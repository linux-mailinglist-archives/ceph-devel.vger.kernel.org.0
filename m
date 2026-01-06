Return-Path: <ceph-devel+bounces-4261-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C19FCF6ED5
	for <lists+ceph-devel@lfdr.de>; Tue, 06 Jan 2026 07:52:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1AA953002D09
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jan 2026 06:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16992C11E4;
	Tue,  6 Jan 2026 06:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="elsMtFIA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3EA1C3BF7
	for <ceph-devel@vger.kernel.org>; Tue,  6 Jan 2026 06:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682352; cv=none; b=iqwIXSNsps631B/rCphVFm1d9cDPIvE5R54G2pR/ZdygBhZlmRqGcWwo/V17M/2n8bYuql8F8KE2noO6QB6YjR3g6t7qiW8KM5MgBVIpwUc3GgYRhx98/aLL5U1eYh6MlCvI3ipIYHGAfMRZSsShNGLSBqG3xDAiNIN1qtRJ8A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682352; c=relaxed/simple;
	bh=/XrHwl9B2lzpGStZjpwEbc6GmdX7hjuAv2coJSxoCO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IUSPmkZ+rmtuPVGcwupye6/MPuCjIEAF019hcFEISTPCFyyZgOIRMVsV0mp2aU5NXboHCTCwM5QCUXkXeDgi6EJuq5lrqeTbMYLQ85CIB5bZgf4ON1AIIMgbVVPTqyZNshf3Hguqt5JF2PTtVulVQNUfZgpjBL5ZUo5zV6t/XGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=elsMtFIA; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47d182a8c6cso3703585e9.1
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 22:52:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767682349; x=1768287149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kszWgAibya6Pa2dpLnyise6dFNb/PgUdYWjpP6yPYk=;
        b=elsMtFIAUz+VfrrZ5G5fwWhp+sa9Emr2iiGmS+lwsNdbphjv0UIecFKMQvo5NyMnhN
         SiL7Goy0gPAjiwznIN8eAahEJgCirParM39s3ypy8wSC+HN0q1epkSJJDe6zBbeN2Tob
         17wVl5Vt7cqlYg+TMISwuQK5csBlv1EpEwNwSCeq5zK9THwZpM5UctjqBvjRa+i2g5xv
         eE7mg3PpScZa8XNe4/gCMQN4Gu11k9ZI/5aAbKTbsJZosbo32eVyu2cwXeqYHDeGyV07
         1tzQnjLEg9Aqxe4RBgjZsB4Jv+AfDawofxHIUUzvydu88A4xG1RzReLgPGzFvJd9j4eI
         4d5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767682349; x=1768287149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8kszWgAibya6Pa2dpLnyise6dFNb/PgUdYWjpP6yPYk=;
        b=B00cKtiZ5WWghTVerWjNWPtoxcqiyNhdgz2MtQgQ8Pvv1rnwLQBQjba/nW5oyfeolX
         cqM4BgKbpEgRt59DBDsWV/7m4JmNAnHmD5qCTQgd0PBXQ3vbSsI0lIt+mGGqFlEeZTRD
         ZCdbhYXhZnlf2/IdwDtAIpl18oD0X8nZBMFOvZdJNbw9ZQUYOkMD7OPkG+IJVpFQLlm6
         Dzsy2P3dtICj+6zakABnFq/YIFg6w6GiDgRg/yC7mueNSm3h+0evBMML1WxSU0oOFk+R
         UCwS1ncR6CdQWv0OJZ+pHMAm5VKjecS6dvxQZPKw7Y2pwCmIxPJnAbMR749NBdsj7dct
         0rpg==
X-Forwarded-Encrypted: i=1; AJvYcCX1hmuLWqrYKXopNrWVv3a9M1Dq1nixGCEa4v+UQ9QpXcQfGveQEC8fH3MVvEHQ6ZhMYexXiL0QbjbZ@vger.kernel.org
X-Gm-Message-State: AOJu0YweyRjlhQ73/FFK904izQpdtDXmSlFl8GHMUvnxX/QG/HxW4nRd
	IHfXASwXkbvrFStGNcTgFRuUVXlTWYCs7sAXwkAOdIg3c8PVqwSTmfgCiqSAJFZ6eRTd+XzxoaR
	Kvpt6q0ViHxQg/K8jt4f4kpEOKjX2TuA=
X-Gm-Gg: AY/fxX6UyQ6MCCuSRyyoNvs9R3JvKonGv23hZh5KoQenkjJIHqAlOoy0w6tPZyoJr31
	QwWeAZPdu/p5AHlg+ddZpgYe+K/xzNOr9leGuIV238BfrgNA9hZYmswdR9ULH0Ef+gh+gZx5aCm
	/8PdholAiQNCgMWD9RNH11Y85lGEOHLmXx9ijD1Ir9/hdZHwh0Xf0pxINmT6PHqdBlhsra9G1id
	x0L1RTDGZ+pOmXK5PU6foJHi0fLQflZd/Dyj3QXw6XbWTzPum/jLzMGETvrJPW/BETfGkS9jaAh
	niOVDBLxTZY2QQm1EUiDwB0pHIFg
