Return-Path: <ceph-devel+bounces-1897-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9556A99B7BF
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 01:55:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 387341F21D1F
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2024 23:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BB5F4F8BB;
	Sat, 12 Oct 2024 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="Bmg4o//l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701012F870
	for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728777346; cv=none; b=r6PSTEDpBco1toOFRMtsox8iTMAUQhWlfuIrF4F2xr8sUh2BoDtrihrcFUcsMQUXUEJZcJ3rDrYKcoJ1RzyzbT5FOmcfEtwRihyqn2M978dguuz5f6DkdFNB1pFPHBO1D6FVml1qH97Z089oPcT+3uy+860XWuje7Mq+WnrLU+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728777346; c=relaxed/simple;
	bh=Rs0WhVYlqwQ9GIF9wqpRbWP2+E5Qn796AkiW/OgXwcI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YerrBy7egi3NzyPReBewwXxvPSmBGJaL1nL/u8mGxBozMOHxQd5O8PQ/KhT6HWxVk8o/cYDe9crRd8XEVFIqhpCIUmuxNngOIY090jCg5EsMLnTftTKLPtMWLHAtETLKSPSTURQTWmi+wIh81/oFKOJfvPjp4dJHjFuIQb1/NHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=Bmg4o//l; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-460407b421bso25635971cf.3
        for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728777343; x=1729382143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+sk6LUiLeleXUsSllRpsc5OH3Y6ZTlzg70lgLuDUR68=;
        b=Bmg4o//lsNVigdXFCWLLM1H7fGmb4Fvzfno3G8QVRU0+7J/qRxsmQm385h/A5YJ1ma
         34wz8G5pJogkwEV6bR5fEG/wAkOy0g70JNXIRftEf0trR7rDqJyskav+yPRagnaySJTS
         TzHrL4PS9K75H7UqhkFiV1VbEuet5urZpSJChF+Gr+yKDhb1IOb7DQkiGEMq/QvjMkDy
         Gj0IupEqbWdgPGFIkpD/RNi4ZMmp0MP+ueuiBx6+mEznmvaKJ3Lptk+m/kCOhUniCgWE
         ors2nme+QnmNkU0UsDkaA3zqhCHN6MMIwwt6R6ZA1K3DOBVgSma1hyi6jTfYK+c7IQr9
         z4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728777343; x=1729382143;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+sk6LUiLeleXUsSllRpsc5OH3Y6ZTlzg70lgLuDUR68=;
        b=SEPQnMc4zryF75oPRRm7hisag5ye7kIEO+ycgP+olgqmJOjwK7lqBJkm1qk8kozag7
         UWP9i6hWRbFQMiTtVSYxV9NAUVdXegiavnmwTJ83cJzNMRQzmj7rA6yzZJw+WkjTp4eD
         w4BP8XkcloEysaXbpq/vE/VEh96W3dbf012r9zEhZw7OoCyjJM2xZGmz8ZxTN4zYp5ni
         OAb5/KqloXQoYqvY9bR9cSiqT6K6kD6s1sB9Hd1LyHcZsNYZZluH8ZnT7yh2RJnr5k4l
         iY5LVOhYDiIwx20mZkLpVu+GEVpYXpUfpQzFIdwH54E37vY/QVZB5mxXEefFp/f9bz3C
         lXzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLmZe4tC1ccmcskBjCVKNokeTcHciBhratKM6vBA5E/tFPQh+5JXvI+xZ58oXOAaZ6Bb3txxAkuBcl@vger.kernel.org
X-Gm-Message-State: AOJu0YzThZs2Yqj8+5cpv3QPZJjL6759WTbkPTQ3nJzjTLJ9/Wl/Wohl
	f1S8v/1CdRo+pYAa/jeqH+pDFpp/GGrnhAw/H0knCiYL79hLmZ5dIHyEFUzsc/610pHX0OW7x6L
	TKQ==
X-Google-Smtp-Source: AGHT+IHk5YHd59N8jAKWL+/oKO+RM0w7kbYnSajqFt83qDlUq2bDjS287Ot2L2/6nIQoY78Ym5jFQg==
X-Received: by 2002:a05:6214:460d:b0:6cc:9:3205 with SMTP id 6a1803df08f44-6cc00093482mr40916936d6.45.1728777343295;
        Sat, 12 Oct 2024 16:55:43 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cbe85b7772sm30477966d6.49.2024.10.12.16.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:55:42 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ceph: correct ceph_mds_cap_item field name
Date: Sat, 12 Oct 2024 19:55:25 -0400
Message-ID: <20241012235529.520289-1-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The issue_seq is sent with bulk cap releases, not the current sequence number.

See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_item field name".

See-also: https://tracker.ceph.com/issues/66704
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/mds_client.c         | 2 +-
 include/linux/ceph/ceph_fs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c4a5fd94bbbb..0be82de8a6da 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2362,7 +2362,7 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
 		item->ino = cpu_to_le64(cap->cap_ino);
 		item->cap_id = cpu_to_le64(cap->cap_id);
 		item->migrate_seq = cpu_to_le32(cap->mseq);
-		item->seq = cpu_to_le32(cap->issue_seq);
+		item->issue_seq = cpu_to_le32(cap->issue_seq);
 		msg->front.iov_len += sizeof(*item);
 
 		ceph_put_cap(mdsc, cap);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ee1d0e5f9789..4ff3ad5e9210 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -822,7 +822,7 @@ struct ceph_mds_cap_release {
 struct ceph_mds_cap_item {
 	__le64 ino;
 	__le64 cap_id;
-	__le32 migrate_seq, seq;
+	__le32 migrate_seq, issue_seq;
 } __attribute__ ((packed));
 
 #define CEPH_MDS_LEASE_REVOKE           1  /*    mds  -> client */

base-commit: 75b607fab38d149f232f01eae5e6392b394dd659
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


