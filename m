Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439743BDC00
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 19:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhGFROy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 13:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhGFROy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 13:14:54 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771AEC061574
        for <ceph-devel@vger.kernel.org>; Tue,  6 Jul 2021 10:12:15 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j16-20020a05600c1c10b0290204b096b0caso2757373wms.1
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 10:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R3EAQm6eG6GvVGYsrzhZhrD9dWR9vxyfdftyH+s48ms=;
        b=t4aGQhfTBOuoaYTdaSrsmQs1OHAY/fWke0qWbIRW0NWcTmcKrRd7InFIG9zszhHSnc
         DeRlesTiTgoeqljtg88aV+GJkb6iJjNVvavSzj5MOk49O4IlE+NmfU8zSVL8IEbkellx
         W3HIiO1v6313MoRYMjwQD0yuunQ/LBHmy+3YCcrDF3tnkrc2LKcy4sSN48NPfioontYP
         o2uEn8817qQ3SKfw40pKO5KX79ZsubGCuSlTDEnBR9XBRhT6VPR/2tPWtuPCW/AiPN/8
         GvA594ieOI9INiLJ14FEi6X5gHv4Lh5FKlTBonmGaiSH9MZSSG+YjyNvJWkG2YqK5WaM
         L/lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R3EAQm6eG6GvVGYsrzhZhrD9dWR9vxyfdftyH+s48ms=;
        b=nY88VRQpgw0+MYwPeMfRr9zQaAPeQHhjSkfNZATjfgBAs+XT2GEhupwxSdoh6FEDSX
         xpgYCO+mpBF1pauho3fpWgElqlyNajLp3qoNDDgAiBMxluNiCBPO3br4holReolreNgB
         awOYFPHakarZaZyX+PHjFNRZyqtpGMiLQw1B9WnywObCCH60t4Zf4990SK4Orz6ewv2g
         jtBqb+EQYNmBicfMM1NBjnQSRfDub3sDfQNRBz3tGiOxZZjVRhM+T1uEsUMNvPte2C3s
         ylvQiJs0ze0CthGH1duodVs6Qq3bNdatxWY3Be5aWhVTyCPUVVDZqgQdlwEjdIYrYCJU
         BOzQ==
X-Gm-Message-State: AOAM532Shefxhq//Se3fiUZae189QMMGz8tQCEUoufn4p+uoeg1fvoy3
        /iGYWVPwTU/Y0yaIawPkd8DMgtd2+NRpZg==
X-Google-Smtp-Source: ABdhPJzUQBawFyhdZ+eAjrTSr/mg1lEjL+uz7M/RQoDOCLMr8R/unsFbc/QTItm5pY/oI2vmaQTHbg==
X-Received: by 2002:a05:600c:3588:: with SMTP id p8mr19074667wmq.137.1625591533071;
        Tue, 06 Jul 2021 10:12:13 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id w3sm3474659wmi.24.2021.07.06.10.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 10:12:12 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Robin Geuze <robin.geuze@nl.team.blue>
Subject: [PATCH] rbd: always kick acquire on "acquired" and "released" notifications
Date:   Tue,  6 Jul 2021 19:11:37 +0200
Message-Id: <20210706171137.851-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Skipping the "lock has been released" notification if the lock owner
is not what we expect based on owner_cid can lead to I/O hangs.
One example is our own notifications: because owner_cid is cleared
in rbd_unlock(), when we get our own notification it is processed as
unexpected/duplicate and maybe_kick_acquire() isn't called.  If a peer
that requested the lock then doesn't go through with acquiring it,
I/O requests that came in while the lock was being quiesced would
be stalled until another I/O request is submitted and kicks acquire
from rbd_img_exclusive_lock().

This makes the comment in rbd_release_lock() actually true: prior to
this change the canceled work was being requeued in response to the
"lock has been acquired" notification from rbd_handle_acquired_lock().

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index be033e179299..a3caecae5d6a 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4203,15 +4203,11 @@ static void rbd_handle_acquired_lock(struct rbd_device *rbd_dev, u8 struct_v,
 	if (!rbd_cid_equal(&cid, &rbd_empty_cid)) {
 		down_write(&rbd_dev->lock_rwsem);
 		if (rbd_cid_equal(&cid, &rbd_dev->owner_cid)) {
-			/*
-			 * we already know that the remote client is
-			 * the owner
-			 */
-			up_write(&rbd_dev->lock_rwsem);
-			return;
+			dout("%s rbd_dev %p cid %llu-%llu == owner_cid\n",
+			     __func__, rbd_dev, cid.gid, cid.handle);
+		} else {
+			rbd_set_owner_cid(rbd_dev, &cid);
 		}
-
-		rbd_set_owner_cid(rbd_dev, &cid);
 		downgrade_write(&rbd_dev->lock_rwsem);
 	} else {
 		down_read(&rbd_dev->lock_rwsem);
@@ -4236,14 +4232,12 @@ static void rbd_handle_released_lock(struct rbd_device *rbd_dev, u8 struct_v,
 	if (!rbd_cid_equal(&cid, &rbd_empty_cid)) {
 		down_write(&rbd_dev->lock_rwsem);
 		if (!rbd_cid_equal(&cid, &rbd_dev->owner_cid)) {
-			dout("%s rbd_dev %p unexpected owner, cid %llu-%llu != owner_cid %llu-%llu\n",
+			dout("%s rbd_dev %p cid %llu-%llu != owner_cid %llu-%llu\n",
 			     __func__, rbd_dev, cid.gid, cid.handle,
 			     rbd_dev->owner_cid.gid, rbd_dev->owner_cid.handle);
-			up_write(&rbd_dev->lock_rwsem);
-			return;
+		} else {
+			rbd_set_owner_cid(rbd_dev, &rbd_empty_cid);
 		}
-
-		rbd_set_owner_cid(rbd_dev, &rbd_empty_cid);
 		downgrade_write(&rbd_dev->lock_rwsem);
 	} else {
 		down_read(&rbd_dev->lock_rwsem);
-- 
2.19.2

