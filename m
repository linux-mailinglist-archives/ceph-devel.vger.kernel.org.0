Return-Path: <ceph-devel+bounces-424-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A73781B8BE
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 14:52:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB49D1C23C10
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Dec 2023 13:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C1AE7BEF7;
	Thu, 21 Dec 2023 13:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Q4OBW8h8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from forward100c.mail.yandex.net (forward100c.mail.yandex.net [178.154.239.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D577633;
	Thu, 21 Dec 2023 13:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Received: from mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:68e:0:640:54ba:0])
	by forward100c.mail.yandex.net (Yandex) with ESMTP id 2D670608F3;
	Thu, 21 Dec 2023 16:40:38 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id beOFl31j0uQ0-OhojHdo2;
	Thu, 21 Dec 2023 16:40:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1703166037; bh=WPPhPspNeSh3G2SSCHs6rFMEoU9LBDX//e9rfPrwgdk=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Q4OBW8h8cLgRt1rCjmo/cply8P6AkRRnTwJVZNTwDQGaxUMryq+tkR0q1zRCqGD5s
	 YgwoDGrCgzCrIQnlQxg4DHTXKZPCXcVHdNYL9ykadaImMaBZMR2S98eJH8oa28Cy93
	 qsZVDdDLAvLH6bRTWt6kn0IK6Ye9o5BmKEKnyL7A=
Authentication-Results: mail-nwsmtp-smtp-production-main-59.iva.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>,
	ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] rbd: use check_sub_overflow() to limit the number of snapshots
Date: Thu, 21 Dec 2023 16:39:17 +0300
Message-ID: <20231221133928.49824-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling with clang-18 and W=1, I've noticed the following
warning:

drivers/block/rbd.c:6093:17: warning: result of comparison of constant
2305843009213693948 with expression of type 'u32' (aka 'unsigned int')
is always false [-Wtautological-constant-out-of-range-compare]
 6093 |         if (snap_count > (SIZE_MAX - sizeof (struct ceph_snap_context))
      |             ~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 6094 |                                  / sizeof (u64)) {
      |                                  ~~~~~~~~~~~~~~

Since the plain check with '>' makes sense only if U32_MAX == SIZE_MAX
which is not true for the 64-bit kernel, prefer 'check_sub_overflow()'
in 'rbd_dev_v2_snap_context()' and 'rbd_dev_ondisk_valid()' as well.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/block/rbd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a999b698b131..ef8e6fbc9a79 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -933,7 +933,7 @@ static bool rbd_image_format_valid(u32 image_format)
 
 static bool rbd_dev_ondisk_valid(struct rbd_image_header_ondisk *ondisk)
 {
-	size_t size;
+	size_t size, result;
 	u32 snap_count;
 
 	/* The header has to start with the magic rbd header text */
@@ -956,7 +956,7 @@ static bool rbd_dev_ondisk_valid(struct rbd_image_header_ondisk *ondisk)
 	 */
 	snap_count = le32_to_cpu(ondisk->snap_count);
 	size = SIZE_MAX - sizeof (struct ceph_snap_context);
-	if (snap_count > size / sizeof (__le64))
+	if (check_sub_overflow(size / sizeof(__le64), snap_count, &result))
 		return false;
 
 	/*
@@ -6090,8 +6090,8 @@ static int rbd_dev_v2_snap_context(struct rbd_device *rbd_dev,
 	 * make sure the computed size of the snapshot context we
 	 * allocate is representable in a size_t.
 	 */
-	if (snap_count > (SIZE_MAX - sizeof (struct ceph_snap_context))
-				 / sizeof (u64)) {
+	if (check_sub_overflow((SIZE_MAX - sizeof(struct ceph_snap_context))
+			       / sizeof(u64), snap_count, &size)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.43.0


