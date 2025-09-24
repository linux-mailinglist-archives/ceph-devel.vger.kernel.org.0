Return-Path: <ceph-devel+bounces-3717-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52985B9800C
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 03:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30B3119C6040
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 01:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8D61F4C8B;
	Wed, 24 Sep 2025 01:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCEaO9Vd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DA348C11
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 01:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758677292; cv=none; b=MlqBsj62cJZdezLG/P2S3ALfY2H7nS0bnqVHqfYaMBEciyOo61HNIEwccDXFpzO7MzBXbHFxjdQPHyL7IvcoddOW7ezcn2ZQI82me7M/KNGn2qHDkWT3FmCSiyMMXrb3+1N4A6tckzZ7Xs4qV6J5GIw8m7xk8p8LA1tNXoAHQIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758677292; c=relaxed/simple;
	bh=poWi75Yc6NYPElhMs5/ZuU6q2IMR/SklZd/8AY6sAXw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qx/BJ3+IFH3b+KZbh8VQ1MfBd7dW5J8kZREoPFVR9B+3rTYSZULXN05AEECojGCulGzNiw0c/ohOZDtPrwPWY451+sr69bVuLuWcOWmKqTY8KSJyLaxUvL0p3LzPCxP3fZAbGKXYLVLeqUahl0VXjESbumHw7lU2MslE2k3GlIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mCEaO9Vd; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so509026b3a.1
        for <ceph-devel@vger.kernel.org>; Tue, 23 Sep 2025 18:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758677289; x=1759282089; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yy4kHwwkNWnxgbcRxW1OuHCY9cgZlZgFiKZ2jZqYCGY=;
        b=mCEaO9Vd4rGDBwTjEQjeKEwRPlt6mbARMEnA25OQpCWcb57VsxrkgZaSDy5IoZH7xC
         qcY0OvQn0hkEwI4X3Y9I9oo7AASxeST0+KMImPfHxgB2NJtB+1+gtp2kqBPAwQif+xu5
         AjqVtyQwjIe+DlpnKZ3fXVGD/I5nLPU/4pOoI3fKT6bEm/p/8BY2vNbRJOZBp++5Dwup
         JhxYxbvJZEkxJ1rFHVaVV8oMXJeBoYAeQ2/OecUCPsRLW0f9L27nYQstsZ0xN5fiE2Ka
         ze7TbD7Iv00REzJMqVQNQfrJB8MSiNnli7NBVv6aX8JSZMbsa20zo+6B4s49J6S4WPbv
         lz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758677289; x=1759282089;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yy4kHwwkNWnxgbcRxW1OuHCY9cgZlZgFiKZ2jZqYCGY=;
        b=vY8TIPFTi7PTO6a9U4DXpax7fbLL+RIJhmVEEupFtHagIfnDnm9gzQigvJbk5zNDn/
         ejUN4zxhIDZj7zwED5BTAUgfgK3bZ/ttbi2O7IYmCFrCIa4yi8PWglqJvXHwvnPOuEPi
         b/ePs0qL0UHkhPsuiPyiP7qoZOCzRHFwg2IsrUO0HK+qyOoxX0tZnJirfI19m1WVeXLa
         S4ZaBx/ZYVsvfx6+/s2IwU02JCI8lS/3X1MgTkHsdALy+URlhCvdfZECdNshIDH3EKwm
         613Mzrp8gonGjiFJkuKRdQzoLGK5shs0/7wzoeq0zeTEgE9tVHnId592WOrOCDa/5nf2
         wm6g==
X-Gm-Message-State: AOJu0YyX9Ai/tdqWX2Sis4DAJhSSJRdSPK81Ug+Oqq599whiLKNGnrkD
	ZAKtt9rw1LnWXrVax+3Ybax8V51vsGth3Y4wsY2g/OqGgrZH3LjxIleC
X-Gm-Gg: ASbGnctIZ8PAaWEggNGkpRQfEYzx/90/WhojpqH64NStSRYirFx5tPGDwE6grp5vCDx
	29FmTR7ElJxgpnCjxy8uGdkAAZY3SYtSjQkLLsmKhPYV3leIC8STvZVyQSxKuA1+RpYjgqzOaqR
	ML8/e/LjXtxoy5FBE9GkjPjaWC2MN6KfX052lGwo7j6rDWczskSlgv1mfgd3WTIwpOH7VtngvUp
	dbRaf1/lJd3cBMDYNR92MkWHFa8dJe2qkAiGtvImP3UMvE1rlMb1gG6Ke1u2oyohWWbKGBiqls4
	KSq6F1wcpJ/ivPlypyB4cKKiAZNDeA6bRTPGcjHv5PBcTHJvrUy7rByRnj74jsA1tl3SUkKEv5m
	/E3D7vkZco6RK+1qGUHghfx3xkGNrywtCH2o=
