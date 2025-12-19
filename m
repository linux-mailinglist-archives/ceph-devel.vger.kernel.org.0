Return-Path: <ceph-devel+bounces-4200-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F1571CCE1E5
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 02:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 02141301919E
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 01:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2D321ABB9;
	Fri, 19 Dec 2025 01:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OhtaN4LE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dGj+ITNM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C28C18C008
	for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 01:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766106705; cv=none; b=pEXlEaJ7MikYRB9kaD0cUeZHEEsQ5WreLMwy39apbr6k6t0Ouo0iXtxDAkkMvHBaVsDtF1Gma8ozfhHf6J5V0TodfkPz3tZyVhL5zIJobgyaynH4R/dEzUuoKN19fqOKd+fFQRnOW62vGYSLJRcHo/SkciNQ93F7jcisBD7LRYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766106705; c=relaxed/simple;
	bh=cypdv1WcQjsWPVmw/CKxIZtz/TZoJzZOztqX045WzdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W3j/Wi1O3rUIXOAS5VsC4AKJZPuRX1Nj0c+4xsVo5MIQOQ45Xxm0GN5Mt1rQCFwKNRAfCos2D/8jW1FWdpzu+CLFvNL/4Y1JTjcAEGbTV48RTAN99Zxhn+NnBF9zEYM2s6hDb6qmpWO2sHG3JvecWdV4+e9PSM9Y/BjBMJlIGYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OhtaN4LE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dGj+ITNM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766106701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kK1BjENHT315R0V+8XhXVEsGAsXTisaxdut0tnfFRGY=;
	b=OhtaN4LEjHB/l6mRphjEtYuyt/D1PLqoPNtIbQAHHeqEgp14yGKSq6RZZgV1B9Gb4esc6Z
	fwj8GjCa2yGV5LKxxEJNeexpi88of6N3FmfKrfBHmDQ0Md3p5tp/DA89FttZzJTO8knbWE
	wks/J03YkhrU0WITdqpbiuy81EhN52E=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-71uYsS4pPYi5HxkhYiHHSQ-1; Thu, 18 Dec 2025 20:11:40 -0500
X-MC-Unique: 71uYsS4pPYi5HxkhYiHHSQ-1
X-Mimecast-MFC-AGG-ID: 71uYsS4pPYi5HxkhYiHHSQ_1766106699
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-45322138f81so2118551b6e.0
        for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 17:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766106699; x=1766711499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kK1BjENHT315R0V+8XhXVEsGAsXTisaxdut0tnfFRGY=;
        b=dGj+ITNMim6NOVeEAMHFyI7TqwZaf683IiZjWUT6VCiZdVyxXvGm3P7PgfRvGPP7oq
         7ZLzEjB3ZIEmgnhSvQcyRXr8BcwHDmDgZd40/ObF1Ase27cIod99xhDWHO0KMmA/8Rzd
         AV1ETWCj5JUqL8ZHtPayYZ2TaBKF6bfNZ/eSP3LlwYh8iUExf65tt8TZIQO7Y2/4AbKd
         TwxO2UPJ7edTFp91F/JbM/s3mta0n0Cv4d5bziJSkjKiSqCMm+ra31Ag8MKfbUKnBt+E
         F259AAVaS1Vie8iSjz2/OCkwGdD5dJtsByDximLCtYiKu37rSNj1mzIBj0hNCyebc5Ca
         Gj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766106699; x=1766711499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kK1BjENHT315R0V+8XhXVEsGAsXTisaxdut0tnfFRGY=;
        b=QX6kMimuNim7WeuKjWqRp7QroR06jYIa7pmzHVm50JEOM5zf6H0lJrkrkDSkTsAH2E
         SsEoAO1sVpJ+zlpxNrZdktyUT0fEGxDshE61JTD49omZg/ySbVCxy7zbwt+gACjQrKhE
         iqbc8h+fMKuG7x6QbIe1M/W1h4Xlir4GIxjrejcGw+u9b2BFacvcUacDu07DSsAnrLxd
         OuNUnOBLo0sRkvVc2MGkZLCGV59v7VCO8avb/Blmt6ucD6M46THhgqmYyr8VtChFBZEu
         HbslU7h6Pf73kwOX6PVZPebGDVYm9o34pEHqtGYyV3ZVZhx9ptLIWbDs4xzQF92iICCK
         Ow9A==
