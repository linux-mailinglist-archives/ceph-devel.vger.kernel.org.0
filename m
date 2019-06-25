Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B6F55236
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbfFYOlS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45634 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOlQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:16 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so18159240wre.12
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kfgg56rrIxnrF2y2atSD41gIa/zUpwvAKREsDRQXx4U=;
        b=tXVNv3PeNlz4vENvBFgPwrmXbz14WsDI9gNsfQOnR8mPAEG4RX93SW01zg7fIxw6bK
         2EDleLL710DhyeE8u2OS6Fu7m4Sj91M0e9gDiOWcPTkMXzCLJyLQuR+cZNrnV4reR3rW
         7YocIKeeks8W+O/YWYcylnuNaBD3BsKREvkluai/69zdsG5qOs34Q0iE5zCGesEeedXk
         RTM5hXXVNHPl2a/kagTR2HnN8m6/FWVMOipsRUfTHQQHYHEcEAzNKkJXsnjD0k3PWH3B
         L7TqbBKiX0nQXmSBUiSJOHTCljriiOdh3U61hNt9Y9S4q5V1M/JvVs4ZBvMeaHWeSNav
         QC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kfgg56rrIxnrF2y2atSD41gIa/zUpwvAKREsDRQXx4U=;
        b=T2XWv7fC+WImW81gu3qvzIB35zEA0vtBPez8MFu/SKmD8JKHZUFBP+eO4d0zMhFvCm
         3BTFDOFCDuaMuwsajHSIaVVAq7s6bHnU2LtRp7aThoPmPUOeN5/I4lPjkFzWa4732B70
         HoMbPsSgTbO4l0tf6sttSFEBd+d1yjSHbEmkO2gedfroEp25CyY+5FhUoftu6DFlrTuI
         kqUjym+obMIbLPb3Gy+V4VXo9uG6d5TKkAN9Ljffnv56PPJn2ZIXwcjaXCbTQ8F5Lkea
         yAm49JQXI8ejGFA78qanqr/v+tN+CNDM9BAdDcWhulJWEXiZC4f75DxpM1OYO5fTr0jJ
         o1NQ==
X-Gm-Message-State: APjAAAUZw7NhS2Vx1+UlR8Gc6VwI/5DUUYbJJTrHjnDFT6SHUNPsWEM+
        Q2BtClOSmdAjaV2NF7sWDo0OKQpYDu4=
X-Google-Smtp-Source: APXvYqy8KV/g1AgsDy4kK3IEqjyGFpQZPpH0UAkCYLGYUsc8MvgoAjPdAGMJB07GKUHn8Rk9YSc/7Q==
X-Received: by 2002:adf:ec0c:: with SMTP id x12mr22107487wrn.342.1561473675001;
        Tue, 25 Jun 2019 07:41:15 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:14 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 07/20] rbd: factor out rbd_osd_setup_copyup()
Date:   Tue, 25 Jun 2019 16:40:58 +0200
Message-Id: <20190625144111.11270-8-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 5c34fe215c63..e059a8139e4f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1861,6 +1861,21 @@ static int rbd_osd_setup_stat(struct ceph_osd_request *osd_req, int which)
 	return 0;
 }
 
+static int rbd_osd_setup_copyup(struct ceph_osd_request *osd_req, int which,
+				u32 bytes)
+{
+	struct rbd_obj_request *obj_req = osd_req->r_priv;
+	int ret;
+
+	ret = osd_req_op_cls_init(osd_req, which, "rbd", "copyup");
+	if (ret)
+		return ret;
+
+	osd_req_op_cls_request_data_bvecs(osd_req, which, obj_req->copyup_bvecs,
+					  obj_req->copyup_bvec_count, bytes);
+	return 0;
+}
+
 static int count_write_ops(struct rbd_obj_request *obj_req)
 {
 	return 2; /* setallochint + write/writefull */
@@ -2560,14 +2575,10 @@ static int rbd_obj_issue_copyup_empty_snapc(struct rbd_obj_request *obj_req,
 	if (IS_ERR(osd_req))
 		return PTR_ERR(osd_req);
 
-	ret = osd_req_op_cls_init(osd_req, 0, "rbd", "copyup");
+	ret = rbd_osd_setup_copyup(osd_req, 0, bytes);
 	if (ret)
 		return ret;
 
-	osd_req_op_cls_request_data_bvecs(osd_req, 0,
-					  obj_req->copyup_bvecs,
-					  obj_req->copyup_bvec_count,
-					  bytes);
 	rbd_osd_format_write(osd_req);
 
 	ret = ceph_osdc_alloc_messages(osd_req, GFP_NOIO);
@@ -2604,15 +2615,9 @@ static int rbd_obj_issue_copyup_ops(struct rbd_obj_request *obj_req, u32 bytes)
 		return PTR_ERR(osd_req);
 
 	if (bytes != MODS_ONLY) {
-		ret = osd_req_op_cls_init(osd_req, which, "rbd",
-					  "copyup");
+		ret = rbd_osd_setup_copyup(osd_req, which++, bytes);
 		if (ret)
 			return ret;
-
-		osd_req_op_cls_request_data_bvecs(osd_req, which++,
-						  obj_req->copyup_bvecs,
-						  obj_req->copyup_bvec_count,
-						  bytes);
 	}
 
 	switch (img_req->op_type) {
-- 
2.19.2

