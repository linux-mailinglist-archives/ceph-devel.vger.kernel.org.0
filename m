Return-Path: <ceph-devel+bounces-4387-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF2A9D1E051
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jan 2026 11:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5A72230703D7
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jan 2026 10:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A6A38A73F;
	Wed, 14 Jan 2026 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6z2LNX9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B029389E0C
	for <ceph-devel@vger.kernel.org>; Wed, 14 Jan 2026 10:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768386205; cv=none; b=BvBR+qNzHZneouCJxaJdeopLbMNqyDztDXF739PuAB2EXf+tG33oXaJ1jjCK8KfSqjfS3UrQ/TQ3m2a54+vFoFh5kBR+IMJv8peYlvg4zd+kV4kJwLRRgG60uBcug2w46Ug/tw2wOpHaH7FXjc+50/ZqDRUUviM2rZcHMl3CcWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768386205; c=relaxed/simple;
	bh=gej0ZY6Rx5cQWaC1k4rXAPj79a1teoZUbokyvThZBZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aRNBDqhSJB345TH3OkeAecUwKsHwuikrviel7a5jDwxAK/oUXrBl0LNfXJQRRlHA7oA8Cs3aPUUc3DNUBBJxV6UthYRT5djtVqcV6Hj9RzBV8Hm8NwbMa+L8hmpUiZDXE10T+8E5Ygo86IcfQ0jTBJ7vqIwHnCHlyN6EKPmrAOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6z2LNX9; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1232d9f25e9so514273c88.0
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jan 2026 02:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768386195; x=1768990995; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6kfNT97ng1VGOZpq6gO5qnaKBZ1Z4V1oS1eWPz4Jejk=;
        b=D6z2LNX9mumdiiPt8xi94RFyiMe1FWJDepuSOEJHK106rgEJbhLv7xqijKcCkFkG+D
         OMaxKKAb4Z0lEjRRxV96KboDhnd4OKLuU48CE2tNY/a0hmlJJLXHTg6x7dI7wQ5JaggL
         vSv2OVwWYIl43xBJH1ZYWxS0JROxqCFfSbrMCUm6wMH1YW56pqU8SN/gRThvnN6Sddt3
         PT/k2NGppSueG52nUj35bEZqpQYxscdkdXEDi6KnQfwlnmqs3HNO08WYfRCCoD5hxsa2
         HkZqoz8+Ej90pQAMU5+fcX/mEvnFfh9oOPbDDE+cXP6Qfbmx1QHVPLLmY0DbY3+3xja1
         d+dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768386195; x=1768990995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6kfNT97ng1VGOZpq6gO5qnaKBZ1Z4V1oS1eWPz4Jejk=;
        b=LpE8Xhn2wl81g7gqnGe8gQRpm/Yspot06Sd9veeswUYlZKgOj8lbK6FiixNSHk7kDA
         LsaMRHC5p4KaIWaBhcUqB9BCLHOEnFd7KGjoImjQpbNRIo+q4N2kL8jBT9al3xBLywQT
         /oUjThqi0F8gP1ujp8BIQkF+rQPxo/WrWIyCvegg1JSG+yanKpm9l+aOf4UQR3ztojJ4
         DTch8b+Y065wQAGPdQtcJ/LNWY/d1B/drJQDjGPt7fSlXlQWEENGI7h36ErS0VQEDQTd
         0UjOoMHzJhkNKatMBOgIOP5vjKQRt+qvi76Z4k1ifLIVbvOlTo8N/4PswCd/TfT4wS8z
         0gpg==
X-Forwarded-Encrypted: i=1; AJvYcCVsVQFTFBssJAbYowAeHKrkozFamvzWbvCA4H8mYiddXlIWtxUis2UCJp34KXcwlpX3xGtKPteWEf6A@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuh/IruUjln4eUadkBylcSwzHr4UQWrjSby7BoYE9YmD89u6an
	Rve8B+XlxtHLPJjRXQ7Z6S6PGpYNNqGMkCdwhHOhhaDhDNnzBPFArGfosQlA2lhaPCAAZeLIZ79
	Y/fPBblC7nRO1dBwGXMX7tPkY+B/VgqM=
X-Gm-Gg: AY/fxX7So6XG0yO1F/6vK72up7KQzH/Mo4Y1C+y8LOuEgEb14MLgM218q+1BD0c0Kcl
	ezIzWSnTBFpuxMeaDOHxCLfQYVS6oZV/AAGeqkbSTIqwclGqSk76mzocIArCRJdFElvAAfeG/+a
	yrASdtmps60P7Je8ajyOG92T8WXZ5H0VqWiTirOyoH7rGtOhEBfjo5pBmUfDI5xzhd2gF2+YtTw
	LRtb1XL4IhwteRyfW4o8OIW7uQNJv3LHdKE9FUFlYnkZddqSiybs+dD+De82/PdJmmFuTe/sW7j
	6l1CGw==
X-Received: by 2002:a05:701b:230d:b0:121:9f05:7e4c with SMTP id
 a92af1059eb24-12337701abdmr1406143c88.16.1768386195026; Wed, 14 Jan 2026
 02:23:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113033113.149842-1-CFSworks@gmail.com> <CAOi1vP94Eruq7k10fnpA7G+LjEHdxxFvL4jnTeLMqfoxnjrTkw@mail.gmail.com>
 <CAH5Ym4gHUG326s8XoBxVExo1ZspSd0n+x3t=+rJ8N9qgjxgGHg@mail.gmail.com>
 <CAOi1vP99j77p42xRtQSRroVreRoaJoe9a8Rms8se5-2d1YSKHg@mail.gmail.com> <CAH5Ym4gTKZue4r8URmgo+BBLJcQ+xKzEm7_P4xo1=XEwfUuv1A@mail.gmail.com>
