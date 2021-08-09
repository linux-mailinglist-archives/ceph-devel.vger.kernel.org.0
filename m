Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FB13E4A27
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Aug 2021 18:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhHIQod (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Aug 2021 12:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhHIQod (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 12:44:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 221CF60F35;
        Mon,  9 Aug 2021 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628527452;
        bh=zDRTU84UIQdfBCy4ZKMyNF+WQ86KUiaAMKkdOYmz0VA=;
        h=From:To:Cc:Subject:Date:From;
        b=e9j4xKENH315UK4S0u+QRZANg3As+QCerly9ydthSQdgIRAJKdhGFuePmvnAVw3Hl
         q5aUg15PxqMlyhmT1rcKtOy8TF/JdlWb2BmSxhbu0XKx8KzTi9k5OZh6RACsmj8Mvz
         DuBj/KslKVPL6oOQaAotPCLNXyfdiBMOFgi3HKBTa3Z2nEJ1mcOTIj9XWdAGTPa3cZ
         +ulzK+e7adqTY1lE/3M4qHYI4AyD74kfUi4doa13NjV5wwvGjVpRrXDeMn0y5ZCT/x
         R4gCTJAQb42rk9+DzqVyikKL77PTo3M9LZWcYL/Iki+N5uhqwqVsgv96/AN/GBH+1W
         /lPlwOl4JF3bQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>
Subject: [PATCH] ceph: enable async dirops by default
Date:   Mon,  9 Aug 2021 12:44:10 -0400
Message-Id: <20210809164410.27750-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Async dirops have been supported in mainline kernels for quite some time
now, and we've recently (as of June) started doing regular testing in
teuthology with '-o nowsync'. So far, that hasn't uncovered any issues,
so I think the time is right to flip the default for this option.

Enable async dirops by default, and change /proc/mounts to show "wsync"
when they are disabled rather than "nowsync" when they are enabled.

Cc: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 4 ++--
 fs/ceph/super.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 609ffc8c2d78..f517ad9eeb26 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -698,8 +698,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
 
-	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
-		seq_puts(m, ",nowsync");
+	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
+		seq_puts(m, ",wsync");
 
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%u", fsopt->wsize);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 389b45ac291b..0bc36cf4c683 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -48,7 +48,8 @@
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-	 CEPH_MOUNT_OPT_NOCOPYFROM)
+	 CEPH_MOUNT_OPT_NOCOPYFROM |		\
+	 CEPH_MOUNT_OPT_ASYNC_DIROPS)
 
 #define ceph_set_mount_opt(fsc, opt) \
 	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
-- 
2.31.1

