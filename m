Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AE55A9AE6
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Sep 2022 16:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiIAOxN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Sep 2022 10:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiIAOxM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Sep 2022 10:53:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981FB80EBB
        for <ceph-devel@vger.kernel.org>; Thu,  1 Sep 2022 07:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662043990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K//pdOvGz0jhsD7uQYp9+3/3bbo9Y7Sq5vyFy3GhASc=;
        b=LpMFQXMQjC+SfMpp4bqun9t9Hhsh3OYTSC9pOfNDjfs9KQJxEfxVR9izvAdOc1c71pwu/w
        6Yc1X5kLhiu5cSbY40KMk/5nkxNp4T11evZ7CONkENbCMBaUjIOBJh7FmTzsiJdx5e7VDJ
        VRcxeUe/kyGFvm6s47HHSjpOG4wTfJY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-x6VdFx3pMaSUqjKmEZjTZQ-1; Thu, 01 Sep 2022 10:53:07 -0400
X-MC-Unique: x6VdFx3pMaSUqjKmEZjTZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C49CC101E985;
        Thu,  1 Sep 2022 14:53:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D12BC2026D4C;
        Thu,  1 Sep 2022 14:53:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        rraja@redhat.com, mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: force sending open request to MDS for root user
Date:   Thu,  1 Sep 2022 22:52:37 +0800
Message-Id: <20220901145237.267010-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

With the root_squash MDS caps enabled and for a root user it should
fail to write the file. But currently the kclient will just skip
sending a open request and check the cap instead even with the root
user. This will skip checking the MDS caps in MDS server.

URL: https://tracker.ceph.com/issues/56067
URL: https://tracker.ceph.com/issues/57154
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 86265713a743..642c0facbdcd 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -360,6 +360,7 @@ int ceph_open(struct inode *inode, struct file *file)
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
 	struct ceph_file_info *fi = file->private_data;
+	uid_t uid = from_kuid(&init_user_ns, get_current_cred()->fsuid);
 	int err;
 	int flags, fmode, wanted;
 
@@ -393,13 +394,19 @@ int ceph_open(struct inode *inode, struct file *file)
 	}
 
 	/*
-	 * No need to block if we have caps on the auth MDS (for
-	 * write) or any MDS (for read).  Update wanted set
-	 * asynchronously.
+	 * If the caller is root user and the Fw caps is required
+	 * it will force sending a open request to MDS to let
+	 * the MDS do the root_squash MDS caps check.
+	 *
+	 * Otherwise no need to block if we have caps on the auth
+	 * MDS (for write) or any MDS (for read). Update wanted
+	 * set asynchronously.
 	 */
 	spin_lock(&ci->i_ceph_lock);
-	if (__ceph_is_any_real_caps(ci) &&
-	    (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap)) {
+	if (((fmode & CEPH_FILE_MODE_WR) && uid != 0) &&
+	    (__ceph_is_any_real_caps(ci) &&
+	     (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap))) {
+
 		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
 		int issued = __ceph_caps_issued(ci, NULL);
 
-- 
2.36.0.rc1

