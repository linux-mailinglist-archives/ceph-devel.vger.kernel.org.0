Return-Path: <ceph-devel+bounces-3523-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8561EB4458C
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 20:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFFF0587154
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 18:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264F62367D5;
	Thu,  4 Sep 2025 18:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tn6uGwlh"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994CE224AE6
	for <ceph-devel@vger.kernel.org>; Thu,  4 Sep 2025 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757011003; cv=none; b=XP4fNTJf3uT0VKdwOkSp/8G2RlABJVHLpDeGAmGKlfaRzeM/1doouCpov3jeB6b3nNKn2ojRJw41xX4u9flqGlzFJ2Ktj3scIlZajG/W9Mbld/hiYVVrUPLgXoE92VgNYjrPCGt9eF2u5ozhCzuwHTGt6Wb6O9EDyP3aqUCq0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757011003; c=relaxed/simple;
	bh=nNREjiI14TMw6bLqfOvvB8e6QL7VI165+o0XHDB3XRg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V1wRIKrRKWame6KTMAgcOOWVVdg/5MLbFvmXDqP/tF4zJbMeBKYtJcwx1aLyV+RRVGejeQVTih3xFXadaYBlEq1D2hqgtK64/UPOtYAVcHq9rEam3VdC9emMDi+B+zEE8hM89j+YSmPRk0uGtJ+zChQXjZmIQ9QF3GC95IdrrfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tn6uGwlh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757010999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kUoOgtDmVPvtU0d6dLe6T2mB6VaPbKe1PvwedEnTvlQ=;
	b=Tn6uGwlhwMmEkWPGYkGF+8ZMCJXJzWRQXQNxvUZ2RoRZbfXCOhW7v3XahWoxTeuqOAUQJg
	fIpQWuSMC1F6SWVFSOm9heGNLqKy9WyCXqPaDOoFQx4B8V2xHiN+Eq8QJsJ1vW6UV02RTT
	qn5I9MgaIJqIGN1AxjPuj4M+geCqfH0=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-6Cbt9VYJMOmYuTo2UkoQmQ-1; Thu, 04 Sep 2025 14:36:38 -0400
X-MC-Unique: 6Cbt9VYJMOmYuTo2UkoQmQ-1
X-Mimecast-MFC-AGG-ID: 6Cbt9VYJMOmYuTo2UkoQmQ_1757010998
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-72166cf69bcso23460097b3.0
        for <ceph-devel@vger.kernel.org>; Thu, 04 Sep 2025 11:36:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757010998; x=1757615798;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kUoOgtDmVPvtU0d6dLe6T2mB6VaPbKe1PvwedEnTvlQ=;
        b=XsImS01zMO4rZYNUEUEk6xBAoHd5JyEwK4k5C35Vm2LQ929yYWLZQqJ9HR2d0c34PI
         ex2x/NntkA1xyVz8FiizT8xrYsDWlWK72kZv4kO2lJYcredYbyaJmExRCZ1z+U1RcJJB
         aAFIQeBf6SDfJqYYx4wBR4j86eptgel2Bqpx4kCiDZKexBdnz/6QCLY6Fzx39TKItWGm
         4BrkEPLMbUoMiAXZSZsXDOU6fSi739FWkX1dlcbl3drDdBG2C1J4g2t2xXCaWQsZe+Vb
         e70LtvIz8WdqWxo0OkU6uOh+kuy58y/BLrRRtYzTiViOiaaN2e9EP4xOV4y2u7RDBd1h
         go/A==
X-Gm-Message-State: AOJu0Yz9QVSJhFGWml8MOFBu8mEnqyDPQocahyWh9EBUmu1hHdkYf2tx
	ygH/0BMXd2wyh/y/525O3Lrpi3jxd91qlTyoW/h/JmX42HgCstv59TJ0hWql/+CyLGISI+yCYSN
	tUpaegz3fpiU4oG7P4zdel2hCPm7/mIQoDPab/Ps2UEhKj5iEycY/OBTr4vjL1yc=
