Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593BD72D95C
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240372AbjFMFgP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240289AbjFMFfu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:35:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851031739
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NYWkrEkNSS28DMxHB+Ho6c82EjRBDukSV1E7V4gZRTI=;
        b=eFHuMCIwEP4F+lvxO229dRgmUwJrynITDgb7yObvxAw/sya9iQFcSEnbSGU/f4KaqsgjCX
        sJmQZcib+ycvs9pYvuszVwgL8/Ce6woo9MrODjk1WMwzP4gPvuwmM89HM7oZFG1IuXnxa9
        3FsJ0fOqBzZMUplv3PcA8XoesfQokDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-Fbm4KUK5MTas21Y3ZQGYuw-1; Tue, 13 Jun 2023 01:31:53 -0400
X-MC-Unique: Fbm4KUK5MTas21Y3ZQGYuw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AA43803DC2;
        Tue, 13 Jun 2023 05:31:53 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C54B81121314;
        Tue, 13 Jun 2023 05:31:49 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 71/71] ceph: switch ceph_open_atomic() to use the new fscrypt helper
Date:   Tue, 13 Jun 2023 13:24:24 +0800
Message-Id: <20230613052424.254540-72-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

Switch ceph_atomic_open() to use new fscrypt helper function
fscrypt_prepare_lookup_partial().  This fixes a bug in the atomic open
operation where a dentry is incorrectly set with DCACHE_NOKEY_NAME when
'dir' has been evicted but the key is still available (for example, where
there's a drop_caches).

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Milind Changire <mchangir@redhat.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/file.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 317087ea017e..9e74ed673f93 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -791,11 +791,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-		if (!fscrypt_has_encryption_key(dir)) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags |= DCACHE_NOKEY_NAME;
-			spin_unlock(&dentry->d_lock);
-		}
+		err = fscrypt_prepare_lookup_partial(dir, dentry);
+		if (err < 0)
+			goto out_req;
 	}
 
 	if (flags & O_CREAT) {
-- 
2.40.1

