Return-Path: <ceph-devel+bounces-2214-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D74569DBBE0
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 18:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CF7E1623EC
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 17:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF2A1C1741;
	Thu, 28 Nov 2024 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rHIRLOjM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DCF1C173D
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732815790; cv=none; b=nDuj8k4kBjA0xgkDF/BFpKfcJnWBHWQgeVAQMd1B2A/JAlcqkQX+duhMMJx2SsBijA031MSyZwEdG8hTaa3J0Vep1e1RtHutv53S4qn2+64QFv/yVjMnvLfmzhYZZmqkqYFVrW4qFWCkALDitIZT8AgXnHkC0zAzd7dvsYs8zUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732815790; c=relaxed/simple;
	bh=RjReZj0QDzpFI7Q/vMsPmi2g8ogk0HU+HpzCZa4NdQ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=muIAkCj6bKVbZ3IDXDsF7BLVsYR7PWyWQ8dZORn88MQawKBNRR/n+NIu33LH++zlGFO9K4CHqdeajvzcxxaXHRZU7qonok0yHJTShN1h7MSwyYmYgU1XXO1N21qzPBO0i5qLNTs1rA7xRpIoWpcElaG+1Hqst1dggjppevmlLXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rHIRLOjM; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732815785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UTJusEyLcdkeaTqu07tNbbd+H/RHd4566STj5QW1iJE=;
	b=rHIRLOjMokzLXIcWoYkQRZQAdNEhxX+svwO+8hBUAEc+JHJic39XNTIjjguYhIPP/hLHYw
	Ycb/qKvZ7XzV/eVsO3eFIoCkrRR1RtKBCtjpNza7rqj/OTiLw1imLltN2XvnGsQYETP9Z1
	8nhCy5k1PXkiRZKVVcZ3mRyKKIAmZdw=
From: Luis Henriques <luis.henriques@linux.dev>
To: Alex Markuze <amarkuze@redhat.com>
Cc: Luis Henriques <luis.henriques@linux.dev>,  Goldwyn Rodrigues
 <rgoldwyn@suse.de>,  Xiubo Li <xiubli@redhat.com>,  Ilya Dryomov
 <idryomov@gmail.com>,  ceph-devel@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
