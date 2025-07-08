Return-Path: <ceph-devel+bounces-3281-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A95AFC6EF
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Jul 2025 11:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4890561486
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Jul 2025 09:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABFFE221FA1;
	Tue,  8 Jul 2025 09:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iC2aYOKf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735CD21C177
	for <ceph-devel@vger.kernel.org>; Tue,  8 Jul 2025 09:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751966458; cv=none; b=Q0Xb5aXDheU7YdVcWkHrU2Ep/mF+p2qQsMu+26HsAg8ByosGvS0vKwdBLVL4S7WbABSIB5yLVifnJtJOyRuPWXz+Xx9br+i0m7s/FjQBlXHVsrrZWi7hZSWu2bHDuZp8ebJIWFzIau6PpD8FD8abAFbJ2QVpykxoagC3Sas7esI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751966458; c=relaxed/simple;
	bh=IpLqlakGO0dYzgNzPoDTX29qJioJzgP2kjach7y4DQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YPNpMxi8txKyPKGZGHAYec8F6L6NKA5896vcWqgjfjUYngF88B0/Zed6/cqsMwlbgiraeaCwEkdoZtHHTQrMgpv4tlBD7I3OHRu/AjaWfx+r6FYdeRxclYnJxvUSqOoO5vqTdH3hKBEUW86Qd4hgAB/N2mfegWHo+BgC6dSC3fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iC2aYOKf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751966455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x/uahyItZRG0nlLxP3L4h8kfACmqXsFbM7LCE/QJYEI=;
	b=iC2aYOKfpZs2pMiTQOMDBHktZ6/GcyuFOKVpYX30pbH8uOfvmTyvl9EmSBbRw2JRtmFH57
	H1pKoKqg2HL7J+QEWtn3dwrRWqdX4QKLa4iXe+DjG0/6QRww9xfQESiGmQuEx9RRc1MdjR
	QBvpEzh/GEpZ/NGXbxipE4c/P/FXd3o=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-ayTeA42hNCi8Nulc9YPcEg-1; Tue, 08 Jul 2025 05:20:54 -0400
X-MC-Unique: ayTeA42hNCi8Nulc9YPcEg-1
X-Mimecast-MFC-AGG-ID: ayTeA42hNCi8Nulc9YPcEg_1751966453
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-886dbed0cddso4083329241.3
        for <ceph-devel@vger.kernel.org>; Tue, 08 Jul 2025 02:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751966453; x=1752571253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x/uahyItZRG0nlLxP3L4h8kfACmqXsFbM7LCE/QJYEI=;
        b=UoVMr0lw0A84yyo0Pv+d8xEcBVYsJeFNZ5YE9OGbHDrQns/i0C8X98DavXLxF4TTEf
         37x8ai9ogvRRV5e5dSdlz9OPP/0FH4+JiNo2V+BjhTIQ5oYIxIu3NgBtj6KJrKRue0Vo
         70oObRlYecP9QCPXZdiWN5tYFBROeKjQX+kNq+D1K0gZ65ls3AqGSLf847SbghlctLWB
         aN4ZWlWdR0uZKQ23mjsoZqOq5wP9AOCF2cMv3OWhD9Q7NuSKEwLOkFrgLceoEFuukYaw
         c/ppG6o8z3zgVaH3CtqVRtWKdWSWwkrV5n6ldrBt9xHOJ+rXs4Z8yd/2TpRkCIGAwQRg
         SofQ==
X-Gm-Message-State: AOJu0YyaFUz2oUgDlTxPpla6QzmZ8AXdLfyw9IEFL6MouW+1H5MuWoOw
	ILNpVvBlT1Ueo7q1JiPCZCyDnig5wq3kH3Uyx2/l+J97ufFszspfzB552xvs03cz14jEqs9/7Fb
	gSIHhHLJL5sM/adLyAm0YfvxrGjAKoklHso5/O7Y/z2ewu2+Yp5/fgn3vdg5w5RtvvGBX/5wtPM
	1yYZJwQr+RwSAGSsuXWpmG6lZ5qBc2wSpQpwBoYg==
X-Gm-Gg: ASbGncsvSgKWtUXOY9Ov9RRLCM2hU26FWdjPOjuyxOQBQM+EE9IvPwZ9AXyk5phHsTz
	TsYQWCfil84QHr37syylM3nwVyiZaVYiIMAeRoHm65QGgnKEaeRHv3o/Yo3owRD4Gb55J5xor68
	FTDPf2
