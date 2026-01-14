Return-Path: <ceph-devel+bounces-4383-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 95271D1BEE3
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jan 2026 02:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2C5C1300765E
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jan 2026 01:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F026329DB99;
	Wed, 14 Jan 2026 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOHQTIDT"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ABD231A3B
	for <ceph-devel@vger.kernel.org>; Wed, 14 Jan 2026 01:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768354118; cv=none; b=EO7LGBQvwA7KJY9WjB+5+NPu5zdLOyRjTfYSfC1S7rz+cUkncQhQvbYjoQBoUthEefF3OTFkEwb6bL72vhmFkJxTBTX3o9Nz1MDt2p7j73FyJBEw4O0L+i51D+nINXW1bXaUCzEvAVMy342A/CsEFI2EW+VhkFYLV+vwnLfRHVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768354118; c=relaxed/simple;
	bh=+kgOOI72I+cUuFqBEirI4M5eA3yar78lYFiasRRQAjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eM/NIw+i2+O27nc033J+D+DvMSFfd/+qHX2Zhhqk8BMlcNMwpjSJaHhXeJO5j7FHjjAzCjtX2lQS7T7P2QR0sKtyh5BzQN4Atv6HRGZTYHb2EurwgQs95of7pSwwEBuwlm4bwt00qXl12LNWFhzseOi6E5yDrLYkIrAdZTN7x2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NOHQTIDT; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4308d81fdf6so4240065f8f.2
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 17:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768354115; x=1768958915; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QBuioRqMX9ATsnmkqEEZorPOJAENNWJihm3lKMbwHHc=;
        b=NOHQTIDTSFA0VD+x2fMY/429hP5empZWzkS122T0URUDmkhit2MaYdwPEGnkTJU/4O
         u/yWz09vq1FJ2mQiGsT/+lNTmS08T0swSXLI/IoQ3OtrgSkZtv9yRi68OsXF4MFl7UlX
         rNpY/C5mlszzqfVq7zSGTUNIlic3RqN/7PuC5S9tu4nWG3eS8DhSr/IZqQdvmocYZUza
         t9xaoT3UZO1/900pnjDG1htVrgk9mkiy5g6ZkO3kNNA+ksRplM/RscAD4xUdPr+x5JiQ
         vxrDkYgx5XSWlNQrkDaPpGUngi2AGRZtHRxr6mqH6EVAzqUIl4lWlsuYepzBRBo1peWf
         0Rbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768354115; x=1768958915;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QBuioRqMX9ATsnmkqEEZorPOJAENNWJihm3lKMbwHHc=;
        b=PeOVeQ9RrPTkSWHHBuVlmFycXQcDk7AB+IpkgMDLV8bAjc6jGDzUmWxeTPADXwFA2j
         FUZwGapBOLXMVlAgx047f+dxNPghTRWmVQBhz2osH2XoNH73JJfoBoh4z3vs20EU946S
         s+hhYw9h4NYYXDQBlc0m5OWDYi1lGAN/8exIMRpVoKil/psDaetxesSzZRVMqQvJ4wut
         6xFJjVwyTy82u3deK0HWz3VSGqzaCeGXjhqp3RCbTUcEvF1H3LKhGRySrNjRvy+aN+fz
         xceNL1zmYZBl/zUZd42I8vemjFatj6N1tCs1cW8r31oobfzl/5Cf2O1JBD8+GxdBDTVv
         XTZA==
X-Forwarded-Encrypted: i=1; AJvYcCVkg16V/qEls2DLe891KRPGN1wwAA/AzvaRrtn9lypNzG9bIsmZ2U79i2gmXV4pFul5m6cv9T+Lwq+5@vger.kernel.org
X-Gm-Message-State: AOJu0YzzlzR4sZvuVVOfZIP+Ma0FcMSb1E8D3TxZqI6VM7TpwXT7c66m
	OsPTONckCcglSTDq30mONiO5Ezj2g1BsWVs805RZpGNsI166AFJpzAgvTPqKAQcjFXyRDXzZrIl
	g52Qe78hxmGutor8y9a7BBq5n7+4aP7k=
