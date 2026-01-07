Return-Path: <ceph-devel+bounces-4276-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0086BCFB70C
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 01:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6D9E4302C8FC
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 00:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB168188735;
	Wed,  7 Jan 2026 00:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAF+eVcG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4EF137750
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 00:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767744928; cv=none; b=Y8raULXlSmf5OIK6w7hqm9y8Ew3kzRoCoLdsejXPHfbYXwIsiwL+sj+fKH/bA1tJabXiO8Ugrv+K+8DvQhFIDm+mZwZD88qSTctLf4YyafAIMD9OKbNlc6TYcaWTXId0abmWI9j0nsiLJyt4G4umPef8QhjLxucLcxjF3ckHWj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767744928; c=relaxed/simple;
	bh=rYCWTgWYbmLP8Fsdt1iBlHAc1LLZ8h4ydLU1lCjaRwA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hFVZmUinTNNRNAksh2vDRAm1fLGW5hN24ceVWGS1bO2Tf7tq8r7YCtoeGBbVTDNnSLKFetuCC//iBzf5c8UARgjXqqJrSroE9/UATr5Wxm71S0ueorsbXMXceXiPUhGciBAjObltlb7DVmex39xSx5eMdMr0liMK2ejuk87xdXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAF+eVcG; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42e2ba54a6fso556829f8f.3
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jan 2026 16:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767744925; x=1768349725; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vx79OS7VB+ZQQNUpXThPdMdOwzIVItE44eUhJR1tRZ4=;
        b=LAF+eVcG8ZU2AeMEu8yrHt0UBMRLqBMkYOqth+1tULfZESgTOICaitnNwo0rH0+jcl
         fOUK1GQ0D0tqJoBY+jDxzACb6KUgiT6eylRFO0+moYd0y/CDYNtATRygoA9/i5oKHN5q
         wcPDHxvCPOf4OL1JwF1VdYvoXdbZPXTzmVIYwK45b3DEnwd9N15i/+CxMBOz/4gDyLcc
         S5P6BLcxwactfPX0o0oMj6ycd8ydM5TLfxt+781q/JONcKSkrdYUkXl6Nu6ZdT74MHps
         8s8mTYgPjmmDcMoNzBxNhIA/SAmxkF2mRg05ZaaB2nKRCLTERrwm7FG/xekUbGiZJ3+M
         UgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767744925; x=1768349725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vx79OS7VB+ZQQNUpXThPdMdOwzIVItE44eUhJR1tRZ4=;
        b=Xuy763XFLJ8eYqtWhB6DjnblGrLIKugB5o45FW1qQaJsRnh8bIPWC99Or+OQ1X9H/p
         Pg8QkOuh+hvwr/A6iN0/W4u/YGcI8h+PvRUN8cZQ5WlW9O+dk5/CfPzKiLAaBDTDWKhd
         eAzX97XQJD5hWKV3lJsbtSCz/yE9riNl3HXUpXIGiLukH2XiIXF/WRDmb3O7HTp5TrvT
         XXRj3EqMB0UCequN4DTklsuG9OvHRLEJEajs6GhSUZVav4T91o9K0/BntoibU1bh8dG+
         IplliqXcddT9j8Yinb3Jk0LriMagG6EcwOXndCmU8SXTK3gTR7HU3Y2JVHJmvraIB+Qh
         KSuw==
X-Forwarded-Encrypted: i=1; AJvYcCVVQuwuNExJzP+jmE/mbTOT3XEJeDaeyGtusfJz9htvG0qrLy7y56IxGLxBjr6Mehhs7AbxsbsrfO+1@vger.kernel.org
X-Gm-Message-State: AOJu0YzPOgmkan5SDbxYqhPhyGS0Yk2uRbB/sI5cbIB3qsBsBQjH4GZD
	cTFFFo4CGhjL8u/Wg2RHa0uiEG37SxPCRIb6oIUAJkUoy/JzwZvpvtA5HPgKEoXjP5jvm6QQfpV
	9Us9hIO6mFSbsxSgMS9BdZHuXdmH3xBs=
