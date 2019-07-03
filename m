Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855265E8CB
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 18:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbfGCQ07 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 12:26:59 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37002 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbfGCQ07 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 12:26:59 -0400
Received: by mail-pl1-f194.google.com with SMTP id bh12so1519708plb.4;
        Wed, 03 Jul 2019 09:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=E30AtsSzpPvKciP/fqaMcoGmTNCMnbS6fwW6uwARnYg=;
        b=a2uPqQcjPYqdJzxBayU5MQMtnUneq8OSPioS2FpvwZFyD61LRCcg0pBNNY/Sy4mCiZ
         LibrPHxKFsD3kBe3ArnR9IK+SjUfr7bQNukpggHhHsl5rc7hL7xB0jy0JOdj9pRxSgLJ
         vOFfgkxQlkjieY8ScN99ZSOV6niI24qyXEm3lAyMlE7WMahllWEGE78SHxEHYaZl/pMb
         KEfRknJ4X/o8/JjZzQXE2U++FPaeUN5fIPdM1ayRKe2v9Binp70GZj//gb+TMqhofdUN
         4UO7fO2TezaJNcnOhPb/ZiUAdHPRerE+tiSrQ6ex10QhoEuYTOLOtxvzCXbxG97JE6r7
         zGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=E30AtsSzpPvKciP/fqaMcoGmTNCMnbS6fwW6uwARnYg=;
        b=DoYVhYlESai+ooUWLaijD1Hw7sFFavLL+dF5FEA7ThQkT73/lKHBQFIr2rcpByL0Ht
         4VDQE65jKzku0iJXEr+iQ4Urm4iU8O3u351iT8dIyCTeOb8iM4/rCjoqtpAtyzpBO/Ee
         nyeiDpGMW9jylegdOHVCAl0TKIpSL50DcxVq63ekBhUA2LW3jjR2D82O1cyXn5JkRYlJ
         axpPWCmt3UkdI8n92aYZubod6jFwcOfoIdTpABOoFlobQ2RQoP2vUo2eA0h5UjjUNWnA
         lAj0GT1AeRT886estyx0rqfM+XzIjWodk6e9MAPm+w0RVVRVJDU/reTPjltsJOkq/J46
         9IhA==
X-Gm-Message-State: APjAAAWbCPe7rpzkJRGZfPp7Iai5kJ7uUEaoMtjbuGmAjVdC1/GSW2bt
        7gwY6gQ2r+7VqAInfxtBVjpscBODfSM=
X-Google-Smtp-Source: APXvYqy7+JNCNy+2vkh0YSgmw93iRcWmokjwECkcnIyuMHNsMFvDfiXE+zEAdocXmFYroyiOBuSyDg==
X-Received: by 2002:a17:902:70cc:: with SMTP id l12mr43495583plt.87.1562171218749;
        Wed, 03 Jul 2019 09:26:58 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id 10sm5230745pfb.30.2019.07.03.09.26.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 09:26:58 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Alex Elder <elder@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH v2 04/35] block: Use kmemdup rather than duplicating its implementation
Date:   Thu,  4 Jul 2019 00:26:50 +0800
Message-Id: <20190703162650.32045-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

kmemdup is introduced to duplicate a region of memory in a neat way.
Rather than kmalloc/kzalloc + memcpy, which the programmer needs to
write the size twice (sometimes lead to mistakes), kmemdup improves
readability, leads to smaller code and also reduce the chances of mistakes.
Suggestion to use kmemdup rather than using kmalloc/kzalloc + memcpy.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
Changes in v2:
  - Fix a typo in commit message (memset -> memcpy)

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

