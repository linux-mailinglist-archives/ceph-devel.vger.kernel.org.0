Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5470344C694
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Nov 2021 19:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbhKJSDj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Nov 2021 13:03:39 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50814 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230100AbhKJSDi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 13:03:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636567250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8mDIdVNyh6fE2TUYtPG7++IpEZUIiOryl/ta8VIQ2rk=;
        b=eTVVN9XGKzTR++d5DkGojioiqcALcz2AkAFM0k2CxjyZRE+g2p1bl9IRyI2vCVgwUFpj9m
        s6LJGqSlgtAe4/W+UJ8ZglHJCZ0rdIzHGNV0o+at/ShVRV3Ougr0+x+vMotzZNyYAxeWwH
        wLSjhl/Wf7jOAQ9IcHrNPbZxv5IaitU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-h8xgqfiWNJGo9CTy9o6bew-1; Wed, 10 Nov 2021 13:00:47 -0500
X-MC-Unique: h8xgqfiWNJGo9CTy9o6bew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B69E804173;
        Wed, 10 Nov 2021 18:00:46 +0000 (UTC)
Received: from fedora2.. (unknown [10.67.24.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 673D31971F;
        Wed, 10 Nov 2021 18:00:44 +0000 (UTC)
From:   khiremat@redhat.com
To:     jlayton@redhat.com
Cc:     pdonnell@redhat.com, idryomov@gmail.com, xiubli@redhat.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v2 1/1] ceph: Fix incorrect statfs report for small quota
Date:   Wed, 10 Nov 2021 23:30:21 +0530
Message-Id: <20211110180021.20876-2-khiremat@redhat.com>
In-Reply-To: <20211110180021.20876-1-khiremat@redhat.com>
References: <20211110180021.20876-1-khiremat@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Kotresh HR <khiremat@redhat.com>

Problem:
The statfs reports incorrect free/available space
for quota less then CEPH_BLOCK size (4M).

Solution:
For quota less than CEPH_BLOCK size, smaller block
size of 4K is used. But if quota is less than 4K,
it is decided to go with binary use/free of 4K
block. For quota size less than 4K size, report the
total=used=4K,free=0 when quota is full and
total=free=4K,used=0 otherwise.

Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/quota.c | 14 ++++++++++++++
 fs/ceph/super.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 620c691af40e..24ae13ea2241 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -494,10 +494,24 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 		if (ci->i_max_bytes) {
 			total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
 			used = ci->i_rbytes >> CEPH_BLOCK_SHIFT;
+			/* For quota size less than 4MB, use 4KB block size */
+			if (!total) {
+				total = ci->i_max_bytes >> CEPH_4K_BLOCK_SHIFT;
+				used = ci->i_rbytes >> CEPH_4K_BLOCK_SHIFT;
+	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
+			}
 			/* It is possible for a quota to be exceeded.
 			 * Report 'zero' in that case
 			 */
 			free = total > used ? total - used : 0;
+			/* For quota size less than 4KB, report the
+			 * total=used=4KB,free=0 when quota is full
+			 * and total=free=4KB, used=0 otherwise */
+			if (!total) {
+				total = 1;
+				free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
+	                        buf->f_frsize = 1 << CEPH_4K_BLOCK_SHIFT;
+			}
 		}
 		spin_unlock(&ci->i_ceph_lock);
 		if (total) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ed51e04739c4..387ee33894db 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -32,6 +32,7 @@
  * large volume sizes on 32-bit machines. */
 #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
+#define CEPH_4K_BLOCK_SHIFT 12  /* 4 KB */
 
 #define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blocklisted */
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
-- 
2.31.1

