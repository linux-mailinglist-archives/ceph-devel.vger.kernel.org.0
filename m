Return-Path: <ceph-devel+bounces-2270-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD1489E818D
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 19:26:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B498318843A8
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 18:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D461514E4;
	Sat,  7 Dec 2024 18:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kv1O0E7g"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3601114B96E
	for <ceph-devel@vger.kernel.org>; Sat,  7 Dec 2024 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733596005; cv=none; b=sDv3ldyOoBKr/eUbXFJBSGT47XZ6y94fnvYTcRe9bkz727+X0QN8J8sGyHkzePtjRDptw89Goc8mr12C/mCLc6EAAtCjWYXrR3Q6QqOqZwuxJpPoinr45P6cNMWGsi6lP8nD5KZkXpL8CR6zMq4JbyOeV8ewiZor28B0fzciHm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733596005; c=relaxed/simple;
	bh=d8Bgfej8kxiAELXWymuZBPbUK4Is217AmBNTsdd0e2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHLkTWwSCUP2yOYscV5mPgSon/aUi+4qj4CEKEbQfK5m6JtQ8ET1Pm8IiHYHUjSZrh0+dEkXFZpFLC1W8w3xniWXu8aD5W+zvYSWPpDSIc1g92JVqB/o8EJvtH5NSDRuAvstFH+rnRh15gpJbccAoKnVlw5WQnGl6LCt2N7rd4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kv1O0E7g; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434f094c636so1879255e9.2
        for <ceph-devel@vger.kernel.org>; Sat, 07 Dec 2024 10:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733596002; x=1734200802; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hbECu90BnaSPKem32qyeN1V+u7434lzbvNHUSLLCNuc=;
        b=kv1O0E7gEHukJDLy8HkiZPmZWEyxpeeIrW92OxYSg0nSm7FS30edtrtpDP1B/2mgeI
         m23QWUuu/tqbRJPr2yV8CNmftghZVxFpLBWPXXlycZx6HEWHEB8VVDIMPmiYv5fKxt5z
         VeJulA/blt/OTnRA4+otUNl0DyZeJyqRz1ATGb4ePR+xZ1SHPzCPDS5yviqgpkxoV0QT
         XXjjhMxQaGnU8FfJf8idclG2nbYuompRnQCc7gvd7KdBxgJ7vCdK1fR+spYF8DJh0Igq
         avUje/5WJeEeE81brqXk0v+kBVUskwLRdY6J15Ia9gdNFMmBWJlwBxZbPQzeNgbAGDJF
         0PGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733596002; x=1734200802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hbECu90BnaSPKem32qyeN1V+u7434lzbvNHUSLLCNuc=;
        b=Jj5ZshtOTxMSuc7/ESZv4xvo+0w3VY4lp3Jfqa9//DSvjCpH0ybkSRJtxAHkGKeTyM
         qTl/MbhYSr5PmChHbAxmAkYBlN2yRXI2PLmjsMR1c1BAEnnmFIOqfl+1UbU6U8DSxZgQ
         wCeOa+RHaHeH8kLgGA6ZNqR+p8ijqzKlIpzzaeBh/sRKdvKkXayh927M9euvFGV3I6Go
         GeuV5dbby69VNuQ7dM10dD/Wa7/fz2ezGFihNt3QQGBuzAMkDMqGBrwVKDuJIyy7c5ej
         c0k7DDc94vtRxeDu9Wq88JAXZ/tNc5NHQL/YVJmXvWePUQKjPAZ6fygUgl1Sa4GWWiSW
         mIGw==
X-Gm-Message-State: AOJu0Yzfc3VI/US3YjW3t3UDVT5sU1oFdQD4SfL/urPheNWrc37Bvwp6
	V5xPC5Bwase21Ia5E6DeG+TSz6zmr+xVpcNN0BXu4wg8FqEu5+XYKomCXg==
X-Gm-Gg: ASbGncuiBYPXDxCGOXATKi7oFga86Q9F8a59nz9nBXr+3SgB7lpYDdAZSkEbOqOIz/D
	Uve1Go2InVk6/j+4CvKvK+/P5CEaAq0N+Sac0FiD6/Rd91Rdo/N5pIFpp72KocTc7TKI5RxI+5o
	/0tb5DsTcVf+Siff5rBNESkwymxDsZjv14i5KB3yeopmQBgVYeveqmEhN3C5Scwjo1E2cDax1rK
	+ktntIvtIH0bdSYJJ/WFjV/TNfMrgpJZn9fePG1MgEpt8v4R3WxwKvDE20GFgtSDVJRqbxxuUmk
	WvQnBE4Xl4f0Dhz0vg==
X-Google-Smtp-Source: AGHT+IE+kVYm4YqrfNN08PYYJ5RK/Hg/4bc4AMsc9WZ9Y684RzV8TFLciMYqAOIH6tZkKbdiYg7lwQ==
X-Received: by 2002:a5d:64c3:0:b0:385:e1e5:fff3 with SMTP id ffacd0b85a97d-3862b3e8852mr6225341f8f.57.1733596002429;
        Sat, 07 Dec 2024 10:26:42 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3862190989fsm7957386f8f.73.2024.12.07.10.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 10:26:40 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Alex Markuze <amarkuze@redhat.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 2/2] ceph: allocate sparse_ext map only for sparse reads
Date: Sat,  7 Dec 2024 19:26:19 +0100
Message-ID: <20241207182622.97113-3-idryomov@gmail.com>
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

If mounted with sparseread option, ceph_direct_read_write() ends up
making an unnecessarily allocation for O_DIRECT writes.

Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/file.c        | 2 +-
 net/ceph/osd_client.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0df2ffc69e92..f17bc4dc629c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1558,7 +1558,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		op = &req->r_ops[0];
-		if (sparse) {
+		if (!write && sparse) {
 			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
 			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9b1168eb77ab..b24afec24138 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1173,6 +1173,8 @@ EXPORT_SYMBOL(ceph_osdc_new_request);
 
 int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
 {
+	WARN_ON(op->op != CEPH_OSD_OP_SPARSE_READ);
+
 	op->extent.sparse_ext_cnt = cnt;
 	op->extent.sparse_ext = kmalloc_array(cnt,
 					      sizeof(*op->extent.sparse_ext),
-- 
2.46.1


