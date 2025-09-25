Return-Path: <ceph-devel+bounces-3728-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 596FFB9E9CE
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 12:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56D4F19C77DE
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 10:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6752EA159;
	Thu, 25 Sep 2025 10:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIohyaEE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B864CE55A
	for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 10:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758795867; cv=none; b=LBo7Cvpk52lGbU2+K6HU9djT96EynH660tb0U+ICEpxP9vT0CaXq475fTiPpDbSNKzKnyOo+W5pCwl0Gco547KKL85LJJoErpANBLswaKbYZYKnvhpLzGm9R7gOthr2oO06eug1R8YT75lQfNRqQwCYKmBVFH6yMHO+BzOuToHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758795867; c=relaxed/simple;
	bh=fR1fieAAj3umYCV/toPyO5fnJbeltf4erytWWJMPkA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q/xedC5M7/IjfwXGDcI2pcl7lWQFPhchvJgSfhZ9Gr0FDCBdHYFV+zfdPruo2KwuxgdZRCKJeOre6WmrK3bKZQzZGtZeLKI4X2YEciwMujIuFxG3euQEWtfwmMaKSRZeMc/hmOq6thBTcE75cvPk/yvrgUc8E0oVxqgkOxbCGpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIohyaEE; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ef166e625aso669069f8f.2
        for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 03:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758795864; x=1759400664; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s7sPHP16RW7OMHHiXSJeSaUegXdDldvsncfoS8C5oxs=;
        b=XIohyaEEcWGullQDHv8o/WHx9drQO8dE7rsKE8kgHN9jLzui83gpeXw86HF5r6tZvd
         LaQSGD4Ql4b8r54mxYhNvrx2J4biXCqevCydbgoR8dnoFmBpcginOyor91NXf0COxjQx
         3T0Yyl0AW2ypy+CpCoUC3MmFhZN29inzh5F4TUYsg29isNF2+2/TxxGOWwJK02EMC0mX
         zpQetRI690FaU/BGFow9FcFt0h2Wi6DsYS6Wd55T3CZHR3ajMzz4nntxI7goB1Ksvjjy
         a8IA/TMaBiEKvuBLeZyor4iZC+hwNSk2z4g31nFxzcrsItCKsgHPgcKl7/edY2yZiixm
         w3rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758795864; x=1759400664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s7sPHP16RW7OMHHiXSJeSaUegXdDldvsncfoS8C5oxs=;
        b=IUJQbotgxhCYs4vqGfHI5VwFKd9fQxKRJnTskebRHrplekDHowcBrh1IKxDs9kXcg1
         hj/tymRCws8UnwV4LLQSrhp8r+3uwki/w84yJaEOErEc0j4LSjc3+y+Wt7NgR3cWAa/J
         zoeAXbEjLQDLAA6d+NWeBI3sVu4jbz+oOyqB5hQCRQz5agC7P51oQCchVjU4AteOncxr
         Ix4NtB2edCeqIQwZLjMaYelwrJFQKmT3nGbuVBYmD/lcHRclM5MAeTr00ZOPwp1Lm/Kp
         74OornEOrgoA4JKNP9ZYOf4eWBVBK3deMM5EiLRWFVLY5GEYATn8PfXAUM+DrG3BiPtr
         DNRA==
X-Gm-Message-State: AOJu0Yy4GdHzMQuBaTSttHrMZo56SWnJK0Nt01kO4tUqbzOkvj2GTtJY
	v8TSiU1pglXiPMHWHokWetkTYmXF1CN3HmUw62lYsJUSos7Sf6TuTt/crPkTpvo9z2GEOOYyKSY
	C2G+rX3VNP0lcoM5kOIaRydBNoNefB9I=
X-Gm-Gg: ASbGncvkeNsAooMZA5PntYEA3/vpce6tPYgiMxToKgy+YCfoCSz9f8mWpXs1KRC3fLo
	Yw4eSQLVyBMjCaWk5d4Dp7Ee6dftr+dzECu06dBPQQ0rRbzxzyik72fA2sDAfcD30viqrqiQ+6v
	N7zfkzwPRwRV6CQdO59s+5PPGqrRK9OeQnjlWHfMagOeAvQxeGSm/42xiPWc1tmvWMUjvew/77p
	TDXaudy3X2MdGZS6Tz4
