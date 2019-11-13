Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 350B3FB8E2
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 20:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfKMTaX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 14:30:23 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33998 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMTaX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 14:30:23 -0500
Received: by mail-wm1-f66.google.com with SMTP id j18so5668662wmk.1
        for <ceph-devel@vger.kernel.org>; Wed, 13 Nov 2019 11:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hVz60Uf1lUJ63EgYX9VmkyC/R1yq4lTqY88oYQKu3o=;
        b=uwzrIOIkR8Ws/Xvb7aU5mPG3gQrRf4MvK22QxWCHHgCj7pbvR6YrLRZ4H2uhM5A/ZS
         qN7NeEe1Le9pmcxbWEMs1IqJ8U31WKUn4g9eVjdIF9uASFyoL2Yb27cA5awqHGyndFpB
         fa9J+oHcbWYV07XIB5RQlkDq1LOAqaWeGlwDCQO5ARJsI2KwY/FUlANzllH3ZOQeS+gE
         m1CYBjjX27yzkwLW1sKHBLgvXiLKr4wBwTQ4GWGuk3gYqyBdP9VuULG8I7zk/oCXJIpq
         cMjVBDsZuQTYrMRhAdShnijIM49tHGVu8XAHH/8XmtBl58wI8v7ARnPOs9Lk6PMGSBuE
         XYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hVz60Uf1lUJ63EgYX9VmkyC/R1yq4lTqY88oYQKu3o=;
        b=LDsULg5RsTnVeNtu6xVGITGm6IbW3TOFBLMm1iTDGE9EUqfALSIUg5PglFFWPB03a9
         it5qowAsZFj7xVOYxN2NezGmys4ahLl4zZV3Yw9edPhtWmeXwNmhJriVUQeYgDWoxtNG
         ct2O35g7Tp4WXnFjV+oWyOAWcnPblZFJ4OU0r6jKvgEPgAlAED+8Kx2PoR6P0dOItY2Q
         qAtb9fGhbI+8ofgGarBDl8OH9DG9nX9wwzWH3PiV7xd8KsKiVhFZWFLXeG81PvNjBaZC
         f881s1z5PZmBlYPrqVsjz+XQaY1VjterM4jU13UA6+PVulwGXw74sC8sHHj0Pw7X54e1
         eRrA==
X-Gm-Message-State: APjAAAVMW0JAFER+W35sHIhxdkHDd9lb4lrl6jMm9LA+Hm0abRncqHIq
        r3WIZm1SgbWvjOMEBY7Qr0gYRgbW
X-Google-Smtp-Source: APXvYqzvkIf1eZV4XOeZxMalKt5ToXAjuCafJC7ugbFdVoRKcQafCNn132jumuiJUYETCd7bru+mww==
X-Received: by 2002:a1c:e3d4:: with SMTP id a203mr3964295wmh.173.1573673419568;
        Wed, 13 Nov 2019 11:30:19 -0800 (PST)
Received: from kwango.local (ip-94-112-128-92.net.upcbroadband.cz. [94.112.128.92])
        by smtp.gmail.com with ESMTPSA id u203sm3329221wme.34.2019.11.13.11.30.17
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 11:30:18 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] rbd: silence bogus uninitialized warning in rbd_object_map_update_finish()
Date:   Wed, 13 Nov 2019 20:29:54 +0100
Message-Id: <20191113192954.29732-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Some versions of gcc (so far 6.3 and 7.4) throw a warning:

  drivers/block/rbd.c: In function 'rbd_object_map_callback':
  drivers/block/rbd.c:2124:21: warning: 'current_state' may be used uninitialized in this function [-Wmaybe-uninitialized]
        (current_state == OBJECT_EXISTS && state == OBJECT_EXISTS_CLEAN))
  drivers/block/rbd.c:2092:23: note: 'current_state' was declared here
    u8 state, new_state, current_state;
                          ^~~~~~~~~~~~~

It's bogus because all current_state accesses are guarded by
has_current_state.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 395410b0d335..2aaa56e4cec9 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2070,7 +2070,7 @@ static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
 	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
 	struct ceph_osd_data *osd_data;
 	u64 objno;
-	u8 state, new_state, current_state;
+	u8 state, new_state, uninitialized_var(current_state);
 	bool has_current_state;
 	void *p;
 
-- 
2.19.2

