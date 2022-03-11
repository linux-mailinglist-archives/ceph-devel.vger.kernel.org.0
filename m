Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527304D596E
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 05:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345722AbiCKEQ0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 23:16:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiCKEQZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 23:16:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 621BC1A128D
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 20:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646972122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JKYPDvqPLukhBuKtprbeOw+vsUiYYpk7dx/igaoEdd0=;
        b=BLLqbKoe6njfZh06DU1iRa2q6nFhdcT9lh1cKL7gECAJ73fOOMSNCHXKwTwi2Hh5J1GVC5
        x5PF0PHtO1TvdToQEBagUN87u2OrVluXcUCDjvFM9XmUaSK8OGeeQkyZXBs4Jd2pYBxQWT
        TdQZfPTG2/7e/uee91+gZEYIlBYIy0E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-rHgG9bzqPQOK0GIeytNTog-1; Thu, 10 Mar 2022 23:15:19 -0500
X-MC-Unique: rHgG9bzqPQOK0GIeytNTog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABA6B51DC;
        Fri, 11 Mar 2022 04:15:17 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A44734CEFB;
        Fri, 11 Mar 2022 04:15:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
Date:   Fri, 11 Mar 2022 12:15:05 +0800
Message-Id: <20220311041505.160241-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The fname->name is based64_encoded names and the max long shouldn't
exceed the NAME_MAX.

The FSCRYPT_BASE64URL_CHARS(NAME_MAX) will be 255 * 4 / 3.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Note:

This patch is bansed on the wip-fscrpt branch in ceph-client repo.


 fs/ceph/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 5a87e7385d3f..560481b6c964 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -205,7 +205,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 	}
 
 	/* Sanity check that the resulting name will fit in the buffer */
-	if (fname->name_len > FSCRYPT_BASE64URL_CHARS(NAME_MAX))
+	if (fname->name_len > NAME_MAX || fname->ctext_len > NAME_MAX)
 		return -EIO;
 
 	ret = __fscrypt_prepare_readdir(fname->dir);
-- 
2.27.0

