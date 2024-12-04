Return-Path: <ceph-devel+bounces-2241-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 584C09E3A54
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 13:50:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27262167B91
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 12:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E4F1B87F8;
	Wed,  4 Dec 2024 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LtG+z9mt"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333FC1B395B
	for <ceph-devel@vger.kernel.org>; Wed,  4 Dec 2024 12:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316620; cv=none; b=Pb8dV0SLP3Z1uyT9bEKgEb9YrK9N9z3PLle8G5uFzGnXqt71XuDLHgBxgfFfKRfhAOmT34reY/o3W94WFPmsNekOdsOW5uTy2QgkqKAepiUcxaxcqzf4mILHRjVPshFBqODCY4V6TmDUZL/bmbSjGEOmiiYYJUXHQ67RZ3J75YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316620; c=relaxed/simple;
	bh=/wbxSazmoCOK4xlEbiLtEWstaEh7tQjCs7+97A+fkPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fG8zU9QohhwfZDuSlCBp3wv9kMdlu2fkz+f1ysSso4PiF1UNZd4ULE75jLYItqmYhfCU23H4pMTtaAIpNB8L067E9tLXXkemOUluAIEgTEr0w+hfXZ8onRsqULSMXybyfK9T22tMZ+5DNUiDJ+NafZAKMvnE3Y1CYCNe3+Q2qFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LtG+z9mt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o7WjPi1lo0lYMkF5rZsJJaNAVTBr1ymij31y2lY5wSE=;
	b=LtG+z9mtPYLSxmP+A5fVmWVx6HVyvuuy7tyx3vD/wqss9ozRdx39Yo4fE7MpF1wFwZdQSC
	oenxqi7/THauxDLZg39CbslE9Zv4NQKre4TgRFDB9JPdUX9No2LSJvQdId1Y8Uqorzre+q
	jhONkFoXQm6a20OBIgrB31YZvcvRe8k=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-b1CS6ahWPN-MFOZcnD5nRg-1; Wed, 04 Dec 2024 07:50:16 -0500
X-MC-Unique: b1CS6ahWPN-MFOZcnD5nRg-1
X-Mimecast-MFC-AGG-ID: b1CS6ahWPN-MFOZcnD5nRg
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-5d0d0a5ae15so3206109a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 04 Dec 2024 04:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316615; x=1733921415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o7WjPi1lo0lYMkF5rZsJJaNAVTBr1ymij31y2lY5wSE=;
        b=KsvM9+u+0gEyj+YqapEO7UWOQxLLCjTpFK4Z7re2iBmXoj/Mo1ezlYKqUsOj47Y/GT
         OPGIVH3blNNCsoZbq5efWKorhP9fwqSOKzkEIKEnBP7ylGi99lfYlKblGh/RgEe/UpDi
         1rLNRhRC/8NEYAHM4mQt2QksKzzrZ3hR3eJuFONT/8RUyI/DExEzx41ITIDOb9kcClsx
         1EVMq9lboPkcb113bIYaiht1iJdAVtOCKcYmq5iAjvuIaCfghdRMvCCbaFdvgylqSDwI
         ed8D0SIVzy3c/H0Z7tL+fth8DA59o2q9WtP0ODevTgijqHFLjB7wMCPA06WuDJHTxUCD
         +SAw==
X-Forwarded-Encrypted: i=1; AJvYcCV7cn+EMncTGwbypMismtBqbYK17osctAWqdwcyFoDaljvSxyYe5sw2fbQnIjq+Tz1xSri0IKolx8G9@vger.kernel.org
X-Gm-Message-State: AOJu0YzOdifTzECooBkAjZ+v+NWrvP2Nm5ABmYKAvsQv03nKmiIMpXKF
	osuzPbIpIUiAbpRzixU8atR++6q3NhTGp8lyPAjIpazfdDFZMTdDVxMtEYrAH0QvGTZ/9E97/Fn
	kEaUtq4AZvkD9mqSd7YrK1ZD49Xy++5Wr4PApkbELzY7A5wiKjzNoFyEe4o4DY2b33v6DUqsLfn
	SgiaFkFV+tF5WkXnQWZ5fbDxfssyNM+Rl4nw==
