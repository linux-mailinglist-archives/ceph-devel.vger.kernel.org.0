Return-Path: <ceph-devel+bounces-4262-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7318CF6EEA
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 07:54:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E9913301D679
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 06:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E272FABE7;
	Tue,  6 Jan 2026 06:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+Ho42mv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C7E1A83F9
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 06:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682364; cv=none; b=IRMdwLxLVF9OAwM/FzgGvBjZh9Ih24PTisYh5uppoFnjqCvhBe/y7cISmcrUqcUfgcagra0MGPGtzb7+TgBqBU9YWCxu3upQ/flYhc2J78nVXf8wKU5Ase1sQZ9pA0b1PbLC+RzMdHxUEvb9ZKqW6v+VOZd4m+QP8LZouQfQZJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682364; c=relaxed/simple;
	bh=ldGsdXFxFu3xsBTGzSJZFSXDMtd7h8Xq1ZGg8CU04mQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dfW4K6Wh6VY013Mmc/nbNK2DaCk/PvIpqym9PFtCF8ahDZQgVAA/6ggLF/UgBypdGQp106bDB2BEyr1eQ3Rr9LnMvRvmACo7RRgw+HDx3UzElyqMdb41v4pNSGIThWH0lLkSPhDxzFjd3M7629kk16ud1BTNBSR0yMfQ/+xLqU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q+Ho42mv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso366985f8f.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 22:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767682361; x=1768287161; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rn9TQgUB35xi9VXhhElF6zAI0W2Qq/UK06bS94ywRVk=;
        b=Q+Ho42mvBrRVrrmsgICGv3qc0zqJq0WBiuPL5DOhIMOayFltYMe4OnIcMxvP/fv4So
         y69ALWU3fgqwxvxK0vIFXB+07Lb1R5HAmYoUAzdnsQgTkw/D8zxlTpCDoH3Xv/Of0NAM
         jauid+RI0PmB1Myj6UI8hergg6fgifJ4yP7PXUBGox2R9cVSOeHQ9oK3wFngvR3HY2x/
         sZTllQXk+Yfe9LlSyQaXfwofYDP/4jRDvElayHRpRzq3dLyYBZ9ucxuwyqtcHhXqSUPZ
         saQkILtml+fBI7CuW4yEPMh/SyXkzd8QcK785XNByBkU6xRxf5ycR15Ie8mTuwKXyoR4
         cPqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767682361; x=1768287161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rn9TQgUB35xi9VXhhElF6zAI0W2Qq/UK06bS94ywRVk=;
        b=b6/DlDe0kpcjn711Nfx302wQ/POAanHpwpqZk/O5J8v3+XeEk42iwGYj4zMy0cGxuf
         6P4TLHH3/QJaxEPmyiDz+VYFXSKrzmbV1QP/StUGHX4i+ZhY7mzg1/MP6EUwJ8znl1gV
         4cVvp5/hrtrZkAYIuxYLXQUF2HK7YFgtIVCa/hw1V+BRe1jYvrSGVPF6NYFasu0zcBc7
         TKFEImuy34sKwOkrM/FnioHz4WcZuNzd2RvpAn+rNt5UILAYkgPv3QQUatXW9PxHktl4
         yxk1yyIY6H96EUm0yX7bQCsDUSrKXMwT/80tJYUijsZ2B1DqPf6WPhKzI6Z70uvizpPC
         i3Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVNbXYvE6qY/oGI3VqPBWIyK/WZH0q84XLlUr0lG/7ffYZNTyd0yxEgZSnY6s9lUfrKwTLOWCFo0hHl@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5bdEaRjLYG5ElyF3IzHwDIQ37+Uc3quRxNc0mUSzix/i+hhDh
	+yvFpR5x4yvEIv0s1aPetWoOa+nrtnasnVLrTSFj9+6xS1T7hThUzPxuzmSp3GfGQZMnOuPxMXW
	GWTrG+rQPrN64R7hahDxyYKe/Ba3QhvE=
X-Gm-Gg: AY/fxX4OMtmR8N/EliZo56GjLGjjDTQAatXLAMPJ+4dZTmAdpM/PI3ZjcqvY4/tSNrv
	4Qr8tY5Y4aqTeyooaV6xmwklyiqLzvRFiRwQcWbA8x4N+OH2DTG2teR6ueXHqd27heZLmXSp2kD
	TthAF/GTYuwlZsGv5o85XTBzG6HbWiJslk1hZn37w5TzxU7fGaSgnHn62x4fJDSvtj+IiO1bxlO
	o/2HWKopR1WIxXdCtBSkjxt2HJUoXzuClmGmZsFoMIGUM/Dy/jIFJH2ZYiJWwqeWR22oPiafA4V
	XVIAjFJpcKur31CDGdjAMw1JM+Um
