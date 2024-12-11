Return-Path: <ceph-devel+bounces-2321-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC4B9ECA71
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 11:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76BB3167CB3
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 10:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4211F0E48;
	Wed, 11 Dec 2024 10:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/Dw3jsf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD7B187872
	for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 10:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733913413; cv=none; b=pVkm2X84EPO1m/lMMm+OoWObApHDD8py2CSAQXOb6LYBLTIAcBN4Ce0AoJ4yOSGIGKj+chGh4P6i1PUrc6PMxEQCPPqK8IoHKWE8cbeEIuhWDv6tBRCParR4oWuNkoyi39MGx1a9xM1qjlUm2txiWQI0HeRXi6L+16aAj1uj2EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733913413; c=relaxed/simple;
	bh=QG/yThXs98ZZa/JDiLiljMIT/owvMMXupz//RaU8MQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C4uaDdqcBIp0CkT7pAQyryYu3sPK5O3hdBQVHJPTIwpKXhhZqp7hPaohbEUB8bZ5Iv9B/reQmnioaqKIOf79Nu4neuO+PfmCXXe8IFrxOX3XEDclWE9h7sXgcnGBK4hG0HoeiocgqK7qObz9+X+o3YSoXCNeCSdIiFXl75C+S3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/Dw3jsf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733913409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CdWb5fGJ5FPtZXDeWsQdCsjlD9SXlRl5cU56yteBmMc=;
	b=V/Dw3jsf904Vmr3k0tK2JsQWkQhbZXeXbW48ip0quMs4zT74gbyKD1bcvl0oZeGA8KWP3y
	kHrd11IYhBT4IVrJIRactgxPKBzwNPn1FyatmveT/Zda2w3qCg22UVNnlIhh2Q+jdF1dA3
	re91cdwQl27eEgktCIs5tTunlHrdncE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-244-rlw1L-lwMkGFosnmEuFLyg-1; Wed, 11 Dec 2024 05:36:48 -0500
X-MC-Unique: rlw1L-lwMkGFosnmEuFLyg-1
X-Mimecast-MFC-AGG-ID: rlw1L-lwMkGFosnmEuFLyg
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa66f6ce6bfso285958766b.2
        for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 02:36:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733913407; x=1734518207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdWb5fGJ5FPtZXDeWsQdCsjlD9SXlRl5cU56yteBmMc=;
        b=m/MrY+Vk2BVp+a/DvKF4dgzJ1J4lDUeDCMqgLxYf/RoIkllhoXlx+YJzKDnxCbDPWz
         F8Nj/jdtc0iIVbopyoiHuaUF3Lb/8Z+ivOuMJG411Y5tTFx1WBBKOB903YCVkjwaXvnM
         gbWFNVisf4qo116XlZGhPWuQjTEMmZve2IOSv161qUb4KKnYBjLCurtObvgFCrGByyHU
         3oawcrUQCMRSpOi2uDNflIMmmMliwpRQjUt4U2wLIAF2B7cKOJ73hgBkTX6oI68AbJgO
         WHRHNwYkvjuScIq1KYXsYv0Kyw5e3eMpv+FEWLOTVnezawH7Se3uy2LA5DHpKYjYLVgb
         0Hbw==
X-Forwarded-Encrypted: i=1; AJvYcCWVbIfKJxl8iNkAFTU/TQSp+IN7kaB44+r2SzBWyXcniBuy52ifqjGYl4tb9di3RAYXO6ATlA2VeVNz@vger.kernel.org
X-Gm-Message-State: AOJu0YzSV5In9dvwQMlPLGmkvTMs0gdPg4nDU8cjmPKEqheTu8UzkGxD
	vSyAbKPhfCtDTHbqnfKgrDa1YXtcPl8qqR0unyC9rNMMPcjqrERl25Pm9Bxc1Yvsmz2IKK+GQwG
	f008M+x5ESllHj47A5RpKW35+ePjwT1UAUqOM/LyJUlBGKVzyPaq9FRdHZPq7NBsXu8T62Cj+MD
	0JNqRbyH1uuh37j+qNa3tHToXVncRhtJ6QQQ==
X-Gm-Gg: ASbGncsW0QjXQ8lYmT/mm631jkwNFhnwl8iG72tgXnUPwPyHlovpGAkmUfeEGc+nGx4
	dvYuZMxXMi2VID9qg6cbeJgh681ldd34Or9s=
