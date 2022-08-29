Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A49C5A420F
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Aug 2022 06:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiH2E5l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Aug 2022 00:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiH2E5j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Aug 2022 00:57:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6A043335
        for <ceph-devel@vger.kernel.org>; Sun, 28 Aug 2022 21:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661749058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5aGxMcLzeSY8EL5QMe2HQ97D2m0IIpx4EeW9qf8ESCM=;
        b=cSPaaw+cNmK0+sjAzIbLWGpona24EWQTo/T8OqGK1G5QQlA/kJ/sz2nx2CzPrhKLS9Scp3
        DmpCiL6eUPpgg4ahg9I23aDkQfXgNfh3kp+GIyXEssVTEEAG4dxyC9HDbLbKtS2nlCHFLE
        EXssiycbbZhgLCxSQA0cnGpFxCKdILk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-mBZ0C9DXOTiJdAwP2v3zNQ-1; Mon, 29 Aug 2022 00:57:33 -0400
X-MC-Unique: mBZ0C9DXOTiJdAwP2v3zNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DF0C811E76;
        Mon, 29 Aug 2022 04:57:33 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93A411121314;
        Mon, 29 Aug 2022 04:57:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fail the open_by_handle_at() if the dentry is being unlinked
Date:   Mon, 29 Aug 2022 12:57:28 +0800
Message-Id: <20220829045728.488148-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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

URL: https://tracker.ceph.com/issues/56524
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- If the dentry was released and inode is evicted such as by dropping
  the caches, it will allocate a new dentry, which is also unhashed.


 fs/ceph/export.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 0ebf2bd93055..5edc1d31cd79 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
 static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 {
 	struct inode *inode = __lookup_inode(sb, ino);
+	struct dentry *dentry;
 	int err;
 
 	if (IS_ERR(inode))
@@ -197,7 +198,21 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
-	return d_obtain_alias(inode);
+
+	/*
+	 * -ESTALE if the dentry exists and is unhashed,
+	 * which should be being released
+	 */
+	dentry = d_find_any_alias(inode);
+	if (dentry && unlikely(d_unhashed(dentry))) {
+		dput(dentry);
+		return ERR_PTR(-ESTALE);
+	}
+
+	if (!dentry)
+		dentry = d_obtain_alias(inode);
+
+	return dentry;
 }
 
 static struct dentry *__snapfh_to_dentry(struct super_block *sb,
-- 
2.36.0.rc1

