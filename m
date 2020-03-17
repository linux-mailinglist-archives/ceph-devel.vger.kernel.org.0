Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA41882DF
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Mar 2020 13:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgCQME7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Mar 2020 08:04:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39197 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgCQME7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Mar 2020 08:04:59 -0400
Received: by mail-wr1-f66.google.com with SMTP id h6so4962501wrs.6
        for <ceph-devel@vger.kernel.org>; Tue, 17 Mar 2020 05:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JqNH+AB/pWHQv45BKXgKcEwpSBlHFvw8DFsiMZU8sAo=;
        b=mOXHvMKbzKUEd4hQL36LInWipxxOiPg3Re6TleV0V2ogztqtI1zVSbXovEKYdUQLn7
         doGak2APFZhw2GMUUNhpCkw/i4WZui1kqB6bszrULx6wqulcR4vuvuJQ7Ba1RK1gDZ8e
         5MrVcZVwJOsvpTJHejBrWZmliA9lvrfaDbm7HQvlBlNcFleMc987xxBdjgOymsEQWs3W
         I9Q/IRqpOFCc92yQGND0MoOlWThlBex8m6tzrL2w5fTp0JCuuTlv+vzvSZdUpz+udZ7v
         KxWNOSRfZWId1UzSHiy+UkQKdIZj0pRRgVODpjQL+0OVsBO7UOFHS3QqFLzHAiDXfXRz
         Baqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JqNH+AB/pWHQv45BKXgKcEwpSBlHFvw8DFsiMZU8sAo=;
        b=IVnyGxdt6F2IX8lLp4z46SissM/l6qs0M9U5pqecKindgRuB88QCf4FkF65Sq22VKP
         bYBiNJmBDbS9Q1Zav4+Yug3vY9hYbzLq4YwvogT+aBeEJo2CXbcnCfGY9htf6nC/L/l5
         l5qv52Qj6vG9O9KsLQz5dyl9zfJcO7KFCSvdtwrRXNJ3VyxAQw1iADrV4Gyj2xDtCLlP
         sSZaGGfkb2Z+lQ8YDv2a8HueguKd8cnDl0lM1DZdfWRk4uKYcGbEqkgtklyXvgASW1wi
         T3Be06EV/cBxml2slY1Mv+llJ3BmSalO/r3skYoeTbsX/E2ifYoGf4QTVMi9pplpfJI0
         2hCg==
X-Gm-Message-State: ANhLgQ1yaaICDlEgU8eEgNF8QEzpCe0VsS1ddMqjoG6Xx0p6q2Ls3Gkh
        UaYuVslERYscP9F6aO/Tv/xMlg/MxOI=
X-Google-Smtp-Source: ADFU+vsEy2aIAvcQ8aqns01G7FtGe6htFH3X2O2TAzt/M2qcGlr0IGd6eW3gGpwoTm2CEBXES226cA==
X-Received: by 2002:a05:6000:41:: with SMTP id k1mr6040978wrx.53.1584446696781;
        Tue, 17 Mar 2020 05:04:56 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id p8sm4416706wrw.19.2020.03.17.05.04.52
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 05:04:52 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 2/3] rbd: call rbd_dev_unprobe() after unwatching and flushing notifies
Date:   Tue, 17 Mar 2020 13:04:21 +0100
Message-Id: <20200317120422.3406-3-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200317120422.3406-1-idryomov@gmail.com>
References: <20200317120422.3406-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

rbd_dev_unprobe() is supposed to undo most of rbd_dev_image_probe(),
including rbd_dev_header_info(), which means that rbd_dev_header_info()
isn't supposed to be called after rbd_dev_unprobe().

However, rbd_dev_image_release() calls rbd_dev_unprobe() before
rbd_unregister_watch().  This is racy because a header update notify
can sneak in:

  "rbd unmap" thread                   ceph-watch-notify worker

  rbd_dev_image_release()
    rbd_dev_unprobe()
      free and zero out header
                                       rbd_watch_cb()
                                         rbd_dev_refresh()
                                           rbd_dev_header_info()
                                             read in header

The same goes for "rbd map" because rbd_dev_image_probe() calls
rbd_dev_unprobe() on errors.  In both cases this results in a memory
leak.

Fixes: fd22aef8b47c ("rbd: move rbd_unregister_watch() call into rbd_dev_image_release()")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index f0ce30a6fc69..e590dc484c18 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6898,9 +6898,10 @@ static void rbd_print_dne(struct rbd_device *rbd_dev, bool is_snap)
 
 static void rbd_dev_image_release(struct rbd_device *rbd_dev)
 {
-	rbd_dev_unprobe(rbd_dev);
 	if (rbd_dev->opts)
 		rbd_unregister_watch(rbd_dev);
+
+	rbd_dev_unprobe(rbd_dev);
 	rbd_dev->image_format = 0;
 	kfree(rbd_dev->spec->image_id);
 	rbd_dev->spec->image_id = NULL;
@@ -6947,7 +6948,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	if (ret) {
 		if (ret == -ENOENT && !need_watch)
 			rbd_print_dne(rbd_dev, false);
-		goto err_out_watch;
+		goto err_out_probe;
 	}
 
 	/*
@@ -6992,11 +6993,10 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
 	return 0;
 
 err_out_probe:
-	rbd_dev_unprobe(rbd_dev);
-err_out_watch:
 	up_write(&rbd_dev->header_rwsem);
 	if (need_watch)
 		rbd_unregister_watch(rbd_dev);
+	rbd_dev_unprobe(rbd_dev);
 err_out_format:
 	rbd_dev->image_format = 0;
 	kfree(rbd_dev->spec->image_id);
-- 
2.19.2

