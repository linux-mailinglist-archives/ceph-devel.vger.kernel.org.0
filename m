Return-Path: <ceph-devel+bounces-3028-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C35EAB742D
	for <lists+ceph-devel@lfdr.de>; Wed, 14 May 2025 20:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 285634C2522
	for <lists+ceph-devel@lfdr.de>; Wed, 14 May 2025 18:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FE9D27F4CA;
	Wed, 14 May 2025 18:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kE05pZ4+"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A127D1ACEDA;
	Wed, 14 May 2025 18:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747246825; cv=none; b=mzYkruE0O4iQeGiRJT81v2a+VXXDz2RX8th0vFAO5XL2qPh6JKZCci+r/J8z1G0ZjEZoRcPE0QgCkz7L5COvcyVcCkUkBXS0SuVO6LKwUuWjUW16JpV2Tp2wwsLTfu4AS8xnXKCSdE2k/hXhoYrIdNHQVEOkVexYq4gnjPWnjEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747246825; c=relaxed/simple;
	bh=LShLumqkihJQzxK2oSUHJJEnrPGHQ9OvLbKc+cZLSzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ae5b0zevEsUQiARnRC5f+Pf06Jvpv8ukz2JwRo+KYNiugSTeDofRyNQPNi9pTUJ4jIGbWgJgBN8alhSMa8SlloJjIJy/vJwahhuNHIiXbmhqzrC7KZUoIHgAwZTBrfavPDnqvfVx5pss9E9BckHbqwc2Q10eet9AWO1HFsCvXyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kE05pZ4+; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-23198fcdeb0so1226425ad.2;
        Wed, 14 May 2025 11:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747246823; x=1747851623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QgkpdbQA01DcUJClm3tXU5YnYdU7zJmZW671sYK0pa4=;
        b=kE05pZ4+kcnDx7WisPilNjoMXufMMNgTjFWSwwZA8gviVvIcXCCQf3d3R153ZQl6zN
         v0n5pKtwSobrdcRjUfOyrgVbzAq5Lo956vW3MMei6RHRihM2sCGlSL2366dym1GBjfOV
         ecB36o3usXfCR9rXVLlKyaD4HlSep9Qr5GJTnLyHOqx0ReWYu7O1TyiwuQdmzB7Y9Zmv
         QRIsfT2oiQuh/C0E++AbuRhf85X+v3oSyxpd0v9UrJfJp3MVGp30vzShGlxtI2s3SKoj
         IkCwbar3r3kg7R79yz2TU2PIi4NqnDAdLuo2iJP1NZDer0e8qg0VgAXzxMxIDIL5m7A7
         Cc/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747246823; x=1747851623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QgkpdbQA01DcUJClm3tXU5YnYdU7zJmZW671sYK0pa4=;
        b=N8IDg83o2Q67noV3IsSOmSuChdgphFxmGQ9pBAJUSmpQebLsFsXaZgtEpw+wc1glXy
         adZP7EqZ5FEfAWLh27ptrsYKwxeT1sr7wAuyp4BpEw5DT7etokERvC50BtuGqSzOU0gq
         PWEMJGmHnGdsLcStYgAjlaUM/EgJN1ayNDKJvnrmXRXFqGe9Jalvv/HDlb7DCmy+nzQ1
         QLxivAIIEsE4DOW7DCMYZJbdKRf6At4QJQcDM1rrIj8jCnoqenqczQmHlg+ZUXf2uLTv
         5mxzbkIo6g4VWfHrRQ+fALgdiuGwrjqmsG7uDU6D+ulhqNJUPTM95L3EHF8RXX0+KVpV
         XOrQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2k10+nK051F65TGwGH7fKr9u3Xkd9LRojKUTou80ZzjXnMdMpVjeRQbV8SaA586d4ZGPzb41q00s5@vger.kernel.org, AJvYcCWMgjkWhZ1XNypPdlTv9hlYsu0c/s35XhiMud1bpmC4y9V1tCe4XjcYQ2nfMnLyEPW333Dcr9HzWTsCA0M=@vger.kernel.org, AJvYcCWNS6F2Mfs2ct26EiRokfh56NMzGvQ78EG8XEpDHbFgU7IOokXktvDUj+GU7wMRNs4sio7GKXEFL+8aHU6x@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2i8UfAIin8KMBuqlp6Dr/9q9Vyx87YcuZDFZgpTZpeec9ZplV
	kKkAY4Mm47cAhUmkAL10YVvE4ziygKQXqeFx5mwRteFxUlJtvEDPuv7oC9lD
X-Gm-Gg: ASbGncv2S8TaqX3H12gCkPuYzIDkqar0LZItbOjGiZNp+2eQVlpwxh8GuGNHvwizq2V
	8RZneZ38SSM8KpZT/q2b42gMiNa3eiWrtSkkh/PyKhpyS5xvHb774oAGao2BhF+KePyCSmGkpDn
	K0PDnlTGLHugZR/u+9MgwnuF/JjKt7toJw0RDqtiEIZ2rO/KTvHRex7sEYnBKIDpypdKtg6bhx9
	gwjKBz59jeLAAGThy8bQ5u/IP37HiIaHp/TKAtZM726lQWZu2I7C0LhnQ5LyYz2WAzxJZ43VyP7
	BekOt3vHWUJ8pyuF1Nss5BfvMx+S6RDuX9BrnKIqY5B+dFOeTgFaXAtaQS2PaTalgsS5Cw==
X-Google-Smtp-Source: AGHT+IFN9UctYMQlaAiLxuxtHAyS1yTR41k3TKQuKvdDE0nUJljmffGv5faKmGgk4C8wB16wzDcS9Q==
X-Received: by 2002:a17:903:234a:b0:224:a74:28cd with SMTP id d9443c01a7336-23198124c72mr53403505ad.31.1747246822676;
        Wed, 14 May 2025 11:20:22 -0700 (PDT)
Received: from sid-Inspiron-15-3525.. ([106.222.228.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc828b422sm101914245ad.186.2025.05.14.11.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 11:20:22 -0700 (PDT)
From: Siddarth Gundu <siddarthsgml@gmail.com>
To: idryomov@gmail.com
Cc: dongsheng.yang@easystack.cn,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Siddarth Gundu <siddarthsgml@gmail.com>
Subject: [PATCH] rbd: replace strcpy() with strscpy()
Date: Wed, 14 May 2025 23:50:15 +0530
Message-ID: <20250514182015.163117-1-siddarthsgml@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strcpy() is deprecated; use strscpy() instead.

Both the destination and source buffer are of fixed length
so strscpy with 2-arguments is used.

Link: https://github.com/KSPP/linux/issues/88
Signed-off-by: Siddarth Gundu <siddarthsgml@gmail.com>
---
 drivers/block/rbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index faafd7ff43d6..92b38972db1c 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -39,6 +39,7 @@
 
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/string.h>
 #include <linux/module.h>
 #include <linux/blk-mq.h>
 #include <linux/fs.h>
@@ -3654,7 +3655,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
 	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
 
 	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
-	strcpy(rbd_dev->lock_cookie, cookie);
+	strscpy(rbd_dev->lock_cookie, cookie);
 	rbd_set_owner_cid(rbd_dev, &cid);
 	queue_work(rbd_dev->task_wq, &rbd_dev->acquired_lock_work);
 }
-- 
2.43.0


