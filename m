Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C92C55241
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731755AbfFYOl1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54325 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731601AbfFYOl0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so3116185wme.4
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NiSiJcNheybEZU5a1VpxxQm3nqn3bG09ZHed3XHRzMQ=;
        b=pOyTIfBx3rQ+6obazteXWNaySDGYUIO9n2G3w6l1N7f8Yb0/3DRKQFtu2ZCSIJBNxY
         yv9eI37NMvc+u0UIbFc7VWOHyE/vTFyOEoKw1gEPUZ7q1UN9i933uppDFTjNvRLL2F3v
         58sM4WNKDkL9g4W7ZJwOH4+7+RnOpVEcsXoMx8DuID8mJkrOO8tOYcviaL+RBqxHkUoW
         ks4I2/XgR2PPoqe0IQovYr6zGGbIqzoG5DZMPQs01yK3DjVXU5WeH0pXgIoEUVPw209B
         677wy5vzfJQk2Ic/IZnI/UFDdPUS306In0hWZTIF1AbpsMpFuEoXkFngaPn2m7BIJWAO
         ZkCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NiSiJcNheybEZU5a1VpxxQm3nqn3bG09ZHed3XHRzMQ=;
        b=JU9byEtfMtkUJynJ/NSx4fxpv09Hwl4R4IfQPrCum9qUJTQEPJU6BRPvXU5eWYJsKJ
         d2EzDxg5H3CZ27UsRFs/SwwkY8cSKCGFj1l5ykdxvKTBtpokWEWnBC3dHI4618/xPoed
         SVCA2qbE8NrOa570Ol0DuLORupOxdM6gEekG3br1b6er4kNWZM9CMa0gm9S3oEfdv6hg
         MMVT/r7Lcp3IO1gR6h628F2tJ4HLXGpXtk6a7Yimgh+5kiZisIcr6+roguR70guYMpvN
         VKki4rFJ26hfCc2VkJQK5rVZn0yvAgs3nCQgY/tl7nBDpeY2PgveUZMQlmoV1gOZZQgs
         KW4Q==
X-Gm-Message-State: APjAAAWQq1J3G4CA1TBwV4TctAMlDnC6st4x7zAUsum7NWbgxuBZAIQl
        KlGN5TSpzVKCtLVYUDvU/JynpoyS2ZE=
X-Google-Smtp-Source: APXvYqyysShA/GuWjuRBZhTC4CpXAsLKCakMcC0DkdvLM6tfbwXaOqwG2NSUhhws/3oylQ2pnwji6A==
X-Received: by 2002:a7b:c776:: with SMTP id x22mr19672293wmk.55.1561473683772;
        Tue, 25 Jun 2019 07:41:23 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:23 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 16/20] libceph: change ceph_osdc_call() to take page vector for response
Date:   Tue, 25 Jun 2019 16:41:07 +0200
Message-Id: <20190625144111.11270-17-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This will be used for loading object map.  rbd_obj_read_sync() isn't
suitable because object map must be accessed through class methods.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c             |  8 ++++----
 include/linux/ceph/osd_client.h |  2 +-
 net/ceph/cls_lock_client.c      |  2 +-
 net/ceph/osd_client.c           | 10 +++++-----
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index fd3f248ba9c2..c9f88b0cb730 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4072,7 +4072,7 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
 
 	ret = ceph_osdc_call(osdc, oid, oloc, RBD_DRV_NAME, method_name,
 			     CEPH_OSD_FLAG_READ, req_page, outbound_size,
-			     reply_page, &inbound_size);
+			     &reply_page, &inbound_size);
 	if (!ret) {
 		memcpy(inbound, page_address(reply_page), inbound_size);
 		ret = inbound_size;
@@ -5098,7 +5098,7 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
 
 	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			     "rbd", "parent_get", CEPH_OSD_FLAG_READ,
-			     req_page, sizeof(u64), reply_page, &reply_len);
+			     req_page, sizeof(u64), &reply_page, &reply_len);
 	if (ret)
 		return ret == -EOPNOTSUPP ? 1 : ret;
 
@@ -5110,7 +5110,7 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
 
 	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			     "rbd", "parent_overlap_get", CEPH_OSD_FLAG_READ,
-			     req_page, sizeof(u64), reply_page, &reply_len);
+			     req_page, sizeof(u64), &reply_page, &reply_len);
 	if (ret)
 		return ret;
 
@@ -5141,7 +5141,7 @@ static int __get_parent_info_legacy(struct rbd_device *rbd_dev,
 
 	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
 			     "rbd", "get_parent", CEPH_OSD_FLAG_READ,
-			     req_page, sizeof(u64), reply_page, &reply_len);
+			     req_page, sizeof(u64), &reply_page, &reply_len);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 2294f963dab7..edb191c40a5c 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -497,7 +497,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 		   const char *class, const char *method,
 		   unsigned int flags,
 		   struct page *req_page, size_t req_len,
-		   struct page *resp_page, size_t *resp_len);
+		   struct page **resp_pages, size_t *resp_len);
 
 extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
 			       struct ceph_vino vino,
diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
index 4cc28541281b..56bbfe01e3ac 100644
--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -360,7 +360,7 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
 	dout("%s lock_name %s\n", __func__, lock_name);
 	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "get_info",
 			     CEPH_OSD_FLAG_READ, get_info_op_page,
-			     get_info_op_buf_size, reply_page, &reply_len);
+			     get_info_op_buf_size, &reply_page, &reply_len);
 
 	dout("%s: status %d\n", __func__, ret);
 	if (ret >= 0) {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9a8eca5eda65..cc2bf296583d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5044,12 +5044,12 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 		   const char *class, const char *method,
 		   unsigned int flags,
 		   struct page *req_page, size_t req_len,
-		   struct page *resp_page, size_t *resp_len)
+		   struct page **resp_pages, size_t *resp_len)
 {
 	struct ceph_osd_request *req;
 	int ret;
 
-	if (req_len > PAGE_SIZE || (resp_page && *resp_len > PAGE_SIZE))
+	if (req_len > PAGE_SIZE)
 		return -E2BIG;
 
 	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_NOIO);
@@ -5067,8 +5067,8 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 	if (req_page)
 		osd_req_op_cls_request_data_pages(req, 0, &req_page, req_len,
 						  0, false, false);
-	if (resp_page)
-		osd_req_op_cls_response_data_pages(req, 0, &resp_page,
+	if (resp_pages)
+		osd_req_op_cls_response_data_pages(req, 0, resp_pages,
 						   *resp_len, 0, false, false);
 
 	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
@@ -5079,7 +5079,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 	ret = ceph_osdc_wait_request(osdc, req);
 	if (ret >= 0) {
 		ret = req->r_ops[0].rval;
-		if (resp_page)
+		if (resp_pages)
 			*resp_len = req->r_ops[0].outdata_len;
 	}
 
-- 
2.19.2

