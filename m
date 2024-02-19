Return-Path: <ceph-devel+bounces-879-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E692485A055
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Feb 2024 10:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17A971C21234
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Feb 2024 09:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A942420B;
	Mon, 19 Feb 2024 09:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VzyDsgDb"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B1324B4A
	for <ceph-devel@vger.kernel.org>; Mon, 19 Feb 2024 09:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708336556; cv=none; b=G5YwqztT003V8ZZKmKGQsqMdMBcXLxWVe07m6pO396yHjfUNdfxmQHTMKG2T6G5sRcHgLQWhjsn0swnU74UqMnmV7zl1MeUmSH25c/3Uw9so5LHYh0g9fs8F3+iqgWRm2u8guovVkqGbTIeNSxKnJSuar1RlXqeT7DyopFgtIW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708336556; c=relaxed/simple;
	bh=+VT9vTd5iqxtfsRSeSJ6IIzTixrFbozZQ5YWFPByTd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bhB4/k/OPBgEFaSjSWd1H+m9SY2s2dWaDDIQMSBsgCbrbSIyFw3e+uX7QO8lRHR7J1pbPTKxX81IqSKFMVADtKFIcfPcSLxEsi5XauScVPCJ/aOFXerm4aAksoNZPbOYW/akmgfUSEtPNJbx8mhRG/mGG6WqC/sd1OR/jlZFSLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VzyDsgDb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708336553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcTM68psDVSURPY45lnJBRzSryvNwrFhrHpm+5fbGdo=;
	b=VzyDsgDbCXNVgk42aX3YxId310AdKLzxdhV7CPzxWofyzScYy8s++GWCgzySfCC1W6lk8K
	luB0FA9/fITf//ig425zyR4Xrv0GCsdwifEsoFw3gANzpsoYtpqYErEjgs9LckLPQGcVQ1
	cWIShS0ik5ljQomh5DamSjKK4sp7994=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-SfwVRtpyMxOtaI5kbkcuNQ-1; Mon, 19 Feb 2024 04:55:51 -0500
X-MC-Unique: SfwVRtpyMxOtaI5kbkcuNQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a2cb0d70d6cso288972566b.2
        for <ceph-devel@vger.kernel.org>; Mon, 19 Feb 2024 01:55:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708336550; x=1708941350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JcTM68psDVSURPY45lnJBRzSryvNwrFhrHpm+5fbGdo=;
        b=fgYdCImIW0D3U7dpJ8MSvsd5BuVZkmKAzJ9sZ42dNnZqH5D6jg1ZMxdLeGFTYcSX5Y
         pFXDNjqy3nnY1+dNed+6H4YWjIQPN74KIVebsbkaRCS5uBmB4+H6aMfIyS4qOme1kzrY
         UFvMvlsoY9VdAaSXI7E5c0fIa3lxHqIqLrcq+PdTUWKmQrzMRo0jFiLl+Lgy8zCMpnw7
         RG4IpnBlhFKfyX3B0vnpFs5VmQ2/+wS94F2LuKdFoiQ5cmv+XSQ9lfziOY93iaH3pvKQ
         gUZWq0/XYk8Yq52gGe1gyRb1ZIwX0eIkY5YaXoh3zKdVnvYmSDKOj4v6RcebKSdx6oai
         swug==
X-Gm-Message-State: AOJu0YycbgRk0FhXU3rMqvdl90PWTvoXAuh8045enTmzpxBTqz0gz7+E
	pD20ia3zCHDZzyryMVbxz6FoirOQvSwFcoBeGvEfOlV4Xr1sZ45rIdHw0ISsII7UCQEqBPISaH8
	5/m1SkdDcMhOebk03qZoiUBCfx4sC3imG/6RGX77aNZIVJJmb0b5HrDvgPz/nXUZy6Vux0cNfoZ
	THJ/agjfLmzIvRMiHYB3COVQ3Eli2hBynbUA==
X-Received: by 2002:a17:907:7684:b0:a3e:8513:f243 with SMTP id jv4-20020a170907768400b00a3e8513f243mr1706855ejc.40.1708336550532;
        Mon, 19 Feb 2024 01:55:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHErVvcggJfm+CuC0CNr9PhukfikhhSrbuQBvQeYNRWjHY3/AH6Qg1L2sl3Bjqhk/7WvefHlqg37PYHznM/lBo=
X-Received: by 2002:a17:907:7684:b0:a3e:8513:f243 with SMTP id
 jv4-20020a170907768400b00a3e8513f243mr1706849ejc.40.1708336550240; Mon, 19
 Feb 2024 01:55:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205011439.84238-1-xiubli@redhat.com> <CACPzV1n1eR0ZSBfhJ9eC5PW1+55GSr7omuwEmXic-YX5AE1+mw@mail.gmail.com>
In-Reply-To: <CACPzV1n1eR0ZSBfhJ9eC5PW1+55GSr7omuwEmXic-YX5AE1+mw@mail.gmail.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Mon, 19 Feb 2024 15:25:13 +0530
Message-ID: <CACPzV1naR_c6zz3_4WoRZvX7YLy2wmci-RDy2kE4Re=TeWHLsQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] ceph: check the cephx mds auth access in client side
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com, Rishabh Dave <ridave@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 6, 2024 at 2:50=E2=80=AFPM Venky Shankar <vshankar@redhat.com> =
wrote:
>
> On Tue, Dec 5, 2023 at 6:47=E2=80=AFAM <xiubli@redhat.com> wrote:
> >
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > The code are refered to the userspace libcephfs:
> > https://github.com/ceph/ceph/pull/48027.
> >
> >
> > V3:
> > - Fix https://tracker.ceph.com/issues/63141.
> >
> > V2:
> > - Fix memleak for built 'path'.
> >
> >
> > Xiubo Li (6):
> >   ceph: save the cap_auths in client when session being opened
> >   ceph: add ceph_mds_check_access() helper support
> >   ceph: check the cephx mds auth access for setattr
> >   ceph: check the cephx mds auth access for open
> >   ceph: check the cephx mds auth access for async dirop
> >   ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
> >
> >  fs/ceph/dir.c        |  28 +++++
> >  fs/ceph/file.c       |  61 +++++++++-
> >  fs/ceph/inode.c      |  46 ++++++--
> >  fs/ceph/mds_client.c | 265 ++++++++++++++++++++++++++++++++++++++++++-
> >  fs/ceph/mds_client.h |  28 ++++-
> >  5 files changed, 415 insertions(+), 13 deletions(-)
> >
> > --
> > 2.41.0
> >
>
> Tested-by: Venky Shankar <vshankar@redhat.com>

cc Rishabh.

Revoking this in the meantime since I suspect this changeset to be causing

        https://tracker.ceph.com/issues/64172

since it happens with the testing kernel, is auth cap related and I
guess the changes were merged in the testing branch around the time we
started seeing this failure. I haven't seen the changes closely, but I
suspect the part where the last auth cap permission is followed might
be involved - not 100% sure though. Xiubo, please have a look.

>
> --
> Cheers,
> Venky



--=20
Cheers,
Venky


