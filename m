Return-Path: <ceph-devel+bounces-3017-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8B5A96482
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Apr 2025 11:34:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C7E463B4330
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Apr 2025 09:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583F6202C58;
	Tue, 22 Apr 2025 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cj8gb86c"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB76202C5C
	for <ceph-devel@vger.kernel.org>; Tue, 22 Apr 2025 09:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745314332; cv=none; b=UHc1TGynAzhBTwY1Z0ycDtTYSdjkVOEMD41XQt39Lf1wBJOrVU75vP+SNnTACGZLU/UofMJwRCHRCIUGLyvc4goQBkZ8orDdIU5GSWeUUcWUb6dFitGC6NvEVJ4qWoacmGrmbHoTuPEBAW3To7kz+vDm9E/UCpnYJEyqD3W+nGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745314332; c=relaxed/simple;
	bh=UJtLZckgjShTD9DLK7kz6cd5GubJ7sJ5EHvnuNrUBeo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZHath48sjGfiGvr4sKKukb0lq1M+8n08AJCq4uyKQSTFaXyp+oyJRm10Um6FWO99g8Jyac1h3ORoEPG5E7rpR/Y7lWQda4vmCobDy2ZKTyfnrd7CRSCNKQq4nUjANMklm8VT6FNeKxGWDFDj2xy+y7aIw1VNuNwFodPI4YXGTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cj8gb86c; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-30db3f3c907so44458631fa.1
        for <ceph-devel@vger.kernel.org>; Tue, 22 Apr 2025 02:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745314328; x=1745919128; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0sHGm3uxYYPA2BerxXuoC8RpvF0z2wS137WLjwPW764=;
        b=Cj8gb86ccvAEpdkblHcRfd1KDgC7V4mNvG6ek4uBBSmn9+qnJBr2TbkGmJUTMtAcOW
         yxDpe2EJpwBE5JAfOE1HM5qghudDF+qzWloApf1wuuBQrl9hj90mANQh2FPB/5MILoQy
         fUp84l0GU98vOsty5iKEq6Or59gZ/oWfqEQEfYMiOHPKOR+KqkG2nfUBvLeHoZ8iZbX6
         uZ2M1QrdqPllK9ij4CezEfP0Zr1TpjTpuIIT+qyjICcSo45oz5LG6RcLVXSEhe3eBwoe
         VhtWOA9nzdkipKHOi7dEfW+YFoFrqyQeVlHlTGEU0A1kQsIepfqGivNvVcj9Ddey/HU/
         sVYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745314328; x=1745919128;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0sHGm3uxYYPA2BerxXuoC8RpvF0z2wS137WLjwPW764=;
        b=Lj6bbnfVo17CvPHogcJHyKdvkYoDiq8Pw+O+32OyWBAOQN/JfV2GPsSCTFGiuLR3MO
         bi1ty6OIqR+7/FhgnB/3FHV7dnka+hzBCzuCaGo5NPo0WO577O2sOeBLJc+ukdM8TfdD
         kRrn2GqUaZ14YUatJ/lqW6xbsS/OEWv/T+oG+QOxsg9X3QPIQL3ZhGTUsQ12eQHeM/1r
         M0iTbI3A0F97PZNTDvCHDpegK9jeOvoDt3dagi+/ACW2sDCKsTYEPnODRxvRNbZp932E
         bCRCa6QuFTHfmyE0pq9TexngyB2aLBo1x9Vfz7PYhXqYPtALMwr9QZMBoGRjCqeuD1fS
         4cnA==
X-Forwarded-Encrypted: i=1; AJvYcCX0MWSnem8h2znva5wr/3JwnvShhHqx/xp7jyCueApR5Xe0PimLjne2G3iSf+5kpWuTwEDXAFXwmVRu@vger.kernel.org
X-Gm-Message-State: AOJu0YwIaUKwgO1FAu3XbuymujJz6EkqT2MPX8gJTfRw1xT+iIT+qBPC
	ozwniIPOUhbwT+DLkIGs2fMQzxCnfB99Iue21IhMGvqeL67sPZlacsP3qgYv/kE=
X-Gm-Gg: ASbGnct5kYQq9JnWfY+R+Vv4kojz+b6M38LuJlXaS/4fax9bxlhgS7mgQINv61RwjL8
	E9SGQoV4T06SgWR96PNL81qbY2v9zKc0CzyCvmZdfeuI79VguF3CkIzb3d5/OAdI6AGE1AEnZ9k
	AU5cBaG8UnvUZaEZ++x0xI7JrKvfsbcQMC8rf8PRjlYI98u7GQa+z8a5kGoeAjv2TYlrT14Body
	q4E46nwZLFfrxZRQ79OC8Ccnq5JwX+HP5dmC7qD6fx4iF8Xa3XKPjWanUOwENwD8DUJWqs2f/QV
	BTahYZ+GXQ1rMZwkkON/IuU09Yhuc1s2zMHcEstQ0pWBWVYhXa0YpA==
X-Google-Smtp-Source: AGHT+IEA9TeSEr74TXhupDPpKnSc+rpRb8Ccgxw8+9jpaQXfTwiOI4VwS54k+ElDOYyd22J8O2FG2Q==
X-Received: by 2002:a2e:a888:0:b0:30d:69cd:ddcf with SMTP id 38308e7fff4ca-310903d1a72mr48182701fa.0.1745314328128;
        Tue, 22 Apr 2025 02:32:08 -0700 (PDT)
Received: from localhost.localdomain ([185.201.30.223])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-310907a6736sm13776621fa.51.2025.04.22.02.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 02:32:07 -0700 (PDT)
From: Dmitry Kandybka <d.kandybka@gmail.com>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,
	ceph-devel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] ceph: fix possible integer overflow in ceph_zero_objects()
Date: Tue, 22 Apr 2025 12:32:04 +0300
Message-ID: <20250422093206.1228087-1-d.kandybka@gmail.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In 'ceph_zero_objects', promote 'object_size' to 'u64' to avoid possible
integer overflow.
Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
---
 fs/ceph/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 851d70200c6b..a7254cab44cc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2616,7 +2616,7 @@ static int ceph_zero_objects(struct inode *inode, loff_t offset, loff_t length)
 	s32 stripe_unit = ci->i_layout.stripe_unit;
 	s32 stripe_count = ci->i_layout.stripe_count;
 	s32 object_size = ci->i_layout.object_size;
-	u64 object_set_size = object_size * stripe_count;
+	u64 object_set_size = (u64) object_size * stripe_count;
 	u64 nearly, t;
 
 	/* round offset up to next period boundary */
-- 
2.43.5


