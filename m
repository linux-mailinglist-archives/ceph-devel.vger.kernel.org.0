Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D563B3F6EFD
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Aug 2021 07:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhHYFvj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Aug 2021 01:51:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232848AbhHYFvi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 01:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629870652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DJY4JzvE3GxKzy5PPFP7IFKW/lhu4y2zW523L/Na2o=;
        b=CM7DcwiHT+q8iGva/U2xjVTqLQG5GexjvC7IMmG5wIkvF3v2BUwsFM/QAl+Ep0303SAkz/
        OiaWYKg/2W2xgWrMAOaxcGQCcnXwonCRSJmVejfxhetYHxhavwxupneXWp3Px7/4CvYRH+
        v+WXJRSlHQTB3myqu/YSHKMGwpDWPc0=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-ovd-8QVqPTe2dGdV8Bak6w-1; Wed, 25 Aug 2021 01:50:50 -0400
X-MC-Unique: ovd-8QVqPTe2dGdV8Bak6w-1
Received: by mail-pj1-f69.google.com with SMTP id fy13-20020a17090b020d00b001939890b4d6so595368pjb.8
        for <ceph-devel@vger.kernel.org>; Tue, 24 Aug 2021 22:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4DJY4JzvE3GxKzy5PPFP7IFKW/lhu4y2zW523L/Na2o=;
        b=snpuyTxi/VF4oItysPuu4imAmtlGp7mV+onXciPzwI49cZBTItlfi0eZMbm087IjNT
         3ytpx5UaDsrw2MLFOyXZ8XS7CzuXK7G0IoKdQHv7wP4P0guMqQVjnxRKIbiuzrBZe1Sy
         xc/sUu7vG2OoTInRohRKuUyzH9YLrDJabst7+MYVx7cyGgYUYjSwe5aShQpxih0Z+Qfz
         /PrfvEGZ7BJ154f6Nr2TyWUNtpAQX7ihCy/gtznnygfgYqmLNYKm3aVUX85/x2uYb2qd
         nN58H0ejKarHlTYaxc+OakNKeObekj7H3+hcdTFR6IrglWqMtOfARc62wVu/MygcPwDu
         /Yvw==
X-Gm-Message-State: AOAM53017WZ0/2IBBlxOut/Z0MNdDgF2RxBawN678bRFzzJDMgfpgNVL
        RizVo2O2QiG+KW/9L8UHl2hKmHVIlD1qf4tjJkmcZ1NrQfJoOw4bZRUf3TcSdHmozrwbVzeQyxr
        9VZ2W1PiIn/hXxi0iufnn5g==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr5679982pjt.95.1629870649851;
        Tue, 24 Aug 2021 22:50:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7yAms7BLMl2ROshSkcXxDXQzH/4W39rFFSyMsqREhLqoIxmizPqs1M3Agh5d9OciiEjPj/g==
X-Received: by 2002:a17:90a:c297:: with SMTP id f23mr5679967pjt.95.1629870649641;
        Tue, 24 Aug 2021 22:50:49 -0700 (PDT)
Received: from localhost.localdomain ([49.207.198.118])
        by smtp.gmail.com with ESMTPSA id w4sm960362pjj.15.2021.08.24.22.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 22:50:49 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 1/2] libceph: export ceph_debugfs_dir for use in ceph.ko
Date:   Wed, 25 Aug 2021 11:20:34 +0530
Message-Id: <20210825055035.306043-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210825055035.306043-1-vshankar@redhat.com>
References: <20210825055035.306043-1-vshankar@redhat.com>
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

