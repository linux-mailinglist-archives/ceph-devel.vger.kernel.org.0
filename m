Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEE839B1D1
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 07:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFDFH1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 01:07:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229801AbhFDFH1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Jun 2021 01:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622783141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ACzH0AkzY9kFOE+5ls/yoXa3JG1amoUDFZvgvLzewBY=;
        b=VWEu0wgqNq6mT5a8nK8YnUVO0nGumHriXYfIFK/efWImXWxTiScdhNxJdo762FWAlFIbQs
        P6aHeq+BiPQmBIuJrbhvN7mncYiNXF5dOtw3B4YeEiuHe5pmpkMN/3yyb+RlWnrPXH7GcD
        VYhCGtN1ma1oBt8tsQc/2t/tDeKt81U=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-DkyK_swPPbeocMu6GOmgxw-1; Fri, 04 Jun 2021 01:05:40 -0400
X-MC-Unique: DkyK_swPPbeocMu6GOmgxw-1
Received: by mail-pj1-f70.google.com with SMTP id f8-20020a17090a9b08b0290153366612f7so4536976pjp.1
        for <ceph-devel@vger.kernel.org>; Thu, 03 Jun 2021 22:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ACzH0AkzY9kFOE+5ls/yoXa3JG1amoUDFZvgvLzewBY=;
        b=QYVPtYfXgL78lTvgdbmNGtFkj4Og3LiEnpFXIIaoBtmtOGVSJK9lgAtH4Hty7hr0rb
         m3F3qCoA447iJ/JFK+c/FcpGqvRK5Towv0d3ZR8WF0qJP7TNut1b7G+E2b5L2O19gq4g
         V4Tdvs3Hm9cOTkq9880hPJNa/udXiHHzyWEQauGmPxj4qnjw9buKKPIr0SOWFdlfLhmF
         xMWvmgUtLfYm7FX9jCrjBucmAAR2w8z/KOjSam1xNrd9CF3LL/Xoz6/WnJPKFdg4gdg1
         kdutG2aT/QmKAAMW/R03sYXUMR1AzzgXReoT2+SjNF+wokGkvSW0H1CAZY/YEj6gCv5W
         Uopg==
X-Gm-Message-State: AOAM531WD6SnrqS4gSkdgu1ceYtkjzG8n+Mf201Lhdp+KqX+Eq1Uo0us
        S+APKiE1Nj4mE0mTZA+tcDpswARt0okz1eBElA+5P511xQ0rhzd97v0Cxyuj0U/D5xmCxd8C+3f
        ShjI9dCfP+3csZAjZKE5sMA==
X-Received: by 2002:a63:dd4b:: with SMTP id g11mr3024815pgj.300.1622783138711;
        Thu, 03 Jun 2021 22:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyNXn0u7QmghOv5sgw8Jk3t/k+g0vNU8psflYZWzffBdS34t6hCROUIIOuya84N6xL3qXS0g==
X-Received: by 2002:a63:dd4b:: with SMTP id g11mr3024798pgj.300.1622783138493;
        Thu, 03 Jun 2021 22:05:38 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.207.151])
        by smtp.gmail.com with ESMTPSA id s20sm3634897pjn.23.2021.06.03.22.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 22:05:38 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 3/3] doc: document new CephFS mount device syntax
Date:   Fri,  4 Jun 2021 10:35:12 +0530
Message-Id: <20210604050512.552649-4-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604050512.552649-1-vshankar@redhat.com>
References: <20210604050512.552649-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 Documentation/filesystems/ceph.rst | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 7d2ef4e27273..0e4ccefb7aea 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -82,7 +82,7 @@ Mount Syntax
 
 The basic mount syntax is::
 
- # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
+ # mount -t ceph user@fs_name=/[subdir] mnt -o mon_host=monip1[:port][/monip2[:port]]
 
 You only need to specify a single monitor, as the client will get the
 full list when it connects.  (However, if the monitor you specify
@@ -90,16 +90,26 @@ happens to be down, the mount won't succeed.)  The port can be left
 off if the monitor is using the default.  So if the monitor is at
 1.2.3.4::
 
- # mount -t ceph 1.2.3.4:/ /mnt/ceph
+ # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=1.2.3.4
 
 is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
-used instead of an IP address.
+used instead of an IP address. Multiple monitor addresses can be
+passed by separating each address with a slash (`/`)::
 
+  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=192.168.1.100/192.168.1.101
 
+When using the mount helper, monitor address can be read from ceph
+configuration file if available.
 
 Mount Options
 =============
 
+  mon_host=ip_address[:port][/ip_address[:port]]
+	Monitor address to the cluster
+
+  fsid=cluster-id
+	FSID of the cluster
+
   ip=A.B.C.D[:N]
 	Specify the IP and/or port the client should bind to locally.
 	There is normally not much reason to do this.  If the IP is not
-- 
2.27.0

