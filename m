Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22C374877B
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfFQPiL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728519AbfFQPiK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9AF2147A;
        Mon, 17 Jun 2019 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785889;
        bh=QcOnqNpzplixhuP1nCon2irlFxVrwyg1/XFSCQvbxrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZbdSZ1RR8GICKEM3rwDhgMU9wMF8uDvN3m4bpgIHQG9zzpI36Zj+yiEpJUONpyDfH
         o4S5WWNNrKXbWONvYN+4vIBMBz0ynzfsRlsmROzYO16Pg9LMl4j+5SQ7s0KWUHxFJB
         UfSaAWyM5sCm7+hmEnNq12okjMDXwHsN+QUJcgVs=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 18/18] ceph: increment change_attribute on local changes
Date:   Mon, 17 Jun 2019 11:37:53 -0400
Message-Id: <20190617153753.3611-19-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
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

