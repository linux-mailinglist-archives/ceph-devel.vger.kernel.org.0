Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59F6A39BD
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjB0Dez (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjB0Del (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:34:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC39769F
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2lSvCn/T6CI+zrSIg2KistLUI8UgXD4pL+toiCoxT88=;
        b=KtE4iFeodcLqQyTfevyC9uCoMtPh99dV5hqSVLdk2VaSPYp2XcMoHU/5YkAGHgw8wtlVAh
        SmJKl1vc54efCBFR375vKH2srkFtl0Ct2sbWj9Qh2soSEjrjgJHSQ2XuJHP55X3TqqqM0H
        hQCpYDmQh2l6uvnUwlVZ1w7xMpvBtgU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-lDemA9TYPA-kU2lDOr9PLA-1; Sun, 26 Feb 2023 22:32:06 -0500
X-MC-Unique: lDemA9TYPA-kU2lDOr9PLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D0EA830F81;
        Mon, 27 Feb 2023 03:32:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FA4935453;
        Mon, 27 Feb 2023 03:32:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 65/68] ceph: prevent snapshots to be created in encrypted locked directories
Date:   Mon, 27 Feb 2023 11:28:10 +0800
Message-Id: <20230227032813.337906-66-xiubli@redhat.com>
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

From: Luís Henriques <lhenriques@suse.de>

With snapshot names encryption we can not allow snapshots to be created in
locked directories because the names wouldn't be encrypted.  This patch
forces the directory to be unlocked to allow a snapshot to be created.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 64a8df4e373e..d8cc6e9d5351 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1084,6 +1084,11 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 		err = -EDQUOT;
 		goto out;
 	}
+	if ((op == CEPH_MDS_OP_MKSNAP) && IS_ENCRYPTED(dir) &&
+	    !fscrypt_has_encryption_key(dir)) {
+		err = -ENOKEY;
+		goto out;
+	}
 
 
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
-- 
2.31.1

