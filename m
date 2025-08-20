Return-Path: <ceph-devel+bounces-3464-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A13B2E5B0
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Aug 2025 21:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DCC3C1CC070D
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Aug 2025 19:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C074136CE0C;
	Wed, 20 Aug 2025 19:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLU1pXFr"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D272566D9
	for <ceph-devel@vger.kernel.org>; Wed, 20 Aug 2025 19:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755718558; cv=none; b=fRsBsGv2kwAng9rckD5JuCWNIo3CnJZvqHzrZvMJsLn+1f5HgMdO1FX0lGkbzsNM5FY5a0C7gA0ZPG1dGT/HLksdF4JNkJkkyRtbjJKbvQKFXQ5Av2OvFCU+Tn/PNlDRlBt9AF6z/VjrkqGpnUw/YQs67LT9Ig7Q8t8zN/fiP3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755718558; c=relaxed/simple;
	bh=G//fKdOQPO4mXZppaU9zHl8ix5CgB8L+rLbPhNiMsDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCgWqfkQ7xBF8bkX1i53Rg4p9jXhHZeEPTnY1XjZS854XUn3//ZWKO2VoFBfpUKK5viAJ/odKIEc1KOiR703gVegVYIiE6Dd0Rdqn1eUiqO96r/n9TQdYQ6FUWdv68d0O0actXiFgbH2KU5A5wCmXkaeMdV1yom0WhKAcvIoTgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLU1pXFr; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-245fd2b63f8so1827085ad.3
        for <ceph-devel@vger.kernel.org>; Wed, 20 Aug 2025 12:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755718556; x=1756323356; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8goEpRwDHGTRQ83yv27cbqDsKgd7ygSdu8TzpTbTPk=;
        b=nLU1pXFrpDEVqWmT2OnIQxxATegEFIHpERb62vKinEeZYq6956jdGOYltZGALVIhQy
         Y0GhdPlVopWJQ6hd7PR6dkpfBn0hL4ZlVQNsafINBOGt2CE7Ar7LXmjAmENdd8lcv5OT
         jYTcb7i7UM02jozIOSkWF6cGsb+NdzmSvfYZiT6npCmLXPF4kFtYVQyMGOe1T4mhFUIR
         O+f/dPxZnYpdNhU6T/eUrLghc87O8ZLW0cMZ0OQjd1LC2UTDoyvJSPdB72g0Sv/W7D4E
         Mn1hQLnaTjCeest2XaTUmwaKx+uaJjlNiY/UJE1QM5t5D8z6iL0Qm4h0PDIqgVU7MXtY
         Tzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755718556; x=1756323356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8goEpRwDHGTRQ83yv27cbqDsKgd7ygSdu8TzpTbTPk=;
        b=Eq5XYwHW0JvcoS9zuknoQ95Qruk3Ii5agWwqSLHbvWB/1dMfnM8JoE22N0fFpx32iA
         4qj1RMFDDfIrVJfmqR2C/1DSa60UpphnsAAqmHGZfx84IP/3gz8rBI5jCoRZuLYzHxer
         aeCT5VbX3sXnOOkfhU8wK7jhxcv69ttTbDo6dPnqmFLb5lH5pxEMG8XJvERO0X7eakwq
         xNXoGlyX6v8XH6b4LwB3fUWBkWAZgcOArHJKJ8tQbnN2YEy4zODu4MQbJkftA+ACLLrw
         tXX3H8Pu1UqEP+3uvCBfkFkKx5kigyX5g+aqAMIduEsFr91jzNHHLl6PVje35h4YQCAy
         ykjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbmLmQgT00nBlS5ODxChjWzdgI7mkgL8IiwNtDolndfMa7piGz0lg1pPVmwew/qiq0JeIIx0rHG2Bp@vger.kernel.org
X-Gm-Message-State: AOJu0YwuEJDFe7XLhQkFAS7q6qhwLisuIoiQWuWU8VhANqdDzX69KlZf
	3qlVzluN194RX/wzhDhLvY6LKXSIkEDwgl67KQAxR1EeEJRGhpC9npzRakU69hgCO76Fgjpl2ny
	q2vv7F08YmLiuEugvENq4Fgb/g/geV4Q=
