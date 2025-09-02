Return-Path: <ceph-devel+bounces-3499-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61293B40D25
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 20:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C8FC3B30B5
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Sep 2025 18:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC7A018027;
	Tue,  2 Sep 2025 18:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKUJzoWx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE6632F76E
	for <ceph-devel@vger.kernel.org>; Tue,  2 Sep 2025 18:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756837822; cv=none; b=B8ciyvB3T3ZeY/bVOh72CmHjSGA9hrWK39lzOgjxQPZx4GELDS6dfyxQ3j2zTVpFVbrpG58npRl4uKbfFPn1Yl/JKtOeyuzpZ+JN/UMJNk6D5O5gcdj1jfOHz9HIaNeV5JNzfaPGNomBhrf6w0yBsthfoeQaIOhpvrv+C0UBxKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756837822; c=relaxed/simple;
	bh=+0tt49eVwvG3+vc1xqkrbIEGZjh+UC/EVvjV8R/C7mk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=naafAq8yPcsLy1XD5qq7dJOFIF9Z+8XDQorAHbnd0aljCULBF0rX4LixhRIoLpGRziObQB9GR0ockN9v3txFNhVnp0+gTyNe6kR57BpF+w4RIrOM0sscyPjqZvOjFkiC0qt5QAnSiJ+Oxv3IJBFjapuFc/RyAJU4Gc4KYixaJoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKUJzoWx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756837819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASDF7zCsUE8NxaMptPS0zZPS3DJLq2joyWFZFJ6zTCo=;
	b=eKUJzoWxLHH4gJ8kLdYlfE6YYheZOsBz9/ZVZ2BAoMUt330Ov+QLeLqOvjcWbo1b37Fixd
	5EM541Bn9PiXV7QRkq24sY87q2w/x0THNP+jyg2kdSegjhtEq7YSgzbYMk8k/dsrNQWIfz
	yGQh+sZuCBwH9lUUpA7VabNEpXKJuws=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-l_x6SQLwOCaswoBlbsBrWQ-1; Tue, 02 Sep 2025 14:30:18 -0400
X-MC-Unique: l_x6SQLwOCaswoBlbsBrWQ-1
X-Mimecast-MFC-AGG-ID: l_x6SQLwOCaswoBlbsBrWQ_1756837818
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-7228611852dso26957557b3.3
        for <ceph-devel@vger.kernel.org>; Tue, 02 Sep 2025 11:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756837817; x=1757442617;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ASDF7zCsUE8NxaMptPS0zZPS3DJLq2joyWFZFJ6zTCo=;
        b=ZTxzkTNcwL+TxmW8MXXrdwM8IClYLCqDDHt9R6P+v9boy4+Np2NecU/ytG35zUOjh6
         Rx83rN9wL2rDaL5tLWqP4RWUreRfQ9oZPgmjDFuj4OJPzhSD3Th2yw6vUGcpK8YOoDP7
         Xo/4jU9P4Kx1gDm0CXu/TyfOkyEqcWnUU5nESbycfcegb8o41qWhMp3IExTod88PeSZn
         mXbSALbAFZGiGFVylDGu4/YCsOfcsluYVOp+L1Q58rMaUir7gIQ48eb/gf+upJtOBy9H
         BOjieuH9KRlcll+xYR0XtnRIrj6YZhfrogW5ns85YsYc8PG0bLAqy36dDMcSJKL8axd5
         2Rww==
X-Gm-Message-State: AOJu0YyDtu87X9ka8TNrC038R1ELd+FDIqMXFV+XLrzK4OzN5Smpl/pe
	Gecw+hdV3Tv/FlSgBNCOFNof+G6oHj/c/NzEtLhjyNHRp1AVHJYTwlwRGC4txbsqauRmNNyxTLB
	FyVzlZswfkSCEr1x68/3g8t0xfCCRF2FRd/Wcb261p5fjCq7vHNYAQFfNoFHyfhM=
X-Gm-Gg: ASbGncuub82bs0aPIKTzkL6hsDnWafPbiylEde0FYKOKQU+lBWb2IevPgpB7UjrzcBR
	46Uo5lodNe1azzeiBkBG1wvbWsC75JNj5inFvqz/3dksT5EmN/kCOE3kPawkw9nswGfK5eGNrxT
	+67mF/6eCMxneUnA6HyMRZl0jdzz9Tyt5NOYqhRtKHsu0zK2E4xk2pqART2JyQlBQSXEj6bv/Ic
	GOvFAHcqOJXi20ToHGEIjP5JVpqitur4Pv7PxxqXVWL+YnrpdrlgEJJyxpCbDYRG8JPejL/d8np
	x6ehr+u8r24ae4asdy2nL8rnDrJnQD+QVdh4cA4Z0LEBtemraX67U0DlLajMmP/zNW6p
