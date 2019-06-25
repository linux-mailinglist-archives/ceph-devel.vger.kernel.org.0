Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905C655245
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfFYOlf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:35 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:52163 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731717AbfFYOl1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:27 -0400
Received: by mail-wm1-f53.google.com with SMTP id 207so3131705wma.1
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cmsVZa69UCb1l4mPg+VwA9ttKDwUdAd1xXDMfo8o/jI=;
        b=qNpjuqRSdKKOg9ErhDmu9wj0wj/Q3yFQSNVSoqei1wZHy1AcxDNv3ETUjwdVr8iAZl
         4lYkwnlIDiJQw5yMwqLRyOjKEK8UrZLTGeB/itMKoCgNWnR1zHn6h3Ke8NBvqw5zIGFH
         urcyJrr0d1+j2ddkJ8HsiFdDVF/OS/5RFoNINGJAl4IgD+v2Kxl9xSV9m/XwuMLc6j/Y
         W4APb2ayyCXBbGCRKqorHpiUzu5B+4NVSjs1uI/02sg5FwhJj2ZtgjpYXF2uqnFTG5+A
         xHFDPO44kCo3mAJSeCyG2jias/XmfNfT1Vgyzb3zRBCDB9lbMld0ruVXlHrnHKlxJ8Me
         FB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cmsVZa69UCb1l4mPg+VwA9ttKDwUdAd1xXDMfo8o/jI=;
        b=s7J6u25uSR5XkIchgp7lB2Gnm3gxYdzgYcb3zw48H8uBCQ+4GTVKo6UhTBUjlrTbhl
         K0EoVGJ45K8uNT23wSEYIwHHscwVnz7atrj7bkAfs7NTYYSmmfI0Lh4xuhHlcjBDZ3or
         nEJPJC+dkvfJDepzgd9GW/7ghPNWqvlPFg//7oTRyet+iADKE5ZzfqO6rTbS753cbPTC
         rFlfoNG2o5PoTpk4wjhVdJf/ZPqP6spk2L0H52kuTeVLQJ3gCOFDHGcgI/2WleAC8i8x
         h98YfCfm/Jbp6AsrPwyLJxQut4rpMCQy73mj3iPUffinzjS2VCGjrED6a8wSZrEhdsVn
         Dl1w==
X-Gm-Message-State: APjAAAVfW+yiCwRBakA+adVyAm1OpT9VcAfGLiMvlN0f6q5Nx7EWuOfS
        vKzHHbFbQeAFmlV3YZnqMzdUhsf3IRg=
X-Google-Smtp-Source: APXvYqy4eEcEav5LoW8BrvWKtN683f8+SK2EOEGqWSwYSu3qjcx8c6y0OKEVpX2skoiJWB+91uvq9w==
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr19687691wmc.21.1561473684600;
        Tue, 25 Jun 2019 07:41:24 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:24 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 17/20] libceph: export osd_req_op_data() macro
Date:   Tue, 25 Jun 2019 16:41:08 +0200
Message-Id: <20190625144111.11270-18-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We already have one exported wrapper around it for extent.osd_data and
rbd_object_map_update_finish() needs another one for cls.request_data.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/osd_client.h | 8 ++++++++
 net/ceph/osd_client.c           | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index edb191c40a5c..44100a4f0808 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -389,6 +389,14 @@ extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb);
 void ceph_osdc_abort_requests(struct ceph_osd_client *osdc, int err);
 
+#define osd_req_op_data(oreq, whch, typ, fld)				\
+({									\
+	struct ceph_osd_request *__oreq = (oreq);			\
+	unsigned int __whch = (whch);					\
+	BUG_ON(__whch >= __oreq->r_num_ops);				\
+	&__oreq->r_ops[__whch].typ.fld;					\
+})
+
 extern void osd_req_op_init(struct ceph_osd_request *osd_req,
 			    unsigned int which, u16 opcode, u32 flags);
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index cc2bf296583d..22e8ccc1f975 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -171,14 +171,6 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
 	osd_data->num_bvecs = num_bvecs;
 }
 
-#define osd_req_op_data(oreq, whch, typ, fld)				\
-({									\
-	struct ceph_osd_request *__oreq = (oreq);			\
-	unsigned int __whch = (whch);					\
-	BUG_ON(__whch >= __oreq->r_num_ops);				\
-	&__oreq->r_ops[__whch].typ.fld;					\
-})
-
 static struct ceph_osd_data *
 osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
 {
-- 
2.19.2

