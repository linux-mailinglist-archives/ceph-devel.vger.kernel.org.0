Return-Path: <ceph-devel+bounces-2269-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B49C69E818C
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 19:26:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9951F1653CC
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 18:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F0611537C6;
	Sat,  7 Dec 2024 18:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jSyeuReG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8B714B96E
	for <ceph-devel@vger.kernel.org>; Sat,  7 Dec 2024 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733596002; cv=none; b=WO5sWdwq3iuUSGPYjQM31tQCU+2/c89RwM7V1P6fNduuHTTHs2kh3ZYn8GHTGUDeo430+2Z8RyZAEt6w45OqjllC9yMtE7P1F+c+VK7UgQQ5ayB5F6xpAPC4OljeEtczOBeEdJNtJZRi2d0IdpGfiLmU76XD9t8LK9n6oOjEt1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733596002; c=relaxed/simple;
	bh=zpN7mCvmWgsGNMdbYkI6N+LLIU3D8E1lJmaRuOWBR6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp/E/J2Ccj/vDjSzlinLeHL8JZQxgompp75PX5Bjhqr/RWokNOYUMQSmbw/ohfvk422am7dconEreRaAHWdS8Tuwh2cX5+GqmKMI5lr93mOxXysrDz/Axlax1+3ZjFxFsGAbzQ8I027r+mwptNx9HxCX6Gyzkpjmyh/MXA+bjJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jSyeuReG; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3863494591bso335518f8f.1
        for <ceph-devel@vger.kernel.org>; Sat, 07 Dec 2024 10:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733595999; x=1734200799; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjVTmTY3qHMLl0cJaFxi4Fr2X/jFuu79M0U9ds0fjic=;
        b=jSyeuReGO7byDHIl7Mes1x8XY1wVd53oAqKpf4bP50YBCiZKp5FMd3v8OiFmzvbMuf
         zC1IF3vDkXYgkikE1x3YvH8t1lOZxqM9KjHadZtO9ZDiEbUbwZP+j1+lOX6VzkibXI+5
         3QHtBSRtkjrb3t/Y3OhlYAyiPAzLv8ZhKBCw0LlXmT8g0sHGiqjupjtymXGvaBf/1ia9
         KAB+7BaemDIgNwLv+HlZNCEpUgndXR8eoqEBa64CG39J8aFqBAM2mdb54g3XZTXGOcJw
         9SOkeia6TSoPWEo7IuNV45slxeT1xAU0FW7w2SGqYmZ8Dq+O7tuUZccSAfzuEhM9eiRd
         f3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733595999; x=1734200799;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hjVTmTY3qHMLl0cJaFxi4Fr2X/jFuu79M0U9ds0fjic=;
        b=roLlKwHn/Wp2F6otkhRbdDso3wz5XixiM6QT090CPM4+cw8jECwrnaTgcrqcAhgHhD
         A9QX5YcTyUEkWIMsQppYw2I/E0IlWSydkU+DRMh6K0A/9B+5DGmSdRMzdBkfSd9+9nIy
         DUeVs5htsQ75PEayXVodIFK3BmPJp9kbontgVYsGhWCMPbcAGS7G4f5fVX9KPuoyfPJR
         suDcsADeKR2XF/dKkZhWw5Ci9ORqfOsGQR7qdB8ebJwiK+ZKLbQuOMuLNztELy5OPQHr
         SrnKBnlTx3OVGWERNIddxyoA4qwCDOEF0UhDT68XPpundy+TZ5B4KdCxrIJYXvsOt/q6
         f/Zw==
X-Gm-Message-State: AOJu0Yw8sGLYHtSqMiRhH3hjSd/bWQ6GgRT1oiy9ucdnqF9KTV1PFQRf
	T0AttWfl5TYPpGnKkLTZ7WvdLx7cLIHBh0Ldpwe7o74nHA/Y5jtYIDQV4Q==