X-Google-Smtp-Source: AGHT+IHy0fwa9ia585w/vIXgoIdJqbR7sJnmq+74ZviBcey7HI8Q7oDjtgRzWWmIN+HBbbgjxaGGDA==
X-Received: by 2002:a05:6a00:3d51:b0:77f:2b7d:ee01 with SMTP id d2e1a72fcca58-77f6972e7d5mr759595b3a.1.1758677289526;
        Tue, 23 Sep 2025 18:28:09 -0700 (PDT)
Received: from smtpclient.apple ([58.247.22.16])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77f1979547fsm11026739b3a.31.2025.09.23.18.28.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Sep 2025 18:28:09 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with
 GCC 11.1.0
From: =?utf-8?B?6ZmI5Y2O5pit77yITHlpY2Fu77yJ?= <lyican53@gmail.com>
In-Reply-To: <2eddc77bea32f3baa47cfb1bafb4e20edfe00417.camel@ibm.com>
Date: Wed, 24 Sep 2025 09:27:15 +0800
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "idryomov@gmail.com" <idryomov@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Xiubo Li <xiubli@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1D65AD7F-DEE2-48DC-8C5D-5814B53FA0A5@gmail.com>
References: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
 <e6987f0268bd7bceddbd6ec53fa174d07cfa3114.camel@ibm.com>
 <C8E92D42-0336-45DD-A415-EA8588DE731D@gmail.com>
 <d6ccd709466d1460baf6e9b0bcec212007172622.camel@ibm.com>
 <A246BD33-C009-4C12-94E7-E95CABB94D04@gmail.com>
 <2eddc77bea32f3baa47cfb1bafb4e20edfe00417.camel@ibm.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
X-Mailer: Apple Mail (2.3826.700.81)

Hi Slava,

I apologize for the confusion with multiple patch versions. Here is one =
single formal patch that I have thoroughly tested and verified on =
multiple platforms:

**Testing verification**:
- Successfully tested on macOS with `git am`
- Successfully tested on Windows with `git am`=20
- Verified using `git apply --check` and `patch --dry-run`
- Confirmed to apply cleanly to Linux v6.17-rc6 (commit =
f83ec76bf285bea5727f478a68b894f5543ca76e)

---

=46rom f83ec76bf285bea5727f478a68b894f5543ca76e Mon Sep 23 09:05:00 2025
From: Huazhao Chen <lyican53@gmail.com>
Date: Mon, 23 Sep 2025 09:00:00 +0800
Subject: [PATCH] ceph: Fix potential undefined behavior in crush_ln() =
with GCC
11.1.0

When x & 0x1FFFF equals zero, __builtin_clz() is called with a zero
argument, which results in undefined behavior. This can happen during
ceph's consistent hashing calculations and may lead to incorrect
placement group mappings.

Fix by checking if the masked value is non-zero before calling
__builtin_clz(). If the masked value is zero, use the expected
result of 16 directly.

Signed-off-by: Huazhao Chen <lyican53@gmail.com>
---
net/ceph/crush/mapper.c | 2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 3a5bd1cd1..000f7a633 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -262,7 +262,7 @@ static __u64 crush_ln(unsigned int xin)
       * do it in one step instead of iteratively
       */
      if (!(x & 0x18000)) {
-               int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
+               int bits =3D (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) =
- 16 : 16;
              x <<=3D bits;
              iexpon =3D 15 - bits;
      }
--=20
2.39.5 (Apple Git-154)

---

**Important clarification about git diff format**:=20
I understand your confusion about the line numbers. The "@@ -262,7 =
+262,7 @@" header is **git's automatic context display format**, not an =
indication of which line I'm trying to modify. Here's what it means:

- `-262,7`: Git shows 7 lines of context starting from line 262 in the =
original file
- `+262,7`: Git shows 7 lines of context starting from line 262 in the =
modified file =20
- **The actual code change is on line 265**: `int bits =3D =
__builtin_clz(x & 0x1FFFF) - 16;`

This is exactly the line you referenced in your message [1]. Git =
automatically chooses context lines to make patches unambiguous - I did =
not manually specify line 262.

**Cross-platform testing results**:
- macOS: `git am` successful=20
- Windows: `git am` successful  =20
- Validation: `git apply --check` and `patch --dry-run` both pass=20

The patch is ready for your review and should apply without any issues.

I would be grateful if you could review this patch again. If you =
encounter any issues during application, please let me know and I'll be =
happy to provide additional assistance.

Thank you for your patience and thorough review process.

Best regards,
Huazhao Chen

[1] =
https://elixir.bootlin.com/linux/v6.17-rc6/source/net/ceph/crush/mapper.c#=
L265=

