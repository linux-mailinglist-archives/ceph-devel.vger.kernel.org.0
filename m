Return-Path: <ceph-devel+bounces-3894-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE23C19B09
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 11:25:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6D9D5505CAE
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Oct 2025 10:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D2926F2BF;
	Wed, 29 Oct 2025 10:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="lzy/yyrT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADFC308F3B
	for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 10:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733332; cv=none; b=D/12NsuZYCPE2luGQEYbtCPHi8+i8GN74SCnvLFNuqi2ht4bz3pS3ZQFYuqDmzkMcwFcjN/o8ejI2EIKT9SpVSHjWjrNKoVZCqKFGqFz9jtEkYQRntX4+34N3h2ip4co9Z1bsTU/nFEFUuMvUe6DGd+EgyOlDGnbSfBBU2pFy7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733332; c=relaxed/simple;
	bh=Srjjbp+31jlTlDMVW5Yg8ROeMQuCxMFPaHceKuOPFLQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=saMhyCYlkZqBFok4ou9Fq+KaAN1uSZ1OuNwo/sIM5H2DBogDQS/3/XwNNpbmb45jwyK6qAR3at3w7ehxG8+dSltdJwoakZPgqkt9Nz2e8Vcd3HBiUh0QfwtYEcXKfPK9kgNqwxcleedgrt9DBhRFTuaxWZN8ZN7nnjvRd3dJrEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=lzy/yyrT; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-781206cce18so998789b3a.0
        for <ceph-devel@vger.kernel.org>; Wed, 29 Oct 2025 03:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761733330; x=1762338130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ExH2mWp+TtRat+/Z2Sn0K+6uHuJUKGnny14cPSnH5Oc=;
        b=lzy/yyrT9FLe1zQ8UtMVsNJvhDIQavjpAyiBS8iIuPG76xJ8lSqXTCyJhJxPsI2T3P
         2cJwRkHy9pVWkepe951CZ+8J9uAWvoZyWVxaWI/Y/zJo5vFp8k91RHm6WfwNwRIUyQ6D
         amPIfIrNi6d8GP2VAN2gi3w5HHRKw6J08n2BlJPEg+yHcPl6cUekazMlfwr/pTggwRjQ
         RmPjyjnFzPBm7CAVib6LFFWNe2TU5hTQ3AJdtXb7ODTP4n1F0ZRoNvY6VhOpIaLHbcnB
         BLOWT+xpxEPw5VwcDINM4EjJEfxVjixW7ZlqDKmmZSYM6Lo76Ol3mAMlmLAkIppd1EC6
         Te6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733330; x=1762338130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ExH2mWp+TtRat+/Z2Sn0K+6uHuJUKGnny14cPSnH5Oc=;
        b=LTcqC94G4jhzOlAgjokUaNqKRXGpL2kTcy/zBrI/q/pRFnuREz42DBGK3kWrQ0uQUa
         zzbe4ajbMAWRAgbAAgZ3gieAawPvjECp3z2IKWyZVrXqcLKmhHhjX5VNeG35LWK9Pkbl
         fugzFY3UcPK8MJJ9v3WtPMEf4tq/YNYFmOAO+wW4Hal0gTKr4ZU7xMlz4ELQFNq9jBQI
         S0VvczTU+jo5lGsyQLqiGkkgbGVuwxYFZgeZQcJiDggrrE7V9+Wwbatw53yKs0z0YR2s
         /iYckg6m+Mj2z4/eLuvEmUgjYc3KdiArY1pC+HZnJEGBPQnjCcE1tkan6uEcWG1QgWU7
         6yDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYZqiEX2B+kXUVEVNGxAQcvQD8AREqBnlertNSuC3q6PGx7n0fc+NpPACQtnzqO41sj5TDTDssi8ZV@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt8MshSQ+dM7c9JQEDA1lm2uXARmWfymudBgEgtQkWPCDxHQ6J
	yhu1c+08k+OV9v9l6e4Mm0nwz14LC+cpG18uXhb/7G4NTioFrL+UKfINbzdAjGvmBgu1YTs1sxI
	ULtlg
