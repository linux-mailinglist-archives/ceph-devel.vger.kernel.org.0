Return-Path: <ceph-devel+bounces-4209-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EAACCD2375
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Dec 2025 00:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC627302FA12
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 23:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAF62EC090;
	Fri, 19 Dec 2025 23:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TVlCSSSG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t2h2tBFY"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5D32D877B
	for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 23:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766188691; cv=none; b=DeqZKECNDH5jORGNiTQiDry3O3+Z7/A26mRioZY6Y9ELDIDHBQKSyeGmAAee5nE6lErq3l2onWXOizq8sPsKIGMFlRlWUmD7oFsWVLotK/lpi6SKmf2upHaeKQQBYcadFgG7rBBlzNtwn94M+ut7dxwvXHUYrb6MWr0Bcig+vZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766188691; c=relaxed/simple;
	bh=fg5yo1xQHprJo8FbsfiNsG2MyoT6pTg3ZTbfjAtjHSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=En9tYAEnV+Dneyctk81o8gyw/IaALobBIwNdYEBXb0Vn1wEdkQxFoM8z8/U7Qxeq/NBNSHr2JYlW3gL52Gh3wd8NoR+D04oa/8BQAU+87rBn0dwXm9T7q0g7Db6t6E8TgQS47cigeHOjzETk+4OzbGBxJxV+qld0rx1nUC/K1XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TVlCSSSG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t2h2tBFY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766188686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ALzyGtBadbZGkYeZTAjY82NX2KCDRBpXYZcaej44mCc=;
	b=TVlCSSSGQPE37OqSIHb0N+wabbiOcR4oIPjXFYrk87nunATJthyd5nzfQPyFiQihVnNo2O
	O/74U+ADEg1h1cQ75MBcGRFTrmxYBoDGS6hwhCUV1sjtHvn4e8EQwtOVc6H5zuMPdEA/4L
	IGJ7BoPJELt1bm+HaIy1rExPnFjBECY=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-2g3rGzJPMc2DOUOpxr2aFQ-1; Fri, 19 Dec 2025 18:58:03 -0500
X-MC-Unique: 2g3rGzJPMc2DOUOpxr2aFQ-1
X-Mimecast-MFC-AGG-ID: 2g3rGzJPMc2DOUOpxr2aFQ_1766188683
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7c7595cde21so4416042a34.2
        for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 15:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766188683; x=1766793483; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALzyGtBadbZGkYeZTAjY82NX2KCDRBpXYZcaej44mCc=;
        b=t2h2tBFYFEmWwWJkZepXsmmsDiNn8SFDRTsbNXzhi9u0yFZjEBxLIbWibHn+SY0gM9
         8XjDyvCSjVEViPSZ1CJ8posLmLs5xkyODUd2963zDoTWJaejWHSjsyS/CcAXxZQW9nVS
         9+4LNEyRenDOTMk4En3v7HWLJGgElK3/53MwgfN/xLWXiS11eH421/wFxQJlkfLf5Gog
         G8BEhxyMM1cZ6yGj2xrlASPpMU+vxGFPwaH/6qRZ4O/wiRjfIp96OjowC0wkJh9gFtjW
         hHAM/24dJhP5wPS48cEzV1xGq2ePLYy+7uTRjEk8yENTDXNdx776Ux1aoWuUjkz10i4p
         xwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766188683; x=1766793483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ALzyGtBadbZGkYeZTAjY82NX2KCDRBpXYZcaej44mCc=;
        b=Z3lgADuyKFPXwnG3VLXdJtnQevQZEob/mimtpb/RUStr4yJMXmRTURwoyLhyv8VFyu
         DMvUl0w/cSWCRrXH9RpWNZvlQT5ALO0sRVfMW+n3K5Ue70//RJ9kK+84peX9hxke7OwO
         JGOdoFRqWVlI3N5VgisIAnT+WmnTV3wSzdVvnTlW1EuHqF9qxkMAHZYALDBtaAtYtRHg
         vk6KzjOMBoe9Nry8lOr1ycArhls8AQz17LLtGpOqpE3AxJInG5ioGjycpOAgHZffH7SQ
         QkxnuQ7Tz7xGf4Ona/ZUxRR8S0QNP6QyJ7jvpumnBkI7wfT+jMyjfHB4gsGkY29kvsi+
         59tA==
X-Forwarded-Encrypted: i=1; AJvYcCWxzQwKuVFAMp89biM/QZyPyPXkfGgH/dHXm1ut0CiQkG2SAGtWnog1RrWxfFE1DgoUB7EoM6kef+ks@vger.kernel.org
X-Gm-Message-State: AOJu0YyTIn+TIa4MOvETcqOEo/Fu3HXoBDf7l+esmem7S0+OYrH7r1P6
	XNkZWR/PWVyd3adYQrASWiSTIelD+/5M+lcoGcBTpUotRm1vcyXqams/ypY0+jTNZf1HNoH7CaP
	B3sIdUmh4t1avRKT3w+3ugpBOwf9I6VQhxox++OvjrRBX6JUPfzevKDZEAE/GYDakxYGQIIIPEl
	lz9tsiEzb4kurjfMowaEro5Q4nN+0cOSM7tolq9w==
