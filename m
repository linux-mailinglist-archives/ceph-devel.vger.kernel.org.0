Return-Path: <ceph-devel+bounces-3091-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BDABAD427A
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Jun 2025 21:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80F783A5363
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Jun 2025 19:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5DA2620FA;
	Tue, 10 Jun 2025 19:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="uJrmVteX"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7125FA03
	for <ceph-devel@vger.kernel.org>; Tue, 10 Jun 2025 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582350; cv=none; b=L717gr73QXDXoUVOfvtSUdRQeFFuJeKQBCNN/UP7qj+wi0Seh1Lgy7447IAHjZhwhXeHn+QywJUCIHfD/clQzCcov6Ap2sl7MSOkvFXN8427C6IZdtfT4M1cR6BmXGBS37LLMi/IgBZiAitVJdCWBJ14iCwP/qE71L6QSRjqFoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582350; c=relaxed/simple;
	bh=Tg699knSwAu7/S2bRyHGf0H8ipYDR18FoTJSAJIzyMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FCv72v75WoOFIjAWFEu9sFwG8PQg963mgT56rDcpFRWoRC71Db23CQM27XWFmvESXMYjzTMIiH0BFGOMpnFvJrU+0mSuAaFk4eJxvz52PTsxZRcFPW7RmZglR3wfsSzEX0dqsaDkGasYezBhk+BwmYEIpZ9Uvnzv7tw2djs9UH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=uJrmVteX; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4091180d3e5so1786745b6e.0
        for <ceph-devel@vger.kernel.org>; Tue, 10 Jun 2025 12:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1749582348; x=1750187148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FSaz2XVQb6c3ZnRbvHxNR/Gxmxkpkd2WgMTi88UzzMM=;
        b=uJrmVteXrHOyfVDVgePrGN6yaMfo2HxVJcNCxVBCdlXaO4Iv8lODuovi+QFvll+XiL
         EQcEqWRnT+54M5DYTSW2/fDdoQaw05sxX229ddz0HYm3RIsuTdVImA9YiOondFssvbOr
         KoO8fSC7IhOo4QP7LhQ4KN2JBNpVBp5RI1fS758XuWkBoyLjH4zLGIhp7m7As5Hyx51B
         EIsPFlxqcmk7ujO+9nZQlJ24EsRZIacqTc08VcsSX56YXhzrea2CsOIfLMxshllArZdl
         05atifapnn4N2YCb+Zilf5Tk/xpjRsXCyJ0R3BL+s64SwizjsODTc0llfMIdWo1xI8vX
         bZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749582348; x=1750187148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FSaz2XVQb6c3ZnRbvHxNR/Gxmxkpkd2WgMTi88UzzMM=;
        b=pXTSFYm4osxVv6WGZ/c8+ZOP1WdnvhMt/hGC4N+rwvDN1SgghtLrZYZHX1ByRkPM7z
         q0OQ1WUPrQQB0IVZeJwHJUlCbcLImrQwnhXa3tcSt5gjaVCnNwXk5tdmb3W9CCPdl5oj
         vWSFkNksYjdU97XzewqM8U2PmDNOP3bUCqFe9bp230y1S3czKjFeJHh1VIQGyCUajInl
         d6Fkqt+dlFzGoBAW/1Bx7KqsKKE5iKX0RI9YtWfTwCnpg4Ak2Pjtrmb8Zx8QUW58V1MF
         GGIYR1DsOj1d0tf2cD//FwVvmIw2BL4AaKORNIXGwS4dsBUB9yqWvRKnsVGBRqkvcRYp
         s+Cw==
X-Gm-Message-State: AOJu0YwTaZXrAZGRW1o+6U/5WkInMiH6rkGcbTeC5NfejbJjr4+FWxJm
	ddZfw5Q3AjgB0mMQen4NTR+ODkb2SbFsaJdt7bJ6fepK/9F2Sw0qxVJTyXtjOoNsWiIWCFRtS0g
	r/tCY
X-Gm-Gg: ASbGncsFAgNN76n99Bo+jKMRLM6x6axJ1BGt1cVuMlXaLlRxFvloBG2QIsQ47oOOw3A
	lOs4CUuIg0yZ+97IqjZ2uW6XQiLCUYf7v75a47RaUrLr48sJNEsw7+UhYtqi0RNx+J/q8d9Rz6J
	kAXd7Ge9m2PTCGLsmkL0rynuKVdNuUibrsE9BPww1pv2GoKNrG97WW/u6+mTwhIkBeV1KQG4MuY
	UKdUZ3qsHa3rtJyInSuR0kgKDLWz0+6HxefoU3HcVLgzv5w3gN0r80K5tew2yQwdI2LR0GoK3tR
	ApcyT8W+skQ6GvWGrlAkb86GuvES1ElOwB+kFfREDOMZel4avbGkUk6O7YPiuSQFOvRlWVcrW7m
	/Sp1Iz4HkOMWLwuwbgNdoGzlAHEfqdRB3ABIRVdZy4btkncev08L6ug==
