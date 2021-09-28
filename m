Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5FD41A8A6
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 08:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbhI1GJa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Sep 2021 02:09:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53148 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239800AbhI1GId (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Sep 2021 02:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632809213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DJY4JzvE3GxKzy5PPFP7IFKW/lhu4y2zW523L/Na2o=;
        b=MBSwOapNSakD0Z26c7fNKgUSz2wdPUb1OIcGDwvfFxFsYT7uTtax8AihzVr4KzQwIH9Uiq
        guYYd60Z+xuH4NY+kR2OuLAfnndCas3vpalvOWDif49FPjWdkiUevAaLOPlA3fa41miSRg
        AWD/ohX8eCpGYN+cEZgsZfT5RxDqUjQ=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-597-SdSoeMSbPKWs0730D1rf3Q-1; Tue, 28 Sep 2021 02:06:51 -0400
X-MC-Unique: SdSoeMSbPKWs0730D1rf3Q-1
Received: by mail-pf1-f199.google.com with SMTP id i20-20020aa796f4000000b00447c2f4d37bso13739794pfq.22
        for <ceph-devel@vger.kernel.org>; Mon, 27 Sep 2021 23:06:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4DJY4JzvE3GxKzy5PPFP7IFKW/lhu4y2zW523L/Na2o=;
        b=tQUZywM7kzhlBNqlc/pYTRrCNnG+q8ny5ugzTNsKeWUo/K7qZPB19zbAOFkNBL7nz4
         SRbEv+HpqJOQzWpp2roNdMrsXtZGJ4hFL3geXlgbwEiqB8t5qNLuKWtyvltozQ+dwmfO
         lNP/ggWz4ThQaP1C+yU1v2nKXUyibiB6eCLUjUFBtOVuF5ggk7p8gZZBJwoNbQtYFNL4
         IOpIMGIFOUbOzG3j/heTMqglotzJOp4Ev5x/E6GchU26+CpNNG1YzCvdcCakxvnvGEoH
         Gky6F9d4cmOtgqEKbR17TN+y530Tnh6BELm/RcbUgUUor9OPtBEJRw9HhDI/8bgkqUb2
         RkuA==
X-Gm-Message-State: AOAM533UHTwWcKPUQUsddgl9HvWQEBf50mCPoV3leHBSNMNPd+pdRJko
        uKPL+ZGYgi3967mrjt3V6sJ3dwpcehrPFA5yyGCwl3a+FZb99j2GOr3A+qSJ1gxE9d1XKLAGedG
        obeVJ1NcrsZqD79CwpPb3jg==
X-Received: by 2002:aa7:8609:0:b0:44b:346a:7404 with SMTP id p9-20020aa78609000000b0044b346a7404mr3899042pfn.86.1632809210168;
        Mon, 27 Sep 2021 23:06:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9eVUPyxcA+HFRSKL5eZyT7Rq0hQEEGEFXnnaInSNUyhIOsbbwcQJAW2tdGImRxnDQB8hdxw==
X-Received: by 2002:aa7:8609:0:b0:44b:346a:7404 with SMTP id p9-20020aa78609000000b0044b346a7404mr3899027pfn.86.1632809209978;
        Mon, 27 Sep 2021 23:06:49 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id v6sm18855862pfv.83.2021.09.27.23.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 23:06:49 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 1/2] libceph: export ceph_debugfs_dir for use in ceph.ko
Date:   Tue, 28 Sep 2021 11:36:32 +0530
Message-Id: <20210928060633.349231-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928060633.349231-1-vshankar@redhat.com>
References: <20210928060633.349231-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 include/linux/ceph/debugfs.h | 2 ++
 net/ceph/debugfs.c           | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
index 8b3a1a7a953a..464c7dfced87 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -4,6 +4,8 @@
 
 #include <linux/ceph/types.h>
 
+extern struct dentry *ceph_debugfs_dir;
+
 /* debugfs.c */
 extern void ceph_debugfs_init(void);
 extern void ceph_debugfs_cleanup(void);
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 2110439f8a24..774e0c0fd18a 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -29,7 +29,8 @@
  *      .../bdi         - symlink to ../../bdi/something
  */
 
-static struct dentry *ceph_debugfs_dir;
+struct dentry *ceph_debugfs_dir;
+EXPORT_SYMBOL(ceph_debugfs_dir);
 
 static int monmap_show(struct seq_file *s, void *p)
 {
-- 
2.27.0

