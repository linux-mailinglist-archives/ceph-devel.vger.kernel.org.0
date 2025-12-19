Return-Path: <ceph-devel+bounces-4203-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D2ACD0096
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 14:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5C9C930521E3
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Dec 2025 13:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F54215539A;
	Fri, 19 Dec 2025 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bhvtgp8Z";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kEqedT8M"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0773CA6F
	for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 13:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766150506; cv=none; b=Gshl08vzfyeW2g/uVkXPRpSbmSsl/H2wYP8Ux9q9vfx8RCQ/PdEtvixKa/8NGZkmkuGKIt/EkNtxF7KdS39NFdCQU3XTKXXP7glmxEw8dDnSAcBzCgM0B60LuC8RJ0JWdwcI4FnQj18z7e/piDnlTTDrLg/Do0PGlhbq9RWwMX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766150506; c=relaxed/simple;
	bh=7ahsJI6MRO1tegZUGoy6hB6POxhagpjFMaOrdaxGLQE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RqRjIZLSJNeqRTUI94gu8xqorl9EcSBg1X4pY97SSb/+BMWpSGmigwXfRYUfTzgVeDHQl1KkZJLDEIVKDpuG4cxYx/HbXXFLLOmfWQ6qh1TOZSqSCadKSpZWzOgg626n+86LxK7KE5pRk60Vxm1LrEsrmNX6+sbnzSeVtQTqiDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bhvtgp8Z; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kEqedT8M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766150502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26Yh38riG93tviD8HF8oSA3DW+KxTiyxEndrr2e2wjQ=;
	b=bhvtgp8ZQ8hvRD8j3462QD5YVffhsCJjOmxfWqLG9XvAf0hRQxr3pWFxE9Q2H3a7UuFhmZ
	d1ip43RKktku9ihthTVxKya16zoB1zCs3I2YBJlPLvwE7XoSJizysPi3md/sHYkxQw2SK9
	oBsaFUr4OGZS0yFFKHrgo4wrRAD7bzA=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-AsdYie6BP3Ckt6Vw4ydHUA-1; Fri, 19 Dec 2025 08:21:41 -0500
X-MC-Unique: AsdYie6BP3Ckt6Vw4ydHUA-1
X-Mimecast-MFC-AGG-ID: AsdYie6BP3Ckt6Vw4ydHUA_1766150501
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4512e9f2f82so2348201b6e.3
        for <ceph-devel@vger.kernel.org>; Fri, 19 Dec 2025 05:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766150501; x=1766755301; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26Yh38riG93tviD8HF8oSA3DW+KxTiyxEndrr2e2wjQ=;
        b=kEqedT8Mc3Yhcu3V4KJ3RDtcx53B/ts3UTZQlpHX/tD5fPghUAjsZ8Anw3SxKmdFT1
         9X5vUjjdzTlVhXoxo6plLZIVTpxhSadUEk4qLB1LT3xc8TJYtRRFyQLFdCRmuQWXw4l5
         n6UZ8V5nQHaTxBCo/wUUriuYFzfzk5mmScclaUFlo7dIvcRWvvOoDX0BQ1NZPW1/jchN
         8eG0C93gVuS+JLL+qTf4556HOKWHGg3chhFSehoWogjMRuVi2sc8+h/PulgZVIDKe/AH
         4QtccwKpvBPTT+E2HCvvehGsNGKojwSa6HWANZDx0FDivSJJHPmYYskgTcWZALTb3mdx
         BVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766150501; x=1766755301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=26Yh38riG93tviD8HF8oSA3DW+KxTiyxEndrr2e2wjQ=;
        b=EJw8BKY9/lIAOLztTUA46h6eSbJigmFkQEWYN4IJdRMEi5QiwQNjfPFjnutZKDs03+
         XzC5hId0k3ZvgJD5MLHk7OLFicp71BB00sBrcVwAxMTWkl7ucMhBzKJuPmzmlitdHDlM
         Gv7fKPrZebU9UeQ+4qbYAsFpwkJ13qeNbHeuVgUGzpfTeavNLTjdaJ2LDWQLoforMZFk
         N9QYHL5gIdkRB6I2vuk6LhH0mrJYEr4UfvMS5aVZLUkIGFKAIWR5csGTzURwWGJwB/Gc
         iMwz5Tce5R41yQ6k4BLJpH3zJ6pMBaRCSiCiTYDX61YbXcEcM4Ky1VvcfjphsnVVqxoc
         j43g==