X-Forwarded-Encrypted: i=1; AJvYcCUSJf7fGpTszGEYtnXcL7hIN0GVDrO5ZODOmaoGradRafCZeI8a8/v8mgQ1KlzPpfb+VncSYvXL+RqT@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7gqn/k4LCCmN0R2RrZfinnBij5QZaciHlKqzAXbp00JAgW0vm
	QS80mwfcECvoJEp0alGEvQzPcx2135JSTLKKoZJmxW5hoWcEG60wUIwzMIn/ee208XGZRDiLVGo
	zJdFHHUyc5CRu4F9j6uu3tVQukikbiFm8OOTtmRon1DbVCGzhTVezAinA5ym9U26mASP5D2FvC7
	PZXJHQY6Q6/I/MqarfCkHjn+BhSIQkCjE/RhCgIw==
X-Gm-Gg: AY/fxX7W9zYRSvBD0CYOSMtLKhDpFWjyNOXLPLlMVRjWnUusnmm/SUJym4OZ1pnHTCD
	7IpcG5Mtr3B9i0LRAfrAx4+Xe/ruVOY+B7NVB3If1RVdxtIjIq6HO2jC+l10xyE0Rfq22NUBqBq
	vqrcGf3aTwbcb7YGSBTJTpfpBQBzjoRP6l4MyRuqGLYsm0lcgI4SnUebHeAEuYeiJZG41Io4BAD
	TaiuKYx8kusqaJ+pQlWw7+0kA==
X-Received: by 2002:a05:6808:e82:b0:450:c7dc:d7f6 with SMTP id 5614622812f47-457a2956782mr2011008b6e.25.1766106699395;
        Thu, 18 Dec 2025 17:11:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtVBPCCNoDj+iZNdcFdsjUyUmyVLsV5cVhaTU6hofQvRoJEGh8oFm6QrJ5JkKPTeWjcI4OOJDjXeg+R4RJsI0=
X-Received: by 2002:a05:6808:e82:b0:450:c7dc:d7f6 with SMTP id
 5614622812f47-457a2956782mr2010999b6e.25.1766106699050; Thu, 18 Dec 2025
 17:11:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215215301.10433-2-slava@dubeyko.com> <CA+2bHPbtGQwxT5AcEhF--AthRTzBS2aCb0mKvM_jCu_g+GM17g@mail.gmail.com>
 <efbd55b968bdaaa89d3cf29a9e7f593aee9957e0.camel@ibm.com> <CA+2bHPYRUycP0M5m6_XJiBXPEw0SyPCKJNk8P5-9uRSdtdFw4w@mail.gmail.com>
 <fd1e92b107d6c36f65ebc12e5aaa7fb773608c6f.camel@ibm.com>
In-Reply-To: <fd1e92b107d6c36f65ebc12e5aaa7fb773608c6f.camel@ibm.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Thu, 18 Dec 2025 20:11:13 -0500
X-Gm-Features: AQt7F2o1xOq8N6VmFiiXc3BbbWHuTS4OE1Ez9oqQgwuW2iKClAq_iiWbHkenKdg
Message-ID: <CA+2bHPaxwf5iVo5N9HgOeCQtVTL8+LrHN_=K3EB-z+jujdGbuQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix kernel crash in ceph_open()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>, 
	Kotresh Hiremath Ravishankar <khiremat@redhat.com>, Alex Markuze <amarkuze@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 2:02=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Wed, 2025-12-17 at 22:50 -0500, Patrick Donnelly wrote:
> > On Wed, Dec 17, 2025 at 3:44=E2=80=AFPM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Wed, 2025-12-17 at 15:36 -0500, Patrick Donnelly wrote:
> > > > Hi Slava,
> > > >
> > > > A few things:
> > > >
> > > > * CEPH_NAMESPACE_WIDCARD -> CEPH_NAMESPACE_WILDCARD ?
> > >
> > > Yeah, sure :) My bad.
> > >
> > > > * The comment "name for "old" CephFS file systems," appears twice.
> > > > Probably only necessary in the header.
> > >
> > > Makes sense.
> > >
> > > > * You also need to update ceph_mds_auth_match to call
> > > > namespace_equals.
> > > >
> > >
> > > Do you mean this code [1]?
> >
> > Yes, that's it.
> >
> > > >  Suggest documenting (in the man page) that
> > > > mds_namespace mntopt can be "*" now.
> > > >
> > >
> > > Agreed. Which man page do you mean? Because 'man mount' contains no i=
nfo about
> > > Ceph. And it is my worry that we have nothing there. We should do som=
ething
> > > about it. Do I miss something here?
> >
> > https://github.com/ceph/ceph/blob/2e87714b94a9e16c764ef6f97de50aecf1b0c=
41e/doc/man/8/mount.ceph.rst
> >
> > ^ that file. (There may be others but I think that's the main one
> > users look at.)
>
> So, should we consider to add CephFS mount options' details into
> man page for generic mount command?

For the generic mount command? No, only in mount.ceph(8).


--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


