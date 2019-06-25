Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0202C55242
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfFYOl2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:28 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37588 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOl1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so3256733wme.2
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+hidNeN0ILCjWSG8uZu8Qm9rtlUL7iqKVkEkqnG59rk=;
        b=ALr9dAQJ5VchWladGxwwtCFhe4KLVbbmmJkpdWmKswYodbah2s+52xpxZFwljQus4c
         t0natdUXsp0A9N7e6FEd7+4wUSbJzhoJ+494RDZq0vwqdNCGDig88Aeh4Ve8Y0h4NprX
         WM9fw5XrDDa2PijN2SYMcMx07Uc728iC6X9ATc8PqFJ2CbxfBYO3rhML4wOfRJkdlZb5
         S5n/KFS0s9rFbo4fVyRbj5gBmLZ/ljj197YN596Hn4wXBTO2TC7uExMNAUAdrtMgRO+M
         sR5Rbg9jytVBDKC0UH8iPlFhN29mANCXqRwmkYnXle9oz1ujZpL4DZpReerfUzYr39Ib
         MyDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+hidNeN0ILCjWSG8uZu8Qm9rtlUL7iqKVkEkqnG59rk=;
        b=MGRTS24RiZom0q20sTqF6fvKWrgbgqgKQCiXULxSLtjL3DiiXzn2VM9pMGnvas3g6W
         xH/Upt/ODB6LgBU7rkNxVjRzXlqmlBeX/B8O/mclf/0o+PCLuzEWFmDzHNyU2Ls1TDVt
         1m8rqGsz+3KYN5zk9Tvod8n1jp/0TPa2BJKMo5VaYClFydMxMi5NYLtw1UnMSEkYceyt
         ai8iybeRXAPxTnKx6hAiykj0M9LSUcg611C+bXPpJ3SHremY2aflbgCv4sk9kx0Eb3tF
         F113wCMf2IYe+o8rpwP/xhR/l5CbYZjQ2UL3100s1Q2dSDIOGr4aZIdtrzs7emXYocfN
         Qndw==
X-Gm-Message-State: APjAAAXLgJwaMd6iWNXc7RKFjtUy50YzGbffDDUR2zbyt3N8fPrbTc28
        5qWRY96qkqv2tMls3GrDwSHPsa53v0o=
X-Google-Smtp-Source: APXvYqw0h8hP1nd3aJk2A2BTPAe7AV/+XkChYctV5sNlOthfGkx659QwedcTgn7/gpEOHjYTIjiOog==
X-Received: by 2002:a1c:96c7:: with SMTP id y190mr18449828wmd.87.1561473685653;
        Tue, 25 Jun 2019 07:41:25 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:25 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 18/20] rbd: call rbd_dev_mapping_set() from rbd_dev_image_probe()
Date:   Tue, 25 Jun 2019 16:41:09 +0200
Message-Id: <20190625144111.11270-19-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Snapshot object map will be loaded in rbd_dev_image_probe(), so we need
to know snapshot's size (as opposed to HEAD's size) sooner.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index c9f88b0cb730..671041b67957 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6014,6 +6014,7 @@ static void rbd_dev_unprobe(struct rbd_device *rbd_dev)
 	struct rbd_image_header	*header;
 
 	rbd_dev_parent_put(rbd_dev);
+	rbd_dev_mapping_clear(rbd_dev);
 
 	/* Free dynamic fields from the header, then zero it out */
 
@@ -6114,7 +6115,6 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 static void rbd_dev_device_release(struct rbd_device *rbd_dev)
 {
 	clear_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
-	rbd_dev_mapping_clear(rbd_dev);
 	rbd_free_disk(rbd_dev);
 	if (!single_major)
 		unregister_blkdev(rbd_dev->major, rbd_dev->name);
@@ -6148,23 +6148,17 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
 	if (ret)
 		goto err_out_blkdev;
 
-	ret = rbd_dev_mapping_set(rbd_dev);
-	if (ret)
-		goto err_out_disk;
-
 	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
 	set_disk_ro(rbd_dev->disk, rbd_dev->opts->read_only);
 
 	ret = dev_set_name(&rbd_dev->dev, "%d", rbd_dev->dev_id);
 	if (ret)
-		goto err_out_mapping;
+		goto err_out_disk;
 
 	set_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
 	up_write(&rbd_dev->header_rwsem);
 	return 0;
 
-err_out_mapping:
-	rbd_dev_mapping_clear(rbd_dev);
 err_out_disk:
 	rbd_free_disk(rbd_dev);
 err_out_blkdev:
@@ -6265,6 +6259,10 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 		goto err_out_probe;
 	}
 
+	ret = rbd_dev_mapping_set(rbd_dev);
+	if (ret)
+		goto err_out_probe;
+
 	if (rbd_dev->header.features & RBD_FEATURE_LAYERING) {
 		ret = rbd_dev_v2_parent_info(rbd_dev);
 		if (ret)
-- 
2.19.2

