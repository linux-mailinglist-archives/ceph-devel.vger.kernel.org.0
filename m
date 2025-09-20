Return-Path: <ceph-devel+bounces-3699-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8518B8C7A0
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Sep 2025 14:07:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62A153A9D53
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Sep 2025 12:07:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65FA25783F;
	Sat, 20 Sep 2025 12:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SQNJ9Kvg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101E31D416E
	for <ceph-devel@vger.kernel.org>; Sat, 20 Sep 2025 12:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758370026; cv=none; b=a4JbjhOmLgfoGzvKk56LaFZeC2d7q6Ue4cMRca4X+pPq7zkRcdz5KjOmNCTctFRapVqR0J1x16Hzs1MPFLsC1DnZAgzFSrZjCuPdgnsuYK0pV3dHjHrzBBTRmtJOZ93+02zf3VKDdhwskb93b+mSgWud+7X9gTovmc7dz+ah4xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758370026; c=relaxed/simple;
	bh=wRfe16rjqxi2xuffa0AZufUXEu2URptMaXK4aGux90c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IvVVgL+3kYv22Mi8XPMhI56EkuWCXzib89z5DKUuYiYcO59Yhy3TVMwp5KQ0Fh+ooeL67ajXqsXbOc/mHI8S0fcyj0iVriRHwHoA0er8cT4aqcUGbSDp69OEaXlPoM/QaI3CieqPSuaMVgf0a0nogXH2sPS4YUU9Vl4lQleRnLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SQNJ9Kvg; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-25669596955so26699425ad.0
        for <ceph-devel@vger.kernel.org>; Sat, 20 Sep 2025 05:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758370024; x=1758974824; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMb8VWE+6URytkIT382Ezy+2ljI6Cia6SMvGCKjJfW4=;
        b=SQNJ9KvgkCS7UTrUppMDU9mHcLiPrTVmuV/0CdIpaS2wj1oQpBqwooNztICSb81yqy
         R9S++Brg/8Oewk87HxYZQffPvpKDT+8ko69zgKqkWSjAkEWFRSP9Fy8HA5+2NNxUBJqj
         2VwXxTWCSm8N5Vz1F8oRq5rFO7AIM/dWEDrAGynd0eLqbTFJF7+8smp3Aike6CnR1/cN
         q1todUKZwWwS4MTUbAraCktMW639yu7e99O3sWgt6uvL7DQimb8STaQrQ7B1AJc6pEmH
         ESkrr9O4NIVtvamkniJ/p6r+6Ihk1PyC7gn9eyJQFUnbQxDzD4fmKMtdpf4nt9ZX7ZIM
         5jlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758370024; x=1758974824;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lMb8VWE+6URytkIT382Ezy+2ljI6Cia6SMvGCKjJfW4=;
        b=e8DaDxh4UY0Vo/gKS29tmZsJpV/tORPs6RsPUzumYG449pW0VoLu6ilhCIp8qogC4h
         3bBggf0caidu4c1cRYZb5BkkCOys4BhuDDojVqkwZpHznsUXQEqFrnbuqyqOuJxEFwoQ
         6pW4NXq739uqctjcvYKAuehg5IUSlZDuVZhIue7hwR0IKyRm6mqxjmf4yzcCGNGycMYz
         1vHDZEtXauOUvvUXYnntOZeQBVLa2a/Wp9/Cr6nqCTbn+3Oubsy3UM0KFYqPkpf4eZ1R
         y8pQuxsXDwtyDh6jnAiOHxsf4TLIBYF6O0JUrzCPkpZV4lCMlf0imc5eOTo+Uf6mm7mf
         bN+A==
X-Gm-Message-State: AOJu0Yy4wE4sem6w+lufi5ntfgGygzdjWSqS6Rp+sj13iSeRPHhU49LJ
	uu9X5ZZlcFlIGTmVB7M78V5pZjqPrU2OkSfO3d8mqsQQwflYzktJVw3i
X-Gm-Gg: ASbGnctAejRVrOMG9ae1cbrpnnVCiFSsPtFwjkVjFO9YqUo4+G2+eaopzfPLhwZg2n1
	e7fZPcBTWTPl+kTeRWDSAYH+pScp5Gq9tTyK5uwQ9yHrNpUc5Qzevwj0hz6o4mwft/ap2CUHBW4
	OlRJlPceDu8G01Invax7Jxt2FDOvur3995o3e1ivnaUOdd+6iqe43kXXRg8tufs1c64Mki9X6va
	SaS7ZpsvebnTx9PkDOLwN6nFOOxOMKlqJ4aWk3O2i4Eh1+4xMbUCiD47IQjWl8z71kADTbIdzJZ
	F45dwcnv/lDOrqSdMQ9/5zyrZdjIQt5kDmb6cFQlNDVOYceVretE+A7kPHE96vwuqpY4doduFxh
	2mJMVFYuTBmhK513Ys+PniN2t4+6xS/VN55eAlrMfS0Z2AqxH
X-Google-Smtp-Source: AGHT+IHvMLKv3j9HfmbwyBfZaaEcYq1hRS0Aah0Qh5jJRqgSuw36FXvoywwNIGGE9sU1vW9GdPrT9Q==
X-Received: by 2002:a17:902:f541:b0:270:8ae3:a6f1 with SMTP id d9443c01a7336-2708ae3a911mr33570055ad.46.1758370024250;
        Sat, 20 Sep 2025 05:07:04 -0700 (PDT)
