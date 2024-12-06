Return-Path: <ceph-devel+bounces-2261-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 167279E6E89
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 13:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5EE8281F89
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2024 12:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89C51FC7C0;
	Fri,  6 Dec 2024 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJU7ILLh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239553D6B;
	Fri,  6 Dec 2024 12:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733489449; cv=none; b=Fv5UAxKrSgh+3QPHQNg662hHPFKIVFhGuo03TPa+j8H52u8Qm7PHxmLPa4TBdc76QVsGu86F/RxaYxhHSnKR8Ggvh9TqpGvLYDAOM4kwSRcUN1L2J7CPeocy88gq1bGulbp4FG6pmAsr2+CCU3oGEGE4dAlpiizc+ENuzSWZVHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733489449; c=relaxed/simple;
	bh=XEZyDHk132hZI57xsp0Rf6mJbSdLueVq0jXAyMBO/2I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SiCUFBEgPOrYhyyQJL8i7fLWGcMaXOq6A+u+H/4MCfV37aW7nWRTrJZgXTtflFni6n15Wt0JYur5Ql9ITgYfWhoWH8qNFN7rY54qKbRMQ700CCSTpAgTGidYfVgQkqjI0K5ueCsHJeV8Sx0f1KnAh/77vygnoyaKy5KdHyfGil0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJU7ILLh; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7fd24e274fdso640801a12.2;
        Fri, 06 Dec 2024 04:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733489447; x=1734094247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvnJWSsrkTVTOK9NYAknHMey6BhHTV0eKyyrXxhAy+8=;
        b=TJU7ILLhuKIB+DdZYmNnXK/p+SNbakk71AxgvLrcRnRrQZCrUZ5CPEcT09Wh5kSgIu
         8cGePaouVZAbvm/siKXY3XoCLDO7jWZenC9wqe7LTCZjH3qZVm1viFl5stjZCprjo0OX
         P+5XoOriZ+oPXVcH30IlEW57ugv76w6+A55QCN7s+M3tzU6FM0Bd85QY0+fGUrK1ljAz
         j8/ZY3fcfee2h9ZtfRJ9kWYTtKtnVKg89YD/EMP+q6REaA1KgJ346p/5UQW65Epy64b1
         qhP+5ieQNx8ht9uH/lT8mydH3Izim1gP6NOCREtUgmJAOezZnqosOt/r1YTy+2xD9ksT
         GkgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733489447; x=1734094247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvnJWSsrkTVTOK9NYAknHMey6BhHTV0eKyyrXxhAy+8=;
        b=kPV/gP9TfPaEVZfIESOpF9miDPYLT3FLQEPctBMXAcdyJ8a3ErtHAQ20h18khd6mF0
         erDm/mSSkAoVeyPLJcOg0LrNlP7S1HPrUs/G7avrRy9QhRuwzNX+K54M9swC09xy6jnT
         S6Bjmoe0fh9frWqGM9zyojET25/3xLl02scmP9rct7YmG9fM3F+uyd0+gemmMlk0S3mR
         VifNlHqWtNzOri/2HoBFiLklcKoWHlCBtrMPtWzXt8CjswoeRjPbD6u03Vy96P1kYiYU
         T+/BwL6TPZjk31+yMxoBsU3bMFOle9c44dnyETnc9EL7904UECzCA2ILcxATv3fxC4zH
         TSNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYR1ATRm5tftTH/aALjMzbWeVGOqMKP7t6AHEv8N1b6fB8IXIPTy1uGp7zSc8ApbbVGh2UBECN@vger.kernel.org, AJvYcCVzwWv8EbrnEOvxfth10xLGrvav8UPxjd1O/Q3i44JylE8DbrNIiIt9+udI+AtgRBei9E8yd8bA3zdp@vger.kernel.org, AJvYcCXUK/HJI86OVYRxn8Pv01VLJWxLgkzkVJr1xbmplXBnVtJAexifX8nqKFfTZNnlyqXSEYzO9W+fXhmtH84q@vger.kernel.org
