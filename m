Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235EE3C826B
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 12:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239013AbhGNKJU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 06:09:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239072AbhGNKJR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 06:09:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5z87lSglp1R+XOAVM/WPJyePD3cVLLHAqajJ2nmRuNY=;
        b=BtAzoPurZ0XheYkrmd4lLLeCsvCS/eGJrvveqd8GF2ucXBLpucv+IsMyWjs1Uql9QLSFt9
        9vGlxcVkQRxHGIIdmFB+dIaWrl0+GfwayMIWCZcl8CylP7Hdpu0OtVyu+Mg/vXSPLFjTaf
        DCa6ZTBlyUIHhet6JNT58PHdm4RCLCs=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-8Dri5kxRNzSkjBbay6SgVQ-1; Wed, 14 Jul 2021 06:06:25 -0400
X-MC-Unique: 8Dri5kxRNzSkjBbay6SgVQ-1
Received: by mail-pj1-f72.google.com with SMTP id c10-20020a17090a558ab029017019f7ec8fso972587pji.8
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 03:06:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5z87lSglp1R+XOAVM/WPJyePD3cVLLHAqajJ2nmRuNY=;
        b=lt+d9jFfnaBT3JIuk8g7vgcpcEJxuErOyHxtgg7jgcFQy9FA/zBaY0gyCm8sURkEPv
         GrFtGtQEEXUcnC2xZQ+l6Sb5nA1zv5Lw9VWF77VzUp3/V0sohf0wHGd0L+oN7jknalNA
         kNPEmt2iharMC4GNGrPe+S6UZgz2UDBhCcqRv6eWPSpFlrVgCFhkR4LpJH+jCEFd2JXH
         ZvEXHXzNbkAt8u7Fcz+SrN6FDYYzNOTt3X6VPDtPU82dqfsGmLbpINW6VkzqTjJWdqSL
         V5lHnBPio9DuMEnlPPdS7CC5gspgwiev/Xuv+3kWAtdXO6JQnAXnOKvfJQC8069e3LBw
         /5oQ==
X-Gm-Message-State: AOAM533zVbCDTX/Jhq9g93GjBLQPcMGDmljbdan13Su4oig3nRkmyAwU
        84EZ11LgF+4kQX+3J+vnkW9KW2aVTA87vKnYCUor3kfJaSnqr73yCtWfZT1Hftry/zY3vNuk6Mh
        +tdg4NTD6CxGyC68vWHAtDg==
X-Received: by 2002:a05:6a00:21c6:b029:2ff:e9:94f0 with SMTP id t6-20020a056a0021c6b02902ff00e994f0mr9358633pfj.73.1626257183676;
        Wed, 14 Jul 2021 03:06:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6BH1KDkaDglMcsb1sHfAdf31lDRnWrfXVfrHBr6CWmn26IX5/bsCm08R0+f8SkbhC2prdFg==
X-Received: by 2002:a05:6a00:21c6:b029:2ff:e9:94f0 with SMTP id t6-20020a056a0021c6b02902ff00e994f0mr9358614pfj.73.1626257183488;
        Wed, 14 Jul 2021 03:06:23 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.217.185])
        by smtp.gmail.com with ESMTPSA id 125sm2227030pfg.52.2021.07.14.03.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 03:06:21 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 5/5] doc: document new CephFS mount device syntax
Date:   Wed, 14 Jul 2021 15:35:54 +0530
Message-Id: <20210714100554.85978-6-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714100554.85978-1-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 Documentation/filesystems/ceph.rst | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 7d2ef4e27273..4942e018db85 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -82,7 +82,7 @@ Mount Syntax
 
 The basic mount syntax is::
 
- # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
+ # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_addr=monip1[:port][/monip2[:port]]
 
 You only need to specify a single monitor, as the client will get the
 full list when it connects.  (However, if the monitor you specify
@@ -90,16 +90,35 @@ happens to be down, the mount won't succeed.)  The port can be left
 off if the monitor is using the default.  So if the monitor is at
 1.2.3.4::
 
- # mount -t ceph 1.2.3.4:/ /mnt/ceph
+ # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_addr=1.2.3.4
 
 is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
-used instead of an IP address.
+used instead of an IP address and the cluster FSID can be left out
+(as the mount helper will fill it in by reading the ceph configuration
+file)::
 
+  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=mon-addr
 
+Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
+
+  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_addr=192.168.1.100/192.168.1.101
+
+When using the mount helper, monitor address can be read from ceph
+configuration file if available. Note that, the cluster FSID (passed as part
+of the device string) is validated by checking it with the FSID reported by
+the monitor.
 
 Mount Options
 =============
 
+  mon_addr=ip_address[:port][/ip_address[:port]]
+	Monitor address to the cluster. This is used to bootstrap the
+        connection to the cluster. Once connection is established, the
+        monitor addresses in the monitor map are followed.
+
+  fsid=cluster-id
+	FSID of the cluster (from `ceph fsid` command).
+
   ip=A.B.C.D[:N]
 	Specify the IP and/or port the client should bind to locally.
 	There is normally not much reason to do this.  If the IP is not
-- 
2.27.0

