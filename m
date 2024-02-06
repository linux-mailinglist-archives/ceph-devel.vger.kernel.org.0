Return-Path: <ceph-devel+bounces-829-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D14784B0F8
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 10:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBFAC285FA2
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Feb 2024 09:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C50612D74D;
	Tue,  6 Feb 2024 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="awzZiwNW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F4612D15B
	for <ceph-devel@vger.kernel.org>; Tue,  6 Feb 2024 09:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707211286; cv=none; b=W+ljGfDaQuS+IzBUGkvzzS7kiKS/lEkADhClPuTZOG1ocNC0V6nT4q0FGf9tcIgfEjAGp0HiKcoB7d67ljPMXybftc5coyArDDz6ZyS2ks/cK4C944us5xW7n472F8QrkEkRSEqr2OIKLvm2Xp7mEh5WkorbWesNvWtjORZ+RqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707211286; c=relaxed/simple;
	bh=HjKXMPYrm2ud/m+KySITGS3V3mfDiWP8ob4wyjcEJRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YRiZbf/04rj0bb9imJKkGgs00ivCIp2stD9jZuqFJ+cL8C9wJHCUKGIqjKaGOV2IX+k2xd+V28zYnY5tMfW+QjXA/HfzNu1unSZT2XIex4JuFv/mDNyWO/S1n1iX/Ca8McMD4g+4sAYyohNHLqJjIWg3ba2M1fIqI9c2KOHnOLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=awzZiwNW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707211282;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qxgmi5nVmHBLiLOEX7KdonYAIEXEAm68ZuGhjyZ6ofI=;
	b=awzZiwNWrFlX3Dk7YJv1z7qNUNdu1z5+PtM5G9+UVkp6KIZKa84RB8CKEu8MFsLHaPunPP
	V9hcMELuh1/GVab/im8zOwZW7wOeHumrCR91+UuYEf5C3pEfnO1qLPZEsS7wIDrlvmJIcS
	p5H+awATFP2Yle8syzl+m9dVuQ0cmvI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-_ebC24fWOK64sHMaSFhotw-1; Tue, 06 Feb 2024 04:21:21 -0500
X-MC-Unique: _ebC24fWOK64sHMaSFhotw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a336006ef27so43592466b.0
        for <ceph-devel@vger.kernel.org>; Tue, 06 Feb 2024 01:21:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707211280; x=1707816080;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qxgmi5nVmHBLiLOEX7KdonYAIEXEAm68ZuGhjyZ6ofI=;
        b=JZlHfiJekRSQaAzeLha6Razl0QGUufA/dsSPsMWoqTl1IR7iryzqNlGNDLdR5QUpV9
         /Wxragai/Z5hXICg7EP2R7Z9nL9Fwv0V9qIYlMcLeOLZ4WzG+Y48OzrsUHYh0bn7bfGf
         WPSIKrWtPyGyo7HvVD5Y50FqsqbTSQhcZO2rSf0jlGLZ7rrl1BIVEUc+J4huKy0hVCAP
         Ek6Bg5tcLLxFsrKP/x8lzjZCk1qAeQs3MUj2VgfBkIGF1X+odAmLX+u37mYAX3DjykCj
         NkOBfYTPN0mfvK8ae9qku++F57yOw2S2bHkrvE2nP77scgUrxGkJaPpR5Mf5Qf7CKSHb
         3xCg==
X-Gm-Message-State: AOJu0YxhfpbkhJyUp+IfGh0gRMqKDXKgDSx16exVsinLpvsRBd19JuMt
	hmHGoDjANvQamuFewtbMtMt+nBp3tndA2930u4lu3IfGxzQ2fK5wqfUL0scHgXkrojQT34NVuN7
	vN3CgQYL/e2C4lKoXQJvgyn+Tkij6/fIhWgd5R11og2fhnYTcHugr2yrAVtKEBPsWmjfrECJxBA
	Y/2/LQpnL4IOmn8aDb4+HTBnjb6/bTSapbfw==
X-Received: by 2002:a17:906:3d29:b0:a38:187c:2a9f with SMTP id l9-20020a1709063d2900b00a38187c2a9fmr1008619ejf.36.1707211280352;
        Tue, 06 Feb 2024 01:21:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFbA/y2PN4qW6S/2T+4g/YaWCYqzpXFF6OrLC4H2MGsAQBOwEKoKQKRvUkCgl3Vcd3x342HcyRgy1SFTFvoWPk=
X-Received: by 2002:a17:906:3d29:b0:a38:187c:2a9f with SMTP id
 l9-20020a1709063d2900b00a38187c2a9fmr1008607ejf.36.1707211280064; Tue, 06 Feb
 2024 01:21:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205011439.84238-1-xiubli@redhat.com>
In-Reply-To: <20231205011439.84238-1-xiubli@redhat.com>
From: Venky Shankar <vshankar@redhat.com>
Date: Tue, 6 Feb 2024 14:50:43 +0530
Message-ID: <CACPzV1n1eR0ZSBfhJ9eC5PW1+55GSr7omuwEmXic-YX5AE1+mw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] ceph: check the cephx mds auth access in client side
To: xiubli@redhat.com
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, jlayton@kernel.org, 
	mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 6:47=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The code are refered to the userspace libcephfs:
> https://github.com/ceph/ceph/pull/48027.
>
>
> V3:
> - Fix https://tracker.ceph.com/issues/63141.
>
> V2:
> - Fix memleak for built 'path'.
>
>
> Xiubo Li (6):
>   ceph: save the cap_auths in client when session being opened
>   ceph: add ceph_mds_check_access() helper support
>   ceph: check the cephx mds auth access for setattr
>   ceph: check the cephx mds auth access for open
>   ceph: check the cephx mds auth access for async dirop
>   ceph: add CEPHFS_FEATURE_MDS_AUTH_CAPS_CHECK feature bit
>
>  fs/ceph/dir.c        |  28 +++++
>  fs/ceph/file.c       |  61 +++++++++-
>  fs/ceph/inode.c      |  46 ++++++--
>  fs/ceph/mds_client.c | 265 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/ceph/mds_client.h |  28 ++++-
>  5 files changed, 415 insertions(+), 13 deletions(-)
>
> --
> 2.41.0
>

Tested-by: Venky Shankar <vshankar@redhat.com>

--=20
Cheers,
Venky


