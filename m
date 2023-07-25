Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE497608A5
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 06:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjGYEgV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 00:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjGYEgT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 00:36:19 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F9EE64
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:18 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3142a9ff6d8so4597441f8f.3
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690259777; x=1690864577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xY06zrmpkj+XtBzqfRQ39oDihyRHQpBOBuxeg2YX7J0=;
        b=nlvgW0R/PIHpiAUS/YVwUNUd79mC7eJInoQIea1nW4qD+n9w5H7Zg48UxuS3kIHecu
         fhlJ9TVmcDL6uE9151lNgBtML6prVr0utGxHk/TeYtuhKH12zqjdKEpqN5Yu1REk9sDP
         ntiAQRzRvTYPOwhqvMVE3dwwZpfOhnyfoP538E6r48CTNuoQZL29+PTle9BlS8SQ6I/k
         a5irbpz7s3bi/hzm+SV+z2w5zHGUFJp6tDcwUnbwKdVFQLmSHZByGF1ked7t0X3v9pwv
         rabHRiVE79vI21qYlV1c4/kFkPyYUz/AcqbCuMoTUQUYBYX7vFbCyjXhg9v9qoGi1VHl
         smAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690259777; x=1690864577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xY06zrmpkj+XtBzqfRQ39oDihyRHQpBOBuxeg2YX7J0=;
        b=RMcWrqR0Q9Wp2cTY1LDFee62wlXSvk0tNi+vN1bo3EseJYrriNPoxB7wiUng4EifNR
         ltNzteXsbIe9D4gb5l+Bs7GptX+ZMzho92q3D9SrEBXXt/2mj6uVKdKpO4M088FT28rs
         j1FUXvIOrUr+t89Y8uGPtyc41Bmd+6J7RLnSNrU48yI5531VXxwQSKD7Zj8RWn1LMQks
         aM3W/HGY5YdfjBL5b3mw8QsnuNYmSdqRconnhSsWxZtnmH2U5X82VmDZWwwxL50qZd2y
         9hsny+tF2ncdAL/tK0XuP7LlvtWSzIQm4SOtYRkxSoGNqmnbRVXYtHG6Lwz32FCtgaYR
         0Fbw==
X-Gm-Message-State: ABy/qLZ9UhvGO50eQxAyf2dtNJTNBN9vTtvp+8R3wXDrzU6Tw3V5yOOO
        h3Qj3i1puDknel1C4lwORcv7AkZfTW8=
X-Google-Smtp-Source: APBJJlFkZu7CYaAS9nv8qm2UMBjes2fyQyNHjuPEMa5OlRYGLwwlINRoXKHf0jt5gaK7iSPMW5nGng==
X-Received: by 2002:adf:f184:0:b0:317:58e4:e941 with SMTP id h4-20020adff184000000b0031758e4e941mr4772997wro.33.1690259776553;
        Mon, 24 Jul 2023 21:36:16 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id d1-20020a5d6441000000b00317643a93f4sm3500760wrw.96.2023.07.24.21.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 21:36:16 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 2/3] rbd: harden get_lock_owner_info() a bit
Date:   Tue, 25 Jul 2023 06:35:55 +0200
Message-ID: <20230725043559.123889-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725043559.123889-1-idryomov@gmail.com>
References: <20230725043559.123889-1-idryomov@gmail.com>
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
 drivers/block/rbd.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

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
-- 
2.41.0

