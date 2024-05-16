Return-Path: <ceph-devel+bounces-1141-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E68088C7AC7
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2024 19:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 994C61F226E6
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2024 17:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438BF28382;
	Thu, 16 May 2024 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thofu.net header.i=@thofu.net header.b="b3CaVwYi"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF5C6FD5
	for <ceph-devel@vger.kernel.org>; Thu, 16 May 2024 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715878834; cv=none; b=WKR41Ol73N5cYBRVzXwCWP1wzUAajbZyGdNwPVg4RvdaQ8YS1gUqyijgku5iMsBHntn2D86IyMNhkpaJYJ1gg84AC3TRvzOUONgAyJbdXBVUHCtg0j6kKruNGKBzGYGg7GgMZIKgOonSdcyDHg23I1vH0U2Jux5OqIjh82OB10g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715878834; c=relaxed/simple;
	bh=RGJDi4Vpq6q9g9KYCP5Aps5Dz56Mtp/92jT/wiwMyBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BZQ3CVFh4bf9BLNHm4niCTgZy1OMLIq5iRqeEnYiNCqaz47Gtok7yxRtouOskE1d1o5p26XrHJodfZrGY6vmWx3yikWVkKhaGQuTlTE2KHsCxeJrDwJLodc5YzFAqeCQXC74m75E/TuPECYbKz9fpxbnDh2agB59amXVYwBPxZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thofu.net; spf=pass smtp.mailfrom=thofu.net; dkim=pass (2048-bit key) header.d=thofu.net header.i=@thofu.net header.b=b3CaVwYi; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=thofu.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thofu.net
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4VgGYg6PqBz9sWp;
	Thu, 16 May 2024 19:00:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=thofu.net; s=MBO0001;
	t=1715878823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Wrc5QeRbLNDPWBSpYSbxVfnyIOE0athpTtlMUiuPKck=;
	b=b3CaVwYimgD7KyMxYYGOss0LPC4YP7JDJAGYNyW14kVPSNu8mHowBP1geBY2c0kdFcOxKr
	TdltpqCDwP9cgF/Oqyp/hJa2McCx6T0fgE3a/RE0ob0jjKk5g/A3c9/hQNBJiGnOAZs7rR
	GJrCq+ZLYKbIPMqud6P2bvEHdS5nwmfp88UVs0Mb/PgyyaVxpuktGtPurJRAu0UrWW4WAN
	voczGuXvSuPLkXPhgWJu2gALCUYlKhZIFifoVZuQpVeTo8LSBvTdGqXviP3qQe+KBDos1J
	FQiepaBQJ8A9PuAWyrReTsgabSPY1AqYawVHgI4CQiPbKje0BitJDwtvXYTymg==
From: Thorsten Fuchs <t.fuchs@thofu.net>
To: ceph-devel@vger.kernel.org
Cc: Thorsten Fuchs <t.fuchs@thofu.net>
Subject: [PATCH] ceph: fix stale xattr when using read() on dir with '-o dirstat'
Date: Thu, 16 May 2024 19:00:21 +0200
Message-Id: <20240516170021.3738-1-t.fuchs@thofu.net>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes stale recursive stats (rbytes, rentries, ...) being returned for
a directory after creating/deleting entries in subdirectories.

Now `getfattr` and `cat` return the same values for the attributes.

Signed-off-by: Thorsten Fuchs <t.fuchs@thofu.net>
---
 fs/ceph/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 0e9f56eaba1e..e3cf76660305 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -2116,12 +2116,16 @@ static ssize_t ceph_read_dir(struct file *file, char __user *buf, size_t size,
 	struct ceph_dir_file_info *dfi = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	int left;
+	int left, err;
 	const int bufsize = 1024;
 
 	if (!ceph_test_mount_opt(ceph_sb_to_fs_client(inode->i_sb), DIRSTAT))
 		return -EISDIR;
 
+	err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
+	if (err)
+		return err;
+
 	if (!dfi->dir_info) {
 		dfi->dir_info = kmalloc(bufsize, GFP_KERNEL);
 		if (!dfi->dir_info)
-- 
2.34.1