X-Forwarded-Encrypted: i=1; AJvYcCU17JvxFViKMTBL0vRPELEMWzmqRqMsxvLlIWYrYDkokVLXWCjL8thciQEcFvELvHXLlnkkelGdkx48@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3vj5tyEFUV47Ai7gdRpO6g2b9NFgmBjntswjtyP3jeXls2Vxg
	F5u8bAUEFbjtdGThY6RJtYQA2pijNrjSSsMOZ0B2B3obJ4A4+50MrogATSZ1M+Zh5SdTS06NzoT
	R1nLNvzqmpxAkAgeXAy+Yyd9fJU73GM1CXvKh/k6M6ErXV8AoB/EPJMcjUb5STvVwffka9TIuf8
	V0u07H9mfKY4B3DwhhRywAk31AKphUCneSLzQoRQ==
X-Gm-Gg: AY/fxX4DksfBSHkSfbFVhD3YmvBZmf8qkGpT44Jvn253sGuacedlu0FZbMVLxddjc6j
	9PdRq2N7lU0NA2XhayIb6fnKM90GtNmAj3N/pLQWAGobKqm1Fnz8sX7eJmfZHMdeeAtLil6l/NZ
	rzicAocOLdn4xQzF+VfGN1d0ccSc25/CfdDEyOPm5NfmXjYAvEmuIlTjgNBKQxY8b3v+Cxt3Y16
	k+1oA1lUH5qsxRLrE+1YoFgAg==
X-Received: by 2002:a05:6820:2e8e:b0:65c:f7ff:142c with SMTP id 006d021491bc7-65d0e94d614mr1083287eaf.12.1766150500990;
        Fri, 19 Dec 2025 05:21:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFltrekp6oXeRiGj09Q7TV0XDPavsSt/KlgICo9u4lhXD5ysa5/HuCmtWzxscn8W2av8uMOznO8potMsT+WYyo=
X-Received: by 2002:a05:6820:2e8e:b0:65c:f7ff:142c with SMTP id
 006d021491bc7-65d0e94d614mr1083281eaf.12.1766150500618; Fri, 19 Dec 2025
 05:21:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215215301.10433-2-slava@dubeyko.com> <CA+2bHPbtGQwxT5AcEhF--AthRTzBS2aCb0mKvM_jCu_g+GM17g@mail.gmail.com>
 <efbd55b968bdaaa89d3cf29a9e7f593aee9957e0.camel@ibm.com> <CA+2bHPYRUycP0M5m6_XJiBXPEw0SyPCKJNk8P5-9uRSdtdFw4w@mail.gmail.com>
 <CAOi1vP_y+UT8yk00gxQZ7YOfAN3kTu6e6LE1Ya87goMFLEROsw@mail.gmail.com>
 <CA+2bHPYp-vcorCDEKU=3f6-H2nj5PHT=U_4=4pmO5bihiDStrA@mail.gmail.com> <CAOi1vP8o7NAmrHi96UJ8B8DxFSHCgiczDCU=r2TAVn2oi1VD8A@mail.gmail.com>
In-Reply-To: <CAOi1vP8o7NAmrHi96UJ8B8DxFSHCgiczDCU=r2TAVn2oi1VD8A@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Fri, 19 Dec 2025 08:21:13 -0500
X-Gm-Features: AQt7F2ooh7ny8Q2vervZmVtfdiY-DS6y6DhZHbFb4wPfVzgKNkgDohMc-NvSy3M
Message-ID: <CA+2bHPb41OinL5E_HXpXTGww2WWqEU3k06JfVHZ9joUQuYsBPg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix kernel crash in ceph_open()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "slava@dubeyko.com" <slava@dubeyko.com>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>, 
	Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 8:01=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Thu, Dec 18, 2025 at 7:08=E2=80=AFPM Patrick Donnelly <pdonnell@redhat=
