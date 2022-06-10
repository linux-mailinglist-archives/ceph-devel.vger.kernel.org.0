Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9F9545B1C
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 06:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbiFJE3J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jun 2022 00:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234813AbiFJE3I (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jun 2022 00:29:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A61C83DA7F
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 21:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654835345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9DrpAo0BYksdVaUdFzXjwp+OaP7emOg/FbzuV3GUrpU=;
        b=YR6ycgoekz/rXm3MxEBFO+L+jzA/Fx+16Nz2nYdrZzKsy5FuAd2I48utrVWaE0mUiXCJvM
        7/XotB9Lstjj41VONQ+iU2w81h3MGAdPfbHK+6zVbd+fycjGibEnTFdNdOb6DNOyIBilzL
        Dc623yWY2b5Q+yeNm4ItC43go25pNfE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-8qVFf2yFPQS2uETXtZ_Dag-1; Fri, 10 Jun 2022 00:29:04 -0400
X-MC-Unique: 8qVFf2yFPQS2uETXtZ_Dag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B2291C04B58;
        Fri, 10 Jun 2022 04:29:04 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71BAF2026D64;
        Fri, 10 Jun 2022 04:29:03 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix incorrect old_size length in ceph_mds_request_args
Date:   Fri, 10 Jun 2022 12:28:54 +0800
Message-Id: <20220610042854.641210-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The 'old_size' is a __le64 type since birth, not sure why the
kclient incorrectly switched it to __le32. This change is okay
won't break anything because union will always allocate more memory
than the 'open' member needed.

Rename 'file_replication' to 'pool' as ceph did. Though this 'open'
struct may never be used in kclient in future, it's confusing when
going through the ceph code.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_fs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 40740e234ce1..49586ff26152 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -433,9 +433,9 @@ union ceph_mds_request_args {
 		__le32 stripe_unit;          /* layout for newly created file */
 		__le32 stripe_count;         /* ... */
 		__le32 object_size;
-		__le32 file_replication;
-               __le32 mask;                 /* CEPH_CAP_* */
-               __le32 old_size;
+		__le32 pool;
+		__le32 mask;                 /* CEPH_CAP_* */
+		__le64 old_size;
 	} __attribute__ ((packed)) open;
 	struct {
 		__le32 flags;
-- 
2.36.0.rc1

