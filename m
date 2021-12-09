Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65D46EDDF
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 17:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241417AbhLIQ5g (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 11:57:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241393AbhLIQ53 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 11:57:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639068835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aXR72X5MULjXcnlV1FTAKcN8vQ00AcBm3sStyaADoaY=;
        b=Z7lFZPQ5B5kGYRQwS+TKhmMPxFgmGAFAKjQDpsZWmqGBKiZCB1yGn5BVnM+OOgOGF1IM48
        XXJEQbQk0cf9sfSz77T2mI8k5cg9Ms5RVb+tPeQUej+3XJS0CIcHjNKZ6BVtVSxP15xpDs
        49uplxnXbT9SCEdNYbJda/6KVMUQUoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-3ZrxcnnSPpudYmwXphL-3A-1; Thu, 09 Dec 2021 11:53:54 -0500
X-MC-Unique: 3ZrxcnnSPpudYmwXphL-3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75F5C835E25;
        Thu,  9 Dec 2021 16:53:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34BE65E24E;
        Thu,  9 Dec 2021 16:53:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v2 01/67] fscache, cachefiles: Disable configuration
From:   David Howells <dhowells@redhat.com>
To:     linux-cachefs@redhat.com
Cc:     dhowells@redhat.com, Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 09 Dec 2021 16:53:48 +0000
Message-ID: <163906882835.143852.11073015983885872901.stgit@warthog.procyon.org.uk>
In-Reply-To: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Disable fscache and cachefiles in Kconfig whilst it is rewritten.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cachefs@redhat.com
Link: https://lore.kernel.org/r/163819576672.215744.12444272479560406780.stgit@warthog.procyon.org.uk/ # v1
---

 fs/9p/Kconfig      |    2 +-
 fs/afs/Kconfig     |    2 +-
 fs/ceph/Kconfig    |    2 +-
 fs/cifs/Kconfig    |    2 +-
 fs/fscache/Kconfig |    3 +++
 fs/nfs/Kconfig     |    2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/9p/Kconfig b/fs/9p/Kconfig
index d7bc93447c85..b3d33b3ddb98 100644
--- a/fs/9p/Kconfig
+++ b/fs/9p/Kconfig
@@ -14,7 +14,7 @@ config 9P_FS
 if 9P_FS
 config 9P_FSCACHE
 	bool "Enable 9P client caching support"
-	depends on 9P_FS=m && FSCACHE || 9P_FS=y && FSCACHE=y
+	depends on 9P_FS=m && FSCACHE_OLD_API || 9P_FS=y && FSCACHE_OLD_API=y
 	help
 	  Choose Y here to enable persistent, read-only local
 	  caching support for 9p clients using FS-Cache
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index fc8ba9142f2f..c40cdfcc25d1 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -25,7 +25,7 @@ config AFS_DEBUG
 
 config AFS_FSCACHE
 	bool "Provide AFS client caching support"
-	depends on AFS_FS=m && FSCACHE || AFS_FS=y && FSCACHE=y
+	depends on AFS_FS=m && FSCACHE_OLD_API || AFS_FS=y && FSCACHE_OLD_API=y
 	help
 	  Say Y here if you want AFS data to be cached locally on disk through
 	  the generic filesystem cache manager
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 94df854147d3..61f123356c3e 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -21,7 +21,7 @@ config CEPH_FS
 if CEPH_FS
 config CEPH_FSCACHE
 	bool "Enable Ceph client caching support"
-	depends on CEPH_FS=m && FSCACHE || CEPH_FS=y && FSCACHE=y
+	depends on CEPH_FS=m && FSCACHE_OLD_API || CEPH_FS=y && FSCACHE_OLD_API=y
 	help
 	  Choose Y here to enable persistent, read-only local
 	  caching support for Ceph clients using FS-Cache
diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index 3b7e3b9e4fd2..346ae8716deb 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -188,7 +188,7 @@ config CIFS_SMB_DIRECT
 
 config CIFS_FSCACHE
 	bool "Provide CIFS client caching support"
-	depends on CIFS=m && FSCACHE || CIFS=y && FSCACHE=y
+	depends on CIFS=m && FSCACHE_OLD_API || CIFS=y && FSCACHE_OLD_API=y
 	help
 	  Makes CIFS FS-Cache capable. Say Y here if you want your CIFS data
 	  to be cached locally on disk through the general filesystem cache
diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index b313a978ae0a..76316c4a3fb7 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -38,3 +38,6 @@ config FSCACHE_DEBUG
 	  enabled by setting bits in /sys/modules/fscache/parameter/debug.
 
 	  See Documentation/filesystems/caching/fscache.rst for more information.
+
+config FSCACHE_OLD_API
+	bool
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 14a72224b657..bdc11b89eac5 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -170,7 +170,7 @@ config ROOT_NFS
 
 config NFS_FSCACHE
 	bool "Provide NFS client caching support"
-	depends on NFS_FS=m && FSCACHE || NFS_FS=y && FSCACHE=y
+	depends on NFS_FS=m && FSCACHE_OLD_API || NFS_FS=y && FSCACHE_OLD_API=y
 	help
 	  Say Y here if you want NFS data to be cached locally on disc through
 	  the general filesystem cache manager


