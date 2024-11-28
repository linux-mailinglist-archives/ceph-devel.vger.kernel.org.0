Return-Path: <ceph-devel+bounces-2217-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1022E9DBC66
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 20:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADC88163B10
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 19:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40CFB1C1ACB;
	Thu, 28 Nov 2024 19:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aQ+3nW4x"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F841C94
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 19:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732821000; cv=none; b=VcAAdEikTaE4oa0cxvB5PZMIIabGIfkvuZnJmb2G6Z+94UM78MhNNF3NtlLUI/qSIf+rPAt4O6b+DT59mb9R2kO8tA7poNoFL1YA/r0aV2BF0b8rU+3aJTLUOB/vzibmWrnRYcQYSspwGMT3jmUNcQv0MT+/JR938kU1/tzrOog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732821000; c=relaxed/simple;
	bh=/2lsMQduZXQXaSld1gB79yb7joGFpD9EHAeh12hu3iw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tm6rizT/OcFH/iCFp5CgZEf2YhzizYIzHoeDnqa6GppmNh9m78NM+Q4Owip8OtbdOkRsUahDnUBK9fOLCOfmPBIHF4k/hecfV3hXBCrYr0fIKQXheSwI5Do1VWLm50GUQpgXWRcdgk1PjwNBGJSmaAdaTV1j72HVEekKDFXYKe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aQ+3nW4x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732820997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VBloSo0D1c+vKDoDMLX0aiqLfpHBlQcdDr4A+YjMHj4=;
	b=aQ+3nW4xmFxK3rGs1LUfcuJtQOmQUZ4dUZgUlFesxFC8XKc/lkWQVmkD+gFjudrAcmzQ6G
	SZVCviTO6ciwS2DfDdI/Ps6TeVaRZCyb9mvRUwDWuT46qa0wWoksFAxTeYrHsKtRIerOnn
	zgdR4c0IAAjKx0v98ccK/sJoM66xusU=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-qhW0iHmcNUOS7xIdb9aeRQ-1; Thu, 28 Nov 2024 14:09:55 -0500
X-MC-Unique: qhW0iHmcNUOS7xIdb9aeRQ-1
X-Mimecast-MFC-AGG-ID: qhW0iHmcNUOS7xIdb9aeRQ
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ffcaf83610so9025311fa.1
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 11:09:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732820994; x=1733425794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBloSo0D1c+vKDoDMLX0aiqLfpHBlQcdDr4A+YjMHj4=;
        b=cQ+s9Y08lpD/eSlY8tgZAdALghAfyJLyR0ss6cKa0tKqQ03pxN1kY9X6l9QpPd1tS2
         WQfYdrz83qQ0aUcdaSDWPiqWJ+z2ZC1YHTnfEz+rNzQ+nANdKGJtryS8tO+tbslyeusG
         sy6dlVCSE2ufCYUEBwC1YBaxjsiU3wPh4rVKwDnJbLBj7QgTPIQEJku6R9jaqeg0eKB6
         2I6wOOtOMAL3QSD+DhqOf8hWWA+95itXaCshpcCKaYP+sTUp/DFagG+oRLggcM8tptH1
         5YoZ99qD1NDd5g3HVa45+qh+1BciZh5tqOqsqoxLzNkvS58AvUCMvOh3klpNZaZv2G0O
         Jfyg==
X-Forwarded-Encrypted: i=1; AJvYcCUYRUJcTpcqJ9pKNoQgwT7VrYeHoU2nQyxZnIGgvkxBptSrEGwVFONHK5OdJ9ZKaM+pr43rqO6MwBbc@vger.kernel.org
X-Gm-Message-State: AOJu0YxSfhajSxD0aAf4ZYZnAv+pCA//8VoGKhDWTDRFn9aVvLmQAbfa
	9tAOUaFWNXlVT1h+G2CcJ2CkLtMMdKa0JKrn+LBSX18AgV8NMcGmtTLLbYrBtxnn3iQkvSS03EA
	kFS8aVzsF7c2Va1VJ+TTEu6Ih9EMbNt5Q7coKkKTcJpMXJSXcWbTZ21y0FU82K7WehIKR/TTKgV
	tYY2ovNVIw+39/+jbXqTL/NgdYqi86mb+2/A==
X-Gm-Gg: ASbGncu7Dze91nZ6eMLI0fkHD9iqfVIb/Yu1upDRDU+/sqNwQcsHm/1XN6L4+r15qXt
	JCctNgp6P6rna/LBr02XiFe54nixsD5A=
