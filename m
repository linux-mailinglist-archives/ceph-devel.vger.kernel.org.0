Return-Path: <ceph-devel+bounces-4134-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5CAC9B30B
	for <lists+ceph-devel@lfdr.de>; Tue, 02 Dec 2025 11:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4CEB74E0739
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Dec 2025 10:39:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A7930F540;
	Tue,  2 Dec 2025 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DieBnMW2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PwdUxgiG"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F28204583
	for <ceph-devel@vger.kernel.org>; Tue,  2 Dec 2025 10:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764671966; cv=none; b=BS4JDHjW8gqH41jB2nZu3P/dHLupfZPdvCqPAuornQ01GtbyZtKsLZxzJyhvlh7/yun6ck83z9no0IUQmoAWwFULWNd5Jy7F8Ho8Fzu2mqJ2XLELlOazS096fyOUOdWQ5rwsdXLPspDdndKMt7aHLq41k2UqZCfGBWMgJ6w6z+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764671966; c=relaxed/simple;
	bh=5PnwP6P9YOsWdrSpcZUxzDIx4rIJLBQPjFt49pWe6OE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=piy34aqaMAeCPUErj0XZU6tDlxBVu9SiM/sim/bfUhiEe4AXQM54eIhXdKAHJfYFG75TCxRCVqaVR0WhOWu/6bdf4Dl7dr5OP95TYaRqKZZEoetdHjJr03FIOwokcLzlsswFQF5A1+kUzUV46KT4xH58rgHm7FmlNOSushlaKYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DieBnMW2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PwdUxgiG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764671963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tiJGdCG0PC+FCsZFqhjWfcf48WR6KzvCnHiDcd4IGfI=;
	b=DieBnMW2CrNnPZf+tyFzMr4JajT9exxAplTitRyzUQOodPUihx32HR6QGvdnnbxMjQ6kyo
	YN9Stmxthg1GOuDxJdbqQ1pyc8NMu4lUBePR+MeCdarX3jHloC7O5Wu1RtinUwKZyuwpEJ
	OGDPpLCu1hauyNpVmAoAtjh0P/JBQOU=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-x50EKxG1MPWxs1s98q7ROg-1; Tue, 02 Dec 2025 05:39:22 -0500
X-MC-Unique: x50EKxG1MPWxs1s98q7ROg-1
X-Mimecast-MFC-AGG-ID: x50EKxG1MPWxs1s98q7ROg_1764671961
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-9353647cc30so7404152241.1
        for <ceph-devel@vger.kernel.org>; Tue, 02 Dec 2025 02:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764671961; x=1765276761; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tiJGdCG0PC+FCsZFqhjWfcf48WR6KzvCnHiDcd4IGfI=;
        b=PwdUxgiG4gFxOb4l9q3ESNVqwsHBPKvBbAPMGWzsToxsZ7Tn0wLEXlW2nhpp5Bt2Pl
         Lfys5R7f4hTZ07Z1tjZus12SXuJGvv6oJST/GCsg9G/JsTXuX3W5mNhjYboOxUlfLZRG
         wxwFtdznxNL/4SuJyigneHRULJtsESvLajRALK1BPCXbh2slMr0sdULH5HwiQXENbPxl
         DBdsJby0JVN2G0QapcP+SHCXxoFjVt965+JFbpPDw3UJu2x9fOUKzCatC/ID2qedb03f
         qsmXy29XWfIQ4amX3z0RtEahPJEeG3qkT5zopQ1GP2g7O3PQXRDtpd2K0zlaKGzdQcyo
         hd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764671961; x=1765276761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tiJGdCG0PC+FCsZFqhjWfcf48WR6KzvCnHiDcd4IGfI=;
        b=lp+Ivgzdz6/muNOzQ9B5EpfEdtwiC0itm5eOFdiKDGpNZmVYF7+D0lF/Xr4v64B7fj
         I/v0NbO8qix9EXxMBzBAAsW2xE/TB3vWstSl4be1xWE/Dw7sXp5q0IVWKoN/fJ+C97Ow
         fqnc5msp/Tn1EORdtQene0CICX9soo05v+3bwA+GSw/Rziz5Fwa3lJ/C1mQLluNWJ0NT
         3kB2ukCj+Sf1LXp+z0wzNNwkCZzjzfPYVkn3F1gqR3f7ja9mcrdpPHnNBSM1am/4/QSW
         2ZyprNEwLGQ8z/skCyHOiyYzylohCpUIxhGkkyEsgVvfphBR4vAsrU44F8j1Sgb16nRN
         4wAg==