X-Gm-Gg: ASbGncsu/hIRpfLpiRAQ9n5SOsG2oI+qS7kcqwYIqaF2kYNZl0v0JHVsNZjOegB6dsZ
	SWD2sDDdc1OMTeio4kOMwHASbisS4rmFExhNOs7I3WtFPvWqnFd2ejkqHpkTaKYIpE+B8/lO6z4
	RtPhzogPJ0NeNzF19oXASspYdvBP+mOKH62okmS/InaCwZv1aZx4gVt5COShxmaTwDzCaI0aY9f
	ynk9xe4C+CU7Ka7mKB4VXxbCnl/So2Cor8kUessDilwdR3wouCXqIAPeXIda2mUnQAqzzMpMA0V
	VbyGTDAcuNGx3vghyuldVC/S9XRCQZnbUQ3Wj7BIx2eggUl1vlfcEHy2GdQEezYI4x18
X-Received: by 2002:a05:690c:6512:b0:71f:9a36:d332 with SMTP id 00721157ae682-72544c08a77mr6426047b3.27.1757010997736;
        Thu, 04 Sep 2025 11:36:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE82QRekzPTrDWlL/a6mMRqKoCvQRuBEzYmW5Cr995ml7oOTUF1e6Enft6jXC9PiheIYQzdMQ==
X-Received: by 2002:a05:690c:6512:b0:71f:9a36:d332 with SMTP id 00721157ae682-72544c08a77mr6425887b3.27.1757010997313;
        Thu, 04 Sep 2025 11:36:37 -0700 (PDT)
Received: from li-4c4c4544-0032-4210-804c-c3c04f423534.ibm.com ([2600:1700:6476:1430::d])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a8502985sm23540587b3.40.2025.09.04.11.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 11:36:36 -0700 (PDT)
Message-ID: <189c4b739dafa71d7e0717fd2c4138a5226ef8fd.camel@redhat.com>
Subject: Re: [PATCH] ceph: add in MAINTAINERS bug tracking system info
From: vdubeyko@redhat.com
To: Ilya Dryomov <idryomov@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	pdonnell@redhat.com, amarkuze@redhat.com
Date: Thu, 04 Sep 2025 11:36:34 -0700
In-Reply-To: <CAOi1vP8Og5phUw3LO3Fv3yfnSSx3FhuSmj7j4pHrF00t-MGS9w@mail.gmail.com>
References: <20250902200957.126211-2-slava@dubeyko.com>
	 <CAOi1vP8Og5phUw3LO3Fv3yfnSSx3FhuSmj7j4pHrF00t-MGS9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi Ilya,

On Thu, 2025-09-04 at 12:45 +0200, Ilya Dryomov wrote:
> On Tue, Sep 2, 2025 at 10:10=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko=
.com> wrote:
> >=20
> > From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >=20
> > CephFS kernel client depends on declaractions in
> > include/linux/ceph/. So, this folder with Ceph
> > declarations should be mentioned for CephFS kernel
> > client. Also, this patch adds information about
>=20
> Hi Slava,
>=20
> This argument can be extended to everything that falls under CEPH
> COMMON CODE (LIBCEPH) entry and then be applied to RBD as well.
> Instead of duplicating include/linux/ceph/ path, I'd suggest replacing
> Xiubo with yourself and/or Alex under LIBCEPH and CEPH entries so that
> you get CCed on all patches.  That would appropriately reflect the
> status quo IMO.
>=20
> > Ceph bug tracking system.
> >=20
> > Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > cc: Alex Markuze <amarkuze@redhat.com>
> > cc: Ilya Dryomov <idryomov@gmail.com>
> > cc: Ceph Development <ceph-devel@vger.kernel.org>
> > ---
> >  MAINTAINERS | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6dcfbd11efef..70fc6435f784 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5625,6 +5625,7 @@ M:        Xiubo Li <xiubli@redhat.com>
> >  L:     ceph-devel@vger.kernel.org
> >  S:     Supported
> >  W:     http://ceph.com/
> > +B:     https://tracker.ceph.com/
>=20
> Let's add this for RADOS BLOCK DEVICE (RBD) entry too.
>=20
>=20

Makes sense. Let me rework the patch.

Thanks,
Slava.


