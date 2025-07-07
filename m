Return-Path: <ceph-devel+bounces-3271-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76A91AFB0D3
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 12:11:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7BCD3A59AD
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Jul 2025 10:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F66291C29;
	Mon,  7 Jul 2025 10:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+aWsKmV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E8DDA9
	for <ceph-devel@vger.kernel.org>; Mon,  7 Jul 2025 10:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751883097; cv=none; b=FvMuadNUxgg1Gmbacm9k9+q51v4pepePosechjKxM3j1PNsNRuuB4J2PHup0ANmgk0WGpDmYFp2td8vWdE5k/gc6uQTh383npIXz6XKv3HbTTB1IiDwuJQTwjhc0eyAuCEE+JCAANu3j47d1yNS6fY5QaG/mP6J9dkmK2wmigPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751883097; c=relaxed/simple;
	bh=apeHThVLY33ysys0ns2kQdX7kZDYMyRR2zqYSSLG+UE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W2zNi5iFC6OvKWtk0gxzNWJUs/BxDW3DyOHTewucJOG3eyvUVBJnL6YeVqIoa8pA/MdDxJoWv3MPsXFJg0n0giD/xD6aZ9SkCv5krLc+VHjXS4L3cbUl3WmIX35e76vSuP9+R6Xu7zmCxpjmkzNWtKdub1G6uW1KxJDpD8pj9ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A+aWsKmV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751883093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F7tRsSnoKak3zvgw3Q/K9RVvMM3Z3IUg0Nhn/aNMlKY=;
	b=A+aWsKmVcY7A8EK1Ygz8ceLts5o0nsnc/At9hX/BDbEkLC/cF7p/DeoXHozXvH4ftbU8tL
	qf5GznMTvB8tVCu/LyzUf97+JkdfBK4oMFxW80J3kr/EcvrT7/CCUv2NuWI3adi5mptEXv
	hDO2TdJ5/GX/sdSvwKGt7mg1aEeXqNI=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-ux0JHi3ANWe3nIFI4wRKsQ-1; Mon, 07 Jul 2025 06:11:31 -0400
X-MC-Unique: ux0JHi3ANWe3nIFI4wRKsQ-1
X-Mimecast-MFC-AGG-ID: ux0JHi3ANWe3nIFI4wRKsQ_1751883091
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-87f21c86defso75557241.0
        for <ceph-devel@vger.kernel.org>; Mon, 07 Jul 2025 03:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751883091; x=1752487891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7tRsSnoKak3zvgw3Q/K9RVvMM3Z3IUg0Nhn/aNMlKY=;
        b=C52Afx8kCDjnbOQUJt/2RwIscdumKSxskLwQ3Y23vKi35hJXy/UGlplv4GCz8YkOfQ
         RQfU2bZwXZHMriM79nMY7+RcLcgq+wMI8/mS3dE4SDzcSAySDXYWERmWeT691moMWTAg
         /iT/D5Pba2CME2irwsV6fhLX+3M6n2NrawofeYfBsT/cUUa/M8rkariEULE6IRHOL9ZJ
         lDIek9DfFsOVFk048cabxns/JMLYhnYlPG+a9g+sf7vXpcr1NT/LpGgs/ZVABI2Ryk+u
         kkiPHd+Xs9AsF0a77vSfQGNUkw7mKEIcs8fz0BAMqF8n1PcWCuDYJg7Mi3aARpnqxWFM
         TUfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUQ3sMskrTPaLpvtE9tTghxZC+vJybH0n2nJ+U15+9pP1UNz0R3rZZzOVdAme41uLYkACaOIflV/KB@vger.kernel.org
X-Gm-Message-State: AOJu0YxZG1V+4zl2BoL45zPE8zBEQq426+h+mWUjDWfsUpU5Epuo3xV8
	dP5oJm5O56vh7v0Fo/+kEUBgnTSa5qnf30eOvIBpBRntINOZWiWMBXRaigh3Vmeqm+N5ro9Ef1T
	rg1SneaAsZHlinjXANSKYpM/EVoLNc2npIbMMPKw/p5bpF7DL6pC4IldKPH5HISQcsqK0lM5wEk
	tgU9roL2vdobd9Pcv/MOxeGdH/cQEnb+9VYWikUg==
