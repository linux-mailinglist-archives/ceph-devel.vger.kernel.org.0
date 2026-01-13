Return-Path: <ceph-devel+bounces-4381-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 99966D1B2AB
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 21:15:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 379BC3005001
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 20:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0542C318B93;
	Tue, 13 Jan 2026 20:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fAqOviz9"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D5389E02
	for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 20:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768335323; cv=none; b=Ea9xmdhOCYKWCI3ZdYWQiASMQh4xoQVClDhh7cjpAK7cXBDFaZ0oNDzJw679kCJu7QsbDjvNxw8+dhslidM29FYb8oWN5hgfUYXTc/0NzdjjEestkYBci7pj87ir3ii1LO7lBrySncalwKeIyvjIkZRRZNxRKD9/iucsrUquBmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768335323; c=relaxed/simple;
	bh=fBMFDvmjGqFMniRVSABC95N8ajXU2RTfInErecwWsx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TJ/WMg5cucSy1uya5R5I0XOlClN6ZcDbxQjEWLhEsrM3mufyxR4+K+UdtnsJrQtjnVLIYSFw1AlzhGUuRYC5QYFoPNUhAnNrrtn6X/6xUhrJNPdDLs1USL707A2UiBAOgRdvltew6zGYJ9QmN7orru5tzZ66Ko3DnodVFPBKckQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fAqOviz9; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12336f33098so10896c88.0
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 12:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768335321; x=1768940121; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tktDzIBgjcupNoJtMOOta90cFLT6qT2A8lnIPlNMlZk=;
        b=fAqOviz9QHjrkqsT2AWTanegshookULiMPuUjKFO9jwfqSKKHwSHwBZ7gzb54k49Au
         yU7KBYLuQIMCFuIKfesS1LSNVMreu7MVFkeJCiH56LI4G9VUmSD9QBMEPuDMA9Cvnqva
         lJjtzOmkhCDNbcvCER2QbxaxmM0rtBrg9pb/0MBXz+4513sND12h8KqWa24NKuNQL3TH
         q4s+G16Kup43obA6MC3Ux2K9qIrJ4+cABlYFeERXYosJXrc+ole4ysedL9i45D/Pux6r
         VECfhQMYC6/CCWNNVpeaIbgbzScKUbAxMjEMmks07jJTKzk81zygmrI8kzWbRpd9/2kB
         iDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768335321; x=1768940121;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tktDzIBgjcupNoJtMOOta90cFLT6qT2A8lnIPlNMlZk=;
        b=OoU6DvCiKqW2ut/xke4NAmYdzIP/p8J2NNp5iIcTv9BwWO5jJQexAaWBgkFb8Y8MKT
         mTXpP6FvCESkvbWBB4/jabLCeQdlJ+xdnQ6I5MjXA4P+ezk26Ab/PBJ30XM1ecxOWL2F
         +H8frlggj4Zpo4QbHl2lxQhrTtg9DK2Kga+Pot5kaIGQoHccHO29uJFJCSMeNayX7Bwk
         lbutk8bG1ZqgTM4NIcVzNyOsgfSIEzCoE8uSe7CksoTqmqECfCwsT/vmLqW2AjbjdRxi
         4fyHdiNJ7nxOT2SQBz72YwT6hVNzF1eRrG/DSMipbadpkfvjR/DnmETYgRBtvbv7xFQF
         paCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUichGFfKcIrVDxW0htdyG1Y/OUlrQtRKvswYkZW9f2mJbSSnRbeQZFoTk4uIZxG2Gx78GZoeJNwTuu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/fho5YH5IqxhdFuFS7OsOaaxtq+N0yE+UXbSIzEP5lr4t8u+l
	Ybu28IJTKZ9bY0U91CWuj6VOfKVtgs3YeXwtIH3fzJUKdJMIEOqJCcMHoewLVzxLeeH6PbOzfpd
	7EIMWi4xQY8LU86ilypWDX6X8sBbw8Ss=
X-Gm-Gg: AY/fxX5kgXr7MAWqgDyk5YDjI4k9MTdIxGXKdbGIszULTQSwUqa41SEzrddcS+p5rBF
	0GK377w4CGrdpBPQLiAbCgqTZiXM2K69jVUQO6oOew1Dx1tSL0f4vv3dfr4Khqy+H8philvCh4j
	2f4pzzG8ffURmPgrSRY1pPhn06Zx8/4OURTl+658jj24twpzXZBaUlBdWB5RCl+69eHvZuuZTDR
	pGPesWnxhRBLp07gfOg2E+dhrY4SUDbwv07lmi7dJ+tAzCWIno2j0+EEOZT6Mzk0JK7P5A=
X-Received: by 2002:a05:701b:2204:b0:123:330b:3a0 with SMTP id
 a92af1059eb24-12336a274b3mr183497c88.14.1768335321399; Tue, 13 Jan 2026
 12:15:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113033113.149842-1-CFSworks@gmail.com> <CAOi1vP94Eruq7k10fnpA7G+LjEHdxxFvL4jnTeLMqfoxnjrTkw@mail.gmail.com>
 <CAH5Ym4gHUG326s8XoBxVExo1ZspSd0n+x3t=+rJ8N9qgjxgGHg@mail.gmail.com>
