Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D6C72D95A
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240286AbjFMFgN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240264AbjFMFfi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:35:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4273B2967
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YauLOFSYhZZ3E/xd1SpAvpbpkYL6PW2o9e4/IQ1GUcg=;
        b=g7xQWCGPmtzX1tAElDeiAudLklzpcRm/XhNTD7hgVj6U43Hb3phB/UEN+Fmw2eg5IVivh4
        UkcQPMN1QGZkudYATxVcvp2lfDBEIkKbs1DiexSqHzLzVbzHJe6IrrTzpeR9WeVWILJuVt
        JlrYehaPi0czveOdl9OBp2LPCvUtuRg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-iIMWQ3QQNwuzp8Ivv073PA-1; Tue, 13 Jun 2023 01:31:49 -0400
X-MC-Unique: iIMWQ3QQNwuzp8Ivv073PA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 201E3101AA68;
        Tue, 13 Jun 2023 05:31:49 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E92BA1121314;
        Tue, 13 Jun 2023 05:31:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 70/71] ceph: switch ceph_lookup() to use new fscrypt helper
Date:   Tue, 13 Jun 2023 13:24:23 +0800
Message-Id: <20230613052424.254540-71-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/dir.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index bac2397e0fc9..09bbd0ffbf4f 100644
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
2.40.1

