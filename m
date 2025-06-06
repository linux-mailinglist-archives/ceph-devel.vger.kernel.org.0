Return-Path: <ceph-devel+bounces-3076-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F18BAD087D
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 21:05:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5FF03ACB66
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Jun 2025 19:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96CE71EA7CC;
	Fri,  6 Jun 2025 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="fzY5FDRs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C541EA7F4
	for <ceph-devel@vger.kernel.org>; Fri,  6 Jun 2025 19:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749236734; cv=none; b=Z4IMfyuV1Vqht1tFEuQIqoF++Y1Qw93fDXJZfl5HV4fj0J0LQ13u1FBUwyw6fD3LkXFaehOK7n5Pw2DQHpxeqUo2wSq0c+m0wWm0JlDk+CBjgxkA6pIOCCDr9JztU1/S9ba8p7bRdl7rPGZYFD5jU3cs1UclbRFy0MsZAnBANc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749236734; c=relaxed/simple;
	bh=FzyvGy2hAPm8tiki8XDkDIM8avH1JeaxwzamlaoNBpk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tW7nuN0EUPX6xYRpC/vYo/u0CB9armEtDFiqZEofeqXmBi4Tr27CCY4+Y1brs1neWG9eHJw3uKirc1QUik/qCAP1szvmJeP7VTWygBL2+qZkvpdI+FP7moe9TWsXR1fdj0OhZ+P6Sv96J+1jxbrMU4+Nu+EvlAyc+bj/HU72+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=fzY5FDRs; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-735b9d558f9so701726a34.2
        for <ceph-devel@vger.kernel.org>; Fri, 06 Jun 2025 12:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1749236731; x=1749841531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=icgXmEtc+ZDI8hjFCRJQZVXjCWbg2Rcppod2hJLd9+4=;
        b=fzY5FDRsAEmFPz/+B8lgb+Zv16GPxd4bEq/ycrmpb7/62sjGqNYgC+yIEbpkW42ayB
         8PDxFIpYcYjbBPPjEj5veKYZ+N+z9iaFBzZjKVkuDdQ+Q2AGZtiiK5y41on7hYQ1JfRA
         jaX4rpinkrKx1xXJsIhKEGYCfHUAGVXw5x7Mv+ssmfHKP3lMRazuhSFxiCb2fxp2bXWr
         iitFIHkNtYvgBQYM5sbYiuX8mlyto+k4tz8ntIpl7Yci+0z9dlHV0hCnbttpFtQSMlu0
         75PvJet50Jl3V81MiWVUVbvC98uuAVYMqLl+8eQa7hIfSjTTsP9gwGoxO7YpDEBDcCZY
         17sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749236731; x=1749841531;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=icgXmEtc+ZDI8hjFCRJQZVXjCWbg2Rcppod2hJLd9+4=;
        b=JFeX8hbgfxZ/E0IQgHeVBaLuN1OA3BWd5ZLNe/3PR8QwLSpeIX6z+NaCq/oJXNUpJQ
         jFvgQRRgUMv4gSpsxN6P/Tpwkid+HKwXnfae7oKOAn/pdCYXYa2lePpG9spSUgnniwFy
         YyLek5bS6CFlgMlMzc+16CnqJnEPNUKVZ6TNiSxz5qJGZwN7Btue9SA+oKrWt5Au1lGD
         9cCXpa6LMBay1Bc6tAUbaK22tuEXM/+gn+POkNKCMk1B1KggoZgJiNfPARW9GuA76+jy
         ZYJ5W5TOPPd2EGH8u5B+Fvh5m/P15ND1qyFv7TcjPpxdmKd2Sv3Mgdcq1bd/tLuN8Vx3
         iEfg==
X-Gm-Message-State: AOJu0YyESIQygON07PS92RCBpWFbXFDXkLGKsHzkEc1oM7f5HMGGGyns
	0xcpokWjgra4F/ErRe+HgsqRMG8U2H1LxGjqFchr3jKWlMX5sFGVogvnWq+5IR9ScS152ge0BJR
	vKQ9fjOI=
X-Gm-Gg: ASbGncu00jz1M/lITKB/9dGuaDXAKFv1pRqboluVhulLipaNu07dnjuancAmPfjp9zl
	zXdo8FxzsuApIhWaS/8xvREhpI4KYfW62m3debpQDo9cKZ15YH0EF5HreyYKFfI0U66lZu7f6pR
	iFsUqUHBIfl2HEFlofHdAK+fpX1pbjcLHDNJguFfTTuGF4DQ57eLLenc4SWY7iKAs9iqxT6JlPp
	w0PA5YgA7UhvS4XBV8UPXG5PGtXQUklTf0RMHTLruyix9+hzEtX8CtqiE1aIGTq6SmZDN3NqQZ8
	tmWrSpQYvzo+rDLRPWLtkDKtL4hkm/JVp+ta6O75z8BqsYySaZ6KcOMTJR++mX/SwRAioAThE5k
	u/O4H
X-Google-Smtp-Source: AGHT+IHk9cym2kIT56CzAKDlIU7Ml6QGRDy1QnHx612oIFzVlPFZO3oCTUJX0/tgFGTK95DSRWzC2Q==
X-Received: by 2002:a05:6870:1996:b0:2c2:4d76:f1ad with SMTP id 586e51a60fabf-2ea009de8ecmr2591637fac.16.1749236731244;
        Fri, 06 Jun 2025 12:05:31 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:fe8a:b218:375c:b2ed])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2ea073406c7sm464999fac.36.2025.06.06.12.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 12:05:29 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: fix wrong sizeof argument issue in register_session()
Date: Fri,  6 Jun 2025 12:05:21 -0700
Message-ID: <20250606190521.438216-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has detected the wrong sizeof
argument in register_session() [1]. The CID 1598909 defect
contains explanation: "The wrong sizeof value is used in
an expression or as argument to a function. The result is
an incorrect value that may cause unexpected program behaviors.
In register_session: The sizeof operator is invoked on
the wrong argument (CWE-569)".

The patch introduces a ptr_size variable that is initialized
by sizeof(struct ceph_mds_session *). And this variable is used
instead of sizeof(void *) in the code.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1598909

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/mds_client.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 230e0c3f341f..5181798643d7 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -979,14 +979,15 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	if (mds >= mdsc->max_sessions) {
 		int newmax = 1 << get_count_order(mds + 1);
 		struct ceph_mds_session **sa;
+		size_t ptr_size = sizeof(struct ceph_mds_session *);
 
 		doutc(cl, "realloc to %d\n", newmax);
-		sa = kcalloc(newmax, sizeof(void *), GFP_NOFS);
+		sa = kcalloc(newmax, ptr_size, GFP_NOFS);
 		if (!sa)
 			goto fail_realloc;
 		if (mdsc->sessions) {
 			memcpy(sa, mdsc->sessions,
-			       mdsc->max_sessions * sizeof(void *));
+			       mdsc->max_sessions * ptr_size);
 			kfree(mdsc->sessions);
 		}
 		mdsc->sessions = sa;
-- 
2.49.0


