Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706A7AEE5E
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Sep 2019 17:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393788AbfIJPSR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 11:18:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35149 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730990AbfIJPSQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 11:18:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id n10so25981wmj.0
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lUx8mf2j7FCeZbe5kdr0Ycq1aCHjlSkQsxKuMV6H8wg=;
        b=g+Pk7vjehsQ+k7H7yhtfk4p0vETGKtsgnaVZxSBSgQW8Gx/GHrwKBggZMVSgwQ8fLw
         LT/lM94MGtJYZBogKf9LOf2+IwARsN2C/e882rA90eQJs8iyE5zVStz9jUIMNzJU9ngg
         OUn3t3JZE40zzMwkRU5XFDEvf/128lGGyYSEyn3psONRolc8fK/9N6d4gcVzoLqKTbtu
         WsOm3cMjW9jyHOToXlkfgJKQRJmSE4yR31mYXqcPQK7Q1UzV/5agUUggWs8voCaFvhI+
         igKRGO7ZTwgp5qx5oCF7AZfHsoq3NcsgttCl/esZ+T4VmKq5eGwTZi3vLnAo5DOE9gPO
         0A0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lUx8mf2j7FCeZbe5kdr0Ycq1aCHjlSkQsxKuMV6H8wg=;
        b=LW402GTXQa6WZ2X+zHjOIxRuAU6w7FwmAY07EZxDiX6ULaQ4cEzx1QBIH+KFf5Yq0Y
         gUwUFyEVX2dxtzu+s9YhPz0f14EXrjtJvQQ9Y9mi0GSqfzT13rEqgIXihdQAhdJGUu96
         x1spIJW8PCzDVI/V5DHRg3oUtIFKtOr6SnWOM7DCMYfb32I5Ode/TdaFjstb1L1OW/DK
         hD97+haH3Eekj5D1o3HT8K4gr2LTLETDEMTUUJlktawaNpgoDBg5A1iAkiDPFq1PI+Q8
         H8eRe2N7QMJLVJMfsj4r/gsWG/AlGh9O5zyEAWPWL43yf6K9N6/L3DgnMQ17yQ5BlBAq
         hoJw==
X-Gm-Message-State: APjAAAV2YoMcp1LnO6ELuXcaLex4n13/F2ak0z708sBluBhdc8UZ7Tf2
        Pp7hIMv/1H9fN5+gPpH/W3+SgOl6xw4=
X-Google-Smtp-Source: APXvYqyNhVWscnbM2MNkm1KFBOp8QT+vmt+0ix55w5bW6Cpeud1fA0J2pVdfk2pzjZANRkE1z+gGqw==
X-Received: by 2002:a7b:cc0a:: with SMTP id f10mr26521wmh.6.1568128694784;
        Tue, 10 Sep 2019 08:18:14 -0700 (PDT)
Received: from kwango.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z11sm16998016wrg.17.2019.09.10.08.18.13
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 08:18:13 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] libceph: avoid a __vmalloc() deadlock in ceph_kvmalloc()
Date:   Tue, 10 Sep 2019 17:17:48 +0200
Message-Id: <20190910151748.914-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The vmalloc allocator doesn't fully respect the specified gfp mask:
while the actual pages are allocated as requested, the page table pages
are always allocated with GFP_KERNEL.  ceph_kvmalloc() may be called
with GFP_NOFS and GFP_NOIO (for ceph and rbd respectively), so this may
result in a deadlock.

There is no real reason for the current PAGE_ALLOC_COSTLY_ORDER logic,
it's just something that seemed sensible at the time (ceph_kvmalloc()
predates kvmalloc()).  kvmalloc() is smarter: in an attempt to reduce
long term fragmentation, it first tries to kmalloc non-disruptively.

Switch to kvmalloc() and set the respective PF_MEMALLOC_* flag using
the scope API to avoid the deadlock.  Note that kvmalloc() needs to be
passed GFP_KERNEL to enable the fallback.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/ceph_common.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index c41789154cdb..970e74b46213 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -13,6 +13,7 @@
 #include <linux/nsproxy.h>
 #include <linux/fs_parser.h>
 #include <linux/sched.h>
+#include <linux/sched/mm.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/statfs.h>
@@ -185,18 +186,34 @@ int ceph_compare_options(struct ceph_options *new_opt,
 }
 EXPORT_SYMBOL(ceph_compare_options);
 
+/*
+ * kvmalloc() doesn't fall back to the vmalloc allocator unless flags are
+ * compatible with (a superset of) GFP_KERNEL.  This is because while the
+ * actual pages are allocated with the specified flags, the page table pages
+ * are always allocated with GFP_KERNEL.  map_vm_area() doesn't even take
+ * flags because GFP_KERNEL is hard-coded in {p4d,pud,pmd,pte}_alloc().
+ *
+ * ceph_kvmalloc() may be called with GFP_KERNEL, GFP_NOFS or GFP_NOIO.
+ */
 void *ceph_kvmalloc(size_t size, gfp_t flags)
 {
-	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
-		void *ptr = kmalloc(size, flags | __GFP_NOWARN);
-		if (ptr)
-			return ptr;
+	void *p;
+
+	if ((flags & (__GFP_IO | __GFP_FS)) == (__GFP_IO | __GFP_FS)) {
+		p = kvmalloc(size, flags);
+	} else if ((flags & (__GFP_IO | __GFP_FS)) == __GFP_IO) {
+		unsigned int nofs_flag = memalloc_nofs_save();
+		p = kvmalloc(size, GFP_KERNEL);
+		memalloc_nofs_restore(nofs_flag);
+	} else {
+		unsigned int noio_flag = memalloc_noio_save();
+		p = kvmalloc(size, GFP_KERNEL);
+		memalloc_noio_restore(noio_flag);
 	}
 
-	return __vmalloc(size, flags, PAGE_KERNEL);
+	return p;
 }
 
-
 static int parse_fsid(const char *str, struct ceph_fsid *fsid)
 {
 	int i = 0;
-- 
2.19.2

