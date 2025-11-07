Return-Path: <ceph-devel+bounces-3935-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2D1C41845
	for <lists+ceph-devel@lfdr.de>; Fri, 07 Nov 2025 21:08:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7F80423335
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Nov 2025 20:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B14145B3E;
	Fri,  7 Nov 2025 20:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="BtbOeCW2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3693009F1
	for <ceph-devel@vger.kernel.org>; Fri,  7 Nov 2025 20:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762546053; cv=none; b=QG2KsptEB4h/N1iLxCiVwXGGBQE8G/vx/OlptktTpuZOMXfQkDMDOVjVhNusIP+wEySpjNONYuIILn8EJvPi0JVAHZqaQeI3eTZkqKXV9K88RlObsuMe7EFXJiny0hyQdWjW3lNqQD0NwV3UHtJMOFdtcTzNRnDMb19X6tfZcZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762546053; c=relaxed/simple;
	bh=WyVUg8UWkOlYJXwXY4s4aZIMRjRD8qqYW7rXJvYcyPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nZnvd/WBUUGrrheJ7Uef3tfUf06o1R8FbZsaxPVQndHRrb6s3I+b/HQ8X30nSn0g5uag+DGVXk6qkKm52SpCLW4DrDz+JEsUTIt8NAgPux0NHZnjgJtF7iSY+aNP0+AQdZ3oCFeEcVODjkRKV8GWeeiLcSIm33o3sXTREhYSMNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=BtbOeCW2; arc=none smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-640c857ce02so996040d50.0
        for <ceph-devel@vger.kernel.org>; Fri, 07 Nov 2025 12:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1762546050; x=1763150850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RZ5ePrd19R7AhMgI5WUbe4Jd+HZjDylEvcfdHto9OPQ=;
        b=BtbOeCW2fv+eVyCFK6xJHltc60PUby+kSbswIk97Z2yhgvM68R5Yf9BfJO1iCx2W/6
         8XlC4Dt9GpLbiY4QnnDPoHJA717yq8+l+zj0lPJB2x/yNCs0lxUjV+1sJUPS9+zmAZrj
         qiSw3MnvWS0NNCGAp/yQs/1MyxfYEb++6Y+OLG/IIl2iAXatR6LlWkmezSTQO0DbH377
         VzPHz/FnR5YTYA9lTK7cUABl8uqn/gB5whDyiwtgmvw2JW4H5XvDJMtzK8dltHZV/n4X
         1td2bM8wwzjSTCVrHUbvjkfVMwTOdf3X+KtdR8lSQ53f+0ixFKKqHz//D9BcxPL73NLt
         h8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762546050; x=1763150850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZ5ePrd19R7AhMgI5WUbe4Jd+HZjDylEvcfdHto9OPQ=;
        b=BA4J1GGA/greV3U4CslbaeL6uOPezqW/ZEaOpeSXeRDtgcZ/ypIgGNm428Gpc5xC9j
         cvQkhCRsiDNA6LNSmT2OIfbyGI/iPRIn5ZiboBvIQwKwQ6kpv5GTa7Y17ILiyvU8L9ee
         4PgIyTGLO24dguoEvcrCxfeQL9r/hlQ+8SqUnfadxxRv4lbHUK4Qd0ClAhC1lo3fF8cw
         dI64Ykw8KUZTedy7f4Cpc0IxuUhFFJtrwfPX7Ci0GSsLJgnnopMY623t5eXatDQdvSJ3
         GJRvdgA439vayk9GJ//FEG/+FimZfGnIuJIlt199wIlJ69ujQJfxr32bFN41ohS21OWJ
         8+Yg==
X-Gm-Message-State: AOJu0Ywu1q00Spc5L1r2QWDgjBkS/D9yq4QI9ze9BucE7uitOJmqqATP
	dwpyjklx/wnuFdac3AEsTJEGq54baS/JTsZKD2bgIIyk9FvahtH1fGfmhjuaVWUlkPHiSQrUbow
	rE6q21jE=