X-Gm-Gg: ASbGncuCwgkeRJF59sTuuxBNNhQ5uBut0FpUq7pYOQ6LzkVpXAeMeWMml6lntFYHAQY
	K5RDLMVNua9FkMh3KdUhogfnTqXAk
X-Received: by 2002:a05:6402:2554:b0:5d0:bcdd:ffa8 with SMTP id 4fb4d7f45d1cf-5d10cb4e1d7mr5268511a12.1.1733316614692;
        Wed, 04 Dec 2024 04:50:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoDktRn1sCIHjfUdLg/24MP8DKL2rQ4Am1VEhg7VQRLpgQ0yNbF9CZlVXmYOxRokoWe59tG8QstLrohSUxX8U=
X-Received: by 2002:a05:6402:2554:b0:5d0:bcdd:ffa8 with SMTP id
 4fb4d7f45d1cf-5d10cb4e1d7mr5268494a12.1.1733316614369; Wed, 04 Dec 2024
 04:50:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e660f348-5a0e-486d-8bae-e6c229f0e047@stanley.mountain>
 <d75b6bb5-f960-4e75-90f3-e7246a2cd295@riscstar.com> <a7f2d7f9-014b-4535-a0d1-74c351d13eca@stanley.mountain>
In-Reply-To: <a7f2d7f9-014b-4535-a0d1-74c351d13eca@stanley.mountain>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 4 Dec 2024 14:50:03 +0200
Message-ID: <CAO8a2Sjkcmqr0Big38Dqia2XZFHVhbukWhAJXYh4Y3VPFrKcaA@mail.gmail.com>
Subject: Re: [bug report] ceph: decode interval_sets for delegated inos
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Alex Elder <elder@riscstar.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I assume a Coccinelle patch can be written, if one doesn't exist yet.

On Tue, Dec 3, 2024 at 8:29=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> On Tue, Dec 03, 2024 at 11:06:50AM -0600, Alex Elder wrote:
> > On 12/3/24 2:19 AM, Dan Carpenter wrote:
> > > Hello Jeff Layton,
> > >
> > > Commit d48464878708 ("ceph: decode interval_sets for delegated inos")
> > > from Nov 15, 2019 (linux-next), leads to the following Smatch static
> > > checker warning:
> > >
> > >     fs/ceph/mds_client.c:644 ceph_parse_deleg_inos()
> > >     warn: potential user controlled sizeof overflow 'sets * 2 * 8' '0=
-u32max * 8'
> > >
> > > fs/ceph/mds_client.c
> > >      637 static int ceph_parse_deleg_inos(void **p, void *end,
> > >      638                                  struct ceph_mds_session *s)
> > >      639 {
> > >      640         u32 sets;
> > >      641
> > >      642         ceph_decode_32_safe(p, end, sets, bad);
> > >                                              ^^^^
> > > set to user data here.
> > >
> > >      643         if (sets)
> > > --> 644                 ceph_decode_skip_n(p, end, sets * 2 * sizeof(=
__le64), bad);
> > >                                                     ^^^^^^^^^^^^^^^^^=
^^^^^^^^
> > > This is safe on 64bit but on 32bit systems it can integer overflow/wr=
ap.
> >
> > So the point of this is that "sets" is u32, and because that is
> > multiplied by 16 when passed to ceph_decode_skip_n(), the result
> > could exceed 32 bits?  I.e., would this address it?
> >
> >       if (sets) {
> >           size_t scale =3D 2 * sizeof(__le64);
> >
> >           if (sets < SIZE_MAX / scale)
> >               ceph_decode_skip_n(p, end, sets * scale, bad);
> >           else
> >               goto bad;
> >       }
> >
>
> Yes, that works.  I don't know if there are any static checker warnings w=
hich
> will complain that the "sets < SIZE_MAX / scale" is always true on 64 bit=
.  I
> don't think there is?
>
> regards,
> dan carpenter
>
>


