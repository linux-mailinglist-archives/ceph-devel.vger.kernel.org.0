Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A972D24C1E3
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Aug 2020 17:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgHTPN6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Aug 2020 11:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbgHTPNv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 11:13:51 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 471B62086A;
        Thu, 20 Aug 2020 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597936431;
        bh=UtI35lAfwwhn6/04T4UDAaFaumi1nbwxWgafEBXA4yk=;
        h=From:To:Cc:Subject:Date:From;
        b=KsiSJnojbfUBsZAwjm8IwduQswLOPaSitvw4k9Kdg8YkGRR/4hk4JFMIzhzjwGJmz
         DtutnP9EzkW/5R69YiG/DynWCnTs10+Gf47hQ9LRlON2o8jTm5lZJcAdEm1j1irsu5
         0jxu4o5xHm9HyMZBnlx+omRcCp3aE78ig6mcxc+Q=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: don't allow setlease on cephfs
Date:   Thu, 20 Aug 2020 11:13:49 -0400
Message-Id: <20200820151349.60203-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Leases don't currently work correctly on kcephfs, as they are not broken
when caps are revoked. They could eventually be implemented similarly to
how we did them in libcephfs, but for now don't allow them.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c  | 2 ++
 fs/ceph/file.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 040eaad9d063..34f669220a8b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1935,6 +1935,7 @@ const struct file_operations ceph_dir_fops = {
 	.compat_ioctl = compat_ptr_ioctl,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
+	.setlease = simple_nosetlease,
 	.flock = ceph_flock,
 };
 
@@ -1943,6 +1944,7 @@ const struct file_operations ceph_snapdir_fops = {
 	.llseek = ceph_dir_llseek,
 	.open = ceph_open,
 	.release = ceph_release,
+	.setlease = simple_nosetlease,
 };
 
 const struct inode_operations ceph_dir_iops = {
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 27c7047c9383..fb3ea715a19d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2505,6 +2505,7 @@ const struct file_operations ceph_file_fops = {
 	.mmap = ceph_mmap,
 	.fsync = ceph_fsync,
 	.lock = ceph_lock,
+	.setlease = simple_nosetlease,
 	.flock = ceph_flock,
 	.splice_read = generic_file_splice_read,
 	.splice_write = iter_file_splice_write,
-- 
2.26.2

