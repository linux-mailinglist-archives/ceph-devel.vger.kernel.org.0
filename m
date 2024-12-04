Return-Path: <ceph-devel+bounces-2244-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7FE9E3AE9
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 14:12:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E497E282256
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 13:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBFC01BBBEE;
	Wed,  4 Dec 2024 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CMmppEAC"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DFC1BBBF7
	for <ceph-devel@vger.kernel.org>; Wed,  4 Dec 2024 13:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733317970; cv=none; b=G6vrE446WAo+coPvr8lppwM/QIcCCwK9jJ4hTBDunM8UfYzLjlJCXuZFV/1CoZrBSQOi16x1IXkne/0TEIg3l0pHSdxnZgvly5Z1jaE+ne9ur/WHAXvjmDvLpwLVefofLYSuj+x3/hNoOaXnU2FHfy4+EgB25ajr2yZr7jEvJmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733317970; c=relaxed/simple;
	bh=Om4+6wXzyMll7t1GWIs2r+TG3c189qt4QT7ckMUdkG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YtKyh1kqvudUXFoBVI4IUjYVX1hMEfKvb7MRxBz1G6QjaF+aZBQCu64nXmY/EIu2HKTxKt9UUtv/tDzJsAls2MRvgIJV7fRSE8KsddX+SYYX7Mr8w7uxo/GxOMcdV60EhMxoWjbRiV335MhOhPE8KyPMovF3WfAa6M7VL7Kp9CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CMmppEAC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733317968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kbWCsWhs5I66kT1z5AYMphzBATHb28k/OzHD2hDHM6Y=;
	b=CMmppEACf78sGYkDIMmkbFK7Vt865OyBg136dJvsAO64PkRso9Xtt24tpLq3laromzOlK0
	IB81CIGuYzl+PVABF/3qfve128LfLlPGX6Uf/O+mAQ1o6X5z4Ceo80Tcb+GqAlGxyCkrno
	qWoLC2M8JxRxShYDEb10yYgOvf7OhLk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-KEDzQlIJMcCn8gOCqSCiVQ-1; Wed, 04 Dec 2024 08:12:44 -0500
X-MC-Unique: KEDzQlIJMcCn8gOCqSCiVQ-1
X-Mimecast-MFC-AGG-ID: KEDzQlIJMcCn8gOCqSCiVQ
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d0214ba84eso5020997a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 04 Dec 2024 05:12:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733317963; x=1733922763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kbWCsWhs5I66kT1z5AYMphzBATHb28k/OzHD2hDHM6Y=;
        b=JzjFzpcHSTZBOUcCfljFxmsK17uUy5pP/EfGAx64T9L4J6j/AByfZiUzEzrTfgA/j8
         DlR5oba+1tpNLx/2viJv739yqSTNdnpSYpGV3dwkDHWImG6tzV6YZofjQ84LwvkzJBfC
         uTTEe4E/EGrdDdhjMvvGSc2E5/8vShesiz8rlXECAGUqqrSEDH/F+aLli2yLSy4N5A1u
         +9dvrL16T9i1GsMfPujxEBgyR2CIbM9T3oBHwmsUTfJl8WELclBM6zNyEiQ/hozZDKg7
         g/pQ6pWEL7EtePJvKGiLQUVKUuOtEKS8HuHC0eidEJQbBiSFF5pZOG6caMBQgvEaSTct
         A9Sg==
X-Forwarded-Encrypted: i=1; AJvYcCW5n71rN84dK6QLuRGdtSfi6sWPphHZ18XgFZa0DjptYdZxLf8XmxA3Ue4ek7pXQCp3bxHSVptpMneJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxHYuSeyZSkoGuOkyflsJp2f5M5ChO3OR7s2N9mPWb7dENPxCPN
	5GTj8nPMstNFnAFM5MOZpvdfA4g+bpC58c0M8/ZfAKYBPgbrM56OnenaXSpGsKLAocV4bSLY86V
	UfgBHsfZP9KkeW12SMvjBzJx/qkU3u/oQMxG/GLcuVUhiK55od4A22UkpPKPZd4Vq2UKL+UQvob
	92ouoipkDE62jVxhjIsP3xoZO0aAZ40fJTKHJxePoEASglY+M=