X-Received: by 2002:a05:6102:418e:b0:4e7:866c:5cd2 with SMTP id ada2fe7eead31-4f2f1dc3efdmr10836393137.2.1751966453297;
        Tue, 08 Jul 2025 02:20:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/cWL+eD19PpC3voZB9j16Y43OQqB3jGMvWGxuo6b+0fz5KWb6Gc+rg8me1swUCcRIcJRu46uFeX6IxP2wlzs=
X-Received: by 2002:a05:6102:418e:b0:4e7:866c:5cd2 with SMTP id
 ada2fe7eead31-4f2f1dc3efdmr10836385137.2.1751966452864; Tue, 08 Jul 2025
 02:20:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250705155422.802775-1-abinashsinghlalotra@gmail.com>
 <CAO8a2Shw=pkQN21+nzHWQyfF5ygGMtHG1uVn2Cqqi6Bhm8Mhfg@mail.gmail.com>
 <75e7fa30828fdde8b122a6627881a1d9c6bbdcdd.camel@ibm.com> <CAO8a2Sg9bDYu8PQvZrB_pZ6Y7xZk8Di6=pQjc+7EAfZU0H89cw@mail.gmail.com>
 <21543a483bddc0417965ce8114a3dd63255790f0.camel@ibm.com>
In-Reply-To: <21543a483bddc0417965ce8114a3dd63255790f0.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 8 Jul 2025 12:20:42 +0300
X-Gm-Features: Ac12FXx4bzfARZLrl0lrbOH6HBRlQ5afSLgNqz6hL1dGfzXlM3dAylyExoDADFE
Message-ID: <CAO8a2ShwBbMau+N_GstVbbrDPF9gwg30Ztg8keTEva2fZp=Q3Q@mail.gmail.com>
Subject: Re: [PATCH RFC] fs/ceph : fix build warning in ceph_writepages_start()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"abinashlalotra@gmail.com" <abinashlalotra@gmail.com>, Xiubo Li <xiubli@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "idryomov@gmail.com" <idryomov@gmail.com>, 
	"abinashsinghlalotra@gmail.com" <abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My comment is about the fact that we are reallocating a 816B
ceph_osd_request in __ceph_sync_read in a loop.
I would just allocate the memory once and reuse the struct. Its
allocated in ceph_osdc_alloc_request where this logic is used:
        if (use_mempool) {
                BUG_ON(num_ops > CEPH_OSD_SLAB_OPS);
                req =3D mempool_alloc(osdc->req_mempool, gfp_flags);
        } else if (num_ops <=3D CEPH_OSD_SLAB_OPS) {
                req =3D kmem_cache_alloc(ceph_osd_request_cache, gfp_flags)=
;
        } else {
                BUG_ON(num_ops > CEPH_OSD_MAX_OPS);
                req =3D kmalloc(struct_size(req, r_ops, num_ops), gfp_flags=
);
        }

IMHO we should keep a consistent allocation logic throughout, @Abinash
Singh please take a look at the allocation logic mentioned here.

On Mon, Jul 7, 2025 at 11:10=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Mon, 2025-07-07 at 22:57 +0300, Alex Markuze wrote:
> > Well, kmem_cache is a bit faster AFAIK. TBH, I would use a magazine
> > allocator here which would bridge the two, but that's a different
> > discussion.
> > We already have an allocation of a big struct in the read path as well
> > where we just kmalloc and it should change as well to
> > kmemcache/mempool.
>
> Which structure in the read path do you mean here? :)
>
> I assume that mempool could be useful under heavy memory pressure to guar=
antee
> the memory availability. But performance is really important point here t=
oo.
>
> Thanks,
> Slava.
>
> >
> > On Mon, Jul 7, 2025 at 9:24=E2=80=AFPM Viacheslav Dubeyko <Slava.Dubeyk=
o@ibm.com> wrote:
> > >
> > > On Mon, 2025-07-07 at 13:11 +0300, Alex Markuze wrote:
> > > > Hi Abinash,
> > > >
> > > > Thanks for your patch, you=E2=80=99ve correctly identified a real c=
oncern
> > > > around stack usage in ceph_writepages_start().
> > > >
> > > > However, dynamically allocating ceph_writeback_ctl inside .writepag=
es
> > > > isn't ideal. This function may be called in memory reclaim paths or
> > > > under writeback pressure, where any GFP allocation (even GFP_NOFS)
> > > > could deadlock or fail unexpectedly.
> > > >
> > > > Instead of allocating the struct on each call, I=E2=80=99d suggest =
one of the following:
> > > >
> > > > Add a dedicated kmem_cache for ceph_writeback_ctl, initialized duri=
ng
> > > > Ceph FS client init.
> > > > This allows reuse across calls without hitting the slab allocator e=
ach time.
> > > >
> > >
> > > I had discussion with Ilya several days ago related to this issue. :)=
 I
