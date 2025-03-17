Return-Path: <ceph-devel+bounces-2948-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 45B7AA65F34
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Mar 2025 21:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 524AF189E8D8
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Mar 2025 20:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929ED1CFBC;
	Mon, 17 Mar 2025 20:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UDYmpzXs"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC13372
	for <ceph-devel@vger.kernel.org>; Mon, 17 Mar 2025 20:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742243506; cv=none; b=MXmWtKf6KJM0cUjzF4Zw7NM0ksPPM/MBWIgAmETOReWdq42Sk5o/v2rE6OjWx13k3F1j5bvwyUPGS5SnZetefMnM4LUOzBFd9Cm0wJN1cpvf+GnvFFmDMh00vxIzHhR2Z2hEp/KldMmv1XM8XGdPQuqw1vxekJWPmruxMZ4OmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742243506; c=relaxed/simple;
	bh=UoRZWC2mA7VY/CusLsl+bQPpXLm+Ud8VpDNQD+W9F/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N3KkQEtkE9RWNTAaMST7o9cTkqxIbbTUJSxXBXU3Mnn31kHp/fg2xHAcfQAE11K46zkFn5zuk1kpkup5gkVx3s2wyZz4g1ZCKJsF1USqDjmWMc0RMlLHK4zQWbx8IBJjvjcGGRJDIsG7RciNO4mUJu1OwrAICnSYeYnKnxpAP9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UDYmpzXs; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-223f4c06e9fso82307525ad.1
        for <ceph-devel@vger.kernel.org>; Mon, 17 Mar 2025 13:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742243504; x=1742848304; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KQJ2C1g7rFQ5fVx+FxmYXnRn8ecbGnU9PGEObv8oAp8=;
        b=UDYmpzXs9Uv4jGY8V46nWBFr/qmGSz6BuIYO49BQg6CL1/kr70YLj4nnqIRqrGpGAE
         ONez3TlV+5sxTzt2cdnanjYB2e3mpfcapKRo2X/m3pRVv1O0FCSpWZaQkN0EBQd5A8sF
         +sF8aaVZv1C0U6kQmSTEpCt2whiHhgtESpCyYvhe2GMpt5XtLDlfvamT1c+t3DhgbATg
         vWEAUwMqJLEi4m4IkIHN7LnVQJgQzeG4pVImy0iQvCBEa45AosKdztywDSaM/4aAtO8/
         ivFwBETVWzXaMY2I1WD9oD/wr3AaSKacePpohpkll6nNgsZc8r83bA98IrnQDRz8zom6
         YWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742243504; x=1742848304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KQJ2C1g7rFQ5fVx+FxmYXnRn8ecbGnU9PGEObv8oAp8=;
        b=prHVzDo5MEB/Q6mrOOGTcSHwI2rTirHp47xZdElJuBkFce7G4abT+J1fDndcLNwzcc
         RL1xf9MoIoZVPv9AsgJWpUhGwrLhSjqyhyrd+Q09WAJDv17StrSaktraU/L/djEAQ/bA
         728S1ZEfvQiPBPkw8wYMXJ4hN/QwYt985Dra5ABAVYBkwiNtZc1c8HMwEQNbWrMzIHB8
         DGfpnb6Nsf2rPZrvG9RYX4AqaMBlBM821OZCo6hmFG4RbF8MY7lFu375ntJlZF5w0CFm
         8GRyGxs3q+FHjz3/rMmJd7/M41x5mCwGTFuNczbqIUo4978J1Evz1JQ0z6HY3dg7OeBZ
         hY0w==
X-Forwarded-Encrypted: i=1; AJvYcCWu5XLZHaQJs7S8J0HmPtaqow2lqc3cC1NH5XD7sjxEcey+9Aai/Aleoqo9uxbB25s3AKz9xu0fPSoa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0fU8xP0IFURY2XOd8RSVR+uuYC9ZoE/ufZhmhqrvN5nzqMxh7
	DEfk5OKfZecMvdT+J9/E424CtjoofhkjGSIbtS68GsT25t/yegJN7C8lbo0uuvmdoWNoqQ7T0Yl
	UdLNhZUwb3KKl6OJp14AxGe6uAWs=
X-Gm-Gg: ASbGncvJskFITjYO6vf9C42w5UmqP0eyKo879HBTy5m3u9uLncQPsJI+ZKw/0mXrJIl
	rsFY96791iiH0Yt0VDNEU14yHfNtuEXIBZTVR4ISGxOFgFGsWz9mWvNyUzP6auvGTg3g9i9BWKj
	+oaVX0E6BaBvCTY2gyVIcyZevoGA==
X-Google-Smtp-Source: AGHT+IEK/m9K2r1o9FvuXWAFNPIPpzSZQH9lIb7vEWET06QHKvlgAxzCcB4QjIz8nl+V6Fb0ZQ8BhJUFY1M2PudaLjY=
X-Received: by 2002:a17:902:d2cc:b0:220:cfb7:56eb with SMTP id
 d9443c01a7336-2262cc394d9mr10462275ad.26.1742243504079; Mon, 17 Mar 2025
 13:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1722309.1741949485@warthog.procyon.org.uk> <CAOi1vP-0yKFKKhy9i2Zmd5coZ59vMMNu2upkZLWvR2sgxWafAw@mail.gmail.com>
 <1771620.1741962570@warthog.procyon.org.uk>
