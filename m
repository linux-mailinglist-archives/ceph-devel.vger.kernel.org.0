Return-Path: <ceph-devel+bounces-3305-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2274EB01FEC
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 16:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459975C516C
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jul 2025 14:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17EC02EA165;
	Fri, 11 Jul 2025 14:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dreamsnake-net.20230601.gappssmtp.com header.i=@dreamsnake-net.20230601.gappssmtp.com header.b="pAwy0dZK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF992E9EDE
	for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 14:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752245850; cv=none; b=JpGiY/XOWvZrCl0Fhd5wmW5yK02ogJmR5b165oUkmCwQu50vKw0aSgyeNay9BOxIMIKM8sak8TLbFzq99pQookb57LllXcBFvpNtfeVqWOa4rHx0BOTEvVmAnWokjEgVo/awQiDn28C/PgfKmef94V9dxAJPy6BDew76czy7RZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752245850; c=relaxed/simple;
	bh=ujVuGLxRLn/0toRGKLlEp8L+AbBKHdb+FHuc1y9E4zU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ssPqMUTjQ5z191Pk9tg+R+tGCPazbqWj7BDSmrPPDQfv3i3QZihM5o1nGfnPQ02RDVDetuahaGqfFml7OCCVjDBrL/0yo+Y27Pu47wv16jNOUL/CaW09QsoqTpXTQGSoGlw0WEFhnQ3T0Rti4JER11iEvguPjVYl5lwHWSH5MOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dreamsnake.net; spf=none smtp.mailfrom=dreamsnake.net; dkim=pass (2048-bit key) header.d=dreamsnake-net.20230601.gappssmtp.com header.i=@dreamsnake-net.20230601.gappssmtp.com header.b=pAwy0dZK; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dreamsnake.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dreamsnake.net
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7dfe2339eccso52328985a.0
        for <ceph-devel@vger.kernel.org>; Fri, 11 Jul 2025 07:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dreamsnake-net.20230601.gappssmtp.com; s=20230601; t=1752245848; x=1752850648; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/q62setULSi79EZ8qW9jvSzGX4GsA8BMot1SbkxOVo=;
        b=pAwy0dZK1gsirJOj+xTYWeuFcXR8GTv011xuYd5OCktVpg7sIhI/lbvsZ+g339BUe4
         rast0rUUKVcpgaWj915C1ete8oMIIjPEI8frAwVQ+CbhFi6X6tKMvC+LEFaG465669tH
         hwZ8tNaXA3n5QSr/gN7rgpIHfvtuXtCNbY20aKW9esCsju/fFWxZFSI9n465DL57/5Yn
         izGLi5DevAMXAOMpF9HoVOmnC8lSOxj8LzdUht4kaWZ11y4vk46tnLpcfq6kvmXmjmeG
         sUaQv9Pqg+Qh1amc9OFCrNLzAdKX426J7mjT6sAOnasvijr0RCu5MBTns+DUbn4JsA3f
         lyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752245848; x=1752850648;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/q62setULSi79EZ8qW9jvSzGX4GsA8BMot1SbkxOVo=;
        b=uF16WMEXx8uT3MHWHDSJ7lO/qKQ5g/v5VszQUb8KbGpBW1DPNhfu0+yOXReuXAq1wC
         U8jggWWPVvobMLF35/2V9Wr8qanC2Opl1M+JgGYHCGdUIRs7JyDNrcn5vd4aB6rOjQlM
         5emA1QWg3DIcIloYzsgeY9ffpTxniFOc9BdPaz4qCjIhtw3xUUSOqTmSlrDxweZDsmmx
         02uYPgwX7OsdGZ7Eyfiem8AceCsiP6rYmp4QWMdzT+nS7md4JVCV/PuqiNRlHmH1kGxI
         GBr9SsFGN5wn+fNos27XJow8QnuBXYRT1IMw3lCqCSl8rOKoU5Fbrg5SiyWT4+4rug9B
         n35w==
X-Gm-Message-State: AOJu0Yzxo0Kak5kPX1Hy7qSeYBP+jgGHpxDq/IQuDTBCvS3B2C9aWjI9
	PJtUau/CTnwEs7PYPBm0go8kEcsWsnhIb42PBPvdqdcOHwu8GnCjNgTSOTGvzOw9AfQ0WSDuVUx
	ZRQ==
X-Gm-Gg: ASbGncvgQyI5m/QBWhsEBLVAb2t2ujH9yuzvVgmp3toXQkUPvdK4ZwpKb7fK9oicoAn
	htLiNX1tpiQc9qaWUueZ74Ir6PSd1jTY6rb4kelpaD0SX1SsN/NAACmtjT35Yys9ZpuNE8cEFsl
	y54izg3/r9sitq7EGDlYUBRMnFts9SSjHJMR9aApbF2j6L55/F/8SzGQHO3BiKAh/1kCScTmNqx
	7mdvJyuHKoDF+93ObRwESJAaxJtaHTbkQVNOKwKSTn4AmfPvw9dZBP87oZXzS3x1EqLM5x9XguE
	C15W+OSC74d1dTwnm4ojfjohb07DGr/RZetVDD9PTLfLA719fPZnPINnTr0bWe7XU1rWUG+lu+i
	rw2kY3gljuhGhbcYm5d6aNGrgqivaXHXwBfa36TnR3ju4WEN70cy82Iw=
X-Google-Smtp-Source: AGHT+IE9p2QksvL3yhzRiLhYSWMH1mf6BWs/CKVm6sMoUP8+B/2KH7+BmY9co72uPQKPDt2JzThMww==
X-Received: by 2002:a05:620a:2725:b0:7c9:38ce:becd with SMTP id af79cd13be357-7dea50cbf0dmr356236885a.22.1752245847476;
        Fri, 11 Jul 2025 07:57:27 -0700 (PDT)
Received: from smtpclient.apple ([2600:4041:403:7300:494:33f1:2212:8db3])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7dcdc000ae6sm229566985a.26.2025.07.11.07.57.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jul 2025 07:57:26 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: discarding an rbd device results in partial zero-filling without
 any errors
From: Anthony D'Atri <aad@dreamsnake.net>
In-Reply-To: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
Date: Fri, 11 Jul 2025 10:57:16 -0400
Cc: Ceph Development <ceph-devel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4DFDAA8E-98D2-461D-A5B1-05C482D235A7@dreamsnake.net>
References: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)

My sense is that blkdiscard is intended for something different from =
what you=E2=80=99re intending.  =46rom the man page:

DESCRIPTION
       blkdiscard is used to discard device sectors.
=E2=80=A6
       -s, --secure
           Perform a secure discard. A secure discard is the same as a =
regular discard except that all copies of the discarded blocks that were =
possibly created by garbage collection must also be
           erased. This requires support from the device.

       -z, --zeroout
           Zero-fill rather than discard.

It=E2=80=99s about sending TRIM commands to the device telling it that =
SSD or thin-provisioned blocks may be reallocated. Zero-filling or =
erasing is a different operation.

If your intent is to free RADOS pool capacity,`blkdiscard` should do =
that, or if there=E2=80=99s a filesystem on the RBD device, mount it and =
run `fstrim`.  Was there a mounted filesystem when you ran the below?

If your intent is to erase data, any new clients getting discarded or =
freed blocks see them thin-provisioned, so any existing old data is not =
visible to them.


> On Jul 11, 2025, at 10:36=E2=80=AFAM, Satoru Takeuchi =
<satoru.takeuchi@gmail.com> wrote:
>=20
> Hi,
>=20
> I tried to discard an RBD device by `blkdiscard -o 1K -l 64K
> <devpath>`. It filled zero from 1K to 4K and didn't
> touch other data. In addition, it didn't return any errors. IIUC, the
> expected behavior
> is "discarding specified region with no error" or "returning an error
> with any side effects".
>=20
> I encountered this problem on linux 6.6.95-flatcar. Typically, flatcar
> kernels would be
> the same as the perspective of rbd driver. I'll reproduce this problem
> in the latest vanilla
> kernel if necessary.
>=20
> This problem can be reproduced as follows.
>=20
> ```
> # dd if=3D/dev/random of=3D/dev/rbd4 bs=3D1M count=3D1
> # strace blkdiscard -o 1K -l 64K /dev/rbd4
> ...
> munmap(0x7f12a09e9000, 262144)          =3D 0
> munmap(0x7f12a09a9000, 262144)          =3D 0
> ioctl(3, BLKDISCARD, [1024, 65536])     =3D 0
> close(3)                                =3D 0
> dup(1)                                  =3D 3
> ...
> # echo $?
> 0
> # od -Ad /dev/rbd4
> ...
> 0000992 113211 010561 012202 161732 151214 112507 137032 030556
> 0001008 000566 120371 003710 133162 125036 000063 100157 032223
> 0001024 000000 000000 000000 000000 000000 000000 000000 000000
> *
> 0004096 123624 045340 045305 146214 137637 031304 136205 041435
> 0004112 121425 157166 013424 107157 121636 056600 054077 145651
> ...
> ```
>=20
> Here are the results with tweaking `-o` parameters.
>=20
> - `-o 0K`: zero-filling from 0 to 64K
> - `-o 2K`: zero-filling from 2K to 4K
> - `-o 3K`: zero-filling from 3K to 4K
> - `-o 4K`: do noting
> - `-o 5K`: zero-filling from 5K to 8K
> - `-o 6K`: zero-filling from 6K to 8K
> - `-o 7K`: zero-filling from 7K to 8K
> - `-o 8K`: do noting
>=20
> Although I checked all commits touching driver/block/rbd.c after v6.9,
> I couldn't find any suspects.
>=20
> Thanks,
> Satoru
>=20


