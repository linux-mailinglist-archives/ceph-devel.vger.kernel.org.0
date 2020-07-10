Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FFD21AE1F
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jul 2020 06:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgGJEid (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Jul 2020 00:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgGJEic (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Jul 2020 00:38:32 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A717EC08C5CE
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jul 2020 21:38:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k5so2063105pjg.3
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jul 2020 21:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZI5yB8NC3FXlTdch1Ac7w+3ZlVRkOei25ObYEJlVfuw=;
        b=ZdN3CH5IiVS+AB1aeT7XsIOU/Zll+Pzl/A2KTdAG1gQdl+2Ry/D0YYUkT5ENr7dWLc
         7KIRdXcym1JbSHgqeYUs9YIZdKOf7tJl5Uz6ci6YI6NPrnPN9SwuIutIbWIO7SI4EjQW
         Mvmy6xONm2feJIu1OVmIJNu95xTNJKBHQTEnfxynF+uifT2STouC8x+pWgDwceLWgEg+
         ju01ZYwXHXZ8pDU4FithfwuT0QUv7eHoEewnRQh6ohSwzsGV3MSt/8fh9ycaEZy4hpli
         DmeHRzkcubl6grA5BMRnhmNnkLMCd+VLDMWwMy94JRGad5fBvw4U1qlHmmJ8PvkKSFX7
         cXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZI5yB8NC3FXlTdch1Ac7w+3ZlVRkOei25ObYEJlVfuw=;
        b=r4625zxuc5Vz1HSxQPWPesk1Hnz9OWefdJQbpvFi6bZemfJgs1/e+jABm8MqnuL+U9
         wWk4mdC0duWS10Ik940CYOwEIZFNiIMFnzqIS2uYQOK+wrAb63/bGy9GLk9aggMEg5Dv
         1TbXIDhu1Hdu/OPaDt9GpT8jXdbZ//sn0lrorcGuYmEP9yuPJv2a2xX945oIUtPzIP7o
         TSwdUvCn/6dzZR4CmDysa2z25SnCEg/Kz6em7buHUaWN31J1eXDGeeBuZuHG5ueNI/Za
         sQNME9eh+Do/ictSkcRMW5qoo5RkqXRne9fDamOWa3gBAO3L0w1ZybFT6Bv1yTbIl84I
         7ZLw==
X-Gm-Message-State: AOAM531+EcRgBgsIiz6Gyk/zwa4arbkmWdx36g3xqZMLu6RH5sF64JB5
        XANNJSygvu61+0sP6whGK/GEO0o6Rh8=
X-Google-Smtp-Source: ABdhPJz4IhZeN3TusPcg1FJtEg0t+HVQqb4Q/lZkSsJ11izbY6sMxXpuX6ph/PtGrsjSDouxvMXgaA==
X-Received: by 2002:a17:90b:3684:: with SMTP id mj4mr3826610pjb.66.1594355912008;
        Thu, 09 Jul 2020 21:38:32 -0700 (PDT)
Received: from centos7.localdomain ([117.11.124.207])
        by smtp.gmail.com with ESMTPSA id t184sm4473901pfd.49.2020.07.09.21.38.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jul 2020 21:38:31 -0700 (PDT)
From:   simon gao <simon29rock@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     simon gao <simon29rock@gmail.com>
Subject: [PATCH] net : client only want latest osdmap.  If the gap with the latest version exceeds the threshold, mon will send the fullosdmap instead of incremental osdmap
Date:   Fri, 10 Jul 2020 00:39:04 -0400
Message-Id: <1594355944-7137-1-git-send-email-simon29rock@gmail.com>
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
index 3d8c801..b0d1ce6 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -349,7 +349,8 @@ static bool __ceph_monc_want_map(struct ceph_mon_client *monc, int sub,
 {
 	__le64 start = cpu_to_le64(epoch);
 	u8 flags = !continuous ? CEPH_SUBSCRIBE_ONETIME : 0;
-
+    if (CEPH_SUB_OSDMAP == sub)
+        flags |= CEPH_SUBSCRIBE_LATEST_OSDMAP
 	dout("%s %s epoch %u continuous %d\n", __func__, ceph_sub_str[sub],
 	     epoch, continuous);
 
-- 
1.8.3.1