In-Reply-To: <1771620.1741962570@warthog.procyon.org.uk>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 17 Mar 2025 21:31:32 +0100
X-Gm-Features: AQ5f1Jrq59f7dIdxNcgCUQSm5CUkGPKgPiOHZrNTi8ttq9GVa948qugsqEsw2ew
Message-ID: <CAOi1vP-S+Ti24cTUKgMmAxzJUcgZek9iMb+bhn8-bXJJq9EekA@mail.gmail.com>
Subject: Re: What are the I/O boundaries for read/write to a ceph object?
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, Alex Markuze <amarkuze@redhat.com>, 
	Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 14, 2025 at 3:29=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Hi Ilya,
>
> Ilya Dryomov <idryomov@gmail.com> wrote:
>
> > > Can you tell me what the I/O boundaries are for splitting up a read o=
r a
> > > write request into separate subrequests?
> > >
> > > Does each RPC call need to fit within the bounds of an object or does=
 it
> > > need to fit within the bounds of a stripe/block?
> >
> > Within the bounds of a RADOS object.
>
> Okay, thanks.
>
> > > Can a vectored read/write access multiple objects/blocks?
> >
> > I'm not sure what "vectored" means in this context,
>
> Where rather than issuing, say, a read data RPC with a single range to re=
ad, I
> can give it a list of non-contiguous regions to read.  I might do this, f=
or
> example, if the VM issues a readahead request for a non-contiguous set of
> folios that fill in the gaps around a folio already present in the pageca=
che.
>
> > but a single read/write coming from the VFS may need to access multiple
> > RADOS objects.  Assuming that the object size is 4M (default), the simp=
lest
> > example is a request for 8192 bytes at 4190208 offset in the file.
>
> netfslib allows for a request to be split up into a number of subrequests=
,
> where each subrequest can be of a different size and may access a differe=
nt
> server or fscache.  What I need to make the ->prepare_read() function do =
is,
> for the specified starting point in the given file, return how many bytes=
 we
> can possibly read before we have to issue the next subrequest.
>
> I currently have this (note this isn't what is in the patches I posted
> yesterday):
>
>         static int ceph_netfs_prepare_read(struct netfs_io_subrequest *su=
breq)
>         {
>                 struct netfs_io_request *rreq =3D subreq->rreq;
>                 struct ceph_inode_info *ci =3D ceph_inode(rreq->inode);
>                 struct ceph_fs_client *fsc =3D
>                         ceph_inode_to_fs_client(rreq->inode);
>                 const struct ceph_file_layout *layout =3D &ci->i_layout;
>
>                 size_t blocksize =3D layout->stripe_unit;
>                 size_t blockoff =3D subreq->start & (blocksize - 1);
>
>                 /* Truncate the extent at the end of the current block */
>                 rreq->io_streams[0].sreq_max_len =3D
>                         umin(blocksize - blockoff,
>                              fsc->mount_options->rsize);
>
>                 return 0;
>         }
>
> where "rreq->io_streams[0].sreq_max_len" gets set to the maximum length w=
e can
> make the next subrequest.  I've made a number of assumptions here that I =
don't
> know are valid:
>
>  - The I/O block size is the stripe unit size.

Hi David,

This is valid, but operating purely in terms of stripe units won't be
optimal in the general case.  In the example that I gave in the previous
message, you would end up issuing 6 RPCs instead of 5, not recognizing
that the first and last logical blocks of the original 384K request are
contiguous within the first RADOS object and could be done in one go.

"Fancy" striping isn't widely used though, so if implementing it
optimally complicates things too much, I wouldn't sweat it.

>  - Blocks are all the same size.

This is valid (except for the EOF block).

>  - Blocks are a power-of-2 size.

This is NOT valid.  IIRC the constraints are that the stripe unit is
a multiple of 64K and that the object size is a multiple of the stripe
unit.  Technically there is nothing stopping the stripe unit ("block")
from being set to 192K, for example.

>
> > > What I'm trying to do is to avoid using ceph_calc_file_object_mapping=
() as
> > > it does a bunch of 128-bit divisions for which I don't need the answe=
rs.
> > > I only need xlen - and really, I just need the limits of the read or =
write
> > > I can make.
> >
> > I don't think ceph_calc_file_object_mapping() can be avoided in the
> > general case.  With non-default ("fancy") striping, given for example
> > stripe_unit=3D64K and stripe_count=3D5, a single 64K * 6 =3D 384K reque=
st at
> > offset 0 in the file would need to access 5 RADOS objects, with the
> > first object/RPC delivering 128K and the other four objects/RPCs 64K
> > each.
>
> ceph_calc_file_object_mapping() seems to assume that the stripe_unit size=
 and
> the object_size are fixed.  Is this something that might change?

Not after the file is created.  Think of these as immutable file
attributes that affect the data placement.

>
> Would you object to me putting an additional function in libceph next to =
that
> one that just gets me that span of the block containing the specified fil=
e
> position?

Fine with me.

Thanks,

                Ilya

