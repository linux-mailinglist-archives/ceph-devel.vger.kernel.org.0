Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89BB3C826A
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 12:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbhGNKJT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 06:09:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239094AbhGNKJM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 06:09:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBH85MVFQXPuSuMKLXbXwQPzrS8jv8/jyfkKZxsdFMM=;
        b=Zf1aACIF56hgjCg/SDbjPJWpPxDUzaCiMWsljHKVVy9qLYciYwnqs1dOxtMYPivaimo4nc
        b+58xDIrGYVKVSDTCKQ4sUbj3kt4yQbgYrpwzAlF8B67DNSuP1sbUFv7OazsVpSFzqQlHX
        1vca1WBFOXoYS6z86VY5swX6xsv8tqs=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-Bu6VPSr7NPC9pW3_yv17wA-1; Wed, 14 Jul 2021 06:06:19 -0400
X-MC-Unique: Bu6VPSr7NPC9pW3_yv17wA-1
Received: by mail-pf1-f200.google.com with SMTP id s187-20020a625ec40000b02903288ce43fc0so1293238pfb.7
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 03:06:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FBH85MVFQXPuSuMKLXbXwQPzrS8jv8/jyfkKZxsdFMM=;
        b=pYJk4VUcbtnzx+Y//HJsKqDT/KK70MHLLwqlri4Cfx0vZThQ2Esji+bBV98yMIwtHw
         vMHITA2Ds9s8FofglenL2E7Xobn8jx2a7b08yjfNWRjs89Vw53mZUymXMiNaIGdCQt9f
         rNRe/6NFXC4zLyR3zktps6jqe5/SckYdfP4SVNZWwMfoz9ngXzoyKRFfYVVKRXrnO+rw
         aj9maL13RmMvOppsBvOfbZFk8waQiCY7n1LNmzbmAd4OcOsBXBJpSxjq9JU2GhFf7p/4
         EqIpeSIz98e2XnRo3FFKi6PbCMvmGMlGC5LM/js8R5Fg04KSdsz1gvlUZRaALz/U1/pk
         +m/Q==
X-Gm-Message-State: AOAM533cGv/zAOVPJv/lksCF3pIWC1LK6sybWM0gB5bfbbQ/MnK7XyvO
        8mJ1HHUcY81+SxFJYUpos8Ykk+lr8J7k0xFmyesP69XwKqNWp9z8HanovaT+SGCxIBMNtrwX3Kb
        ZPSdtkoRAIsd0HP8Xst/M9Q==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr3071813pju.51.1626257178331;
        Wed, 14 Jul 2021 03:06:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyw4HClj6jY4VYSYzi5H++ZORrf8LZNi9GgE3n6sS4BHqI/22tblJ4MP97s3b4ikIUlI5PXrQ==
X-Received: by 2002:a17:90a:d596:: with SMTP id v22mr3071795pju.51.1626257178173;
        Wed, 14 Jul 2021 03:06:18 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.217.185])
        by smtp.gmail.com with ESMTPSA id 125sm2227030pfg.52.2021.07.14.03.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 03:06:17 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 4/5] ceph: record updated mon_addr on remount
Date:   Wed, 14 Jul 2021 15:35:53 +0530
Message-Id: <20210714100554.85978-5-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714100554.85978-1-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Note that the new monitors are just shown in /proc/mounts.
Ceph does not (re)connect to new monitors yet.

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 fs/ceph/super.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index d8c6168b7fcd..d3a5a3729c5b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1268,6 +1268,13 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
 	else
 		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
 
+	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
+		kfree(fsc->mount_options->mon_addr);
+		fsc->mount_options->mon_addr = fsopt->mon_addr;
+		fsopt->mon_addr = NULL;
+		printk(KERN_NOTICE "ceph: monitor addresses recorded, but not used for reconnection");
+	}
+
 	sync_filesystem(fc->root->d_sb);
 	return 0;
 }
-- 
2.27.0

