Return-Path: <ceph-devel+bounces-2996-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0533DA75070
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Mar 2025 19:34:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B094172AA3
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Mar 2025 18:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C69C1DE883;
	Fri, 28 Mar 2025 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="DxLQ+qLv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F2E54782
	for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 18:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743186889; cv=none; b=AY49BfIv8kYcq2icOYwIPegSZlhuSovbDHphK+bx3pudYdlZXvyEAVrr4aKcL91/BUbT96BmPPiDRH8goctewIkdmQikhHyy/gO2BDUzaalXnGprAhq6OOj2AHa7pqAGJSH7Ym7ZJ/1vClyjIlGh0dG5jJgHX3Pm6tO8bSES8qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743186889; c=relaxed/simple;
	bh=ii63htly/q9V4/8BMJB4oy9YKYqGdINN90vv2SsOPUI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UrGuCLreet8wmSSyMMSO7ww3JxRmsoaqy7AaL0BVAw16Hq0MrPNYxZANAx2LIe0X/vCHH7TCvFR7uJP7kiMH9zKj/ZcoRv/bsgDXdl5TmKuhKmRu3y16WhBOhXLKUZB9Gy5VQXm+iu04JvWALgF0zcU7traWJu3hispQy/++kkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=DxLQ+qLv; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3f9832f798aso1470537b6e.2
        for <ceph-devel@vger.kernel.org>; Fri, 28 Mar 2025 11:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1743186887; x=1743791687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NYyRMrMOXsDFb3xdB7NCVH0/dlLRcKWe9AzQRzj+rDo=;
        b=DxLQ+qLvjf3rCgUClz2FNwX/rgo9R5JqxUBzn7ou8akpZpqZp+LU6G1G8YQXinWXEH
         Kk7YaspaIZtBpFaYoBMns1HWKsiSFTCLNzMmoV5GHx+0QOXaVumeGDdeBxkuSuPcv+C2
         6y0RWkFqMBzGWmet6tjg0tJk96EcQWGZKj+pkGeVdsANSLxw5d+UHp88Rhq9CIMl+RkV
         K9gdV2Dbs4rDGGCS3ORjWnImBo3/Thh3scpe8tLxC4RgK1KoqmQ43srqJOmNBFCDFPRB
         9rHN0t2Z7Opc8MaiTXQ80f6gk3gEBwGivWcdqxlEpDNPCTMOgzFatkHh30uAohBGkx2G
         +d6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743186887; x=1743791687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NYyRMrMOXsDFb3xdB7NCVH0/dlLRcKWe9AzQRzj+rDo=;
        b=ANLFpcInw9iPAaNdcb1M8l7UFPaNlOGZi8cGiJ2GYIeNQzjirt4bPosEk3p1vLCyVl
         SMbxznoM78wnH5X10OrDgTc4rO2oLBCPR4nb2GAQrIDbzwNQcalgrHkVtBbE7SDb1uuc
         CDsw60TZvNFjlkNjbku2dT982PPShSjjLtK2oxikhiVquSUExbmocZ/JM7PfJ7zkJ2a+
         NokAp57DRJI95f7PsnrUrcxmBiAMhiDIqewoNga5DidB+8Il83tlRd2JgZWfJrj2AuI4
         7upROLSMv0vr4pwLdUkRJUSQ15F5BrG/ITTL0Yiz2nShQIzNLBURiO0ds+I7brDRCRfa
         +Y1A==
X-Forwarded-Encrypted: i=1; AJvYcCW/09oo9fw+ZResaaflfRp+J9ua+mUSInovYtjz5DwBWu1r/fw5ka46g5YMbLvPV/98PTuaOQao/Z0P@vger.kernel.org
X-Gm-Message-State: AOJu0YxOe+eo/VkDG9d/RwCbR60nBhIPuWHHDiZ6nCQtuX36UmySh2cN
	OwevxNTQFm0S5MXShJA8jT+868Jkg0Cg1IlDV+omW2/he7NtdD7Z/7VXKQ6tElw=
X-Gm-Gg: ASbGncuO1mW/4OYq7kpIAsG1juKLd5MTUItTK2ouv4GdO8abPBmzf4zwTDBeRKiL3dJ
	tTn+XBdpXy/dI3oXssjluI1xXDCeGAuhtFMfoHbaxcaAzaV1H7ZIM6m6Gk7D0DnjC4xrsJ7YBsq
	LOYHYNIiQpOqXJYCQllXQGLSZUEnZsRnGbYXyDoGRFdXZHSiBkT16+gZuc36Sg5tnE/SIHsQzBO
	BTsW8ShK1LoAO3Lbo/113YVNV763fZJ2Uqab1IDMSlQ+xszPt+sabSwP4Nvb6H1jDigTVQdWV/c
	HasJrfyoRlOOwKCwfqahPf01miJOJS2SLtQnLYHJNDfSwbicjWofATWjHw46a48=
X-Google-Smtp-Source: AGHT+IH9583/DyQXgvjz3hASS2/m9k+G0lUoej2HkZB/z7d04nfto4TCua5uyEYMZku6QzH53/0x1g==
X-Received: by 2002:a05:6808:1782:b0:3f9:aeb6:8621 with SMTP id 5614622812f47-3ff0f4e3fecmr206141b6e.3.1743186886711;
        Fri, 28 Mar 2025 11:34:46 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:a98e:5dd9:196b:ce32])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3ff052944ffsm418040b6e.41.2025.03.28.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 11:34:44 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: dan.carpenter@linaro.org,
	ceph-devel@vger.kernel.org
Cc: dhowells@redhat.com,
	idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] ceph: fix variable dereferenced before check in ceph_umount_begin()
Date: Fri, 28 Mar 2025 11:33:59 -0700
Message-ID: <20250328183359.1101617-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

smatch warnings:
fs/ceph/super.c:1042 ceph_umount_begin() warn: variable dereferenced before check 'fsc' (see line 1041)

vim +/fsc +1042 fs/ceph/super.c

void ceph_umount_begin(struct super_block *sb)
{
	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);

	doutc(fsc->client, "starting forced umount\n");
              ^^^^^^^^^^^
Dereferenced

	if (!fsc)
            ^^^^
Checked too late.

		return;
	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
	__ceph_umount_begin(fsc);
}

This patch moves pointer check before the first
dereference of the pointer.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_r_202503280852.YDB3pxUY-2Dlkp-40intel.com_&d=DwIBAg&c=BSDicqBQBDjDI9RkVyTcHQ&r=q5bIm4AXMzc8NJu1_RGmnQ2fMWKq4Y4RAkElvUgSs00&m=Ud7uNdqBY_Z7LJ_oI4fwdhvxOYt_5Q58tpkMQgDWhV3199_TCnINFU28Esc0BaAH&s=QOKWZ9HKLyd6XCxW-AUoKiFFg9roId6LOM01202zAk0&e=
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f3951253e393..6cbc33c56e0e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1032,9 +1032,11 @@ void ceph_umount_begin(struct super_block *sb)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_fs_client(sb);
 
-	doutc(fsc->client, "starting forced umount\n");
 	if (!fsc)
 		return;
+
+	doutc(fsc->client, "starting forced umount\n");
+
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
 	__ceph_umount_begin(fsc);
 }
-- 
2.48.0