In-Reply-To: <CAH5Ym4gHUG326s8XoBxVExo1ZspSd0n+x3t=+rJ8N9qgjxgGHg@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 13 Jan 2026 21:15:09 +0100
X-Gm-Features: AZwV_Qhurd22kOjJ70wmLj50kuVTijX8RizcBckOIi4gaDucpNRmHnXzigAFX4s
Message-ID: <CAOi1vP99j77p42xRtQSRroVreRoaJoe9a8Rms8se5-2d1YSKHg@mail.gmail.com>
Subject: Re: [RFC PATCH] libceph: Handle sparse-read replies lacking data length
To: Sam Edwards <cfsworks@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 8:04=E2=80=AFPM Sam Edwards <cfsworks@gmail.com> wr=
ote:
>
> On Tue, Jan 13, 2026 at 9:27=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com>=
 wrote:
> >
> > On Tue, Jan 13, 2026 at 4:31=E2=80=AFAM Sam Edwards <cfsworks@gmail.com=
> wrote:
> > >
> > > When the OSD replies to a sparse-read request, but no extents matched
> > > the read (because the object is empty, the read requested a region
> > > backed by no extents, ...) it is expected to reply with two 32-bit
> > > zeroes: one indicating that there are no extents, the other that the
> > > total bytes read is zero.
> > >
> > > In certain circumstances (e.g. on Ceph 19.2.3, when the requested obj=
ect
> > > is in an EC pool), the OSD sends back only one 32-bit zero. The
> > > sparse-read state machine will end up reading something else (such as
> > > the data CRC in the footer) and get stuck in a retry loop like:
> > >
> > >   libceph:  [0] got 0 extents
> > >   libceph: data len 142248331 !=3D extent len 0
> > >   libceph: osd0 (1)...:6801 socket error on read
> > >   libceph: data len 142248331 !=3D extent len 0
> > >   libceph: osd0 (1)...:6801 socket error on read
> > >
> > > This is probably a bug in the OSD, but even so, the kernel must handl=
e
> > > it to avoid misinterpreting replies and entering a retry loop.
> >
> > Hi Sam,
> >
>
> Hey Ilya,
>
> > Yes, this is definitely a bug in the OSD (and I also see another
> > related bug in the userspace client code above the OSD...).  The
> > triggering condition is a sparse read beyond the end of an existing
> > object on an EC pool.  19.2.3 isn't the problem -- main branch is
> > affected as well.
> >
> > If this was one of the common paths, I'd support adding some sort of
> > a workaround to "handle" this in the kernel client.  However, sparse
> > reads are pretty useless on EC pools because they just get converted
> > into regular thick reads.  Sparse reads offer potential benefits only
> > on replicated pools, but the kernel client doesn't use them by default
> > there either.  The sparseread mount option that is necessary for the
> > reproducer to work isn't documented and was added purely for testing
> > purposes.
>
> Note that the kernel client forces sparse reads when using fscrypt
> (see linux-6.18/fs/ceph/addr.c:361) and I encountered this problem
> organically as a result. It may still make sense to apply a kernel
> workaround.
>
> On the other hand, it sounds like fscrypt+EC is a niche corner case,
> we've now established that the OSD is definitely not following the
> protocol, and working around this client-side is more involved than
> just fixing this in the OSD. So I think simply telling affected users
> to update their OSDs is also a reasonable way to handle this.

fscrypt and EC can't be mixed -- fscrypt+EC doesn't really work.  The
reason sparse reads are forced for fscrypt is that the client relies on
the sparseness metadata to be able tell if a given 4K block in the
encrypted file is a hole (in the PUNCH_HOLE sense) or not.  If it's
a hole, POSIX dictates that a read should return zeroes.  On an EC pool
where sparse reads are degraded into regular thick reads by the OSD,
a hole in the middle of an object wouldn't ever be signaled.  Instead,
the OSD would synthesize a bunch of zeroes and pass them to the client.
The client would then run them through the crypto engine (believing
it's a bona fide ciphertext) and return the resulting gibberish to the
user, thus violating POSIX and widespread assumptions about generic
filesystem behavior.

>
> I'll defer to you.
>
> >
> > >
> > > Detect this condition when the extent count is zero by checking the
> > > `payload_len` field of the op reply. If it is only big enough for the
> > > extent count, conclude that the data length is omitted and skip to th=
e
> > > next op (which is what the state machine would have done immediately
> > > upon reading and validating the data length, if it were present).
> > >
> > > ---
> > >
> > > Hi list,
> > >
> > > RFC: This patch is submitted for comment only. I've tested it for abo=
ut
> > > 2 weeks now and am satisfied that it prevents the hang, but the curre=
nt
> > > approach decodes the entire op reply body while still in the
> > > data-gathering step, which is suboptimal; feedback on cleaner
> > > alternatives is welcome!
> > >
> > > I have not searched for nor opened a report with Ceph proper; I'd lik=
e a
> > > second pair of eyes to confirm that this is indeed an OSD bug before =
I
> > > proceed with that.
> >
> > Let me know if you want me to file a Ceph tracker ticket on your
> > behalf.  I have a draft patch for the bug in the OSD and would link it
> > in the PR, crediting you as a reporter.
>
> Please do! I'm also interested in seeing the patch -- the OSD code is
> pretty dense and I couldn't find the EC sparse read handler.

https://github.com/ceph/ceph/pull/66912

Thanks,

                Ilya

