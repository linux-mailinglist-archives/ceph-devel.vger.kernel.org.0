Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3387D3BB4A2
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 03:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhGEBZv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jul 2021 21:25:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229818AbhGEBZv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jul 2021 21:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625448195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X1SujpTrfv65sbiVl1ncQwAtLPRsEEfrTinGF5zhOMY=;
        b=FIJ6CLWjUTWzMYLI7ugk0OcY1swYhO3OVN/lSwRy76HuZRlX/sbK4H7ga+bzMx8KG4CMWd
        bOwpLdmyF7ZkNA5YiouTVretqPbzZ8kS4FRiflF6Z3TyJpgTsb/ElJ+a7qsQzwTaBM78fO
        fXMMxE5/6/SNE/kMP4d0NXO27dqaBp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-TJCwex-VOSG8-8X6PyAw9A-1; Sun, 04 Jul 2021 21:23:13 -0400
X-MC-Unique: TJCwex-VOSG8-8X6PyAw9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C1B35802921;
        Mon,  5 Jul 2021 01:23:11 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2B0060875;
        Mon,  5 Jul 2021 01:23:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 4/4] ceph: flush the mdlog before waiting on unsafe reqs
Date:   Mon,  5 Jul 2021 09:22:57 +0800
Message-Id: <20210705012257.182669-5-xiubli@redhat.com>
In-Reply-To: <20210705012257.182669-1-xiubli@redhat.com>
References: <20210705012257.182669-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the client requests who will have unsafe and safe replies from
MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
(journal log) immediatelly, because they think it's unnecessary.
That's true for most cases but not all, likes the fsync request.
The fsync will wait until all the unsafe replied requests to be
safely replied.

Normally if there have multiple threads or clients are running, the
whole mdlog in MDS daemons could be flushed in time if any request
will trigger the mdlog submit thread. So usually we won't experience
the normal operations will stuck for a long time. But in case there
has only one client with only thread is running, the stuck phenomenon
maybe obvious and the worst case it must wait at most 5 seconds to
wait the mdlog to be flushed by the MDS's tick thread periodically.

This patch will trigger to flush the mdlog in the relevant and auth
MDSes to which the in-flight requests are sent just before waiting
the unsafe requests to finish.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c6a3352a4d52..4b966c29d9b5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2286,6 +2286,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
  */
 static int unsafe_request_wait(struct inode *inode)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
 	int ret, err = 0;
@@ -2305,6 +2306,82 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
+	/*
+	 * Trigger to flush the journal logs in all the relevant MDSes
+	 * manually, or in the worst case we must wait at most 5 seconds
+	 * to wait the journal logs to be flushed by the MDSes periodically.
+	 */
+	if (req1 || req2) {
+		struct ceph_mds_session **sessions = NULL;
+		struct ceph_mds_session *s;
+		struct ceph_mds_request *req;
+		unsigned int max;
+		int i;
+
+		/*
+		 * The mdsc->max_sessions is unlikely to be changed
+		 * mostly, here we will retry it by reallocating the
+		 * sessions arrary memory to get rid of the mdsc->mutex
+		 * lock.
+		 */
+retry:
+		max = mdsc->max_sessions;
+		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
+		if (!sessions) {
+			err = -ENOMEM;
+			goto out;
+		}
+		spin_lock(&ci->i_unsafe_lock);
+		if (req1) {
+			list_for_each_entry(req, &ci->i_unsafe_dirops,
+					    r_unsafe_dir_item) {
+				s = req->r_session;
+				if (unlikely(s->s_mds > max)) {
+					spin_unlock(&ci->i_unsafe_lock);
+					goto retry;
+				}
+				if (!sessions[s->s_mds]) {
+					s = ceph_get_mds_session(s);
+					sessions[s->s_mds] = s;
+				}
+			}
+		}
+		if (req2) {
+			list_for_each_entry(req, &ci->i_unsafe_iops,
+					    r_unsafe_target_item) {
+				s = req->r_session;
+				if (unlikely(s->s_mds > max)) {
+					spin_unlock(&ci->i_unsafe_lock);
+					goto retry;
+				}
+				if (!sessions[s->s_mds]) {
+					s = ceph_get_mds_session(s);
+					sessions[s->s_mds] = s;
+				}
+			}
+		}
+		spin_unlock(&ci->i_unsafe_lock);
+
+		/* the auth MDS */
+		spin_lock(&ci->i_ceph_lock);
+		if (ci->i_auth_cap) {
+		      s = ci->i_auth_cap->session;
+		      if (!sessions[s->s_mds])
+			      sessions[s->s_mds] = ceph_get_mds_session(s);
+		}
+		spin_unlock(&ci->i_ceph_lock);
+
+		/* send flush mdlog request to MDSes */
+		for (i = 0; i < max; i++) {
+			s = sessions[i];
+			if (s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(s);
+			}
+		}
+		kfree(sessions);
+	}
+
 	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
 	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
 	if (req1) {
@@ -2321,6 +2398,7 @@ static int unsafe_request_wait(struct inode *inode)
 			err = -EIO;
 		ceph_mdsc_put_request(req2);
 	}
+out:
 	return err;
 }
 
-- 
2.27.0

