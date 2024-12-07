Return-Path: <ceph-devel+bounces-2271-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE119E81D4
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 20:35:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81F982818C8
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Dec 2024 19:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF52A14C5A1;
	Sat,  7 Dec 2024 19:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFA5IzV9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEF214B945
	for <ceph-devel@vger.kernel.org>; Sat,  7 Dec 2024 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733600131; cv=none; b=abacFweRwrufKCxuNyjZvqa+YAMO0u2s9cGYVhwuW/SPXCbGtXDc0x/5ybvuFirmCcMlEMz33nraO4O9n/a4CrgzUBbCRZ6sdY0dJBBwZe7UrRikF0ZxYe1QGYCIIjMrwCZnBkRk0P4NkqaPSXPJbEikxKBRiNRd17+r+Mo1UCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733600131; c=relaxed/simple;
	bh=S9+eMRLhszSX2eIDRqb3o2/+4HSW4Y0goAcyunVL1Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jzPnC7+ymQqZZatzu0upcOdINHnm4MpD2Az/hx2xIkJMk1RAwViHL/0u/wD5HgKjxkP8NCnqcYbLRgVuP3WIxgVjP4DB5EONDR/dGRvpsPJjZo+fBQQAFHTOI2H3hZNRzQE2uuylaC0XBCWY8jtVIxWZSphsA4ev4tOiqA1fa4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SFA5IzV9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434a1fe2b43so31522925e9.2
        for <ceph-devel@vger.kernel.org>; Sat, 07 Dec 2024 11:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733600128; x=1734204928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C/6mEl+S3SOm8yY9uUzy1dURtoIt3SrJ37jWTgw3F80=;
        b=SFA5IzV9OuMgpcgtmceyIsMiBPLdb9fhxShjYDEC7/vf3EPgihBQU3nZbv81ySeWTs
         k/2YRW3QQrBeY5ZzkMLyYe9LMuoAP6ALMfNdNHvkUcapgQ0ayGJcAhhOcjUR9oQFSP+9
         qiz2CeHEJYs1k9Ehe2k6E97BfTl/LDSrnDiFeq4NB6UCf9u5fC00uCKVhAUkw8yISimb
         570/ZVsAtuIUgg0rxkNPILqjb+vwbHn5gBq7Dx/5bVnijofKHSI6PO+QzXVpE5yasfjj
         jiy1yYErf+jLNO9MIlKY6/SFg4S+brmZsUMhty8okZcQr7JDcVROWOo4Ou9rWljPCSvh
         Ps/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733600128; x=1734204928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C/6mEl+S3SOm8yY9uUzy1dURtoIt3SrJ37jWTgw3F80=;
        b=Cq6En2l0DX5+FSNtE4sSCvrcnVMmfw87DZe5e+D6K1+4oIXIpRf2QTPsxPIRcFBHs/
         p8fX4g5TY3eHSGgrCHcQ8o009IKq1nZCjPGuCuMlrkfypCMCx+RbY+jdI2p+aBv7IKnP
         mJ433aIcHyv6sZp33PZp49sX81mF8GYif1jBbssHSr6irytHhz0RZBblgiHTGvqkVjNK
         ETGTv9ehE+gJBKSIEFYyKDjE2TWERjLIuS/2EdhzcLjVC0lAz029CJgkYAmljRlzIHwJ
         ud5uainkNgo/2bBMzbIei6RGCUW2qTWj/QAbz5vdcg1RUVuIcq8CL00vHVwOXvz3eMmA
         YOTw==
X-Gm-Message-State: AOJu0YzmWbjGKPv3xymOjigoDEDGJS4dNOTG+qpvMQYEWd5PaeCqIGdc
	Zvsfdv8gj5Vpd970IHDLtCVilFcnDihC4BErnMc+TFj9FJdVRTcK4GPetQ==
X-Gm-Gg: ASbGnct76Qo/dqKMczMQfv8S8RceOh/GTlK9t35QolDIDYow8HpBxlrUIk4CwvuMI59
	wYU+1erwQdK2VaRGUDHA7nF6M5TtsBAt0+snkGk1b4soJem3qhnBqDB5gAXYin4YV4c+3qnDaWM
	oxi2WuXV9M2Zdkhd6CQZFP3mbgZLBUo9FauQ/JghTlYaGknJTdhGwGc7A3U9lcFeB7RAkyfkrTX
	r4897WalSb0ldF8cKSaz8uh15SsoPpIVZCT4gNLNTqssPkpTxi2Vz0CrbYJ/28qzlFfKyji61gJ
	tvY2tFqbopEjgdxcog==
X-Google-Smtp-Source: AGHT+IHzTtzdPmeyhw9pHHKZlznixGc1YH41WqCiUnpdtdfBLYNPK2QCQFY+zftjQd1zKoEvQs1itw==
X-Received: by 2002:a5d:588f:0:b0:385:e94d:b152 with SMTP id ffacd0b85a97d-3862b3cf311mr5824105f8f.54.1733600128084;
        Sat, 07 Dec 2024 11:35:28 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-386257de681sm7805432f8f.30.2024.12.07.11.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Dec 2024 11:35:27 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH] ceph: validate snapdirname option length when mounting
Date: Sat,  7 Dec 2024 20:35:10 +0100
Message-ID: <20241207193511.104802-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.46.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It becomes a path component, so it shouldn't exceed NAME_MAX
characters.  This was hardened in commit c152737be22b ("ceph: Use
strscpy() instead of strcpy() in __get_snap_name()"), but no actual
check was put in place.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index cfe21f320f4a..f86fc5fb858a 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -431,6 +431,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
 
 	switch (token) {
 	case Opt_snapdirname:
+		if (strlen(param->string) > NAME_MAX)
+			return invalfc(fc, "snapdirname too long");
 		kfree(fsopt->snapdir_name);
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;
-- 
2.46.1


