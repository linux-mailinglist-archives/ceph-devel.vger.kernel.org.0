Return-Path: <ceph-devel+bounces-4344-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 578A3D069CD
	for <lists+ceph-devel@lfdr.de>; Fri, 09 Jan 2026 01:31:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10023302E06F
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Jan 2026 00:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CA61E633C;
	Fri,  9 Jan 2026 00:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBLYha5Z"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EFA199949
	for <ceph-devel@vger.kernel.org>; Fri,  9 Jan 2026 00:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767918611; cv=none; b=Udz/2FbU2WF/1tnN/sp6/v7tE/cjfVeSVbwTkaj5PpGMJrKBT8M2k1N0yVemjxsMQvaRWgUAfn6HS/KrLfLgNFqNslDYs0GJ6Q3uWBzICnQOdu2Gr/JfzKLQe+lFN6V0GJUlgDqdTZ8y+YhjaKBdYjwrMhUegMN/DfoirRXu6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767918611; c=relaxed/simple;
	bh=FQevz05rTmEcBW13DrlcKq2QCO7ffBl0HPj3LkzAk64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pF2GDw5Dd13i0agiY9RPLAEhO4ewg+BeJVYbio0pYYLjuraFFGQoMdNwf5ZuQmjn4mALKGRBJ5tEBr8nhf18CLj5CHEebo5ciSkp7H5hM93S0ey2EHIt14J62hBn08RR5/x6X2WD5gSjanucLNuyOabdurs9LP9paZXsCVu8BQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBLYha5Z; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-430f57cd471so1954336f8f.0
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jan 2026 16:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767918608; x=1768523408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaPVvzJ4LbN1B2Y4P2DX67AxqOr8ShRD2iMYaC6rtCM=;
        b=hBLYha5ZPBr/nEDWRrSx2uQLBDifpLkhH5ZAhWKlQgi+2mCYqOVJJine3e3EOrzkQk
         ktYg9jTCES5v7zkjE2Tku8tGEsc/xaARIRrhUqzln4HNGrhUhB6PZkc8NdoOqtpjT6La
         XYscjFaks690jEW6NmmUBmZYx9azXRwBGMM3jGVZob0J+nT3T6bicUejSw/XTST5DrzB
         ZpBwRpF1iykkq7a6wPkEXwQGr3jOISKLWxABlO2N/z4CzYw6+UhHeAqPyErREbPNppxR
         U9+Kp93tF6VA+WNj2GDbmoX8277Ja0oTlFhi2BxUrMNZcMk9C0hlbjMNAn/k8JNOEDt2
         CwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767918608; x=1768523408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CaPVvzJ4LbN1B2Y4P2DX67AxqOr8ShRD2iMYaC6rtCM=;
        b=DpXSMb9sJdfyAZLQUWGyENjSMn5FB9wJLati9p4kY5XqoRQkkfMNp5Z7fwoPwQqIDa
         66bfF4gsbMTgPPOnX7hNAoIzXiaAGGc8ZEHkFMRLn9tnKaRBvfXu+WXRNXT2vYCpuARV
         yCF3e+hx7/QXrd+tPOZvoDMFX70js1HReS5sbYkzeSgYz4h3+QCzRdfDvx9pXP+TkRG4
         u+2QmgmmTEVO8n00nbqNjCRbNYReKnrw0e6JypQdo8+Oxs3YQBMbRhhqGkgtlRVEWrNg
         maRJCNHvI+puV/rtjxN9pijUUCPKRVArIPcQnxQNrlknsXlLz9F750P2Rdo5bi8u/Ykr
         EQIQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5SiLzJKNADY64FtPXBSgtE2vb1NwMa44EqO+aoTO87bZutcLxvG5YS3ZKBCPlY/8wq3Uoleo24QaE@vger.kernel.org
X-Gm-Message-State: AOJu0YzWO14VzLhJYJmtUu/ajpjYStXypj+i84mrv/idl2hpwklyUdEq
	ea+YPB73Xft1Y7oOFlMzcfDNpPFLUijFQsb7oAV0Gum07/6KCXWnaMxGa1pFhELXPqDTdVK3MaD
	zREL/y0qzToPRcEVGc02gHsQnRNp308M=
X-Gm-Gg: AY/fxX5laHx3F6cDrMRlbj5aJIMP/zFHCG1b+6RggzgFxCGRuq1YtCx/RaOqlTYH/mI
	8YgBY9okuoZa68jGCKmgwOuDBpyfF5yTNwBNIadfz9oyy7qhKi5+rnxO+diYmZ/IsTUuqb4fqCJ
	6oNXOP2cwsgCdzbkgxdeGIAkrwjJ7GHeKqiqE6WuIOXawLwAVIxko7OJH8WsHq9e3Sxl4zXSmli
	nDPm9oxam29V4rUa0nFTLimrQziuxfAlFzLcFmgZ223Z7VlHuXorAiODBc7HVmeCdl10memlCw3
	x1gayw==