Received: from smtpclient.apple ([2403:d400:1000:7:c4a:831d:b386:ef7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2698035d337sm80068635ad.139.2025.09.20.05.07.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Sep 2025 05:07:03 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with
 GCC 11.1.0
From: =?utf-8?B?6ZmI5Y2O5pit77yITHlpY2Fu77yJ?= <lyican53@gmail.com>
In-Reply-To: <d6ccd709466d1460baf6e9b0bcec212007172622.camel@ibm.com>
Date: Sat, 20 Sep 2025 20:06:48 +0800
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "idryomov@gmail.com" <idryomov@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Xiubo Li <xiubli@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A246BD33-C009-4C12-94E7-E95CABB94D04@gmail.com>
References: <1AD55673-B7F4-4DB7-AE80-1AC81709F65A@gmail.com>
 <e6987f0268bd7bceddbd6ec53fa174d07cfa3114.camel@ibm.com>
 <C8E92D42-0336-45DD-A415-EA8588DE731D@gmail.com>
 <d6ccd709466d1460baf6e9b0bcec212007172622.camel@ibm.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
X-Mailer: Apple Mail (2.3826.700.81)


> 2025=E5=B9=B49=E6=9C=8820=E6=97=A5 02:51=EF=BC=8CViacheslav Dubeyko =
<Slava.Dubeyko@ibm.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, 2025-09-19 at 10:34 +0800, =E9=99=88=E5=8D=8E=E6=98=AD=EF=BC=88L=
yican=EF=BC=89 wrote:
>>> 2025=E5=B9=B49=E6=9C=8819=E6=97=A5 02:07=EF=BC=8CViacheslav Dubeyko =
<Slava.Dubeyko@ibm.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>=20
> <skipped>
> I still have the same issue with the new patch. Your patch is trying =
to modify
> the line 262. However, we have comments on this line [1]:
>=20
> 260 /*
> 261 * figure out number of bits we need to shift and
> 262 * do it in one step instead of iteratively
> 263 */
> 264 if (!(x & 0x18000)) {
> 265 int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
> 266 x <<=3D bits;
> 267 iexpon =3D 15 - bits;
> 268 }
>=20
> Thanks,
> Slava.
>=20
> [1]
> =
https://elixir.bootlin.com/linux/v6.17-rc6/source/net/ceph/crush/mapper.c#=
L262
Hi Slava,

Thank you for your patience with this patch. I want to clarify the =
confusion about the line numbering.

The patch header "@@ -262,7 +262,7 @@" was automatically generated by =
git format-patch - I did not manually specify line 262. This is how git =
diff format works: it shows context lines starting from line 262, but =
the actual code modification is on line 265 where the `__builtin_clz()` =
call is located (exactly as you referenced in [1]).

To be absolutely clear:
- I am NOT trying to modify line 262 (which contains comments)
- I AM modifying line 265: `int bits =3D __builtin_clz(x & 0x1FFFF) - =
16;`
- The "@@ -262,7 +262,7 @@" header is git's standard way of providing =
context
- Git automatically chooses how many context lines to show and where to =
start them

The patch content clearly shows the actual change:
```diff
- int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
+ int bits =3D (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) - 16 : 16;
```

This line-by-line diff shows exactly what gets modified - line 265 in =
the official kernel source.

Here is the git-generated patch:

---

=46rom ac3a55a6a18761d613971ef6f78fa39e6d7d2172 Mon Sep 17 00:00:00 2001
From: Huazhao Chen <lyican53@gmail.com>
Date: Sat, 20 Sep 2025 19:42:54 +0800
Subject: [PATCH] ceph: Fix potential undefined behavior in crush_ln() =
with GCC
 11.1.0

When x & 0x1FFFF equals zero, __builtin_clz() is called with a zero
argument, which results in undefined behavior. This can happen during
ceph's consistent hashing calculations and may lead to incorrect
placement group mappings.

Fix by checking if the masked value is non-zero before calling
__builtin_clz(). If the masked value is zero, use the expected result
of 16 directly.

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
- int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
+ int bits =3D (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) - 16 : 16;
  x <<=3D bits;
  iexpon =3D 15 - bits;
  }
--=20
2.39.5 (Apple Git-154)

---

To demonstrate that this is git's automatic behavior and not my manual =
choice, I can provide the same fix with different context formatting. =
Here's an alternative patch with less context (generated using `git =
format-patch -U1`):

```diff
@@ -264,3 +264,3 @@ static __u64 crush_ln(unsigned int xin)
  if (!(x & 0x18000)) {
- int bits =3D __builtin_clz(x & 0x1FFFF) - 16;
+ int bits =3D (x & 0x1FFFF) ? __builtin_clz(x & 0x1FFFF) - 16 : 16;
  x <<=3D bits;
```

As you can see, this version shows "@@ -264,3 +264,3 @@" but still =
modifies the exact same line - line 265 where `__builtin_clz()` is =
called. The line numbers in the @@ header are just context indicators, =
not the target of the modification.

Both patches apply successfully to commit =
f83ec76bf285bea5727f478a68b894f5543ca76e (Linux 6.17-rc6). I've tested =
both locally with `git am`. The actual code change is identical in both =
cases - we're fixing the undefined behavior in the `__builtin_clz()` =
call on line 265.

I hope this clarifies that the git-generated diff headers don't indicate =
which line I'm trying to modify, but rather where git chooses to show =
the context for the patch.

Best regards,
Huazhao Chen

[1] =
https://elixir.bootlin.com/linux/v6.17-rc6/source/net/ceph/crush/mapper.c#=
L265=

