Return-Path: <ceph-devel+bounces-3317-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4802DB049B4
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jul 2025 23:47:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F28D1A61368
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Jul 2025 21:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CD6190676;
	Mon, 14 Jul 2025 21:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="jVeHQ1wj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E21CEADB
	for <ceph-devel@vger.kernel.org>; Mon, 14 Jul 2025 21:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752529664; cv=none; b=pUtVF1D81Y0aifXE3hPzyMzoxttHMLOXzOByuHiRiyj3PIZZMtSpf+yFdsYyBi8WxA9aoDFx5omJ31BttwLOdh+N92tAv4lXXywASsQNia6SbhHEkJjfcOSuKfGC6Q7e18zM6Wd04gsXLhC4SKUteKPVZeeJSAzI3M8q/iebhIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752529664; c=relaxed/simple;
	bh=h3SZ8Yp5NeHUkPOaTNmfQg2HRShSkFSZ+BV9YZ86jm0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yy603bFZ9NIW3FB+u3bKIILrWfEtUBQu496ekyfkWKoK/YCenHWDRBt3zC2QBP0fqZ4YtVIv7lpSev09ao37cxrV0Qzw5l+1uejRUDaZF/KVfQ+9Ycknz5jKkZg/n6zbBfrJ5g9VGM6RftSnabmS8K8Ke6yAkwgRL4fYFEBTTpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=jVeHQ1wj; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-714066c7bbbso47002667b3.3
        for <ceph-devel@vger.kernel.org>; Mon, 14 Jul 2025 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1752529660; x=1753134460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LQFXAKg1wXZa5rKcVsa1NQNG+NeBhOy+TGnjxAdiVIM=;
        b=jVeHQ1wjGwt8vpwy2FCz8Nd0TEe26eEKLMfc5pwHsQPjPVDqUib6dATIydZQKcVFBh
         fxrYq59APXZIzv+16FlpALB7d/JfLMLRGX+Y7kBm/hJz8pDBjqHBD9E0Xdh5GE0wlDNE
         71VhBg5ISLZ61pSZgL3E5N4LPZZMarmjbBYQGZUTVbM/5kWocjvepV0Fr2aNjw3HVMBP
         xu2N0cJBIlxxkarrVEBPVvunIh/PU0Mm1cfw1k1UY2SLqLcGoH66e4xwxkBJdsOsIK2A
         L3rCWffnFL7V+mCjo+FLmOOdknuxxt6x5ymPOCk1HxA2QaFBLSFjI8fhw6XSZqA3YMEA
         FeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752529660; x=1753134460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQFXAKg1wXZa5rKcVsa1NQNG+NeBhOy+TGnjxAdiVIM=;
        b=PDHey8LZEu+HntFg7po8EbQy7v94IlAeQjCEmiKUOPCk++oWjhI9NGk2gRLdvfX/Fc
         4RPuwoSlDjxLZdb8zIxzlObSKYcJkcWXOmgnrj+sSMvodrb1nFyxLbQaqlw0dCtoTN/P
         YtZY0Smfm7bH2KW+Dtp1erZiwtQ653+SSpe5VZohCFbf7Ub6HKF+clWc33GRsmzHQIan
         RcUpRuTg4cGFScwuDRPwo0616v6peQ7w9rtiBmNH0GYBopXieKYQPBF/MAHarDL+atg8
         3Uk6SvWmGWWA4HONutXzhhT11DnBlDNt7r9gmtT8ap97rCiP/6xuWZvV+ZaIZQEdo8kd
         S2jA==
X-Gm-Message-State: AOJu0YxIcYRs9a/wtMEC3PW78EiV+CA6U8Vcy6+/uHUp6SxECWyHvm4f
	WNKsrcRmSBV+UKDu3l19kFRF0jmgNrl7xxBoTc2jKxpLM2igV3YtIs0ETDiYVO/3DYMS6J9+H90
	q85agNZ4=
X-Gm-Gg: ASbGncvczuKIdRpdA9lWqU3D4XXdb4uHxj/r1GX7rpYiqEhAHHY+IbY8DfPJJzhQkTG
	Qt5HrdnO87Nj+BK6qibprmZ1gnd24tp/WxUMe6VLfFBXre/3Ujt19qhN4tRf/W3qPFyMEfIRKbo
	v3RQ2hY1DtjaoNJDm8P4MH/EF5QFtZVp1HBio5CD96s/rN7qkqmbwxtaJ1xISRYpvIQxX/H3uan
	XQlClDLSXWPdkJU3hdbtwtRMjQhZJyeTVJUW/meWddxm5hhfGwsFEbzyi32MWzzbcqHGlA8h6t/
	d69J92qIAi2BNUTjBW4AqrwUcWCoCMXQTf5VDQcewP1m7Wg8JLPp8YodpOxPkoZkUCiDaXgyAFu
	oh5x0y9Lo8BxpbURsdaxrFAVtg5227VGU2be5lJIl
X-Google-Smtp-Source: AGHT+IGuh6O9oC9UQEQNHHd0gj85nSUNTITBk9q/ljdvHr/ogOTW+FNlfLV1HjDX5CjfeJvZS8YXVg==
X-Received: by 2002:a05:690c:350e:b0:70e:7a67:b4b5 with SMTP id 00721157ae682-717d5dc7ca9mr210629277b3.22.1752529660312;
        Mon, 14 Jul 2025 14:47:40 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:ffc5:c11b:37c7:4909])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-717c61eb7f3sm21346397b3.98.2025.07.14.14.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jul 2025 14:47:39 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: fix potentail race condition of operations with CEPH_I_ODIRECT flag