X-Google-Smtp-Source: AGHT+IHX18AD6wCneFN/Depby87XqaBLWuU70jvGkwVCMMuKK91HmvxyJzt6rAr2bsWLfkF8p0SYmjCz9GWTrqupIwc=
X-Received: by 2002:a05:6000:420c:b0:431:67d:5390 with SMTP id
 ffacd0b85a97d-432c37757demr11199309f8f.54.1767918607480; Thu, 08 Jan 2026
 16:30:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210139.40554-1-CFSworks@gmail.com> <20260107210139.40554-3-CFSworks@gmail.com>
 <a16c48a05998429d26f68887cad4abec045869c7.camel@ibm.com>
In-Reply-To: <a16c48a05998429d26f68887cad4abec045869c7.camel@ibm.com>
From: Sam Edwards <cfsworks@gmail.com>
Date: Thu, 8 Jan 2026 16:29:56 -0800
X-Gm-Features: AZwV_Qhs1bYnF1ylgDtcnuHMu2faQRYszJb8TUTX8484Oc-ZB76U1YiGtjr8ibg
Message-ID: <CAH5Ym4jn8wg+mYGqKGb17OZGBkyDeX-Vx3wgfVT0cqPtn36QFQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ceph: Remove error return from ceph_process_folio_batch()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Xiubo Li <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	Milind Changire <mchangir@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "brauner@kernel.org" <brauner@kernel.org>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 12:08=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2026-01-07 at 13:01 -0800, Sam Edwards wrote:
> > Following the previous patch, ceph_process_folio_batch() no longer
> > returns errors because the writeback loop cannot handle them.
> >
> > Since this function already indicates failure to lock any pages by
> > leaving `ceph_wbc.locked_pages =3D=3D 0`, and the writeback loop has no=
 way
> > to handle abandonment of a locked batch, change the return type of
> > ceph_process_folio_batch() to `void` and remove the pathological goto i=
n
> > the writeback loop. The lack of a return code emphasizes that
> > ceph_process_folio_batch() is designed to be abort-free: that is, once
> > it commits a folio for writeback, it will not later abandon it or
> > propagate an error for that folio.
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
>
>  I don't see the point of removing the returning error code from the func=
tion. I
> prefer to have it because this method calls other ones with complex
> functionality.

Hey Slava,

I've tried to clarify this patch a few ways now, but I still haven't
seen actionable technical feedback, only misunderstanding or
preference rather than concrete issues. I'm making one last, detailed
attempt to explain the rationale; if it still isn't clear, I believe
our only remaining option is to involve another maintainer to help
complete the review.

As the function ceph_process_folio_batch() exists today (i.e. in
Linus's tree), the API allows for 3 different possible outcomes (names
my own, for illustrative purposes):
- ERROR (rc !=3D 0): The function returns an error code, maybe after
already allocating the page array and locking some pages, maybe not.
It's ambiguous.
- EMPTY (!rc && !locked_pages): The function executes normally, but
does not lock any folios. It may do this if it encounters a problem on
the first folio.
- LOCKED (!rc && locked_pages >=3D 1): The function executes to
completion without erroring after locking at least one folio. It may
have encountered errors on subsequent folios, but it handles these by
flushing the batch and trying again next time it's called.

The ceph_writepages_start() loop that calls it, today, does not
differentiate between the ERROR and EMPTY result:

if (rc)
    goto release_folios;

/* did we get anything? */
if (!ceph_wbc.locked_pages)
    goto release_folios;

So right now it's just a redundant degree of freedom. Standard
software engineering principles dictate that a function's API should
not create complexity beyond the actual needs of its caller. So either
we remove EMPTY... or remove ERROR.

The current problem with ERROR is that it (often, not always) results
in a crash: the loop will come around without freeing the page array
and violate the expectations of the next iteration, and we violate the
BUG_ON() in ceph_allocate_page_array(). The loop is, today, not
written in a way that "aborting" a batch is ever appropriate; it
assumes the page array only exists when LOCKED. We must either add
logic to the caller to fix it... or remove ERROR.

The only way that the ERROR result could occur today is if fscrypt is
enabled, the write storm bug is fixed, and a non-first folio fails its
bounce page allocation. That means that it isn't possible now, and it
wouldn't be made possible by applying this patchset. The "no dead
code" rule requires that we either add some logic to
ceph_allocate_page_array() that can actually result in ERROR... or
remove ERROR.

Finally, there is a big advantage to removing the return code from
ceph_process_folio_batch(): it uses C's type system to enforce the
guarantee that it doesn't abandon the page array. (Note! That does not
mean that ceph_process_folio_batch() is not allowed to encounter
failures -- I fully agree that it's a complex function and it may have
more fallible logic added in the future -- just that it is responsible
for cleaning up after those failures. Put simply, the lack of a return
code gives it no way for it to make the cleanup the caller's problem!)

> And I would like still save the path of returning error code from
> the function. So, I don't agree with this patch.

It can always be brought back in the future if something genuinely
needs it (such as a hypothetical "major failure" in
ceph_process_folio_batch() that needs to fail the entire writeback,
not merely retry). But Linux doesn't keep "vestigial" code around for
hypothetical future needs. If there isn't a concrete reason to add or
use it now, then there's no reason to preserve it.

Hope this helps,
Sam

>
> Thanks,
> Slava.