X-Gm-Message-State: AOJu0YxJhMHoJV9+/uB7whT7DN4eAXspzny57/vzJcWLmgTuHKHONW2/
	0mi24NKTh1rvblLMm28tT9xuGUcPmkX3FVPKertkyJ83MBTvT3dRHgKl4m3niPVLNPiBrfnUczO
	DJsA/gAW0TXkWnRRBekf/F8nyU+J+8Q9S
X-Gm-Gg: ASbGnctnCu4MQIut6TEzQ1n0EKMTKMDQI2S3S7i0ZgxlkiRlhQQwfeNw+Vneg/chrf3
	rSuTfBxMyW8TbpnjnKEj+Efq1vpQ2hsY=
X-Google-Smtp-Source: AGHT+IGfoReZyqEHkx2l9Z6yTZIOzjckyeg+BIUhB/ROWL3Ic48D0l/l6lTNNJvqLqnQjmI0031T4Qs+fZHxaDSRsvg=
X-Received: by 2002:a17:90b:17c2:b0:2ee:aa28:79aa with SMTP id
 98e67ed59e1d1-2ef69366eb9mr4867604a91.6.1733489447225; Fri, 06 Dec 2024
 04:50:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
 <20241205154951.4163232-1-max.kellermann@ionos.com> <CAO8a2Si+7uFkOCf4JxCSkLtJR=_nQOYPAZ_WkWES97ifhyHvBQ@mail.gmail.com>
In-Reply-To: <CAO8a2Si+7uFkOCf4JxCSkLtJR=_nQOYPAZ_WkWES97ifhyHvBQ@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 6 Dec 2024 13:50:36 +0100
Message-ID: <CAOi1vP9Ovx1fJ8AH3gPEfeAT1nL3uT98EAngdO=FHtfiem6+3w@mail.gmail.com>
Subject: Re: [PATCH v2] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 5:30=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> w=
rote:
>
> Good.
> This sequence has not been tested independently, but it should be fine.

Applied.

Thanks,

                Ilya

>
> On Thu, Dec 5, 2024 at 5:49=E2=80=AFPM Max Kellermann <max.kellermann@ion=
os.com> wrote:
> >
> > In two `break` statements, the call to ceph_release_page_vector() was
> > missing, leaking the allocation from ceph_alloc_page_vector().
> >
> > Instead of adding the missing ceph_release_page_vector() calls, the
> > Ceph maintainers preferred to transfer page ownership to the
> > `ceph_osd_request` by passing `own_pages=3Dtrue` to
> > osd_req_op_extent_osd_data_pages().  This requires postponing the
> > ceph_osdc_put_request() call until after the block that accesses the
> > `pages`.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > ---
> >  fs/ceph/file.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 4b8d59ebda00..ce342a5d4b8b 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1127,7 +1127,7 @@ ssize_t __ceph_sync_read(struct inode *inode, lof=
f_t *ki_pos,
> >
> >                 osd_req_op_extent_osd_data_pages(req, 0, pages, read_le=
n,
> >                                                  offset_in_page(read_of=
f),
> > -                                                false, false);
> > +                                                false, true);
> >
> >                 op =3D &req->r_ops[0];
> >                 if (sparse) {
> > @@ -1186,8 +1186,6 @@ ssize_t __ceph_sync_read(struct inode *inode, lof=
f_t *ki_pos,
> >                         ret =3D min_t(ssize_t, fret, len);
> >                 }
> >
> > -               ceph_osdc_put_request(req);
> > -
> >                 /* Short read but not EOF? Zero out the remainder. */
> >                 if (ret >=3D 0 && ret < len && (off + ret < i_size)) {
> >                         int zlen =3D min(len - ret, i_size - off - ret)=
;
> > @@ -1221,7 +1219,8 @@ ssize_t __ceph_sync_read(struct inode *inode, lof=
f_t *ki_pos,
> >                                 break;
> >                         }
> >                 }
> > -               ceph_release_page_vector(pages, num_pages);
> > +
> > +               ceph_osdc_put_request(req);
> >
> >                 if (ret < 0) {
> >                         if (ret =3D=3D -EBLOCKLISTED)
> > --
> > 2.45.2
> >
>

