Return-Path: <ceph-devel+bounces-3304-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 808C7B01F45
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 16:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9110516B2C8
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 14:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87DC167DB7;
	Fri, 11 Jul 2025 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjIpA+ri"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6155F2A8C1
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752244577; cv=none; b=eby4qBmCFWGZgbBAgyVOPS54R5KiueN0tcWSdoxLBKHB5vWpLOta7Sz8XrlANCP+U+SIBG8xB3Co3k1HQquGn1pU0+vyCKVpyx8JUD8i2l96qmk/lcfPYB0JhfcpO57rWOW2YTlWm5IesPTJGTgdfh/+c9XlAuALo29HR4uVAQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752244577; c=relaxed/simple;
	bh=rk50LGSqKg+ji77/o5L92HXxmrroWeN/JqFefYMzUp8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=bVMV89iYQqQ4QRppi1VN1q7f8qdLW4HsxvWCt177h8kzTOJeuB8vvWh/73sIxjGYd3buNeoZxA41gvWN3QwlifYVuXlBhT4rUUnhQgltMROYmoCgrYsGFHvSD6vDT5VKliZVuV6tsDdiAon0hjVgsZdv8ona9DiB7x1/tirF0+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RjIpA+ri; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b3aa2a0022cso2278993a12.1
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 07:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752244575; x=1752849375; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=U/+D0Ufkt89sK6GAcgcDs1g/x3uVkCQx/I8wS0upQFM=;
        b=RjIpA+riBTof8/I8Skz7b66zUORG1wqqocem5GceaCgrjtgur+e4GyZ2W+C13dk8L2
         detD6Oc4oOXlGr1MjD0TtXAHsv0kkbl3Hea0BPug5vmQ9afI+pkKQrOOLqT3wuvBAO0E
         KRUABfej7RM6XRPodYLYVBCs9JXB2gq/3zliXVAj7mxln7uOzzpfPXVonQOcYeJYwWBF
         ROe6J+ABIV0x8zsb+iirznDoJXt2LWYdX7pF9G1Wg8YGxahUIwzTw+1MYj7r01/IelU0
         l/i805/+JyBZK5vGc54xeGlT3Oojii2YRPK4HmXEoRQuU3npI12+TXrPE0A/eq/2St9F
         6l9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752244575; x=1752849375;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U/+D0Ufkt89sK6GAcgcDs1g/x3uVkCQx/I8wS0upQFM=;
        b=qNJqPSOHAHj8ITQiDFt9SegeAOg1YpmHTcgnpJI9ZzJzaonLd9rZ0AyuwXNV5rbk2K
         eWH3i3yj3Nxyf+HN4rsdYqO1DmcNX53uVn5c4x1dmbWaDbAqy9VmlA/eS8FHlb6ppHbw
         dIsCS722fLqSmlGuILkl01HRHQH8eQUVRIIU/QS9wqWs0v1ScRDnlShBG3qioBhnx7cQ
         q7Imcp10SsuyPjVxaourxkqQ0tek4msHziJGLBbpgGjOu2Aj+pP95e8PrEWE/M9mzaWE
         tmlRSRV7jbbwEO/kFFYLBeAKJyiOE1/45PePdIAopAjtpZb4GPFJS4/VvmAXjhjnxFzT
         rPWg==
X-Gm-Message-State: AOJu0YyAK22NMEjDWYTdwFj+ouhitjnWPQE+HoasvOa0pSBHqfy0v/uM
	JAUvD/fOM/BteRK1dS2U1KwOvkPqJNwA+hPKK3P6Q5EuKZIWK5/33/H8nPR5IC238JWyXrGexR3
	Ws7t0KE/MyrvRgZysLXJu3yKhMJpsa+3sJXg+
X-Gm-Gg: ASbGncv3hBb1Gfhsv5aps34Q5ab8oglRqu8FgQxCuRu/r/tbddhrGLMS2RbhtmELr1+
	wZ/QkbvPnRgfs7WBje5rEKVfRNyRAZjJmDlM1DLHO0+V3DJMlsTPJzuLJZqvhyDN4XOwSjJaJ46
	9tcGyUHv6lbjWQzyitoe0hrQ2f+SAsOv41f6CTH1XxTDLC8SXKy5PAr8ITt3QF8vHXWg1k011C9
	DuxG1na
X-Google-Smtp-Source: AGHT+IFrI+LNdDLeVMse3m0CkvzgXG4T50mzWs/i0OqonEvwdcpgEGVAq8CjpxB+dNJ4T4wmYe38Qwx1NEKhEDIQlsU=
X-Received: by 2002:a17:90b:33c8:b0:311:baa0:89ce with SMTP id
 98e67ed59e1d1-31c4ca84837mr5859219a91.12.1752244575239; Fri, 11 Jul 2025
 07:36:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date: Fri, 11 Jul 2025 23:36:07 +0900
X-Gm-Features: Ac12FXx-XyxeVLtKkgsG830tiLLZ2bajWYqrJ_qiaE0yvbYQrZTzW9R7leOT3V0
Message-ID: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
Subject: discarding an rbd device results in partial zero-filling without any errors
To: Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

I tried to discard an RBD device by `blkdiscard -o 1K -l 64K
<devpath>`. It filled zero from 1K to 4K and didn't
touch other data. In addition, it didn't return any errors. IIUC, the
expected behavior
is "discarding specified region with no error" or "returning an error
with any side effects".

I encountered this problem on linux 6.6.95-flatcar. Typically, flatcar
kernels would be
the same as the perspective of rbd driver. I'll reproduce this problem
in the latest vanilla
kernel if necessary.

This problem can be reproduced as follows.

```
# dd if=/dev/random of=/dev/rbd4 bs=1M count=1
# strace blkdiscard -o 1K -l 64K /dev/rbd4
...
munmap(0x7f12a09e9000, 262144)          = 0
munmap(0x7f12a09a9000, 262144)          = 0
ioctl(3, BLKDISCARD, [1024, 65536])     = 0
close(3)                                = 0
dup(1)                                  = 3
...
# echo $?
0
# od -Ad /dev/rbd4
...
0000992 113211 010561 012202 161732 151214 112507 137032 030556
0001008 000566 120371 003710 133162 125036 000063 100157 032223
0001024 000000 000000 000000 000000 000000 000000 000000 000000
*
0004096 123624 045340 045305 146214 137637 031304 136205 041435
0004112 121425 157166 013424 107157 121636 056600 054077 145651
...
```

Here are the results with tweaking `-o` parameters.

- `-o 0K`: zero-filling from 0 to 64K
- `-o 2K`: zero-filling from 2K to 4K
- `-o 3K`: zero-filling from 3K to 4K
- `-o 4K`: do noting
- `-o 5K`: zero-filling from 5K to 8K
- `-o 6K`: zero-filling from 6K to 8K
- `-o 7K`: zero-filling from 7K to 8K
- `-o 8K`: do noting

Although I checked all commits touching driver/block/rbd.c after v6.9,
I couldn't find any suspects.

Thanks,
Satoru

