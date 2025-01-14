Return-Path: <ceph-devel+bounces-2438-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8146FA1070D
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 13:47:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8F03188589D
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2025 12:47:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F181D236A85;
	Tue, 14 Jan 2025 12:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b="ZPyb6i2C"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lesviallon.fr (89-95-58-186.abo.bbox.fr [89.95.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77732236A73
	for <ceph-devel@vger.kernel.org>; Tue, 14 Jan 2025 12:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.95.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736858856; cv=none; b=KBbRMvq84EKWuTTJ/5grVKrQMI1eESW/zNKaPbmxuUeWieTMbcirdnGW3KBeKSslbQt/OL5uSNlI1OWiXk2VpCIRcH3o+b3Qdk9U6iXzRv71UU/J3rTgx8IOabpBg+aa6yRDGKtwAT0zRznXu+o0evnTDijOAE5ecmVv5OooSxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736858856; c=relaxed/simple;
	bh=8x0DxQLAFRSaDBV2xiVvHf3tcDjn6YUYt3MVWz+mp/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d9aKVVSDZAFq7e18dKZRuycPDHya14qaZBYdUcbzmlf1NhKKnNBDx/4za26mqSCMutIh5kE8L11u4aeUsds9Z5q1sLPv5Dv68x9AAjkVP2tlyMLHnOW1S82vP/GRD8Q8FcDlC0SZpyvggglGRCovffgwg0L3MmatEcil1mANBmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr; spf=pass smtp.mailfrom=lesviallon.fr; dkim=pass (1024-bit key) header.d=lesviallon.fr header.i=@lesviallon.fr header.b=ZPyb6i2C; arc=none smtp.client-ip=89.95.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lesviallon.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lesviallon.fr
From: Antoine Viallon <antoine@lesviallon.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lesviallon.fr;
	s=dkim; t=1736858301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=o3/PrDweVPfkN6fvH+bVoPb5RD1oZl2pL5stdG1ocOE=;
	b=ZPyb6i2CWlOApnKv1U1X1HlqeiMx7HrkG41UVHVzAiRDIT9fA2WLrorV2eIkXXN8/eY/5S
	cEjFlJWxWUslyhYUuM2mdvYCAk1S6+93DzWSUYDHxCWJq4ODzU0rv658EaulXQa+ZiQ2rZ
	FkJuj3rYlRAbaYMGAk7VTQXAaQwqYyU=
Authentication-Results: lesviallon.fr;
	auth=pass smtp.mailfrom=antoine@lesviallon.fr
To: ceph-devel@vger.kernel.org
Cc: Antoine Viallon <antoine@lesviallon.fr>
Subject: [PATCH] ceph: fix memory leak in ceph_mds_auth_match()
Date: Tue, 14 Jan 2025 13:38:06 +0100
Message-ID: <20250114123806.2339159-1-antoine@lesviallon.fr>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +
X-Spam-Level: *

This was detected in production because it caused a continuous memory growth,
eventually triggering kernel OOM and completely hard-locking the kernel.

Relevant kmemleak stacktrace:

    unreferenced object 0xffff888131e69900 (size 128):
      comm "git", pid 66104, jiffies 4295435999
      hex dump (first 32 bytes):
        76 6f 6c 75 6d 65 73 2f 63 6f 6e 74 61 69 6e 65  volumes/containe
        72 73 2f 67 69 74 65 61 2f 67 69 74 65 61 2f 67  rs/gitea/gitea/g
      backtrace (crc 2f3bb450):
        [<ffffffffaa68fb49>] __kmalloc_noprof+0x359/0x510
        [<ffffffffc32bf1df>] ceph_mds_check_access+0x5bf/0x14e0 [ceph]
        [<ffffffffc3235722>] ceph_open+0x312/0xd80 [ceph]
        [<ffffffffaa7dd786>] do_dentry_open+0x456/0x1120
        [<ffffffffaa7e3729>] vfs_open+0x79/0x360
        [<ffffffffaa832875>] path_openat+0x1de5/0x4390
        [<ffffffffaa834fcc>] do_filp_open+0x19c/0x3c0
        [<ffffffffaa7e44a1>] do_sys_openat2+0x141/0x180
        [<ffffffffaa7e4945>] __x64_sys_open+0xe5/0x1a0
        [<ffffffffac2cc2f7>] do_syscall_64+0xb7/0x210
        [<ffffffffac400130>] entry_SYSCALL_64_after_hwframe+0x77/0x7f

Signed-off-by: Antoine Viallon <antoine@lesviallon.fr>
---
 fs/ceph/mds_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 785fe489ef4b..89c69e9c03b9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5702,6 +5702,9 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 					kfree(_tpath);
 				return 0;
 			}
+
+			if (free_tpath)
+			  kfree(_tpath);
 		}
 	}
 
-- 
2.47.0