X-Google-Smtp-Source: AGHT+IGYD/4oaeZFGD8g/XwhYaXs9oIED78402CdDy1QTBueC2hLPxNXvXj3gMAVzr8s+MUavsobMwbo9aw5MtQ69LU=
X-Received: by 2002:a05:600c:620c:b0:47a:7fdd:2906 with SMTP id
 5b1f17b1804b1-47d7f0675f5mr22967325e9.12.1767682349169; Mon, 05 Jan 2026
 22:52:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251231024316.4643-1-CFSworks@gmail.com> <20251231024316.4643-3-CFSworks@gmail.com>
 <fe859743904a2add8d7d67f64ab9686769670782.camel@ibm.com>
In-Reply-To: <fe859743904a2add8d7d67f64ab9686769670782.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Mon, 5 Jan 2026 22:52:17 -0800
X-Gm-Features: AQt7F2qSMaDQuAsTU099Mtksbe1TOsnwwrmcaOvUfvxyvBKLdqY4MZNKFgENhOY
Message-ID: <CAH5Ym4jnsYNp7Y5icBtQJZvX_JW=nvprj61ZH1XDX3Js0ePggA@mail.gmail.com>
Subject: Re: [PATCH 2/5] ceph: Remove error return from ceph_process_folio_batch()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Milind Changire <mchangir@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 5, 2026 at 12:36=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Tue, 2025-12-30 at 18:43 -0800, Sam Edwards wrote:
> > Following the previous patch, ceph_process_folio_batch() no longer
> > returns errors because the writeback loop cannot handle them.
>

Hi Slava,

> I am not completely convinced that we can remove returning error code her=
e. What
> if we don't process any folio in ceph_process_folio_batch(), then we cann=
ot call
> the ceph_submit_write(). It sounds to me that we need to have error code =
to jump
> to release_folios in such case.

This goto is already present (search the comment "did we get anything?").

>
> >
> > Since this function already indicates failure to lock any pages by
> > leaving `ceph_wbc.locked_pages =3D=3D 0`, and the writeback loop has no=
 way
>
> Frankly speaking, I don't quite follow what do you mean by "this function
> already indicates failure to lock any pages". What do you mean here?

I feel like there's a language barrier here. I understand from your
homepage that you speak Russian. I believe the Russian translation of
what I'm trying to say is:

=D0=AD=D1=82=D0=B0 =D1=84=D1=83=D0=BD=D0=BA=D1=86=D0=B8=D1=8F =D1=83=D0=B6=
=D0=B5 =D1=81=D0=B8=D0=B3=D0=BD=D0=B0=D0=BB=D0=B8=D0=B7=D0=B8=D1=80=D1=83=
=D0=B5=D1=82 =D0=BE =D1=82=D0=BE=D0=BC, =D1=87=D1=82=D0=BE =D0=BD=D0=B8 =D0=
=BE=D0=B4=D0=BD=D0=B0 =D1=81=D1=82=D1=80=D0=B0=D0=BD=D0=B8=D1=86=D0=B0 =D0=
=BD=D0=B5 =D0=B1=D1=8B=D0=BB=D0=B0
=D0=B7=D0=B0=D0=B1=D0=BB=D0=BE=D0=BA=D0=B8=D1=80=D0=BE=D0=B2=D0=B0=D0=BD=D0=
=B0, =D0=BF=D0=BE=D1=81=D0=BA=D0=BE=D0=BB=D1=8C=D0=BA=D1=83 ceph_wbc.locked=
_pages =D0=BE=D1=81=D1=82=D0=B0=D1=91=D1=82=D1=81=D1=8F =D1=80=D0=B0=D0=B2=
=D0=BD=D1=8B=D0=BC 0.

It's likely that I didn't phrase the English version clearly enough.
Do you have a clearer phrasing I could use? This is the central point
of this patch, so it's crucial that it's well-understood.

>
> > to handle abandonment of a locked batch, change the return type of
> > ceph_process_folio_batch() to `void` and remove the pathological goto i=
n
> > the writeback loop. The lack of a return code emphasizes that
> > ceph_process_folio_batch() is designed to be abort-free: that is, once
> > it commits a folio for writeback, it will not later abandon it or
> > propagate an error for that folio.
>
> I think you need to explain your point more clear. Currently, I am not co=
nvinced
> that this modification makes sense.

