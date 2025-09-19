Return-Path: <ceph-devel+bounces-3683-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61830B87D05
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Sep 2025 05:30:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40F0558154D
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Sep 2025 03:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D60923A98D;
	Fri, 19 Sep 2025 03:30:29 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [111.22.67.135])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA1626B0AE;
	Fri, 19 Sep 2025 03:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.22.67.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758252629; cv=none; b=b3Lvv8OAcLAdbP7nYoHaGoQ5lM/dsQDIAC3ewsFGWnPyMJnUrxrYrjmzfvgFP/af9UQn+dI3zIejElqOkgrHD/om/IrphC/S87ALoo9AnFt2s6BoVBuLLi61d+Is8oeX/uz+z9YXoRXUFdOn43gj+uohsGzw8FqUEMfIMtadpqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758252629; c=relaxed/simple;
	bh=ZS5Ns/hrI4Zq127OgXmQHHOyaTk4eyHQnoUF3TgClKc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iygWnVi0WYyExar+3cIIeGFY9nVVVARKR3BiEdThX8mDEsvxn4gCG/DGOtbbm3Z7w3qMx+7yC+tNNTXAygu1JtW80uNQO12MMTdBQ4taMqP8sAgmIRy0pYPTM7JE9vd7Ds1h1BZ0AaSl28IAnR0pwI1Rmvo6jZE5K+PVPhWl5Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com; spf=pass smtp.mailfrom=cmss.chinamobile.com; arc=none smtp.client-ip=111.22.67.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee768cccd93771-1182f;
	Fri, 19 Sep 2025 11:27:15 +0800 (CST)
X-RM-TRANSID:2ee768cccd93771-1182f
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from localhost.localdomain (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee968cccd919d8-13bf4;
	Fri, 19 Sep 2025 11:27:15 +0800 (CST)
X-RM-TRANSID:2ee968cccd919d8-13bf4
From: liujing <liujing@cmss.chinamobile.com>
To: idryomov@gmail.com
Cc: xiubli@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] ceph: Fix the wrong format specifier
Date: Fri, 19 Sep 2025 11:27:13 +0800
Message-Id: <20250919032713.6534-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

in the ceph_common.c file, to strictly comply with the requirements
of the %x format specifier and avoid type mismatch and overflow
issues, d should be defined as an unsigned int type.

Signed-off-by: liujing <liujing@cmss.chinamobile.com>
---
 net/ceph/ceph_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 4c6441536d55..d3c19a63cadd 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -195,7 +195,7 @@ int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
 	int i = 0;
 	char tmp[3];
 	int err = -EINVAL;
-	int d;
+	unsigned int d;
 
 	dout("%s '%s'\n", __func__, str);
 	tmp[2] = 0;
-- 
2.27.0