X-Gm-Gg: AY/fxX4WOlp5MS8YkbFyXSi/mXiDDAemSv+R5xJirLVrOkNA1BA+oaFHWHp4fp2gpXH
	kqt8c4Inw05B+hQejhU8m3QwNFE7cwreZkoAlO0aqeQ77N3btimqrIh4rHvorgQsNggfgb0wNdz
	eIXWWs8vSzBqplU5SJG0GFThc0oRcsyDEP9KR4PUey4XbX8CxdI1DqBoSpKAvGV8fg+vrGrf3ig
	xN7dTExi9dOfU2sY5yaQnhr71sJqRS7SBoXuVWig2PGH4rdJ1Uzg9sxhm9DpbwdNo287XNKd9A/
	JmkmC7PV1PpEs0Mpp5MRnv3fzIF9
X-Google-Smtp-Source: AGHT+IH3zW/Ui0lliH/ZzImWy7mu3pdxcAHPFYwiAms+uVPmbCkqVo1ZCaRawfU40d+Jw9hAL9Y5rBPeZHpOoNI2ggA=
X-Received: by 2002:a05:6000:40c9:b0:431:316:9212 with SMTP id
 ffacd0b85a97d-432c3628186mr751165f8f.6.1767744924526; Tue, 06 Jan 2026
 16:15:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-3-CFSworks@gmail.com>
 <fe859743904a2add8d7d67f64ab9686769670782.camel@ibm.com> <CAH5Ym4jnsYNp7Y5icBtQJZvX_JW=nvprj61ZH1XDX3Js0ePggA@mail.gmail.com>
 <d680c81d5f48e02a1282cc029aacdb7e093d2d5c.camel@ibm.com>
In-Reply-To: <d680c81d5f48e02a1282cc029aacdb7e093d2d5c.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Tue, 6 Jan 2026 16:15:13 -0800
X-Gm-Features: AQt7F2oNpb3JEky7VU6B4CILXd0-Bq3VYqDH6H-Njj1suMedJjP4l0KJKr4Jawc
Message-ID: <CAH5Ym4jaZO5NWYZCzf9NpmhVm58MB0+aD4-4NR+iiozHRXDmhQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] ceph: Remove error return from ceph_process_folio_batch()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Milind Changire <mchangir@redhat.com>, Xiubo Li <xiubli@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, "brauner@kernel.org" <brauner@kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 2:47=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyko@ib=
m.com> wrote:
>
> On Mon, 2026-01-05 at 22:52 -0800, Sam Edwards wrote:
> > On Mon, Jan 5, 2026 at 12:36=E2=80=AFPM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > > > Following the previous patch, ceph_process_folio_batch() no longer
> > > > returns errors because the writeback loop cannot handle them.
> > >
> >
> > Hi Slava,
> >
> > > I am not completely convinced that we can remove returning error code=
 here. What
