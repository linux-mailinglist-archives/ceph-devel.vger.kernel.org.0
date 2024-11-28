Return-Path: <ceph-devel+bounces-2213-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A859DB85A
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 14:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70F15B21545
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Nov 2024 13:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4636F1A0BFE;
	Thu, 28 Nov 2024 13:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WfukNIsV"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9DC1A0AF7
	for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 13:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732799527; cv=none; b=SJKY1kMpuH9EEfiNKON72GhCmDAl0ny7+mO/94HWPTEcQ925oK9h8gcoxOJfJgSsburgbFi7Kl9wPfe5+Ayho/E6Mc/aGQNvvscUOfR3CzZm+7ZbE1d5ktfEpXqQoWBaNzlE3D33pzkIN9QH9b/i51eXUxvOmghNGL1q5pIVHLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732799527; c=relaxed/simple;
	bh=RSVSJUlGidziblJUxiTLtOwxA2rGIZxQe7Q2HII3bj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZnxDa522p0DcMKVkY8Gi8GvUV4QkpHssb4mKIoOMQ3IjHB3bcCUBlaCpRM5mbjtOf2TC+d1tO9NrfnADo3y6uPYLRGAOiMzT0iBKNtv4xx1Xqd//Vdnv8jm/d2AGHsYUlaLKWYYeDBQUqvJBebZqSGQpbcwaa9PqbsJqlJkomv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WfukNIsV; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aa549f2f9d2so90661866b.3
        for <ceph-devel@vger.kernel.org>; Thu, 28 Nov 2024 05:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732799523; x=1733404323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RSVSJUlGidziblJUxiTLtOwxA2rGIZxQe7Q2HII3bj8=;
        b=WfukNIsV9w1A3v+mw5nsNNGLg3DrszqV88B17Wa1xUW8EJiUhdVcU//VgGFMj/Jz96
         GF9O2csXZs8Z2kb0JguNrMWiDGhi9wq0dfqxFDDypRsLqium2sIuL86GQ6tiNkroAaYp
         RW1XBGvs56c2Kld6Yrp01H6QCV+pZWsA2oMr4M6XWYkagFtgEXa2bv6FPW8yv8AynsCo
         iYjDaz+qB68GVq7j/Gma7sun0obGNEv7dWWoemReGeySGsabntUoetUZqWgmApVVZzHq
         n8RA0fYpfksyd3AtwwNgzhap4X45hzocTuCln6s7n5s6EPpcml9aV84MnA9lCXFTKVM9
         O0KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732799523; x=1733404323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RSVSJUlGidziblJUxiTLtOwxA2rGIZxQe7Q2HII3bj8=;
        b=dhPXHQxvUzH0IB+Q8oCq72dTcpGQHYrtmAeCJ0VKFY1VW6pAUIjikEMothGrmGo25C
         8y7+nguCce/8egb5FQ6QLNFgp3fEn1xSWQ0Pe2R3p9CgeWy+Hz6Shidsfla4wQwf2Vud
         VXsTVNCAnCXpdWxWmXgIArCfbr1Bc2AkVfh/NYYQ6BAKbFIQWyztRoJxKYdoJNBugsJ5
         sKrVv42bzj9LDgrkOTqODP5hsuKSTic66LypuWKGsTjatLAnVVmpmW5E2SeWfwOol9Nf
         6H1/WsL/BSFGvPFzbqLy2BghFy0wI54XKVLBeu5Y5uMErP+S0HByFYRpNntsFDrYtcvu
         8ZhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPf3gBed0aUbSDj17A4a6tyFQdw/QBDOrpV4pm1DfYweCdnlnmDrR5Jg0B1Qs9lL3cS0WV0l8l5tl7@vger.kernel.org
X-Gm-Message-State: AOJu0YxcCXXt+vfGDgX3dShwfIw2jbky11yg3DbsGezTQ1RS02hlBcel
	//urJqE+asbIJdnFOUifRVsdWNNXeUhq18wvBj7nbayKDmwjKmA0gz1D4X/0RZezD/3I3hqSK0D
	pAzxB4T+lALFZ8Tjx9KSBB9HIdCN8FVMOe1G+nSvpAyZZ37Z8EQs=
X-Gm-Gg: ASbGnct7VAYL2YH0s86+qGy+Mtezlr+/68cFykSRl5yMpGGH2lo/MAXLxgEzk2xoXLP
	qR4I8tn2YLL3ZVCJHJ+CFsN20p8PNbW7Xd9j0GyRQV0utpPwauX73g0g/JjQs
X-Google-Smtp-Source: AGHT+IG1z9xD1ww7s3NzrjYICCANEgPUfErUCJ+27Ulo0O2S8YfixqzsbTMswQj+hKgVIkE2rjhXF92c63MiUh+CN0g=
X-Received: by 2002:a17:906:1db2:b0:aa5:459e:2db with SMTP id
 a640c23a62f3a-aa581062652mr505113866b.53.1732799523286; Thu, 28 Nov 2024
 05:12:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com>
 <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
 <CAKPOu+-Xa37qO1oQQtmLbZ34-KHckMmOumpf9n4ewnHr6YyZoQ@mail.gmail.com>
 <CAKPOu+9H+NGa44_p4DDw3H=kWfi-zANN_wb3OtsQScjDGmecyQ@mail.gmail.com> <CAO8a2Sh6wJ++BQE_6WjK0H5ySNer8i2GqqW=BY3uAgK-6Wbj=g@mail.gmail.com>
In-Reply-To: <CAO8a2Sh6wJ++BQE_6WjK0H5ySNer8i2GqqW=BY3uAgK-6Wbj=g@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 28 Nov 2024 14:11:52 +0100
Message-ID: <CAKPOu+8H=cGbY4TgoT4bZvWwFPH7ZQ8MioMUey+nJvb0my4xUg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 1:49=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> The ergonomics and error handling on this function seem awkward. I'll
> take a closer look on how to arrange it better.

Does that mean you misunderstood page ownership, or do you still
believe my patch is wrong?
To me, "pages must not be freed manually" and "pages must be freed
manually" can't both be right at the same time.

