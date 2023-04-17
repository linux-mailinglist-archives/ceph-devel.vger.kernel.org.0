Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1566E3E04
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDQD2t (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjDQD2k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:28:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A5C2716
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7xPKdPqJsV9Tlx49upUFcyJjU+H7GHJVeoQ/EWWQRl0=;
        b=SOvxFF5pOhuIslv/392rYiQQj3G0aZJqHJXIvn2gAuwqZ7qgItZVyhYgVQO3vwWCh+6L01
        WXGl72zRCaz4rpRC4fAeb13BXBXQ/L/JBlHleWt0qf6lrXoRrfQxbZjWamh/lScYa0hRtJ
        AAWPvIYGtSOuYTlEuofDYpnA6TeZv5Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-hk3_Zh2pNVeomXaaKIjk2A-1; Sun, 16 Apr 2023 23:27:55 -0400
X-MC-Unique: hk3_Zh2pNVeomXaaKIjk2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7171F811E7C;
        Mon, 17 Apr 2023 03:27:55 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BCFD2027144;
        Mon, 17 Apr 2023 03:27:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 09/70] ceph: make ceph_msdc_build_path use ref-walk
Date:   Mon, 17 Apr 2023 11:25:53 +0800
Message-Id: <20230417032654.32352-10-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Encryption potentially requires allocation, at which point we'll need to
be in a non-atomic context. Convert ceph_msdc_build_path to take dentry
spinlocks and references instead of using rcu_read_lock to walk the
path.

This is slightly less efficient, and we may want to eventually allow
using RCU when the leaf dentry isn't encrypted.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index dcb25724b693..0aa2c97a0460 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2400,7 +2400,8 @@ static inline  u64 __get_oldest_tid(struct ceph_mds_client *mdsc)
 char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 			   int stop_on_nosnap)
 {
-	struct dentry *temp;
+	struct dentry *cur;
+	struct inode *inode;
 	char *path;
 	int pos;
 	unsigned seq;
@@ -2417,34 +2418,35 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	path[pos] = '\0';
 
 	seq = read_seqbegin(&rename_lock);
-	rcu_read_lock();
-	temp = dentry;
+	cur = dget(dentry);
 	for (;;) {
-		struct inode *inode;
+		struct dentry *temp;
 
-		spin_lock(&temp->d_lock);
-		inode = d_inode(temp);
+		spin_lock(&cur->d_lock);
+		inode = d_inode(cur);
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
-			     pos, temp);
-		} else if (stop_on_nosnap && inode && dentry != temp &&
+			     pos, cur);
+		} else if (stop_on_nosnap && inode && dentry != cur &&
 			   ceph_snap(inode) == CEPH_NOSNAP) {
-			spin_unlock(&temp->d_lock);
+			spin_unlock(&cur->d_lock);
 			pos++; /* get rid of any prepended '/' */
 			break;
 		} else {
-			pos -= temp->d_name.len;
+			pos -= cur->d_name.len;
 			if (pos < 0) {
-				spin_unlock(&temp->d_lock);
+				spin_unlock(&cur->d_lock);
 				break;
 			}
-			memcpy(path + pos, temp->d_name.name, temp->d_name.len);
+			memcpy(path + pos, cur->d_name.name, cur->d_name.len);
 		}
+		temp = cur;
 		spin_unlock(&temp->d_lock);
-		temp = READ_ONCE(temp->d_parent);
+		cur = dget_parent(temp);
+		dput(temp);
 
 		/* Are we at the root? */
-		if (IS_ROOT(temp))
+		if (IS_ROOT(cur))
 			break;
 
 		/* Are we out of buffer? */
@@ -2453,8 +2455,9 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 
 		path[pos] = '/';
 	}
-	base = ceph_ino(d_inode(temp));
-	rcu_read_unlock();
+	inode = d_inode(cur);
+	base = inode ? ceph_ino(inode) : 0;
+	dput(cur);
 
 	if (read_seqretry(&rename_lock, seq))
 		goto retry;
-- 
2.39.1

