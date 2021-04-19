Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99655363966
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Apr 2021 04:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbhDSCdV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 18 Apr 2021 22:33:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20600 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232038AbhDSCdU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 18 Apr 2021 22:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618799571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iFz9n4mBkTaZSyU3SpYrvbFCH+G+UqyCQa9LgBn7/w4=;
        b=NV/jM2NLYLBQRsKLOn/BIrOCINISJyqRCGMKDhGKowo4tCzYuIQg1dWwn9wKMEnd22nRln
        ew/bW+nMQiig1lZX3pE76bEnpK7uJdC1PrmgEsN/lllW2fA3RKw9dQQjMUG1tqTZ2kSGN9
        2/VBIgaP17BxAU/jrnnK7u0Z8gGfZbA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-3cw3uPCHM_uf7jLQwr1HWw-1; Sun, 18 Apr 2021 22:32:42 -0400
X-MC-Unique: 3cw3uPCHM_uf7jLQwr1HWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EB2518397A3;
        Mon, 19 Apr 2021 02:32:41 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DF435D9CD;
        Mon, 19 Apr 2021 02:32:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: make the lost+found dir accessible by kernel client
Date:   Mon, 19 Apr 2021 10:32:37 +0800
Message-Id: <20210419023237.1177430-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Inode number 0x4 is reserved for the lost+found dir, and the app
or test app need to access it.

URL: https://tracker.ceph.com/issues/50216
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.h              | 3 ++-
 include/linux/ceph/ceph_fs.h | 7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 4808a1458c9b..0f38e6183ff0 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -542,7 +542,8 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
 
 static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
 {
-	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
+	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT &&
+	    vino.ino != CEPH_INO_LOST_AND_FOUND ) {
 		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
 		return true;
 	}
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index e41a811026f6..57e5bd63fb7a 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -27,9 +27,10 @@
 #define CEPH_MONC_PROTOCOL   15 /* server/client */
 
 
-#define CEPH_INO_ROOT   1
-#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
-#define CEPH_INO_DOTDOT 3	/* used by ceph fuse for parent (..) */
+#define CEPH_INO_ROOT           1
+#define CEPH_INO_CEPH           2 /* hidden .ceph dir */
+#define CEPH_INO_DOTDOT         3 /* used by ceph fuse for parent (..) */
+#define CEPH_INO_LOST_AND_FOUND 4 /* lost+found dir */
 
 /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
 #define CEPH_MAX_MON   31
-- 
2.27.0

