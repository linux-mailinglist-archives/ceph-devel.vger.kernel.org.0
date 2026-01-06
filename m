Return-Path: <ceph-devel+bounces-4263-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D677CF6EF0
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 07:54:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B5B50301B2EF
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 06:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BFFB2FABE7;
	Tue,  6 Jan 2026 06:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISL9vzp3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2D028FFF6
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682412; cv=none; b=cAWF7s/GGUIrb4dJCJxj4t8Gk+5SGwlYVWtkwZtcK/hmK+Sha2SVMAITgInMablV+IsxUmEUQ/AZRzhYOf39W+uV1bxvVohjbp+gD2suihXCUe/ix878hjaDrpv6sFekCA9m5FfxrRrXQAFb84paUHEFsPu1Nhnpc0sTgK8elV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682412; c=relaxed/simple;
	bh=LIftr669zk/jWjjCHKjVl97Eknq8lheTyPhEYvY3L60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JItjkcRhpbdm8sH0Z539hku1pcWXHoL/5hJP6ImI/ShvAmtdeEE9QuMu/iYRKGC+z0/tlUL3sG9YNdtDqDdK4v7ecHv/TsjoXOSUNiUgXYHcUz2aNPPG3yc+uqAlgBQnuik8fRoFZGk8NHdTFSwEUBHnPEDlI1BtfxnMJt9SFrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ISL9vzp3; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42e2ba54a6fso222151f8f.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 22:53:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767682409; x=1768287209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1y5U6WAbYoOb9xnbqZlaBZX7OOF3q1TP90ZeOZQg5L0=;
        b=ISL9vzp3AeUhHEbFr7uUFmznO5jms/7UaE6C2AYka1PljlQ5glM3uNTcLo0/dj9EAY
         iNZnrNcNgJPHb8Zuc/cXQdVWH9SrR1Z3Ot6OOA5oTq4Y3huwRIouAEtEAX9nuPL4X+Vj
         gqXF/vobjJQIIPbucsrIUgiT4mnMSM1ymyo/cZGUiMmD0ucJDrMHxsPij/ehtN4Ppntl
         pwMjckyrctdIvmLfq2rS3d7lCOOngZFzsxsB8CPaDIqttMpGZwVVvuaQpyzjwxdy4ibn
         Iy//hSVXkuai30fAghOBATNi5UwVVN6msXkToYoFN2EgMukAtyKAQRl4WKsRJ6GWEicp
         q25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767682409; x=1768287209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1y5U6WAbYoOb9xnbqZlaBZX7OOF3q1TP90ZeOZQg5L0=;
        b=WUvgZEfa3z7JfNAqAhfA3ScG1gePtey+fkwDTTA/HZMhVHlRNGM0XIPf/GdITA/zIG
         iO/bomd7gnLqgmJU9iuc3ET84CFhxr7ovd4tF+vLYzPzIfyVTXihbZ2vwcxa3Xuc3M9v
         ZWFNJ1anvbygZHc/hd/tVTeicZG9bADqgdjTOhZ/lX+rqqL3+r8bZ35V392dVI21s4t0
         XTx5fcPZgEYEozNXRkR8pP0zaGwQmU4hMnV01vOChVRieZXD1iJfOl19RJByxe/UmfHm
         uoFhFM5HjBXixdS80xYpnEMkw+2xlSFisHCBp5zzkSsNApwMsW+dQS/OYTDmXSqJJWRn
         c5ow==
X-Forwarded-Encrypted: i=1; AJvYcCUTxoMFgSfry0L5ozY4TNJ9tqv4EKrtMMbSh20OnCvCLdmFqq28XfJknFiCnQLmdgXsUJF7G9Jj6Kgo@vger.kernel.org
X-Gm-Message-State: AOJu0YwBGGr5sfMjbVCLVyUz4PSk1tQFSnzOjYD5tkLlzAJPhIqVujHU
	B+chXlE2IYpo4VVUvmjPIEkq7aQxHDYLeTaBi3re9p8kkA57mM0hmqpIwf8DjLqiLPSzbGsNnmP
	hiyjqKjMEyCdtpLNq2mJt/K9Nl+40un8=
X-Gm-Gg: AY/fxX7rnBt+hccijZbutnLG55lbvTtfHg8pcQ0dwozFi+52rlAbhfmVXtvf6RSL2tQ
	wbROJKiAy/UH+d8SA6yuh+dsBoAi77+lgaedPj5OJ24flDYux249z+nOgW/81HU7HD8QLCsH7lH
	N7jDsZ9TbZSvn/2SLqbdbyK7cmlPTS/84KRNNNeLlkOomqn5KWK8oUa4RbzDE8d49pmsq158JGP
	PYiBzWN9LYgPqsneCND60nzSkNOXngcxb0vdhRZbNA44/LqzqlXaDw9BXR6/UdfY5scsPyEJs71
	I1PXyKDDhbxsz3Lj6kAQ3g373vr+
