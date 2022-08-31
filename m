Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0D95A73D1
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Aug 2022 04:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiHaCQm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Aug 2022 22:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbiHaCQl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Aug 2022 22:16:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E54585F92
        for <ceph-devel@vger.kernel.org>; Tue, 30 Aug 2022 19:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661912198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yigujtqRGYmmPrJlg5QtEmwhx8BDnkQmcTVpfFCJghA=;
        b=TDWDolFlA0PyIbea2ybovodMe+Qoh5mc3SdxYJmeHwp1n6b5l4nh70bunA4Kkxh3T7MHoy
        jAlv5eRMI3GB8eAipMJWFWoQQtDH0XpKkl5T1p4ivHn6RUT0sWbqpVSsaAS0ADoD4TPTqs
        hut0a33guWPD6yzyR1Ym1SM2FE59MAU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-A7gV4z97NSarYZooEfowfQ-1; Tue, 30 Aug 2022 22:16:35 -0400
X-MC-Unique: A7gV4z97NSarYZooEfowfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2663D805B72;
        Wed, 31 Aug 2022 02:16:35 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 919AF400E88E;
        Wed, 31 Aug 2022 02:16:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: fail the open_by_handle_at() if the dentry is being unlinked
Date:   Wed, 31 Aug 2022 10:16:17 +0800
Message-Id: <20220831021617.11058-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

When unlinking a file the kclient will send a unlink request to MDS
by holding the dentry reference, and then the MDS will return 2 replies,
which are unsafe reply and a deferred safe reply.

After the unsafe reply received the kernel will return and succeed
the unlink request to user space apps.

Only when the safe reply received the dentry's reference will be
released. Or the dentry will only be unhashed from dcache. But when
the open_by_handle_at() begins to open the unlinked files it will
succeed.

The inode->i_count couldn't be used to check whether the inode is
opened or not.

URL: https://tracker.ceph.com/issues/56524
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- The inode->i_count couldn't be correctly indicate that whether the
  file is opened or not.

V2:
- If the dentry was released and inode is evicted such as by dropping
  the caches, it will allocate a new dentry, which is also unhashed.

 fs/ceph/export.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 0ebf2bd93055..8559990a59a5 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
 static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 {
 	struct inode *inode = __lookup_inode(sb, ino);
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	int err;
 
 	if (IS_ERR(inode))
@@ -193,7 +194,7 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 		return ERR_PTR(err);
 	}
 	/* -ESTALE if inode as been unlinked and no file is open */
-	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
+	if ((inode->i_nlink == 0) && !__ceph_is_file_opened(ci)) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
-- 
2.36.0.rc1

