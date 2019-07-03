Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31A95E4FE
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 15:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGCNNp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 09:13:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34583 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfGCNNp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 09:13:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id p10so1249133pgn.1;
        Wed, 03 Jul 2019 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fs73VhBOyzdIlK7YRoWsh1OqkxflcVmUXV5igdjoOaY=;
        b=BEXICzBtUf+LWzuwiVitPQJyjh0z0UiuDy9pOagTf1LOBXd/txFvzx/PW3/rhhuDcK
         F/DvcMKyoERmx6VBiqA+VP+Clc65y3FL5yfZaRA1ai/YA62KbB5MPEKrmOQn0L4FEkZ4
         pG3undSA5aVNmHNKStTEWAGx3xU11yDAK0tDCBOnOTALxHRWOrsumrDeKuTVxsrfDMYf
         O+HsK3a+zhSgu1tJM75YFVybSzo4LlSgi1THX7UivqMtqPfvSMm0LvqKx/kPRJC3qKc5
         NgIXXT/o7R4GZpiS3xkC2pQNaERBvSQYxfHPTp1iFWmPAce1tFk4RhqJaN95JioEORo9
         6zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fs73VhBOyzdIlK7YRoWsh1OqkxflcVmUXV5igdjoOaY=;
        b=m1hq0tPHebsCRFH3mWYJR0MQV1ZieVor/zP1BhEJf2GeR9QEmK7CM+7gqzmZiO4yJD
         H93g1km+lslV3U+y0V4MJA1zCI/AvXf1918SDcL+sMGBVpTgZ9aH+lXt+sKOn+ImSBEk
         X3SM0UEmqpwuJ0vBFYCa55l2ti0bICSoyVuO2wjTXpqZIS9pt+WNBM05JLCuPZ6Seqkw
         wX2kVAxR/F+p5pt5eeL6aJ5dcqYgCUMqKpn3lUrZf4Vw+a/rckmRArbbndhvzu3gMug5
         Ho065xdupu8PV65GsqT9t5eIruEI3NuTsCA/9GgCXD+3keOQ3BSFiJDMCTMmZhGigO/K
         PMgA==
X-Gm-Message-State: APjAAAUU193d75IwsJKUPVvYiV5te9uEInzKSyb90WQM/M9Uan0oRnkm
        TPARTpNkcG1394lmxNo9r2xETkteoIg=
X-Google-Smtp-Source: APXvYqzWl6TjQMQji2rpNBgch+fJu98DPtzuMAHWJT08/Ao4l1frJAV1VFzoF7qnwymeQSRzPkuavQ==
X-Received: by 2002:a17:90a:2525:: with SMTP id j34mr13150137pje.11.1562159624573;
        Wed, 03 Jul 2019 06:13:44 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id b36sm7680259pjc.16.2019.07.03.06.13.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 06:13:44 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 03/30] block: Use kmemdup rather than duplicating its implementation
Date:   Wed,  3 Jul 2019 21:13:36 +0800
Message-Id: <20190703131336.24808-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memset, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/block/rbd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e5009a34f9c2..47ad3772dc58 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1068,7 +1068,7 @@ static int rbd_header_from_disk(struct rbd_device *rbd_dev,
 
 		if (snap_names_len > (u64)SIZE_MAX)
 			goto out_2big;
-		snap_names = kmalloc(snap_names_len, GFP_KERNEL);
+		snap_names = kmemdup(&ondisk->snaps[snap_count], snap_names_len, GFP_KERNEL);
 		if (!snap_names)
 			goto out_err;
 
@@ -1088,7 +1088,6 @@ static int rbd_header_from_disk(struct rbd_device *rbd_dev,
 		 * snap_names_len bytes beyond the end of the
 		 * snapshot id array, this memcpy() is safe.
 		 */
-		memcpy(snap_names, &ondisk->snaps[snap_count], snap_names_len);
 		snaps = ondisk->snaps;
 		for (i = 0; i < snap_count; i++) {
 			snapc->snaps[i] = le64_to_cpu(snaps[i].id);
-- 
2.11.0

