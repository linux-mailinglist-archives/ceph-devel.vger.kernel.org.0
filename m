Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7221F11F92D
	for <lists+ceph-devel@lfdr.de>; Sun, 15 Dec 2019 17:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfLOQnh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 15 Dec 2019 11:43:37 -0500
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:48162 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfLOQng (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 15 Dec 2019 11:43:36 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2019 11:43:36 EST
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id 47bVPv5MK2z9vZ63
        for <ceph-devel@vger.kernel.org>; Sun, 15 Dec 2019 16:35:31 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 31xnMYoM1nRu for <ceph-devel@vger.kernel.org>;
        Sun, 15 Dec 2019 10:35:31 -0600 (CST)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 47bVPv493tz9vZ5m
        for <ceph-devel@vger.kernel.org>; Sun, 15 Dec 2019 10:35:31 -0600 (CST)
Received: by mail-yb1-f197.google.com with SMTP id y204so2365352yby.18
        for <ceph-devel@vger.kernel.org>; Sun, 15 Dec 2019 08:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RtqtAENkikt2OwSsUAKI6q95l8UgBNbet4mLKXhPLPc=;
        b=gASw7z/I0SjFUTMduO0mrbXnhtLKxXhWkOF1hA/NCG12Ch6gDZFEqMnbJIwzzEPoou
         +xH47X1jCoab581xt65AVJdaT3JqBWycPK5jVlQq0+xGLTyro0BNAy6T6oB1/wt/dles
         ag7qhX3VwtoyqJFRO+djy8VltI5NtuvPH+NoE3e2pZl1gm9KBPs0tNtqIYIV9YV+iP7j
         BHNwjeLz35FgXSkYJz0vrOhsE/tvHIKDsss25zHf4nVDcqCbzb7gM6ATSy0cbmgug3Q2
         XTlMUOK0GYYiGZRDWz5Esl0NS0AozgZJ4ge0Ve6AbtJCcyVVNp8l9cAL4TZxrmk86wn2
         VLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RtqtAENkikt2OwSsUAKI6q95l8UgBNbet4mLKXhPLPc=;
        b=c447kJM0O9/p3pR9HUSb6YgamdB5Qp5Bxt+3qc3U0oGbH6q9HXRUflEtLOa/2z3Ryy
         11Musczwv6wN3KYunyHXQVWENLryXopq/FTMQreqUj6oqtkfljsBtB237NIb0Wvdn71f
         jPZMz462B0IGEbZFKG/nWxKkP9GHXuDS/5haahc+L6Gfk5EpahtzV45B9GcoHq6NgFh1
         ZEzyBX0FU+eMCKIjcB8mVsv0XsnsM4gY7elMQ9hkxOIblh8v3sBtf5sbNdFsUkMtzAaI
         r8anYarFxfjtL1coQVx8J8mWnSchTDx6djZ6Urjcw+YeuXRUSZYilswKO/TJMc4SfTkr
         M40w==
X-Gm-Message-State: APjAAAUJzJ86PRyb557MIpUq5EvgpzzPv67lLzRGaHcW3bgNT/NOFX8z
        S+XXD8W+t4Kdmcdu/qx+/DK35bzXK+avo3vSmxxnI+p2Cckr1SpdC/LqRF9yBDM+4mkIqbY/b2g
        +3O+Wf5hlwti5srVYOtGjA3xATA==
X-Received: by 2002:a0d:cc4c:: with SMTP id o73mr16970366ywd.482.1576427730956;
        Sun, 15 Dec 2019 08:35:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqz926INkyG4z0GFI/Np7oPSQT09p97e6twIqiathpPSkhQbrht1R/pRTZ9FNegpZbKOIIU6sA==
X-Received: by 2002:a0d:cc4c:: with SMTP id o73mr16970343ywd.482.1576427730693;
        Sun, 15 Dec 2019 08:35:30 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id y9sm7261560ywc.19.2019.12.15.08.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 08:35:30 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sage@redhat.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>, ceph-devel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rbd: Avoid calling BUG() when object_map is not empty
Date:   Sun, 15 Dec 2019 10:35:27 -0600
Message-Id: <20191215163527.25203-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In __rbd_object_map_load, if object_map contains data, return
error -EINVAL upstream, instead of crashing, via BUG. The patch
fixes this issue.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/block/rbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2b184563cd32..6e9a11f32a94 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1892,7 +1892,8 @@ static int __rbd_object_map_load(struct rbd_device *rbd_dev)
 	int num_pages;
 	int ret;
 
-	rbd_assert(!rbd_dev->object_map && !rbd_dev->object_map_size);
+	if (rbd_dev->object_map || rbd_dev->object_map_size)
+		return -EINVAL;
 
 	num_objects = ceph_get_num_objects(&rbd_dev->layout,
 					   rbd_dev->mapping.size);
-- 
2.20.1

