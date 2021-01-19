Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13A2FBAB3
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Jan 2021 16:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbhASPD7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Jan 2021 10:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389193AbhASOpP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 09:45:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6A0720DD4
        for <ceph-devel@vger.kernel.org>; Tue, 19 Jan 2021 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611067472;
        bh=dcBMc4caMRpBfpk0nnqbrRWXnYqbTf1YcIr1LHN8bIs=;
        h=From:To:Subject:Date:From;
        b=NGAx/oEU+7XYNpY3+VUGA+Vwoj4mUK7/AfoHItPfNuRpJCsG+Bccm8QEdigjabXsk
         hXZwvVVbwqK0ItAaIPybhy6112QgRFQUVIKmvJf8+1DS9pjeIbRzyQGC51ljsh2LVK
         birP3CdUxQPVLOzMeUvoN0SvkjaFtcGfA8Y2433TGOWK8ZRg3zVrYWYsMKA0tI+xF+
         KKmcvs1gVzead5x+zFS02+tY6cYlI34+bZdaPpZ+VoORrqI5dDnFFHAsGubEtTXXQl
         OZasvCz27jpJZ2ey5jmq8zSv8iLPLoL5XmzwyRQTHddKysJpvdoDe0sdbaGI3JzcF0
         rvzHo1OPMmbSQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: enable async dirops by default
Date:   Tue, 19 Jan 2021 09:44:30 -0500
Message-Id: <20210119144430.337370-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This has been behaving reasonably well in testing, and enabling this
offers significant performance benefits. Enable async dirops by default
in the kclient going forward, and change show_options to add "wsync"
when they are disabled.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 4 ++--
 fs/ceph/super.h | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9b1b7f4cfdd4..884e2ffabfaf 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -577,8 +577,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
 		seq_show_option(m, "recover_session", "clean");
 
-	if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
-		seq_puts(m, ",nowsync");
+	if (!(fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS))
+		seq_puts(m, ",wsync");
 
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%u", fsopt->wsize);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 13b02887b085..8ee2745f6257 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -46,8 +46,9 @@
 #define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
-	(CEPH_MOUNT_OPT_DCACHE |		\
-	 CEPH_MOUNT_OPT_NOCOPYFROM)
+	(CEPH_MOUNT_OPT_DCACHE		|	\
+	 CEPH_MOUNT_OPT_NOCOPYFROM	|	\
+	 CEPH_MOUNT_OPT_ASYNC_DIROPS)
 
 #define ceph_set_mount_opt(fsc, opt) \
 	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
-- 
2.29.2

