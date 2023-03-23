Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB1A6C6057
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjCWHB7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjCWHBk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:01:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FFC22DC7
        for <ceph-devel@vger.kernel.org>; Thu, 23 Mar 2023 00:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opQRUmOsBPc96enzB+QnTmCAkuwuNDIlk2PuuTcUk1I=;
        b=bkrVFSUYOEAiFWk0o4O9kJ/HefXM6XyifJCly7ZFlWxWzV6jBvhcKbm+DZWG50MFpwvlL9
        0z35T/nvfpQM1qDpB/XtXXlRfF+VmGUNkxo9VBZmSK9H33cTU/kKoAZaFT7KR/Gjd56eZG
        4MXCL+71IBdqlAS5W8+c2ujgxFKYffQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-VnAGfj76MTiLb9M2HDeWdw-1; Thu, 23 Mar 2023 02:59:41 -0400
X-MC-Unique: VnAGfj76MTiLb9M2HDeWdw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 112BC101A54F;
        Thu, 23 Mar 2023 06:59:41 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44C0F492B01;
        Thu, 23 Mar 2023 06:59:37 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 70/71] ceph: switch ceph_open() to use new fscrypt helper
Date:   Thu, 23 Mar 2023 14:55:24 +0800
Message-Id: <20230323065525.201322-71-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

Instead of setting the no-key dentry in ceph_lookup(), use the new
fscrypt_prepare_lookup_partial() helper.  We still need to mark the
directory as incomplete if the directory was just unlocked.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/dir.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index fe48a5d26c1d..c28de23e12a1 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -784,14 +784,15 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 		return ERR_PTR(-ENAMETOOLONG);
 
 	if (IS_ENCRYPTED(dir)) {
-		err = ceph_fscrypt_prepare_readdir(dir);
+		bool had_key = fscrypt_has_encryption_key(dir);
+
+		err = fscrypt_prepare_lookup_partial(dir, dentry);
 		if (err < 0)
 			return ERR_PTR(err);
-		if (!fscrypt_has_encryption_key(dir)) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags |= DCACHE_NOKEY_NAME;
-			spin_unlock(&dentry->d_lock);
-		}
+
+		/* mark directory as incomplete if it has been unlocked */
+		if (!had_key && fscrypt_has_encryption_key(dir))
+			ceph_dir_clear_complete(dir);
 	}
 
 	/* can we conclude ENOENT locally? */
-- 
2.31.1

