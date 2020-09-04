Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E9F25D44C
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Sep 2020 11:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgIDJKq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Sep 2020 05:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgIDJKn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Sep 2020 05:10:43 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7874CC061244
        for <ceph-devel@vger.kernel.org>; Fri,  4 Sep 2020 02:10:41 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z23so7556565ejr.13
        for <ceph-devel@vger.kernel.org>; Fri, 04 Sep 2020 02:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCYtcDzFhFLA1ntJlAk0caAJKw5IPg4HzkSPR/TTOs8=;
        b=HZSMV+l1LxoEvWotASgjfxKqEtSQz4j/jZrtDNqsnCJNE0dCcLnNkSmJ1AT8jNKtcz
         Ej2ZmX4mIp4kOG3WXAXuRHIxeFp6fNXmXujPbY4LVix/lkIgz1cKdH/MIA/SydytavNL
         b/RxQCr44DyqyJ7HR68C9pTDAOJRyfg1pXibTcX/dUxCXgz8YiqYlnhNDvfNjwIV4zXn
         WbmGvbyMn+UHe2jO29YnSChtRAv2/ei/duzXQJm1P01LC+68575HDoE7QfxVLtWhFEuK
         yeLouAp9OFN6Ov6SoKIT5+n/6ISZPpM32tcLzWXNXGZAA3e1wo/UOS55MB/xTXvyI2o3
         5LDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wCYtcDzFhFLA1ntJlAk0caAJKw5IPg4HzkSPR/TTOs8=;
        b=ASmKM6g59apiIuX0SkRxwLWiU5+i30VI5MMRlOFbCliXP+Mxp/mXZsuT9NqPyGTGn3
         MVsZ9ZDodYDR582hFB/XeQAlhhdiag6IIJaiIR2+ueHpGzmFsoqJYXvYHI8jgIaKNnWc
         Qm91Hg7eO+NRiBdWK2u5ssVO3PKO3fYxG4UNyMBHQ/awjZCTLGiT37hoNdUBV3waBF5b
         7yQNDfQc735mWUvQjHtOMOz+OQR+XTwyPsfuH/Ca3JeeWXdiVBbreLoJaDcxoW5+vRCj
         9Ap9lP0Ui7DtSCaXASQ0yb3kVvMEI4QV6AHUsXcCafAS72amgtppyoB9oh1P/KNIAZOp
         3Xug==
X-Gm-Message-State: AOAM531XWyk9nCwuDmTMbWpHPTrpxdjc6Gsxy1AvbPPU1QmU5NOqgf7F
        uPxJcPVJrB5RHK2x4osQKPtzKGRUisMDBQ==
X-Google-Smtp-Source: ABdhPJx5e4wAYdac4gUxocH7yQ1ZvhGm1WRI60WaLb0LnflyO/GD9Y2hKI5OldtUw9CLTUnrSDyrmg==
X-Received: by 2002:a17:906:f9d3:: with SMTP id lj19mr6198597ejb.346.1599210639905;
        Fri, 04 Sep 2020 02:10:39 -0700 (PDT)
Received: from kwango.local (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id v13sm6120093edl.9.2020.09.04.02.10.39
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 02:10:39 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] rbd: require global CAP_SYS_ADMIN for mapping and unmapping
Date:   Fri,  4 Sep 2020 11:10:05 +0200
Message-Id: <20200904091005.7537-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It turns out that currently we rely only on sysfs attribute
permissions:

  $ ll /sys/bus/rbd/{add*,remove*}
  --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/add
  --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/add_single_major
  --w------- 1 root root 4096 Sep  3 20:37 /sys/bus/rbd/remove
  --w------- 1 root root 4096 Sep  3 20:38 /sys/bus/rbd/remove_single_major

This means that images can be mapped and unmapped (i.e. block devices
can be created and deleted) by a UID 0 process even after it drops all
privileges or by any process with CAP_DAC_OVERRIDE in its user namespace
as long as UID 0 is mapped into that user namespace.

Be consistent with other virtual block devices (loop, nbd, dm, md, etc)
and require CAP_SYS_ADMIN in the initial user namespace for mapping and
unmapping, and also for dumping the configuration string and refreshing
the image header.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/rbd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index fa252e8ed276..180587ce606c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5120,6 +5120,9 @@ static ssize_t rbd_config_info_show(struct device *dev,
 {
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	return sprintf(buf, "%s\n", rbd_dev->config_info);
 }
 
@@ -5231,6 +5234,9 @@ static ssize_t rbd_image_refresh(struct device *dev,
 	struct rbd_device *rbd_dev = dev_to_rbd_dev(dev);
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	ret = rbd_dev_refresh(rbd_dev);
 	if (ret)
 		return ret;
@@ -7059,6 +7065,9 @@ static ssize_t do_rbd_add(struct bus_type *bus,
 	struct rbd_client *rbdc;
 	int rc;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
@@ -7209,6 +7218,9 @@ static ssize_t do_rbd_remove(struct bus_type *bus,
 	bool force = false;
 	int ret;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	dev_id = -1;
 	opt_buf[0] = '\0';
 	sscanf(buf, "%d %5s", &dev_id, opt_buf);
-- 
2.19.2

