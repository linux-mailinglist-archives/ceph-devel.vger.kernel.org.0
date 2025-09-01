Return-Path: <ceph-devel+bounces-3497-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB440B3EAB6
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Sep 2025 17:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 080C6167538
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Sep 2025 15:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 793A13081CB;
	Mon,  1 Sep 2025 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4NR0fjk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD98932F777
	for <ceph-devel@vger.kernel.org>; Mon,  1 Sep 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756739701; cv=none; b=fz3jSt/7NqA1KxcdIwgsooOTe3jCXTrruyL9Mf4pSsd9DVIFYoSBDth2bgCJDreBbf5GQ+y/MPFbGeHFEttXSNJ1vumkQwhIoDh7h3hOY0yHacizOTJYSRUMtN1e3fQefVpVNv9OiPnvt48BINCw30dp184WleXtqz5OjCVTz+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756739701; c=relaxed/simple;
	bh=d9ZsWkV9weZU5EgWpzqcvnFADsgoVlKQdwsP0siCujs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=orLQGlPYh3CbzJzu30eTi2XXZ0ARlsIcLhxxai1guzDef3qizHH/locYh3X2Z5kgywQw7+2yUKAgghsJ+XI3Bc7Y0COQBVxVXpWqxlpgqcljWS0NFmk+yiwNGm2dxRimY2jhbIu1M3/wryUb5v7asfWCuumDi80tn4Pe8EKUr8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B4NR0fjk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0urIMojorRra0z+jtQP3egYMiZwvjHHk7h/DnJcG8EQ=;
	b=B4NR0fjkyPKVJYbhmp3UY1vDK32QNa/51psjFl23zolPCQEjMn9RrtbiXHMm/AC9RmdkzP
	Fic+8IcKYB4AhlIVaN6MKdOC19FjGsxpitOI6S4dHeEMugPOa7o9ZrEMzTWif3dSDFXsNT
	l0oQJH4AES24VoOInqRbkudNgNGd6FY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-552-VubX-2aPNhamVpUJdvqtqQ-1; Mon, 01 Sep 2025 11:14:58 -0400
X-MC-Unique: VubX-2aPNhamVpUJdvqtqQ-1
X-Mimecast-MFC-AGG-ID: VubX-2aPNhamVpUJdvqtqQ_1756739697
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b3118ab93aso57144791cf.0
        for <ceph-devel@vger.kernel.org>; Mon, 01 Sep 2025 08:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756739697; x=1757344497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0urIMojorRra0z+jtQP3egYMiZwvjHHk7h/DnJcG8EQ=;
        b=ZaAtCr/OWpR6rk3b1VvcqR8DU8I1y1HPXEY7uK0XffT2TVe0cAnfS5FdqjpYqHhvIv
         NcU66ILY5SUfunilDiDfELMi21P7IkpKrn1HhlQvL+OSALvgxFo2fHTTyAcv0nyNTAPf
         ZR7NIuuHHwaKixyRI3hhszn/ARW0f2/E56t25o/I8J+gbPpmaQnN3GyhxIjAcuU3DMmR
         mPJyYQ5Eduvw9W4z0ZHUvG0T1hJHIV9qX8fG65ae1EJMJYmeaKk7fPk77Ul6WYHZ/YBs
         tA9Hg/HMRpfGPY0lNx0aYuwER7QtcoZ1vWS7R2n1+KjhDEQZwB9fC/MJmiMS+Nd1W7xm
         Q1Ew==
X-Gm-Message-State: AOJu0YxV4j1MfAoqIrk8Clp68MZNEwbKUCZmIgRYGmg31mHn5MWzplBb
	R2zb2JYNQN0+UoB2F3Y6+HQaInVGS1fMoImN+Z13wQnYnfFZhQ0YlyYi/iZeifiax+ZKVU5jMzC
	U+gBbpBqjJe6UWVXqWQXscWiXMLNmRzFY48QSEMVMKrKUsAM6EWn1Ul8N7dk+E4wv8dYtnJM431
	Gzt0+bQtTl+TKBJK6gV00yVo7XplKmIkcKz1p88gIRNGck65sSiQ==
