Return-Path: <ceph-devel+bounces-4185-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 73AC1CC50EA
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 21:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AB66C303EF6B
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 20:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18E832F751;
	Tue, 16 Dec 2025 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="YD4REUXR"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yx1-f66.google.com (mail-yx1-f66.google.com [74.125.224.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E5A3002DC
	for <ceph-devel@vger.kernel.org>; Tue, 16 Dec 2025 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765915222; cv=none; b=ad0BmbaIYQnEY6rjLivNHfmGW7K2h03hxnWJRDko71UwdLyFcazt8qXnIjSAxb/XzFxdzH3zmZOwfqOAEKzXefmWiIX66wf2lhYrM4rtvn9dFosaaHYsEniZycEvWBZrEYTSvDNhotZ82eVlK1C2jPMeZWiwWZM1HM4zNNvz1pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765915222; c=relaxed/simple;
	bh=W9myzMlDVTfDdzd2dxRqugETmI9Y3kZ4dF3KewVdvTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oY+niGMfiMMJj4jLE+9H18E9UUJ/aDrCiAyCAa7i4SbnNyCxFzm3YcN/iNEakyZIEjzxpVVvnd7lkHgJ3VgEASpFpY+ads4NG91YklevSL55Yp4LpxR2mpDlZ7AQO9cILxHXoKIeE7SVy6PeJ7sEDZxww2aGw4p+grWxrotZvwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=YD4REUXR; arc=none smtp.client-ip=74.125.224.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yx1-f66.google.com with SMTP id 956f58d0204a3-6447213ea47so5442521d50.3
        for <ceph-devel@vger.kernel.org>; Tue, 16 Dec 2025 12:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1765915219; x=1766520019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ce5/Jr+wXPPAgYBiuheNMGHCY0MttENpNDX20Yhq0K4=;
        b=YD4REUXRUHGvS+huWIEc/0By59SEsOz7NPuFVFelPHCkReK1Y96iqAeWPRqWjsXRLF
         5AyJeUh5MFtJ4dQ+8J/Ng4Zpx4fM7oFKsc9x5EVYxQSV5isdjAEJ+XKH86txNI/uTOjc
         NfZD9Xq56P+0+IDR2Ez4H6lPxqeSNkt6kV20Yc2a+O7RVxYPm8/502Sfm5pXKxSLQpsx
         rhImIGS5w2/5V7FDKjnZX+GYkZFgwhhpkP112eMb4WQ1sOH9FjGD1qkmJOySmL89YrYe
         rdwNeFQGBK8id5PUS3+pMY8PcfY8Wlbekb8IsPxLAmNdilNCo2Gs9+se8P9pqzyNlvV6
         LH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915219; x=1766520019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ce5/Jr+wXPPAgYBiuheNMGHCY0MttENpNDX20Yhq0K4=;
        b=lsxXySEO8eUuEAp75swRTcIsIh3LWPGOgul76F7ntZylaVQghxOAzFPFWD9SN2sYPj
         uxrYKX2MdAKotBvrt81JV+N+szjqpGetUn7D9aa/a6pK0ve9E4iDzcyMcAVwowj9/pCO
         GBIAm0qitwELmX9KlI2hdyp7TizQrxJ+MdoDQbWkfH1YR6SAzlYKgEOReechIW8MXG/s
         XhAGYFvf6Al5R7UIIl4lLke+f0koyEw+N8DpoBFfmnT4tVQSqXT9U9U6jTvZ/WVK4Y1E
         oDYSgrkg5BNXXUwgBCwKYAcJO32ipjfB0RUrU+KwgIZYgMf3XpOW1ZteISTXngvLT6SS
         Rh+Q==
X-Gm-Message-State: AOJu0YyIZOsvp2VKtbOj041kw0gpWb/RnQcczt+HrfL9sogDv23AzV2Q
	99EdTdiTZZEb7Kx1xvyzLLdcmSnR2GnpcR4MUkKxguPBBq3otFFq9KZevfbXlU4a7D7J8ISEI1r
	BedN4hIfWGGzx
X-Gm-Gg: AY/fxX4+UsAWnKEk5Zm2MPiuAzdAx84jHEmYH1nsT0i6OGzH5jRmvNjpvVa7K0e+y86
	LdpdSyBwcXfGNxmGXUy/5y4mxe6+rXgsBt7wuqJvvkUcPKGSSqvznUGG5YIs5zMfTWW4quy7wxb
	SGxw4nI6SmkXQe8Jg/98zidqSCO/lUJFoVYUxIIZVeNzRu3RGxFp9CWF8oW3ccoDxUFz8brUx6b
	AjaQAjVl05V16WhDIqECdOWTyHARqD/fF+xVKE1ieETGRRy55j14uPYKhr5/PkaMRvs8WMMtf8U
	Z71xQ4Plrvd6KQyBbEvtC0XLDP10NaCqeto6/AQSlfS7b5WJ5CaA7pdWjDTpaF5kNYB8MKe7hbf
	6erF0Wsj6Xli1nY3QO7pHiySb4/yk5SYwzLoXXH78F+eVwXyPCmDAweiSk4m28lBilAFJmtZ19m
	MTIEBz7L/IupQNgQLHgiWN1YITe6Bv2kIA+TKEBCc=
X-Google-Smtp-Source: AGHT+IFss4XifqHhQdhVU+8YTknoHGIrjYBMPTiUOuaw5AB/60y6F7hQuTuki2v3rPw9Z10H0e6/0w==
X-Received: by 2002:a05:690e:1c08:b0:645:5b0e:c916 with SMTP id 956f58d0204a3-6455b0ecbcdmr10495906d50.3.1765915219244;
        Tue, 16 Dec 2025 12:00:19 -0800 (PST)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:877:a727:61cf:6a50])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e749e5bc1sm42744327b3.30.2025.12.16.12.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 12:00:18 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	vdubeyko@redhat.com,
	Pavan.Rallabhandi@ibm.com
Subject: [PATCH v3] ceph: rework co-maintainers list in MAINTAINERS file
Date: Tue, 16 Dec 2025 12:00:06 -0800
Message-ID: <20251216200005.16281-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

This patch reworks the list of co-mainteainers for
Ceph file system in MAINTAINERS file.

Fixes: d74d6c0e9895 ("ceph: add bug tracking system info to MAINTAINERS")
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 MAINTAINERS | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b11839cba9d..f17933667828 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5801,7 +5801,8 @@ F:	drivers/power/supply/cw2015_battery.c
 
 CEPH COMMON CODE (LIBCEPH)
 M:	Ilya Dryomov <idryomov@gmail.com>
-M:	Xiubo Li <xiubli@redhat.com>
+M:	Alex Markuze <amarkuze@redhat.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
@@ -5812,8 +5813,9 @@ F:	include/linux/crush/
 F:	net/ceph/
 
 CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
-M:	Xiubo Li <xiubli@redhat.com>
 M:	Ilya Dryomov <idryomov@gmail.com>
+M:	Alex Markuze <amarkuze@redhat.com>
+M:	Viacheslav Dubeyko <slava@dubeyko.com>
 L:	ceph-devel@vger.kernel.org
 S:	Supported
 W:	http://ceph.com/
-- 
2.52.0


