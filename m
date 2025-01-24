Return-Path: <ceph-devel+bounces-2557-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8070A1BCF4
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jan 2025 20:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42C18162141
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jan 2025 19:46:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BEBF2236F1;
	Fri, 24 Jan 2025 19:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="AaovrC+j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DE91CEE86
	for <ceph-devel@vger.kernel.org>; Fri, 24 Jan 2025 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737748000; cv=none; b=Wsi6pQCk5FPhIFJ7IrPCh5rHJCOW1jIZYtmFlKF+iu69QVzOElEQA3xiUwz4R81jOKe1XKgE3ReL2VmSceuoORsCWyGUcMjx8TfaQVzGXffSLM/0y+11i/Zrk+vWuoGMsKEr0bt3p3CuamPfqQeAahOvoCjPxpOdaMVJ+cr9UpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737748000; c=relaxed/simple;
	bh=GrgMNcI1Yb6FUTWoe9Ajb6IU54XGxI+V1Dm6RzB2zoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s2ENwS7HLFNimXeAiFFfEx2AAfTL3grH8sv5srl1/SUjTPyGxabSwG/zNagaE7eCgHPa+eIkpqZ32dQpUeTDQv0m26YQe3LvZt7gWtyKrTImw3zsm5GE9q1Vpkw/5QKnhKjUuDgto8hkNEGCuEI+d1kqOIxQVsiMEChD6uR8T08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=AaovrC+j; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-724d1724657so1797446a34.0
        for <ceph-devel@vger.kernel.org>; Fri, 24 Jan 2025 11:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1737747997; x=1738352797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=h+mFE/ulv8pEzS8/5/bnivhTITbq2zRRaZL80LF3uaA=;
        b=AaovrC+j8s9yqbAf/R16xNAHQyULLNbE94F7kzYWmXy2fsSuOe8LHOBReoSUag3srU
         wORCMWMy1sz6WsHjRx9/vC+OHQKsISMiIYJ73g4IJeA6rRKU0dCDk1ugvdN1xcjeL/7h
         Kt7rqzp/9vW9Znwb5zElPrN/lQEUwgIEHrCpSOSqfARwZ6xXuh6iOWVhcwAGp0gw68bl
         2GE7oW6ZUVju/UOnqupz25DOLy+gjBBbCcdWSjbIs7SrreIMFmvm2TIuv3QyHDvsnopE
         BhyswfOt07Hi/bW+1vAzSqPw/m95q8+y4BooL0aWqwqA1dP7iJ6pRB8iLxLUBvquyX5G
         Ezpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737747997; x=1738352797;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+mFE/ulv8pEzS8/5/bnivhTITbq2zRRaZL80LF3uaA=;
        b=RVA4I7l/dbupFeRXtwX4Fve50YF7P77Ad/XHXxRqinysW4N2zK0umXmceGP/ANDdav
         ArbWu3pQ6U5IQHNjxmAY+11+JsReqZGfkADmpQRq2Kvw7k8KxEgMsjlHonqd+r8O1ez5
         j3R2AMI+v9RSku+hCLCrgXrtl9niaTw1Wd92kawEov+E1Tcv/3QwoyGMMUKOZBO35VxH
         J7/Ct728unlhQLS6wy/jV0RmZY0QT3sVJsINz/I1HdsoV173uhNqtWjVTyzpuG7GHy8t
         hyuV/vI0hBCwEf0hbsjKZecbq+/FqQYaJIqUgJAQkwA33WsO7BaOpTuwJ6fcm+vLP6P9
         g+uA==
X-Gm-Message-State: AOJu0YyXg22gQ51Hh38IvRAK+jyQH4pMoaTG5OsXAe0VOgxzq/AvHj4E
	TLJQzZZBHHb33DIh28NIIPiHNx33wbEeTca/fNfOWKI3bNgmzxoVdh+tn0+K4yeWqryRD+QOVj5
	Q7egI52ap
X-Gm-Gg: ASbGnctXD1aD2DcuTHRu4k83uSFgb5EnZQZI48cE9AcGY4ac6zldbRRyj9YQSRt8T3K
	vgQt88lXrWgrZe8egPoxJGyauASJT8rekIco4+/DD8Bg4lGgoe0sK4f7xF46Hjb8Caq5wjaM0h+
	RmOwg7OSBjDx8uwvvt/z2rajKSM6yeJ0pZGAvRO3vEaGhnKOCkDgTPr7fg/p531eiYADTvjqEKB
	3U9uROh4wnkNaCm/OoARSxpNehec1u4wM5eZKeVQWTkWEKgOr/XLIvlVIQbKkNjf31ii7ruIiJ+
	C1O1NhnfEen2vUdCK4xgR8c=
X-Google-Smtp-Source: AGHT+IFL867600fy4toPcO6pgU+6w7MNcMYjDeXTrnAEh/zXDezq4gER8EeGNNqEsK8iun+a4IE6UQ==
X-Received: by 2002:a9d:53c8:0:b0:723:7853:8791 with SMTP id 46e09a7af769-724e0c42c02mr4170120a34.0.1737747996837;
        Fri, 24 Jan 2025 11:46:36 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:b6e8:cdba:6b52:89c0])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-724ecfa00e5sm579097a34.65.2025.01.24.11.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2025 11:46:35 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: exchange hardcoded value on NAME_MAX
Date: Fri, 24 Jan 2025 11:46:23 -0800
Message-ID: <20250124194623.19699-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

Initially, ceph_fs_debugfs_init() had temporary
name buffer with hardcoded length of 80 symbols.
Then, it was hardcoded again for 100 symbols.
Finally, it makes sense to exchange hardcoded
value on properly defined constant and 255 symbols
should be enough for any name case.

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index fdf9dc15eafa..fdd404fc8112 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -412,7 +412,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 
 void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 {
-	char name[100];
+	char name[NAME_MAX];
 
 	doutc(fsc->client, "begin\n");
 	fsc->debugfs_congestion_kb =
-- 
2.48.0


