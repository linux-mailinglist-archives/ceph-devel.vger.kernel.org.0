Return-Path: <ceph-devel+bounces-4166-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFDECAB826
	for <lists+ceph-devel@lfdr.de>; Sun, 07 Dec 2025 18:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3938B300B932
	for <lists+ceph-devel@lfdr.de>; Sun,  7 Dec 2025 17:07:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49461277007;
	Sun,  7 Dec 2025 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="diLIA0JZ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D9F2AD2B
	for <ceph-devel@vger.kernel.org>; Sun,  7 Dec 2025 17:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765127274; cv=none; b=TdsP/+nm/O07TeFXqrFV+pa/cU4eZWo/lmuvmnsTdH4Ua0UihUXGbvFLrqxSkkZXOwxeXGnKvxgi1xVnQMWUmFdOOGOu35n9H7YP9Er/Z+t4a0S1CdJNlrJVdiVtqZxGZE1hwPqGmH7hYD4tk5cef2z6BSgxYVU9OqKWmHeWCgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765127274; c=relaxed/simple;
	bh=W6618hwRlV0oIHS4kEO9H2fCUujYuG8wj7M9jXXcDHg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MW2zZ7aj5Q5VqlddC6wxj62hIqh506PL60TmNogaTq50dXEt8TGGs+dHZUOzvWSMeSPzqndMAFTv+hH50QeJSR5qaPXP3eLz6yriAwGF/4vJsibSWrIwilx+uLuNLs5unhAzcmUpSYVX0OqgTXaQnRJfKu6bFeR8Up0l/V5do2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=diLIA0JZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640c6577120so5850996a12.1
        for <ceph-devel@vger.kernel.org>; Sun, 07 Dec 2025 09:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765127269; x=1765732069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JRbQyXkhtYelBntjwwYgW2DnVjXNNgrMbw0oxlz8gRY=;
        b=diLIA0JZpkOFyTgaKazRXYoI9DrVbHkka3kbY0i0kYrNb7kv2Cxh/jhHA7WCkvbfYh
         qieKATGin9eqv2wW3I0ZoJb8lpVhp4VKgH1IBSS/RDG3b7jEiLMyhJtsZK7Ekp9NjmoS
         myIMaIsrqkiLg6ORrcBvJVTWZpt76rybjB2r2T8P+r1FX8qadYU/9nMBM7un7dPLJF+M
         P286J0BxbznqJjfurhXZ7jqOQX8nAS2/jMdcISlXkF9RNWDaXE/puKVVMVNUZ+9kVzhX
         S98CXPrYul+N+xowFtesRg+SzJY2GkBYuIbcBoa0KOT5HjWf1MoeL5OGpH6OPyIcpv/h
         L2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765127269; x=1765732069;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRbQyXkhtYelBntjwwYgW2DnVjXNNgrMbw0oxlz8gRY=;
        b=e3VO/xTDTe3fUkJwVw2zq000Gm4ecBeZzKGPn+OhnEbZVNRdir9CxK2xc1IYkdKypq
         GWodwCcYIVQZnw6BSHkKYDd7lCizhS97YBL2PwQpxOskXNkN7u1SM9eDbpSmPIy1s9Sz
         nJyNeAu/4g4eiPWxTAngqBftaUKIgAu+h6hUKSKZKZ/CjjuqDYOQPdDEfMSAFs9cqcL3
         oWa6Qi1KRlMcnyNeS3YztXOUytW5J1jGY+qQzi+adwV86YmB/VNG9bwl28ySF/lX3rTs
         cbioZbjwZjjmhTn4Xks6UJxmuAAMM0F/S0hbyKlIlNB6k5HfvXoWbKNsp4/k8vLoDnFF
         biTg==
X-Gm-Message-State: AOJu0YxDFFzUAzSbyeSnlR2ITxwjscnYIiJWITq9R4TX0RQmbQc08m45
	66+jOp8S07ReSwT4UcSmqS94u6naQjH+JI3NEuMri33Xsa5k6vrFyVjZHado3g==
X-Gm-Gg: ASbGncvWFCxHG5ajji6nXluucjppVOJd2ty5DSbqNgqyDeYamCVXB4g0+5Oo8STL31V
	2m3NoP8WFSNgdg6AMZh4X81LCI2gSFL5uxRp/lyMx/i36SbiFgtLR3l746vprcy9O/emCpiLBVG
	GGpWvBMrYy1is4UzqLl4a6woAlXxOS+qiojN1JhQz0yC9kIM6CpxQfHm/vJX5reLZA1o0AvjUaw
	FydjtuLl0TFgjFoswosW9PKM0qfjz5h0MV4RDpWdWEMZvp3z2lmdpqzfqpBlDTLpthi9fWmBKwr
	mYLxQ4gqrehj2uqs2An5eR+u6B1ZRmRxcWUrEC7Gw/imU753nTc2ai0jPuTvGW3Sihc2bCcnKmQ
	MGWrszz8S3uIagu8vGt2N06D5RMGsSRHXEUMU5PivCSeTLGZBch0tCrBahlBlg7u5wgzPleqXY8
	BJcv9G7RBWqNnbXATNyrollg0TyZhUIKBJnurdBcmvtWK+6hzKSPCyUw==
X-Google-Smtp-Source: AGHT+IELIQ+kGUpv/vsiEfbQk5xMCsIoper+nA5zBfurJATeyCRV7Lbu1yQlTO2kjpVjDj3/e3RsCA==
X-Received: by 2002:a17:907:7e85:b0:b70:be84:5186 with SMTP id a640c23a62f3a-b7a2479da6cmr545913266b.44.1765127268546;
        Sun, 07 Dec 2025 09:07:48 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f44597e6sm890409866b.12.2025.12.07.09.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 09:07:47 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH] rbd: stop selecting CRC32, CRYPTO, and CRYPTO_AES
Date: Sun,  7 Dec 2025 18:07:29 +0100
Message-ID: <20251207170730.3055857-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

None of the RBD code directly requires CRC32, CRYPTO, or CRYPTO_AES.
These options are needed by CEPH_LIB code and they are selected there
directly.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 drivers/block/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 77d694448990..858320b6ebb7 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -316,9 +316,6 @@ config BLK_DEV_RBD
 	tristate "Rados block device (RBD)"
 	depends on INET && BLOCK
 	select CEPH_LIB
-	select CRC32
-	select CRYPTO_AES
-	select CRYPTO
 	help
 	  Say Y here if you want include the Rados block device, which stripes
 	  a block device over objects stored in the Ceph distributed object
-- 
2.49.0