X-Received: by 2002:a17:907:7806:b0:aa6:86d1:c3fe with SMTP id a640c23a62f3a-aa6b10f597fmr203511366b.4.1733913407325;
        Wed, 11 Dec 2024 02:36:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFU21SkbNdBsy36aA1H/6vo5DKeaZdo5uu/Ns2PdBzpkF9S514ffAr8hMu6zEVqCTGc7M8X45QJz4+hYhOF3/s=
X-Received: by 2002:a17:907:7806:b0:aa6:86d1:c3fe with SMTP id
 a640c23a62f3a-aa6b10f597fmr203509266b.4.1733913406879; Wed, 11 Dec 2024
 02:36:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <yvmwdvnfzqz3efyoypejvkd4ihn5viagy4co7f4pquwrlvjli6@t7k6uihd2pp3>
 <87ldxvuwp9.fsf@linux.dev> <CAO8a2SjWXbVxDy4kcKF6JSesB=_QEfb=ZfPbwXpiY_GUuwA8zQ@mail.gmail.com>
 <87mshj8dbg.fsf@orpheu.olymp> <CAO8a2SjHq0hi22QdmaTH2E_c1vP2qHvy7JWE3E1+y3VhEWbDaw@mail.gmail.com>
 <87zflj6via.fsf@orpheu.olymp> <CAO8a2SgMLurHP=o_ENbvOFMci8bcX0TP_18rbjrYJSbmV9CrMA@mail.gmail.com>
 <CAO8a2ShzHuTizjY+T+RNr28XLGOJPNoXJf1rQUburMBVwJywMA@mail.gmail.com>
In-Reply-To: <CAO8a2ShzHuTizjY+T+RNr28XLGOJPNoXJf1rQUburMBVwJywMA@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 11 Dec 2024 12:36:35 +0200
Message-ID: <CAO8a2ShL4MccFRfVOsmq+pc6AxyVYvZbL=cQRDSDRQC8044pLQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Folks, this is the fix please add your reviews:

https://marc.info/?l=3Dceph-devel&m=3D173367895206137&w=3D2

