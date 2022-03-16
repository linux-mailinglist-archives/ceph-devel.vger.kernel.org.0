Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3D14DA913
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Mar 2022 04:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353507AbiCPDw1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 23:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353087AbiCPDw0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 23:52:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04AFF5F8FC
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 20:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647402671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=PCPZOLL1XemIY2tqYesA+tZnsM+MUK30YtaZzNEEFYY=;
        b=IwVQ7TTailGrEN7dq/TifEfEB0hmvd1ZOT/xnJKUR5HM5//HuSVhUE5u4ONvAKlfAp4Tuf
        /sgcMoQ/N7eWKujKGSYhE5q7jVSrmBMjfJp5PlFygHIZd22AWLH0sOrrhc0r19z/WsD2jD
        6BN+fWxxwakb4oCc/c2l3EaHGWN2qLk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-UEI9gwzINju3MuulBJTSXA-1; Tue, 15 Mar 2022 23:51:06 -0400
X-MC-Unique: UEI9gwzINju3MuulBJTSXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4083C80159B;
        Wed, 16 Mar 2022 03:51:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD2762023A1E;
        Wed, 16 Mar 2022 03:51:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix the buf size and use NAME_SIZE instead
Date:   Wed, 16 Mar 2022 11:51:00 +0800
Message-Id: <20220316035100.68406-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Since the base64_encrypted file name shouldn't exceed the NAME_SIZE,
no need to allocate a buffer from the stack that long.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Jeff, you can just squash this into the previous commit.


 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c51b07ec72cf..cd0c780a6f84 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2579,7 +2579,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 			parent = dget_parent(cur);
 		} else {
 			int len, ret;
-			char buf[FSCRYPT_BASE64URL_CHARS(NAME_MAX)];
+			char buf[NAME_MAX];
 
 			/*
 			 * Proactively copy name into buf, in case we need to present
-- 
2.27.0

