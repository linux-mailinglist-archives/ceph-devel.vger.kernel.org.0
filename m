Return-Path: <ceph-devel+bounces-2259-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 665099E5A38
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 16:50:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10FC9166EEF
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 15:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EAEE21CA18;
	Thu,  5 Dec 2024 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="KXNBQZTA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AFC219A73
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 15:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413797; cv=none; b=oCzlMbcWDve0KEyhYd9Vk0cgIfnlsNgil+V6DY8c627VpXAag3VBtSzfbWiVNFyRPRXdJ3JrMA28luYlfHvHsV0eSvxjk7L+a0Vq0jXpKq5SdAxZ3r63P1kRq6TRtBek0z3TyQ+CWqAIZOSvK0Ywl3/1JyE65jFT4cUKxiBE6+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413797; c=relaxed/simple;
	bh=QJh0SocakRQFAItV+WIZs0QtfPK9Gb+2/saeLJIXm0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhY3vbEQqj1Ahfh6f35IGB1BMctPf8IUlIG9YVKAIot+5TlqITmgNylg0XP5NTFhB2J8PSRhoIZmQYkyndIs6XvLDCOcN7xaOdp23e1gNWG3ZLI9Gqm4lSjshD/tsZNZcdv/13QSKPUDgSivjSEFEgxjEeKzESpJpoP7wV9pESo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=KXNBQZTA; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa53ebdf3caso196323266b.2
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 07:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733413793; x=1734018593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwnaybcL2baNYeNlHgBi1xq+W7PQq1z/cLM7e155nn4=;
        b=KXNBQZTAR8I08avEHQdxB7EMte+ZfpmY/g+DZQoQFq+XmRCrsIAvTHksMXhDjsAB4H
         IloJ/Askvfysn9nr7sGRLr9Ci8zx9Ca/EWl21OLvmIOhujfDkPNjD0jlIaUUfYdkRFyq
         3d4lOH7sqVuQZMcVzoZkirLl0rGX+tN3IP+rRFxejOOvBhLI2JrdLhadToW4WoVQvYUc
         N5luOfQBg6joQMghHQPKjW/0HbYsQPNkmjQHjAnGhry5UUDbhGy6KVJ0aIUCEZvLet3a
         GTkY41kx/NbLnuFIQUufuvom3b49BSbGir0FUUEsR8IPFajy+50BzdZwaOHUaX+QHbPk
         aw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733413793; x=1734018593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jwnaybcL2baNYeNlHgBi1xq+W7PQq1z/cLM7e155nn4=;
        b=lomf5wW1wjvvtr/qq2JNqpOxikoi9MSUehlDeg1w+BS8poKtg03klX3SmxafMUmXzs
         rv88TGAUf/5ZJwQW2FoavRcp0tZhcOrHM9dAMqK0WymOt9XNzt0cdIc110LZ0EnpIJ4/
         rXdgIzXuXDzoQ7S5a9WVroDpdoUxxvyMslfAcKw+kRc94rCxHHO7e1UJ3sA7wqiZyLOT
         VjRFcPsCQUIFeUdeBhCr6upWjErw+3RO54uSUwoXMUZhn3MpV/YnQ2XxXsoAi+rQHsMe
         Rp0xhKgbbr7KvSnbxcaf5IGQkN9WCVOp/fdfTOQhRqGESfwN61/YngWhypleCyrXLywg
         KLmQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0Y4ZW5gmbimiamczRba6Fdw1UAW2PoFVF1I3Jh1LuDihZui6u1/6HXE/7GiSaG7GM4vqRvj3YuvZN@vger.kernel.org
X-Gm-Message-State: AOJu0YxVIoOdn7CmsAcEYZeC1o3g3uI59Nn8JeEXSEMwAgl9y5PsQ3j+
	CAhPa4Q3CdA0sQ+VSXkIfCbvDRU9qKGW7amg2lbUWkzps9GziAL0z2ASFE1Ywho=
X-Gm-Gg: ASbGncsXm6wmJppyM9C5cpkYVZdXq33sxnQF32orAeSrrLRZikFuoAvcP3dGIyFgucB
	VFCJeQTw3dYgRk2qPaD4rpw9k443zapKL/Hq73be//UO78pQecxwdUomEfMtZzszv2XF1Mv3BdJ
	YX6y/akR0HllSXVohgGQgx7nqS5qLG8x9OUKakNBuyIITVUTl5ZLPy+N1UuFExyvr14iqr6UNTJ
	/7WvDgGZ6Guur4sQpCu1rMVZm2FUKaQNuUi0RJ5Xg6gT0UkDBT3Jc2FEnVZSphGhlatQLT1Nt2X
	3xWbAJfEf1zUNkmsg2tZQECsWzhwmRCdpr0izTUAen8DhSYwlg==
X-Google-Smtp-Source: AGHT+IE2OSa7ZjCjHWl3RYhlRyZyKlZnSLP+x1YzEi8/mKnAl0lFCce0mHxT24btJrTigdztogh09Q==
X-Received: by 2002:a17:907:9713:b0:aa5:c9f4:7bb9 with SMTP id a640c23a62f3a-aa60182367dmr1087692866b.35.1733413793311;
        Thu, 05 Dec 2024 07:49:53 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2c8700023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2c:8700:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa625e58dffsm107575866b.13.2024.12.05.07.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 07:49:53 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: amarkuze@redhat.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2] fs/ceph/file: fix memory leaks in __ceph_sync_read()
Date: Thu,  5 Dec 2024 16:49:51 +0100
Message-ID: <20241205154951.4163232-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
References: <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In two `break` statements, the call to ceph_release_page_vector() was
missing, leaking the allocation from ceph_alloc_page_vector().

Instead of adding the missing ceph_release_page_vector() calls, the
Ceph maintainers preferred to transfer page ownership to the
`ceph_osd_request` by passing `own_pages=true` to
osd_req_op_extent_osd_data_pages().  This requires postponing the
ceph_osdc_put_request() call until after the block that accesses the
`pages`.

Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/file.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..ce342a5d4b8b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1127,7 +1127,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
 						 offset_in_page(read_off),
-						 false, false);
+						 false, true);
 
 		op = &req->r_ops[0];
 		if (sparse) {
@@ -1186,8 +1186,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			ret = min_t(ssize_t, fret, len);
 		}
 
-		ceph_osdc_put_request(req);
-
 		/* Short read but not EOF? Zero out the remainder. */
 		if (ret >= 0 && ret < len && (off + ret < i_size)) {
 			int zlen = min(len - ret, i_size - off - ret);
@@ -1221,7 +1219,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 				break;
 			}
 		}
-		ceph_release_page_vector(pages, num_pages);
+
+		ceph_osdc_put_request(req);
 
 		if (ret < 0) {
 			if (ret == -EBLOCKLISTED)
-- 
2.45.2