X-Google-Smtp-Source: AGHT+IHwDdSc/TJ/o92tv6SPKTI6OWDV+jLprnN0V72tx3X6PFVDV/k8WZRZQw1ANSRTHOMbgNggwrrESfkotT6EgB4=
X-Received: by 2002:a05:6000:1a87:b0:3e9:3b91:e846 with SMTP id
 ffacd0b85a97d-40e498b7760mr2777437f8f.10.1758795863648; Thu, 25 Sep 2025
 03:24:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924095807.27471-1-ethanwu@synology.com> <20250924095807.27471-2-ethanwu@synology.com>
 <396d9279317ff76f26eabf541281ff94fda5505d.camel@ibm.com>
In-Reply-To: <396d9279317ff76f26eabf541281ff94fda5505d.camel@ibm.com>
From: tzuchieh wu <ethan198912@gmail.com>
Date: Thu, 25 Sep 2025 18:24:12 +0800
X-Gm-Features: AS18NWD3WKmGwAeXLRnjTquNFH89n1fwJe4SGkG4SzcebD9akITTQp4OfqDNumM
Message-ID: <CACKp3fk4Bs75G5pEFV0Hyd3Ft0-3HxF58n50gzojMGv1fSJbNw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix snapshot context missing in ceph_zero_partial_object
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, 
	"ethanwu@synology.com" <ethanwu@synology.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> =E6=96=BC 2025=E5=B9=B49=E6=9C=
=8825=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8A=E5=8D=882:26=E5=AF=AB=E9=81=93=
=EF=BC=9A
>
> On Wed, 2025-09-24 at 17:58 +0800, ethanwu wrote:
> > The ceph_zero_partial_object function was missing proper snapshot
> > context for its OSD write operations, which could lead to data
> > inconsistencies in snapshots.
> >
> > Reproducer:
> > dd if=3D/dev/urandom of=3D/mnt/mycephfs/foo bs=3D64K count=3D1
> > mkdir /mnt/mycephfs/.snap/snap1
> > md5sum /mnt/mycephfs/.snap/snap1/foo
> > fallocate -p -o 0 -l 4096 /mnt/mycephfs/foo
> > echo 3 > /proc/sys/vm/drop/caches
> > md5sum /mnt/mycephfs/.snap/snap1/foo # get different md5sum!!
> >
>
> I assume that it's not complete reproduction recipe. It needs to enable t=
he
> support of snapshot feature as well.

I use ../src/vstart.sh --new -x --localhost --bluestore
to deploy the cephfs environment and the fs allow_snaps is enabled by defau=
lt.
but client snap auth is needed.
I use the following command to grant the auth
./bin/ceph auth caps client.fs_a mds 'allow rwps fsname=3Da' mon 'allow
r fsname=3Da' osd 'allow rw tag cephfs data=3Da'

>
> > will get the same
> >
> > Fixes: ad7a60de882ac ("ceph: punch hole support")
> > Signed-off-by: ethanwu <ethanwu@synology.com>
> > ---
> >  fs/ceph/file.c | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index c02f100f8552..58cc2cbae8bc 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -2572,6 +2572,7 @@ static int ceph_zero_partial_object(struct inode =
*inode,
> >       struct ceph_inode_info *ci =3D ceph_inode(inode);
> >       struct ceph_fs_client *fsc =3D ceph_inode_to_fs_client(inode);
> >       struct ceph_osd_request *req;
> > +     struct ceph_snap_context *snapc;
> >       int ret =3D 0;
> >       loff_t zero =3D 0;
> >       int op;
> > @@ -2586,12 +2587,25 @@ static int ceph_zero_partial_object(struct inod=
e *inode,
>
> As far as I can see, you are covering the zeroing case. I assume that oth=
er type
> of operations (like modifying the file's content) works well. Am I correc=
t? Have
> you tested this?

Yes, I've checked all ceph_osdc_new_request
Only these 2 places misses snap context, write operation works as expected.

>
> We definitely have not enough xfstests and unit-tests. We haven't Ceph sp=
ecific
> test in xfstests for covering snapshots functionality. It will be really =
great
> if somebody can write this test(s). :)
>

I can add this test into xfstests or ceph unit-tests,
which place do you prefer to add this test on?

> Thanks,
> Slava.
>

Thanks,
ethanwu

