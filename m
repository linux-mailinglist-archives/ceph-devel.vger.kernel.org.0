Return-Path: <ceph-devel+bounces-4277-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 37903CFB7B8
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 01:33:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9190E3008C99
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 00:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67EF71E991B;
	Wed,  7 Jan 2026 00:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzvRtC/T"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742E61DDC3F
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767746033; cv=none; b=AwJ/IBCa9pXwXMy0MEVjD0xWoF2oviHcBhV73HpnaVRbE1wtojVwv4LbVqwELL/RL8RAziiPJ9UF6mubs5ShcuAyrcGTXIbFQD94/bUA4jFYDu3PrMlSEub32j+P2ajtT7z/nC2Al91a/vlGlGDOjlJneLFV9UYTD+7qayRRHtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767746033; c=relaxed/simple;
	bh=9LNf5uyM7PeViOzaPr73mUBfY3bo7yujUM1Kfj3wBtc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=La/NbBewkuP7LOGaOKeO9eA5+th/0ElYQ0JdLykzuLf3+ncaxUhGdzJg+0wZm0yhGt8hUeP/6SgoRQxoeCah7gzwVb40xyAPCo7CytcveYMVeXQ1E2G4uYl609Qk/meXjvkdGmhJOzMd9q+RLKIHw8PCfasKsXb1WcgzvgKqs0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XzvRtC/T; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47bdbc90dcaso10845185e9.1
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jan 2026 16:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767746030; x=1768350830; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Izfcp9nSGloW/IJ9+CQjD8lhQ5XI8VMhMTNLb0M+uW8=;
        b=XzvRtC/TUFK0xagOoWyfPJwhsv2flpw1e7b2aUuZKPQoCW4P1jZ7GyQ0VLBEKZ0Gcs
         V1fiS7HZ+Rx2AJgwrqVI+neiLZGuyOo8YwG9dYGKLw91Fabz9zAOTFjfm4EqjOZN6igC
         HtTOSQSlnMJlmzhJP3XUuEl2d9KIaAeR3TU8ldcrLl3IkHLtqtqPvDhROCH537BHwvNa
         y6CQ28VlX8REOPetY2ZxtH1LbWA7Z699OQ8QP/kkgjxYtLYf4lmDbNpThoPBYNbgB3Yf
         WlVmhmBoVzqC04SkKiBJl6q+ahaBme0eYSbmuvz1gM+dM7pn9Rh5u2xP78/IvdGoOzXM
         6hJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767746030; x=1768350830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Izfcp9nSGloW/IJ9+CQjD8lhQ5XI8VMhMTNLb0M+uW8=;
        b=O7F3qBKJJGM8Az1catdXo6zRGKWbqVCsy28Mr91FoMEBgf29c/fl29KjBVMrxN8w1E
         tiHkPoL3tll03ADXS3oFUU9ViWxqWEQrfdaHxC/m8EXT8D8wjCHnM7AbZQANxpHS9/4N
         H3xLPw/4pc0EMG9y+3UqIwvlxyrZMB9aJoPy6eoYzZXr3FPdL3XxzcnJvFfJet3RPuT8
         6BkJDocpdonNvau1Havl20n4JPxTmgDxj+yshACW2hCILOqxZqekGwOzMdfH2Erx1e8U
         NNuXi777h1XqzDJ9VRAJ/eUwY+o3nPD7nw/7RYSKDe/ndeEGLkgauwrqe7eTDhCJIiT0
         IOgg==
X-Forwarded-Encrypted: i=1; AJvYcCVLAPz0suvYRQkGFVDzDB7qy5gjq6R3OCi/LLe969cT7tnAAnOfZLHPrP2nODzggtyS3/3u2jJ7H0su@vger.kernel.org
X-Gm-Message-State: AOJu0YydKK9xcL1tBZB81s013AHj3/d+5YP5dRMsTyvFTgTHQ71pvAsA
	ciPbVquXX8BLsM5DcPm/uVAEf0k/tzXFOz9LvSMt8umEiEqDUbINZTXWC3WQXsaXJ3HuACb3nuj
	0ysOMezHmNw8QJIRScceMvXDfRCRNC/I=
