Return-Path: <ceph-devel+bounces-924-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A57986B111
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 15:00:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3B46C1C22958
	for <lists+ceph-devel@lfdr.de>; Wed, 28 Feb 2024 14:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1F914F992;
	Wed, 28 Feb 2024 14:00:23 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from andre.telenet-ops.be (andre.telenet-ops.be [195.130.132.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F8F149DE5
	for <ceph-devel@vger.kernel.org>; Wed, 28 Feb 2024 14:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709128823; cv=none; b=TaWuurS1X/Vbstx/XAOUOwYtvw6nt/QEZJKfb+xw/bITIDk13gQKbpFMR5qdwSJcc1JXClAPEv9hxyQdjNKQL0sAiR9F+kwqxgbv12m6aifU+1jHooo7g0TXN2KI8Thk0knXfoxnGLfDqRPYwM/bU4h5UATVer7TYAMwCtFU04Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709128823; c=relaxed/simple;
	bh=QsCae0o9eyN75UvvnzCtyzD7Q33sU4Xy0REKuZlqxLw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aOleBBw/qrw2Hhy5rCjUCa4Kmq/L5oFJg6R8WcYwwujEakjeg/zLluVTgwNNOCbPoj8wOLS2f0vhGbCm+wYkHChzYsHeRTyWHYVDpssObDuw9SI2kz+MypRq1Y33zHVE2hctZCJsHg+5hdPhQIgtEW8JWXpONYylaVVfy1T+NdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:48c4:26a9:d9ec:22cb])
	by andre.telenet-ops.be with bizsmtp
	id se072B0074gWvPH01e07Ym; Wed, 28 Feb 2024 15:00:13 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1rfKTV-001tZC-DU;
	Wed, 28 Feb 2024 15:00:07 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1rfKTe-006hlF-Uu;
	Wed, 28 Feb 2024 15:00:06 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Chris Down <chris@chrisdown.name>,
	Petr Mladek <pmladek@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jessica Yu <jeyu@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jason Baron <jbaron@akamai.com>,
	Jim Cromie <jim.cromie@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 3/4] dyndbg: Use *no_printk() helpers
Date: Wed, 28 Feb 2024 15:00:04 +0100
Message-Id: <32e18ceb528b99d9147be9c1af578a1965e2bad9.1709127473.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1709127473.git.geert+renesas@glider.be>
References: <cover.1709127473.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When printk-indexing is enabled, each printk() or dev_printk()
invocation emits a pi_entry structure.  This is even true when the call
is protected by an always-false check: while the actual code to print
the message is optimized out by the compiler, the pi_entry structure is
still emitted.

Fix this by replacing "if (0) *printk(...)" constructs by calls to the
corresponding *no_printk() helpers.

Note that this has minimal impact, as most (all?) callers of
dynamic_{pr,dev}_debug() are protected by checks for DYNAMIC_DEBUG
anyway.  Still, using the helpers serves as a good example to follow.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 include/linux/dynamic_debug.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 4fcbf4d4fd0a29d1..ff44ec346162a164 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -305,9 +305,9 @@ void __dynamic_ibdev_dbg(struct _ddebug *descriptor,
 #define DYNAMIC_DEBUG_BRANCH(descriptor) false
 
 #define dynamic_pr_debug(fmt, ...)					\
-	do { if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); } while (0)
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #define dynamic_dev_dbg(dev, fmt, ...)					\
-	do { if (0) dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__); } while (0)
+	dev_no_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__)
 #define dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
 			 groupsize, buf, len, ascii)			\
 	do { if (0)							\
-- 
2.34.1


