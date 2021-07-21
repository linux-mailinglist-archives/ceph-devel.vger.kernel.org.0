Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843573D0F42
	for <lists+ceph-devel@lfdr.de>; Wed, 21 Jul 2021 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhGUM3s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 21 Jul 2021 08:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236534AbhGUM3s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 21 Jul 2021 08:29:48 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 983BEC061574
        for <ceph-devel@vger.kernel.org>; Wed, 21 Jul 2021 06:10:24 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d12so2103765wre.13
        for <ceph-devel@vger.kernel.org>; Wed, 21 Jul 2021 06:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Kwdnv/sSDYgvkWyPDJbDpCrFrENTOmlS/NiN7rSN9o=;
        b=XLOk0r5m/WCOQOs2AZV7fuXsl7MVUxBOjZMZgIkQGWDb78wRtxcvC4WKXcibWEM63O
         Asn2ZCLu3moK5NJ1V5/MOIst9BdJIuRB+H7ezx3vAJPwEbCVn7bdsObwGpCyRQX0LA1T
         1oOJ9//sz0dFW9mH427tGB6fVaJeENPzW7y0M5xtaga8K+cJsiAI/zmBsW+yzLKhWZJr
         +1Kmsa0Xz/4jwGfPpru9b4hLzjCvwavCll/HOs3pVv9U9I0kfaMtYJ8vHyPEiGjiE59w
         mEMXEa5e7w7ZB7nxBU+RxYmqx8LcDc/2xmm/wQ9PrRP621AuGzpKZtWgQPznf6nLDsjz
         tS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Kwdnv/sSDYgvkWyPDJbDpCrFrENTOmlS/NiN7rSN9o=;
        b=doaA1kcStUomUW5BVlX0XU8bG/OZvQp8wR9e23PcZ721eyeriDl2rqg/tOtrx50c5M
         42+Hu9G+0iXiCA2X/7jhMX11a23PvFE+QVb+RB+tw4tSZaZdsBd55wxiAvl46GSIHUd5
         iLz2/wziT6M937QB5VEgNREg1E1puIJ4VAeAtHUSc+JEOS7VD/bJotIOcAXxz0ScjbNg
         7yuUIJEFpBywVT6/oOBRXIunCvW1nD2lJ7sE7XXQ8J1x9eYA+KhGXbqpBQAwFuD1nAhx
         po6M4pyHnbZM9dxERyl+eYWPdElLY0uKMPQno4N/Hbm70UaqtjhGDmw8e77dN3b8Relf
         XXUg==
X-Gm-Message-State: AOAM532O12hm/5sq34HnvXZGFFeb5oUsbvJX6zW9zqRa/BTkhzQBuUpF
        yqzKHwIjiV36O0uhSK9QnZQbTG9bz/0hVw==
X-Google-Smtp-Source: ABdhPJx34vrtiE1ZMnt/19WhgHVo3AW1Lcs1AsiftA/zNPGvFmNEklcrnMdxF+up0cmPqoAqUc3eSQ==
X-Received: by 2002:adf:efc6:: with SMTP id i6mr42240655wrp.213.1626873023263;
        Wed, 21 Jul 2021 06:10:23 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-137-87.net.upcbroadband.cz. [94.112.137.87])
        by smtp.gmail.com with ESMTPSA id b6sm5081170wmj.34.2021.07.21.06.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 06:10:22 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH] rbd: resurrect setting of disk->private_data in rbd_init_disk()
Date:   Wed, 21 Jul 2021 15:09:50 +0200
Message-Id: <20210721130950.3359-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_open() and rbd_release() expect that disk->private_data is set to
rbd_dev.  Otherwise we hit a NULL pointer dereference when mapping the
image.

Fixes: 195b1956b85b ("rbd: use blk_mq_alloc_disk and blk_cleanup_disk")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 48c485d7efa1..9384395670b2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4943,6 +4943,7 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 		disk->minors = RBD_MINORS_PER_MAJOR;
 	}
 	disk->fops = &rbd_bd_ops;
+	disk->private_data = rbd_dev;
 
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 	/* QUEUE_FLAG_ADD_RANDOM is off by default for blk-mq */
-- 
2.19.2

