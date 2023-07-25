Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C1D762469
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 23:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjGYV3R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 17:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjGYV3Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 17:29:16 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4BF1FEB
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:13 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-4fbb281eec6so9502850e87.1
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jul 2023 14:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690320552; x=1690925352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Si8u31JjykIlBGeMY3l1rmiBprxRVKXt5XCzLIWo/Bw=;
        b=gleUB2OaQ+8fsAkALfjqHESQQulHZmPU7nHDZw2R2IrzZyyyDzDBvOZEkC/T6wii+X
         Z95BKpKN1n156XC49BCZnksAoLiU+B7xSrfIvLZ0KElIJZWU/THmPTB2RvLOFMquqCeS
         YacsjY/sf24DYIflmAt3zsUnCde2+MH7zbo4wr+flG+gglSZzS9SMfkpQK8UuDImoVwq
         13oehnMPMmBnR1kNCvDoSg4Rtu/Ny/U3iFeY/0DsXRg07NWHNbWYHBs25D4aGOy5dSqK
         zBdhTbIJXWqf+SuZPJezqw6OkFzSy9QPH+XuUMgfX/UM4V07Xz8ABHKtqi3fVNxUK1Kf
         TSBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690320552; x=1690925352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Si8u31JjykIlBGeMY3l1rmiBprxRVKXt5XCzLIWo/Bw=;
        b=QDcdv7MyxoNiriEZp7nQDStRfQNw/FHlyFmna8TwV1bMZ/e+2Kw74OEvMfL9bLWzGS
         eTABqzZxoiWHbcNzIpAZLkzl8KXEOiHKDk/AyoY3fZ8qUPYM7xXU84YU0ulv9SNXEu4o
         pBy0bJlwVKKq4Dp6/l9OL6gfqXp/fLJMP48aV6I07+Vt5Cjl++A0Hzi8OP8XcBQvdO7Z
         BZkPGnDX5bh4kdeDty5yuEBzc98v1yWHu3BKkMH8CBGFqoGhdOnkK1tKlS10+jMWuAPJ
         jT87vvlAGwkgSpEUt/mnq6dyhCQELPHtzlFcZwEa2qxvO6EONEIwgYM3FQNDbZmdGaiZ
         eaIQ==
X-Gm-Message-State: ABy/qLZRoA8NwhaRcnMXcKH+mbwOonGbTcwUVKZxterk+i78amfeX9rc
        9arrJ5MzukCelLuWS3aXDNw2pIdIwxc=
X-Google-Smtp-Source: APBJJlHcxE50i4gFVW58Vdd5aMm9nijBlF5DTyeQw2r+4DRuqcZnO+bh1mkBhWIpYJ+JfC+krSSqjA==
X-Received: by 2002:a05:6512:202c:b0:4f8:7781:9870 with SMTP id s12-20020a056512202c00b004f877819870mr55716lfs.60.1690320551509;
        Tue, 25 Jul 2023 14:29:11 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id f23-20020a05640214d700b005224ec27dd7sm1200778edx.66.2023.07.25.14.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 14:29:11 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v2 2/3] rbd: harden get_lock_owner_info() a bit
Date:   Tue, 25 Jul 2023 23:28:45 +0200
Message-ID: <20230725212847.137672-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725212847.137672-1-idryomov@gmail.com>
References: <20230725212847.137672-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

- we want the exclusive lock type, so test for it directly
- use sscanf() to actually parse the lock cookie and avoid admitting
  invalid handles
- bail if locker has a blank address

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c  | 21 +++++++++++++++------
 net/ceph/messenger.c |  1 +
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index dca6c1e5f6bc..94629e826369 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3862,10 +3862,9 @@ static struct ceph_locker *get_lock_owner_info(struct rbd_device *rbd_dev)
 	u32 num_lockers;
 	u8 lock_type;
 	char *lock_tag;
+	u64 handle;
 	int ret;
 
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
-
 	ret = ceph_cls_lock_info(osdc, &rbd_dev->header_oid,
 				 &rbd_dev->header_oloc, RBD_LOCK_NAME,
 				 &lock_type, &lock_tag, &lockers, &num_lockers);
@@ -3886,18 +3885,28 @@ static struct ceph_locker *get_lock_owner_info(struct rbd_device *rbd_dev)
 		goto err_busy;
 	}
 
-	if (lock_type == CEPH_CLS_LOCK_SHARED) {
-		rbd_warn(rbd_dev, "shared lock type detected");
+	if (lock_type != CEPH_CLS_LOCK_EXCLUSIVE) {
+		rbd_warn(rbd_dev, "incompatible lock type detected");
 		goto err_busy;
 	}
 
 	WARN_ON(num_lockers != 1);
-	if (strncmp(lockers[0].id.cookie, RBD_LOCK_COOKIE_PREFIX,
-		    strlen(RBD_LOCK_COOKIE_PREFIX))) {
+	ret = sscanf(lockers[0].id.cookie, RBD_LOCK_COOKIE_PREFIX " %llu",
+		     &handle);
+	if (ret != 1) {
 		rbd_warn(rbd_dev, "locked by external mechanism, cookie %s",
 			 lockers[0].id.cookie);
 		goto err_busy;
 	}
+	if (ceph_addr_is_blank(&lockers[0].info.addr)) {
+		rbd_warn(rbd_dev, "locker has a blank address");
+		goto err_busy;
+	}
+
+	dout("%s rbd_dev %p got locker %s%llu@%pISpc/%u handle %llu\n",
+	     __func__, rbd_dev, ENTITY_NAME(lockers[0].id.name),
+	     &lockers[0].info.addr.in_addr,
+	     le32_to_cpu(lockers[0].info.addr.nonce), handle);
 
 out:
 	kfree(lock_tag);
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index cd7b0bf5369e..5eb4898cccd4 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1123,6 +1123,7 @@ bool ceph_addr_is_blank(const struct ceph_entity_addr *addr)
 		return true;
 	}
 }
+EXPORT_SYMBOL(ceph_addr_is_blank);
 
 int ceph_addr_port(const struct ceph_entity_addr *addr)
 {
-- 
2.41.0