X-Received: by 2002:a05:651c:b24:b0:2ff:cfbb:c893 with SMTP id 38308e7fff4ca-2ffd5fcc60amr46532421fa.6.1732820994102;
        Thu, 28 Nov 2024 11:09:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIeEpMGF/H22zp414InHW1svpPHkxi1av3dzgBicfwNUfbIUyxq9BjE4qZjXR1rvkVs3HzMYhIcovoyEEM+WQ=
X-Received: by 2002:a05:651c:b24:b0:2ff:cfbb:c893 with SMTP id
 38308e7fff4ca-2ffd5fcc60amr46532311fa.6.1732820993734; Thu, 28 Nov 2024
 11:09:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <yvmwdvnfzqz3efyoypejvkd4ihn5viagy4co7f4pquwrlvjli6@t7k6uihd2pp3>
 <87ldxvuwp9.fsf@linux.dev> <CAO8a2SjWXbVxDy4kcKF6JSesB=_QEfb=ZfPbwXpiY_GUuwA8zQ@mail.gmail.com>
 <87mshj8dbg.fsf@orpheu.olymp> <CAO8a2SjHq0hi22QdmaTH2E_c1vP2qHvy7JWE3E1+y3VhEWbDaw@mail.gmail.com>
 <87zflj6via.fsf@orpheu.olymp>
In-Reply-To: <87zflj6via.fsf@orpheu.olymp>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 28 Nov 2024 21:09:42 +0200
Message-ID: <CAO8a2SgMLurHP=o_ENbvOFMci8bcX0TP_18rbjrYJSbmV9CrMA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] ceph: ceph: fix out-of-bound array access when
 doing a file read
To: Luis Henriques <luis.henriques@linux.dev>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch, I'm reworking the ergonomics of this function, this ret
error code is checked and carried through the loop and checked every
other line.

On Thu, Nov 28, 2024 at 8:53=E2=80=AFPM Luis Henriques <luis.henriques@linu=
x.dev> wrote:
>
> Hi!
>
> On Thu, Nov 28 2024, Alex Markuze wrote:
> > On Thu, Nov 28, 2024 at 7:43=E2=80=AFPM Luis Henriques <luis.henriques@=
linux.dev> wrote:
> >>
> >> Hi Alex,
> >>
> >> [ Thank you for looking into this. ]
> >>
> >> On Wed, Nov 27 2024, Alex Markuze wrote:
> >>
> >> > Hi, Folks.
> >> > AFAIK there is no side effect that can affect MDS with this fix.
> >> > This crash happens following this patch
> >> > "1065da21e5df9d843d2c5165d5d576be000142a6" "ceph: stop copying to it=
er
> >> > at EOF on sync reads".
> >> >
> >> > Per your fix Luis, it seems to address only the cases when i_size go=
es
> >> > to zero but can happen anytime the `i_size` goes below  `off`.
> >> > I propose fixing it this way:
> >>
> >> Hmm... you're probably right.  I didn't see this happening, but I gues=
s it
> >> could indeed happen.
> >>
> >> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> >> > index 4b8d59ebda00..19b084212fee 100644
> >> > --- a/fs/ceph/file.c
> >> > +++ b/fs/ceph/file.c
> >> > @@ -1066,7 +1066,7 @@ ssize_t __ceph_sync_read(struct inode *inode,
> >> > loff_t *ki_pos,
> >> >         if (ceph_inode_is_shutdown(inode))
> >> >                 return -EIO;
> >> >
> >> > -       if (!len)
> >> > +       if (!len || !i_size)
> >> >                 return 0;
> >> >         /*
> >> >          * flush any page cache pages in this range.  this
> >> > @@ -1200,12 +1200,11 @@ ssize_t __ceph_sync_read(struct inode *inode=
,
> >> > loff_t *ki_pos,
> >> >                 }
> >> >
> >> >                 idx =3D 0;
> >> > -               if (ret <=3D 0)
> >> > -                       left =3D 0;
> >>
> >> Right now I don't have any means for testing this patch.  However, I d=
on't
> >> think this is completely correct.  By removing the above condition you=
're
> >> discarding cases where an error has occurred (i.e. where ret is negati=
ve).
> >
> > I didn't discard it though :).
> > I folded it into the `if` statement. I find the if else construct
> > overly verbose and cumbersome.
> >
> > +                       left =3D (ret > 0) ? ret : 0;
> >
>
> Right, but with your patch, if 'ret < 0', we could still hit the first
> branch instead of that one:
>
>                 if (off + ret > i_size)
>                         left =3D (i_size > off) ? i_size - off : 0;
>                 else
>                         left =3D (ret > 0) ? ret : 0;
>
> Cheers,
> --
> Lu=C3=ADs
>