X-Google-Smtp-Source: AGHT+IHkzheiWDsu3Tie2YRfl2Rs17I2MZZFoKuqAplH4JngFa3MjKXuUVDsqgaz71+jH30+7xzENXTwDBSKqDXexEQ=
X-Received: by 2002:a05:6000:2302:b0:430:f255:14b3 with SMTP id
 ffacd0b85a97d-432bc9f562amr2306441f8f.43.1767682360802; Mon, 05 Jan 2026
 22:52:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-4-CFSworks@gmail.com>
 <90190adb0e384d4d9d451d444c46f177bb95366d.camel@ibm.com>
In-Reply-To: <90190adb0e384d4d9d451d444c46f177bb95366d.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Mon, 5 Jan 2026 22:52:29 -0800
X-Gm-Features: AQt7F2qecFY42oeNK1b5j0ZScFM7tbibbtSuEsvYRAf7mNPiTGRbxAk-2svhnhw
Message-ID: <CAH5Ym4is+dfE4Td8cuA0s4_4fkGNy+X1R_N+nSZDzSjYfxNBfg@mail.gmail.com>
Subject: Re: [PATCH 3/5] ceph: Free page array when ceph_submit_write fails
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Milind Changire <mchangir@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 1:09=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > If `locked_pages` is zero, the page array must not be allocated:
> > ceph_process_folio_batch() uses `locked_pages` to decide when to
> > allocate `pages`,
> >
>

Hi Slava,

> I don't quite follow how this statement is relevant to the issue. If
> `locked_pages` is zero, then ceph_submit_write() will not to be called. D=
o I
> miss something here?

That statement is only informing that ceph_process_folio_batch() will
BUG() when locked_pages =3D=3D 0 && pages !=3D NULL. It establishes why
`pages` must be freed/NULLed before the next iteration of
ceph_writepages_start()'s loop (which sets locked_pages =3D 0).

>
> > and redundant allocations trigger
> > ceph_allocate_page_array()'s BUG_ON(), resulting in a worker oops (and
> > writeback stall) or even a kernel panic. Consequently, the main loop in
> > ceph_writepages_start() assumes that the lifetime of `pages` is confine=
d
> > to a single iteration.
>
> It will be great to see the reproducer script or application and call tra=
ce of
> the issue. Could you please share the reproduction path and the call trac=
e of
> the issue?

It's difficult to reproduce organically. It arises when
`!ceph_inc_osd_stopping_blocker(fsc->mdsc)`, which I understand can
only happen in a race. I used the fault injection framework to force
ceph_inc_osd_stopping_blocker() to fail.

The call trace is disinteresting. See my reply to your comments on
patch 1: it's the same trace.

>
> >
> > The ceph_submit_write() function claims ownership of the page array on
> > success.
> >
>
> As far as I can see, writepages_finish() should free the page array on su=
ccess.

That's my understanding too; by "claims ownership of the page array" I
only mean that ceph_writepages_start() isn't responsible for cleaning
it up, once it calls ceph_submit_write().

>
> > But failures only redirty/unlock the pages and fail to free the
> > array, making the failure case in ceph_submit_write() fatal.
> >
> > Free the page array in ceph_submit_write()'s error-handling 'if' block
> > so that the caller's invariant (that the array does not outlive the
> > iteration) is maintained unconditionally, allowing failures in
> > ceph_submit_write() to be recoverable as originally intended.
> >
> > Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > ---
> >  fs/ceph/addr.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 2b722916fb9b..91cc43950162 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1466,6 +1466,13 @@ int ceph_submit_write(struct address_space *mapp=
ing,
> >                       unlock_page(page);
> >               }
> >
> > +             if (ceph_wbc->from_pool) {
> > +                     mempool_free(ceph_wbc->pages, ceph_wb_pagevec_poo=
l);
> > +                     ceph_wbc->from_pool =3D false;
> > +             } else
> > +                     kfree(ceph_wbc->pages);
> > +             ceph_wbc->pages =3D NULL;
>
> Probably, it makes sense to introduce a method ceph_free_page_array likew=
ise to
> __ceph_allocate_page_array() and to use for freeing page array in all pla=
ces.

I like the suggestion but not the name. Instead of
ceph_free_page_array(), it should probably be called
ceph_discard_page_array(), because it is also redirtying the pages and
must not be used after successful writeback. (To me, "free" implies
success while "discard" implies failure.)

> Could ceph_wbc->locked_pages be greater than zero but ceph_wbc->pages =3D=
=3D NULL?

ceph_wbc->locked_pages is the current array index into
ceph_wbc->pages, so they both need to be reset sometime before the
next iteration of ceph_writepages_start()'s loop.

Warm regards,
Sam



>
> Thanks,
> Slava.
>
> > +
> >               ceph_osdc_put_request(req);
> >               return -EIO;
> >       }