X-Gm-Gg: AY/fxX5BXeJXgrT+sJ4IZHBrzu+CmHxtDdeWvy2pygODbvv3yDWxeFdCd3/5RedNUfk
	7L7D/JMnC54A9CPvBJ6zORIHIAl/ASN133i/SNN1P6Abi8bQ8eK3pNKTdr6rMf5IsiEDOgLJLVm
	9W56RqwTSNThiLsdtLCjoLoaCRWPcUgdOyFOr5FQ+bVfLu3BVjOeN89B8eQNY5qbE/guYT0rncj
	yAl9/zDW5w3ma+tFDYFUhH0Dkoo0BJtsRBJ9xNQJPsBjZeYqCwxEDrESY07tS3vD7PA8qdG9ZAO
	3iAwqZe8iQ7bLX8cVGI7LkQrUC6u
X-Received: by 2002:a05:6000:22ca:b0:432:8651:4071 with SMTP id
 ffacd0b85a97d-4342c4ff4e4mr732473f8f.18.1768354115237; Tue, 13 Jan 2026
 17:28:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113033113.149842-1-CFSworks@gmail.com> <CAOi1vP94Eruq7k10fnpA7G+LjEHdxxFvL4jnTeLMqfoxnjrTkw@mail.gmail.com>
 <CAH5Ym4gHUG326s8XoBxVExo1ZspSd0n+x3t=+rJ8N9qgjxgGHg@mail.gmail.com> <CAOi1vP99j77p42xRtQSRroVreRoaJoe9a8Rms8se5-2d1YSKHg@mail.gmail.com>
In-Reply-To: <CAOi1vP99j77p42xRtQSRroVreRoaJoe9a8Rms8se5-2d1YSKHg@mail.gmail.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Tue, 13 Jan 2026 17:28:22 -0800
X-Gm-Features: AZwV_QhFf73l4DYyApWuqyDgrTihKuEnEAkJTT1ZRLiIjtWXa7sZe10WUiofD_w
Message-ID: <CAH5Ym4gTKZue4r8URmgo+BBLJcQ+xKzEm7_P4xo1=XEwfUuv1A@mail.gmail.com>
Subject: Re: [RFC PATCH] libceph: Handle sparse-read replies lacking data length
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 12:15=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> =
wrote:
>
> On Tue, Jan 13, 2026 at 8:04=E2=80=AFPM Sam Edwards <cfsworks@gmail.com> =
wrote:
> >
> > On Tue, Jan 13, 2026 at 9:27=E2=80=AFAM Ilya Dryomov <idryomov@gmail.co=
m> wrote:
> > >
> > > On Tue, Jan 13, 2026 at 4:31=E2=80=AFAM Sam Edwards <cfsworks@gmail.c=
om> wrote:
> > > >
> > > > When the OSD replies to a sparse-read request, but no extents match=
ed
> > > > the read (because the object is empty, the read requested a region
> > > > backed by no extents, ...) it is expected to reply with two 32-bit
> > > > zeroes: one indicating that there are no extents, the other that th=
e
> > > > total bytes read is zero.
> > > >
> > > > In certain circumstances (e.g. on Ceph 19.2.3, when the requested o=
bject
> > > > is in an EC pool), the OSD sends back only one 32-bit zero. The
> > > > sparse-read state machine will end up reading something else (such =
as
> > > > the data CRC in the footer) and get stuck in a retry loop like:
> > > >
> > > >   libceph:  [0] got 0 extents
> > > >   libceph: data len 142248331 !=3D extent len 0
> > > >   libceph: osd0 (1)...:6801 socket error on read
> > > >   libceph: data len 142248331 !=3D extent len 0
> > > >   libceph: osd0 (1)...:6801 socket error on read
> > > >
> > > > This is probably a bug in the OSD, but even so, the kernel must han=
dle
> > > > it to avoid misinterpreting replies and entering a retry loop.
> > >
> > > Hi Sam,
> > >
> >
> > Hey Ilya,
> >
> > > Yes, this is definitely a bug in the OSD (and I also see another
> > > related bug in the userspace client code above the OSD...).  The
> > > triggering condition is a sparse read beyond the end of an existing
> > > object on an EC pool.  19.2.3 isn't the problem -- main branch is
> > > affected as well.
> > >
> > > If this was one of the common paths, I'd support adding some sort of
> > > a workaround to "handle" this in the kernel client.  However, sparse
> > > reads are pretty useless on EC pools because they just get converted
> > > into regular thick reads.  Sparse reads offer potential benefits only
> > > on replicated pools, but the kernel client doesn't use them by defaul=
t
> > > there either.  The sparseread mount option that is necessary for the
> > > reproducer to work isn't documented and was added purely for testing
> > > purposes.
> >
> > Note that the kernel client forces sparse reads when using fscrypt
> > (see linux-6.18/fs/ceph/addr.c:361) and I encountered this problem
> > organically as a result. It may still make sense to apply a kernel
> > workaround.
> >
> > On the other hand, it sounds like fscrypt+EC is a niche corner case,
> > we've now established that the OSD is definitely not following the
> > protocol, and working around this client-side is more involved than
> > just fixing this in the OSD. So I think simply telling affected users
> > to update their OSDs is also a reasonable way to handle this.
>
> fscrypt and EC can't be mixed -- fscrypt+EC doesn't really work.  The
> reason sparse reads are forced for fscrypt is that the client relies on
> the sparseness metadata to be able tell if a given 4K block in the
> encrypted file is a hole (in the PUNCH_HOLE sense) or not.  If it's
> a hole, POSIX dictates that a read should return zeroes.  On an EC pool
> where sparse reads are degraded into regular thick reads by the OSD,
> a hole in the middle of an object wouldn't ever be signaled.  Instead,
> the OSD would synthesize a bunch of zeroes and pass them to the client.
> The client would then run them through the crypto engine (believing
> it's a bona fide ciphertext) and return the resulting gibberish to the
> user, thus violating POSIX and widespread assumptions about generic
> filesystem behavior.

Oof, thanks for the heads-up! Fortunately my workload tolerates
garbage in holes... with the occasional (now-explained) warning, that
is. :)

I don't see the fscrypt+EC limitation mentioned in the kernel nor Ceph
docs, so I'm guessing this is more a "known major limitation" than an
out-of-scope use case. The CephFS client already blocks PUNCH_HOLE for
encrypted inodes, but by writing into the middle of an empty object, I
was able to form a hole organically and reproduce the garbage you
describe.

EC is complex, so I wouldn't have been surprised if it simply didn't
have a way to store objects with holes at all. But I was caught off
guard to learn that the hard part of this problem is communicating the
hole to the client. My intuition was that the read path must already
be detecting "no data here" in order to synthesize filler zeroes, but
it sounds like that information doesn't survive as explicit metadata.
Clearly I have more to learn about the EC read pipeline.

Cheers,
Sam

>
> >
> > I'll defer to you.
> >
> > >
> > > >
> > > > Detect this condition when the extent count is zero by checking the
> > > > `payload_len` field of the op reply. If it is only big enough for t=
he
> > > > extent count, conclude that the data length is omitted and skip to =
the
> > > > next op (which is what the state machine would have done immediatel=
y
> > > > upon reading and validating the data length, if it were present).
> > > >
> > > > ---
> > > >
> > > > Hi list,
> > > >
> > > > RFC: This patch is submitted for comment only. I've tested it for a=
bout
> > > > 2 weeks now and am satisfied that it prevents the hang, but the cur=
rent
> > > > approach decodes the entire op reply body while still in the
> > > > data-gathering step, which is suboptimal; feedback on cleaner
> > > > alternatives is welcome!
> > > >
> > > > I have not searched for nor opened a report with Ceph proper; I'd l=
ike a
> > > > second pair of eyes to confirm that this is indeed an OSD bug befor=
e I
> > > > proceed with that.
> > >
> > > Let me know if you want me to file a Ceph tracker ticket on your
> > > behalf.  I have a draft patch for the bug in the OSD and would link i=
t
> > > in the PR, crediting you as a reporter.
> >
> > Please do! I'm also interested in seeing the patch -- the OSD code is
> > pretty dense and I couldn't find the EC sparse read handler.
>
> https://github.com/ceph/ceph/pull/66912
>
> Thanks,
>
>                 Ilya