X-Gm-Gg: ASbGncuFGHKDvEtx1zT7k24L8peFbQ++FW0L3KY85vP2PfuoEYnJj+bW18SDG/QZZ1q
	IruukTUZuLGwWFldaKqYxShEtzM+FrtpwbzX7qW8jfOkNj0R5SM/g3fJBa8hgwW6stMzi5STxDV
	0tqbRqXXKROKrcz2jwa6s4DB6BbomF03/dv5MjyROiQo97ou7zbNnJCw0uzaZij4G4ewUYYrRK0
	xp7WNo=
X-Google-Smtp-Source: AGHT+IEw6yEZFOyGL4kkp4xKr6cImocWO1TXMTWMUFNGtDhYr0rF3Q16Lj536Qp9dTsBeRtbktV1MMTVvO8wqs7Nc0Q=
X-Received: by 2002:a17:902:ce88:b0:240:72bb:db0b with SMTP id
 d9443c01a7336-245ef16219fmr52883995ad.21.1755718556364; Wed, 20 Aug 2025
 12:35:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250729170240.118794-1-khiremat@redhat.com> <3dbbabbd68b58c95a73d02380ce6e48b5803adf2.camel@ibm.com>
 <CAPgWtC4s6Yhjp0_pnrcU5Cv3ptLe+4uL6+whQK4y398JCcNLnA@mail.gmail.com>
 <6ec6e3f45e4b90c2b56f4732e0e56fb389442c6e.camel@ibm.com> <CAPgWtC5muDGHsd5A=5bE4OCxYtiKRTLUa1KjU348qnfPDb54_Q@mail.gmail.com>
 <75632a861cf3c3fe77bbc384a805e9e4e77b95a8.camel@ibm.com> <CAPgWtC4z2G5GuWjzTf4oRc=h=Vx7_0=S4FHvRMe-fmKFgrAdUQ@mail.gmail.com>
 <185b42f5e88db732e299ca5f8323306951b08c88.camel@ibm.com> <CAPgWtC5EVzdWZbF3NgntHaT03fiqH=NM-HTUPunE6GeJD1QPSw@mail.gmail.com>
 <ae92e8a5cf730e997d031adb5e1708f17975e8a9.camel@ibm.com> <CAPgWtC6QSaGfrjHWRiW9OL6SF4fpKedqXzb1mUzjhNepRh-C=A@mail.gmail.com>
 <35eed4288342fd73fa7ba4166eff899daa28a8e6.camel@ibm.com>
In-Reply-To: <35eed4288342fd73fa7ba4166eff899daa28a8e6.camel@ibm.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Wed, 20 Aug 2025 21:35:44 +0200
X-Gm-Features: Ac12FXwZPsALaDAUj3Ba91dka_5SL2ivXFkdBaiWZqu4jB6lbMipOxqxL0gXtRU
Message-ID: <CAOi1vP__RnxLUzLMMvqELsgRLyb4qkw+dwSACQinRGz4xJjNVw@mail.gmail.com>
Subject: Re: [PATCH] ceph: Fix multifs mds auth caps issue
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Kotresh Hiremath Ravishankar <khiremat@redhat.com>, Venky Shankar <vshankar@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Patrick Donnelly <pdonnell@redhat.com>, 
	Alex Markuze <amarkuze@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 8:03=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Tue, 2025-08-19 at 19:31 +0530, Kotresh Hiremath Ravishankar wrote:
> > On Wed, Aug 13, 2025 at 11:52=E2=80=AFPM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > >
>
> <skipped>
>
> > >
> > > OK. I agree that restriction creation of filesystem names greater tha=
n NAME_MAX
> > > length should be considered as independent task.
> > >
> >
> > Are you suggesting to use the inline buffer for fsname with NAME_MAX
> > as the limit
> > with this patch ?
> >
>
> Potentially, inline buffer for fsname could be better solution. However, =
if the
> user-space side can create the name bigger than NAME_MAX, currently, then=
 we
> cannot afford the inline buffer yet for this patch.

We have had many instances of the kernel client not supporting (e.g.
by refusing the mount or continuously throwing an error after mounting)
something that is possible or even officially supported on the
userspace side.  The most recent example is the case-folding feature,
before that the big one was limited support for inline data, no support
for the old way of doing quotas, etc.  If justified, I don't see
anything wrong with restricting the length of the FS name irrespective
of whether it remains a dynamically allocated string or gets an inline
buffer.  The userspace side can catch up and implement the create-time
check that would generate an appropriate warning or just fail the
creation of the filesystem later.

Thanks,

                Ilya