X-Google-Smtp-Source: AGHT+IFUJWpfhBc1UQYREHXQfiPYebrwPMVVM9mo8IKhQD0djEMBAU5QEkjkg7BitFBPHJ1qAcd2SNCAlS3ddrqc3BY=
X-Received: by 2002:a05:6000:400b:b0:432:8504:8d5b with SMTP id
 ffacd0b85a97d-432bca50697mr2357831f8f.50.1767682408823; Mon, 05 Jan 2026
 22:53:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-5-CFSworks@gmail.com>
 <5fba25f7b85276411c091cb7206b2dc057d89c68.camel@ibm.com>
In-Reply-To: <5fba25f7b85276411c091cb7206b2dc057d89c68.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Mon, 5 Jan 2026 22:53:17 -0800
X-Gm-Features: AQt7F2oeBLu8u8nDHtRk87_oJyIZfNw123FsmGteGKwQ52mKx0EX_ROSZwv_0BQ
Message-ID: <CAH5Ym4ig7uBdereXpL8T3Cjn1zqzRxG1VwXb59rwHQjTQKWrPw@mail.gmail.com>
Subject: Re: [PATCH 4/5] ceph: Assert writeback loop invariants
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Milind Changire <mchangir@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 2:29=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > If `locked_pages` is zero, the page array must not be allocated:
> > ceph_process_folio_batch() uses `locked_pages` to decide when to
> > allocate `pages`, and redundant allocations trigger
> > ceph_allocate_page_array()'s BUG_ON(), resulting in a worker oops (and
> > writeback stall) or even a kernel panic. Consequently, the main loop in
> > ceph_writepages_start() assumes that the lifetime of `pages` is confine=
d
> > to a single iteration.
> >
> > This expectation is currently not clear enough, as evidenced by the
> > previous two patches which fix oopses caused by `pages` persisting into
> > the next loop iteration.
> >
> > Use an explicit BUG_ON() at the top of the loop to assert the loop's
> > preexisting expectation that `pages` is cleaned up by the previous
> > iteration. Because this is closely tied to `locked_pages`, also make it
> > the previous iteration's responsibility to guarantee its reset, and
> > verify with a second new BUG_ON() instead of handling (and masking)
> > failures to do so.
> >
> > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > ---
> >  fs/ceph/addr.c | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 91cc43950162..b3569d44d510 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1669,7 +1669,9 @@ static int ceph_writepages_start(struct address_s=
pace *mapping,
> >               tag_pages_for_writeback(mapping, ceph_wbc.index, ceph_wbc=
.end);
> >
> >       while (!has_writeback_done(&ceph_wbc)) {
> > -             ceph_wbc.locked_pages =3D 0;
> > +             BUG_ON(ceph_wbc.locked_pages);
> > +             BUG_ON(ceph_wbc.pages);
> > +
>

Hi Slava,

> It's not good idea to introduce BUG_ON() in write pages logic. I am defin=
itely
> against these two BUG_ON() here.

I share your distaste for BUG_ON() in writeback. However, the
BUG_ON(ceph_wbc.pages); already exists in ceph_allocate_page_array().
This patch is trying to catch that earlier, where it's easier to
troubleshoot. If I changed these to WARN_ON(), it would not prevent
the oops.

And the writeback code has a lot of BUG_ON() checks already (so I am
not "introducing" BUG_ON), but I suppose you could be saying "it's
already a problem, please don't make it worse."

If I introduce a ceph_discard_page_array() function (as discussed on
patch 4), I could call it at the top of the loop (to *ensure* a clean
state) instead of using BUG_ON() (to *assert* a clean state). I'd like
to hear from other reviewers which approach they'd prefer.

>
> >               ceph_wbc.max_pages =3D ceph_wbc.wsize >> PAGE_SHIFT;
> >
> >  get_more_pages:
> > @@ -1703,11 +1705,10 @@ static int ceph_writepages_start(struct address=
_space *mapping,
> >               }
> >
> >               rc =3D ceph_submit_write(mapping, wbc, &ceph_wbc);
> > -             if (rc)
> > -                     goto release_folios;
> > -
>
> Frankly speaking, its' completely not clear the from commit message why w=
e move
> this check. What's the problem is here? How this move can fix the issue?

The diff makes it a little unclear, but I'm actually moving
ceph_wbc.{locked_pages,strip_unit_end} =3D 0; *above* the check (see
commit message: "also make it the previous iteration's responsibility
to guarantee [locked_pages is] reset") so that they happen
unconditionally. Git just happens to see it in terms of the if/goto
moving downward, not the assignments moving up.

Warm regards,
Sam


>
> Thanks,
> Slava.
>
> >               ceph_wbc.locked_pages =3D 0;
> >               ceph_wbc.strip_unit_end =3D 0;
> > +             if (rc)
> > +                     goto release_folios;
> >
> >               if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
> >                       ceph_wbc.nr_folios =3D