On Thu, Nov 28, 2024 at 9:31=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> This patch does three things:
>
> 1. The allocated pages are bound to the request, simplifying the
> memory management especially on the bad path.
> 2. ret is checked at the earliest point instead of being carried
> through the loop.
> 3. The overflow bug is fixed.
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4b8d59ebda00..9522d5218c04 100644
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
> @@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>                 int num_pages;
>                 size_t page_off;
>                 bool more;
> -               int idx;
> +               int idx =3D 0;
>                 size_t left;
>                 struct ceph_osd_req_op *op;
>                 u64 read_off =3D off;
> @@ -1127,7 +1127,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>
>                 osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
>                                                  offset_in_page(read_off)=
,
> -                                                false, false);
> +                                                false, true);
>
>                 op =3D &req->r_ops[0];
>                 if (sparse) {
> @@ -1160,7 +1160,15 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>                 else if (ret =3D=3D -ENOENT)
>                         ret =3D 0;
>
> -               if (ret > 0 && IS_ENCRYPTED(inode)) {
> +               if (ret < 0) {
> +                       ceph_osdc_put_request(req);
> +
> +                       if (ret =3D=3D -EBLOCKLISTED)
> +                               fsc->blocklisted =3D true;
> +                       break;
> +               }
> +
> +               if (IS_ENCRYPTED(inode)) {
>                         int fret;
>
>                         fret =3D ceph_fscrypt_decrypt_extents(inode, page=
s,
> @@ -1186,10 +1194,8 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>                         ret =3D min_t(ssize_t, fret, len);
>                 }
>
> -               ceph_osdc_put_request(req);
> -
>                 /* Short read but not EOF? Zero out the remainder. */
> -               if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
> +               if (ret < len && (off + ret < i_size)) {
>                         int zlen =3D min(len - ret, i_size - off - ret);
>                         int zoff =3D page_off + ret;
>
> @@ -1199,13 +1205,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>                         ret +=3D zlen;
>                 }
>
> -               idx =3D 0;
> -               if (ret <=3D 0)
> -                       left =3D 0;
> -               else if (off + ret > i_size)
> -                       left =3D i_size - off;
> +               if (off + ret > i_size)
> +                       left =3D (i_size > off) ? i_size - off : 0;
>                 else
>                         left =3D ret;
> +
>                 while (left > 0) {
>                         size_t plen, copied;
>
> @@ -1221,13 +1225,8 @@ ssize_t __ceph_sync_read(struct inode *inode,
> loff_t *ki_pos,
>                                 break;
>                         }
>                 }
> -               ceph_release_page_vector(pages, num_pages);
>
> -               if (ret < 0) {
> -                       if (ret =3D=3D -EBLOCKLISTED)
> -                               fsc->blocklisted =3D true;
> -                       break;
> -               }
> +               ceph_osdc_put_request(req);
>
>                 if (off >=3D i_size || !more)
>                         break;
>
> On Thu, Nov 28, 2024 at 9:09=E2=80=AFPM Alex Markuze <amarkuze@redhat.com=
> wrote:
> >
> > Good catch, I'm reworking the ergonomics of this function, this ret
> > error code is checked and carried through the loop and checked every
> > other line.
> >
> > On Thu, Nov 28, 2024 at 8:53=E2=80=AFPM Luis Henriques <luis.henriques@=
linux.dev> wrote:
> > >
> > > Hi!
> > >
> > > On Thu, Nov 28 2024, Alex Markuze wrote:
> > > > On Thu, Nov 28, 2024 at 7:43=E2=80=AFPM Luis Henriques <luis.henriq=
ues@linux.dev> wrote:
> > > >>
> > > >> Hi Alex,
> > > >>
> > > >> [ Thank you for looking into this. ]
> > > >>
> > > >> On Wed, Nov 27 2024, Alex Markuze wrote:
> > > >>
> > > >> > Hi, Folks.
> > > >> > AFAIK there is no side effect that can affect MDS with this fix.
> > > >> > This crash happens following this patch
> > > >> > "1065da21e5df9d843d2c5165d5d576be000142a6" "ceph: stop copying t=
o iter
> > > >> > at EOF on sync reads".
> > > >> >
> > > >> > Per your fix Luis, it seems to address only the cases when i_siz=
e goes
> > > >> > to zero but can happen anytime the `i_size` goes below  `off`.
> > > >> > I propose fixing it this way:
> > > >>
> > > >> Hmm... you're probably right.  I didn't see this happening, but I =
guess it
> > > >> could indeed happen.
> > > >>
> > > >> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > >> > index 4b8d59ebda00..19b084212fee 100644
> > > >> > --- a/fs/ceph/file.c
> > > >> > +++ b/fs/ceph/file.c
> > > >> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *ino=
de,
> > > >> > loff_t *ki_pos,
> > > >> >         if (ceph_inode_is_shutdown(inode))
> > > >> >                 return -EIO;
> > > >> >
> > > >> > -       if (!len)
> > > >> > +       if (!len || !i_size)
> > > >> >                 return 0;
> > > >> >         /*
> > > >> >          * flush any page cache pages in this range.  this
> > > >> > @@ -1200,12 +1200,11 @@ ssize_t __ceph_sync_read(struct inode *i=
node,
> > > >> > loff_t *ki_pos,
> > > >> >                 }
> > > >> >
> > > >> >                 idx =3D 0;
> > > >> > -               if (ret <=3D 0)
> > > >> > -                       left =3D 0;
> > > >>
> > > >> Right now I don't have any means for testing this patch.  However,=
 I don't
> > > >> think this is completely correct.  By removing the above condition=
 you're
> > > >> discarding cases where an error has occurred (i.e. where ret is ne=
gative).
> > > >
> > > > I didn't discard it though :).
> > > > I folded it into the `if` statement. I find the if else construct
> > > > overly verbose and cumbersome.
> > > >
> > > > +                       left =3D (ret > 0) ? ret : 0;
> > > >
> > >
> > > Right, but with your patch, if 'ret < 0', we could still hit the firs=
t
> > > branch instead of that one:
> > >
> > >                 if (off + ret > i_size)
> > >                         left =3D (i_size > off) ? i_size - off : 0;
> > >                 else
> > >                         left =3D (ret > 0) ? ret : 0;
> > >
> > > Cheers,
> > > --
> > > Lu=C3=ADs
> > >


