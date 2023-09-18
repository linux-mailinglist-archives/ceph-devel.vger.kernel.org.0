Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27927A4538
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Sep 2023 10:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbjIRIzu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Sep 2023 04:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240876AbjIRIz1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Sep 2023 04:55:27 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAD7D1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Sep 2023 01:55:19 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2bf5bf33bcdso71263071fa.0
        for <ceph-devel@vger.kernel.org>; Mon, 18 Sep 2023 01:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695027317; x=1695632117; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D/LluwsTVmduTpUuftyAJX8MClI5ZxpGRLDpFVPNZ5k=;
        b=FfS7ZK6tnQNhpMeVIxpdcl6v0mKRBHlHX35zECnm8bgJiu9/uPq240paqTxO6MLcZp
         M8Ip+Ey6jzXmzM2eYjjUL+4wrLt3Fv3w6iL2+d0aAfr9bsCsoFMc6KQ+kRqQ83gw+99k
         ajZjR/46V9Rqi4Tv0eIfaJKGJvXeE+lRP2GOAl3b+hhfjWzVCspwI0M7KSiA2TtQyQKJ
         VsQEd2ufk+c69GkC1ppPW4Ayixc8do6S0MsGJ1KvAzf4/qm0yQR3a5ZYrEBECrRuPHBv
         oK1Bzk2YcCAEOgFa1rzayaMs4199wEhLjVMbv8GX1bO1qc/JMO9boMTyqBhMPUUau+CU
         Zl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695027317; x=1695632117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D/LluwsTVmduTpUuftyAJX8MClI5ZxpGRLDpFVPNZ5k=;
        b=UzblgjtD6DXj7gLvmURhbBJZWzSidXOFPZ/SHejYPF6F/Cnbhoid3Wxdq3hHbLkluO
         hyLzVVCVWMeIH1wnRcA5uMV9Km2SpsVPyMPC/D7dEdkLbiDOd1AL8/KnMzCTHtswkmZ1
         +9PWU/Tcwg7OvYz6TdSTcpF8RxNkhcqzxgz8JlEk4qTF/8qzbe3U5jA5I6alfXuSt+RL
         izt1NxA5tisDOqFZpIJof9KILTRXbEsubg1K/ekPNYy/Iht5a8MHL+JibJ6V7492dsWX
         JTnjgeve1suv5pojiILvDcTr5PXFKxCsuqRCdPGwswCaxsADXiySSOD54QWbea1tD41/
         PboA==
X-Gm-Message-State: AOJu0Yxl12aqd3EnQ3xv18+RzP6lqn696KVyQw+n8g8U6waSwdQlzLh8
        t5HXU4JLZc2AJ3gG/Q1/Rx+Y2RzfsLw=
X-Google-Smtp-Source: AGHT+IFDPvp0406RGJEX4Vfl6DFa0T0PAJW3RH4Q4lCHzVTidEsV3k2fhrRefkI7UwHsWX3w+MCWwQ==
X-Received: by 2002:a2e:9b95:0:b0:2bc:bcc6:d4ad with SMTP id z21-20020a2e9b95000000b002bcbcc6d4admr7126371lji.21.1695027317221;
        Mon, 18 Sep 2023 01:55:17 -0700 (PDT)
Received: from zambezi.redhat.com (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id g21-20020a170906595500b00992f2befcbcsm6090870ejr.180.2023.09.18.01.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 01:55:16 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Milind Changire <mchangir@redhat.com>
Subject: [PATCH] Revert "ceph: make members in struct ceph_mds_request_args_ext a union"
Date:   Mon, 18 Sep 2023 10:55:08 +0200
Message-ID: <20230918085509.55682-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This reverts commit 3af5ae22030cb59fab4fba35f5a2b62f47e14df9.

ceph_mds_request_args_ext was already (and remains to be) a union.  An
additional anonymous union inside is bogus:

    union ceph_mds_request_args_ext {
        union {
            union ceph_mds_request_args old;
            struct { ... } __attribute__ ((packed)) setattr_ext;
        };
    }

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/ceph_fs.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 5f2301ee88bc..f3b3593254b9 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -467,19 +467,17 @@ union ceph_mds_request_args {
 } __attribute__ ((packed));
 
 union ceph_mds_request_args_ext {
-	union {
-		union ceph_mds_request_args old;
-		struct {
-			__le32 mode;
-			__le32 uid;
-			__le32 gid;
-			struct ceph_timespec mtime;
-			struct ceph_timespec atime;
-			__le64 size, old_size;       /* old_size needed by truncate */
-			__le32 mask;                 /* CEPH_SETATTR_* */
-			struct ceph_timespec btime;
-		} __attribute__ ((packed)) setattr_ext;
-	};
+	union ceph_mds_request_args old;
+	struct {
+		__le32 mode;
+		__le32 uid;
+		__le32 gid;
+		struct ceph_timespec mtime;
+		struct ceph_timespec atime;
+		__le64 size, old_size;       /* old_size needed by truncate */
+		__le32 mask;                 /* CEPH_SETATTR_* */
+		struct ceph_timespec btime;
+	} __attribute__ ((packed)) setattr_ext;
 };
 
 #define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */
-- 
2.41.0