> > > if we don't process any folio in ceph_process_folio_batch(), then we =
cannot call
> > > the ceph_submit_write(). It sounds to me that we need to have error c=
ode to jump
> > > to release_folios in such case.
> >
> > This goto is already present (search the comment "did we get anything?"=
).
> >
> > >
> > > >
> > > > Since this function already indicates failure to lock any pages by
> > > > leaving `ceph_wbc.locked_pages =3D=3D 0`, and the writeback loop ha=
s no way
> > >
> > > Frankly speaking, I don't quite follow what do you mean by "this func=
tion
> > > already indicates failure to lock any pages". What do you mean here?
> >
> > I feel like there's a language barrier here. I understand from your
> > homepage that you speak Russian. I believe the Russian translation of
> > what I'm trying to say is:
> >
> > =D0=AD=D1=82=D0=B0 =D1=84=D1=83=D0=BD=D0=BA=D1=86=D0=B8=D1=8F =D1=83=D0=
=B6=D0=B5 =D1=81=D0=B8=D0=B3=D0=BD=D0=B0=D0=BB=D0=B8=D0=B7=D0=B8=D1=80=D1=
=83=D0=B5=D1=82 =D0=BE =D1=82=D0=BE=D0=BC, =D1=87=D1=82=D0=BE =D0=BD=D0=B8 =
=D0=BE=D0=B4=D0=BD=D0=B0 =D1=81=D1=82=D1=80=D0=B0=D0=BD=D0=B8=D1=86=D0=B0 =
=D0=BD=D0=B5 =D0=B1=D1=8B=D0=BB=D0=B0
> > =D0=B7=D0=B0=D0=B1=D0=BB=D0=BE=D0=BA=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=
=BD=D0=B0, =D0=BF=D0=BE=D1=81=D0=BA=D0=BE=D0=BB=D1=8C=D0=BA=D1=83 ceph_wbc.=
locked_pages =D0=BE=D1=81=D1=82=D0=B0=D1=91=D1=82=D1=81=D1=8F =D1=80=D0=B0=
=D0=B2=D0=BD=D1=8B=D0=BC 0.
>
> It haven't made your statement more clear. :)
>
> As far as I can see, this statement has no connection to the patch 2. It =
is more
> relevant to the patch 3.
>
> >
> > It's likely that I didn't phrase the English version clearly enough.
> > Do you have a clearer phrasing I could use? This is the central point
> > of this patch, so it's crucial that it's well-understood.
> >
> > >
> > > > to handle abandonment of a locked batch, change the return type of
> > > > ceph_process_folio_batch() to `void` and remove the pathological go=
to in
> > > > the writeback loop. The lack of a return code emphasizes that
> > > > ceph_process_folio_batch() is designed to be abort-free: that is, o=
nce
> > > > it commits a folio for writeback, it will not later abandon it or
> > > > propagate an error for that folio.
> > >
> > > I think you need to explain your point more clear. Currently, I am no=
t convinced
> > > that this modification makes sense.
> >
> > ACK; a good commit message needs to be clear to everyone. I'm not sure
> > where I went wrong in my wording, but I'll try to restate my thought
> > process; so maybe you can tell me where I lose you:
> > 1) At this point in the series (after patch 1 is applied), there is no
> > remaining possible way for ceph_process_folio_batch() to return a
> > nonzero value. All possible codepaths result in rc=3D0.
>
> I am still not convinced that patch 1 is correct.

Then we should resolve patch 1 first before continuing with this
discussion. This patch is predicated on the correctness of patch 1, so
until that premise is agreed upon, any review of this patch is
necessarily blocked on that outcome.

If you have specific technical objections to patch 1, let=E2=80=99s address
those directly in that thread. Once we reach a consensus there, we can
continue the discussion of this patch on solid ground.