X-Received: by 2002:a05:690c:4b03:b0:71c:7eb:3556 with SMTP id 00721157ae682-722763b0ae9mr141069417b3.15.1756837816838;
        Tue, 02 Sep 2025 11:30:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE31gZtLpBFU/GPsABT/hXbcuHGun2+lZcXyD/fpbEthrTXT8BKSP2Z/St0jr6rloAmkCn1Ag==
X-Received: by 2002:a05:690c:4b03:b0:71c:7eb:3556 with SMTP id 00721157ae682-722763b0ae9mr141068547b3.15.1756837815863;
        Tue, 02 Sep 2025 11:30:15 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a8502985sm7142207b3.40.2025.09.02.11.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 11:30:15 -0700 (PDT)
Message-ID: <375e4fa284edbe24ba0ea49c908b3cd780233410.camel@redhat.com>
Subject: Re: [PATCH] ceph: cleanup in ceph_alloc_readdir_reply_buffer()
From: vdubeyko@redhat.com
To: Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko
 <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com
Date: Tue, 02 Sep 2025 11:30:14 -0700
In-Reply-To: <CAO8a2ShN_=0dkgfWcRB3=q+C9o2hBONCQS1Os4ubG-NhsBhJ1w@mail.gmail.com>
References: <20250829212859.93312-2-slava@dubeyko.com>
	 <CAO8a2ShN_=0dkgfWcRB3=q+C9o2hBONCQS1Os4ubG-NhsBhJ1w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-09-01 at 18:30 +0300, Alex Markuze wrote:
> Lets add unlikely to these checks.
>=20

Makes sense. Let me rework the patch.

Thanks,
Slava.

> On Sat, Aug 30, 2025 at 12:29=E2=80=AFAM Viacheslav Dubeyko <slava@dubeyk=
o.com> wrote:
> >=20
> > From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >=20
> > The Coverity Scan service has reported potential issue
> > in ceph_alloc_readdir_reply_buffer() [1]. If order could
> > be negative one, then it expects the issue in the logic:
> >=20
> > num_entries =3D (PAGE_SIZE << order) / size;
> >=20
> > Technically speaking, this logic [2] should prevent from
> > making the order variable negative:
> >=20
> > if (!rinfo->dir_entries)
> >     return -ENOMEM;
> >=20
> > However, the allocation logic requires some cleanup.
> > This patch makes sure that calculated bytes count
> > will never exceed ULONG_MAX before get_order()
> > calculation. And it adds the checking of order
> > variable on negative value to guarantee that second
> > half of the function's code will never operate by
> > negative value of order variable even if something
> > will be wrong or to be changed in the first half of
> > the function's logic.
> >=20
> > [1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selected=
Issue=3D1198252
> > [2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/mds_clien=
t.c#L2553
> >=20
> > Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > cc: Alex Markuze <amarkuze@redhat.com>
> > cc: Ilya Dryomov <idryomov@gmail.com>
> > cc: Ceph Development <ceph-devel@vger.kernel.org>
> > ---
> >  fs/ceph/mds_client.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 0f497c39ff82..d783326d6183 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2532,6 +2532,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_m=
ds_request *req,
> >         struct ceph_mount_options *opt =3D req->r_mdsc->fsc->mount_opti=
ons;
> >         size_t size =3D sizeof(struct ceph_mds_reply_dir_entry);
> >         unsigned int num_entries;
> > +       u64 bytes_count;
> >         int order;
> >=20
> >         spin_lock(&ci->i_ceph_lock);
> > @@ -2540,7 +2541,11 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_=
mds_request *req,
> >         num_entries =3D max(num_entries, 1U);
> >         num_entries =3D min(num_entries, opt->max_readdir);
> >=20
> > -       order =3D get_order(size * num_entries);
> > +       bytes_count =3D (u64)size * num_entries;
> > +       if (bytes_count > ULONG_MAX)
> > +               bytes_count =3D ULONG_MAX;
> > +
> > +       order =3D get_order((unsigned long)bytes_count);
> >         while (order >=3D 0) {
> >                 rinfo->dir_entries =3D (void*)__get_free_pages(GFP_KERN=
EL |
> >                                                              __GFP_NOWA=
RN |
> > @@ -2550,7 +2555,7 @@ int ceph_alloc_readdir_reply_buffer(struct ceph_m=
ds_request *req,
> >                         break;
> >                 order--;
> >         }
> > -       if (!rinfo->dir_entries)
> > +       if (!rinfo->dir_entries || order < 0)
> >                 return -ENOMEM;
> >=20
> >         num_entries =3D (PAGE_SIZE << order) / size;
> > --
> > 2.51.0
> >=20


