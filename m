Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5853B9C55
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 08:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhGBGvP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 02:51:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhGBGvP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 02:51:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5qheXNQOaNt/CDKPLuGTP9BqPAGQVa8s2zCFsVteMQ=;
        b=dh4wVPFkOYoKrjzd0oatL+cxij3uFLzLCZMgrqnE77j9FGVGEps+0BvajOaOmQNCHZqIUW
        6R1irysuBzu0PRF5+l9umTYP/zzzvWjZkQrpOOxmw4loqRYIHhiUQI3la2wJNag/FpqmpF
        nZDOf45zmQl3XeF0BqdRrX2bcRBisT0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466--ET9mHXaPP2gcFuK8Ki7og-1; Fri, 02 Jul 2021 02:48:42 -0400
X-MC-Unique: -ET9mHXaPP2gcFuK8Ki7og-1
Received: by mail-pf1-f197.google.com with SMTP id f9-20020a056a0022c9b029030058c72fafso5662221pfj.1
        for <ceph-devel@vger.kernel.org>; Thu, 01 Jul 2021 23:48:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g5qheXNQOaNt/CDKPLuGTP9BqPAGQVa8s2zCFsVteMQ=;
        b=MVG3zRWluISPJ7F344zGM82/G0jAjJ3l+oHmS1OawZWrRFnMlEuGBPhXzo6mc6EsIA
         aMPkiRMOewJeL1eP9UsjK4LvS5H0DG5osuL4pa4Wu0/csrBDp37Lewq6xvOXmMcKv9tc
         UVEdlXGnU/sXkKCudL68h7d1VOkPV1Vjw9O+yKkS+82dRBWrtCwkLruNP0ZIh3Le7x4g
         5k17Oq0ilc1+duNWiGont6CYVfoH70dlcZZT096/V+DDN+2bTxp0bsbeSA8I+2IU5oHk
         ydc4x+cAX8GURIA0BU8FsmPRVY13YeVQ13RXYV/dUmK92OO26iK3AvNcGMV9rLLzf2Zh
         V4Dw==
X-Gm-Message-State: AOAM532QNLZ3WE2agPBIV/QTr48agke2Of3gT65QA9quKKVaoH5HluR8
        CkngrXfA56Z32h/CmSwChCfbpJc2owpt4t+W7SS1hvNDcayLBquFzNgHgGhoZbiJ+SeCDwNdLFv
        nPVOMffLfKi9lGekOfhYjzw==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr3585938pjb.214.1625208521533;
        Thu, 01 Jul 2021 23:48:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDx7VAyW5semyHIsbkJ4sv19sgRzrmCINdEVj6UH6HfiSKOEzvZdeRpL9WFnqb4AG1JysBwg==
X-Received: by 2002:a17:90b:4b87:: with SMTP id lr7mr3585920pjb.214.1625208521302;
        Thu, 01 Jul 2021 23:48:41 -0700 (PDT)
Received: from localhost.localdomain ([49.207.212.118])
        by smtp.gmail.com with ESMTPSA id o34sm2394364pgm.6.2021.07.01.23.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 23:48:40 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v2 4/4] doc: document new CephFS mount device syntax
Date:   Fri,  2 Jul 2021 12:18:21 +0530
Message-Id: <20210702064821.148063-5-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210702064821.148063-1-vshankar@redhat.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
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
index 7d2ef4e27273..830ea8969d9d 100644
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
+	FSID of the cluster
+
   ip=A.B.C.D[:N]
 	Specify the IP and/or port the client should bind to locally.
 	There is normally not much reason to do this.  If the IP is not
-- 
2.27.0

