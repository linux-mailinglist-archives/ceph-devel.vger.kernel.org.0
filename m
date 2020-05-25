Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD431E04F0
	for <lists+ceph-devel@lfdr.de>; Mon, 25 May 2020 04:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388747AbgEYCvK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 24 May 2020 22:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388398AbgEYCvK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 24 May 2020 22:51:10 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C1C061A0E;
        Sun, 24 May 2020 19:51:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ci21so7949893pjb.3;
        Sun, 24 May 2020 19:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0KTulik1Nw6UnTFr4ECUxiGZmmAKN8Jgtu7klUu9+kQ=;
        b=nHmD6bYEjdy89LXBZiccA1HR8SKfRHmmze16HYNFa0BoHvddtGrEPfCuPiju0FY5e+
         uSJC6WC0bumFpfHFloVziH2bmU02a1x7InZshsa+uWm4aXZ82b2tUhtRxUjGckfI4tKp
         NhRuS0BL1ZY9BVw64howvx0RxHu0wa2RqJtbKNrcnl4E/z+YZa4ael/By/9AOqBxmjMS
         TXaWBcWmjNzdfyfK+u64fT5+XL9aguMsdRjFABayTixOyU6wOIAfdkLQhk6NLeRLr5Au
         an0BB1aWj7Qf69hjoQOHRfo1gf+lTKrggsprt5PKtxw6EwnlI6DC0ZcvZaxAzQFjeS+Z
         OV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0KTulik1Nw6UnTFr4ECUxiGZmmAKN8Jgtu7klUu9+kQ=;
        b=OBDFOlL6lAvKjo/F+vDiyHUlZo2J7TITemQAR7/gehVW5phMjcOMwmi111KGkVYLuw
         DB/7kzkLyb5/Vq77ph5XKnweEJHVMDzaa0avHDhsCpDpsXpCIYNHekh2oIMKt5q5poEx
         1elFVtWVFaux4IeOCHQtd5QjMdl6KF+z6SQQJvpDUJ9rg2BtlqFUrTxD4XkVczW7yylh
         PAXrQ3WnwPdyYdAQu6IGmxaTmfCp+cssq+cXs0dWCFuratO8HnkOzx6DcVqCV0vGqfKV
         SCG5QA7XizLMOvXuxnAWKMy3TddH9IyIiY3hlEfiU7dNK0mrdSLZ9is4EqNMitONRUWQ
         W0qA==
X-Gm-Message-State: AOAM532yAPSqxHQ8wVQRY/Ru71xvlD0uxCguRwCvP+o667gbWyrbZ3gU
        3CVmmQkKR8loiNBsPlJj1A2+xcVx
X-Google-Smtp-Source: ABdhPJyxXnHBQZJaKDgwKvPimEv4R6bFOVBQoKzLnbwCAZHVIm6ToC6cE/y5xwLAqIJ6dpY4QjQdUg==
X-Received: by 2002:a17:90a:fe96:: with SMTP id co22mr17356494pjb.220.1590375068185;
        Sun, 24 May 2020 19:51:08 -0700 (PDT)
Received: from MacBook-Pro.mshome.net ([122.224.153.228])
        by smtp.googlemail.com with ESMTPSA id l10sm11804420pfd.70.2020.05.24.19.51.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 19:51:07 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>,
        Yanhu Cao <jrcaoyanhu@jd.com>,
        kbuild test robot <lkp@intel.com>
Subject: [v2] ceph: show max caps in debugfs caps file
Date:   Mon, 25 May 2020 10:50:49 +0800
Message-Id: <20200525025049.4292-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

before
------
total		1286
avail		1005
used		281
reserved	0
min		1024

after
-----
total		1286
avail		1005
used		281
limit		261
reserved	0
min		1024

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
Signed-off-by: Yanhu Cao <jrcaoyanhu@jd.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 fs/ceph/caps.c       | 6 ++++--
 fs/ceph/debugfs.c    | 8 +++++---
 fs/ceph/mds_client.c | 1 +
 fs/ceph/mds_client.h | 4 +++-
 fs/ceph/super.h      | 2 +-
 5 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5f3aa4d607de..17191d6cd3b5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -404,8 +404,8 @@ void ceph_put_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap)
 }
 
 void ceph_reservation_status(struct ceph_fs_client *fsc,
-			     int *total, int *avail, int *used, int *reserved,
-			     int *min)
+			     int *total, int *avail, int *used, int *limit,
+			     int *reserved, int *min)
 {
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 
@@ -417,6 +417,8 @@ void ceph_reservation_status(struct ceph_fs_client *fsc,
 		*avail = mdsc->caps_avail_count;
 	if (used)
 		*used = mdsc->caps_use_count;
+	if (limit)
+		*limit = mdsc->caps_limit;
 	if (reserved)
 		*reserved = mdsc->caps_reserve_count;
 	if (min)
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 481ac97b4d25..617020261902 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -138,16 +138,18 @@ static int caps_show(struct seq_file *s, void *p)
 {
 	struct ceph_fs_client *fsc = s->private;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
-	int total, avail, used, reserved, min, i;
+	int total, avail, used, limit, reserved, min, i;
 	struct cap_wait	*cw;
 
-	ceph_reservation_status(fsc, &total, &avail, &used, &reserved, &min);
+	ceph_reservation_status(fsc, &total, &avail, &used,
+				&limit, &reserved, &min);
 	seq_printf(s, "total\t\t%d\n"
 		   "avail\t\t%d\n"
 		   "used\t\t%d\n"
+		   "limit\t\t%d\n"
 		   "reserved\t%d\n"
 		   "min\t\t%d\n\n",
-		   total, avail, used, reserved, min);
+		   total, avail, used, limit, reserved, min);
 	seq_printf(s, "ino                issued           implemented\n");
 	seq_printf(s, "-----------------------------------------------\n");
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7c63abf5bea9..d26bc065f5f5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1920,6 +1920,7 @@ int ceph_trim_caps(struct ceph_mds_client *mdsc,
 		   int max_caps)
 {
 	int trim_caps = session->s_nr_caps - max_caps;
+	mdsc->caps_limit = max_caps;
 
 	dout("trim_caps mds%d start: %d / %d, trim %d\n",
 	     session->s_mds, session->s_nr_caps, max_caps, trim_caps);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 903d9edfd4bf..840d47976dbb 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -445,7 +445,9 @@ struct ceph_mds_client {
 	struct		list_head cap_wait_list;
 	int		caps_total_count;    /* total caps allocated */
 	int		caps_use_count;      /* in use */
-	int		caps_use_max;	     /* max used caps */
+	int		caps_use_max;	     /* max used caps,
+						limited by client */
+	int		caps_limit;          /* limited by mds */
 	int		caps_reserve_count;  /* unused, reserved */
 	int		caps_avail_count;    /* unused, unreserved */
 	int		caps_min_count;      /* keep at least this many
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 60aac3aee055..052d7725761d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -700,7 +700,7 @@ extern void ceph_unreserve_caps(struct ceph_mds_client *mdsc,
 			       struct ceph_cap_reservation *ctx);
 extern void ceph_reservation_status(struct ceph_fs_client *client,
 				    int *total, int *avail, int *used,
-				    int *reserved, int *min);
+				    int *limit, int *reserved, int *min);
 
 
 
-- 
2.24.3 (Apple Git-128)

