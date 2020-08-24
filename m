Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839CA24F158
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 05:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgHXDBK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Aug 2020 23:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgHXDBJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 23 Aug 2020 23:01:09 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD4BC061573;
        Sun, 23 Aug 2020 20:01:09 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y6so3518980plk.10;
        Sun, 23 Aug 2020 20:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sd+e9mqpssttKPHG4Vmc6RWj6G6G48PRDU4F/RVT5Ho=;
        b=ZdGyEdWrQTveFGjbRMDO8OjW4bOlMQM5qKDRp3leiKZ51A4hPjROMAfDMggtFBqpZK
         d7C/TwKkIM4h46aPUIB9e48MiECI07EnmmfpcmlEFkZg6XTVmXN525aXeFItEqlyfKh6
         p5p4/FknIqY4PvcSJeeCmvW9bogn4f63HDddphzkShoSLoUnPN886F5kpZCYQRmTcL7Z
         YYsZ4wnP7Idwi5itH2j6BYsGBm6ZMKRxcFlTEkE/byZQvNYCQIEs8A1F4M+49RX9wDB9
         zDwIr0r8b2NLhY0cLNxKWHdvqRVsoeWs59go1QwpgeYBv0bNddx4m2jLG1M0495anJj8
         35lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sd+e9mqpssttKPHG4Vmc6RWj6G6G48PRDU4F/RVT5Ho=;
        b=liUqLiOZSKJstgpPrfvXzYfIPlY3ZlVcnThQBMF9n7tOOtuuU1RY8/34pO8oNpjmSZ
         OxRmWkbLwDFlp9UnMZcomlh0wfq57lm0qw9sek0Wn1xQMgP4qzHY+xeA7BABE6Ug2tOj
         nmzsEk82QF1yG/VFKsxjzm03yHdhQHeLOFyPJ1m1fZ0EBpQmEcd3cy9gsH6aNTTbm/IE
         UXccOcEPmu0I7COvJSHiAhdxhL4isjAbErKWJn0qHsSPxqWAYSCcYBuy/0P4szYbg2KX
         CMlzU86VfDu7+/dOtImEAQ8XL7CRZrPumI0i4Dkk8rjRmiob6Gz2fCRD0zCPD3MhnEQB
         0Urw==
X-Gm-Message-State: AOAM530QY2iLwCEfFk/PBpX1/YwytIujcLMHL2Ka/zYJ+nJ+ldGw+76t
        +jxbKJ3+C2gqgRwsqtMF+vk=
X-Google-Smtp-Source: ABdhPJzeyhiSO1vJo2MHuImYOXNbsVyKEJazgLqADtaMajhDvY5Q6r8/3E2YNHow3p8CiRT1+AIZjA==
X-Received: by 2002:a17:90a:c394:: with SMTP id h20mr3092215pjt.22.1598238069049;
        Sun, 23 Aug 2020 20:01:09 -0700 (PDT)
Received: from localhost.localdomain ([122.224.153.227])
        by smtp.gmail.com with ESMTPSA id y65sm9328813pfb.155.2020.08.23.20.01.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Aug 2020 20:01:08 -0700 (PDT)
From:   Yanhu Cao <gmayyyha@gmail.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yanhu Cao <gmayyyha@gmail.com>
Subject: [PATCH] ceph: add column 'mds' to show caps in more user friendly
Date:   Mon, 24 Aug 2020 11:00:58 +0800
Message-Id: <20200824030058.37786-1-gmayyyha@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In multi-mds, the 'caps' debugfs file will have duplicate ino,
add the 'mds' column to indicate which mds session the cap belongs to.

Signed-off-by: Yanhu Cao <gmayyyha@gmail.com>
---
 fs/ceph/debugfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 97539b497e4c..47f8971a9c52 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -202,7 +202,8 @@ static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
 {
 	struct seq_file *s = p;
 
-	seq_printf(s, "0x%-17lx%-17s%-17s\n", inode->i_ino,
+	seq_printf(s, "0x%-17lx%-3d%-17s%-17s\n", inode->i_ino,
+		   cap->session->s_mds,
 		   ceph_cap_string(cap->issued),
 		   ceph_cap_string(cap->implemented));
 	return 0;
@@ -222,8 +223,8 @@ static int caps_show(struct seq_file *s, void *p)
 		   "reserved\t%d\n"
 		   "min\t\t%d\n\n",
 		   total, avail, used, reserved, min);
-	seq_printf(s, "ino                issued           implemented\n");
-	seq_printf(s, "-----------------------------------------------\n");
+	seq_printf(s, "ino              mds  issued           implemented\n");
+	seq_printf(s, "--------------------------------------------------\n");
 
 	mutex_lock(&mdsc->mutex);
 	for (i = 0; i < mdsc->max_sessions; i++) {
-- 
2.24.3 (Apple Git-128)

