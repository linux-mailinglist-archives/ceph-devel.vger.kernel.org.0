Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DBB3B6DB2
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 06:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhF2Ep2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 00:45:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231564AbhF2Ep0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 00:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624941779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wt+bhXO6Wlj4AsF06BJ9cFSEeZnr00rTlhm6p4Mzo88=;
        b=ADyTNEeL3Y3iGjLVUGY3N2ko6HTbuPQDHYZQomtPL24HQVP9BfmaTJ9GGv0MQB6TrCo3VM
        AGqhydpNvA5jwdUjz51TmT/sPkFOSUDuaftH17D6GSvWyXg6tP6M78YrIs7GoiWjuomcrW
        cP4ALv06na+J/Rvw7C5A2zKRZr7p5lo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-4HUKiAaSMyyOvAX4kfc2vQ-1; Tue, 29 Jun 2021 00:42:57 -0400
X-MC-Unique: 4HUKiAaSMyyOvAX4kfc2vQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78C08804145;
        Tue, 29 Jun 2021 04:42:56 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7801D5D9DC;
        Tue, 29 Jun 2021 04:42:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 4/5] ceph: flush the mdlog before waiting on unsafe reqs
Date:   Tue, 29 Jun 2021 12:42:40 +0800
Message-Id: <20210629044241.30359-5-xiubli@redhat.com>
In-Reply-To: <20210629044241.30359-1-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

This patch will trigger to flush the mdlog in all the MDSes manually
just before waiting the unsafe requests to finish.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c6a3352a4d52..6e80e4649c7a 100644
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
@@ -2305,6 +2306,14 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
+	/*
+	 * Trigger to flush the journal logs in all the MDSes manually,
+	 * or in the worst case we must wait at most 5 seconds to wait
+	 * the journal logs to be flushed by the MDSes periodically.
+	 */
+	if (req1 || req2)
+		flush_mdlog(mdsc);
+
 	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
 	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
 	if (req1) {
-- 
2.27.0