X-Google-Smtp-Source: AGHT+IE4RCwrwROQPI9KAHBsZxY8PBwtUrCyxVC2tiwe/+NWIB5GTbtZv/R7pqnA/19vQn+Tf5HjkA==
X-Received: by 2002:a05:6808:1806:b0:408:ed52:c62f with SMTP id 5614622812f47-40a5d0553a5mr391077b6e.2.1749582347461;
        Tue, 10 Jun 2025 12:05:47 -0700 (PDT)
Received: from system76-pc.attlocal.net (162-197-212-70.lightspeed.sntcca.sbcglobal.net. [162.197.212.70])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40a5d95e89csm16503b6e.38.2025.06.10.12.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 12:05:46 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: fix potential race condition of i_cap_delay_list access
Date: Tue, 10 Jun 2025 12:05:29 -0700
Message-ID: <20250610190529.516586-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has detected potential
race condition of i_cap_delay_list access [1].
The CID 1596363 contains explanation: "Accessing
ci->i_cap_delay_list without holding lock
ceph_mds_client.cap_delay_lock. Elsewhere,
ceph_inode_info.i_cap_delay_list is written to with
ceph_mds_client.cap_delay_lock held 9 out of 9 times.
The value of the shared data will be determined
by the interleaving of thread execution. In ceph_check_caps:
Thread shared data is accessed without holding an appropriate
lock, possibly causing a race condition (CWE-366)".

The patch reworks __cap_delay_cancel() logic by means
moving list_empty(&ci->i_cap_delay_list) under
mdsc->cap_delay_lock protection. Patch introduces
is_cap_delay_list_empty_safe() function that checks
the emptiness of i_cap_delay_list under
mdsc->cap_delay_lock protection. This function is used
in ceph_check_caps() and __ceph_touch_fmode() methods
to resolve the race condition issue.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1596363

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
---
 fs/ceph/caps.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a8d8b56cf9d2..eceee464ec50 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -566,13 +566,26 @@ static void __cap_delay_cancel(struct ceph_mds_client *mdsc,
 	struct inode *inode = &ci->netfs.inode;
 
 	doutc(mdsc->fsc->client, "%p %llx.%llx\n", inode, ceph_vinop(inode));
-	if (list_empty(&ci->i_cap_delay_list))
-		return;
+
 	spin_lock(&mdsc->cap_delay_lock);
-	list_del_init(&ci->i_cap_delay_list);
+	if (!list_empty(&ci->i_cap_delay_list)) {
+		list_del_init(&ci->i_cap_delay_list);
+	}
 	spin_unlock(&mdsc->cap_delay_lock);
 }
 
+static inline bool is_cap_delay_list_empty_safe(struct ceph_mds_client *mdsc,
+						struct ceph_inode_info *ci)
+{
+	bool is_empty;
+
+	spin_lock(&mdsc->cap_delay_lock);
+	is_empty = list_empty(&ci->i_cap_delay_list);
+	spin_unlock(&mdsc->cap_delay_lock);
+
+	return is_empty;
+}
+
 /* Common issue checks for add_cap, handle_cap_grant. */
 static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 			      unsigned issued)
@@ -2260,7 +2273,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 
 	/* periodically re-calculate caps wanted by open files */
 	if (__ceph_is_any_real_caps(ci) &&
-	    list_empty(&ci->i_cap_delay_list) &&
+	    is_cap_delay_list_empty_safe(mdsc, ci) &&
 	    (file_wanted & ~CEPH_CAP_PIN) &&
 	    !(used & (CEPH_CAP_FILE_RD | CEPH_CAP_ANY_FILE_WR))) {
 		__cap_delay_requeue(mdsc, ci);
@@ -4720,7 +4733,7 @@ void __ceph_touch_fmode(struct ceph_inode_info *ci,
 	/* queue periodic check */
 	if (fmode &&
 	    __ceph_is_any_real_caps(ci) &&
-	    list_empty(&ci->i_cap_delay_list))
+	    is_cap_delay_list_empty_safe(mdsc, ci))
 		__cap_delay_requeue(mdsc, ci);
 }
 
-- 
2.49.0


