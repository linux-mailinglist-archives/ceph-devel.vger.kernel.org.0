Return-Path: <ceph-devel+bounces-4378-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B08CD1AEF1
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 20:05:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 455AD3041CE0
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jan 2026 19:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C298356A1A;
	Tue, 13 Jan 2026 19:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TmdWURpD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1B73563E3
	for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768331091; cv=none; b=jkydrEel9bDFnY7ppxAEzr9sbACphRUQsJibArOZP1GG7QwfEdJlz+dTIJ99s07G+1ixo4MdA3K/r6CYfJJANJueGhZ9MUJlztSTsv7XFLkEyZfpgB4AmhDjQdAF9eKCLr2223jdOSSmrhEUBKFkBQtImGY5BZdUZcr8rDnTiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768331091; c=relaxed/simple;
	bh=yZiP87EsvsbyryyLG2TOHxTb3MavKqA7SGG63ayroeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LXWJrQ2JdbOuZ0fei+4EfAqEKS+qpJfLLtwvFlVsC/xVjdKVkv3o5CwdxtVltccP727IER1mK8wZjAKG+D5WsmE3ard8tQ6a3fVDtDSJ2wVhi99AbQ8VHd7xlArJdW6StYe8Rw3FpPTAlqV0QMWGmgczF3iGrgTzjKFe+Ww7XK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TmdWURpD; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47ee2715254so1339735e9.3
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jan 2026 11:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768331088; x=1768935888; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OlyFI8pmxNfI7nf9CDMVjXYTjK2uALjN14mZ/chFHew=;
        b=TmdWURpD4lXcFdixigOBM45wtomWAjI6L0psSAvOTNqYk/BKLUwneFB6vvrJfDsX5m
         cJFEvW8K0Be2LH4y021uJTpVbm9Rt9F+Hl7PgQE1Se6AD7pktc/eSM6M+BZ++sRUwVZb
         yVoihLFVfCbZWgJWBvTySoXR6+mo+qCJAWcnhhqkpPSmWjbAU1O92MkSeiQqtuMSQ2KG
         RkFF+zf5bXolwvK4KfyvoIA90u71oRk8R2au+iXwFHUK/KL2v5942TuotRQGBVuvnBCe
         4PUYLmDaXqftoI3WoyTR/7EMLBP4eNQaYcs6z6rKc3fd3t3M6gWE7vGTn9P28oSSRwby
         ZROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768331088; x=1768935888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OlyFI8pmxNfI7nf9CDMVjXYTjK2uALjN14mZ/chFHew=;
        b=d1JqXsE+7boqXAAEjwZWyF8W4oX4lIrMHehFvBaAZQVhNkPgHU1e5ahNFHTIAp2J8V
         2Z+O0ZuybWwGZgjxs+6MsZ0TY5mg/KYU4FoOnh8OHrEWU5twbUZO8q/5xQUe3KDk55wf
         bEDnYs1UusJjyDpqZqGfKX3SELHQHLu/JVBOSOIbSAuNfsM2ArNwfpZVImldolo18TEb
         44jRoG9ho7IZ8teHHYRfotIDWmu9B44F/9Jp2wtLrKnmxoUCHtacMFP4w7MsxK7SnqcQ
         Pz4Azj7IWtb0VNhvZ/dQQIQGWS3Qlnk+LJouG2huynGKQmtbpJMcqX6qnJ+C+hK8bxKc
         ylKA==
X-Forwarded-Encrypted: i=1; AJvYcCXCLeu0uNCSVsapj6dYtq47B9v7Be4VG1AlFl9KCDROHEje7QIsbe1ZcpqZmBMQicgiv8KOZ0Uat3hP@vger.kernel.org
X-Gm-Message-State: AOJu0YzPtKo8UXd7ngswT+Xfr7vQOcCHoUNdNkJMY7XLqHnJa3UBTdMT
	QW9y23RDi9bvCSiGe4cGfKmmvqt9sOxH+nOpZ2xtYezBVOSeS9oXgXjNWED7xBzKvJIibia2ZAu
	COJgugh2Qjz3tIgqw6oRZpaM7zH3HDHuPyShE
X-Gm-Gg: AY/fxX5YeBu8SET+943brKrKWx+L7/7k0c6+vPcD+j+wEuZWhHBQZxADKnBYOv57zJ6
	oV9iINafzQ6/KLusotd060Gl/sxgZteNNVMe+6zu8jiM6rw5qANYtNxb/lCrVve/vDxtl/CDNt+
	s2S0IX2InpCSAU/8I5AGAPUj9OmXlroZz1sP6M1O4p78V0evs/D9XNyUDWsf28o4/hc+2gdqgx0
	+iWyTY+V1oycgTm7SJVfGtWsBv/Heay/0n9uY5JTAM4+IjyaocuE21OSaABBmY8LvXuuZWLpoUv
	BwymruK0sArSfDLDeeqZRGUbYpHf
X-Received: by 2002:a05:600c:314f:b0:477:7991:5d1e with SMTP id
 5b1f17b1804b1-47ee335fb15mr2640315e9.25.1768331087856; Tue, 13 Jan 2026
 11:04:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260113033113.149842-1-CFSworks@gmail.com> <CAOi1vP94Eruq7k10fnpA7G+LjEHdxxFvL4jnTeLMqfoxnjrTkw@mail.gmail.com>