X-Gm-Gg: ASbGnctjvhF5TP6Bk1xSt9XymQGoSf+/MNtb+KEGItXzIqHdZebFm4QsZ2yxKRCgKM7
	2HZbJpxT/mcQDN0QXwKPQz4S9+A1yr4GAbBHh8PjO485WELvf43L//1zxhWC+0t0qNCmSMgdJGP
	QLRnuoECOBXnFxd2jG0jH95Qhwm9SYaBA0zzqcyfuaQ91bKgB8VIfmwlTB40GrahOUrlyX4Wpk/
	R+cqNztP1gxjIyBWMk+jPIJLI3V+UQxcdp+ExJqiR9N7HjloiZEpkPZjAYQEi+20QGK+Qd4yj02
	FuvLj2TbxwmtSoWVZMh+2d2lALS7GrNUqnoZj/p9T7Dt/RsL6Gujse2DF5x7IeigeusvB9rk939
	cJ75p2AnlmOwaJGFBNRbSeLrU7wCSbetXFWslZMR6ojFBmUpLiY7SeT0xkuxDwgUg33t2Xvwjq4
	ICo/IflAyPPSLmIu6hpKOTKlEK
X-Google-Smtp-Source: AGHT+IEqYKX6PUZCvPQ43ID+NkdezuDDTSQSofgCTqlK+FDd2PcLeAZunAzA4UgtHlctwdsk1r5vIA==
X-Received: by 2002:a05:6a00:130f:b0:77f:43e6:ce65 with SMTP id d2e1a72fcca58-7a442cc2c03mr6912507b3a.0.1761733330060;
        Wed, 29 Oct 2025 03:22:10 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:3fc9:8c3c:5030:1b20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41409f714sm14560993b3a.72.2025.10.29.03.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:22:09 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	home7438072@gmail.com,
	idryomov@gmail.com,
	jaegeuk@kernel.org,
	kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	sagi@grimberg.me,
	tytso@mit.edu,
	visitorckw@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v4 6/6] ceph: replace local base64 helpers with lib/base64
Date: Wed, 29 Oct 2025 18:22:02 +0800
Message-Id: <20251029102202.544118-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the ceph_base64_encode() and ceph_base64_decode() functions and
replace their usage with the generic base64_encode() and base64_decode()
helpers from lib/base64.

This eliminates the custom implementation in Ceph, reduces code
duplication, and relies on the shared Base64 code in lib.
The helpers preserve RFC 3501-compliant Base64 encoding without padding,
so there are no functional changes.

This change also improves performance: encoding is about 2.7x faster and
decoding achieves 43-52x speedups compared to the previous local
implementation.

Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 fs/ceph/crypto.c | 60 ++++--------------------------------------------
 fs/ceph/crypto.h |  6 +----
 fs/ceph/dir.c    |  5 ++--
 fs/ceph/inode.c  |  2 +-
 4 files changed, 9 insertions(+), 64 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index cab722619..9bb0f320b 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -15,59 +15,6 @@
 #include "mds_client.h"
 #include "crypto.h"
 
-/*
- * The base64url encoding used by fscrypt includes the '_' character, which may
- * cause problems in snapshot names (which can not start with '_').  Thus, we
- * used the base64 encoding defined for IMAP mailbox names (RFC 3501) instead,
- * which replaces '-' and '_' by '+' and ','.
- */
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	char *cp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits)
-		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
-	return cp - dst;
-}
-
-int ceph_base64_decode(const char *src, int srclen, u8 *dst)
-{
-	u32 ac = 0;
-	int bits = 0;
-	int i;
-	u8 *bp = dst;
-
-	for (i = 0; i < srclen; i++) {
-		const char *p = strchr(base64_table, src[i]);
-
-		if (p == NULL || src[i] == 0)
-			return -1;
-		ac = (ac << 6) | (p - base64_table);
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
-		}
-	}
-	if (ac & ((1 << bits) - 1))
-		return -1;
-	return bp - dst;
-}
-
 static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
@@ -316,7 +263,7 @@ int ceph_encode_encrypted_dname(struct inode *parent, char *buf, int elen)
 	}
 
 	/* base64 encode the encrypted name */
-	elen = ceph_base64_encode(cryptbuf, len, p);
+	elen = base64_encode(cryptbuf, len, p, false, BASE64_IMAP);
 	doutc(cl, "base64-encoded ciphertext name = %.*s\n", elen, p);
 
 	/* To understand the 240 limit, see CEPH_NOHASH_NAME_MAX comments */
@@ -410,7 +357,8 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 			tname = &_tname;
 		}
 
-		declen = ceph_base64_decode(name, name_len, tname->name);
+		declen = base64_decode(name, name_len,
+				       tname->name, false, BASE64_IMAP);
 		if (declen <= 0) {
 			ret = -EIO;
 			goto out;
@@ -424,7 +372,7 @@ int ceph_fname_to_usr(const struct ceph_fname *fname, struct fscrypt_str *tname,
 
 	ret = fscrypt_fname_disk_to_usr(dir, 0, 0, &iname, oname);
 	if (!ret && (dir != fname->dir)) {
-		char tmp_buf[CEPH_BASE64_CHARS(NAME_MAX)];
+		char tmp_buf[BASE64_CHARS(NAME_MAX)];
 
 		name_len = snprintf(tmp_buf, sizeof(tmp_buf), "_%.*s_%ld",
 				    oname->len, oname->name, dir->i_ino);
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 23612b2e9..b748e2060 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -8,6 +8,7 @@
 
 #include <crypto/sha2.h>
 #include <linux/fscrypt.h>
+#include <linux/base64.h>
 
 #define CEPH_FSCRYPT_BLOCK_SHIFT   12
 #define CEPH_FSCRYPT_BLOCK_SIZE    (_AC(1, UL) << CEPH_FSCRYPT_BLOCK_SHIFT)
@@ -89,11 +90,6 @@ static inline u32 ceph_fscrypt_auth_len(struct ceph_fscrypt_auth *fa)
  */
 #define CEPH_NOHASH_NAME_MAX (180 - SHA256_DIGEST_SIZE)
 
-#define CEPH_BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3)
-
-int ceph_base64_encode(const u8 *src, int srclen, char *dst);
-int ceph_base64_decode(const char *src, int srclen, u8 *dst);
-
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
 void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 8478e7e75..25045d817 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -998,13 +998,14 @@ static int prep_encrypted_symlink_target(struct ceph_mds_request *req,
 	if (err)
 		goto out;
 
-	req->r_path2 = kmalloc(CEPH_BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
+	req->r_path2 = kmalloc(BASE64_CHARS(osd_link.len) + 1, GFP_KERNEL);
 	if (!req->r_path2) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	len = ceph_base64_encode(osd_link.name, osd_link.len, req->r_path2);
+	len = base64_encode(osd_link.name, osd_link.len,
+			    req->r_path2, false, BASE64_IMAP);
 	req->r_path2[len] = '\0';
 out:
 	fscrypt_fname_free_buffer(&osd_link);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index fc543075b..d06fb76fc 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -911,7 +911,7 @@ static int decode_encrypted_symlink(struct ceph_mds_client *mdsc,
 	if (!sym)
 		return -ENOMEM;
 
-	declen = ceph_base64_decode(encsym, enclen, sym);
+	declen = base64_decode(encsym, enclen, sym, false, BASE64_IMAP);
 	if (declen < 0) {
 		pr_err_client(cl,
 			"can't decode symlink (%d). Content: %.*s\n",
-- 
2.34.1


