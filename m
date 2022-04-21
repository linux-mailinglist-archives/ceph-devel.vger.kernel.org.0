Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A515095C3
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 06:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384086AbiDUEX3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 00:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384082AbiDUEX2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 00:23:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB95C11A29
        for <ceph-devel@vger.kernel.org>; Wed, 20 Apr 2022 21:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650514838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a8An7gdAXJ2BGWfKwe9DC8jxJ9gJl9YiE5dBr2bE7/g=;
        b=dwt+n1wPC/Fpd2N2Cpk+/zJVKdXHoehVBdC5RDsUL6G7+aWxqK9Ly9nKvXm59tfGhz9UW7
        NrmvElgcC/UFj/p/CLW9fBWvVqOzTCHuqSsBg3gqLiuprvVJuN9bjdSf8FfDFT9QYBKf4f
        8f3tltLztdiot6ZsJnfFrOk2LI6hi2w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-0ceBVEefP9-OlQvL7MFt-Q-1; Thu, 21 Apr 2022 00:20:35 -0400
X-MC-Unique: 0ceBVEefP9-OlQvL7MFt-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00EF4811E76;
        Thu, 21 Apr 2022 04:20:35 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55A6340D0166;
        Thu, 21 Apr 2022 04:20:34 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: try to choose the auth MDS if possible for getattr
Date:   Thu, 21 Apr 2022 12:20:28 +0800
Message-Id: <20220421042028.92787-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If any 'x' caps is issued we can just choose the auth MDS instead
of the random replica MDSes. Because only when the Locker is in
LOCK_EXEC state will the loner client could get the 'x' caps. And
if we send the getattr requests to any replica MDS it must auth pin
and tries to rdlock from the auth MDS, and then the auth MDS need
to do the Locker state transition to LOCK_SYNC. And after that the
lock state will change back.

This cost much when doing the Locker state transition and usually
will need to revoke caps from clients.

URL: https://tracker.ceph.com/issues/55240
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b45f321910af..2a5023b1272d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2270,6 +2270,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
+	int issued = ceph_caps_issued(ceph_inode(inode));
 	int mode;
 	int err;
 
@@ -2283,7 +2284,24 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
 			return 0;
 
-	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
+	/*
+	 * If any 'x' caps is issued we can just choose the auth MDS
+	 * instead of the random replica MDSes. Because only when the
+	 * Locker is in LOCK_EXEC state will the exclusive client could
+	 * get the 'x' caps. And if we send the getattr requests to any
+	 * replica MDS it must auth pin and tries to rdlock from the auth
+	 * MDS, and then the auth MDS need to do the Locker state transition
+	 * to LOCK_SYNC. And after that the lock state will change back.
+	 *
+	 * This cost much when doing the Locker state transition and
+	 * usually will need to revoke caps from clients.
+	 */
+	if (((mask & CEPH_CAP_ANY_SHARED) && (issued & CEPH_CAP_ANY_EXCL))
+	    || (mask & CEPH_STAT_RSTAT))
+		mode = USE_AUTH_MDS;
+	else
+		mode = USE_ANY_MDS;
+
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
-- 
2.36.0.rc1