Date: Mon, 14 Jul 2025 14:47:19 -0700
Message-ID: <20250714214719.589469-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has detected potential
race conditions in ceph_block_o_direct(), ceph_start_io_read(),
ceph_block_buffered(), and ceph_start_io_direct() [1 - 4].

The CID 1590942, 1590665, 1589664, 1590377 contain explanation:
"The value of the shared data will be determined by
the interleaving of thread execution. Thread shared data is accessed
without holding an appropriate lock, possibly causing
a race condition (CWE-366)".

This patch reworks the pattern of accessing/modification of
CEPH_I_ODIRECT flag by means of adding smp_mb__before_atomic()
before reading the status of CEPH_I_ODIRECT flag and
smp_mb__after_atomic() after clearing set/clear this flag.
Also, it was reworked the pattern of using of ci->i_ceph_lock
in ceph_block_o_direct(), ceph_start_io_read(),
ceph_block_buffered(), and ceph_start_io_direct() methods.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1590942
[2] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1590665
[3] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1589664
[4] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1590377

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 fs/ceph/io.c    | 53 +++++++++++++++++++++++++++++++++++++++----------
 fs/ceph/super.h |  3 ++-
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/io.c b/fs/ceph/io.c
index c456509b31c3..91b73052d708 100644
--- a/fs/ceph/io.c
+++ b/fs/ceph/io.c
@@ -21,14 +21,23 @@
 /* Call with exclusively locked inode->i_rwsem */
 static void ceph_block_o_direct(struct ceph_inode_info *ci, struct inode *inode)
 {
+	bool is_odirect;
+
 	lockdep_assert_held_write(&inode->i_rwsem);
 
-	if (READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT) {
-		spin_lock(&ci->i_ceph_lock);
-		ci->i_ceph_flags &= ~CEPH_I_ODIRECT;
-		spin_unlock(&ci->i_ceph_lock);
-		inode_dio_wait(inode);
+	spin_lock(&ci->i_ceph_lock);
+	/* ensure that bit state is consistent */
+	smp_mb__before_atomic();
+	is_odirect = READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT;
+	if (is_odirect) {
+		clear_bit(CEPH_I_ODIRECT_BIT, &ci->i_ceph_flags);
+		/* ensure modified bit is visible */
+		smp_mb__after_atomic();
 	}
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (is_odirect)
+		inode_dio_wait(inode);
 }
 
 /**
@@ -51,10 +60,16 @@ void
 ceph_start_io_read(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	bool is_odirect;
 
 	/* Be an optimist! */
 	down_read(&inode->i_rwsem);
-	if (!(READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT))
+	spin_lock(&ci->i_ceph_lock);
+	/* ensure that bit state is consistent */
+	smp_mb__before_atomic();
+	is_odirect = READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT;
+	spin_unlock(&ci->i_ceph_lock);
+	if (!is_odirect)
 		return;
 	up_read(&inode->i_rwsem);
 	/* Slow path.... */
@@ -106,12 +121,22 @@ ceph_end_io_write(struct inode *inode)
 /* Call with exclusively locked inode->i_rwsem */
 static void ceph_block_buffered(struct ceph_inode_info *ci, struct inode *inode)
 {
+	bool is_odirect;
+
 	lockdep_assert_held_write(&inode->i_rwsem);
 
-	if (!(READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT)) {
-		spin_lock(&ci->i_ceph_lock);
-		ci->i_ceph_flags |= CEPH_I_ODIRECT;
-		spin_unlock(&ci->i_ceph_lock);
+	spin_lock(&ci->i_ceph_lock);
+	/* ensure that bit state is consistent */
+	smp_mb__before_atomic();
+	is_odirect = READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT;
+	if (!is_odirect) {
+		set_bit(CEPH_I_ODIRECT_BIT, &ci->i_ceph_flags);
+		/* ensure modified bit is visible */
+		smp_mb__after_atomic();
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
+	if (!is_odirect) {
 		/* FIXME: unmap_mapping_range? */
 		filemap_write_and_wait(inode->i_mapping);
 	}
@@ -137,10 +162,16 @@ void
 ceph_start_io_direct(struct inode *inode)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	bool is_odirect;
 
 	/* Be an optimist! */
 	down_read(&inode->i_rwsem);
-	if (READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT)
+	spin_lock(&ci->i_ceph_lock);
+	/* ensure that bit state is consistent */
+	smp_mb__before_atomic();
+	is_odirect = READ_ONCE(ci->i_ceph_flags) & CEPH_I_ODIRECT;
+	spin_unlock(&ci->i_ceph_lock);
+	if (is_odirect)
 		return;
 	up_read(&inode->i_rwsem);
 	/* Slow path.... */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index bb0db0cc8003..969212637c5b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -638,7 +638,8 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_I_FLUSH_SNAPS	(1 << 8)  /* need flush snapss */
 #define CEPH_I_ERROR_WRITE	(1 << 9) /* have seen write errors */
 #define CEPH_I_ERROR_FILELOCK	(1 << 10) /* have seen file lock errors */
-#define CEPH_I_ODIRECT		(1 << 11) /* inode in direct I/O mode */
+#define CEPH_I_ODIRECT_BIT	(11) /* inode in direct I/O mode */
+#define CEPH_I_ODIRECT		(1 << CEPH_I_ODIRECT_BIT)
 #define CEPH_ASYNC_CREATE_BIT	(12)	  /* async create in flight for this */
 #define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
 #define CEPH_I_SHUTDOWN		(1 << 13) /* inode is no longer usable */
-- 
2.49.0


