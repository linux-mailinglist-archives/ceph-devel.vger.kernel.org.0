Return-Path: <ceph-devel+bounces-4197-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C560FCCD1F5
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 19:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B70ED3015D29
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 18:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB64226CF9;
	Thu, 18 Dec 2025 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MdKQL7q/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXpcpBnK"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197CC134CF
	for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766081292; cv=none; b=CwBIzb/39Y+xPpfLCJadPaHpJqUavKYOV+mvJAaXc85HX1RVCjseq0cYuWjdfDDqVfiJ4fghcXZGycy/cP4bdRdamaf8NCgDPohSGesxDLaLCaZcGAp0kqzi4EiWVyUtus9TleAwAvVjMHqfl0UiK4IC9YjZoHPuCbe94iB92l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766081292; c=relaxed/simple;
	bh=PSzADfUadqKJhAe3O64Qm7xOMc6TKJAuyOAPfF7mHok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GBkZ3j/3bqmIj2PxDzmBQGi4xgBLFnbPK12BtNCy3svlEs8bWNs00ILW9QA6Lu4dRdJvEufsBOK06k+iK9f9eu2T4Wf5jS+ldkqml8ONkraavTg/X0i//XscRtbx6xBeRpit8q/E3WjplNA5x3h0T4Ayi7cLECATeJiFUqbewdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MdKQL7q/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZXpcpBnK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766081288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n0b9LaANB5N3DHna+Xr73RjnETko0TNgOV05D5Hm/dU=;
	b=MdKQL7q/7NKCQAdRs8JauZrJVJKSMwem8yXjXpiQ3l2wKt6fw7Cs4F77GzR7EDaj1b6Yy2
	QOZtUgO6c19YXWV3zNd1GebSH11jqcGFRfwaC+PTLmJ5K54kv9OWAsixpo9BKz6m1EIVLR
	FTYZPnqQOvBbxBHtdZHK788zNcP5Us4=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-8f_QdG7xOCynuEXNymBFog-1; Thu, 18 Dec 2025 13:08:07 -0500
X-MC-Unique: 8f_QdG7xOCynuEXNymBFog-1
X-Mimecast-MFC-AGG-ID: 8f_QdG7xOCynuEXNymBFog_1766081287
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4501735f488so1104813b6e.2
        for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 10:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766081287; x=1766686087; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n0b9LaANB5N3DHna+Xr73RjnETko0TNgOV05D5Hm/dU=;
        b=ZXpcpBnKy5kixI+5belwoOFuqmSu64YFpqfNr6POvZAg/abUvmFNptZo90D52iR0mU
         6yGJAM+3mFPxssI64mIjMZZ7dwNP+F43YUNHDuCIxL6IKnwLUKKamz+E5dMCr6xrQK1g
         7UMKfSbK+w9wgA3pH2U8fCv+YXOaft0YZN97bfn5ScTSFvIG21p2cyvGbJ0+QjSfGGIE
         KtYOUUKBPtUCSC96IWxdD997C5gygorvSH/nJmKWU4SNFNvmMduA82e7L0LD52mm9dYO
         IuIC9hwscf+QaUGO8fy58/fyKC7jBKhs3R5689DgmtCscxj+pFpMyQCzZESfVoqLEM5J
         QXmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766081287; x=1766686087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n0b9LaANB5N3DHna+Xr73RjnETko0TNgOV05D5Hm/dU=;
        b=uEMxrDnizCAwiutKhZUNEzJG7xraZDxy7BsyLVcbjJdZbtfyaEsKaanRBLbGMER/It
         MznQLOJ2Kzj3vJtvUHsj0e/PhKrjumLldwiksnEItGZ67LH5T60jR04iqvIpcoyZEdwR
         zaxLZO78KRWQ9a8yMGVqqlKZ1f+mLJySQyKKeHMWPeTrBJv/ImSkIxH+N5mmXNAvV6Qn
         ZZG7O5N2Ntpl2dAxyiU92DNvyFptT691AB5mYu5dnyHnl3bE/Fid7vmdYMK31gAr3UtV
         I5xfGAzssA4/IixtIx4UtUXf/n6ncyxKhTEQsfpzQNQV0+ylZaZXuSSEVFT536xiMuxx
         ZefA==