In-Reply-To: <CAO8a2SjWXbVxDy4kcKF6JSesB=_QEfb=ZfPbwXpiY_GUuwA8zQ@mail.gmail.com>
	(Alex Markuze's message of "Wed, 27 Nov 2024 15:47:02 +0200")
References: <yvmwdvnfzqz3efyoypejvkd4ihn5viagy4co7f4pquwrlvjli6@t7k6uihd2pp3>
	<87ldxvuwp9.fsf@linux.dev>
	<CAO8a2SjWXbVxDy4kcKF6JSesB=_QEfb=ZfPbwXpiY_GUuwA8zQ@mail.gmail.com>
Date: Thu, 28 Nov 2024 17:42:43 +0000
Message-ID: <87mshj8dbg.fsf@orpheu.olymp>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

Hi Alex,

[ Thank you for looking into this. ]

On Wed, Nov 27 2024, Alex Markuze wrote:

> Hi, Folks.
> AFAIK there is no side effect that can affect MDS with this fix.
> This crash happens following this patch
> "1065da21e5df9d843d2c5165d5d576be000142a6" "ceph: stop copying to iter
> at EOF on sync reads".
>
> Per your fix Luis, it seems to address only the cases when i_size goes
> to zero but can happen anytime the `i_size` goes below  `off`.
> I propose fixing it this way:

Hmm... you're probably right.  I didn't see this happening, but I guess it
could indeed happen.

> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4b8d59ebda00..19b084212fee 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>         if (ceph_inode_is_shutdown(inode))
>                 return -EIO;
>
> -       if (!len)
> +       if (!len || !i_size)
>                 return 0;
>         /*
>          * flush any page cache pages in this range.  this
> @@ -1200,12 +1200,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>                 }
>
>                 idx =3D 0;
> -               if (ret <=3D 0)
> -                       left =3D 0;

Right now I don't have any means for testing this patch.  However, I don't
think this is completely correct.  By removing the above condition you're
discarding cases where an error has occurred (i.e. where ret is negative).

Why not simply modify my patch and do:

		if (i_size < off)
			ret =3D 0;

instead of:
		if (i_size =3D=3D 0)
			ret =3D 0;

?

(Again, totally untested!)

Cheers,
--=20
Lu=C3=ADs

> -               else if (off + ret > i_size)
> -                       left =3D i_size - off;
> +               if (off + ret > i_size)
> +                       left =3D (i_size > off) ? i_size - off : 0;
>                 else
> -                       left =3D ret;
> +                       left =3D (ret > 0) ? ret : 0;
> +
>                 while (left > 0) {
>                         size_t plen, copied;
>
>
> On Thu, Nov 7, 2024 at 1:09=E2=80=AFPM Luis Henriques <luis.henriques@lin=
ux.dev> wrote:
>>
>> (CC'ing Alex)
>>
>> On Wed, Nov 06 2024, Goldwyn Rodrigues wrote:
>>
>> > Hi Xiubo,
>> >
>> >> BTW, so in the following code:
>> >>
>> >> 1202                 idx =3D 0;
>> >> 1203                 if (ret <=3D 0)
>> >> 1204                         left =3D 0;
>> >> 1205                 else if (off + ret > i_size)
>> >> 1206                         left =3D i_size - off;
>> >> 1207                 else
>> >> 1208                         left =3D ret;
>> >>
>> >> The 'ret' should be larger than '0', right ?
>> >>
>> >> If so we do not check anf fix it in the 'else if' branch instead?
>> >>
>> >> Because currently the read path code won't exit directly and keep
>> >> retrying to read if it found that the real content length is longer t=
han
>> >> the local 'i_size'.
>> >>
>> >> Again I am afraid your current fix will break the MIX filelock semant=
ic ?
>> >
>> > Do you think changing left to ssize_t instead of size_t will
>> > fix the problem?
>> >
>> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> > index 4b8d59ebda00..f8955773bdd7 100644
>> > --- a/fs/ceph/file.c
>> > +++ b/fs/ceph/file.c
>> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode, lo=
ff_t *ki_pos,
>> >       if (ceph_inode_is_shutdown(inode))
>> >               return -EIO;
>> >
>> > -     if (!len)
>> > +     if (!len || !i_size)
>> >               return 0;
>> >       /*
>> >        * flush any page cache pages in this range.  this
>> > @@ -1087,7 +1087,7 @@ ssize_t __ceph_sync_read(struct inode *inode, lo=
ff_t *ki_pos,
>> >               size_t page_off;
>> >               bool more;
>> >               int idx;
>> > -             size_t left;
>> > +             ssize_t left;
>> >               struct ceph_osd_req_op *op;
>> >               u64 read_off =3D off;
>> >               u64 read_len =3D len;
>> >
>>
>> I *think* (although I haven't tested it) that you're patch should work as
>> well.  But I also think it's a bit more hacky: the overflow will still be
>> there:
>>
>>                 if (ret <=3D 0)
>>                         left =3D 0;
>>                 else if (off + ret > i_size)
>>                         left =3D i_size - off;
>>                 else
>>                         left =3D ret;
>>                 while (left > 0) {
>>                         // ...
>>                 }
>>
>> If 'i_size' is '0', 'left' (which is now signed) will now have a negative
>> value in the 'else if' branch and the loop that follows will not be
>> executed.  My version will simply set 'ret' to '0' before this 'if'
>> construct.
>>
>> So, in my opinion, what needs to be figured out is whether this will cau=
se
>> problems on the MDS side or not.  Because on the kernel client, it should
>> be safe to ignore reads to an inode that has size set to '0', even if
>> there's already data available to be read.  Eventually, the inode metada=
ta
>> will get updated and by then we can retry the read.
>>
>> Unfortunately, the MDS continues to be a huge black box for me and the
>> locking code in particular is very tricky.  I'd rather defer this for
>> anyone that is familiar with the code.
>>
>> Cheers,
>> --
>> Lu=C3=ADs
>>

