Return-Path: <ceph-devel+bounces-1535-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA318934332
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jul 2024 22:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08DC4282FD2
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Jul 2024 20:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA2F1849D8;
	Wed, 17 Jul 2024 20:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F8MdDVYn"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7649D33997;
	Wed, 17 Jul 2024 20:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721247984; cv=none; b=dX2lcvs7Z6+NlS55i1L24kX6wzUfDmVsxhXDXrPUaVe5NopqlC0th8RhD64HhEvJGijti6nTN/O0VQ053h2ff8LHL+R6RVM7G9gEDBpQqgSg/xMDU8VvlDVdQFtvpJ+JYrW6B8IJQ6ltVC/BjmNLt7vSX2l3IxaH2DRN1YuVy0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721247984; c=relaxed/simple;
	bh=sEpwm454qhpVCnOenxLpI0TxqK/C6/vZIZluX9S0+DY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U48dwu2WJpcl9CaK9v+ppuYFPtYwKYIQUKsnkq95EtgJsU3k4wrjLSqMjCxECBeGLkWkKZTKOx5LOinFquvHK5SOI7cMhBM5DT6Ot5SFqabwTm42bWSJBZ4saLwwehqKJ2RlvfHihXYvDInehLwyQuAmlH5d7XfFSh/FJpiEQiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F8MdDVYn; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5c651c521f2so15075eaf.1;
        Wed, 17 Jul 2024 13:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721247982; x=1721852782; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ncSYgCH2yObWoew5+X7CbTEVtAMvPgWthTFHHeqOzls=;
        b=F8MdDVYnUd9rxE3x+HJDTXh5rc/euAdwP8HcYJwXPywvl8trfU2HD7EhkQ7vyGHLhc
         W45ab7idzdutIxyCAEf1HUtl6v34ZO85KUhTnpouCutjMWYC2xlbP28M49DiZtuy39ID
         8MMZb6libjr4N8XWo+Lw4RCMZWdolB0RFs8/Bfde0LN3IzkcVr0Jxd7k4uIF9oBk6BCs
         0bNL2hoaX+xAlCxfFMyZxlcMY11ChvmJIAviqTihfN9lLIoJecJBEW6XbLEx4uc4BLKt
         wmOUZpLrapMsDA/69q/I81LUMk6l+SHkN1zC1/uc8ITmhx5cfYZWImXhanGaohbj8Yzw
         +0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721247982; x=1721852782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncSYgCH2yObWoew5+X7CbTEVtAMvPgWthTFHHeqOzls=;
        b=o42mJEGcXGkq+7nPVCU6oCnq3ICKuBFqMiltljCucDbOEAHC/2qr1AXRJp1TALRZK1
         dgDkF6MwOUktgJJuHkZaTQe2zbQzjuO7u8mWas2+U7ps8yldvvIUgEm1EKKxJ/g51Ym6
         FjVdo0Gf4udq3I5IiNZXOZW4rvpanoM7EhqR0NfxLXYGLTzAyq4jlyzl58Quo7e7ioHo
         BCb2TGEwd2pCQmJkLEO2dEV27hi0x+UkVj9WMJ7b3lOswyD7SwAEbqlNUWdZnQ4XbJ6m
         8q71IUZXVkI1E9jVOHcOFxQZEZM14Lv8+yeelvtb/mcp3nGLmLQHmOelVYp8gunb0z/k
         BMrg==
X-Forwarded-Encrypted: i=1; AJvYcCXaD2fmtmkRDJtRfobOkY3sn7XtmD2Q2fZ24meOldeyvADL4Zen0fVWCgGkVxRpSGRngtTX7xmPtS7hKyrinBoR0HPNRXA7abpce2RTvpEG88+Sx2ffKTZj7BWafIZFTcET84PWcXz33HytxhZILzdT0IiQ96BUJBzJsgem5wdW
X-Gm-Message-State: AOJu0Yw1Sc7dd3YF03wqn7C1qOjX89ZK1iXkfFnppvCSBFtJBPcLTj/T
	VxVGn+UAGnKe0UGQMntmMJlebbUbZZ9+dDeTZxuae8an9akkmPkXlUdqqtIEGEIQNbx2Z2iyAVr
	gWhxY5sGa5le6vzJFB48CtmaOFcs=
