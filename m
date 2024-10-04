Return-Path: <ceph-devel+bounces-1885-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 452399909EC
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 19:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 024BE283097
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Oct 2024 17:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118301D9A51;
	Fri,  4 Oct 2024 17:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fD3FiFLA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800EB1E376B;
	Fri,  4 Oct 2024 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728061576; cv=none; b=ckcoJoGunNC21DZN0LZ8GuFEUBaHQaOj+FCZ3ViXT6inw4A04sgX0D0l3Vq4y/7EZ+d+s6dsbVNBIQV+5DUrIQQci+njWnSd0nZJwetpsRPipyP23QB7/r4EWHCO/rNFjU4zvpj13RYAsCNvbrn0mEgov3O/UBJV4FXx8XivIdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728061576; c=relaxed/simple;
	bh=9HsYwzndrMM5eK3xjeOx1q9GYUptfxoE7kjLCX3szzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FQ9F5V/Fhm8FyoBQHdf34sGJ7Fg1gO04tR0Rq7JigQsCD5+2PosBuFH7MsAL7pmDrTPFw0wsp2wajrS8bb7FiUa0KKXUChTDFOoTG46uKlc2pq9dYbWHJTpaA14Vtn+/JCWKBqC0Qi6K467PYSMDOTGCLtjT582igBrD5Hywu6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fD3FiFLA; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5daa93677e1so1256906eaf.3;
        Fri, 04 Oct 2024 10:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728061573; x=1728666373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWpd/wenAT0Lbq60RUb6kZo/W2VeUIRlYq/dT+QbHuM=;
        b=fD3FiFLAQKX38HmtgN2czhh8S/qrNPUVGv4PAUt1oGKajHistJDOy+4EtB26W8Mkyh
         9R9OH3xLuz83zMnNF3s1iJO3S3KWtC+K3MzxIIXH+FP5hC8Sg1yaqlAapH4MIlOEeLHj
         PUDLQz3WOzhz2RnYQHw3KUlc9h7uHer/6CEAGmm+zuJD1nXUe2r6B4Gy0ustMybDtj2y
         NRLoAeQfUBz5vMBuE+i4/d7fMmPZJaWv5onLofqnVwysvT3qm7X4Nz3bR2evmTDQL5Kz
         UT8kRJHDCltMpRNLmBRHgFMLmg11P3uz2FKz9GYbgO45mF6P2HLJHGVEIEdSH7ELfet3
         +6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728061573; x=1728666373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWpd/wenAT0Lbq60RUb6kZo/W2VeUIRlYq/dT+QbHuM=;
        b=hewzjpCewAh7hMj2JVksTbonznIhVTgxeNs6z6W5INV8uUtx+i1ptZqG/zi+xg0rPe
         AlYmd8r00ZUmiJ2aCAn175MG3Fcb3UrA+poAqj1aYYqHFXppDzcmlLkdCqqy5csOZEmf
         PUgJDjJqPZPl0A3EaBQQ3iqY4L3cvACqWVQmEUPXC+evkm6V9335cS23DCGVaOdzHWeT
         Ufiquak0XMpJju5T0V1vUQmUmfYpIm/oSYTHt1q4ua5EwmkjYY1P4+CGWLF2D8Sr2YWQ
         GXz5h5diFVIRD94KTuCmgc57BwvtRmhmwQci78il9c6DJlkfBw1IX06+VJKkgcgW82dW
         ByUw==
X-Forwarded-Encrypted: i=1; AJvYcCURcpYU+z2E2nkKV/5LoTGiGN6iE9O0lfxqwjfl8HfpqnT40agiuv/m/fBaONPgbKfKmJVmeuxow484@vger.kernel.org, AJvYcCXbdCGPCfYWnJj2cscBolcxj8HYm/ntOFt1rBGldWZwPA9+7HiCBn18RREtFXsRvMIxChmP95S4ECW4vHjW@vger.kernel.org, AJvYcCXhiQ0ievj+shOPf9lK0cOPaO8sIvMHTrHWLsAoTp9ZZKXj30HmhhAaGptuNtkzaW3ggqJRw8xu@vger.kernel.org
X-Gm-Message-State: AOJu0YwMHqEcV5/H0uTTSyRn/RFk8XCQgRb4NzhPvcl5eJnWCdkzwfTV
	mAgXLeNC+xlXQJtgDzPYuISPTOkfZeLU4gpA17oEbmx9/MnaAprVwgX+v2UkNeaZPNNFQSK4B+x
	lszplzyF0b/Rr+g6pBU7/Vbm3ljY=
X-Google-Smtp-Source: AGHT+IHgiBBu9yfFpxkoqHDKPeQVhYNE+CvmBMgljLxeStnjl6NoyRX4gxW0/1NYVWF/0tSBf8te4xywKAUqfh8Kgng=
X-Received: by 2002:a05:6820:50d:b0:5e5:bf7f:3469 with SMTP id
 006d021491bc7-5e7cbe62bb6mr2150439eaf.0.1728061573525; Fri, 04 Oct 2024
 10:06:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241003010512.58559-1-batrick@batbytes.com> <3822914.1728056247@warthog.procyon.org.uk>
In-Reply-To: <3822914.1728056247@warthog.procyon.org.uk>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Fri, 4 Oct 2024 19:06:01 +0200
Message-ID: <CAOi1vP9p-_nUYTZLF+B=u1xGG_6SEZ8a1CS-dD8313A9S_-yJg@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix cap ref leak via netfs init_request
To: David Howells <dhowells@redhat.com>
Cc: Xiubo Li <xiubli@redhat.com>, Patrick Donnelly <batrick@batbytes.com>, 
	Jeff Layton <jlayton@kernel.org>, Patrick Donnelly <pdonnell@redhat.com>, stable@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 4, 2024 at 5:37=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Hi Ilya,
>
> Are you going to pick this up, or should I ask Christian to take it throu=
gh
> the vfs tree?

Hi David,

I picked it up yesterday.

Thanks,

                Ilya

