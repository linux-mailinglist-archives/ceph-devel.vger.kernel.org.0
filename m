Return-Path: <ceph-devel+bounces-2274-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3989E8D1D
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 09:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5379164CE2
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2024 08:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2942144A4;
	Mon,  9 Dec 2024 08:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpwW+sjA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F7254918
	for <ceph-devel@vger.kernel.org>; Mon,  9 Dec 2024 08:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733732202; cv=none; b=RK948FOoTEsHTe8EuB6oiinup1abC5ePbbHPa5rbv3dP2rE/lTKYLtSooMAPQTpVpB/FTXYnN5zt0QJ06zJKuBJ2+flwBwQ9lBbC6FeWLEoXPziq18HYb+NMi1QNAM2k2H/l/XLtgRqXQT5AXEfnX88RZBvzJL02xhSIqGfGWYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733732202; c=relaxed/simple;
	bh=cv91eaOjF84dhGY5z4dPoabxkj7Qx5zzyfdDUlILbEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=r02qJ6RJOqalVWDLwfNeXiHBamTRIXhvAVIoiJhyFKWjkvIUVm1qWekplSrfkN73lBi475vZ6Vc0QQ2C4jA3n40YeDCMkK7ImNfAYmerxtB0vribgZ9LLQvQUZu1lBQ3ZpPzLMbcKe44u6o9v+NrCmyLaZvhVTdIVkPM/8ifLKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpwW+sjA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733732199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MSnb4tcmMZeftvdJqymxhSeEp/eC4ruAozCiE/UHa4k=;
	b=fpwW+sjAZN0L/RPOK40YT583czNNbzufpQYp6cZMeXtBg2bIPkOXUsLigWymt+b4orY7ha
	b4f+Tnnr4/+cVH86ycUwneEUpT4yJwXDESblSlIoMPaYRWKK5iDrbIb+NnPnOIXUdS6IBd
	QTsRK/MYA9pBtOHW74JIsmTRbglwZiE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-z2mEva07MmyGLNiZfrV-QA-1; Mon, 09 Dec 2024 03:16:38 -0500
X-MC-Unique: z2mEva07MmyGLNiZfrV-QA-1
X-Mimecast-MFC-AGG-ID: z2mEva07MmyGLNiZfrV-QA
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5d3ff3c1b34so775221a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 09 Dec 2024 00:16:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733732197; x=1734336997;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MSnb4tcmMZeftvdJqymxhSeEp/eC4ruAozCiE/UHa4k=;
        b=nzsEZWnhZuC+LzRfonvENQNOyTEC06/7Q4Gd2wY3/vOaDTBR3omiG2X+ojSASV79dE
         VAiu1cSCEwHmoNzKUkVrpAWuXZu79uXI8AUz35MmZrrrG925fVrq5MIEWIdLwGS6xRoK
         SuXjRTlq+8Z8+E1mUplj9pNWR0VRQCPPZUn9IRf5SOCblXo+Dd5K4o4e1coyPFqWWDZO
         cSbHKCPlvG8+ppBOeMpvsuYNmOFHWTN0xJHE7fSpeq7Di5wBLRaxxz9JXCi6C/0n+qDa
         982Xu/6MQT5OiZtIVBVe6FIRQ8mA1b0N/qb5Dw1Wipkf/eDxBLTMMBXCI59lIgIVXyjS
         XiDQ==
X-Gm-Message-State: AOJu0YwJDVhvC95I4+2aK5glpMXWYcG3HZrFp9AP1OtQPtez4RWfwh4Y
	pRYo9em3DjYs+QDMXYoRJY4h/ibaWNgtJwnPtXx7Mqdunlxb4vYnKD5P46ApO2/DYIdsxcz5zL5
	LaUEUVrQGNUs7Dv58VcAJF8WoRbr/Wah4pTPE+bszlP0nQCxKdHJasjLn/+GV1Vg4Mnkey46UZy
	mCwk3/Nnnkt1VhjWDStMa4HeovnEL2jN1Y49LqGJoO/w==
X-Gm-Gg: ASbGncuqzW4wp0W6avMNoV93PW+IAkt9pvttic5JCictNa2pby+ovjR8xpbCo/6uhYx
	pNhjoCKqzzpNHandrCsZfvMs9jFozmNI=
X-Received: by 2002:a17:906:31ce:b0:aa6:72d3:aab8 with SMTP id a640c23a62f3a-aa672d3b323mr400318866b.48.1733732196770;
        Mon, 09 Dec 2024 00:16:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPCPj2aBpa14+1QtwMjzKMIZX32l1fJcTLYCmDDsgSdr5BpxPJFwQPe7MEWLoWA/8H7cV5K+o4jZywjSCTcuA=
X-Received: by 2002:a17:906:31ce:b0:aa6:72d3:aab8 with SMTP id
 a640c23a62f3a-aa672d3b323mr400317166b.48.1733732196385; Mon, 09 Dec 2024
 00:16:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241208172930.3975558-1-amarkuze@redhat.com> <CO1PR15MB487619C4B0B6483072E233C392332@CO1PR15MB4876.namprd15.prod.outlook.com>
In-Reply-To: <CO1PR15MB487619C4B0B6483072E233C392332@CO1PR15MB4876.namprd15.prod.outlook.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 9 Dec 2024 10:16:25 +0200
Message-ID: <CAO8a2ShLJP686V7T6sRnS=GHtHAJASrk+_ZE6qFEja0mCwiXHQ@mail.gmail.com>
Subject: Fwd: [PATCH] ceph: improve error handling and short/overflow-read
 logic in __ceph_sync_read()
To: ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"

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
@@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
         if (ceph_inode_is_shutdown(inode))
                 return -EIO;

-       if (!len)
+       if (!len || !i_size)
                 return 0;
         /*
          * flush any page cache pages in this range.  this
@@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                 int num_pages;
                 size_t page_off;
                 bool more;
-               int idx;
+               int idx = 0;
                 size_t left;
                 struct ceph_osd_req_op *op;
                 u64 read_off = off;
@@ -1160,7 +1160,14 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                 else if (ret == -ENOENT)
                         ret = 0;

-               if (ret > 0 && IS_ENCRYPTED(inode)) {
+               if (ret < 0) {
+                       ceph_osdc_put_request(req);
+                       if (ret == -EBLOCKLISTED)
+                               fsc->blocklisted = true;
+                       break;
+               }
+
+               if (IS_ENCRYPTED(inode)) {
                         int fret;

                         fret = ceph_fscrypt_decrypt_extents(inode, pages,
@@ -1187,7 +1194,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                 }

                 /* Short read but not EOF? Zero out the remainder. */
-               if (ret >= 0 && ret < len && (off + ret < i_size)) {
+               if (ret < len && (off + ret < i_size)) {
                         int zlen = min(len - ret, i_size - off - ret);
                         int zoff = page_off + ret;

@@ -1197,13 +1204,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                         ret += zlen;
                 }

-               idx = 0;
-               if (ret <= 0)
-                       left = 0;
-               else if (off + ret > i_size)
-                       left = i_size - off;
+               if (off + ret > i_size)
+                       left = (i_size > off) ? i_size - off : 0;
                 else
                         left = ret;
+
                 while (left > 0) {
                         size_t plen, copied;

@@ -1222,12 +1227,6 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,

                 ceph_osdc_put_request(req);

-               if (ret < 0) {
-                       if (ret == -EBLOCKLISTED)
-                               fsc->blocklisted = true;
-                       break;
-               }
-
                 if (off >= i_size || !more)
                         break;
         }
--
2.34.1


