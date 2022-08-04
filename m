Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59A5898F9
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Aug 2022 10:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239384AbiHDIGj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Aug 2022 04:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236184AbiHDIGi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Aug 2022 04:06:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 611F161DA4
        for <ceph-devel@vger.kernel.org>; Thu,  4 Aug 2022 01:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659600396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0W0uAYExuspsrPYM8yaIBF6HBQxml3+RQpZ2HFbwea4=;
        b=Pd7dt0U31JMszAEMmqVn/ZYzWdma4133/T3roAjyfA87HbRdREiNrbWif+sOGFOrJsK7Ml
        s6G67ik2kfWt4VgyI86xR/3hlwbVkGbS3ObT9uFwejxGQENHNqqQlKmNj1/ljUpdEzNSvC
        0bXW3MSjMlXzniW1oq6XVHk8kKN544o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-SIuThlu4NoW-a9aLU5Tbqw-1; Thu, 04 Aug 2022 04:06:32 -0400
X-MC-Unique: SIuThlu4NoW-a9aLU5Tbqw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFDB41824622
        for <ceph-devel@vger.kernel.org>; Thu,  4 Aug 2022 08:06:31 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80D401121325;
        Thu,  4 Aug 2022 08:06:30 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fail the open_by_handle_at() if the dentry is being unlinked
Date:   Thu,  4 Aug 2022 16:06:24 +0800
Message-Id: <20220804080624.14768-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 fs/ceph/export.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 0ebf2bd93055..7d2ae977b8c9 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -182,6 +182,7 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
 static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 {
 	struct inode *inode = __lookup_inode(sb, ino);
+	struct dentry *dentry;
 	int err;
 
 	if (IS_ERR(inode))
@@ -197,7 +198,15 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
-	return d_obtain_alias(inode);
+
+	/* -ESTALE if the dentry is unhashed, which should being released */
+	dentry = d_obtain_alias(inode);
+	if (d_unhashed(dentry)) {
+		dput(dentry);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return dentry;
 }
 
 static struct dentry *__snapfh_to_dentry(struct super_block *sb,
-- 
2.36.0.rc1

