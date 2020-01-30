Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA5414DBEC
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 14:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgA3Na6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 08:30:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41137 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgA3Na5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 08:30:57 -0500
Received: by mail-wr1-f65.google.com with SMTP id c9so4035086wrw.8
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jan 2020 05:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9DPgWPlO0VR8awHrOhf9rZyVBR0KdQdHIpdirKOFxmY=;
        b=fYbM1smroXDbgPDs1h/amHJEM44ihzwDKl+sMV4//CqzXKxAfNxCj669ajEn/hJ/xe
         OxVeHEzmug06++vnaOyKqES7mjaC1vkE1zKKe9Kpm3OX1Z+tMZLoO9N2KvhJxzfLLTmK
         ZChm9ObUTQFWMffm4A+PzIa4OswSovwoBam8Rh91pTz/j4EZdhgoIvQY7NQCg3U0ZnkA
         QSqkVk8r64Xy2HiQ/k9WeRP+4p9aQDqBBGDrR9HzDh8GnOouRlC9FTsosotQE/DQXZWJ
         6eb7zYeu2FN+ow0NdlGeKWK5r3uLXCw0wxbTlxgrjV/ngoeGB/R7Scw0ME6khAKewMPd
         X/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9DPgWPlO0VR8awHrOhf9rZyVBR0KdQdHIpdirKOFxmY=;
        b=QnlstdsQOEinglqcned02heQ80mV3j5Zai6S9S3rZYpEUgqApQ0gOaoP7KMMZ03XxL
         Z0AIwcwYQj0I0gtR0X4yYxA8I5uYp1jU5JGFyeTFcR4R7s5kWLbrBqOBTV2XmsrWnt8O
         4JPTki2FBCSs2yd5p9cBDiWhtlXjE0h4buySx9dzM0eOBfEXY8A57RSd/96Rn3tURe4i
         wfKAr3KckHGSl2TNWOSXynUgwMLTkFWA1z5hyKm+Cf750eVCRbe67uFwS8oeguwNFXcl
         1vK43NZSz2g9Rfk4yciv3E6OrYyzlWPXamqWGPCUjwEc7dJ43jfTRNxjjlBTDOnlxtk6
         oK1A==
X-Gm-Message-State: APjAAAV3XNpnJjtFoZ9Q2XQKu72577/Hwj5X9NBiON6/8waXe7UWn08f
        iaEBhWeVI5CjAnsb8sY6HW+cFo2SSOA=
X-Google-Smtp-Source: APXvYqzyjCc7L/pOMB7sqrNPOssVjso/mrFMRsS579TAPCc7xCW+nIllkLNGgeBSWw8I51eT4Nbmew==
X-Received: by 2002:a5d:438c:: with SMTP id i12mr1258651wrq.51.1580391056411;
        Thu, 30 Jan 2020 05:30:56 -0800 (PST)
Received: from kwango.redhat.com ([213.175.37.12])
        by smtp.gmail.com with ESMTPSA id g2sm7254835wrw.76.2020.01.30.05.30.55
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 05:30:55 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] rbd: remove barriers from img_request_layered_{set,clear,test}()
Date:   Thu, 30 Jan 2020 14:31:02 +0100
Message-Id: <20200130133102.13745-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

IMG_REQ_LAYERED is set in rbd_img_request_create(), and tested and
cleared in rbd_img_request_destroy() when the image request is about to
be destroyed.  The barriers are unnecessary.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f21f9bc8d74a..4e494d5600cc 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1371,18 +1371,15 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
 static void img_request_layered_set(struct rbd_img_request *img_request)
 {
 	set_bit(IMG_REQ_LAYERED, &img_request->flags);
-	smp_mb();
 }
 
 static void img_request_layered_clear(struct rbd_img_request *img_request)
 {
 	clear_bit(IMG_REQ_LAYERED, &img_request->flags);
-	smp_mb();
 }
 
 static bool img_request_layered_test(struct rbd_img_request *img_request)
 {
-	smp_mb();
 	return test_bit(IMG_REQ_LAYERED, &img_request->flags) != 0;
 }
 
-- 
2.19.2

