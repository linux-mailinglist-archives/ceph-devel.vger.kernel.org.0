Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66C31DCA4F
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 11:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgEUJjC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 05:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728719AbgEUJjC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 May 2020 05:39:02 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20944C061A0E;
        Thu, 21 May 2020 02:39:02 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so2627841plr.4;
        Thu, 21 May 2020 02:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/CP/j4xODWOOmZoMRHzZmHfMUYujGrZKL9gkml0f/ZY=;
        b=G6SUhUflqEfjW5GdmmHmzu+uNKXatHrfaAjFyhUkgkhQ9Yg8+UgWADR4KHAbM/r154
         n1qYGUKrnZrrDEEZO3LxBgnODVWF3kQQ4U0jq9Nyny/vi7qMe9Nub+YAiT9mRDtLcVK9
         /QVAvXEG/5Y9J08J86CpaCtRS1fVBdijHti/0mueK2zBIiH/y/4CuZYoN+JmVhg/P32a
         tc/t42UvE2nhz+r273KkROsyU4qRJujhzs1wzxP+Kaa5ne5wc+i7qmBgrBA6BgQXdhqS
         P5zC2Fsf5pg/7mw3zerK5FDtysdOpRKAJi/KQkZwldHhoC1mh1+0ooFUBng6nICglxjJ
         43gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/CP/j4xODWOOmZoMRHzZmHfMUYujGrZKL9gkml0f/ZY=;
        b=k0B9EgxM8/ZNEhiIm77HY4GKVo/PmdwekeHsd+VKkqWkiv61MjNjQRu0Qov2aCVHyw
         hfoZCtZcAdPKZF5vdnSj37LDNZLNnaghFJg9ACt6/iB9IwKcV+4gus2CXBx6Ala2ZMG5
         iOcx9NR3O+wD8FI1JaK34ef3RxRT+K/IbbOs/zTaGXdJP0Syq8WJAFEii8RF4wfFO7Qt
         mLakl79/3C9MjAsPXpCPfgXy8VMYJodxP8CobtC0+rTECtjr+kQxflAjVIrCMTEzwADG
         8YKtAXM9xhQBvgEQES/1mJVMo22OOqkwp/Z6jBBTRtxndO+tzGeHIliN33pzPDY2lzHk
         x6mg==
X-Gm-Message-State: AOAM533FB+Vbt4f1pfozgLFDmIhMzWaXFwjZpVPGDSZphu3d7nl9VM/I
        R/J3x5BKgOOowxAerzM94/XSakL6
X-Google-Smtp-Source: ABdhPJxKDsOWkzPyLivDneHXVRxanBmj7K67wmB2WrQCX9Bi5vBx9vl1lWroZBg2AQ5vXd1x1YlenQ==
X-Received: by 2002:a17:90b:110f:: with SMTP id gi15mr10505850pjb.124.1590053941601;
        Thu, 21 May 2020 02:39:01 -0700 (PDT)
Received: from MacBook-Pro.mshome.net ([122.224.153.228])
        by smtp.googlemail.com with ESMTPSA id t188sm4028211pfb.185.2020.05.21.02.38.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 02:39:00 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: show max caps in debugfs caps file
Date:   Thu, 21 May 2020 17:38:45 +0800
Message-Id: <20200521093845.15101-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.2 (Apple Git-127)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

        before
        ------
        total           1026
        avail           1024
        used            2
        reserved        0
        min             1024

        after
        ------
        total           1026
        avail           1024
        used            2
        max             2048
        reserved        0
        min             1024

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/caps.c    | 6 ++++--
 fs/ceph/debugfs.c | 7 ++++---
 fs/ceph/super.h   | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5f3aa4d607de..e2c759a2ef35 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -404,8 +404,8 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
 }
 
 void ceph_reservation_status(struct ceph_fs_client *fsc,
-			     int *total, int *avail, int *used, int *reserved,
-			     int *min)
+			     int *total, int *avail, int *used, int *max,
+			     int *reserved, int *min)
 {
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 
@@ -417,6 +417,8 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
 		*avail = mdsc->caps_avail_count;
 	if (used)
 		*used = mdsc->caps_use_count;
+	if (max)
+		*max = mdsc->caps_use_max;
 	if (reserved)
 		*reserved = mdsc->caps_reserve_count;
 	if (min)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 481ac97b4d25..942004376588 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -138,16 +138,17 @@ static int caps_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
-	int total, avail, used, reserved, min, i;
+	int total, avail, used, max, reserved, min, i;
 	struct cap_wait	*cw;
 
-	ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
+	ceph_reservation_status(fsc, &total, &avail, &used, &max,
+				&reserved, &min);
 	seq_printf(s, "total\t\t%d\n"
 		   "avail\t\t%d\n"
 		   "used\t\t%d\n"
 		   "reserved\t%d\n"
 		   "min\t\t%d\n\n",
-		   total, avail, used, reserved, min);
+		   total, avail, used, max, reserved, min);
 	seq_printf(s, "ino                issued           implemented\n");
 	seq_printf(s, "-----------------------------------------------\n");
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 60aac3aee055..79aa42d9336c 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -700,7 +700,7 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
 			       struct ceph_cap_reservation *ctx);
 extern void ceph_reservation_status(struct ceph_fs_client *client,
 				    int *total, int *avail, int *used,
-				    int *reserved, int *min);
+				    int *max, int *reserved, int *min);
 
 
 
-- 
2.24.2 (Apple Git-127)