X-Gm-Gg: ASbGncvKABcIHBXKDitWud6+vZetGo4C0KOnzaSS6ETR83lVGWvbjzM2vcFWkBW4Q8g
	LHJC5TTia0vqutozEvk7Z0ujRsWcImrGGrt4eibSJPkWkvOJXwZX8ykszXFERJTApmc2Amg2v03
	o+CGiF
X-Received: by 2002:a05:6102:3c83:b0:4e9:b793:1977 with SMTP id ada2fe7eead31-4f2f198657bmr6730567137.0.1751883091013;
        Mon, 07 Jul 2025 03:11:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZk9HP7WquLGz9hJIU3/iitkGK7pyQmFnsHBnwFPfQZvCp3nE527tvdBQMCbV6WsFIk6+2pDQHk5bu0nJ/J4w=
X-Received: by 2002:a05:6102:3c83:b0:4e9:b793:1977 with SMTP id
 ada2fe7eead31-4f2f198657bmr6730560137.0.1751883090654; Mon, 07 Jul 2025
 03:11:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250705155422.802775-1-abinashsinghlalotra@gmail.com>
In-Reply-To: <20250705155422.802775-1-abinashsinghlalotra@gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 7 Jul 2025 13:11:19 +0300
X-Gm-Features: Ac12FXzhZJHBc-jmWn_1riw6N5tTCNRIyO2xwvpd_kNSDAAuVz1F2T4p4yggCpY
Message-ID: <CAO8a2Shw=pkQN21+nzHWQyfF5ygGMtHG1uVn2Cqqi6Bhm8Mhfg@mail.gmail.com>
Subject: Re: [PATCH RFC] fs/ceph : fix build warning in ceph_writepages_start()
To: Abinash Singh <abinashlalotra@gmail.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Abinash Singh <abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Abinash,

Thanks for your patch, you=E2=80=99ve correctly identified a real concern
around stack usage in ceph_writepages_start().

However, dynamically allocating ceph_writeback_ctl inside .writepages
isn't ideal. This function may be called in memory reclaim paths or
under writeback pressure, where any GFP allocation (even GFP_NOFS)
could deadlock or fail unexpectedly.

Instead of allocating the struct on each call, I=E2=80=99d suggest one of t=
he following:

Add a dedicated kmem_cache for ceph_writeback_ctl, initialized during
Ceph FS client init.
This allows reuse across calls without hitting the slab allocator each time=
.

Embed a ceph_writeback_ctl struct inside ceph_inode_info, if it's
feasible to manage lifetimes and synchronization. Note that
.writepages can run concurrently on the same inode, so this approach
would require proper locking or reuse guarantees.

