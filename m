Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044B155232
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbfFYOlP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 10:41:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44298 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfFYOlO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:41:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id r16so18159312wrl.11
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qe/U9AKfQAWDBylF7c8/i1SeuzUZ8V2J8WgofUcdj6s=;
        b=ZbGgUIV2UA9IDOdEBPOO6oYnqkxCuYOVSucuEoqV7v3gt4CjDzZQCNpyriWGvfK1XD
         Yy051huoMoo4ff6DaVBriuhXPE1nZC+iB87CkQn+sPbTaPFk084I6DBbSEQY80MfBzOS
         cwuF/D8hn6ma/wbhKLSNSmrWwK+xQg8S+Kjb71RcxMxMj9qhm45Tg3nqMDML0P3kbn6t
         qdsc/8BLHGT5uCPD3s+mjr0JdPbkmVJoSpWTVy0NPjlzFLzZBoBFvnJqriJKPJZCi2Vn
         twS84s6ZY0cM/HpoOoEB3tKCP3BDctACE9q7Ih29SjsZrFAfbkw1zNsMNY1FtIOPvH0h
         0FCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qe/U9AKfQAWDBylF7c8/i1SeuzUZ8V2J8WgofUcdj6s=;
        b=CGE2tyVAZP61Ccg47JCg7OaSGiWmKgFkazTBFIn5bnzTlBJyL5DJx4Ep8XZ6PmJ4Li
         EKx2gbRTvguR55DtvOOJTFuB3YD0qCcpLw8ceBoxHDytjONQc9IpuL0MSXVKTbH5LSWJ
         wE3wqDjmL3f/y+OfhCneceKrJLcuCpKtJCbGkmpRicXd+Gk4jOW6AQMaqpgIyi1k3Kh/
         FQjwtpBSF3YiD9M0PStx9sWyPGEbt79k9GJasEvi2yMyczhzoKvKCLrqGfo4R3z0Hr//
         5Tw8gqVRSDPiYcbJQJcW6v/PMK6t/bkdckNCGOHh6O0FNDpAeL7mqx2xxr/MZ8yBZr5I
         Rb5Q==
X-Gm-Message-State: APjAAAU44PfTKZZSzDr9bCWh3WORFsn+tFxXXuTnl5Cqa9beJBTLg+pn
        TDOjuLaNRUsazJzLE0Ayb57pI4XXAmk=
X-Google-Smtp-Source: APXvYqw7CJXT20h++24GL0hwf9Fp/lNuuNTNtso6pNPYPL9ZgmbEB7hj4/sKejdKkGWF2OzN2wkZCQ==
X-Received: by 2002:adf:e311:: with SMTP id b17mr22937456wrj.11.1561473671414;
        Tue, 25 Jun 2019 07:41:11 -0700 (PDT)
Received: from kwango.redhat.com (ovpn-brq.redhat.com. [213.175.37.11])
        by smtp.gmail.com with ESMTPSA id f2sm20282378wrq.48.2019.06.25.07.41.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 07:41:10 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 04/20] rbd: move OSD request submission into object request state machines
Date:   Tue, 25 Jun 2019 16:40:55 +0200
Message-Id: <20190625144111.11270-5-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190625144111.11270-1-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Start eliminating asymmetry where the initial OSD request is allocated
and submitted from outside the state machine, making error handling and
restarts harder than they could be.  This commit deals with submission,
a commit that deals with allocation will follow.

Note that this commit adds parent chain recursion on the submission
side:

  rbd_img_request_submit
    rbd_obj_handle_request
      __rbd_obj_handle_request
        rbd_obj_handle_read
          rbd_obj_handle_write_guard
            rbd_obj_read_from_parent
              rbd_img_request_submit

