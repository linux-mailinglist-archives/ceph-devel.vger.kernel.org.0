Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B26E055237
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbfFYOlS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44310 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731158AbfFYOlS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id r16so18159657wrl.11
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gHQJOX947kOtkb2gjtZGqnw55LHsHg48YQn88Ila+kQ=;
        b=pGnfA6wPSKNJ4kWGSC1AXp7PBrU/rDpwNMqH45vt95Hq2GUjI3y7osByT5SFMrkQZ2
         ap98rhh1k5eiFPYH6fEQEhtT6uZAWBdjNuUV2VGkWSQgvrgyAYGPfxBN/4zpVsx262Cx
         ipOI60O9XgzwAAdPo6BmyAifuZGz902BzDZBsOi9KpoOBtyoTFx2Y2gIw0EZyYSdMJ/I
         aWmrjGy1wQimpqMqv8DgieTdlLp2jlk7JuKLABHf+rR7YVyysY5XD7Hr6BvE/HHaZpuJ
         Hrx/dvQfdKqjn5Og+QQ6qIuUCv8ih6IQJoh6JP2pMsU8z3XjmpaIzGwNV27bg+tXI7OU
         Lv3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gHQJOX947kOtkb2gjtZGqnw55LHsHg48YQn88Ila+kQ=;
        b=L4/cbg7Jh9CJBI8uz07RFghgZ2sPmj28f8etq4T8T33fjGYps0thj3Sur9l14dGRun
         8TrbDjtIDNYLjlTmIA2x1Ls4eEHH1mqXXpLQ8wOZgXrBuzu375tzQ6NwyCfGZvmGIWmz
         y0bo073NJWLAG8G6FJx9nyHmT4n4VJrh/3zfbdonBnIYQi9YZgUiiYWa2HKsa2GTNKMS
         729bnVTynm6EbEWU6J7tguPskWtzRMyIZT/tqTLBKNYcrUYxR7Fp+c/lTaa81VL7eFZg
         e2KfGBTcXYo+tO50Qa9YNcP6rpLc/KqiqnYiFObN1kidlpPN/X9kTjnbbXjh0IP34ILH
         w+0A==
X-Gm-Message-State: APjAAAWNmNmgFqc+3oZmI5PACTDCBKVwDoP+QYNsmHY9f2VjUCLpMYN/
        qcOdJMNi785g2yogjP3cbVL3a8pQl9c=
X-Google-Smtp-Source: APXvYqzVRE8kpaWUFDYeF6m3Uj05VKVnKyF4aPF3zdscJ2JQ7tyQA/f1U94r1N333zvJU3UeJaGfmw==
X-Received: by 2002:adf:ce88:: with SMTP id r8mr40114257wrn.42.1561473676301;
        Tue, 25 Jun 2019 07:41:16 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:15 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 08/20] rbd: factor out __rbd_osd_setup_discard_ops()
Date:   Tue, 25 Jun 2019 16:40:59 +0200
Message-Id: <20190625144111.11270-9-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

With obj_req->xferred removed, obj_req->ex.oe_off and obj_req->ex.oe_len
can be updated if required for alignment.  Previously the new offset and
length weren't stored anywhere beyond rbd_obj_setup_discard().

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e059a8139e4f..acc9017034d7 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1943,12 +1943,27 @@ static u16 truncate_or_zero_opcode(struct rbd_obj_request *obj_req)
 					  CEPH_OSD_OP_ZERO;
 }
 
+static void __rbd_osd_setup_discard_ops(struct ceph_osd_request *osd_req,
+					int which)
+{
+	struct rbd_obj_request *obj_req = osd_req->r_priv;
+
+	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
+		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
+		osd_req_op_init(osd_req, which, CEPH_OSD_OP_DELETE, 0);
+	} else {
+		osd_req_op_extent_init(osd_req, which,
+				       truncate_or_zero_opcode(obj_req),
+				       obj_req->ex.oe_off, obj_req->ex.oe_len,
+				       0, 0);
+	}
+}
+
 static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	struct ceph_osd_request *osd_req;
-	u64 off = obj_req->ex.oe_off;
-	u64 next_off = obj_req->ex.oe_off + obj_req->ex.oe_len;
+	u64 off, next_off;
 	int ret;
 
 	/*
@@ -1961,10 +1976,17 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 	 */
 	if (rbd_dev->opts->alloc_size != rbd_dev->layout.object_size ||
 	    !rbd_obj_is_tail(obj_req)) {
-		off = round_up(off, rbd_dev->opts->alloc_size);
-		next_off = round_down(next_off, rbd_dev->opts->alloc_size);
+		off = round_up(obj_req->ex.oe_off, rbd_dev->opts->alloc_size);
+		next_off = round_down(obj_req->ex.oe_off + obj_req->ex.oe_len,
+				      rbd_dev->opts->alloc_size);
 		if (off >= next_off)
 			return 1;
+
+		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
+		     obj_req, obj_req->ex.oe_off, obj_req->ex.oe_len,
+		     off, next_off - off);
+		obj_req->ex.oe_off = off;
+		obj_req->ex.oe_len = next_off - off;
 	}
 
 	/* reverse map the entire object onto the parent */
@@ -1979,19 +2001,8 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 	if (IS_ERR(osd_req))
 		return PTR_ERR(osd_req);
 
-	if (rbd_obj_is_entire(obj_req) && !obj_req->num_img_extents) {
-		rbd_assert(obj_req->flags & RBD_OBJ_FLAG_DELETION);
-		osd_req_op_init(osd_req, 0, CEPH_OSD_OP_DELETE, 0);
-	} else {
-		dout("%s %p %llu~%llu -> %llu~%llu\n", __func__,
-		     obj_req, obj_req->ex.oe_off, obj_req->ex.oe_len,
-		     off, next_off - off);
-		osd_req_op_extent_init(osd_req, 0,
-				       truncate_or_zero_opcode(obj_req),
-				       off, next_off - off, 0, 0);
-	}
-
 	obj_req->write_state = RBD_OBJ_WRITE_START;
+	__rbd_osd_setup_discard_ops(osd_req, 0);
 	rbd_osd_format_write(osd_req);
 	return 0;
 }
-- 
2.19.2

