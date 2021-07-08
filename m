Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57D63BF709
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhGHIpv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 04:45:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231384AbhGHIpu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 04:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625733788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5z87lSglp1R+XOAVM/WPJyePD3cVLLHAqajJ2nmRuNY=;
        b=R+bj66X1GTsDzVMJtXSG5WU6DIUhWx9RoUpFW7Ca+LSVvGf1hbaCvqOGbcMQkaOE1FqaXY
        PqvxntuGDXs5tbqa+hosPgRADnLMfzN30xtuU4sPsQDk9oXAi3NoxByIwQxD1XrDk7az6O
        AtX3JVHPsENH0MJpI9dKMwZzMDZ4It4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-ULh2wJfXO1GN4hpuvTeu7g-1; Thu, 08 Jul 2021 04:43:07 -0400
X-MC-Unique: ULh2wJfXO1GN4hpuvTeu7g-1
Received: by mail-pj1-f71.google.com with SMTP id p22-20020a17090a9316b029016a0aced749so68997pjo.9
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jul 2021 01:43:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5z87lSglp1R+XOAVM/WPJyePD3cVLLHAqajJ2nmRuNY=;
        b=FHRKMCKZ4cW29wuL97vT1Rv1a1C1gHx6AZPkjbK9BYqjtjxnTLjSnk1bAuiBdtYEAA
         qZUbE4yLt7pElw9lnf4pJAZIz80zOAfxsVDMHp99r1elik7BveOoJCtQfaDU+qUKF9gQ
         kwHY//4TlpsXR3ntiHzVDM1clT2ue6rAnL14kgUEjj75gIkvxMoXxkFWfdBWKignXmUf
         Pc5/Hfo3l6UWJKByKAlwf6vuBZtGoXhLJ9pvosjl9grgTSZAmRZ1qyY1/rVpFCoqBFTV
         LN5mUomiHv+qpdWeevixhZ4xe5R5pdDMow3D0HFwLResBnD4cGZTTaCP/yJaRS6G6X/9
         6eAg==
X-Gm-Message-State: AOAM532ljnGkjVpf4ekTOJUdcy3JgoOMOFv0Mx5W80HMRk+zu3aPvPa0
        6Hze7XLWCzr5dRwLhgqoHaUTbQApe2S0utIR4/UkOTsiv+veTedxpHg2nFIzsi3TwJAKlgfrEuM
        A3H+THBLdixC9CoXlgvFC4Q==
X-Received: by 2002:a17:90a:df0b:: with SMTP id gp11mr1662904pjb.35.1625733786647;
        Thu, 08 Jul 2021 01:43:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5EWLwGHvJhcaRF8F4x2qA3gC7QDDsKvRGng0YHnuh8iqE7Fvqm65uamzt4idgHUnvaxd1dQ==
X-Received: by 2002:a17:90a:df0b:: with SMTP id gp11mr1662894pjb.35.1625733786471;
        Thu, 08 Jul 2021 01:43:06 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.223.150])
        by smtp.gmail.com with ESMTPSA id r14sm2154588pgm.28.2021.07.08.01.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 01:43:06 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 5/5] doc: document new CephFS mount device syntax
Date:   Thu,  8 Jul 2021 14:12:47 +0530
Message-Id: <20210708084247.182953-6-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210708084247.182953-1-vshankar@redhat.com>
References: <20210708084247.182953-1-vshankar@redhat.com>
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

