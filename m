Return-Path: <ceph-devel+bounces-1573-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF5193F096
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 11:07:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C0AD9B20DD6
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 09:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D86E713D8BF;
	Mon, 29 Jul 2024 09:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UIRM+pa3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B6113CA95
	for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 09:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722244013; cv=none; b=SAla+TdqzopHE/qeGhalNbtN6nX+D4hqW1DC18+5CAm9AWbbZVZE7M/B2JrDz0ywG8EryNGfGLpQ+YFq+Z+j1kyRKy3iOfCQsLlvhTbZC72lNwK5snNWxH1aq1Skq1/Hs2qo8yqVxurJsKLLy8PkthNbf7v2+nI/ra43EiNTfsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722244013; c=relaxed/simple;
	bh=hykvftg3vhQtA4vVyQKMdRddESCKg0yCsxhDTFA9jWM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dahlHqCpY+ZDL/R2EP0a0ZrBGI4ar6GpKRAY+x8wf4uFipLsMjySZoYt85Qo67dMjSiHrN6D5lc77iu6q85rt75neD8n5fIitWi969AKUngJ2GBiHDGb+nCgIeGTsy2CzR+22uu08GTCIlzcJm83tlUVoipaLZrqctpZWhY+Dr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UIRM+pa3; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ef2d582e31so39053181fa.2
        for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 02:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722244010; x=1722848810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7iJw9k6D1Ud7dg7cELMS+oQmF5+B7DIbU5iHUw2ERek=;
        b=UIRM+pa3ixAnUoVh4g5qMCKIxJIMQIyxA2EIAAiyV94JGCFSDGFCxeYoemZrIxjjqC
         lbtOSHZW7xkP+clvbV09jvOQOWYGGRTIdpxiEZKT0k9KiRHt+Mnuo0oC014EXEWz/YSP
         Hk5aFgpOcQy+S+RSG9oIqZd90J9KIQcj3MVTifBYc0f4rWMUTBd5WMBukswmE8CPxIp5
         P1WR58BBLeaYwthiZFCAfP6kc2lZCGZ2ls2En921/ZAlV7tswXyTO3Sbs+1YOWJekhBb
         tMu4CqFsmFKmvX1HaTeHfKt6uk2J0/elPbF8tsQ92h1IiiL1gai2PNJOsAPWbuNEONdQ
         xA2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722244010; x=1722848810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7iJw9k6D1Ud7dg7cELMS+oQmF5+B7DIbU5iHUw2ERek=;
        b=n5PSe8iZiUtdo7CYXbozB0ueYRq4eBRMn7ahcR0+prPy1ZJmxz/YUfn/eEjwraTw+r
         3h99QNCK/obP5mHPxV+gWvIlgyx2ct1ujlGH371v8DKISSB9Jl+vqa/OSJcuRelFjjda
         MAp1HiENBEXDPqhcprT1/FKwoOiWx9KbOuXA/mCbEDNAqUwPDlwvPYZAVs/WD+7MmgkE
         MsrmO1uai/mzmHNRfbVgwg1LjdRH9A8iggmyIaQKfwrYrNKrGKGxomauDaCDoMpt8ZBn
         ILTovdJdttPX6xBJzc5REGEUCUerYvab1yl4yQ33h4bfO8zB2kq7OKBSJ2SaMKAkIwzS
         e6Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUFQOuvJC9e2q2rbI5/k/AX53/4HMj/Q2egcdYsoXPMgeQ5h6jGnf/X2h1AwMaYf2/3wMmTJx4Rok27V20jAeasy6Czt4j3KOzqOA==
X-Gm-Message-State: AOJu0Yz5Mut2JpDfLkBmCuupWK5grbKqTLVhr9PC+X1tr2rYVkWxza23
	IFkQXZivnSC20R3CLOjaAam9kxbyt9e2mLdfS53FV+7/e5+soh9JkZILJb4Fmbo=
X-Google-Smtp-Source: AGHT+IH0aAp6nqFToH47ycIHryIQNXERRaRXnmdtYJYfX6Q5qoO3wtejC77Lmfcly4PoTitp0zXv9A==
X-Received: by 2002:a2e:330e:0:b0:2ef:2472:300a with SMTP id 38308e7fff4ca-2f12edfc2a1mr45943311fa.2.1722244009483;
        Mon, 29 Jul 2024 02:06:49 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f03cd00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f03:cd00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac63b59bfesm5456620a12.44.2024.07.29.02.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 02:06:49 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: dhowells@redhat.com,
	jlayton@kernel.org
Cc: willy@infradead.org,
	linux-cachefs@redhat.com,
	linux-fsdevel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH] fs/ceph/addr: pass using_pgpriv2=false to fscache_write_to_cache()
Date: Mon, 29 Jul 2024 11:06:39 +0200
Message-ID: <20240729090639.852732-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This piece was missing in commit ae678317b95e ("netfs: Remove
deprecated use of PG_private_2 as a second writeback flag").

There is one remaining use of PG_private_2: the function
__fscache_clear_page_bits(), whose only purpose is to clear
PG_private_2.  This is done via folio_end_private_2() which also
releases the folio reference which was supposed to be taken by
folio_start_private_2() (via ceph_set_page_fscache()).

__fscache_clear_page_bits() is called by __fscache_write_to_cache(),
but only if the parameter using_pgpriv2 is true; the only caller of
that function is ceph_fscache_write_to_cache() which still passes
true.

By calling folio_end_private_2() without folio_start_private_2(), the
folio refcounter breaks and causes trouble like RCU stalls and general
protection faults.

Cc: stable@vger.kernel.org
Fixes: ae678317b95e ("netfs: Remove deprecated use of PG_private_2 as a second writeback flag")
Link: https://lore.kernel.org/ceph-devel/CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com/
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8c16bc5250ef..aacea3e8fd6d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -512,7 +512,7 @@ static void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, b
 	struct fscache_cookie *cookie = ceph_fscache_cookie(ci);
 
 	fscache_write_to_cache(cookie, inode->i_mapping, off, len, i_size_read(inode),
-			       ceph_fscache_write_terminated, inode, true, caching);
+			       ceph_fscache_write_terminated, inode, false, caching);
 }
 #else
 static inline void ceph_fscache_write_to_cache(struct inode *inode, u64 off, u64 len, bool caching)
-- 
2.43.0


