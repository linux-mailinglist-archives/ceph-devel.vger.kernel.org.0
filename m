Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1FC443C4B
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 06:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhKCFD2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 01:03:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57701 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229650AbhKCFD2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 01:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635915651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G6ttA+yux8lw/P3A0ANDNL1dzcgFx4xxDCE8D42qAl0=;
        b=EBT9kj+o9lmBlv8ab3HbNiMbJ4qG+1//SKWyreZAQxWi1mZHLE5OYBnOnFuzroFZn/onA6
        pdmrEggjWsGZOCNOqCJFLWCAqt12AFJ9VyUWr2vzgsDXB+uCrTbcZgpVZCwHU+HRKLcyqE
        0lQSfX+2fEGOi5+du5sZwbL1LOBfJYQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-Wk1Mb6bONXClADcUWThEqg-1; Wed, 03 Nov 2021 01:00:50 -0400
X-MC-Unique: Wk1Mb6bONXClADcUWThEqg-1
Received: by mail-pf1-f197.google.com with SMTP id c207-20020a621cd8000000b0048060050cfeso749392pfc.3
        for <ceph-devel@vger.kernel.org>; Tue, 02 Nov 2021 22:00:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G6ttA+yux8lw/P3A0ANDNL1dzcgFx4xxDCE8D42qAl0=;
        b=0We58vGgBIBSxegloKZGge7l2q9VlEwOBEXL2Ox50JlbyXdg72huinCJA+gGaPighb
         kNzHUo85/4xB5ISLVQBt1r3oK+y6oZfWNjB93TGsoOBMqOcLGzURKBzOt+CsdTJs2vaU
         0DDnSVmyy7cM7qrllXESgonVrdoLPSdid7dFLeG0Of/7sUt74KlplvZ5oiWVvB7L3ldA
         WUclZvJV8pWj9tpr0bHbbeF2a5g8KAwkA9yXWJ1+9uR3wVjtJ26rU+GMz3owEvznsNW4
         uCpOGTpdJQupCn+k9w1w54T2cRaqyaz5edVOUewRzAZmCndq1dDKo10dxCIvWpkAzKyl
         oSIA==
X-Gm-Message-State: AOAM532gw0h45L2crj/KBwtNjhkcqJAetjujKCJ8+4HmaprfGA6HkoIY
        dZKUKOlO5+P0KQB15lnpnEENTkwmC2Dwtnf1JCE2GyXyTyMcMVG6npiwGHpIwEsd5oG6MC5TpWk
        RGyCYTPRV277Sm/0izrq8YA==
X-Received: by 2002:a17:90b:1293:: with SMTP id fw19mr11976536pjb.155.1635915649008;
        Tue, 02 Nov 2021 22:00:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyoYZm3/yM7bs/NqC964p2GuFxOqgG72BaW5PzYGsn/kcyJIE2KX2v/M5H/3f0La6AKEJCzBg==
X-Received: by 2002:a17:90b:1293:: with SMTP id fw19mr11976517pjb.155.1635915648852;
        Tue, 02 Nov 2021 22:00:48 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.207.105])
        by smtp.gmail.com with ESMTPSA id h6sm780636pfi.174.2021.11.02.22.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 22:00:48 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v5 1/1] ceph: mount syntax module parameter
Date:   Wed,  3 Nov 2021 10:30:39 +0530
Message-Id: <20211103050039.371277-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103050039.371277-1-vshankar@redhat.com>
References: <20211103050039.371277-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add read-only paramaters for supported mount syntaxes. Primary
user is the user-space mount helper for catching v2 syntax bugs
during testing by cross verifying if the kernel supports v2 syntax
on mount failure.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 609ffc8c2d78..32e5240e33a0 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1452,6 +1452,14 @@ bool disable_send_metrics = false;
 module_param_cb(disable_send_metrics, &param_ops_metrics, &disable_send_metrics, 0644);
 MODULE_PARM_DESC(disable_send_metrics, "Enable sending perf metrics to ceph cluster (default: on)");
 
+/* for both v1 and v2 syntax */
+bool mount_support = true;
+static const struct kernel_param_ops param_ops_mount_syntax = {
+	.get = param_get_bool,
+};
+module_param_cb(mount_syntax_v1, &param_ops_mount_syntax, &mount_support, 0444);
+module_param_cb(mount_syntax_v2, &param_ops_mount_syntax, &mount_support, 0444);
+
 module_init(init_ceph);
 module_exit(exit_ceph);
 
-- 
2.27.0

