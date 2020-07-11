Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D34221C1F4
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jul 2020 05:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgGKDsx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jul 2020 23:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgGKDsx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jul 2020 23:48:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7D7C08C5DD
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jul 2020 20:48:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id b92so3426155pjc.4
        for <ceph-devel@vger.kernel.org>; Fri, 10 Jul 2020 20:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=VQoYhipYHx5/PvplxB00MlGjvRVqaBCNWcP6GvkLLlE=;
        b=YJpSZKUq+gpXtl6H42ea7avJal7pGv8UUPff0GtEqsrylwxV0GK2TjVl+Lm6RWemCA
         kbkkr8zVb4pN98yVAL9Uxz1FhmmiXIAbamnNbi+033KLxeq4OauA7QNQhqXS1Temg9AU
         jhgQc5kM9iMYu0nizkobsftsWoKQfUdxbYY038CZ1X+4o76vkDXqFI4sAlxW45tLOMhJ
         a7hrdF7o5I4OLQon6bW1Nn18CniquM93C3tTGHNUap7gzVe7STneVP8aGVOaaxuQEkhw
         xzFtyG3rTXYuBt3EsrmM0xUkgbP2QHc3c+wx8Lt6sV/R66kHtUrcfJWv9UIy9gG3ANRt
         5FMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=VQoYhipYHx5/PvplxB00MlGjvRVqaBCNWcP6GvkLLlE=;
        b=S00Ua1QjHDGCx58mo5OSHdb/eKpYGp5C5jvvCKMRJ49Dm7DrKKxwdoDGXN1HY75OX5
         gGBzQSd/aDDRZ/yOE0S7V76ZceHFs4Zp0KvpjIc+WkdW7MCSA085RwDCAKrZbE3ksqNI
         avG2M7I8Loq4+m+2IAmIwo5ickoozMKUfE2aXQ21rabmqLAP45aB13c5mU7MOiww97c9
         AlbXLIeYbBmgT/dEhL+hQ1pgAsEivCnIWjIVu11KkMP6YL4evTFJLtwv0RqQcWfGPylD
         blIGlglvFUe443dE5zlUEFnYkt0Sr2EYiay7zxx8gdaFLgZ684l/ti2iGhvrJNvE2PrN
         Jypw==
X-Gm-Message-State: AOAM532C4ovqj0K/599WGvJVwjTPM8VfZSxkIY5nvYZ8qS3vOKVMghD9
        DySyprthV1yR8ipGJjmvXFRYXgtSayQ=
X-Google-Smtp-Source: ABdhPJw+2NZKCQ9TXn30WdZ1/WJp4d5xSL12qzp3C0V3sLjCEx9id3TbWiiT0iqVgPM48RQ7YLAvFA==
X-Received: by 2002:a17:90b:1b06:: with SMTP id nu6mr8855554pjb.106.1594439332433;
        Fri, 10 Jul 2020 20:48:52 -0700 (PDT)
Received: from centos7.localdomain ([184.104.209.136])
        by smtp.gmail.com with ESMTPSA id cv7sm7056009pjb.9.2020.07.10.20.48.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jul 2020 20:48:52 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] libceph : client only want latest osdmap.      If the gap with the latest version exceeds the threshold, mon will send the fullosdmap instead of incremental osdmap
Date:   Fri, 10 Jul 2020 23:49:33 -0400
Message-Id: <1594439373-2120-1-git-send-email-simon29rock@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Fix: https://tracker.ceph.com/issues/43421
Signed-off-by: simon gao <simon29rock@gmail.com>
---
 include/linux/ceph/ceph_fs.h | 1 +
 net/ceph/mon_client.c        | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ebf5ba6..9dcc132 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -208,6 +208,7 @@ struct ceph_client_mount {
 } __attribute__ ((packed));
 
 #define CEPH_SUBSCRIBE_ONETIME    1  /* i want only 1 update after have */
+#define CEPH_SUBSCRIBE_LATEST_OSDMAP   2  /* i want the latest fullmap, for client */ 
 
 struct ceph_mon_subscribe_item {
 	__le64 start;
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 3d8c801..8d67671 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -349,7 +349,8 @@ static bool __ceph_monc_want_map(struct ceph_mon_client *monc, int sub,
 {
 	__le64 start = cpu_to_le64(epoch);
 	u8 flags = !continuous ? CEPH_SUBSCRIBE_ONETIME : 0;
-
+	if (CEPH_SUB_OSDMAP == sub)
+            flags |= CEPH_SUBSCRIBE_LATEST_OSDMAP;
 	dout("%s %s epoch %u continuous %d\n", __func__, ceph_sub_str[sub],
 	     epoch, continuous);
 
-- 
1.8.3.1