> So, we should expect to
> receive error code from move_dirty_folio_in_page_array(), especially for =
the
> case if no one folio has been processed. And if no one folio has been pro=
cessed,
> then we need to return error code.
>
> The ceph_process_folio_batch() is complex function and we need to have th=
e way
> to return the error code from internal function's logic to the caller's l=
ogic.
> We cannot afford not to have the return error code from this function. Be=
cause
> we need to be ready to release unprocessed folios if something was wrong =
in the
> function's logic.
>
> Thanks,
> Slava.
>
> > 2) Therefore, the `if` statement that checks the
> > ceph_process_folio_batch() return code is dead code.
> > 3) Trying to `goto release_folios` when the page array is active
> > constitutes a bug. So the `if (!ceph_wbc.locked_pages) goto
> > release_folios;` condition is correct, but the `if (rc) goto
> > release_folios;` is incorrect. (It's dead code anyway, see #2 above.)
> > 4) Therefore, delete the `if (rc) goto release_folios;` dead code and
> > rely solely on `if (!ceph_wbc.locked_pages) goto release_folios;`
> > 5) Since we aren't using the return code of ceph_process_folio_batch()
> > -- a static function with no other callers -- it should not return a
> > status in the first place.
> > 6) By design ceph_process_folio_batch() is a "best-effort" function:
> > it tries to lock as many pages as it *can* (and that might be 0!) and
> > returns once it can't proceed. It is *not* allowed to abort: that is,
> > it cannot commit some pages for writeback, then change its mind and
> > prevent writeback of the whole batch.
> > 7) Removing the return code from ceph_process_folio_batch() does not
> > prevent ceph_writepages_start() from knowing if a failure happened on
> > the first folio. ceph_writepages_start() already checks whether
> > ceph_wbc.locked_pages =3D=3D 0.
> > 8) Removing the return code from ceph_process_folio_batch() *does*
> > prevent ceph_writepages_start() from knowing *what* went wrong when
> > the first folio failed, but ceph_writepages_start() wasn't doing
> > anything with that information anyway. It only cared about the error
> > status as a boolean.
> > 9) Most importantly: This patch does NOT constitute a behavioral
> > change. It is removing unreachable (and, when reached, buggy)
> > codepaths.
> >
> > Warm regards,
> > Sam
> >
> >
> >
> > >
> > > Thanks,
> > > Slava.
> > >
> > > >
> > > > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > > > ---
> > > >  fs/ceph/addr.c | 17 +++++------------
> > > >  1 file changed, 5 insertions(+), 12 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > > index 3462df35d245..2b722916fb9b 100644
> > > > --- a/fs/ceph/addr.c
> > > > +++ b/fs/ceph/addr.c
> > > > @@ -1283,16 +1283,16 @@ static inline int move_dirty_folio_in_page_=
array(struct address_space *mapping,
> > > >  }
> > > >
> > > >  static
> > > > -int ceph_process_folio_batch(struct address_space *mapping,
> > > > -                          struct writeback_control *wbc,
> > > > -                          struct ceph_writeback_ctl *ceph_wbc)
> > > > +void ceph_process_folio_batch(struct address_space *mapping,
> > > > +                           struct writeback_control *wbc,
> > > > +                           struct ceph_writeback_ctl *ceph_wbc)
> > > >  {
> > > >       struct inode *inode =3D mapping->host;
> > > >       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode)=
;
> > > >       struct ceph_client *cl =3D fsc->client;
> > > >       struct folio *folio =3D NULL;
> > > >       unsigned i;
> > > > -     int rc =3D 0;
> > > > +     int rc;
> > > >
> > > >       for (i =3D 0; can_next_page_be_processed(ceph_wbc, i); i++) {
> > > >               folio =3D ceph_wbc->fbatch.folios[i];
> > > > @@ -1322,12 +1322,10 @@ int ceph_process_folio_batch(struct address=
_space *mapping,
> > > >               rc =3D ceph_check_page_before_write(mapping, wbc,
> > > >                                                 ceph_wbc, folio);
> > > >               if (rc =3D=3D -ENODATA) {
> > > > -                     rc =3D 0;
> > > >                       folio_unlock(folio);
> > > >                       ceph_wbc->fbatch.folios[i] =3D NULL;
> > > >                       continue;
> > > >               } else if (rc =3D=3D -E2BIG) {
> > > > -                     rc =3D 0;
> > > >                       folio_unlock(folio);
> > > >                       ceph_wbc->fbatch.folios[i] =3D NULL;
> > > >                       break;
> > > > @@ -1369,7 +1367,6 @@ int ceph_process_folio_batch(struct address_s=
pace *mapping,
> > > >               rc =3D move_dirty_folio_in_page_array(mapping, wbc, c=
eph_wbc,
> > > >                               folio);
> > > >               if (rc) {
> > > > -                     rc =3D 0;
> > > >                       folio_redirty_for_writepage(wbc, folio);
> > > >                       folio_unlock(folio);
> > > >                       break;
> > > > @@ -1380,8 +1377,6 @@ int ceph_process_folio_batch(struct address_s=
pace *mapping,
> > > >       }
> > > >
> > > >       ceph_wbc->processed_in_fbatch =3D i;
> > > > -
> > > > -     return rc;
> > > >  }
> > > >
> > > >  static inline
> > > > @@ -1685,10 +1680,8 @@ static int ceph_writepages_start(struct addr=
ess_space *mapping,
> > > >                       break;
> > > >
> > > >  process_folio_batch:
> > > > -             rc =3D ceph_process_folio_batch(mapping, wbc, &ceph_w=
bc);
> > > > +             ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> > > >               ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
> > > > -             if (rc)
> > > > -                     goto release_folios;
> > > >
> > > >               /* did we get anything? */
> > > >               if (!ceph_wbc.locked_pages)