X-Gm-Gg: ASbGncvDmbJ5qwmp6jofkDwpPWcn/4dV2n4B5W4casNddmPNOZSujO0JTP1Cn3AMafD
	XLE1JZG+oLnJT3rZFYwV1DwXGydGdmwkjF2GUIug4lQyyy03MI8fe9MdhNpdQLEx8Y7P3QT8NYP
	RY8nzni1JakCMEO0ly78tEQxK2OmIAzNlGpH4r1Z/4ev5fsHlxZkiqyH4BUIjkJOJCSD3KmipCu
	QLmAIiInzJqpdBkj2BOqgxHbLpQFMETtyG0FRICRmXw8MEHE/QqekTPy4NAKqQSxlo4EmElmnfn
	WLzlRalJkdtcCDAX9g==
X-Google-Smtp-Source: AGHT+IFRBge/GNp/1k+3bgmSeOpECqTWgNj1gwtHzB9r84DWNn2zCac7G06+B9EYjb2uWPvC3RRBdg==
X-Received: by 2002:a05:6000:1fa4:b0:385:e38f:8cc with SMTP id ffacd0b85a97d-3862b3d5eacmr5936872f8f.38.1733595999151;
        Sat, 07 Dec 2024 10:26:39 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190989fsm7957386f8f.73.2024.12.07.10.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 10:26:37 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Alex Markuze <amarkuze@redhat.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 1/2] ceph: fix memory leak in ceph_direct_read_write()
Date: Sat,  7 Dec 2024 19:26:18 +0100
Message-ID: <20241207182622.97113-2-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241207182622.97113-1-idryomov@gmail.com>
References: <20241207182622.97113-1-idryomov@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bvecs array which is allocated in iter_get_bvecs_alloc() is leaked
and pages remain pinned if ceph_alloc_sparse_ext_map() fails.

There is no need to delay the allocation of sparse_ext map until after
the bvecs array is set up, so fix this by moving sparse_ext allocation
a bit earlier.  Also, make a similar adjustment in __ceph_sync_read()
for consistency (a leak of the same kind in __ceph_sync_read() has been
addressed differently).

Cc: stable@vger.kernel.org
Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/file.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index f9bb9e5493ce..0df2ffc69e92 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1116,6 +1116,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			len = read_off + read_len - off;
 		more = len < iov_iter_count(to);
 
+		op = &req->r_ops[0];
+		if (sparse) {
+			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
+			if (ret) {
+				ceph_osdc_put_request(req);
+				break;
+			}
+		}
+
 		num_pages = calc_pages_for(read_off, read_len);
 		page_off = offset_in_page(off);
 		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
@@ -1129,16 +1139,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 						 offset_in_page(read_off),
 						 false, true);
 
-		op = &req->r_ops[0];
-		if (sparse) {
-			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
-			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
-			if (ret) {
-				ceph_osdc_put_request(req);
-				break;
-			}
-		}
-
 		ceph_osdc_start_request(osdc, req);
 		ret = ceph_osdc_wait_request(osdc, req);
 
@@ -1557,6 +1557,16 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			break;
 		}
 
+		op = &req->r_ops[0];
+		if (sparse) {
+			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
+			if (ret) {
+				ceph_osdc_put_request(req);
+				break;
+			}
+		}
+
 		len = iter_get_bvecs_alloc(iter, size, &bvecs, &num_pages);
 		if (len < 0) {
 			ceph_osdc_put_request(req);
@@ -1566,6 +1576,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		if (len != size)
 			osd_req_op_extent_update(req, 0, len);
 
+		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
+
 		/*
 		 * To simplify error handling, allow AIO when IO within i_size
 		 * or IO can be satisfied by single OSD request.
@@ -1597,17 +1609,6 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			req->r_mtime = mtime;
 		}
 
-		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
-		op = &req->r_ops[0];
-		if (sparse) {
-			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
-			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
-			if (ret) {
-				ceph_osdc_put_request(req);
-				break;
-			}
-		}
-
 		if (aio_req) {
 			aio_req->total_len += len;
 			aio_req->num_reqs++;
-- 
2.46.1


