Return-Path: <ceph-devel+bounces-2215-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1F1D9DBC1B
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 19:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 635DF163D66
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 18:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB2D1BD9CF;
	Thu, 28 Nov 2024 18:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LSS+9YRy"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E0F537F8
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 18:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732817988; cv=none; b=gEKuda6NAfi3wsSz6vTknGIo+JURZCu4REVRe4VBUUlvkbxuzmwn9k/3coOVLp4WjKSENbsbH2cxspJoAs03I6Wir4JUvN5ABoxbK2X7ZI9itlglGxJq2cpJUEEHhRBggL1JbuP+kVrISBXiReMxvZrs4eDnc3ckip6GbbMRPFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732817988; c=relaxed/simple;
	bh=3wVaoWQl30Bqcl8Xk1npalljplWllN2Ye2/yGZMSlFk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g0UhTPXHzwMP/dPUr9a74vfbc7IC7Yd/cKzsblAu83pwL6yvylDz72Zs/0THyqj+D6hXwJ9Q9nWD9vba+on2VYTCD+Xm855SmtJGuEmdi8h+EYKTCNyiOL1m2oX5DLXMJ7APvm2FFenlPNnZx/w9Sh36ndRq46XgIPzJxP/tmm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LSS+9YRy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732817985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5eISIz/Oj12p2h73uef5HQuFnz3PuN01E35x9njK6SU=;
	b=LSS+9YRycY9SFunoKudqBKZdjLr05i/uGvjUW6V93Vw6wVLQuC67tRAG5hPOwFBC9livmW
	3UuX5Zm9M/lyTX9qYapHwlTCw8/Xtu6sYFqiKOSzUyMZ0c7D74EKsYocMM+SdWXoYKzO7Z
	E/MqzbURwYh4/qA8jj36FWD8/XdDIdM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-JukOwQDIPviFIt1Ii_jcvw-1; Thu, 28 Nov 2024 13:19:43 -0500
X-MC-Unique: JukOwQDIPviFIt1Ii_jcvw-1
X-Mimecast-MFC-AGG-ID: JukOwQDIPviFIt1Ii_jcvw
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d0214ba84eso740608a12.2
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 10:19:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732817982; x=1733422782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5eISIz/Oj12p2h73uef5HQuFnz3PuN01E35x9njK6SU=;
        b=FdnSWEyh0tyFngzH2uTpBmGEER/s579S5q0uvDKO/F0b8iqHapgfKAG+E4KUM33pdP
         NtyjyT/hG2vIt0CvZ/o33545zu0va/t0ZGnsDIRxWmDsPkYqb4YUHoSyPwW1bD/G+BMV
         TcZAoDTiNWOdotsxBjA7LaE8QiczuZ4IbI6KhF1fwS/DiNeSOa9G73faqzIeGI3FTvUj
         nzqi6du+gI1a8gCSy5TBDoXobKSW06htWF2TgEikChJdb4bdd5HW+ZCAm0JrJmPtaaoh
         y9BbQZb43LfvG1CoC6k8sR3GYyBGYyfTKckTm1+EC912zyAXjssv+2jTs9SxGktAa5lH
         wviQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8S9WfcXDswHssxCnbMH2QsvcbkveH6zYa4hF8FO+CI9dTDx/Figl/5Er1rHJc6X9slejfTQHlJe3K@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb4NJ0qfRm8rUozo+JD6DwNB76KWV4IBu34GMgPoCACjOUNyvc
	9RnU6Rn87bImP0W1itkS982ELWMir7XfjyG5nAwb0Smj6CaFMXe3TUXRTJ3fvFFeRzBeYthJIwR
	Yx5Nf65ceu+toGBzSuRZXUmZeIRqjzRggf94VIyynA7LfR0I4NeyBU8C4bhutiLc+9zf+POacfn
	LPc+zh3eexBzg3l7GrwFRyq5LMuQQ3EzLA6w==
X-Gm-Gg: ASbGncsTQ/pusfZX9jroqImMbqOZBAT5I8Q4RzuCuRY5OhX1iVGbrqio0j0U1u2dJCH
	//kGNI089lrYQLdwL0K2R2Biq0QHrKic=
X-Received: by 2002:a05:6402:2353:b0:5cf:d198:2a54 with SMTP id 4fb4d7f45d1cf-5d080c56e0cmr6278042a12.19.1732817982356;
        Thu, 28 Nov 2024 10:19:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6Y17PccYhgLF3ikhUf60nm9eQEDIn7kEWr91epvYCd5hqXPZAosgQP3Qmz0y4mFeUf0xT1hA4zKUuRiht4ok=
X-Received: by 2002:a05:6402:2353:b0:5cf:d198:2a54 with SMTP id
 4fb4d7f45d1cf-5d080c56e0cmr6278023a12.19.1732817981971; Thu, 28 Nov 2024
 10:19:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <yvmwdvnfzqz3efyoypejvkd4ihn5viagy4co7f4pquwrlvjli6@t7k6uihd2pp3>
 <87ldxvuwp9.fsf@linux.dev> <CAO8a2SjWXbVxDy4kcKF6JSesB=_QEfb=ZfPbwXpiY_GUuwA8zQ@mail.gmail.com>
 <87mshj8dbg.fsf@orpheu.olymp>
In-Reply-To: <87mshj8dbg.fsf@orpheu.olymp>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 28 Nov 2024 20:19:31 +0200
Message-ID: <CAO8a2SjHq0hi22QdmaTH2E_c1vP2qHvy7JWE3E1+y3VhEWbDaw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I didn't discard it though :).
I folded it into the `if` statement. I find the if else construct
overly verbose and cumbersome.

+                       left =3D (ret > 0) ? ret : 0;

