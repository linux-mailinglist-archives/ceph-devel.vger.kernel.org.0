Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81CA55AA557
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Sep 2022 03:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiIBBzt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Sep 2022 21:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiIBBzs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 1 Sep 2022 21:55:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6376C10C
        for <ceph-devel@vger.kernel.org>; Thu,  1 Sep 2022 18:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662083746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9VSbocV0ObqiwbP8CHpHn6N+YRK0NSLfdFwiXVyKoto=;
        b=RvyL2Es/G655bPXlOg7wI7n/NQL7AGXy47gyE7COhDGRA6VR4DU3o/cwaWJW0eZemDEjZj
        6tdU0+e9FYQ+W7ksB1aU2GwQD0fRPuNrOlN6FeNzjuGL8X0fxzQFzRWixRRqf9ib7nwjvr
        wQs0nJey3v+8M5JeVh+vVa8/sslwySo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-G5ETFGavO1uVCYiXpJnjWA-1; Thu, 01 Sep 2022 21:55:44 -0400
X-MC-Unique: G5ETFGavO1uVCYiXpJnjWA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A0403C0E22D;
        Fri,  2 Sep 2022 01:55:43 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96BBE492CA2;
        Fri,  2 Sep 2022 01:55:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        rraja@redhat.com, mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: force sending open requests to MDS for root user for root_squash
Date:   Fri,  2 Sep 2022 09:55:35 +0800
Message-Id: <20220902015535.305294-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
sending a open request and check_caps() instead even with the root
user. This will skip checking the MDS caps in MDS server.

We should force sending a open request to MDS for root user if the
cephx is enabled.

URL: https://tracker.ceph.com/issues/56067
URL: https://tracker.ceph.com/issues/57154
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 86265713a743..d51c98412a30 100644
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
+	if (!((fmode & CEPH_FILE_MODE_WR) && !uid) &&
+	    (__ceph_is_any_real_caps(ci) &&
+	     (((fmode & CEPH_FILE_MODE_WR) == 0) || ci->i_auth_cap))) {
+
 		int mds_wanted = __ceph_caps_mds_wanted(ci, true);
 		int issued = __ceph_caps_issued(ci, NULL);
 
-- 
2.36.0.rc1

