Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABCC38F42
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfFGPih (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730020AbfFGPid (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:33 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9A7B21473;
        Fri,  7 Jun 2019 15:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921912;
        bh=QcOnqNpzplixhuP1nCon2irlFxVrwyg1/XFSCQvbxrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcJbKC/plLT6QqkOLN+V2w+w9iZES4/FW6sZD6ahYIzgnsuSBRk+atjZT5pdMh7/x
         8UIyttaKROz6jXpxb/u2NndXtjK3HQ9CJMwZQw88sbRINmpNBqet/qtCAAZWvvL36w
         ++VFSvuyGhCGCY6DXQ84XD/NFQ0RhW2wYHjDHscc=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 16/16] ceph: increment change_attribute on local changes
Date:   Fri,  7 Jun 2019 11:38:16 -0400
Message-Id: <20190607153816.12918-17-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We don't set SB_I_VERSION on ceph since we need to manage it ourselves,
so we must increment it whenever we update the file times.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 ++
 fs/ceph/file.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index a47c541f8006..e078cc55b989 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -10,6 +10,7 @@
 #include <linux/pagevec.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/signal.h>
+#include <linux/iversion.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -1576,6 +1577,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 
 	/* Update time before taking page lock */
 	file_update_time(vma->vm_file);
+	inode_inc_iversion_raw(inode);
 
 	do {
 		lock_page(page);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index a7080783fe20..e993ffeae9de 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -10,6 +10,7 @@
 #include <linux/namei.h>
 #include <linux/writeback.h>
 #include <linux/falloc.h>
+#include <linux/iversion.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -1434,6 +1435,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (err)
 		goto out;
 
+	inode_inc_iversion_raw(inode);
+
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
 		err = ceph_uninline_data(file, NULL);
 		if (err < 0)
@@ -2065,6 +2068,8 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		do_final_copy = true;
 
 	file_update_time(dst_file);
+	inode_inc_iversion_raw(dst_inode);
+
 	if (endoff > size) {
 		int caps_flags = 0;
 
-- 
2.21.0