This will be fixed in the next commit.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 60 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 488da877a2bb..9c6be82353c0 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -223,7 +223,8 @@ enum obj_operation_type {
 #define RBD_OBJ_FLAG_COPYUP_ENABLED		(1U << 1)
 
 enum rbd_obj_read_state {
-	RBD_OBJ_READ_OBJECT = 1,
+	RBD_OBJ_READ_START = 1,
+	RBD_OBJ_READ_OBJECT,
 	RBD_OBJ_READ_PARENT,
 };
 
@@ -253,7 +254,8 @@ enum rbd_obj_read_state {
  * even if there is a parent).
  */
 enum rbd_obj_write_state {
-	RBD_OBJ_WRITE_OBJECT = 1,
+	RBD_OBJ_WRITE_START = 1,
+	RBD_OBJ_WRITE_OBJECT,
 	RBD_OBJ_WRITE_READ_FROM_PARENT,
 	RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
 	RBD_OBJ_WRITE_COPYUP_OPS,
@@ -284,6 +286,7 @@ struct rbd_obj_request {
 
 	struct ceph_osd_request	*osd_req;
 
+	struct mutex		state_mutex;
 	struct kref		kref;
 };
 
@@ -1560,6 +1563,7 @@ static struct rbd_obj_request *rbd_obj_request_create(void)
 		return NULL;
 
 	ceph_object_extent_init(&obj_request->ex);
+	mutex_init(&obj_request->state_mutex);
 	kref_init(&obj_request->kref);
 
 	dout("%s %p\n", __func__, obj_request);
@@ -1802,7 +1806,7 @@ static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
 	rbd_osd_req_setup_data(obj_req, 0);
 
 	rbd_osd_req_format_read(obj_req);
-	obj_req->read_state = RBD_OBJ_READ_OBJECT;
+	obj_req->read_state = RBD_OBJ_READ_START;
 	return 0;
 }
 
@@ -1885,7 +1889,7 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
 			return ret;
 	}
 
-	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
+	obj_req->write_state = RBD_OBJ_WRITE_START;
 	__rbd_obj_setup_write(obj_req, which);
 	return 0;
 }
@@ -1943,7 +1947,7 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
 				       off, next_off - off, 0, 0);
 	}
 
-	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
+	obj_req->write_state = RBD_OBJ_WRITE_START;
 	rbd_osd_req_format_write(obj_req);
 	return 0;
 }
@@ -2022,7 +2026,7 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
 			return ret;
 	}
 
-	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
+	obj_req->write_state = RBD_OBJ_WRITE_START;
 	__rbd_obj_setup_zeroout(obj_req, which);
 	return 0;
 }
@@ -2363,11 +2367,17 @@ static void rbd_img_request_submit(struct rbd_img_request *img_request)
 
 	rbd_img_request_get(img_request);
 	for_each_obj_request(img_request, obj_request)
-		rbd_obj_request_submit(obj_request);
+		rbd_obj_handle_request(obj_request, 0);
 
 	rbd_img_request_put(img_request);
 }
 
+static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
+{
+	rbd_obj_request_submit(obj_req);
+	return 0;
+}
+
 static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 {
 	struct rbd_img_request *img_req = obj_req->img_request;
@@ -2415,12 +2425,22 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
 	return 0;
 }
 
-static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
+static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
 {
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	int ret;
 
 	switch (obj_req->read_state) {
+	case RBD_OBJ_READ_START:
+		rbd_assert(!*result);
+
+		ret = rbd_obj_read_object(obj_req);
+		if (ret) {
+			*result = ret;
+			return true;
+		}
+		obj_req->read_state = RBD_OBJ_READ_OBJECT;
+		return false;
 	case RBD_OBJ_READ_OBJECT:
 		if (*result == -ENOENT && rbd_dev->parent_overlap) {
 			/* reverse map this object extent onto the parent */
@@ -2464,6 +2484,12 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
 	}
 }
 
+static int rbd_obj_write_object(struct rbd_obj_request *obj_req)
+{
+	rbd_obj_request_submit(obj_req);
+	return 0;
+}
+
 /*
  * copyup_bvecs pages are never highmem pages
  */
@@ -2661,11 +2687,21 @@ static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
 	return rbd_obj_read_from_parent(obj_req);
 }
 
-static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
+static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
 {
 	int ret;
 
 	switch (obj_req->write_state) {
+	case RBD_OBJ_WRITE_START:
+		rbd_assert(!*result);
+
+		ret = rbd_obj_write_object(obj_req);
+		if (ret) {
+			*result = ret;
+			return true;
+		}
+		obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
+		return false;
 	case RBD_OBJ_WRITE_OBJECT:
 		if (*result == -ENOENT) {
 			if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
@@ -2722,10 +2758,12 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
 	struct rbd_img_request *img_req = obj_req->img_request;
 	bool done;
 
+	mutex_lock(&obj_req->state_mutex);
 	if (!rbd_img_is_write(img_req))
-		done = rbd_obj_handle_read(obj_req, result);
+		done = rbd_obj_advance_read(obj_req, result);
 	else
-		done = rbd_obj_handle_write(obj_req, result);
+		done = rbd_obj_advance_write(obj_req, result);
+	mutex_unlock(&obj_req->state_mutex);
 
 	return done;
 }
-- 
2.19.2