In-Reply-To: <CAOi1vP94Eruq7k10fnpA7G+LjEHdxxFvL4jnTeLMqfoxnjrTkw@mail.gmail.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Tue, 13 Jan 2026 11:04:36 -0800
X-Gm-Features: AZwV_QijI2lvibmmsdLwR0mWdq4huOR2pWXtZKnJ-e9G5-peVn_RIMecL_slGFA
Message-ID: <CAH5Ym4gHUG326s8XoBxVExo1ZspSd0n+x3t=+rJ8N9qgjxgGHg@mail.gmail.com>
Subject: Re: [RFC PATCH] libceph: Handle sparse-read replies lacking data length
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2026 at 9:27=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Tue, Jan 13, 2026 at 4:31=E2=80=AFAM Sam Edwards <cfsworks@gmail.com> =
wrote:
> >
> > When the OSD replies to a sparse-read request, but no extents matched
> > the read (because the object is empty, the read requested a region
> > backed by no extents, ...) it is expected to reply with two 32-bit
> > zeroes: one indicating that there are no extents, the other that the
> > total bytes read is zero.
> >
> > In certain circumstances (e.g. on Ceph 19.2.3, when the requested objec=
t
> > is in an EC pool), the OSD sends back only one 32-bit zero. The
> > sparse-read state machine will end up reading something else (such as
> > the data CRC in the footer) and get stuck in a retry loop like:
> >
> >   libceph:  [0] got 0 extents
> >   libceph: data len 142248331 !=3D extent len 0
> >   libceph: osd0 (1)...:6801 socket error on read
> >   libceph: data len 142248331 !=3D extent len 0
> >   libceph: osd0 (1)...:6801 socket error on read
> >
> > This is probably a bug in the OSD, but even so, the kernel must handle
> > it to avoid misinterpreting replies and entering a retry loop.
>
> Hi Sam,
>

Hey Ilya,

> Yes, this is definitely a bug in the OSD (and I also see another
> related bug in the userspace client code above the OSD...).  The
> triggering condition is a sparse read beyond the end of an existing
> object on an EC pool.  19.2.3 isn't the problem -- main branch is
> affected as well.
>
> If this was one of the common paths, I'd support adding some sort of
> a workaround to "handle" this in the kernel client.  However, sparse
> reads are pretty useless on EC pools because they just get converted
> into regular thick reads.  Sparse reads offer potential benefits only
> on replicated pools, but the kernel client doesn't use them by default
> there either.  The sparseread mount option that is necessary for the
> reproducer to work isn't documented and was added purely for testing
> purposes.

Note that the kernel client forces sparse reads when using fscrypt
(see linux-6.18/fs/ceph/addr.c:361) and I encountered this problem
organically as a result. It may still make sense to apply a kernel
workaround.

On the other hand, it sounds like fscrypt+EC is a niche corner case,
we've now established that the OSD is definitely not following the
protocol, and working around this client-side is more involved than
just fixing this in the OSD. So I think simply telling affected users
to update their OSDs is also a reasonable way to handle this.

I'll defer to you.

>
> >
> > Detect this condition when the extent count is zero by checking the
> > `payload_len` field of the op reply. If it is only big enough for the
> > extent count, conclude that the data length is omitted and skip to the
> > next op (which is what the state machine would have done immediately
> > upon reading and validating the data length, if it were present).
> >
> > ---
> >
> > Hi list,
> >
> > RFC: This patch is submitted for comment only. I've tested it for about
> > 2 weeks now and am satisfied that it prevents the hang, but the current
> > approach decodes the entire op reply body while still in the
> > data-gathering step, which is suboptimal; feedback on cleaner
> > alternatives is welcome!
> >
> > I have not searched for nor opened a report with Ceph proper; I'd like =
a
> > second pair of eyes to confirm that this is indeed an OSD bug before I
> > proceed with that.
>
> Let me know if you want me to file a Ceph tracker ticket on your
> behalf.  I have a draft patch for the bug in the OSD and would link it
> in the PR, crediting you as a reporter.

Please do! I'm also interested in seeing the patch -- the OSD code is
pretty dense and I couldn't find the EC sparse read handler.

>
> >
> > Reproducer (Ceph 19.2.3, CephFS with an EC pool already created):
> >   mount -o sparseread ... /mnt/cephfs
> >   cd /mnt/cephfs
> >   mkdir ec/
> >   setfattr -n ceph.dir.layout.pool -v 'cephfs-data-ecpool' ec/
> >   echo 'Hello world' > ec/sparsely-packed
> >   truncate -s 1048576 ec/sparsely-packed
> >   # Read from a hole-backed region via sparse read
> >   dd if=3Dec/sparsely-packed bs=3D16 skip=3D10000 count=3D1 iflag=3Ddir=
ect | xxd
> >   # The read hangs and triggers the retry loop described in the patch
> >
> > Hope this works,
> > Sam
> >
> > PS: I would also like to write a pair of patches to our messenger v1/v2
> > clients to check explicitly that sparse reads consume exactly the numbe=
r
> > of bytes in the data section, as I see there have already been previous
> > bugs (including CVE-2023-52636) where the sparse-read machinery gets ou=
t
> > of sync with the incoming TCP stream. Has this already been proposed?
>
> Not that I'm aware of.  An additional safety net would be welcome as
> long as it doesn't end up too invasive of course.

Time permitting, I'll see about fixing read_partial_message() to use
con->v1.in_base_pos consistently, use that to count data bytes
consumed in sparse reads, and fail with a more specific error_msg when
a length mismatch is detected. (I do not have a plan for messenger v2
yet.)

Regards,
Sam

>
> Thanks,
>
>                 Ilya