X-Gm-Gg: AY/fxX42YDWEiLGOPzl/FlN2qEaiRC4j9lLG16q+5IuxKmxjDFpZcjQOYVbyvuxGobd
	IDHGW8T3l62tHemSbtcyk3ximTl8V9vHX0W0rRZyP/qASaaoyw8odwS7cFhVZb3C/CaIG1vNSLK
	muqGlKW+n9bN5rzdSWiSmFFpbBjNmPtwmbIkFGMnDfqGgmIfCRVzoSVCfKBR7EMA5UKLHttmfZ6
	aLgozqpmt6GnMCXoyDjRjGQPjHJkuhG3Nh6QTMGsB1c45EqDkwd1JjUz6SUvDEq3pIctklBEDJj
	YTtsBbh8LSPS5rm37+IgRXUnwzX/
X-Google-Smtp-Source: AGHT+IHnE+r7bGv/BkxZ6LJhXngM4EyGuF2bd3sQnhEUsKf8xxvzuAYkADKmfPfEUw7qWYwEM4IF8p+euzLP8YCo0x4=
X-Received: by 2002:a05:600c:4e8a:b0:479:2a09:9262 with SMTP id
 5b1f17b1804b1-47d84b18037mr6856645e9.9.1767746029492; Tue, 06 Jan 2026
 16:33:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-5-CFSworks@gmail.com>
 <5fba25f7b85276411c091cb7206b2dc057d89c68.camel@ibm.com> <CAH5Ym4ig7uBdereXpL8T3Cjn1zqzRxG1VwXb59rwHQjTQKWrPw@mail.gmail.com>
 <a3a4413f8d9c7df1fc53b2421c9256496f682a4c.camel@ibm.com>