X-Google-Smtp-Source: AGHT+IFSRPf4iO7FOIYwpaSrJDKwLNrX/hn2v8uBVQCD1+mp0QuUcyPuSVjRdHo2DHuixjUvNAimZaelOjd9P+sqgHg=
X-Received: by 2002:a05:6871:58c:b0:25e:b8c2:8367 with SMTP id
 586e51a60fabf-260d915c40fmr2312531fac.11.1721247982433; Wed, 17 Jul 2024
 13:26:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611063618.106485-1-ofir.gal@volumez.com> <20240611063618.106485-5-ofir.gal@volumez.com>
 <2695367b-8c67-47ab-aa2c-3529b50b1a83@volumez.com>
In-Reply-To: <2695367b-8c67-47ab-aa2c-3529b50b1a83@volumez.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 17 Jul 2024 22:26:10 +0200
Message-ID: <CAOi1vP96JtsP02hpsZpeknKN_dh3JdnQomO8aTbuH6Bz247rxA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] libceph: use sendpages_ok() instead of sendpage_ok()
To: Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, netdev@vger.kernel.org, 
	ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com, 
	pabeni@redhat.com, kbusch@kernel.org, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2024 at 2:46=E2=80=AFPM Ofir Gal <ofir.gal@volumez.com> wro=
te:
>
> Xiubo/Ilya please take a look
>
> On 6/11/24 09:36, Ofir Gal wrote:
> > Currently ceph_tcp_sendpage() and do_try_sendpage() use sendpage_ok() i=
n
> > order to enable MSG_SPLICE_PAGES, it check the first page of the
> > iterator, the iterator may represent contiguous pages.
> >
> > MSG_SPLICE_PAGES enables skb_splice_from_iter() which checks all the
> > pages it sends with sendpage_ok().
> >
> > When ceph_tcp_sendpage() or do_try_sendpage() send an iterator that the
> > first page is sendable, but one of the other pages isn't
> > skb_splice_from_iter() warns and aborts the data transfer.
> >
> > Using the new helper sendpages_ok() in order to enable MSG_SPLICE_PAGES
> > solves the issue.
> >
> > Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
> > ---
> >  net/ceph/messenger_v1.c | 2 +-
> >  net/ceph/messenger_v2.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
> > index 0cb61c76b9b8..a6788f284cd7 100644
> > --- a/net/ceph/messenger_v1.c
> > +++ b/net/ceph/messenger_v1.c
> > @@ -94,7 +94,7 @@ static int ceph_tcp_sendpage(struct socket *sock, str=
uct page *page,
> >        * coalescing neighboring slab objects into a single frag which
> >        * triggers one of hardened usercopy checks.
> >        */
> > -     if (sendpage_ok(page))
> > +     if (sendpages_ok(page, size, offset))
> >               msg.msg_flags |=3D MSG_SPLICE_PAGES;
> >
> >       bvec_set_page(&bvec, page, size, offset);
> > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > index bd608ffa0627..27f8f6c8eb60 100644
> > --- a/net/ceph/messenger_v2.c
> > +++ b/net/ceph/messenger_v2.c
> > @@ -165,7 +165,7 @@ static int do_try_sendpage(struct socket *sock, str=
uct iov_iter *it)
> >                * coalescing neighboring slab objects into a single frag
> >                * which triggers one of hardened usercopy checks.
> >                */
> > -             if (sendpage_ok(bv.bv_page))
> > +             if (sendpages_ok(bv.bv_page, bv.bv_len, bv.bv_offset))
> >                       msg.msg_flags |=3D MSG_SPLICE_PAGES;
> >               else
> >                       msg.msg_flags &=3D ~MSG_SPLICE_PAGES;
>

Hi Ofir,

Ceph should be fine as is -- there is an internal "cursor" abstraction
that that is limited to PAGE_SIZE chunks, using bvec_iter_bvec() instead
of mp_bvec_iter_bvec(), etc.  This means that both do_try_sendpage() and
ceph_tcp_sendpage() should be called only with

  page_off + len <=3D PAGE_SIZE

being true even if the page is contiguous (and that we lose out on the
potential performance benefit, of course...).

That said, if the plan is to remove sendpage_ok() so that it doesn't
accidentally grow new users who are unaware of this pitfall, consider
this

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya

