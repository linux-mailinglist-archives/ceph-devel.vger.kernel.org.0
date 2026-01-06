Return-Path: <ceph-devel+bounces-4264-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DEDECF6EE7
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 07:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 397C8301AE0A
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 06:53:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449E43009C1;
	Tue,  6 Jan 2026 06:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKmoAYrc"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5326D2C11E4
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 06:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682421; cv=none; b=L/U4uwXF8oQ+2zKxRDMCzCGnjtsDAwnAttTSgEwHanffIIAB6ABtMf55JDRK2ClYWGDU/D4z7W0yaCq9yu77E5xxGX3pUdK3p+NBOdrvSzTyEsNkNTrshwc9Z6pRdpbXs8o6lQGRfU2C70P2hjbSdrHTGN5X6/lJ72hk6Ypm/PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682421; c=relaxed/simple;
	bh=yI2uKGGWact6aw8Quq2svhMk8YRVXCsIc0sLg9mWNFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nRpLwjz9DLATd7gxqXGjNPNvQmwsXbf/cSXXsg1PT3t6SK/2MQmefarizMS/AAqz9SAbGJuOqeSEI732+25/FbeEoN5AeYJM42bK0brSklL9rv88t8NM4lL16yEBHDfQ+CHPmONr0z8bcwvYIl7ljOnX3Yf+o4ZYXuto7cw75tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKmoAYrc; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4327555464cso321177f8f.1
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 22:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767682418; x=1768287218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLU2SMeJcQK8EmXGGVWWd23Q8mPEEIYZ05BQxSoNnUg=;
        b=KKmoAYrcaxkF6PDMFGcOIZxRA+Ue7oWG8Use5pgWlDjEqTIzb6hyH9Eq15rXADWlbz
         ET51xkYTKpxLfOmjisEJ2mazbtvWvgEMEFrJ7w0w/mU0TSinu+KN4+Gtjqi0TC0H0Y9b
         M6rCl+n045UEhQSTYnVFG0nLomGpJvATaSwIqtG5DJoh3NaT13rYkY4n2pZcDDyndhjA
         y5jgBYPcla9JxFxzjQF/BXz3qlrEGSN8GGgWFvJdZkzt94omv/P5DrPg8rJZlJ28U/Oa
         l/s1RYvRSfcFE27yeM0n12i1evyeQakVUIqP+rkzLqA0zqtcIH2IiGVAOZ8J80icpJq7
         aLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767682418; x=1768287218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WLU2SMeJcQK8EmXGGVWWd23Q8mPEEIYZ05BQxSoNnUg=;
        b=FaTaiO9V65u4BedyJge6aQ32pA1lD3bKK/aBspj3Yo6/RtCdobe+wVSAnW33LUFepe
         ilqZK2YGz/M/BcAaggdr1lCCqxLPGzmpNVB2AYqC8Dhs+GGkb8bwsyzHjDApOmZcGHA5
         SapWKWhKS966eqxIU5xbljKi+1dLdJL3bPxpfTgndwKTrPChaFPobr4k8tLXsBg6wzj3
         sMQzbov9XPdY9/wSiWR315a9uhORpnZTlmfOusVNIqLZS4DnzLUUn9vIalOsx1HnWCbT
         BQS3+4kAj3HW263gGDBzZGPkzERdNMj8vApbjSixKn7lgRHq1UyatQJIswnL1dtwdmGZ
         0iJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpNbpgctkaPGpXyrZPlaLnaTwyNCnD7W+45N4nVvYYvvACFcgT5JX0Ui/cgU+p7IfTlQHh7+JGWG94@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3FdNPZJIUs9l+9x8CzgkQwFMU8sVfYIH+jDzWDasEVXwl8VzF
	qKjFJgeqrYHHhkROTIVXO/qLJHUjp1ZtewgityKvel0dRM0P/wkzgMgnrOnGCgqDJ2MZzXMS3jM
	4V5FCSKLyhq9Ks/Te/24Tu+4JgSVSoc8=
X-Gm-Gg: AY/fxX6bcxqPWgKUK7qtzQSTNuDaiTEtv+5aGnk2ImDXf5DGDh6KRalP+B2WKqv/ukF
	ZKh0NP+M7zHe8I2ISWXaQ7YhknYN77YjGDzr5l+zmxc0WVS1ZtueteMF/6MW95sRus76nAbfi7c
	1iYx4be4IUPtmSCubAwKFm3xhYzfB2WBvg4rJOXYmhXLrrwfb4Xr392niHaAGYXwY31tm9ZXuVL
	yNgj/n7OUgH60ok/gQp2j2/G5X+mcWWeBZikrm/GqFbhGwEytlN8umIE7gq4Z9YZRBo+2Y5MCaP
	Bp0/ut/4eBy00F91BIT1q9IR0PIK
X-Google-Smtp-Source: AGHT+IHnmWsRhvAmhJi01atOVhTVco7Qfzi5gMMpzC9P2bXKgrhvQMwIfLnCc9ASdkf4qP/a/3OdyDg2/KZZ7ogdtKQ=
X-Received: by 2002:a5d:5887:0:b0:431:266:d132 with SMTP id
 ffacd0b85a97d-432bca4a947mr2536178f8f.46.1767682417611; Mon, 05 Jan 2026
 22:53:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-6-CFSworks@gmail.com>
 <912bf88ff3b77203c2df37aa4744139a2ea0a98c.camel@ibm.com>
In-Reply-To: <912bf88ff3b77203c2df37aa4744139a2ea0a98c.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Mon, 5 Jan 2026 22:53:24 -0800
X-Gm-Features: AQt7F2pglkIvwKwPeRALxY2XVk-FbmtxYeP0YLz7UZ-lZb7mhqNJHohdNE6NF4E
Message-ID: <CAH5Ym4j9Sgzng9SUB8ONcX1nLCcdRn7A9G1YbpZXOi3ctQT5BQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] ceph: Fix write storm on fscrypted files
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Milind Changire <mchangir@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 2:34=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > CephFS stores file data across multiple RADOS objects. An object is the
> > atomic unit of storage, so the writeback code must clean only folios
> > that belong to the same object with each OSD request.
> >
> > CephFS also supports RAID0-style striping of file contents: if enabled,
> > each object stores multiple unbroken "stripe units" covering different
> > portions of the file; if disabled, a "stripe unit" is simply the whole
> > object. The stripe unit is (usually) reported as the inode's block size=
.
> >
> > Though the writeback logic could, in principle, lock all dirty folios
> > belonging to the same object, its current design is to lock only a
> > single stripe unit at a time. Ever since this code was first written,
> > it has determined this size by checking the inode's block size.
> > However, the relatively-new fscrypt support needed to reduce the block
> > size for encrypted inodes to the crypto block size (see 'fixes' commit)=
,
> > which causes an unnecessarily high number of write operations (~1024x a=
s
> > many, with 4MiB objects) and grossly degraded performance.

Hi Slava,

> Do you have any benchmarking results that prove your point?

I haven't done any "real" benchmarking for this change. On my setup
(closer to a home server than a typical Ceph deployment), sequential
write throughput increased from ~1.7 to ~66 MB/s with this patch
applied. I don't consider this single datapoint representative, so
rather than presenting it as a general benchmark in the commit
message, I chose the qualitative wording "grossly degraded
performance." Actual impact will vary depending on workload, disk
type, OSD count, etc.

Those curious about the bug's performance impact in their environment
can find out without enabling fscrypt, using: mount -o wsize=3D4096

However, the core rationale for my claim is based on principles, not
on measurements: batching writes into fewer operations necessarily
spreads per-operation overhead across more bytes. So this change
removes an artificial per-op bottleneck on sequential write
performance. The exact impact varies, but the patch does improve
(fscrypt-enabled) write throughput in nearly every case.

Warm regards,
Sam


>
> Thanks,
> Slava.
>
> >
> > Fix this (and clarify intent) by using i_layout.stripe_unit directly in
> > ceph_define_write_size() so that encrypted inodes are written back with
> > the same number of operations as if they were unencrypted.
> >
> > Fixes: 94af0470924c ("ceph: add some fscrypt guardrails")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > ---
> >  fs/ceph/addr.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index b3569d44d510..cb1da8e27c2b 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1000,7 +1000,8 @@ unsigned int ceph_define_write_size(struct addres=
s_space *mapping)
> >  {
> >       struct inode *inode =3D mapping->host;
> >       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
> > -     unsigned int wsize =3D i_blocksize(inode);
> > +     struct ceph_inode_info *ci =3D ceph_inode(inode);
> > +     unsigned int wsize =3D ci->i_layout.stripe_unit;
> >
> >       if (fsc->mount_options->wsize < wsize)
> >               wsize =3D fsc->mount_options->wsize;

