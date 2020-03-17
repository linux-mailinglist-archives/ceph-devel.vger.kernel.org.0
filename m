Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAEE0188803
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 15:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgCQOsn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 10:48:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46503 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgCQOsn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Mar 2020 10:48:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id w16so9638318wrv.13
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 07:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onTjRtqDOzng69gH+kRX//NNGai7U0gQhqy+u2lZuRA=;
        b=j2TP9M8rG7qYNtVNx1S7wIY5En+xdH2BwyRp142wo12Xa/392oHLNG1cG1D0rclK7Q
         fyfQMZy3Sf4KhgY+wo1G+hjKVdGGmBTLESKiYeJgLS6VglT8lPPcPhWHzbwkac23FIlO
         2+RjuOBwySabOgIn3JdzkDF55Ozn5IW199lGWvZ6vVovXS/GNgLdrlbJxKbawV/3GxF/
         jCsz4/AJMcgpbZbQNfUtvZZkP6IzPmj4MwBhD5VK1bN4YgpPF8w38luPjtDEEKCbrQFV
         ZRlWIkWDI+WKmfsl4gId+sXzIHZGO8tirNkhWDK3kgNEy2yVxlQuMurUomjMnfDrsKQG
         5VsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onTjRtqDOzng69gH+kRX//NNGai7U0gQhqy+u2lZuRA=;
        b=HNwaPPjb4ZYX+Fma/Rokdjiq5L5p31xSt/FdM/SpTeJUeM1ddUzumphoj+bxcMHP5z
         UYAM/oTvSEAK2tRo5+/UN1tEdn6ZV/eFTT+oC3hbSz5e1LFlJ1HrADcg+v5V30O4zKdD
         35/YFau1xbcpV+INQwepDsgnQLXFR1dxRXyQQNXTH2zX5FIefuq2gnLaVv2hbQaOSwjy
         +AbejP8rAuT02QrOYBwsxxfaOU/yUk8bCBHvTJEA3iVweNXO0Caq7Wgo6jgX+34ur2zm
         g+mtkDaGgjgGj++IpPoALmljRa/03e9PZs9NLEW+EuniNdGc7hQTHsO1aLd2lgupQWTr
         Y6mw==
X-Gm-Message-State: ANhLgQ1y6pM+HEBoQjIsMs07iDKWlbjACRpD2+rsXMFepi4amMx/UWv1
        V0fohf1SSFJvlqlmI7a79oTgXAzQUCw=
X-Google-Smtp-Source: ADFU+vs5498TA7Za2GRkuVLQsGQswBScj9X23Q1kwJXgAcyAvE65rkwplKMyXm2UNJ0w9ej8FyKNhA==
X-Received: by 2002:adf:db49:: with SMTP id f9mr6191086wrj.145.1584456521144;
        Tue, 17 Mar 2020 07:48:41 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id i21sm4300348wmb.23.2020.03.17.07.48.39
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 07:48:40 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] rbd: don't mess with a page vector in rbd_notify_op_lock()
Date:   Tue, 17 Mar 2020 15:48:47 +0100
Message-Id: <20200317144847.10913-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_notify_op_lock() isn't interested in a notify reply.  Instead of
accepting that page vector just to free it, have watch-notify code take
care of it.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f44ce9ccadd6..acafdae16be2 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3754,11 +3754,7 @@ static int __rbd_notify_op_lock(struct rbd_device *rbd_dev,
 static void rbd_notify_op_lock(struct rbd_device *rbd_dev,
 			       enum rbd_notify_op notify_op)
 {
-	struct page **reply_pages;
-	size_t reply_len;
-
-	__rbd_notify_op_lock(rbd_dev, notify_op, &reply_pages, &reply_len);
-	ceph_release_page_vector(reply_pages, calc_pages_for(0, reply_len));
+	__rbd_notify_op_lock(rbd_dev, notify_op, NULL, NULL);
 }
 
 static void rbd_notify_acquired_lock(struct work_struct *work)
-- 
2.19.2

