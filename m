Return-Path: <ceph-devel+bounces-2186-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65AA19D2786
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 14:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE4331F23C2B
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 13:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10EE51CDA35;
	Tue, 19 Nov 2024 13:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QFejK1C0"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3163A1CCEF7
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 13:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732024737; cv=none; b=Yevsu86/nhz6QdA7QHx9+LIkJBR12FwYWnIxqpLoFyf4+mk7MLjgPz/KRKUlJ2JeFnllQ6cAEq1UKW3NorMzKyRBhoiDZjpiLgSyXGR7h1h4Qwok+SYSZRECva9QU/GFcP24fuun59W47n73X/aeRdg0x4RLPkMEX6qN0cXBXwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732024737; c=relaxed/simple;
	bh=JRMmo+WtD8ZQ9tnK5iu3KlaQlw+IagjhyTaOOGeU6ZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X3/qwLATj//jOhTvHr991VZbkSE7Ph+Mwep1pp2JH202k1Qec5JzEkbh3WhRNTKmJYkrcmo7HE1fMaRTb2iLfr1ZPL9/2eAyHeEVymuHLXUt469X8CMTAOW91UBOEr0fzdnWHTnJ4XAQLHa5T4Cl+G1zBAVdcm5BmGsp2XqunAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QFejK1C0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732024735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LqgjF5czC77lSXqlwmOXziI5fgt/MDDIJWvfKiacIM4=;
	b=QFejK1C0KWqdCkQ1dpEwjmLUCdcKO1e5T95kgdd/OCjniGhYkDGduQN76HrdWoqnpYhFVT
	nrnYsdyKWDrXXdROZme19TbyKu31FzUoqspXMd8qiRlq1DyAKnu7H33W/JUVII10q1vfqb
	TsC2E+VfTTCHPQ81HJ/CfYRDgc3mrxU=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-ZDjq7b77M22k8rn0GStjEQ-1; Tue, 19 Nov 2024 08:58:54 -0500
X-MC-Unique: ZDjq7b77M22k8rn0GStjEQ-1
X-Mimecast-MFC-AGG-ID: ZDjq7b77M22k8rn0GStjEQ
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3e60e1775bdso4677867b6e.2
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 05:58:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732024733; x=1732629533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LqgjF5czC77lSXqlwmOXziI5fgt/MDDIJWvfKiacIM4=;
        b=TAd2X5kts7/kioy/2SMWUnipEV1yKdNkbJdEUCr4h8WmQAjua2KvkClFsHccROshNU
         0yHo3PBDzVjQ0EFBTAAfZUr9QOW37ubeAvd4pU+Lrc9yUmcZL9fn3xUADDhw0ikSnjMk
         K+xCqsfVZHgY/jCZGv5KTN8ucnjxe5KfY6f0WaSEFFz7O6AzmCXZN4feNPSrNmrVPafY
         yixKJN6unEGGh/cRYkPMGcsJnODn0x8jpRzFrVuI4CmireJmnaWLGdHVCLomSF1Vsa/E
         lH6+KXoC20SWkkHY+UAa+98PNToYuNoe1302s1aBKEUPRxr9vxpQ8k8u+65CjA/Sohz6
         o3AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkoQsAmU7bpjaR/4cBW0gMaACqXPobOk7JCpgUAJwXox2MtuMsTFYaP7o5vGg6T25GlOHdYYyXKjsq@vger.kernel.org
X-Gm-Message-State: AOJu0YwIYk1nmc/Qq3xUHLGbwnrEx/+pjRwp6x/lo+06mJO4Kd+txF7F
	wbkvscwXuyc+qMdb9kC4hU2hHTTOCbuR5w3Auirl7UHCmImUmm7Txvf58ZYSUkf0NphrSGFxAMi
	HFJXU7C5l6AHZprCT7yFjIJvnBjfirxl/ZQon6N46dOEgECYhyaZByZxcWxV5wDDjd0bjUhV5W+
	24kbVodHuretwSG3iCK4LuTTtZwfYszjByoQ==
