Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4836E3E48
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbjDQDgk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjDQDgR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AECE4C21
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yu7gf8xWcAldAFS01M0YAQCprE2DqFfADWe3S2lo3P0=;
        b=ULxR+McPay5UuVIoXNkjJeq2qegwOA0Yz/87P31ZyksPvCMLPVwTiAQDfba84jiuLjtal+
        m3VsPDHVAfW4HVtA+OHSR6IqBBl6mua/lSVfC6hRM4CGrqIfn8P/7TibpgyePqH0qLMp4b
        wlx2TZY+vZi6w6ALxJBAVeAIb0GxYfY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-536-5AOGCXkMPJKTiLMmbgT0tg-1; Sun, 16 Apr 2023 23:33:14 -0400
X-MC-Unique: 5AOGCXkMPJKTiLMmbgT0tg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A6FE2857FB3;
        Mon, 17 Apr 2023 03:33:13 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB3C8202717C;
        Mon, 17 Apr 2023 03:33:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 70/70] ceph: switch ceph_open_atomic() to use the new fscrypt helper
Date:   Mon, 17 Apr 2023 11:26:54 +0800
Message-Id: <20230417032654.32352-71-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
2.39.1