X-Gm-Gg: ASbGncvb7jcnIfbVplAKj4JLW05floPM5CFj06xCVih81szt+JOVvEHRpz4g4yGkUuJ
	jBU3JUkWZi7aV19CW5SYomSQ0Q9uovcPOfpvq9tE/kwNDC8+3b7sE1PUi72Pc8Pbsfz1GaV7tOP
	nDaf4CTZoPtlL935SFqjSgUVqQ6mIZ2py1z1iazBTpC0WE4oAx7AO7ydEaXQ9PPXoyTDqCwyDEP
	U2U/BqjeJ22APC12egBGqaFRDQ5QPk7n3erBcGLfGEcbI6bki8yG0RNYiiop3WqvahJSTDiPHKO
	6AJ85XXUltZF+TkHfjqFfG1wMgpU0eytHytwBmUB/ZkppvRImAh1qywRbtApPeZRCnw+7jIvfz7
	Uq3dsamcwayxovwLAy8LQkJx1HfuFV00T7vU/Z+zojwxifnK8aAq8mcsGade/kubbwjZz0umuR/
	xRZh5E/9Hthvx6psK26sk+s7dAtyKb
X-Google-Smtp-Source: AGHT+IF4Gy8sW+9Ws05psGkXClvUciPh1od+10rtoaTgtJd6D1d6vA5O/m2a1qHh7XwIGg9IlIiS4Q==
X-Received: by 2002:a53:e318:0:b0:63f:baef:c5b with SMTP id 956f58d0204a3-640d45cd2dfmr236483d50.44.1762546050193;
        Fri, 07 Nov 2025 12:07:30 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:672:286b:fcb7:eee4])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-640c7e846f8sm824617d50.14.2025.11.07.12.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 12:07:29 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com,
	Pavan.Rallabhandi@ibm.com
Subject: [PATCH] ceph: minor cleanup in ceph_fscrypt_decrypt_extents()
Date: Fri,  7 Nov 2025 12:07:18 -0800
Message-ID: <20251107200717.399869-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has reported a potential issue
in ceph_fscrypt_decrypt_extents() method [1]. The function
ceph_fscrypt_decrypt_page() can return the negative value as
an error code. Logic of ceph_fscrypt_decrypt_extents()
process this case in correct way. However, it makes sense
to make the minor cleanup of the function logic.

This patch adds several unlikely macros to conditions checks
and it reworks fret variable check by adding else statement
to the condition check.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1662519

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 fs/ceph/crypto.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 7026e794813c..f23c1a6a99a0 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -570,7 +570,7 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 	u32 xlen;
 
 	/* Nothing to do for empty array */
-	if (ext_cnt == 0) {
+	if (unlikely(ext_cnt == 0)) {
 		doutc(cl, "%p %llx.%llx empty array, ret 0\n", inode,
 		      ceph_vinop(inode));
 		return 0;
@@ -585,7 +585,7 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 		int pgidx = pgsoff >> PAGE_SHIFT;
 		int fret;
 
-		if ((ext->off | ext->len) & ~CEPH_FSCRYPT_BLOCK_MASK) {
+		if (unlikely((ext->off | ext->len) & ~CEPH_FSCRYPT_BLOCK_MASK)) {
 			pr_warn_client(cl,
 				"%p %llx.%llx bad encrypted sparse extent "
 				"idx %d off %llx len %llx\n",
@@ -597,12 +597,12 @@ int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page,
 						 off + pgsoff, ext->len);
 		doutc(cl, "%p %llx.%llx [%d] 0x%llx~0x%llx fret %d\n", inode,
 		      ceph_vinop(inode), i, ext->off, ext->len, fret);
-		if (fret < 0) {
+		if (unlikely(fret < 0)) {
 			if (ret == 0)
 				ret = fret;
 			break;
-		}
-		ret = pgsoff + fret;
+		} else
+			ret = pgsoff + fret;
 	}
 	doutc(cl, "ret %d\n", ret);
 	return ret;
-- 
2.51.1