.com> wrote:
> >
> > On Thu, Dec 18, 2025 at 5:31=E2=80=AFAM Ilya Dryomov <idryomov@gmail.co=
m> wrote:
> > >
> > > On Thu, Dec 18, 2025 at 4:50=E2=80=AFAM Patrick Donnelly <pdonnell@re=
dhat.com> wrote:
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
> > > Hi Patrick,
> > >
> > > Is that actually desired?  After having to take a look at the userspa=
ce
> > > code to suggest the path forward in the thread for the previous versi=
on
> > > of Slava's patch, I got the impression that "*" was just an MDSAuthCa=
ps
> > > thing.  It's one of the two ways to express a match for any fs_name
> > > (the other is not specifying fs_name in the cap at all).
> >
> > Well, '*' is not a valid name for a file system (enforced via
> > src/mon/MonCommands.h) so it's fairly harmless to allow. I think there
>
> By "allow", do you mean "handle specially"?  AFAIU passing "-o
> mds_namespace=3D*" on mount is already allowed in the sense that the
> value (a single "*" character) would be accepted and then matched
> literally against the names in the fsmap.  Because "*" isn't a valid
> name, such an attempt to mount is guaranteed to fail with ENOENT.

Yes, correct.

> > is a potential issue with "legacy fscid" (which indicates what the
> > default file system to mount should be according to the ceph admin).
> > That only really influences the ceph-fuse client I think because --
> > after now looking at the kernel code -- it seems the kernel just
> > mounts whatever it can find in the FSMap if no mds_namespace is
> > specified. (If it were to respect the configured legacy file system,
> > it should sub to "mdsmap" if no mds_namespace is specified. s.f.
> > src/mon/MDSMonitor.cc)
>
> In create_fs_client() the kernel asks for an unqualified mdsmap if
> no mds_namespace is specified:
>
>     if (!fsopt->mds_namespace) {
>             ceph_monc_want_map(&fsc->client->monc, CEPH_SUB_MDSMAP,
>                                0, true);
>     } else {
>             ceph_monc_want_map(&fsc->client->monc, CEPH_SUB_FSMAP,
>                                0, false);
>     }
>
> I thought a subscription for an unqualified mdsmap (i.e. a generic
> "mdsmap" instead of a specific "mdsmap.<fscid>") was how the default
> filesystem thing worked.  Does this get overridden somewhere or am
> I missing something else?

Ah, I didn't see that code. Yes, this looks right then.

> >
> > So I think there is a potential for "*" to be different from nothing.
> > The latter is supposed to be whatever the legacy fscid is.
>
> Are you stating this in the context of mounting or in the context of
> the MDS auth cap matching?

mounting.

>  In my previous message, I was trying to
> separate the case of mounting (where the name can be supplied by the
> user via mds_namespace option) from the case of ceph_mds_auth_match()
> where the name that is coming from the mdsmap is matched against the
> name in the cap.  AFAIU in userspace "*" has special meaning only in
> the latter case.

I understand what you've been saying. I contend that treating "*"
specially for mds_namespace mntopt could be useful: you can select
*any* available file system even if none of them are marked as the
legacy fscid.

Big picture I don't think this matters much. It'd probably be better
to only use namespace_equals (no "*" handling) for mntopt matching and
something else for the mds auth cap matching (yes "*" handling).

> > Slava: I also want to point out that ceph_mdsc_handle_fsmap should
> > also be calling namespace_equals (it currently duplicates the old
> > logic).
> >
> > > I don't think this kind of matching is supposed to occur when mountin=
g.
> > > When fs_name is passed via ceph_select_filesystem() API or --client_f=
s
> > > option on mount it appears to be a literal comparison that happens in
> > > FSMapUser::get_fs_cid().
> >
> > Sorry, are you mixing the kernel and C++? I'm not following.
>
> I'm trying to ensure that we don't introduce an unnecessary discrepancy
> in behavior between the kernel client and the userspace client/gateways.
> If passing "*" for fs_name is a sure way to make Client::mount() fail
> with ENOENT in userspace, the kernel client shouldn't be doing (and on
> top of that documenting) something different IMO.

I wouldn't suggest the kernel change without also updating userspace.
In any case, we can drop the suggestion.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