X-Gm-Message-State: AOJu0YwJxkTK9afNFPwVZ1AC27dRFy7otMEQjrcQZNi8Tjx0zP5oQtwZ
	0zURewKcXrSq2mFXnrbLY4oYfC4T4Y4OS9YQ35QQC8COZQi31wSWTMovENaYwwhHOaTj6JR1KSp
	K+eBgEsv0/qLvYz8jtP8bgciRz2IN1bcVo2o0BMzrCuyMi1rgLWCwoFmFlCMypGEu9mOBHEx54/
	E1IIU8uggMmGlC1L/OR0PnGPMrMi4yXMQlXldFUg==
X-Gm-Gg: ASbGncs11q5pM5rGYVUm4+G8RRRWtpuX8Pw74TPULJS1cyCkItltC17GoSqzmVOA4tQ
	ApS/12AabwqWFmUAuwrHTffuazfiLEgP7VcSjNTPTmT5R7u7qotYn50Hn2o4mKoU4pjFW/ucVyQ
	4hYboM478I0j6wSM/qPpkE+2mIcAMOmqrZuulEPv491qNUBXy3CRgBbkLMcuEi5BJf30Kk1mdqC
	bjJbd2MVw==
X-Received: by 2002:a05:6102:3a10:b0:5d5:f6ae:3914 with SMTP id ada2fe7eead31-5e40c7cb8d0mr836352137.22.1764671961501;
        Tue, 02 Dec 2025 02:39:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHAMGx5cfztqeLoNBnJ/UEcyA8RGEsBmIpTD5RsW452OYnkA6k6u8LDJj4i/NlZIhmlNjDEh5f8ikVmIOC8PAc=
X-Received: by 2002:a05:6102:3a10:b0:5d5:f6ae:3914 with SMTP id
 ada2fe7eead31-5e40c7cb8d0mr836346137.22.1764671961145; Tue, 02 Dec 2025
 02:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251127134620.2035796-1-amarkuze@redhat.com> <20251127134620.2035796-2-amarkuze@redhat.com>
 <06142f77a8091d5ed7c1523495f6e0ebb33ad83d.camel@ibm.com>
In-Reply-To: <06142f77a8091d5ed7c1523495f6e0ebb33ad83d.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Tue, 2 Dec 2025 12:39:09 +0200
X-Gm-Features: AWmQ_bmzcuX7F6VSqGLZw7uMWzaR6h6Lr_rKYwXcM4z4j4En4w7OXI6g2qxMJyY
Message-ID: <CAO8a2Sge5iS7ZezQ09PoKZBGdScJ3nQe0i-+FeCMgYA+16K5ZA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ceph: handle InodeStat v8 versioned field in reply parsing
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

v8 was added for case insensitive file systems, not relevant to Linux,
I can add a comment saying that.

On Mon, Dec 1, 2025 at 10:20=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Thu, 2025-11-27 at 13:46 +0000, Alex Markuze wrote:
> > Add forward-compatible handling for the new versioned field introduced
> > in InodeStat v8. This patch only skips the field without using it,
> > preparing for future protocol extensions.
> >
> > The v8 encoding adds a versioned sub-structure that needs to be properl=
y
> > decoded and skipped to maintain compatibility with newer MDS versions.
> >
> > Signed-off-by: Alex Markuze <amarkuze@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 1740047aef0f..32561fc701e5 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -231,6 +231,18 @@ static int parse_reply_info_in(void **p, void *end=
,
> >                                                     info->fscrypt_file_=
len, bad);
> >                       }
> >               }
> > +
> > +             /* struct_v 8 added a versioned field - skip it */
> > +             if (struct_v >=3D 8) {
> > +                     u8 v8_struct_v, v8_struct_compat;
> > +                     u32 v8_struct_len;
> > +
>
> Probably, we need to have warning here that, currently, this protocol is =
not
> supported yet.
>
> Thanks,
> Slava.
>
> > +                     ceph_decode_8_safe(p, end, v8_struct_v, bad);
> > +                     ceph_decode_8_safe(p, end, v8_struct_compat, bad)=
;
> > +                     ceph_decode_32_safe(p, end, v8_struct_len, bad);
> > +                     ceph_decode_skip_n(p, end, v8_struct_len, bad);
> > +             }
> > +
> >               *p =3D end;
> >       } else {
> >               /* legacy (unversioned) struct */