> > > considered namely to add the dedicated kmem_cache for ceph_writeback_=
ctl.
> > > However, Ilya mentioned that CONFIG_FRAME_WARN defaulting to 2048 on =
x86_64. So,
> > > you even could not see such warning on x86_64 systems. But, yes, this=
 rework
> > > makes sense from my point of view.
> > >
> > > By the way, do we need to consider mempool here instead of kmem_cache=
? The
> > > writeback is pretty intensive and critical code path.
> > >
> > > Thanks,
> > > Slava.
> > >
> > > > Embed a ceph_writeback_ctl struct inside ceph_inode_info, if it's
> > > > feasible to manage lifetimes and synchronization. Note that
> > > > .writepages can run concurrently on the same inode, so this approac=
h
> > > > would require proper locking or reuse guarantees.
> > > >
> > > > On Sat, Jul 5, 2025 at 6:54=E2=80=AFPM Abinash Singh <abinashlalotr=
a@gmail.com> wrote:
> > > > >
> > > > > The function `ceph_writepages_start()` triggers
> > > > > a large stack frame warning:
> > > > > ld.lld: warning:
> > > > >         fs/ceph/addr.c:1632:0: stack frame size (1072) exceeds li=
mit (1024) in function 'ceph_writepages_start.llvm.2555023190050417194'
> > > > >
> > > > > fix it by dynamically allocating `ceph_writeback_ctl` struct.
> > > > >
> > > > > Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
> > > > > ---
> > > > > The high stack usage of ceph_writepages_start() was further
> > > > > confirmed by using -fstack-usage flag :
> > > > > ...
> > > > > fs/ceph/addr.c:1837:ceph_netfs_check_write_begin        104     s=
tatic
> > > > > fs/ceph/addr.c:1630:ceph_writepages_start       648     static
> > > > > ...
> > > > > After optimzations it may go upto 1072 as seen in warning.
> > > > > After allocating `ceph_writeback_ctl` struct it is reduced to:
> > > > > ...
> > > > > fs/ceph/addr.c:1630:ceph_writepages_start       288     static
> > > > > fs/ceph/addr.c:81:ceph_dirty_folio      72      static
> > > > > ...
> > > > > Is this fun used very frequently ?? or dynamic allocation is
> > > > > a fine fix for reducing the stack usage ?
> > > > >
> > > > > Thank You
> > > > > ---
> > > > >  fs/ceph/addr.c | 82 ++++++++++++++++++++++++++------------------=
------
> > > > >  1 file changed, 43 insertions(+), 39 deletions(-)
> > > > >
> > > > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > > > index 60a621b00c65..503a86c1dda6 100644
> > > > > --- a/fs/ceph/addr.c
> > > > > +++ b/fs/ceph/addr.c
> > > > > @@ -1633,9 +1633,13 @@ static int ceph_writepages_start(struct ad=
dress_space *mapping,
> > > > >         struct inode *inode =3D mapping->host;
> > > > >         struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(in=
ode);
> > > > >         struct ceph_client *cl =3D fsc->client;
> > > > > -       struct ceph_writeback_ctl ceph_wbc;
> > > > > +       struct ceph_writeback_ctl *ceph_wbc __free(kfree) =3D NUL=
L;
> > > > >         int rc =3D 0;
> > > > >
> > > > > +       ceph_wbc =3D kmalloc(sizeof(*ceph_wbc), GFP_NOFS);
> > > > > +       if (!ceph_wbc)
> > > > > +               return -ENOMEM;
> > > > > +
> > > > >         if (wbc->sync_mode =3D=3D WB_SYNC_NONE && fsc->write_cong=
ested)
> > > > >                 return 0;
> > > > >
> > > > > @@ -1648,7 +1652,7 @@ static int ceph_writepages_start(struct add=
ress_space *mapping,
> > > > >                 return -EIO;
> > > > >         }
> > > > >
> > > > > -       ceph_init_writeback_ctl(mapping, wbc, &ceph_wbc);
> > > > > +       ceph_init_writeback_ctl(mapping, wbc, ceph_wbc);
> > > > >
> > > > >         if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
> > > > >                 rc =3D -EIO;
> > > > > @@ -1656,7 +1660,7 @@ static int ceph_writepages_start(struct add=
ress_space *mapping,
> > > > >         }
> > > > >
> > > > >  retry:
> > > > > -       rc =3D ceph_define_writeback_range(mapping, wbc, &ceph_wb=
c);
> > > > > +       rc =3D ceph_define_writeback_range(mapping, wbc, ceph_wbc=
);
> > > > >         if (rc =3D=3D -ENODATA) {
> > > > >                 /* hmm, why does writepages get called when there
> > > > >                    is no dirty data? */
> > > > > @@ -1665,55 +1669,55 @@ static int ceph_writepages_start(struct a=
ddress_space *mapping,
> > > > >         }
> > > > >
> > > > >         if (wbc->sync_mode =3D=3D WB_SYNC_ALL || wbc->tagged_writ=
epages)
> > > > > -               tag_pages_for_writeback(mapping, ceph_wbc.index, =
ceph_wbc.end);
> > > > > +               tag_pages_for_writeback(mapping, ceph_wbc->index,=
 ceph_wbc->end);
> > > > >
> > > > > -       while (!has_writeback_done(&ceph_wbc)) {
> > > > > -               ceph_wbc.locked_pages =3D 0;
> > > > > -               ceph_wbc.max_pages =3D ceph_wbc.wsize >> PAGE_SHI=
FT;
> > > > > +       while (!has_writeback_done(ceph_wbc)) {
> > > > > +               ceph_wbc->locked_pages =3D 0;
> > > > > +               ceph_wbc->max_pages =3D ceph_wbc->wsize >> PAGE_S=
HIFT;
> > > > >
> > > > >  get_more_pages:
> > > > > -               ceph_folio_batch_reinit(&ceph_wbc);
> > > > > +               ceph_folio_batch_reinit(ceph_wbc);
> > > > >
> > > > > -               ceph_wbc.nr_folios =3D filemap_get_folios_tag(map=
ping,
> > > > > -                                                           &ceph=
_wbc.index,
> > > > > -                                                           ceph_=
wbc.end,
> > > > > -                                                           ceph_=
wbc.tag,
> > > > > -                                                           &ceph=
_wbc.fbatch);
> > > > > +               ceph_wbc->nr_folios =3D filemap_get_folios_tag(ma=
pping,
> > > > > +                                                           &ceph=
_wbc->index,
> > > > > +                                                           ceph_=
wbc->end,
> > > > > +                                                           ceph_=
wbc->tag,
> > > > > +                                                           &ceph=
_wbc->fbatch);
> > > > >                 doutc(cl, "pagevec_lookup_range_tag for tag %#x g=
ot %d\n",
> > > > > -                       ceph_wbc.tag, ceph_wbc.nr_folios);
> > > > > +                       ceph_wbc->tag, ceph_wbc->nr_folios);
> > > > >
> > > > > -               if (!ceph_wbc.nr_folios && !ceph_wbc.locked_pages=
)
> > > > > +               if (!ceph_wbc->nr_folios && !ceph_wbc->locked_pag=
es)
> > > > >                         break;
> > > > >
> > > > >  process_folio_batch:
> > > > > -               rc =3D ceph_process_folio_batch(mapping, wbc, &ce=
ph_wbc);
> > > > > +               rc =3D ceph_process_folio_batch(mapping, wbc, cep=
h_wbc);
> > > > >                 if (rc)
> > > > >                         goto release_folios;
> > > > >
> > > > >                 /* did we get anything? */
> > > > > -               if (!ceph_wbc.locked_pages)
> > > > > +               if (!ceph_wbc->locked_pages)
> > > > >                         goto release_folios;
> > > > >
> > > > > -               if (ceph_wbc.processed_in_fbatch) {
> > > > > -                       ceph_shift_unused_folios_left(&ceph_wbc.f=
batch);
> > > > > +               if (ceph_wbc->processed_in_fbatch) {
> > > > > +                       ceph_shift_unused_folios_left(&ceph_wbc->=
fbatch);
> > > > >
> > > > > -                       if (folio_batch_count(&ceph_wbc.fbatch) =
=3D=3D 0 &&
> > > > > -                           ceph_wbc.locked_pages < ceph_wbc.max_=
pages) {
> > > > > +                       if (folio_batch_count(&ceph_wbc->fbatch) =
=3D=3D 0 &&
> > > > > +                           ceph_wbc->locked_pages < ceph_wbc->ma=
x_pages) {
> > > > >                                 doutc(cl, "reached end fbatch, tr=
ying for more\n");
> > > > >                                 goto get_more_pages;
> > > > >                         }
> > > > >                 }
> > > > >
> > > > > -               rc =3D ceph_submit_write(mapping, wbc, &ceph_wbc)=
;
> > > > > +               rc =3D ceph_submit_write(mapping, wbc, ceph_wbc);
> > > > >                 if (rc)
> > > > >                         goto release_folios;
> > > > >
> > > > > -               ceph_wbc.locked_pages =3D 0;
> > > > > -               ceph_wbc.strip_unit_end =3D 0;
> > > > > +               ceph_wbc->locked_pages =3D 0;
> > > > > +               ceph_wbc->strip_unit_end =3D 0;
> > > > >
> > > > > -               if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
> > > > > -                       ceph_wbc.nr_folios =3D
> > > > > -                               folio_batch_count(&ceph_wbc.fbatc=
h);
> > > > > +               if (folio_batch_count(&ceph_wbc->fbatch) > 0) {
> > > > > +                       ceph_wbc->nr_folios =3D
> > > > > +                               folio_batch_count(&ceph_wbc->fbat=
ch);
> > > > >                         goto process_folio_batch;
> > > > >                 }
> > > > >
> > > > > @@ -1724,38 +1728,38 @@ static int ceph_writepages_start(struct a=
ddress_space *mapping,
> > > > >                  * we tagged for writeback prior to entering this=
 loop.
> > > > >                  */
> > > > >                 if (wbc->nr_to_write <=3D 0 && wbc->sync_mode =3D=
=3D WB_SYNC_NONE)
> > > > > -                       ceph_wbc.done =3D true;
> > > > > +                       ceph_wbc->done =3D true;
> > > > >
> > > > >  release_folios:
> > > > >                 doutc(cl, "folio_batch release on %d folios (%p)\=
n",
> > > > > -                     (int)ceph_wbc.fbatch.nr,
> > > > > -                     ceph_wbc.fbatch.nr ? ceph_wbc.fbatch.folios=
[0] : NULL);
> > > > > -               folio_batch_release(&ceph_wbc.fbatch);
> > > > > +                     (int)ceph_wbc->fbatch.nr,
> > > > > +                     ceph_wbc->fbatch.nr ? ceph_wbc->fbatch.foli=
os[0] : NULL);
> > > > > +               folio_batch_release(&ceph_wbc->fbatch);
> > > > >         }
> > > > >
> > > > > -       if (ceph_wbc.should_loop && !ceph_wbc.done) {
> > > > > +       if (ceph_wbc->should_loop && !ceph_wbc->done) {
> > > > >                 /* more to do; loop back to beginning of file */
> > > > >                 doutc(cl, "looping back to beginning of file\n");
> > > > >                 /* OK even when start_index =3D=3D 0 */
> > > > > -               ceph_wbc.end =3D ceph_wbc.start_index - 1;
> > > > > +               ceph_wbc->end =3D ceph_wbc->start_index - 1;
> > > > >
> > > > >                 /* to write dirty pages associated with next snap=
c,
> > > > >                  * we need to wait until current writes complete =
*/
> > > > > -               ceph_wait_until_current_writes_complete(mapping, =
wbc, &ceph_wbc);
> > > > > +               ceph_wait_until_current_writes_complete(mapping, =
wbc, ceph_wbc);
> > > > >
> > > > > -               ceph_wbc.start_index =3D 0;
> > > > > -               ceph_wbc.index =3D 0;
> > > > > +               ceph_wbc->start_index =3D 0;
> > > > > +               ceph_wbc->index =3D 0;
> > > > >                 goto retry;
> > > > >         }
> > > > >
> > > > > -       if (wbc->range_cyclic || (ceph_wbc.range_whole && wbc->nr=
_to_write > 0))
> > > > > -               mapping->writeback_index =3D ceph_wbc.index;
> > > > > +       if (wbc->range_cyclic || (ceph_wbc->range_whole && wbc->n=
r_to_write > 0))
> > > > > +               mapping->writeback_index =3D ceph_wbc->index;
> > > > >
> > > > >  dec_osd_stopping_blocker:
> > > > >         ceph_dec_osd_stopping_blocker(fsc->mdsc);
> > > > >
> > > > >  out:
> > > > > -       ceph_put_snap_context(ceph_wbc.last_snapc);
> > > > > +       ceph_put_snap_context(ceph_wbc->last_snapc);
> > > > >         doutc(cl, "%llx.%llx dend - startone, rc =3D %d\n", ceph_=
vinop(inode),
> > > > >               rc);
> > > > >
> > > > > --
> > > > > 2.43.0
> > > > >
> > > > >
> > > >
>
> --
> Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>