ACK; a good commit message needs to be clear to everyone. I'm not sure
where I went wrong in my wording, but I'll try to restate my thought
process; so maybe you can tell me where I lose you:
1) At this point in the series (after patch 1 is applied), there is no
remaining possible way for ceph_process_folio_batch() to return a
nonzero value. All possible codepaths result in rc=3D0.
2) Therefore, the `if` statement that checks the
ceph_process_folio_batch() return code is dead code.
3) Trying to `goto release_folios` when the page array is active
constitutes a bug. So the `if (!ceph_wbc.locked_pages) goto
release_folios;` condition is correct, but the `if (rc) goto
release_folios;` is incorrect. (It's dead code anyway, see #2 above.)
4) Therefore, delete the `if (rc) goto release_folios;` dead code and
rely solely on `if (!ceph_wbc.locked_pages) goto release_folios;`
5) Since we aren't using the return code of ceph_process_folio_batch()
-- a static function with no other callers -- it should not return a
status in the first place.
6) By design ceph_process_folio_batch() is a "best-effort" function:
it tries to lock as many pages as it *can* (and that might be 0!) and
returns once it can't proceed. It is *not* allowed to abort: that is,
it cannot commit some pages for writeback, then change its mind and
prevent writeback of the whole batch.
7) Removing the return code from ceph_process_folio_batch() does not
prevent ceph_writepages_start() from knowing if a failure happened on
the first folio. ceph_writepages_start() already checks whether
ceph_wbc.locked_pages =3D=3D 0.
8) Removing the return code from ceph_process_folio_batch() *does*
prevent ceph_writepages_start() from knowing *what* went wrong when
the first folio failed, but ceph_writepages_start() wasn't doing
anything with that information anyway. It only cared about the error
status as a boolean.
9) Most importantly: This patch does NOT constitute a behavioral
change. It is removing unreachable (and, when reached, buggy)
codepaths.

Warm regards,
Sam



>
> Thanks,
> Slava.
>
> >
> > Signed-off-by: Sam Edwards <CFSworks@gmail.com>
> > ---
> >  fs/ceph/addr.c | 17 +++++------------
> >  1 file changed, 5 insertions(+), 12 deletions(-)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 3462df35d245..2b722916fb9b 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1283,16 +1283,16 @@ static inline int move_dirty_folio_in_page_arra=
y(struct address_space *mapping,
> >  }
> >
> >  static
> > -int ceph_process_folio_batch(struct address_space *mapping,
> > -                          struct writeback_control *wbc,
> > -                          struct ceph_writeback_ctl *ceph_wbc)
> > +void ceph_process_folio_batch(struct address_space *mapping,
> > +                           struct writeback_control *wbc,
> > +                           struct ceph_writeback_ctl *ceph_wbc)
> >  {
> >       struct inode *inode =3D mapping->host;
> >       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
> >       struct ceph_client *cl =3D fsc->client;
> >       struct folio *folio =3D NULL;
> >       unsigned i;
> > -     int rc =3D 0;
> > +     int rc;
> >
> >       for (i =3D 0; can_next_page_be_processed(ceph_wbc, i); i++) {
> >               folio =3D ceph_wbc->fbatch.folios[i];
> > @@ -1322,12 +1322,10 @@ int ceph_process_folio_batch(struct address_spa=
ce *mapping,
> >               rc =3D ceph_check_page_before_write(mapping, wbc,
> >                                                 ceph_wbc, folio);
> >               if (rc =3D=3D -ENODATA) {
> > -                     rc =3D 0;
> >                       folio_unlock(folio);
> >                       ceph_wbc->fbatch.folios[i] =3D NULL;
> >                       continue;
> >               } else if (rc =3D=3D -E2BIG) {
> > -                     rc =3D 0;
> >                       folio_unlock(folio);
> >                       ceph_wbc->fbatch.folios[i] =3D NULL;
> >                       break;
> > @@ -1369,7 +1367,6 @@ int ceph_process_folio_batch(struct address_space=
 *mapping,
> >               rc =3D move_dirty_folio_in_page_array(mapping, wbc, ceph_=
wbc,
> >                               folio);
> >               if (rc) {
> > -                     rc =3D 0;
> >                       folio_redirty_for_writepage(wbc, folio);
> >                       folio_unlock(folio);
> >                       break;
> > @@ -1380,8 +1377,6 @@ int ceph_process_folio_batch(struct address_space=
 *mapping,
> >       }
> >
> >       ceph_wbc->processed_in_fbatch =3D i;
> > -
> > -     return rc;
> >  }
> >
> >  static inline
> > @@ -1685,10 +1680,8 @@ static int ceph_writepages_start(struct address_=
space *mapping,
> >                       break;
> >
> >  process_folio_batch:
> > -             rc =3D ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> > +             ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> >               ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
> > -             if (rc)
> > -                     goto release_folios;
> >
> >               /* did we get anything? */
> >               if (!ceph_wbc.locked_pages)

