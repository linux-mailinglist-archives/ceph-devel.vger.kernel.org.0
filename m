Return-Path: <ceph-devel+bounces-2218-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AAE89DBC7C
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 20:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE147B21884
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 19:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020B919D06A;
	Thu, 28 Nov 2024 19:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CnKDMe9F"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A57AD4B
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 19:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732822335; cv=none; b=E2NMjYgDy6+fFqBq+EswZZMi4TrmO1f/ODkIdrGTg8uoy5L4tZ+dQsF/DBgZVk+Lc0cErJB6PZ/0EovUCIL/+W+Pm49iSpF35VV7u0e3imHTb4YPvtHaiooAP3P776Ht6nIsQvrZ9zhZ9SPLSB0QaO65DLPR7+yHqyEOqQxELn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732822335; c=relaxed/simple;
	bh=5VOk4BWNzM21NcthJLtbPq/g7KfrkwseQgPCCNEeTV4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S0nRDIy/YHI7qL7zf0/Sk8I088O2LV7TqT5gUAWaohceqo6tSIl64fP8hy1Z+iV1hRH9hgwQ5GFSHJjceKYTjKdoUqUaHea690+5FB5cvQr2opD2wApQl8T3XZ1W7oNbuYp+JcuTqNMdTkjGdHIl/OfwMm2HSJc53pcGNArUTj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CnKDMe9F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732822332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EnVQUfZl331CO9eUo/BiP0d+bcV7TULQB+5mR8nOQ+c=;
	b=CnKDMe9FtCIlIYkqvUf+rI2X184gYGQLUwT/D/3+JPLgdjLaoxLkUiHz975HktclmVjfid
	WOg/eKnXnkXMvZC8U8bJiOyDnCXFGv3vT565qeYs36eBXh9C+1NVY0POOGxseV+HOo0IBu
	eqsSbP9VpXKVuP5U+xp+FqMcD0wkPyc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-sMoBQzmrPKSW7FuGpZHFwQ-1; Thu, 28 Nov 2024 14:32:11 -0500
X-MC-Unique: sMoBQzmrPKSW7FuGpZHFwQ-1
X-Mimecast-MFC-AGG-ID: sMoBQzmrPKSW7FuGpZHFwQ
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d0ae45646eso47252a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 11:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732822330; x=1733427130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EnVQUfZl331CO9eUo/BiP0d+bcV7TULQB+5mR8nOQ+c=;
        b=Ijm0PGuqzKqTipSSaDiqITbHgvaTcO4PL7JXaLdf17YlYkVl6t75SnVTX/wdM1Bhvy
         jE0bCV6J96lrWydmXn5otXfWwjA/tCgSAHVCc9E8DV+s/fQEm0cuKHiYrPuyM+L01yxT
         B3NCcGylJBTo6OG6HWcGDAd9pVJNb5c4zBZns4ki52iPdKapM3wzXfxMiXqf9CWtV0xq
         IIf00RfOcdvoHAqF33CunupdHw5gNqhkUmRUV4PKyLr4Qd25b9BH60zrCjz+6TGijfo+
         OLA5U4awldsYjmj/8uHtESdSGzcmiYZpvdPmUogx0XOvn8xZuD5HDsn9ROY/wMFWDFR6
         4UsA==
X-Forwarded-Encrypted: i=1; AJvYcCU9G+KgtX7r/C9SQnaeKKaPPedY7Ce39D2q8wjjtTERQz2p9af3NuOGyyQdQasURJT3KJYgTbw+sjCK@vger.kernel.org
X-Gm-Message-State: AOJu0YzKjWioDNd09jIRySxLKNi9K975yXLb0uxs8XVIDeqwEMI99laT
	jpDCwQrhQldDb6Z9JJeR2MElHlUE3kOWZcfu1URmkOV/1/4yYJ87oVelIzMS7usSLxPcWMJYE2H
	aJweOA7X1UnIb9AsQCq+ZG1Ksl09kWHg6yutSHzEiRrUcXQHjlI/OuslBrrz3Tp9Ysq8yyMfzXF
	/K0E0ozVrGhr+uMhVLrRADYd+oW9l0gIKjMw==
X-Gm-Gg: ASbGncv1Iitq53AIqDdlQPrfcep7e2J5e0LWZeBEl7dm7MlE+gPIh34XJMMrc1OvFei
	6D++KdO9qIKc5QbaOXIdIIpVlGKtAx3o=
X-Received: by 2002:a05:6402:27d0:b0:5d0:96ba:dae0 with SMTP id 4fb4d7f45d1cf-5d096bae26fmr3706736a12.8.1732822329760;
        Thu, 28 Nov 2024 11:32:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeqJ10Y0BmU+FbLE6SyhfL2eC+8APugg8SkHo0kLc4JSg/0ouQGW8uaRdFqdUbZT7BR8nzHDZgvGv3wlnF1yw=
X-Received: by 2002:a05:6402:27d0:b0:5d0:96ba:dae0 with SMTP id
 4fb4d7f45d1cf-5d096bae26fmr3706721a12.8.1732822329451; Thu, 28 Nov 2024
 11:32:09 -0800 (PST)
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
In-Reply-To: <CAO8a2SgMLurHP=o_ENbvOFMci8bcX0TP_18rbjrYJSbmV9CrMA@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 28 Nov 2024 21:31:58 +0200
Message-ID: <CAO8a2ShzHuTizjY+T+RNr28XLGOJPNoXJf1rQUburMBVwJywMA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This patch does three things:

1. The allocated pages are bound to the request, simplifying the
memory management especially on the bad path.
2. ret is checked at the earliest point instead of being carried
through the loop.
3. The overflow bug is fixed.

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..9522d5218c04 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
        if (ceph_inode_is_shutdown(inode))
                return -EIO;

-       if (!len)
+       if (!len || !i_size)
                return 0;
        /*
         * flush any page cache pages in this range.  this
@@ -1086,7 +1086,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                int num_pages;
                size_t page_off;
                bool more;
-               int idx;
+               int idx =3D 0;
                size_t left;
                struct ceph_osd_req_op *op;
                u64 read_off =3D off;
@@ -1127,7 +1127,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,

                osd_req_op_extent_osd_data_pages(req, 0, pages, read_len,
                                                 offset_in_page(read_off),
-                                                false, false);
+                                                false, true);

                op =3D &req->r_ops[0];
                if (sparse) {
@@ -1160,7 +1160,15 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                else if (ret =3D=3D -ENOENT)
                        ret =3D 0;

-               if (ret > 0 && IS_ENCRYPTED(inode)) {
+               if (ret < 0) {
+                       ceph_osdc_put_request(req);
+
+                       if (ret =3D=3D -EBLOCKLISTED)
+                               fsc->blocklisted =3D true;
+                       break;
+               }
+
+               if (IS_ENCRYPTED(inode)) {
                        int fret;

                        fret =3D ceph_fscrypt_decrypt_extents(inode, pages,
@@ -1186,10 +1194,8 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                        ret =3D min_t(ssize_t, fret, len);
                }

-               ceph_osdc_put_request(req);
-
                /* Short read but not EOF? Zero out the remainder. */
-               if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
+               if (ret < len && (off + ret < i_size)) {
                        int zlen =3D min(len - ret, i_size - off - ret);
                        int zoff =3D page_off + ret;

@@ -1199,13 +1205,11 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                        ret +=3D zlen;
                }

-               idx =3D 0;
-               if (ret <=3D 0)
-                       left =3D 0;
-               else if (off + ret > i_size)
-                       left =3D i_size - off;
+               if (off + ret > i_size)
+                       left =3D (i_size > off) ? i_size - off : 0;
                else
                        left =3D ret;
+
                while (left > 0) {
                        size_t plen, copied;

@@ -1221,13 +1225,8 @@ ssize_t __ceph_sync_read(struct inode *inode,
loff_t *ki_pos,
                                break;
                        }
                }
-               ceph_release_page_vector(pages, num_pages);

-               if (ret < 0) {
-                       if (ret =3D=3D -EBLOCKLISTED)
-                               fsc->blocklisted =3D true;
-                       break;
-               }
+               ceph_osdc_put_request(req);

                if (off >=3D i_size || !more)
                        break;

On Thu, Nov 28, 2024 at 9:09=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
>
> Good catch, I'm reworking the ergonomics of this function, this ret
> error code is checked and carried through the loop and checked every
> other line.
>
> On Thu, Nov 28, 2024 at 8:53=E2=80=AFPM Luis Henriques <luis.henriques@li=
nux.dev> wrote:
> >
> > Hi!
> >
> > On Thu, Nov 28 2024, Alex Markuze wrote:
> > > On Thu, Nov 28, 2024 at 7:43=E2=80=AFPM Luis Henriques <luis.henrique=
s@linux.dev> wrote:
> > >>
> > >> Hi Alex,
> > >>
> > >> [ Thank you for looking into this. ]
> > >>
> > >> On Wed, Nov 27 2024, Alex Markuze wrote:
> > >>
> > >> > Hi, Folks.
> > >> > AFAIK there is no side effect that can affect MDS with this fix.
> > >> > This crash happens following this patch
> > >> > "1065da21e5df9d843d2c5165d5d576be000142a6" "ceph: stop copying to =
iter
> > >> > at EOF on sync reads".
> > >> >
> > >> > Per your fix Luis, it seems to address only the cases when i_size =
goes
> > >> > to zero but can happen anytime the `i_size` goes below  `off`.
> > >> > I propose fixing it this way:
> > >>
> > >> Hmm... you're probably right.  I didn't see this happening, but I gu=
ess it
> > >> could indeed happen.
> > >>
> > >> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > >> > index 4b8d59ebda00..19b084212fee 100644
> > >> > --- a/fs/ceph/file.c
> > >> > +++ b/fs/ceph/file.c
> > >> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode=
,
> > >> > loff_t *ki_pos,
> > >> >         if (ceph_inode_is_shutdown(inode))
> > >> >                 return -EIO;
> > >> >
> > >> > -       if (!len)
> > >> > +       if (!len || !i_size)
> > >> >                 return 0;
> > >> >         /*
> > >> >          * flush any page cache pages in this range.  this
> > >> > @@ -1200,12 +1200,11 @@ ssize_t __ceph_sync_read(struct inode *ino=
de,
> > >> > loff_t *ki_pos,
> > >> >                 }
> > >> >
> > >> >                 idx =3D 0;
> > >> > -               if (ret <=3D 0)
> > >> > -                       left =3D 0;
> > >>
> > >> Right now I don't have any means for testing this patch.  However, I=
 don't
> > >> think this is completely correct.  By removing the above condition y=
ou're
> > >> discarding cases where an error has occurred (i.e. where ret is nega=
tive).
> > >
> > > I didn't discard it though :).
> > > I folded it into the `if` statement. I find the if else construct
> > > overly verbose and cumbersome.
> > >
> > > +                       left =3D (ret > 0) ? ret : 0;
> > >
> >
> > Right, but with your patch, if 'ret < 0', we could still hit the first
> > branch instead of that one:
> >
> >                 if (off + ret > i_size)
> >                         left =3D (i_size > off) ? i_size - off : 0;
> >                 else
> >                         left =3D (ret > 0) ? ret : 0;
> >
> > Cheers,
> > --
> > Lu=C3=ADs
> >


