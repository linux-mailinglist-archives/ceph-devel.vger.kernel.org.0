Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF35F1882E0
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 13:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCQMFD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 08:05:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43041 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQMFC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Mar 2020 08:05:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id b2so19062412wrj.10
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 05:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cBUpox85RxX9oUWWDs/rPz95nR2HzjMae7+1O3FTjKI=;
        b=THmO/1y2uMXi2jLZ5V0LjMy+8whCSgSy6HTRC0U4KBe8+fKhLg+Sx+XGWW+7FH0pj9
         u9mqBBR1g99Xou8D1CGuPW3rJsClDy4rV0/RqlWlFjfglCLQNIk6Mqva/L2CA0SshLh0
         QmSoTyJYQXXQ9y9n3tIiQpz20076EILiX0LMEzIQpKnoO5VQfN2E2E7Fpp3f7HD+zwRJ
         iQTXQCYK/C9LCiEaz3iuD3ZWx6lqUOVu2c0g9xcado2cP84HglF9bDJMysrVg1xk4T8b
         sMfUCR4YWmJGKTvUgGHaLV2tamrnShW+9Pe9YTz8ki+NuobgPSfpM/kR18e+Aqf7Ocn2
         aidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cBUpox85RxX9oUWWDs/rPz95nR2HzjMae7+1O3FTjKI=;
        b=OIwt4/r5ld8Mah29TGmeegY9par51qvfnFIfb/1OSPNkoNvdUBgkBFbKcYL1uu6pJ3
         doeVwLbEVrCWptpGeqiU7iaKJc1BM02oDizhep/mn5/peGxLcRDiyyPFMAGjnxRZCXoY
         pTV5oCVG4ZghkQ8r9kbEw4fLRaLwwxlKd83FkruNcntpVU+DxIXdmMLmIXmiZ+Ghz+2i
         yQVWVk7+V0gHkAiCkNfcI0RmaW+bPN+c1QCLez/B78CAx5+V4wgF1jhAolV2wZlZP6D3
         PsGKoZOxgoXceACr+IF3kWPufYEsaDfLqisW/ymncuYt18hFWPtsFz5kil6Bxo833yqk
         dCYA==
X-Gm-Message-State: ANhLgQ38kpwJQMrYDb8DrxqUr4aK3krXEFjdEVgxSI5cuJ0vE44Shhka
        TNvWlJuBF/howqE+4zM99OG5Kwx59fA=
X-Google-Smtp-Source: ADFU+vvJxxQyT8YNcdTwIzGkkySkr+gtGUL3G2Vt/BBCllxLxM8Izr0BCFoHR1mwQDGVJMpbs6Kd6g==
X-Received: by 2002:a5d:6591:: with SMTP id q17mr5546268wru.22.1584446700460;
        Tue, 17 Mar 2020 05:05:00 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id p8sm4416706wrw.19.2020.03.17.05.04.56
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:04:57 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 3/3] rbd: don't test rbd_dev->opts in rbd_dev_image_release()
Date:   Tue, 17 Mar 2020 13:04:22 +0100
Message-Id: <20200317120422.3406-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200317120422.3406-1-idryomov@gmail.com>
References: <20200317120422.3406-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_dev->opts is used to distinguish between the image that is being
mapped and a parent.  However, because we no longer establish watch for
read-only mappings, this test is imprecise and results in unnecessary
rbd_unregister_watch() calls.

Make it consistent with need_watch in rbd_dev_image_probe().

Fixes: b9ef2b8858a0 ("rbd: don't establish watch for read-only mappings")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e590dc484c18..f44ce9ccadd6 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6898,7 +6898,7 @@ static void rbd_print_dne(struct rbd_device *rbd_dev, bool is_snap)
 
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
-	if (rbd_dev->opts)
+	if (!rbd_is_ro(rbd_dev))
 		rbd_unregister_watch(rbd_dev);
 
 	rbd_dev_unprobe(rbd_dev);
-- 
2.19.2

