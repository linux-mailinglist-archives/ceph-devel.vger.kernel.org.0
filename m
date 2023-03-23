Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7219E6C6026
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjCWG6R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCWG6Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AA9305EA
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Npb0jl875E/SYOJRjBJ/u8Wvo+5RGJOZUvusAZCaJIE=;
        b=UX/kd4m3NfyGd1CwiWyl5VvZf/5rkMcYYrLwoPtmi6+80XsgunLWcU7pG7rbO9CNvYxeqy
        N5wS8tq6JAuI0XD0ePMnfVIgfWcgC0Hfkf6tnIOgrv2s4pedhYkoB/HzylZtPTMwTWAQB0
        guceCC3JSlL0VNFDbMcDZottrfln3ms=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457--eAWe1WjOWCx4STa_8jdag-1; Thu, 23 Mar 2023 02:57:05 -0400
X-MC-Unique: -eAWe1WjOWCx4STa_8jdag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F6D38028B2;
        Thu, 23 Mar 2023 06:57:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93C74492B01;
        Thu, 23 Mar 2023 06:57:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 25/71] ceph: make d_revalidate call fscrypt revalidator for encrypted dentries
Date:   Thu, 23 Mar 2023 14:54:39 +0800
Message-Id: <20230323065525.201322-26-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
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

From: Jeff Layton <jlayton@kernel.org>

If we have a dentry which represents a no-key name, then we need to test
whether the parent directory's encryption key has since been added.  Do
that before we test anything else about the dentry.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index f5e04f63c8e6..ffdeccb699ae 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1770,6 +1770,10 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 	struct inode *dir, *inode;
 	struct ceph_mds_client *mdsc;
 
+	valid = fscrypt_d_revalidate(dentry, flags);
+	if (valid <= 0)
+		return valid;
+
 	if (flags & LOOKUP_RCU) {
 		parent = READ_ONCE(dentry->d_parent);
 		dir = d_inode_rcu(parent);
@@ -1782,8 +1786,8 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 		inode = d_inode(dentry);
 	}
 
-	dout("d_revalidate %p '%pd' inode %p offset 0x%llx\n", dentry,
-	     dentry, inode, ceph_dentry(dentry)->offset);
+	dout("d_revalidate %p '%pd' inode %p offset 0x%llx nokey %d\n", dentry,
+	     dentry, inode, ceph_dentry(dentry)->offset, !!(dentry->d_flags & DCACHE_NOKEY_NAME));
 
 	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
 
-- 
2.31.1