In-Reply-To: <a3a4413f8d9c7df1fc53b2421c9256496f682a4c.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Tue, 6 Jan 2026 16:33:38 -0800
X-Gm-Features: AQt7F2rW86FdMXuY4HjhNoWPfSqVr2zt2Cqvnt43jPG3uYuSS8QgCXwS2vMA5Jk
Message-ID: <CAH5Ym4iZ7ZTsFxHCHQPnHS5U-vZL8=Z_5T0cXJeB56dzw+CQpw@mail.gmail.com>
Subject: Re: [PATCH 4/5] ceph: Assert writeback loop invariants
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Milind Changire <mchangir@redhat.com>, Xiubo Li <xiubli@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, "brauner@kernel.org" <brauner@kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 3:00=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Mon, 2026-01-05 at 22:53 -0800, Sam Edwards wrote:
> > On Mon, Jan 5, 2026 at 2:29=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyk=
o@ibm.com> wrote:
> > >
> > > On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > > > If `locked_pages` is zero, the page array must not be allocated:
> > > > ceph_process_folio_batch() uses `locked_pages` to decide when to
> > > > allocate `pages`, and redundant allocations trigger
> > > > ceph_allocate_page_array()'s BUG_ON(), resulting in a worker oops (=
and
> > > > writeback stall) or even a kernel panic. Consequently, the main loo=
p in
> > > > ceph_writepages_start() assumes that the lifetime of `pages` is con=
fined
> > > > to a single iteration.
> > > >
> > > > This expectation is currently not clear enough, as evidenced by the
> > > > previous two patches which fix oopses caused by `pages` persisting =
into
> > > > the next loop iteration.
> > > >
> > > > Use an explicit BUG_ON() at the top of the loop to assert the loop'=
s
> > > > preexisting expectation that `pages` is cleaned up by the previous
> > > > iteration. Because this is closely tied to `locked_pages`, also mak=
e it
> > > > the previous iteration's responsibility to guarantee its reset, and
> > > > verify with a second new BUG_ON() instead of handling (and masking)
> > > > failures to do so.
> > > >
> > > > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > > > ---
> > > >  fs/ceph/addr.c | 9 +++++----
> > > >  1 file changed, 5 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > > index 91cc43950162..b3569d44d510 100644
> > > > --- a/fs/ceph/addr.c
> > > > +++ b/fs/ceph/addr.c
> > > > @@ -1669,7 +1669,9 @@ static int ceph_writepages_start(struct addre=
ss_space *mapping,
> > > >               tag_pages_for_writeback(mapping, ceph_wbc.index, ceph=
_wbc.end);
> > > >
> > > >       while (!has_writeback_done(&ceph_wbc)) {
> > > > -             ceph_wbc.locked_pages =3D 0;
> > > > +             BUG_ON(ceph_wbc.locked_pages);
> > > > +             BUG_ON(ceph_wbc.pages);
> > > > +
> > >
> >
> > Hi Slava,
> >
> > > It's not good idea to introduce BUG_ON() in write pages logic. I am d=
efinitely
> > > against these two BUG_ON() here.
> >
> > I share your distaste for BUG_ON() in writeback. However, the
> > BUG_ON(ceph_wbc.pages); already exists in ceph_allocate_page_array().
> > This patch is trying to catch that earlier, where it's easier to
> > troubleshoot. If I changed these to WARN_ON(), it would not prevent
> > the oops.
> >
> > And the writeback code has a lot of BUG_ON() checks already (so I am
> > not "introducing" BUG_ON), but I suppose you could be saying "it's
> > already a problem, please don't make it worse."
> >
>
> It looks really strange that you do at first:
>
> -             ceph_wbc.locked_pages =3D 0;
>
> and then you introduce two BUG_ON():
>
> +             BUG_ON(ceph_wbc.locked_pages);
> +             BUG_ON(ceph_wbc.pages);
>
> But what's the point? It looks more natural simply to make initialization=
 here:
>
>               ceph_wbc.locked_pages =3D 0;
>               ceph_wbc.strip_unit_end =3D 0;
>
> What's wrong with it?

The problem is if that block runs at the top of the loop while
ceph_wbc.pages !=3D NULL, the worker will oops in
ceph_allocate_page_array(). This is a particularly difficult oops to
diagnose. We should prevent it by carefully maintaining the loop's
invariants, but if prevention fails, the next best option is to oops
earlier, as close as possible to the actual bug.

>
> > If I introduce a ceph_discard_page_array() function (as discussed on
> > patch 4), I could call it at the top of the loop (to *ensure* a clean
> > state) instead of using BUG_ON() (to *assert* a clean state). I'd like
> > to hear from other reviewers which approach they'd prefer.
> >
> > >
> > > >               ceph_wbc.max_pages =3D ceph_wbc.wsize >> PAGE_SHIFT;
> > > >
> > > >  get_more_pages:
> > > > @@ -1703,11 +1705,10 @@ static int ceph_writepages_start(struct add=
ress_space *mapping,
> > > >               }
> > > >
> > > >               rc =3D ceph_submit_write(mapping, wbc, &ceph_wbc);
> > > > -             if (rc)
> > > > -                     goto release_folios;
> > > > -
> > >
> > > Frankly speaking, its' completely not clear the from commit message w=
hy we move
> > > this check. What's the problem is here? How this move can fix the iss=
ue?
> >
> > The diff makes it a little unclear, but I'm actually moving
> > ceph_wbc.{locked_pages,strip_unit_end} =3D 0; *above* the check (see
> > commit message: "also make it the previous iteration's responsibility
> > to guarantee [locked_pages is] reset") so that they happen
> > unconditionally. Git just happens to see it in terms of the if/goto
> > moving downward, not the assignments moving up.
>
> I simply don't see any explanation why we are moving this check.

The check is not being moved; other lines are being moved above it,
and Git's diff algorithm made it look like the check moved.
This equivalent diff makes the actual change clearer:
         rc =3D ceph_submit_write(mapping, wbc, &ceph_wbc);
+        ceph_wbc.locked_pages =3D 0;
+        ceph_wbc.strip_unit_end =3D 0;
         if (rc)
             goto release_folios;
-
-        ceph_wbc.locked_pages =3D 0;
-        ceph_wbc.strip_unit_end =3D 0;

         if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
             ceph_wbc.nr_folios =3D

> And what this
> move is fixing. I believe it's really important to explain what this
> modification is fixing.

This is not a bugfix; it's purely code cleanup -- more of the
"defensive programming" that we both like to see.

Cheers,
Sam

>
> Thanks,
> Slava.
>
> >
> > Warm regards,
> > Sam
> >
> >
> > >
> > > Thanks,
> > > Slava.
> > >
> > > >               ceph_wbc.locked_pages =3D 0;
> > > >               ceph_wbc.strip_unit_end =3D 0;
> > > > +             if (rc)
> > > > +                     goto release_folios;
> > > >
> > > >               if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
> > > >                       ceph_wbc.nr_folios =3D

