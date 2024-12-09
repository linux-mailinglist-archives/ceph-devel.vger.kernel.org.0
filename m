Return-Path: <ceph-devel+bounces-2275-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71AA89E92AB
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 12:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3AA3282D32
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 11:44:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD6F121B1A8;
	Mon,  9 Dec 2024 11:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ov4DV40l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D3421764E
	for <ceph-devel@vger.kernel.org>; Mon,  9 Dec 2024 11:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733744651; cv=none; b=ISEVqQLyNKRxBdIA0mLD4GqBU2HaCulxLhy7Qi//W/bL726cPJxRMh2s/N0oPBABJ2jbZGOzAaf0o76+e4S4zcCK2RQBE3WrxAHP71BCdaKg6C+n+qrN9eNOgktfOlni55hucHC/NHnT3Iwbj4RnoBQhggudHKHh78+VForG/MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733744651; c=relaxed/simple;
	bh=r9EBNbbm7gAcA8t43/kJgC9SKgm4tsTHj8bl4TimuuU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aVFAKKH3xA1d34dpILq1C0iYnywnfP3mkMW7agz9VQDhe17301xHTQN7mE9Erk5Lf06qJYvryQTHhCKZmnEaCUji63S1uuz70CSnoqiQESpoxiiMCXfRxCU69unABqt0XRJVzDdBhFqUj0hSWLxmDSySVbVIbz8gzmRKn4tnovY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ov4DV40l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733744648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PLfDzvbbwI+wpzr+Ubvr+aqHJMScI7dEPybph92X5Os=;
	b=Ov4DV40l7HeodW/IqzlC6sIKPB6fwRs90kQp9fQYNez0tPrYyzPTk+0pEeb1UkH42DiqiZ
	jm2Ec35zJHcvAn3OKmpiOFGH7dLv8EOVA3igUIc1m7dfQIvjfJk7WW68suiz3u1VJikMXd
	Fm1TESjkPXh3+bKae8dFVLwL1YNCoqE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-zMtFgQJfMI-9Z7t7Dro66A-1; Mon, 09 Dec 2024 06:44:07 -0500
X-MC-Unique: zMtFgQJfMI-9Z7t7Dro66A-1
X-Mimecast-MFC-AGG-ID: zMtFgQJfMI-9Z7t7Dro66A
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d87efed6c4so75724666d6.1
        for <ceph-devel@vger.kernel.org>; Mon, 09 Dec 2024 03:44:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733744645; x=1734349445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PLfDzvbbwI+wpzr+Ubvr+aqHJMScI7dEPybph92X5Os=;
        b=WzgcEKTrxme1+VVG4RSbSZeSwaycNRZ6ebCSTCIsZg78/34JolyCD9OipRRrHWBQ4F
         lgGKDFur17taASfFiT9vRTIieRXlbGFOrQnDgcbK0Kc+5vGHlJDTEqEEVTgH46AD+yI5
         LPoesEyJWt+gPFLf+5+ZD/6qsdoFU09TMaj6xbVsxRi3/z1cYQ5ZLrb6f4cK5y0/kQ7b
         Sj+Ulx7fkuWSiMxCIK56QDSUMDfPPylmTLlKcav9shaYGluxwyjCPAdK7sKdzMka8nDG
         cnAGztHUcxp8TzbcvbpbFVmuDJpsmpjFWsMA/wj0chyEH4086YgveRAJlrQ2neE4CmQ1
         cCsQ==
X-Gm-Message-State: AOJu0YxMeFoABSIpU1Xxh50yvOHjAhuWzIvqx8ve6F4KbE5xsWIXsg9g
	LEyMVuQmVcSJ5ualyGOx/pgfu3Bey/U7nzxs2s+i2J7urEZr/RwISrG6+a63f6KrtuUJsvbMSAq
	kWOrtjFjTkZfrpNvNM3GO4Z/0Ak1Rd+04K8o+frr1MEzCbvZ18wVLScqvzdB0rxALsE70sJdwZj
	mMfBbf1GFAXf19PtJt9Mp/QoMeGJRsqDc4UOADencJA0jrew==
X-Gm-Gg: ASbGncsBFJDwuf2Of92Kf0ncqaFlgHsCwMA73QVyS53+AhmTlPYppXrUWEJav3ga29F
	U8VVESbTk/hNwBXrn5IVkP4z/le36J6iZQi/l70qJ+leK8/XF8z1YkKzR427BLh0kjR4cbYX83u
	5p8ITrkYJ/ENHu+zDOOLxVK0M23vMorEf5ldxuYCQDJ0QYbgxxKVB007ZzDZ1dUQaOD5SrFp/mi
	3BbEq5Y8mjS5KS27FHj7FC9TZKO7PQGznCYhEVzP6DMXbPhLNKwc7OwRXJKZu139rnJmwR3bJgV
	lZ/pU/d3ihFk494=
X-Received: by 2002:a05:6214:1bc6:b0:6d8:838f:8b54 with SMTP id 6a1803df08f44-6d8e72081aemr202565476d6.39.1733744645606;
        Mon, 09 Dec 2024 03:44:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxGbkXPdM7YHSjv1dhSk7BJvpbWukYmEVYw8v/vfpershKDrfDd7sJt6V1hxRbIksw69EW/A==
X-Received: by 2002:a05:6214:1bc6:b0:6d8:838f:8b54 with SMTP id 6a1803df08f44-6d8e72081aemr202565246d6.39.1733744645279;
        Mon, 09 Dec 2024 03:44:05 -0800 (PST)
Received: from metal-build.. (d4.5e.780d.ip4.static.sl-reverse.com. [13.120.94.212])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d8fa8f0453sm24475246d6.20.2024.12.09.03.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 03:44:04 -0800 (PST)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH] ceph: improve error handling and short/overflow-read logic in __ceph_sync_read()
Date: Mon,  9 Dec 2024 11:43:59 +0000
Message-Id: <20241209114359.1309965-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch refines the read logic in __ceph_sync_read() to ensure more
predictable and efficient behavior in various edge cases.

- Return early if the requested read length is zero or if the file size
  (`i_size`) is zero.
- Initialize the index variable (`idx`) where needed and reorder some
  code to ensure it is always set before use.
- Improve error handling by checking for negative return values earlier.
- Remove redundant encrypted file checks after failures. Only attempt
  filesystem-level decryption if the read succeeded.
- Simplify leftover calculations to correctly handle cases where the read
  extends beyond the end of the file or stops short.
- This resolves multiple issues caused by integer overflow
  - https://tracker.ceph.com/issues/67524
  - https://tracker.ceph.com/issues/68981
  - https://tracker.ceph.com/issues/68980

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/file.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index ce342a5d4b8b..8e0400d461a2 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	if (ceph_inode_is_shutdown(inode))
 		return -EIO;
 
-	if (!len)
+	if (!len || !i_size)
 		return 0;
 	/*
 	 * flush any page cache pages in this range.  this
@@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		int num_pages;
 		size_t page_off;
 		bool more;
-		int idx;
+		int idx = 0;
 		size_t left;
 		struct ceph_osd_req_op *op;
 		u64 read_off = off;
@@ -1160,7 +1160,14 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		else if (ret == -ENOENT)
 			ret = 0;
 
-		if (ret > 0 && IS_ENCRYPTED(inode)) {
+		if (ret < 0) {
+			ceph_osdc_put_request(req);
+			if (ret == -EBLOCKLISTED)
+				fsc->blocklisted = true;
+			break;
+		}
+
+		if (IS_ENCRYPTED(inode)) {
 			int fret;
 
 			fret = ceph_fscrypt_decrypt_extents(inode, pages,
@@ -1187,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 
 		/* Short read but not EOF? Zero out the remainder. */
-		if (ret >= 0 && ret < len && (off + ret < i_size)) {
+		if (ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
 			int zoff = page_off + ret;
 
@@ -1197,13 +1204,11 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			ret += zlen;
 		}
 
-		idx = 0;
-		if (ret <= 0)
-			left = 0;
-		else if (off + ret > i_size)
-			left = i_size - off;
+		if (off + ret > i_size)
+			left = (i_size > off) ? i_size - off : 0;
 		else
 			left = ret;
+
 		while (left > 0) {
 			size_t plen, copied;
 
@@ -1222,12 +1227,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 
 		ceph_osdc_put_request(req);
 
-		if (ret < 0) {
-			if (ret == -EBLOCKLISTED)
-				fsc->blocklisted = true;
-			break;
-		}
-
 		if (off >= i_size || !more)
 			break;
 	}
-- 
2.34.1


