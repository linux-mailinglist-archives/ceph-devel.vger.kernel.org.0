Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409CE65F95
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2019 20:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbfGKSlq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 14:41:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730254AbfGKSlp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 14:41:45 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C157821670;
        Thu, 11 Jul 2019 18:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562870504;
        bh=1JH4tf4jiow3lEBaL51zTDXAkTduOhO52oShpIklJsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xv5CiWiEGWb6okS0E9VdKUHK5t8pcoX5AlcthQ2TU5IDf18ygkFeOpefsLi0Psbot
         9jOxW9dOW4C98HnJtKa0j3wpyqil0un30+8T3rtTmQIuHydNf8ZlM9VXrG0PatkPQE
         OGt9HT6jUmaBtipPIee5bCkF6UkhdmiJggBwIR7k=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com,
        lhenriques@suse.com
Subject: [PATCH v2 5/5] ceph: handle inlined files in copy_file_range
Date:   Thu, 11 Jul 2019 14:41:36 -0400
Message-Id: <20190711184136.19779-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711184136.19779-1-jlayton@kernel.org>
References: <20190711184136.19779-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If the src is inlined, then just bail out. Have it attempt to uninline
the dst file however.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 252aac44b8ce..774f51b0b63d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1934,6 +1934,10 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	if (len < src_ci->i_layout.object_size)
 		return -EOPNOTSUPP; /* no remote copy will be done */
 
+	/* Fall back if src file is inlined */
+	if (READ_ONCE(src_ci->i_inline_version) != CEPH_INLINE_NONE)
+		return -EOPNOTSUPP;
+
 	prealloc_cf = ceph_alloc_cap_flush();
 	if (!prealloc_cf)
 		return -ENOMEM;
@@ -1967,6 +1971,13 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	if (ret < 0)
 		goto out_caps;
 
+	/* uninline the dst inode */
+	dirty = ceph_uninline_data(dst_inode, NULL);
+	if (dirty < 0) {
+		ret = dirty;
+		goto out_caps;
+	}
+
 	size = i_size_read(dst_inode);
 	endoff = dst_off + len;
 
@@ -2080,7 +2091,7 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	/* Mark Fw dirty */
 	spin_lock(&dst_ci->i_ceph_lock);
 	dst_ci->i_inline_version = CEPH_INLINE_NONE;
-	dirty = __ceph_mark_dirty_caps(dst_ci, CEPH_CAP_FILE_WR, &prealloc_cf);
+	dirty |= __ceph_mark_dirty_caps(dst_ci, CEPH_CAP_FILE_WR, &prealloc_cf);
 	spin_unlock(&dst_ci->i_ceph_lock);
 	if (dirty)
 		__mark_inode_dirty(dst_inode, dirty);
-- 
2.21.0