X-Received: by 2002:a05:6808:2106:b0:3e7:acf6:e611 with SMTP id 5614622812f47-3e7bc7db1acmr13764062b6e.25.1732024733310;
        Tue, 19 Nov 2024 05:58:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVO3hakjeF20vHmqn/nW3qXqE2dxIDPQCWRIT8loTe7Ij8PL+k+df4akrF5mL359u8Mhj8Ursl1P1+38egrro=
X-Received: by 2002:a05:6808:2106:b0:3e7:acf6:e611 with SMTP id
 5614622812f47-3e7bc7db1acmr13764038b6e.25.1732024733013; Tue, 19 Nov 2024
 05:58:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org> <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
In-Reply-To: <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Tue, 19 Nov 2024 08:58:27 -0500
Message-ID: <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dario@cure53.de, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 8:02=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Tue, Nov 19, 2024 at 1:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> > -ENAMETOOLONG could be problematic there. This function is often called
> > when we have a dentry and need to build a path to it to send to the MDS
> > in a call. The system call that caused us to generate this path
> > probably doesn't involve a pathname itself, so the caller may be
> > confused by an -ENAMETOOLONG return.
>
> It is unfortunate that the Ceph-MDS protocol requires having to
> convert a file descriptor back to a path name - but do you really
> believe EIO would cause less confusion? ENAMETOOLONG is exactly what
> happens, even if it's an internal error. But there are many error
> codes that describe internal errors, so there's some prior art.

The protocol does **not** require building the full path for most
operations unless it involves a snapshot. For snapshots we have to
climb the directory tree until we find the directory with the
snapshot. e.g.:

$ tree -a foo/ foo/.snap/ foo/bar/baz/.snap/
foo/
=E2=94=94=E2=94=80=E2=94=80 bar
    =E2=94=94=E2=94=80=E2=94=80 baz
        =E2=94=94=E2=94=80=E2=94=80 file
foo/.snap/
=E2=94=94=E2=94=80=E2=94=80 1
    =E2=94=94=E2=94=80=E2=94=80 bar
        =E2=94=94=E2=94=80=E2=94=80 baz
            =E2=94=94=E2=94=80=E2=94=80 file
foo/bar/baz/.snap/
=E2=94=9C=E2=94=80=E2=94=80 _1_1099511627779
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 file
=E2=94=94=E2=94=80=E2=94=80 2
    =E2=94=94=E2=94=80=E2=94=80 file


If you read "file" via foo/.snap/1 you get:

2024-11-19T13:47:23.523+0000 7f9b3b79b640  1 --
[v2:172.21.10.4:6874/192645635,v1:172.21.10.4:6875/192645635] <=3D=3D
client.4417 172.21.10.4:0/1322260999 43506 =3D=3D=3D=3D
client_request(client.4417:121 open #0x10000000003//1/bar/baz/file
2024-11-19T13:47:23.524518+0000 caller_uid=3D1141,
caller_gid=3D1141{1000,1141,}) =3D=3D=3D=3D 199+0+0 (crc 0 0 0) 0x55acb2d55=
180
con 0x55acb2b3cc00

and for foo/bar/baz/.snap/2/

2024-11-19T13:47:56.796+0000 7f9b3b79b640  1 --
[v2:172.21.10.4:6874/192645635,v1:172.21.10.4:6875/192645635] <=3D=3D
client.4417 172.21.10.4:0/1322260999 43578 =3D=3D=3D=3D
client_request(client.4417:155 open #0x10000000005//2/file
2024-11-19T13:47:56.798370+0000 caller_uid=3D1141,
caller_gid=3D1141{1000,1141,}) =3D=3D=3D=3D 191+0+0 (crc 0 0 0) 0x55acb2d56=
000
con 0x55acb2b3cc00

(Note: the MDS protocol indicates a snapshot in the relative file path
via double forward slash.)

If you create "file":

2024-11-19T13:56:56.895+0000 7f9b34f8e640  7 mds.0.server
reply_client_request 0 ((0) Success) client_request(client.4467:7
create owner_uid=3D1141, owner_gid=3D1141 #0x10000000005/file
2024-11-19T13:56:56.890430+0000 caller_uid=3D1141,
caller_gid=3D1141{1000,1141,})

(During path lookups when planning to read the file, the client will
usually get read caps so it doesn't need to formally open the file. So
this last example uses a create.)


--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