On Sat, Jul 5, 2025 at 6:54=E2=80=AFPM Abinash Singh <abinashlalotra@gmail.=
com> wrote:
>
> The function `ceph_writepages_start()` triggers
> a large stack frame warning:
> ld.lld: warning:
>         fs/ceph/addr.c:1632:0: stack frame size (1072) exceeds limit (102=
4) in function 'ceph_writepages_start.llvm.2555023190050417194'
>
> fix it by dynamically allocating `ceph_writeback_ctl` struct.
>
> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
> ---
> The high stack usage of ceph_writepages_start() was further
> confirmed by using -fstack-usage flag :
> ...
> fs/ceph/addr.c:1837:ceph_netfs_check_write_begin        104     static
> fs/ceph/addr.c:1630:ceph_writepages_start       648     static
> ...
> After optimzations it may go upto 1072 as seen in warning.
> After allocating `ceph_writeback_ctl` struct it is reduced to:
> ...
> fs/ceph/addr.c:1630:ceph_writepages_start       288     static
> fs/ceph/addr.c:81:ceph_dirty_folio      72      static
> ...
> Is this fun used very frequently ?? or dynamic allocation is
> a fine fix for reducing the stack usage ?
>
> Thank You
> ---
>  fs/ceph/addr.c | 82 ++++++++++++++++++++++++++------------------------
>  1 file changed, 43 insertions(+), 39 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 60a621b00c65..503a86c1dda6 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1633,9 +1633,13 @@ static int ceph_writepages_start(struct address_sp=
ace *mapping,
>         struct inode *inode =3D mapping->host;
>         struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
>         struct ceph_client *cl =3D fsc->client;
> -       struct ceph_writeback_ctl ceph_wbc;
> +       struct ceph_writeback_ctl *ceph_wbc __free(kfree) =3D NULL;
>         int rc =3D 0;
>
> +       ceph_wbc =3D kmalloc(sizeof(*ceph_wbc), GFP_NOFS);
> +       if (!ceph_wbc)
> +               return -ENOMEM;
> +
>         if (wbc->sync_mode =3D=3D WB_SYNC_NONE && fsc->write_congested)
>                 return 0;
>
> @@ -1648,7 +1652,7 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>                 return -EIO;
>         }
>
> -       ceph_init_writeback_ctl(mapping, wbc, &ceph_wbc);
> +       ceph_init_writeback_ctl(mapping, wbc, ceph_wbc);
>
>         if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
>                 rc =3D -EIO;
> @@ -1656,7 +1660,7 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>         }
>
>  retry:
> -       rc =3D ceph_define_writeback_range(mapping, wbc, &ceph_wbc);
> +       rc =3D ceph_define_writeback_range(mapping, wbc, ceph_wbc);
>         if (rc =3D=3D -ENODATA) {
>                 /* hmm, why does writepages get called when there
>                    is no dirty data? */
> @@ -1665,55 +1669,55 @@ static int ceph_writepages_start(struct address_s=
pace *mapping,
>         }
>
>         if (wbc->sync_mode =3D=3D WB_SYNC_ALL || wbc->tagged_writepages)
> -               tag_pages_for_writeback(mapping, ceph_wbc.index, ceph_wbc=
.end);
> +               tag_pages_for_writeback(mapping, ceph_wbc->index, ceph_wb=
c->end);
>
> -       while (!has_writeback_done(&ceph_wbc)) {
> -               ceph_wbc.locked_pages =3D 0;
> -               ceph_wbc.max_pages =3D ceph_wbc.wsize >> PAGE_SHIFT;
> +       while (!has_writeback_done(ceph_wbc)) {
> +               ceph_wbc->locked_pages =3D 0;
> +               ceph_wbc->max_pages =3D ceph_wbc->wsize >> PAGE_SHIFT;
>
>  get_more_pages:
> -               ceph_folio_batch_reinit(&ceph_wbc);
> +               ceph_folio_batch_reinit(ceph_wbc);
>
> -               ceph_wbc.nr_folios =3D filemap_get_folios_tag(mapping,
> -                                                           &ceph_wbc.ind=
ex,
> -                                                           ceph_wbc.end,
> -                                                           ceph_wbc.tag,
> -                                                           &ceph_wbc.fba=
tch);
> +               ceph_wbc->nr_folios =3D filemap_get_folios_tag(mapping,
> +                                                           &ceph_wbc->in=
dex,
> +                                                           ceph_wbc->end=
,
> +                                                           ceph_wbc->tag=
,
> +                                                           &ceph_wbc->fb=
atch);
>                 doutc(cl, "pagevec_lookup_range_tag for tag %#x got %d\n"=
,
> -                       ceph_wbc.tag, ceph_wbc.nr_folios);
> +                       ceph_wbc->tag, ceph_wbc->nr_folios);
>
> -               if (!ceph_wbc.nr_folios && !ceph_wbc.locked_pages)
> +               if (!ceph_wbc->nr_folios && !ceph_wbc->locked_pages)
>                         break;
>
>  process_folio_batch:
> -               rc =3D ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
> +               rc =3D ceph_process_folio_batch(mapping, wbc, ceph_wbc);
>                 if (rc)
>                         goto release_folios;
>
>                 /* did we get anything? */
> -               if (!ceph_wbc.locked_pages)
> +               if (!ceph_wbc->locked_pages)
>                         goto release_folios;
>
> -               if (ceph_wbc.processed_in_fbatch) {
> -                       ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
> +               if (ceph_wbc->processed_in_fbatch) {
> +                       ceph_shift_unused_folios_left(&ceph_wbc->fbatch);
>
> -                       if (folio_batch_count(&ceph_wbc.fbatch) =3D=3D 0 =
&&
> -                           ceph_wbc.locked_pages < ceph_wbc.max_pages) {
> +                       if (folio_batch_count(&ceph_wbc->fbatch) =3D=3D 0=
 &&
> +                           ceph_wbc->locked_pages < ceph_wbc->max_pages)=
 {
>                                 doutc(cl, "reached end fbatch, trying for=
 more\n");
>                                 goto get_more_pages;
>                         }
>                 }
>
> -               rc =3D ceph_submit_write(mapping, wbc, &ceph_wbc);
> +               rc =3D ceph_submit_write(mapping, wbc, ceph_wbc);
>                 if (rc)
>                         goto release_folios;
>
> -               ceph_wbc.locked_pages =3D 0;
> -               ceph_wbc.strip_unit_end =3D 0;
> +               ceph_wbc->locked_pages =3D 0;
> +               ceph_wbc->strip_unit_end =3D 0;
>
> -               if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
> -                       ceph_wbc.nr_folios =3D
> -                               folio_batch_count(&ceph_wbc.fbatch);
> +               if (folio_batch_count(&ceph_wbc->fbatch) > 0) {
> +                       ceph_wbc->nr_folios =3D
> +                               folio_batch_count(&ceph_wbc->fbatch);
>                         goto process_folio_batch;
>                 }
>
> @@ -1724,38 +1728,38 @@ static int ceph_writepages_start(struct address_s=
pace *mapping,
>                  * we tagged for writeback prior to entering this loop.
>                  */
>                 if (wbc->nr_to_write <=3D 0 && wbc->sync_mode =3D=3D WB_S=
YNC_NONE)
> -                       ceph_wbc.done =3D true;
> +                       ceph_wbc->done =3D true;
>
>  release_folios:
>                 doutc(cl, "folio_batch release on %d folios (%p)\n",
> -                     (int)ceph_wbc.fbatch.nr,
> -                     ceph_wbc.fbatch.nr ? ceph_wbc.fbatch.folios[0] : NU=
LL);
> -               folio_batch_release(&ceph_wbc.fbatch);
> +                     (int)ceph_wbc->fbatch.nr,
> +                     ceph_wbc->fbatch.nr ? ceph_wbc->fbatch.folios[0] : =
NULL);
> +               folio_batch_release(&ceph_wbc->fbatch);
>         }
>
> -       if (ceph_wbc.should_loop && !ceph_wbc.done) {
> +       if (ceph_wbc->should_loop && !ceph_wbc->done) {
>                 /* more to do; loop back to beginning of file */
>                 doutc(cl, "looping back to beginning of file\n");
>                 /* OK even when start_index =3D=3D 0 */
> -               ceph_wbc.end =3D ceph_wbc.start_index - 1;
> +               ceph_wbc->end =3D ceph_wbc->start_index - 1;
>
>                 /* to write dirty pages associated with next snapc,
>                  * we need to wait until current writes complete */
> -               ceph_wait_until_current_writes_complete(mapping, wbc, &ce=
ph_wbc);
> +               ceph_wait_until_current_writes_complete(mapping, wbc, cep=
h_wbc);
>
> -               ceph_wbc.start_index =3D 0;
> -               ceph_wbc.index =3D 0;
> +               ceph_wbc->start_index =3D 0;
> +               ceph_wbc->index =3D 0;
>                 goto retry;
>         }
>
> -       if (wbc->range_cyclic || (ceph_wbc.range_whole && wbc->nr_to_writ=
e > 0))
> -               mapping->writeback_index =3D ceph_wbc.index;
> +       if (wbc->range_cyclic || (ceph_wbc->range_whole && wbc->nr_to_wri=
te > 0))
> +               mapping->writeback_index =3D ceph_wbc->index;
>
>  dec_osd_stopping_blocker:
>         ceph_dec_osd_stopping_blocker(fsc->mdsc);
>
>  out:
> -       ceph_put_snap_context(ceph_wbc.last_snapc);
> +       ceph_put_snap_context(ceph_wbc->last_snapc);
>         doutc(cl, "%llx.%llx dend - startone, rc =3D %d\n", ceph_vinop(in=
ode),
>               rc);
>
> --
> 2.43.0
>
>


