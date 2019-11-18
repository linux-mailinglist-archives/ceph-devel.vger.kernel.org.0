Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF65A1006A1
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 14:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKRNig (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 08:38:36 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36542 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfKRNif (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 18 Nov 2019 08:38:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id c22so18877743wmd.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2019 05:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=URgUTKUr4PFsmMgcE/I1boUSGJvMsmUQCFb58LW+Sj4=;
        b=ssOO63NrhxtAgAbp2VgeFWl6j3FNJtYtlPF/TtHK9kfBLk4imXCVRBRt2vgSEEesdd
         G4b8mZ0wWglm62yf9SItPjlTdJDZFE/LZdgJvpNs4ecuw4UT1hduCm/V2UZN2Rbb8NkO
         S/tGc7aBx+DGLhHJSYCjZ1i9vFrwFBMXbySGX6mmwjDo8oP14a2YNZ7e4Gyxqgyr8ShO
         ZhJKAM+EPMv4WWMJ3LuoGISL4FJVU5MIskTU1Y2uYBJVL792dnNv2Q7fxS9mRizK8SaJ
         +4CwTL7wOPkqRtOM2O+xo7ZJs89r3o26T0HdfMPpRYBgjZStlLKQIgCRtVO1BI8oqZEz
         WXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=URgUTKUr4PFsmMgcE/I1boUSGJvMsmUQCFb58LW+Sj4=;
        b=dHC+EEhUpHsuflZHjKWQsG2GS3gTRB6kt4qFdEdqm0OpiDv2TPnLZRsNMSFVFTuL4P
         9ez8QbdIfQ88xEUXrKIqCxR8kkT6gI9fhJUHOkFNFKQ4Dw60sQpE9WDUmy+Q8ExdGLfs
         DrazwYqZVGywWL9zrOeAaFwXkrlqlCiy9sOaYO5OCjLXrBQ1iAGDbMzW/MtN0gHRzj+R
         hn3JQqes0SzLDCzJYXI3pMQ2CSvpibahstU5va9pjQZrG5zB8xYzlUskHEv3g67en3OQ
         wPfkczU+xcLSANCA8GDL9RKmNSFXmi7cW61XaaGd2iHFdiqgW1Y+DjoUeufpCvUisY6F
         t0YQ==
X-Gm-Message-State: APjAAAUffP76DKs102pLZD3ESGvw6FeRlaCRbEsSYj7hPsZ2oj6ns9yx
        BYDoIQbSPn7MbEHOoqfbgssMWMC/
X-Google-Smtp-Source: APXvYqx702WZoWpWM7PfJbiT4zbKaacDtzgBJ5SP+uVZJVBRHFXmQATA8tTEXkJ2Dx62kOVzdMnrJA==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr30771802wml.41.1574084312230;
        Mon, 18 Nov 2019 05:38:32 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id t133sm24670242wmb.1.2019.11.18.05.38.31
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 05:38:31 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 4/9] rbd: disallow read-write partitions on images mapped read-only
Date:   Mon, 18 Nov 2019 14:38:11 +0100
Message-Id: <20191118133816.3963-5-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191118133816.3963-1-idryomov@gmail.com>
References: <20191118133816.3963-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If an image is mapped read-only, don't allow setting its partition(s)
to read-write via BLKROSET: with the previous patch all writes to such
images are failed anyway.

If an image is mapped read-write, its partition(s) can be set to
read-only (and back to read-write) as before.  Note that at the rbd
level the image will remain writeable: anything sent down by the block
layer will be executed, including any write from internal kernel users.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 842b92ef2c06..979203cd934c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -706,9 +706,16 @@ static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
 	if (get_user(ro, (int __user *)arg))
 		return -EFAULT;
 
-	/* Snapshots can't be marked read-write */
-	if (rbd_is_snap(rbd_dev) && !ro)
-		return -EROFS;
+	/*
+	 * Both images mapped read-only and snapshots can't be marked
+	 * read-write.
+	 */
+	if (!ro) {
+		if (rbd_is_ro(rbd_dev))
+			return -EROFS;
+
+		rbd_assert(!rbd_is_snap(rbd_dev));
+	}
 
 	/* Let blkdev_roset() handle it */
 	return -ENOTTY;
-- 
2.19.2

