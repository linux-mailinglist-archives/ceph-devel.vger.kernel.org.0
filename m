Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333AC7B1050
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Sep 2023 03:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjI1BUS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Sep 2023 21:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjI1BUR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Sep 2023 21:20:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74D2F5
        for <ceph-devel@vger.kernel.org>; Wed, 27 Sep 2023 18:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695863972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Yn5ZBwTq2w9PCzKya40PTSFhNJGcj2fDSKjLFpvNkoc=;
        b=BzxGdkOC+9rENgQSoq6TvZdCG0PXlvdIMzvROW+oU2BDcGkZ9MkjRpr2DeabVhnfh9MlgX
        fPUJxohRPTHksbVODBY6VBrd7PF3tgKinBKIlvJlQbjm0dii+DZ3+0IeJaYtk1JUHcAjKg
        WCvy5Nrad4VHbVAQR/oZcnKcr11zWdE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-QQTX2l1yPFyb95HJx3AdDg-1; Wed, 27 Sep 2023 21:19:28 -0400
X-MC-Unique: QQTX2l1yPFyb95HJx3AdDg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 445B03801FF7;
        Thu, 28 Sep 2023 01:19:28 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7549740C2064;
        Thu, 28 Sep 2023 01:19:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: trigger to flush dirty caps when trimming caps
Date:   Thu, 28 Sep 2023 09:16:57 +0800
Message-ID: <20230928011657.220849-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The MDS side may time out waiting the caps to be released, so we
need to trigger to flush the dirty caps as soon as possible.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       |  9 +++++++--
 fs/ceph/mds_client.c | 14 +++++++++-----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a36366df7773..93953ae07398 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2035,6 +2035,10 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 	struct ceph_mds_session *session = NULL;
 
 	spin_lock(&ci->i_ceph_lock);
+
+	/* Cancel the delay caps checking */
+	__cap_delay_cancel(mdsc, ci);
+
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
 		ci->i_ceph_flags |= CEPH_I_ASYNC_CHECK_CAPS;
 
@@ -4644,8 +4648,6 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 			if (time_before(jiffies, ci->i_hold_caps_max))
 				break;
 		}
-		list_del_init(&ci->i_cap_delay_list);
-
 		inode = igrab(&ci->netfs.inode);
 		if (inode) {
 			spin_unlock(&mdsc->cap_delay_lock);
@@ -4654,7 +4656,10 @@ unsigned long ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 			ceph_check_caps(ci, 0);
 			iput(inode);
 			spin_lock(&mdsc->cap_delay_lock);
+		} else {
+			list_del_init(&ci->i_cap_delay_list);
 		}
+
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
 	doutc(cl, "done\n");
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a7bffb030036..7896bf27a3cf 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2160,6 +2160,7 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int used, wanted, oissued, mine;
 	struct ceph_cap *cap;
+	bool check_cap = false;
 
 	if (*remaining <= 0)
 		return -1;
@@ -2180,9 +2181,6 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 	      ceph_cap_string(oissued), ceph_cap_string(used),
 	      ceph_cap_string(wanted));
 	if (cap == ci->i_auth_cap) {
-		if (ci->i_dirty_caps || ci->i_flushing_caps ||
-		    !list_empty(&ci->i_cap_snaps))
-			goto out;
 		if ((used | wanted) & CEPH_CAP_ANY_WR)
 			goto out;
 		/* Note: it's possible that i_filelock_ref becomes non-zero
@@ -2190,6 +2188,8 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 		 * of lock mds request will re-add auth caps. */
 		if (atomic_read(&ci->i_filelock_ref) > 0)
 			goto out;
+		if (ci->i_dirty_caps || !list_empty(&ci->i_cap_snaps))
+			check_cap = true;
 	}
 	/* The inode has cached pages, but it's no longer used.
 	 * we can safely drop it */
@@ -2202,7 +2202,7 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 	if ((used | wanted) & ~oissued & mine)
 		goto out;   /* we need these caps */
 
-	if (oissued) {
+	if (oissued && cap != ci->i_auth_cap) {
 		/* we aren't the only cap.. just remove us */
 		ceph_remove_cap(mdsc, cap, true);
 		(*remaining)--;
@@ -2223,11 +2223,15 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 		} else {
 			dput(dentry);
 		}
-		return 0;
+		goto unlocked;
 	}
 
 out:
 	spin_unlock(&ci->i_ceph_lock);
+
+unlocked:
+	if (check_cap)
+		ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 	return 0;
 }
 
-- 
2.39.1