X-Gm-Gg: AY/fxX5Uhu04xDbI/gbSNdq/ZtqEIBUn4BdoWuvS0huWyJatBwYwZogSdqsKryVV8+A
	YIELZQpkIuVZhHJpuDUYREnNS00FB8sxuMSQMBFFaKBsFTFvvuerT3nGYoonYalknvUngPIuv7h
	eNmeiQRNO1SsK6LAVwOqV6I5IWWaWoMOhtTn0yRRM8iV2L7rMQ9OfXwcTntbRovTKqo82laA/x5
	V85L9r5aVl5VodptGyuB+QNAw==
X-Received: by 2002:a05:6820:22a6:b0:659:9a49:9009 with SMTP id 006d021491bc7-65d0ea7234dmr2047564eaf.54.1766188682805;
        Fri, 19 Dec 2025 15:58:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFkZgbLIJ6ZlFxqxj6DIFGtzXWHySjjDCDaU59hhL/rXFFpA1JV6B/4qSUVo4rT38mLRQ6n9JAyYN2XvIzJQBU=
X-Received: by 2002:a05:6820:22a6:b0:659:9a49:9009 with SMTP id
 006d021491bc7-65d0ea7234dmr2047556eaf.54.1766188682443; Fri, 19 Dec 2025
 15:58:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215215301.10433-2-slava@dubeyko.com> <CA+2bHPbtGQwxT5AcEhF--AthRTzBS2aCb0mKvM_jCu_g+GM17g@mail.gmail.com>
 <efbd55b968bdaaa89d3cf29a9e7f593aee9957e0.camel@ibm.com> <CA+2bHPYRUycP0M5m6_XJiBXPEw0SyPCKJNk8P5-9uRSdtdFw4w@mail.gmail.com>
 <fd1e92b107d6c36f65ebc12e5aaa7fb773608c6f.camel@ibm.com> <CA+2bHPaxwf5iVo5N9HgOeCQtVTL8+LrHN_=K3EB-z+jujdGbuQ@mail.gmail.com>
 <87994d8c04ecb211005c0ad63f63e750b41070bd.camel@ibm.com>
In-Reply-To: <87994d8c04ecb211005c0ad63f63e750b41070bd.camel@ibm.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Fri, 19 Dec 2025 18:57:36 -0500
X-Gm-Features: AQt7F2pX1AEqWsLpHfP7izf2vX1wqWKkYGVE75LfO8EsP1EnvxMqAPnEDWiZuXE
Message-ID: <CA+2bHPZjUqwPfGiCMLkktszx+E2iatE80O0FHk4pr=K08GJH8g@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix kernel crash in ceph_open()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "slava@dubeyko.com" <slava@dubeyko.com>, 
	Kotresh Hiremath Ravishankar <khiremat@redhat.com>, Alex Markuze <amarkuze@redhat.com>, 
	"idryomov@gmail.com" <idryomov@gmail.com>, Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 3:39=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Thu, 2025-12-18 at 20:11 -0500, Patrick Donnelly wrote:
> > On Thu, Dec 18, 2025 at 2:02=E2=80=AFPM Viacheslav Dubeyko
> > <Slava.Dubeyko@ibm.com> wrote:
> > >
> > > On Wed, 2025-12-17 at 22:50 -0500, Patrick Donnelly wrote:
> > > > On Wed, Dec 17, 2025 at 3:44=E2=80=AFPM Viacheslav Dubeyko
> > > > <Slava.Dubeyko@ibm.com> wrote:
> > > > >
> > > > > On Wed, 2025-12-17 at 15:36 -0500, Patrick Donnelly wrote:
> > > > > > Hi Slava,
> > > > > >
> > > > > > A few things:
> > > > > >
> > > > > > * CEPH_NAMESPACE_WIDCARD -> CEPH_NAMESPACE_WILDCARD ?
> > > > >
> > > > > Yeah, sure :) My bad.
> > > > >
> > > > > > * The comment "name for "old" CephFS file systems," appears twi=
ce.
> > > > > > Probably only necessary in the header.
> > > > >
> > > > > Makes sense.
> > > > >
> > > > > > * You also need to update ceph_mds_auth_match to call
> > > > > > namespace_equals.
> > > > > >
> > > > >
> > > > > Do you mean this code [1]?
> > > >
> > > > Yes, that's it.
> > > >
> > > > > >  Suggest documenting (in the man page) that
> > > > > > mds_namespace mntopt can be "*" now.
> > > > > >
> > > > >
> > > > > Agreed. Which man page do you mean? Because 'man mount' contains =
no info about
> > > > > Ceph. And it is my worry that we have nothing there. We should do=
 something
> > > > > about it. Do I miss something here?
> > > >
> > > > https://github.com/ceph/ceph/blob/2e87714b94a9e16c764ef6f97de50aecf=
1b0c41e/doc/man/8/mount.ceph.rst
> > > >
> > > > ^ that file. (There may be others but I think that's the main one
> > > > users look at.)
> > >
> > > So, should we consider to add CephFS mount options' details into
> > > man page for generic mount command?
> >
> > For the generic mount command? No, only in mount.ceph(8).
> >
>
> I meant that, currently, we have no information about CephFS mount option=
s in
> man page for generic mount command. From my point of view, it makes sense=
 to
> have some explanation of CephFS mount options there. So, I see the point =
to send
> a patch for adding the explanation of CephFS mount options into man page =
of
> generic mount command. As a result, we will have brief information in man=
 page
> for generic mount command and detailed explanation in mount.ceph(8). How =
do you
> feel about it?

I didn't realize that the mount(8) manpage had FS specific options.
That would be good to add, certainly. I would also recommend pointing
out in that same man page that mount.ceph has some user-friendly
helpers (like pulling information out of the ceph.conf) so we
recommend using it routinely.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


