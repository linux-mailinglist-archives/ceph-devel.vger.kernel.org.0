Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192E26A3996
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjB0DbX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjB0DbW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:31:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE461CADB
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y4hNnQv1vDX3PiBEmggXtgDcdb8dFtK9mXM6WCcL850=;
        b=GQLqw/w68yVj3VSKJEvypZL6x1vqLfXx4rg9md4+5aRu9P17nkTmju0r4sD90lVcvfi25C
        xbk7ocTyZFDKVhuS9wtnG0dN7xoxD/OCtjgg1m2fVi/kdv1pxUEoRVa0nb5jbpOnGFDCsP
        UssA0o6M6aTjFh4/hDArktHerzVK+UM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-cr-Nv4ORMzmv9RWnRKtj2A-1; Sun, 26 Feb 2023 22:29:45 -0500
X-MC-Unique: cr-Nv4ORMzmv9RWnRKtj2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67CC995D605;
        Mon, 27 Feb 2023 03:29:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AD311731B;
        Mon, 27 Feb 2023 03:29:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 24/68] ceph: set DCACHE_NOKEY_NAME in atomic open
Date:   Mon, 27 Feb 2023 11:27:29 +0800
Message-Id: <20230227032813.337906-25-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Atomic open can act as a lookup if handed a dentry that is negative on
the MDS. Ensure that we set DCACHE_NOKEY_NAME on the dentry in
atomic_open, if we don't have the key for the parent. Otherwise, we can
end up validating the dentry inappropriately if someone later adds a
key.

Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0f3f8d873659..05fd27230e05 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -788,6 +788,13 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req->r_args.open.mask = cpu_to_le32(mask);
 	req->r_parent = dir;
 	ihold(dir);
+	if (IS_ENCRYPTED(dir)) {
+		if (!fscrypt_has_encryption_key(dir)) {
+			spin_lock(&dentry->d_lock);
+			dentry->d_flags |= DCACHE_NOKEY_NAME;
+			spin_unlock(&dentry->d_lock);
+		}
+	}
 
 	if (flags & O_CREAT) {
 		struct ceph_file_layout lo;
-- 
2.31.1

