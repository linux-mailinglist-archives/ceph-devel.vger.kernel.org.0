Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCEA55243
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbfFYOla (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38547 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731697AbfFYOl3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:29 -0400
Received: by mail-wr1-f68.google.com with SMTP id d18so18210483wrs.5
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBDzcKemw5w5t3/Ex4/+gKGh8Auku8BKKDXCCz1dO1w=;
        b=nZrKjMlnK18M4BAH4U/E66R11Ob8xsS2DrAeJQtBZ7QTqidi5gNG2gMxjl+k9XiBPb
         P+CC+MO00KtwqGm1Lso37GL8xBCDp5ZgoCKoP49z+NXuK4QCbWgIJJPie5l/vK0nUWSV
         fIkoL39x+5CsH5vFDYvBIzgWQKKEKLLv9wwk2IuMqGYVGzCAxKeq0al+W9G0k7azn/UR
         0ukuCgJ/9HY4PwqXJTdAlQgxgEcU6BTtyUjPTinuHFnzSqfzItNEQALhgySHjW4HMAP9
         BhDhbVldhp5NR1XPY6+ru/C+uqOJ32V/bi1IsGvIqsg8FEpMwjz9rd24QxnaGkceam+O
         fgzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBDzcKemw5w5t3/Ex4/+gKGh8Auku8BKKDXCCz1dO1w=;
        b=jEdzqRs/hr9q/Q3EET5ov93+rb60G3z7AdhZY635PHGNbM5wDgPkystxzuCIcrYmCS
         fOx46YqtKdTboDcn7MGi4eZBsuTBAeTH79G0OF38tdieXDPVh50QR6bmScbYmYaVc0bA
         wxbYSXJ4eqg46A+uy1SWAIFER6Rdo5WRYW//gadQxJkI1OR+imMvZwxBV0pnhJyCiPuT
         Pms3FUh6UjEl/fmb65JqFxH18T180yWw59/El0putDkVbTQOf9E7s4vCnP1j6HhnYHFI
         ktLp8ElCliBMDkaIB6Ei4PF+othfcn0Qa3dC/peX+kS+FbCmJy6KXw05Y1Ajovh+kPwz
         QMGA==
X-Gm-Message-State: APjAAAUOypFW9Y++VS05SHEwrfWMRRyxGJWRki/eTi8Epi1lOu1p4Bp9
        kKUTWHNVKmtIWYqC+8YWHIFt6k6frBw=
X-Google-Smtp-Source: APXvYqyHDWCo6j/YBTFbV/Q5oGCYoHB9f9ULCARZbkvNyhKPXT7u9T8PEF/t66EJAtG4zD65353PBg==
X-Received: by 2002:a5d:42ca:: with SMTP id t10mr3591820wrr.202.1561473687513;
        Tue, 25 Jun 2019 07:41:27 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:27 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 20/20] rbd: setallochint only if object doesn't exist
Date:   Tue, 25 Jun 2019 16:41:11 +0200
Message-Id: <20190625144111.11270-21-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

setallochint is really only useful on object creation.  Continue
hinting unconditionally if object map cannot be used.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 756595f5fbc9..5dc217530f0f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2366,9 +2366,12 @@ static void __rbd_osd_setup_write_ops(struct ceph_osd_request *osd_req,
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	u16 opcode;
 
-	osd_req_op_alloc_hint_init(osd_req, which++,
-				   rbd_dev->layout.object_size,
-				   rbd_dev->layout.object_size);
+	if (!use_object_map(rbd_dev) ||
+	    !(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST)) {
+		osd_req_op_alloc_hint_init(osd_req, which++,
+					   rbd_dev->layout.object_size,
+					   rbd_dev->layout.object_size);
+	}
 
 	if (rbd_obj_is_entire(obj_req))
 		opcode = CEPH_OSD_OP_WRITEFULL;
@@ -2511,9 +2514,15 @@ static int rbd_obj_init_zeroout(struct rbd_obj_request *obj_req)
 
 static int count_write_ops(struct rbd_obj_request *obj_req)
 {
-	switch (obj_req->img_request->op_type) {
+	struct rbd_img_request *img_req = obj_req->img_request;
+
+	switch (img_req->op_type) {
 	case OBJ_OP_WRITE:
-		return 2; /* setallochint + write/writefull */
+		if (!use_object_map(img_req->rbd_dev) ||
+		    !(obj_req->flags & RBD_OBJ_FLAG_MAY_EXIST))
+			return 2; /* setallochint + write/writefull */
+
+		return 1; /* write/writefull */
 	case OBJ_OP_DISCARD:
 		return 1; /* delete/truncate/zero */
 	case OBJ_OP_ZEROOUT:
-- 
2.19.2

