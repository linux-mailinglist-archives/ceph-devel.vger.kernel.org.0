Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42C16C6029
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjCWG6d (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjCWG62 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:58:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93562FCD3
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBzvCEnP9wxCptLfZWyiIPKKst+VHzLkImpIzvWfiRo=;
        b=hOWLRs6zxTf8T9c8wB/14TVLqiBlRN4xEnOXPn4M6VL2cltsTQybpDNV5f6h3rriM/iSbd
        J3wnJr2V9XU+HJZ9v4gCMJ4Or6Bt8H8a+cVNyTsbvWhZfGYnGskpx7FvFloKENY+iVa1/r
        hPYoF7BomszMbZo2mae9WKwdHYTAEbU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-Zh8UCNaXPZOz9QikbvZw1g-1; Thu, 23 Mar 2023 02:57:12 -0400
X-MC-Unique: Zh8UCNaXPZOz9QikbvZw1g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D8E62823811;
        Thu, 23 Mar 2023 06:57:12 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60F5F492B01;
        Thu, 23 Mar 2023 06:57:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 27/71] ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
Date:   Thu, 23 Mar 2023 14:54:41 +0800
Message-Id: <20230323065525.201322-28-xiubli@redhat.com>
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

From: Xiubo Li <xiubli@redhat.com>

The fname->name is based64_encoded names and the max long shouldn't
exceed the NAME_MAX.

The FSCRYPT_BASE64URL_CHARS(NAME_MAX) will be 255 * 4 / 3.

[ xiubli: s/FSCRYPT_BASE64URL_CHARS/CEPH_BASE64_CHARS/ reported by
  kernel test robot <lkp@intel.com> ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 03f4b9e73884..2222f4968f74 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -264,7 +264,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	}
 
 	/* Sanity check that the resulting name will fit in the buffer */
-	if (fname->name_len > CEPH_BASE64_CHARS(NAME_MAX))
+	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
 		return -EIO;
 
 	ret = __fscrypt_prepare_readdir(fname->dir);
-- 
2.31.1

