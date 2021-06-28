Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A943B5A2B
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 09:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhF1H6b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 03:58:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232317AbhF1H6a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 03:58:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624866964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ei9np5dyF4bOpwEaKKW/3KrcFjx/uy1Dba5DpeOc0ik=;
        b=FFa1JcWcsO9M8WWVZL4flguJqV7vkq1MmH+xirJJ1IFDtWw+dLbYAogklAYUz4qhWOs0su
        GRzbOqxt2zxyMvL4xjmEgGIh16MhgmIOv0WVSX7j71bgKlLHXG+lJGLDi3fWgDJ844hBdP
        K5TvVfRQCoeoH8kZvH+euH6VReLY3ok=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-rXpBzRy4PumuFZG74PHpjg-1; Mon, 28 Jun 2021 03:56:03 -0400
X-MC-Unique: rXpBzRy4PumuFZG74PHpjg-1
Received: by mail-pl1-f197.google.com with SMTP id a6-20020a1709027d86b02901019f88b046so5433654plm.21
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 00:56:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ei9np5dyF4bOpwEaKKW/3KrcFjx/uy1Dba5DpeOc0ik=;
        b=cRwryHRngOVo4PkKR12x/lzAAt3iliy4jr4C/TySXOpxogObfHkiitFaMLAUhjPr4K
         pkezsq0Bn9YpPjgXf951m6ThcTEOIwg7d+flKX2sFPKb5yMZ0EtZiieS6+ciGd+g8gWR
         k1t89Ig5xoanamkKWbigCKxCGqhElHLj5WgTm4sE4HYtn3aq0jcZQK3C4sCGcyBB8gNT
         OBgP44cyv1zPfeqzsLhmPaT5CWpr80gJLWDSAppMhrSOmwj/laAI5GjMh6nQdktk7FKM
         fyDZNpnP3BTXjvTTjspMhIsOHY/N6FBByMjbYvKmPQ4z1/TOR3Z1Ta3Rxh2730oBzhXN
         /f0g==
X-Gm-Message-State: AOAM532oIYMGvlMxsTkGMMYPJzeKwM0RkAAFFQBEACA15oSFZpjfzJhV
        khpMo6cNtaonFexyaJMAw6iSmerU56sgsS1gWs+PMeHpRhAWKxPXGRNGOZNfNvd9dgaZlGLbSij
        NwmPoYkTaLWxhKr313G/wuw==
X-Received: by 2002:a62:dd8b:0:b029:2e9:731a:e22e with SMTP id w133-20020a62dd8b0000b02902e9731ae22emr23405270pff.69.1624866962250;
        Mon, 28 Jun 2021 00:56:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkFR5vMnFmW0Mmz3RSrP6kb6axAH8h/cABDxSWcjxLgD6NKorqBdTtmrrPtPYSY1r/51MEZg==
X-Received: by 2002:a62:dd8b:0:b029:2e9:731a:e22e with SMTP id w133-20020a62dd8b0000b02902e9731ae22emr23405256pff.69.1624866962075;
        Mon, 28 Jun 2021 00:56:02 -0700 (PDT)
Received: from localhost.localdomain ([49.207.209.6])
        by smtp.gmail.com with ESMTPSA id g123sm8304959pfb.187.2021.06.28.00.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 00:56:01 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Venky Shankar <vshankar@redhat.com>
Subject: [PATCH 4/4] doc: document new CephFS mount device syntax
Date:   Mon, 28 Jun 2021 13:25:45 +0530
Message-Id: <20210628075545.702106-5-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210628075545.702106-1-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 Documentation/filesystems/ceph.rst | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 7d2ef4e27273..e46f9091b851 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -82,7 +82,7 @@ Mount Syntax
 
 The basic mount syntax is::
 
- # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
+ # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_host=monip1[:port][/monip2[:port]]
 
 You only need to specify a single monitor, as the client will get the
 full list when it connects.  (However, if the monitor you specify
@@ -90,16 +90,33 @@ happens to be down, the mount won't succeed.)  The port can be left
 off if the monitor is using the default.  So if the monitor is at
 1.2.3.4::
 
- # mount -t ceph 1.2.3.4:/ /mnt/ceph
+ # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_host=1.2.3.4
 
 is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
-used instead of an IP address.
+used instead of an IP address and the cluster FSID can be left out
+(as the mount helper will fill it in by reading the ceph configuration
+file)::
 
+  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=mon-addr
 
+Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
+
+  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=192.168.1.100/192.168.1.101
+
+When using the mount helper, monitor address can be read from ceph
+configuration file if available. Note that, the cluster FSID (passed as part
+of the device string) is validated by checking it with the FSID reported by
+the monitor.
 
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

