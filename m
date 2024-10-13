Return-Path: <ceph-devel+bounces-1901-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3416699B7DE
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 03:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDA1E1F226AF
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 01:17:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F990231CB0;
	Sun, 13 Oct 2024 01:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="D+izDBgY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECCC231C84
	for <ceph-devel@vger.kernel.org>; Sun, 13 Oct 2024 01:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728782212; cv=none; b=JD9oRls8SlWIsLi0HpXHxAV75wISS5DurF23ZHlIK05HL6d5p3iUN/JOuCYwAwMPlNplZWrfw4lvMabAZ3RUJthGZ/ja5nDpj1bt3YDcz3Es/JGhsNm0imO1YqETjGdKDM91pIME/MMgJoy3iu88pCG9589c0DF8mMfUb0moYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728782212; c=relaxed/simple;
	bh=EIRenDw2BqfpW0tGN7vT3a/GQQiZ5fM48AI43utYV5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiWjo/8yoIYO2hWAbJd6D+QRVJbZnuYMSJWv6SFGaslLh48GnDlel5P93JvQ40ag051YvM6n7PziiVRzIRddNXMwId74+vCnOoJFt5xAR9qw1+OiQo6qHj0S+C1oEQmZ2i3sZPJOKVOIKoQ+mTtt96QRZwVtPZpWZibq6y10ABw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=D+izDBgY; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7afc5e480dbso230706785a.3
        for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 18:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728782210; x=1729387010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1JP/aMLtWgkr4nEgb/QbGxbr1aV47kQlfIyzJktF6o=;
        b=D+izDBgYNDIfKmHBKIHpYADkKNzcu0VWs953jaWqVXsJ8yErWK3YbA7dvRy3915zgv
         JB5aK71v4HaKeCILJJS8vu5jbsuXEu+HqXfrdPHjkdVp6URSzRTiYICVKvfm8r+T10I5
         RZTqnN/BDWkCkxI+Pv+8670yVJbO4ZMOof5IzuePU+QpT+ZDjmQLPNJPn8yT3zuKsFAd
         0v3Tlyq4b28LPSCCUYTMrcX3dDmEr5Y8IKPoc8qfprU1rIol+/gOrv8MgR8kQuRHTWSd
         we3MM0nDiYr+11JPc2kFlm+R8T4530cqC84FU/rYunt3Ffc6BsyA4uuoYtPkYliP1Myj
         Y4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728782210; x=1729387010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1JP/aMLtWgkr4nEgb/QbGxbr1aV47kQlfIyzJktF6o=;
        b=WBRKwy5lgHvtGMsLeS1V/keSIOMPb02lYP8LFNrEmlVSonZMIIrf4kRaGP4pZb6vrf
         KEv9IoplKo4pHQfYtyswMM6vaDo82oBXJmxBJWqNibrfIgUBVAmmTQOHr1yyRzB3PGDm
         wrq3qmPsbi2UAqVKa3ZRr+sgkp5NH624fbGcfObICrXdlUUsy2FMNDaGTdr/Ppqc1bnG
         et3H/GZ0vwNPeByOnNNq5vv32reAtEuH+9rsJQKMzLuyp/Wh0Wrvkz9tqAiq9qCcFlNP
         K46nz/NZxs0VYxHrkIh6dvwMzUejRhfnNPCbjx3w6NjCdb11u+9ML/K8mdL+vwDVlJVB
         xCsQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0UAouy2MAGG1fzNsjxFZD5/kXVY/sFn+gTsmpUd98PR2VK3l9Iqd9Tu/qAQJEVo7B8gjNyerFr8uE@vger.kernel.org
X-Gm-Message-State: AOJu0YwZbmHCmUDdIDzhzR/t3ac28/XPhi0rIVeGkQwRBnOXCiCgUsW1
	pOZUaCBu9Pl6xELtiRGnBjwbUpsAcaXsmj1WOH2j+VB86gj8GQoDTlltlewpug==
X-Google-Smtp-Source: AGHT+IFzaotxC5gGcUuBGItE9Hl6lkk9SyC4dInEzsiB/Nq4eZhc3Bnjj9WkKljw4NDmmMFayfxbBQ==
X-Received: by 2002:a05:620a:3f85:b0:79e:f850:e4de with SMTP id af79cd13be357-7b11a2e42eamr1334593885a.0.1728782209943;
        Sat, 12 Oct 2024 18:16:49 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b11497704dsm273414185a.101.2024.10.12.18.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 18:16:49 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ceph: requalify some char pointers as const
Date: Sat, 12 Oct 2024 21:16:37 -0400
Message-ID: <20241013011642.555987-2-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241013011642.555987-1-batrick@batbytes.com>
References: <20241013011642.555987-1-batrick@batbytes.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 73f321b52895..42bdbe5b7ef9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -286,7 +286,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	struct ceph_fsid fsid;
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
-	char *fsid_start, *fs_name_start;
+	const char *fsid_start, *fs_name_start;
 
 	if (*dev_name_end != '=') {
 		dout("separator '=' missing in source");

base-commit: 7234e2ea0edd00bfb6bb2159e55878c19885ce68
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