X-Gm-Gg: ASbGnctvQDgEaDvHXiNvPicw9nGg3AhERI46dbRpBQwik8qTRh9anYJIpGtysHFol/3
	A8NvcOw1xfjj0ABkBZIcIr1352HKrBsRqo2pezYTKKaQzPkSmZbLcQD7p1NMvjIk0oPTS54VWZM
	K77XBcLPNkt1ZkhdctIx9k5SeCkPfqbLQmRWHqW4Vj7dZj3j42yez88qkFT52cykOsCNhlIOKLH
	YiBtXkrQNzgv/DJr2QJ+b7rww+1h5Dcgz5KgV33mB2Bnb4KDb09hGF+Ji2m7UEQZeY0idMwb/ER
	LJyhCORgzFfzZhGhKFgH4DxQVOmCTAQDJB3WkwkGeNMlVMKzcS0G8XVKGOdwLvFFR/MImVWaYQ=
	=
X-Received: by 2002:a05:622a:1c15:b0:4b0:6aa5:be8f with SMTP id d75a77b69052e-4b31d888517mr85860241cf.25.1756739697226;
        Mon, 01 Sep 2025 08:14:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFVnsjxpmb+OfsU9Oir/PMVU6TwlJKtOxrJdOJ9/JyaiwIcoUIkmvWobBUSFXBl6iDN+VVIbg==
X-Received: by 2002:a05:622a:1c15:b0:4b0:6aa5:be8f with SMTP id d75a77b69052e-4b31d888517mr85859601cf.25.1756739696458;
        Mon, 01 Sep 2025 08:14:56 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b30b67894bsm64286011cf.33.2025.09.01.08.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 08:14:56 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Slava.Dubeyko@ibm.com,
	idryomov@gmail.com,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 2/2] ceph/inode: drop extra reference from ceph_get_reply_dir() in ceph_fill_trace()
Date: Mon,  1 Sep 2025 15:14:48 +0000
Message-Id: <20250901151448.726098-2-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250901151448.726098-1-amarkuze@redhat.com>
References: <20250901151448.726098-1-amarkuze@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ceph_get_reply_dir() may return a different, referenced inode when r_parent is stale and the parent directory lock is not held.
ceph_fill_trace() used that inode but failed to drop the reference when it differed from req->r_parent, leaking an inode reference.

Keep the directory inode in a local and iput() it at function end if it does not match req->r_parent.

Signed-off-by: Alex Markuze <amarkuze@redhat.com>
---
 fs/ceph/inode.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 470ee595ecf2..439c08ece283 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1585,6 +1585,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
 	struct ceph_client *cl = fsc->client;
 	int err = 0;
+	struct inode *dir = NULL;
 
 	doutc(cl, "%p is_dentry %d is_target %d\n", req,
 	      rinfo->head->is_dentry, rinfo->head->is_target);
@@ -1601,7 +1602,11 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		 * r_parent may be stale, in cases when R_PARENT_LOCKED is not set,
 		 * so we need to get the correct inode
 		 */
-		struct inode *dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
+		dir = ceph_get_reply_dir(sb, req->r_parent, rinfo);
+		if (IS_ERR(dir)) {
+			err = PTR_ERR(dir);
+			goto done;
+		}
 		if (dir) {
 			err = ceph_fill_inode(dir, NULL, &rinfo->diri,
 					      rinfo->dirfrag, session, -1,
@@ -1869,6 +1874,9 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 					    &dvino, ptvino);
 	}
 done:
+	/* Drop extra ref from ceph_get_reply_dir() if it returned a new inode */
+	if (!IS_ERR(dir) && dir && dir != req->r_parent)
+		iput(dir);
 	doutc(cl, "done err=%d\n", err);
 	return err;
 }
-- 
2.34.1


