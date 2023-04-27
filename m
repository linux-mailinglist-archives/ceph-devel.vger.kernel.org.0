Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE106F0190
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Apr 2023 09:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbjD0HWI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Apr 2023 03:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjD0HVz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Apr 2023 03:21:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96BD04C11
        for <ceph-devel@vger.kernel.org>; Thu, 27 Apr 2023 00:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682579967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pxByNbyYmigbMvHkeeP50vSiQrdPc2d2oR8XdIluuEU=;
        b=GK3KY/ODL7iFcGEzima0Lz3Fs73UKXM0Zg3KiXnRCuydwOl56fVq/bcZQqzhFwyhGJ0EF4
        oXB3hsROUp3Xk8qErzunldr9KldJANvOnHiWVFmYmOjrFpIwaQYb5o9opDLjDP3gJwLzZu
        0mbeohubjj8OIMvVLau6pKJKWqO7NPg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-K1X4Yvz2MIS_gqlyKwuUZg-1; Thu, 27 Apr 2023 03:19:23 -0400
X-MC-Unique: K1X4Yvz2MIS_gqlyKwuUZg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 660B485A5A3;
        Thu, 27 Apr 2023 07:19:23 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-41.pek2.redhat.com [10.72.12.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05207492B03;
        Thu, 27 Apr 2023 07:19:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, frans@dtu.dk, gfarnum@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: pass the ino# instead if the old_dentry is DCACHE_DISCONNECTED
Date:   Thu, 27 Apr 2023 15:19:06 +0800
Message-Id: <20230427071906.59037-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When exporting the kceph to NFS it may pass a DCACHE_DISCONNECTED
dentry for the link operation. Then it will parse this dentry as a
snapdir, and the mds will fail the link request as -EROFS.

MDS allow clients to pass a ino# instead of a path.

URL: https://tracker.ceph.com/issues/59515
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c        | 13 +++++++++++--
 fs/ceph/mds_client.c |  5 ++++-
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index c28de23e12a1..09bbd0ffbf4f 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1140,6 +1140,9 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	struct ceph_mds_request *req;
 	int err;
 
+	if (dentry->d_flags & DCACHE_DISCONNECTED)
+		return -EINVAL;
+
 	err = ceph_wait_on_conflict_unlink(dentry);
 	if (err)
 		return err;
@@ -1151,8 +1154,8 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	if (err)
 		return err;
 
-	dout("link in dir %p old_dentry %p dentry %p\n", dir,
-	     old_dentry, dentry);
+	dout("link in dir %p %llx.%llx old_dentry %p:'%pd' dentry %p:'%pd'\n",
+	     dir, ceph_vinop(dir), old_dentry, old_dentry, dentry, dentry);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LINK, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
 		d_drop(dentry);
@@ -1161,6 +1164,12 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_old_dentry = dget(old_dentry);
+	/*
+	 * The old_dentry maybe a DCACHE_DISCONNECTED dentry, then we
+	 * will just pass the ino# to MDSs.
+	 */
+	if (old_dentry->d_flags & DCACHE_DISCONNECTED)
+		req->r_ino2 = ceph_vino(d_inode(old_dentry));
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 70bbd344e3d9..35eb0ce141ba 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2875,6 +2875,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	u64 ino1 = 0, ino2 = 0;
 	int pathlen1 = 0, pathlen2 = 0;
 	bool freepath1 = false, freepath2 = false;
+	struct dentry *r_old_dentry = NULL;
 	int len;
 	u16 releases;
 	void *p, *end;
@@ -2892,7 +2893,9 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	}
 
 	/* If r_old_dentry is set, then assume that its parent is locked */
-	ret = set_request_path_attr(NULL, req->r_old_dentry,
+	if (req->r_old_dentry && !(req->r_old_dentry->d_flags & DCACHE_DISCONNECTED))
+		r_old_dentry = req->r_old_dentry;
+	ret = set_request_path_attr(NULL, r_old_dentry,
 			      req->r_old_dentry_dir,
 			      req->r_path2, req->r_ino2.ino,
 			      &path2, &pathlen2, &ino2, &freepath2, true);
-- 
2.40.0

