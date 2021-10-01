Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69641E703
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Oct 2021 07:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241631AbhJAFCi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Oct 2021 01:02:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241541AbhJAFCh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Oct 2021 01:02:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633064454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DJY4JzvE3GxKzy5PPFP7IFKW/lhu4y2zW523L/Na2o=;
        b=e07Fx1MqyfEfGUPjq6r5BAd4lM4xDNL1G1VPS8oxWYhS8xkhkNvNziUNrT4u3SkxhrxBm8
        K8qb38HPZapQaBm4+11OiEp73WwaQS6HZ8xRNtBQLfarm/mIXNOTAAa52JUh6a/yMCyZ4d
        dxVmBFwYZ082dT4lGEwGpbjRfyyYXuw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-tYSFVjUmMGC8z0kl1SkV5Q-1; Fri, 01 Oct 2021 01:00:53 -0400
X-MC-Unique: tYSFVjUmMGC8z0kl1SkV5Q-1
Received: by mail-pj1-f72.google.com with SMTP id bx14-20020a17090af48e00b0019f1c6c254bso4661640pjb.4
        for <ceph-devel@vger.kernel.org>; Thu, 30 Sep 2021 22:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4DJY4JzvE3GxKzy5PPFP7IFKW/lhu4y2zW523L/Na2o=;
        b=IAIVXF7JvJs5pjGBLn4p61Pdh8zj4+5a+0gZgOOcqXBRaZatEm5gVj6ikakSLvZjzX
         y49lnJ0rL6GaYFeBIHmfiwL7Z78NcSsjojfFXyJEK79/g2T2kJlfQqjXBfrbPRhR+BT7
         SIdf38ha9EizfAyEpnVSd5J+WFxdPUSB9QQbQkDyzWDvppDzrzdxgfk9Wx+EIPXCLEP4
         nZP1xh6ksSshb4aDOYAAX+7IqYYEgrfzYsOf/9O0FWxfEh0c2im1lDw2Ry5RJtTjvyT/
         hWucxhKq7Dpg90zhAb6NuZROUkxagAy2lp99nt1MLZnbpvRF6laXI4Ix/FQzxlQrjY7E
         ZQmA==
X-Gm-Message-State: AOAM532vyOIriuxjNl9wI8tF+lgYnBdAqY+hQ5ONYFP3JVWaGt2mR1iW
        996skgqTnBDo9hknx3vYAkeBZoZnhHeIIzTevm7nSByxQrd94KcMw2mFoOwfVpP1MYaKufBw8Tg
        Y3Wavx03b/EXTrzax6A0Iyw==
X-Received: by 2002:a17:902:f703:b029:12c:982:c9ae with SMTP id h3-20020a170902f703b029012c0982c9aemr7783186plo.20.1633064450614;
        Thu, 30 Sep 2021 22:00:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyZpa8PzISBsH8aYCqNsi2HoPnI74/iruc1W1LcwoLX3H3s9Sf48tvsNwjFmNQSy8DNuUBIKQ==
X-Received: by 2002:a17:902:f703:b029:12c:982:c9ae with SMTP id h3-20020a170902f703b029012c0982c9aemr7783066plo.20.1633064448918;
        Thu, 30 Sep 2021 22:00:48 -0700 (PDT)
Received: from localhost.localdomain ([49.207.221.217])
        by smtp.gmail.com with ESMTPSA id s3sm6377485pjr.1.2021.09.30.22.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 22:00:48 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, pdonnell@redhat.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 1/2] libceph: export ceph_debugfs_dir for use in ceph.ko
Date:   Fri,  1 Oct 2021 10:30:36 +0530
Message-Id: <20211001050037.497199-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001050037.497199-1-vshankar@redhat.com>
References: <20211001050037.497199-1-vshankar@redhat.com>
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

