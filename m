Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF776C605A
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCWHC0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCWHCD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:02:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094D923864
        for <ceph-devel@vger.kernel.org>; Thu, 23 Mar 2023 00:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EGVDNhgBr65e9Dp4iDAKWnXuaCr7HnLrX/sYFW7hhag=;
        b=XhKA7DnUlNZ2bGD/F9fCGGRVULTL+S5e48LO1ZJl+gTpDxsbBguveWprYQSjjlsTHt9SQR
        vR8CgvJS525wi9Rp/d3qcCVhUwYVByBI3gsOtjjxaZGOAzge5O+TeK0mCT4vQZQiQhE1QU
        z4/93n1L65kFNSTcG/Q8KU1bqJGyE9o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-TIekmybhPT29FWSe-k_nqQ-1; Thu, 23 Mar 2023 02:59:45 -0400
X-MC-Unique: TIekmybhPT29FWSe-k_nqQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7562338145A3;
        Thu, 23 Mar 2023 06:59:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7896492B01;
        Thu, 23 Mar 2023 06:59:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 71/71] ceph: switch ceph_open_atomic() to use the new fscrypt helper
Date:   Thu, 23 Mar 2023 14:55:25 +0800
Message-Id: <20230323065525.201322-72-xiubli@redhat.com>
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

Switch ceph_atomic_open() to use new fscrypt helper function
fscrypt_prepare_lookup_partial().  This fixes a bug in the atomic open
operation where a dentry is incorrectly set with DCACHE_NOKEY_NAME when
'dir' has been evicted but the key is still available (for example, where
there's a drop_caches).

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
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
2.31.1