On Thu, Nov 28, 2024 at 7:43=E2=80=AFPM Luis Henriques <luis.henriques@linu=
x.dev> wrote:
>
> Hi Alex,
>
> [ Thank you for looking into this. ]
>
> On Wed, Nov 27 2024, Alex Markuze wrote:
>
> > Hi, Folks.
> > AFAIK there is no side effect that can affect MDS with this fix.
> > This crash happens following this patch
> > "1065da21e5df9d843d2c5165d5d576be000142a6" "ceph: stop copying to iter
> > at EOF on sync reads".
> >
> > Per your fix Luis, it seems to address only the cases when i_size goes
> > to zero but can happen anytime the `i_size` goes below  `off`.
> > I propose fixing it this way:
>
> Hmm... you're probably right.  I didn't see this happening, but I guess i=
t
> could indeed happen.
>
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 4b8d59ebda00..19b084212fee 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >         if (ceph_inode_is_shutdown(inode))
> >                 return -EIO;
> >
> > -       if (!len)
> > +       if (!len || !i_size)
> >                 return 0;
> >         /*
> >          * flush any page cache pages in this range.  this
> > @@ -1200,12 +1200,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
> > loff_t *ki_pos,
> >                 }
> >
> >                 idx =3D 0;
> > -               if (ret <=3D 0)
> > -                       left =3D 0;
>
> Right now I don't have any means for testing this patch.  However, I don'=
t
> think this is completely correct.  By removing the above condition you're
> discarding cases where an error has occurred (i.e. where ret is negative)=
.
>
> Why not simply modify my patch and do:
>
>                 if (i_size < off)
>                         ret =3D 0;
>
> instead of:
>                 if (i_size =3D=3D 0)
>                         ret =3D 0;
>
> ?
>
> (Again, totally untested!)
>
> Cheers,
> --
> Lu=C3=ADs
>
> > -               else if (off + ret > i_size)
> > -                       left =3D i_size - off;
> > +               if (off + ret > i_size)
> > +                       left =3D (i_size > off) ? i_size - off : 0;
> >                 else
> > -                       left =3D ret;
> > +                       left =3D (ret > 0) ? ret : 0;
> > +
> >                 while (left > 0) {
> >                         size_t plen, copied;
> >
> >
> > On Thu, Nov 7, 2024 at 1:09=E2=80=AFPM Luis Henriques <luis.henriques@l=
inux.dev> wrote:
> >>
> >> (CC'ing Alex)
> >>
> >> On Wed, Nov 06 2024, Goldwyn Rodrigues wrote:
> >>
> >> > Hi Xiubo,
> >> >
> >> >> BTW, so in the following code:
> >> >>
> >> >> 1202                 idx =3D 0;
> >> >> 1203                 if (ret <=3D 0)
> >> >> 1204                         left =3D 0;
> >> >> 1205                 else if (off + ret > i_size)
> >> >> 1206                         left =3D i_size - off;
> >> >> 1207                 else
> >> >> 1208                         left =3D ret;
> >> >>
> >> >> The 'ret' should be larger than '0', right ?
> >> >>
> >> >> If so we do not check anf fix it in the 'else if' branch instead?
> >> >>
> >> >> Because currently the read path code won't exit directly and keep
> >> >> retrying to read if it found that the real content length is longer=
 than
> >> >> the local 'i_size'.
> >> >>
> >> >> Again I am afraid your current fix will break the MIX filelock sema=
ntic ?
> >> >
> >> > Do you think changing left to ssize_t instead of size_t will
> >> > fix the problem?
> >> >
> >> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> >> > index 4b8d59ebda00..f8955773bdd7 100644
> >> > --- a/fs/ceph/file.c
> >> > +++ b/fs/ceph/file.c
> >> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, =
loff_t *ki_pos,
> >> >       if (ceph_inode_is_shutdown(inode))
> >> >               return -EIO;
> >> >
> >> > -     if (!len)
> >> > +     if (!len || !i_size)
> >> >               return 0;
> >> >       /*
> >> >        * flush any page cache pages in this range.  this
> >> > @@ -1087,7 +1087,7 @@ ssize_t __ceph_sync_read(struct inode *inode, =
loff_t *ki_pos,
> >> >               size_t page_off;
> >> >               bool more;
> >> >               int idx;
> >> > -             size_t left;
> >> > +             ssize_t left;
> >> >               struct ceph_osd_req_op *op;
> >> >               u64 read_off =3D off;
> >> >               u64 read_len =3D len;
> >> >
> >>
> >> I *think* (although I haven't tested it) that you're patch should work=
 as
> >> well.  But I also think it's a bit more hacky: the overflow will still=
 be
> >> there:
> >>
> >>                 if (ret <=3D 0)
> >>                         left =3D 0;
> >>                 else if (off + ret > i_size)
> >>                         left =3D i_size - off;
> >>                 else
> >>                         left =3D ret;
> >>                 while (left > 0) {
> >>                         // ...
> >>                 }
> >>
> >> If 'i_size' is '0', 'left' (which is now signed) will now have a negat=
ive
> >> value in the 'else if' branch and the loop that follows will not be
> >> executed.  My version will simply set 'ret' to '0' before this 'if'
> >> construct.
> >>
> >> So, in my opinion, what needs to be figured out is whether this will c=
ause
> >> problems on the MDS side or not.  Because on the kernel client, it sho=
uld
> >> be safe to ignore reads to an inode that has size set to '0', even if
> >> there's already data available to be read.  Eventually, the inode meta=
data
> >> will get updated and by then we can retry the read.
> >>
> >> Unfortunately, the MDS continues to be a huge black box for me and the
> >> locking code in particular is very tricky.  I'd rather defer this for
> >> anyone that is familiar with the code.
> >>
> >> Cheers,
> >> --
> >> Lu=C3=ADs
> >>
>


