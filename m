Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A375353E69D
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jun 2022 19:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238549AbiFFNNu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jun 2022 09:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbiFFNNt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Jun 2022 09:13:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D021F19F9A
        for <ceph-devel@vger.kernel.org>; Mon,  6 Jun 2022 06:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654521227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HY6C5Nxz7ryYkr53f+hI5+wAZjYxHh/4qm/WfgsnBmk=;
        b=aAdFVgq+wOVeWUZmM2zt2QuQzNleA2Dc3/JPeX3wSUB48RhetvJ24UePFZgiJStTP9oHjZ
        GtXRLgBEHWB7H/tkPPhr0Bxvnnwk1Drmivsu5OwSCZFsXM2K3n/xX+QXYgH43U0DpmDerz
        MrjgNjYitRarquooQcQPYbTy9ck4AyA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-Perog5f0PpqRB_ni4V53bg-1; Mon, 06 Jun 2022 09:13:44 -0400
X-MC-Unique: Perog5f0PpqRB_ni4V53bg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 34381802812;
        Mon,  6 Jun 2022 13:13:44 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A0DB40EC002;
        Mon,  6 Jun 2022 13:13:43 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fix the incorrect comment for the ceph_mds_caps struct
Date:   Mon,  6 Jun 2022 21:13:40 +0800
Message-Id: <20220606131340.317483-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The incorrect comment is misleading. Acutally the last members
in ceph_mds_caps strcut is a union for none export and export
bodies.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 86bf82dbd8b8..40740e234ce1 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -768,7 +768,7 @@ struct ceph_mds_caps {
 	__le32 xattr_len;
 	__le64 xattr_version;
 
-	/* filelock */
+	/* a union of non-export and export bodies. */
 	__le64 size, max_size, truncate_size;
 	__le32 truncate_seq;
 	struct ceph_timespec mtime, atime, ctime;
-- 
2.36.0.rc1

