Return-Path: <ceph-devel+bounces-1906-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C0C99C845
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 13:12:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB91B1C24262
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 11:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1301019ABDE;
	Mon, 14 Oct 2024 11:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Dc8uREMr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34F1142623;
	Mon, 14 Oct 2024 11:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903819; cv=none; b=FJPO/wYmmBXzt3OdD+K42pQ4KSGrc6Yo1j0feaEmkq1UhXrcHzDyDN3jnlXvz30wkmHbzEiEcV93ox43w3HI0mOnTxbIORIRkD8OFUqQGdo1figNs06Kx4h8dsFXCcCMyZ4Dcrnl9PmAodIQts2kZd4CiMrF8u9te/m3uPFjn3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903819; c=relaxed/simple;
	bh=tNN/+wk+97B8YzKp3H3aAjI3vyVRiGLPiJGm1HY0NCw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mqEQsiMepJVOBJJZ2AGSy8BjaSk/XsXL8WQTMOwd8pS5sYFYMf3lajrwhNwdkWg/l6R/+A8L0drfZgCn89fbTtjKV+9t9iJdRrwgzhWq/xFC+yHSDBr+nyDPe4Ue56JYWkdWhfU5cFMIRnRZBh6NdBhua6/uf8BTxW9pREzyzLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Dc8uREMr; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=oi2t8
	sjMjlwV7Ls5PkqOofE1o4ecrZbk4kz13E7yzL4=; b=Dc8uREMrQ4S6WMEFDgK3a
	LE2gcy8ZLsnl+Op/OQRb/SZ+Uiei2cxjyahzOShjBuDOHa9HfvhNE9VOrowRztVl
	IZDUGxp1mrxQCA+2EsYHd/zV/evbNLx61Co3rPXANGeb1cdD+WO/Dz1MBhYEa/2D
	i93KbxwxfZhIcdeFZ7WZAY=
Received: from localhost.localdomain (unknown [60.166.101.130])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wCHLytp+gxnXFgvBA--.9313S2;
	Mon, 14 Oct 2024 19:03:05 +0800 (CST)
From: Qianqiang Liu <qianqiang.liu@163.com>
To: brauner@kernel.org
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: return result directly from wait_for_completion_killable()
Date: Mon, 14 Oct 2024 19:03:04 +0800
Message-Id: <20241014110304.60746-1-qianqiang.liu@163.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHLytp+gxnXFgvBA--.9313S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZr48AF1Utr43tFW3Kr15Arb_yoWfCFb_Jr
	yFqrW8uwnxArs5Gw1jkFW3trZagw4DuF1fXrWvgFnakFW5Gan8CrWqq3s3uFyYgws7Ga45
	Cw1DCFy2kr17CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbUUU5UUUUU==
X-CM-SenderInfo: xtld01pldqwhxolxqiywtou0bp/1tbiLx94amcMySBCrgACsO

Simplify the code by returning the result of
wait_for_completion_killable() directly, instead of calling it
separately and then returning 0.

No functional changes are introduced, this is a simple refactor
to streamline the code.

Signed-off-by: Qianqiang Liu <qianqiang.liu@163.com>
---
 fs/ceph/locks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index ebf4ac0055dd..0d48a85f5397 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -221,8 +221,7 @@ static int ceph_lock_wait_for_completion(struct ceph_mds_client *mdsc,
 	if (err && err != -ERESTARTSYS)
 		return err;
 
-	wait_for_completion_killable(&req->r_safe_completion);
-	return 0;
+	return wait_for_completion_killable(&req->r_safe_completion);
 }
 
 static int try_unlock_file(struct file *file, struct file_lock *fl)
-- 
2.39.2 (Apple Git-143)


