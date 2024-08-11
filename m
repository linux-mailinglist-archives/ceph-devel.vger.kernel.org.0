Return-Path: <ceph-devel+bounces-1648-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C64994E2C4
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 21:37:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0EFA1C20C6C
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Aug 2024 19:37:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7806D158526;
	Sun, 11 Aug 2024 19:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lrYOPBjq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EA91F945;
	Sun, 11 Aug 2024 19:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723405046; cv=none; b=E8zTlzShB+DGbrTzOQNqpPkyE4U6t3leGPf74oPyFPZ4uJkcQKAiEjcfdd1bbttm6g2+mJHfUra/eVbspi/nsrIVbv5wyw+7TZgrShOQItG4k90BduwfyhEKwwzJbOPDKixvUWjnaQ38eHAxGS8KnnVrGyLrgnXNcPNQGyJwioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723405046; c=relaxed/simple;
	bh=ikmiCCPOlqRkEb6DUx1eUYL3/MPw3G/PtfYjQ9vhX8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KNtDRd4rzowo9mixQqp/qT/ahpiUOChuGz9nT5VxPqImrAFLKLGylQtuTrHUmLl4hIioPEHP0y+8IVH30Rc+SeERSnu9NeNtLlmCNSI8YkGMA5WSntz5XAx6Iwkz6JLhjVcgZ5L+5FzEoel4yIwXxNL/8EMJFHo1tfj66H4cLvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lrYOPBjq; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-70d2b921cd1so3455614b3a.1;
        Sun, 11 Aug 2024 12:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723405043; x=1724009843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FT4xeysPtgZnEED7ZNSpLO1Roz20Xrz/qSgj/gG8LH4=;
        b=lrYOPBjqvCjAMxCn5IZ+8gHsfm9niYnWyB4CORocjJiU5Nu+GtzW3PFFvFe6WFcpVZ
         oVNkt0XeElHdIJ9eLDuMEHi0trw9MDWvB/WWf9w4fN+c9DdiW4MpS6uud9DpyQS2Kp+g
         A8YI4VBBWy0aZV8VmhZo2dBoy/dD89IsdtS0bSXzd+G47j/U1gs8tFkcwO9TTX2udiAL
         oVgtVeilC8jbLh+NGYJgOlqnbCIn3qjhU4gP0sPbiJDADpMN6E4toO0IVVtnX57lGx2v
         9NZoMG+Mvgan7wRC0+Sx0AvdJBH70QnszuDNPAMgfb5e6NyAWTv7ty8q/MBR1U+m4lHI
         lbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723405043; x=1724009843;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FT4xeysPtgZnEED7ZNSpLO1Roz20Xrz/qSgj/gG8LH4=;
        b=OsElUovaqwAikmC2quqEuzavHqaDuZbAz0xSos3E6PI1q6pvTocJi92FlYa7ZGNfrL
         m4p8y7jZnhbS7JxLL5eOnNLn1beadRsq6sHR2lGHs1xTh/UnNTRzUqwUdyqGWbaNgAU8
         UiwDHLD4eeJbEaDKg8ItvW+DLWQ993HbX6gCyBEgKMiz/VLiWuymHycH/DrkKvZgqLzC
         wFpe2/RDgs7PH6/RDYNXRQItCmmXESocWVyDhIj7lhC1CxNpCkJGGrAOps6c2D+dZNwU
         rhRg8xrqcZpu6nyBvS8nHkxHyykjMg7vyj4XvF5M3m67+IWGwLURlwJfNbddTT0+R8dK
         vGkQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8hIFT9KrWS+u4uRvpyX2o3tHkoNkp0unAFjBitdzMs5SHBfGFfrImPCbOlbfIw1uxQ1rL3xXasMRCTCioonW09K68NAkSuSwph8c3XmqMo6ui/ohrSEis6YTfGAcrGX7nm5nqr3R4bOFjIQqF8fT9orsq09oDnAsH1eYUTgqgyA==
X-Gm-Message-State: AOJu0YyUPlP4tVMrYZkI3vxoG21rWETCGx/qt/xKJkLN9hraHvfbysnu
	dPMO9s+BRydIWhSCvO+UQWnK+ANjj1KOoLYA4xZ44hLRx/Xrlxhp
X-Google-Smtp-Source: AGHT+IH6q7CgRJyf1EjyGEzPBy1TOPudwIDMCx/3t0n1OAzxptirUSj6B0BDWeUKJD5hWul1RvfnKA==
X-Received: by 2002:a05:6a21:3a45:b0:1be:c6a5:5e74 with SMTP id adf61e73a8af0-1c89ff22057mr11146417637.21.1723405043063;
        Sun, 11 Aug 2024 12:37:23 -0700 (PDT)
Received: from dev0.. ([2405:201:6803:30b3:6c2e:a6d:389a:e911])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e5872b1csm2689564b3a.40.2024.08.11.12.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Aug 2024 12:37:22 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: idryomov@gmail.com,
	xiubli@redhat.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ceph-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: skhan@linuxfoundation.org,
	javier.carrasco.cruz@gmail.com,
	Abhinav Jain <jain.abhinav177@gmail.com>
Subject: [PATCH net] libceph: Make the input const as per the TODO
Date: Mon, 12 Aug 2024 01:06:45 +0530
Message-Id: <20240811193645.1082042-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify arguments to const in ceph_crypto_key_decode().
Modify ceph_key_preparse() in accordance with the changes.

Signed-off-by: Abhinav Jain <jain.abhinav177@gmail.com>
---
 net/ceph/crypto.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 051d22c0e4ad..cfd485d6d3c5 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -86,7 +86,7 @@ int ceph_crypto_key_encode(struct ceph_crypto_key *key, void **p, void *end)
 	return 0;
 }
 
-int ceph_crypto_key_decode(struct ceph_crypto_key *key, void **p, void *end)
+int ceph_crypto_key_decode(struct ceph_crypto_key *key, const void **p, const void *end)
 {
 	int ret;
 
@@ -300,7 +300,7 @@ static int ceph_key_preparse(struct key_preparsed_payload *prep)
 	struct ceph_crypto_key *ckey;
 	size_t datalen = prep->datalen;
 	int ret;
-	void *p;
+	const void *p;
 
 	ret = -EINVAL;
 	if (datalen <= 0 || datalen > 32767 || !prep->data)
@@ -311,9 +311,8 @@ static int ceph_key_preparse(struct key_preparsed_payload *prep)
 	if (!ckey)
 		goto err;
 
-	/* TODO ceph_crypto_key_decode should really take const input */
-	p = (void *)prep->data;
-	ret = ceph_crypto_key_decode(ckey, &p, (char*)prep->data+datalen);
+	p = prep->data;
+	ret = ceph_crypto_key_decode(ckey, &p, (const char *)prep->data + datalen);
 	if (ret < 0)
 		goto err_ckey;
 
-- 
2.34.1