X-Forwarded-Encrypted: i=1; AJvYcCUFL2kxjCnrTGvY/I57s/hL2qYsNEe/WtBMkd+OqbJD6zHxKsVSF+f8ILRq4ZeV3/1vFb/3iADnDHYy@vger.kernel.org
X-Gm-Message-State: AOJu0YxA5dD39BALAzcIi6PRFTHlsspFJvSCb2QKyI2zL03mDLHpkznM
	nkt4ovtWNrnvo17c96MiILWPOr58IonvLGka9d7N9xRgiWN66x7SVkaiIDHE2x0jEPjLi7MQT0D
	f3VT4uUE2fYNxUIefO52hVjLkOE5G3+muXsaUBiQDhMwSvI24oJl0wXs33EfVOw11I+g0uZNfDp
	8xcHTqz8O4Z2XN/CRVfFDcDqnvmSyFYZPNmQG33w==
X-Gm-Gg: AY/fxX5NqQMBllaB9xigZT0ZtZo9CR1GxbE+vQgkRvxhn3qL/XdL+G267gYJgmgHMjs
	Q/1WE/3Y4YADjNyX8+wIhbh6IZSP3tfzy4ADAd+8VXUeIyolU3l4+1kyEm17aTiLmHxRhii2QhN
	9aTomdf9y0nX1fz+/WG+dWK84IKLPGJ6zjh71fmQh0fFlwk2tWdZe2/jFurE3pHs6do6h1bk2ko
	4dqerDxWnzIC9JAyeOblCaqrQ==
X-Received: by 2002:a05:6808:15a4:b0:44d:a0ec:d9a5 with SMTP id 5614622812f47-457b20e7905mr259902b6e.1.1766081286842;
        Thu, 18 Dec 2025 10:08:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwI9JppUiyybyQEUKLX+rkVjgWevAPoVmFyvelhb53jqdEnlHewZ+RA30L6KCqP4+bDA2RHrutlnPZkrQfMPE=
X-Received: by 2002:a05:6808:15a4:b0:44d:a0ec:d9a5 with SMTP id
 5614622812f47-457b20e7905mr259883b6e.1.1766081286354; Thu, 18 Dec 2025
 10:08:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215215301.10433-2-slava@dubeyko.com> <CA+2bHPbtGQwxT5AcEhF--AthRTzBS2aCb0mKvM_jCu_g+GM17g@mail.gmail.com>
 <efbd55b968bdaaa89d3cf29a9e7f593aee9957e0.camel@ibm.com> <CA+2bHPYRUycP0M5m6_XJiBXPEw0SyPCKJNk8P5-9uRSdtdFw4w@mail.gmail.com>
 <CAOi1vP_y+UT8yk00gxQZ7YOfAN3kTu6e6LE1Ya87goMFLEROsw@mail.gmail.com>
In-Reply-To: <CAOi1vP_y+UT8yk00gxQZ7YOfAN3kTu6e6LE1Ya87goMFLEROsw@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Thu, 18 Dec 2025 13:07:40 -0500
X-Gm-Features: AQt7F2oKFN-fFnrYZwNCueqVIS6BNu3z2eC-gzyeZKnABhC7VtL93wcTjBbzWlE
Message-ID: <CA+2bHPYp-vcorCDEKU=3f6-H2nj5PHT=U_4=4pmO5bihiDStrA@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix kernel crash in ceph_open()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "slava@dubeyko.com" <slava@dubeyko.com>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>, 
	Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 5:31=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> w=
rote:
>
> On Thu, Dec 18, 2025 at 4:50=E2=80=AFAM Patrick Donnelly <pdonnell@redhat=
.com> wrote:
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
> Hi Patrick,
>
> Is that actually desired?  After having to take a look at the userspace
> code to suggest the path forward in the thread for the previous version
> of Slava's patch, I got the impression that "*" was just an MDSAuthCaps
> thing.  It's one of the two ways to express a match for any fs_name
> (the other is not specifying fs_name in the cap at all).

Well, '*' is not a valid name for a file system (enforced via
src/mon/MonCommands.h) so it's fairly harmless to allow. I think there
is a potential issue with "legacy fscid" (which indicates what the
default file system to mount should be according to the ceph admin).
That only really influences the ceph-fuse client I think because --
after now looking at the kernel code -- it seems the kernel just
mounts whatever it can find in the FSMap if no mds_namespace is
specified. (If it were to respect the configured legacy file system,
it should sub to "mdsmap" if no mds_namespace is specified. s.f.
src/mon/MDSMonitor.cc)

So I think there is a potential for "*" to be different from nothing.
The latter is supposed to be whatever the legacy fscid is.

Slava: I also want to point out that ceph_mdsc_handle_fsmap should
also be calling namespace_equals (it currently duplicates the old
logic).

> I don't think this kind of matching is supposed to occur when mounting.
> When fs_name is passed via ceph_select_filesystem() API or --client_fs
> option on mount it appears to be a literal comparison that happens in
> FSMapUser::get_fs_cid().

Sorry, are you mixing the kernel and C++? I'm not following.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