In-Reply-To: <CAH5Ym4gTKZue4r8URmgo+BBLJcQ+xKzEm7_P4xo1=XEwfUuv1A@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 14 Jan 2026 11:23:02 +0100
X-Gm-Features: AZwV_QifkpbAvycm6ktCWk3ggeJIuHTKvu_oifp-ex1DAqcGJvBAo9zzekojm5I
Message-ID: <CAOi1vP_y1ZWKUFG92PKry=5xdTdi4704aKAHkV+OtkFnM5zR=g@mail.gmail.com>
Subject: Re: [RFC PATCH] libceph: Handle sparse-read replies lacking data length
To: Sam Edwards <cfsworks@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 2:28=E2=80=AFAM Sam Edwards <cfsworks@gmail.com> wr=
ote:
>
> On Tue, Jan 13, 2026 at 12:15=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com=
> wrote:
> >
> > On Tue, Jan 13, 2026 at 8:04=E2=80=AFPM Sam Edwards <cfsworks@gmail.com=
> wrote:
> > >
> > > On Tue, Jan 13, 2026 at 9:27=E2=80=AFAM Ilya Dryomov <idryomov@gmail.=
com> wrote:
> > > >
> > > > On Tue, Jan 13, 2026 at 4:31=E2=80=AFAM Sam Edwards <cfsworks@gmail=
.com> wrote:
> > > > >
> > > > > When the OSD replies to a sparse-read request, but no extents mat=
ched
> > > > > the read (because the object is empty, the read requested a regio=
n
> > > > > backed by no extents, ...) it is expected to reply with two 32-bi=
t
> > > > > zeroes: one indicating that there are no extents, the other that =
the
> > > > > total bytes read is zero.
> > > > >
> > > > > In certain circumstances (e.g. on Ceph 19.2.3, when the requested=
 object
> > > > > is in an EC pool), the OSD sends back only one 32-bit zero. The
> > > > > sparse-read state machine will end up reading something else (suc=
h as
> > > > > the data CRC in the footer) and get stuck in a retry loop like:
> > > > >
> > > > >   libceph:  [0] got 0 extents
> > > > >   libceph: data len 142248331 !=3D extent len 0
> > > > >   libceph: osd0 (1)...:6801 socket error on read
> > > > >   libceph: data len 142248331 !=3D extent len 0
> > > > >   libceph: osd0 (1)...:6801 socket error on read
> > > > >
> > > > > This is probably a bug in the OSD, but even so, the kernel must h=
andle
> > > > > it to avoid misinterpreting replies and entering a retry loop.
> > > >
> > > > Hi Sam,
> > > >
> > >
> > > Hey Ilya,
> > >
> > > > Yes, this is definitely a bug in the OSD (and I also see another
> > > > related bug in the userspace client code above the OSD...).  The
> > > > triggering condition is a sparse read beyond the end of an existing
> > > > object on an EC pool.  19.2.3 isn't the problem -- main branch is
> > > > affected as well.
> > > >
> > > > If this was one of the common paths, I'd support adding some sort o=
f
> > > > a workaround to "handle" this in the kernel client.  However, spars=
e
> > > > reads are pretty useless on EC pools because they just get converte=
d
> > > > into regular thick reads.  Sparse reads offer potential benefits on=
ly
> > > > on replicated pools, but the kernel client doesn't use them by defa=
ult
> > > > there either.  The sparseread mount option that is necessary for th=
e
> > > > reproducer to work isn't documented and was added purely for testin=
g
> > > > purposes.
> > >
> > > Note that the kernel client forces sparse reads when using fscrypt
> > > (see linux-6.18/fs/ceph/addr.c:361) and I encountered this problem
> > > organically as a result. It may still make sense to apply a kernel
> > > workaround.
> > >
> > > On the other hand, it sounds like fscrypt+EC is a niche corner case,
> > > we've now established that the OSD is definitely not following the
> > > protocol, and working around this client-side is more involved than
> > > just fixing this in the OSD. So I think simply telling affected users
> > > to update their OSDs is also a reasonable way to handle this.
> >
> > fscrypt and EC can't be mixed -- fscrypt+EC doesn't really work.  The
> > reason sparse reads are forced for fscrypt is that the client relies on
> > the sparseness metadata to be able tell if a given 4K block in the
> > encrypted file is a hole (in the PUNCH_HOLE sense) or not.  If it's
> > a hole, POSIX dictates that a read should return zeroes.  On an EC pool
> > where sparse reads are degraded into regular thick reads by the OSD,
> > a hole in the middle of an object wouldn't ever be signaled.  Instead,
> > the OSD would synthesize a bunch of zeroes and pass them to the client.
> > The client would then run them through the crypto engine (believing
> > it's a bona fide ciphertext) and return the resulting gibberish to the
> > user, thus violating POSIX and widespread assumptions about generic
> > filesystem behavior.
>
> Oof, thanks for the heads-up! Fortunately my workload tolerates
> garbage in holes... with the occasional (now-explained) warning, that
> is. :)
>
> I don't see the fscrypt+EC limitation mentioned in the kernel nor Ceph
> docs, so I'm guessing this is more a "known major limitation" than an
> out-of-scope use case.

Correct, it's tracked under https://tracker.ceph.com/issues/67507.

Thanks,

                Ilya