X-Gm-Gg: ASbGnctWTOPWPlKiDtso0kkJ+kvEq4bvt0yCf2KNz0iRJ3APXA89ggBGh6/fkGpHe+X
	e731lMn6xBi9brshwkpmfbO+XTHvH
X-Received: by 2002:a05:6402:360b:b0:5d0:c7a7:ac0d with SMTP id 4fb4d7f45d1cf-5d10cb9a314mr6558461a12.34.1733317963055;
        Wed, 04 Dec 2024 05:12:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpj/Ukw/hb5OmvYVDNKrVLJ36yoSZpTls4sI4Jw9ZSD/XHcHW4VH+Puxmbq5rHrQ/dlE/1KoPlbBQhY+dKpPs=
X-Received: by 2002:a05:6402:360b:b0:5d0:c7a7:ac0d with SMTP id
 4fb4d7f45d1cf-5d10cb9a314mr6558442a12.34.1733317962682; Wed, 04 Dec 2024
 05:12:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
 <d75b6bb5-f960-4e75-90f3-e7246a2cd295@riscstar.com> <a7f2d7f9-014b-4535-a0d1-74c351d13eca@stanley.mountain>
 <CAO8a2Sjkcmqr0Big38Dqia2XZFHVhbukWhAJXYh4Y3VPFrKcaA@mail.gmail.com>
In-Reply-To: <CAO8a2Sjkcmqr0Big38Dqia2XZFHVhbukWhAJXYh4Y3VPFrKcaA@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 4 Dec 2024 15:12:31 +0200
Message-ID: <CAO8a2SgNuGyvH+jcCbaVO0p1fRfOd7_Kuo9MuUDCnDwxNt1SoA@mail.gmail.com>
Subject: Re: [bug report] ceph: decode interval_sets for delegated inos
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alex Elder <elder@riscstar.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dan, how are you running smatch?
I've been looking at smatch warnings/errors and don't get this error.
Do you have a custom smatch checker?

On Wed, Dec 4, 2024 at 2:50=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> w=
rote:
>
> I assume a Coccinelle patch can be written, if one doesn't exist yet.
>
> On Tue, Dec 3, 2024 at 8:29=E2=80=AFPM Dan Carpenter <dan.carpenter@linar=
o.org> wrote:
> >
> > On Tue, Dec 03, 2024 at 11:06:50AM -0600, Alex Elder wrote:
> > > On 12/3/24 2:19 AM, Dan Carpenter wrote:
> > > > Hello Jeff Layton,
> > > >
> > > > Commit d48464878708 ("ceph: decode interval_sets for delegated inos=
")
> > > > from Nov 15, 2019 (linux-next), leads to the following Smatch stati=
c
> > > > checker warning:
> > > >
> > > >     fs/ceph/mds_client.c:644 ceph_parse_deleg_inos()
> > > >     warn: potential user controlled sizeof overflow 'sets * 2 * 8' =
'0-u32max * 8'
> > > >
> > > > fs/ceph/mds_client.c
> > > >      637 static int ceph_parse_deleg_inos(void **p, void *end,
> > > >      638                                  struct ceph_mds_session *=
s)
> > > >      639 {
> > > >      640         u32 sets;
> > > >      641
> > > >      642         ceph_decode_32_safe(p, end, sets, bad);
> > > >                                              ^^^^
> > > > set to user data here.
> > > >
> > > >      643         if (sets)
> > > > --> 644                 ceph_decode_skip_n(p, end, sets * 2 * sizeo=
f(__le64), bad);
> > > >                                                     ^^^^^^^^^^^^^^^=
^^^^^^^^^^
> > > > This is safe on 64bit but on 32bit systems it can integer overflow/=
wrap.
> > >
> > > So the point of this is that "sets" is u32, and because that is
> > > multiplied by 16 when passed to ceph_decode_skip_n(), the result
> > > could exceed 32 bits?  I.e., would this address it?
> > >
> > >       if (sets) {
> > >           size_t scale =3D 2 * sizeof(__le64);
> > >
> > >           if (sets < SIZE_MAX / scale)
> > >               ceph_decode_skip_n(p, end, sets * scale, bad);
> > >           else
> > >               goto bad;
> > >       }
> > >
> >
> > Yes, that works.  I don't know if there are any static checker warnings=
 which
> > will complain that the "sets < SIZE_MAX / scale" is always true on 64 b=
it.  I
> > don't think there is?
> >
> > regards,
> > dan carpenter
> >
> >


