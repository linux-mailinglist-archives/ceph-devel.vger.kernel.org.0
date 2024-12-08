Return-Path: <ceph-devel+bounces-2272-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84EC99E8481
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Dec 2024 11:17:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D79B16534D
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Dec 2024 10:17:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D6113B58F;
	Sun,  8 Dec 2024 10:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XeSrbMub"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E513665A
	for <ceph-devel@vger.kernel.org>; Sun,  8 Dec 2024 10:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733653033; cv=none; b=ruzZmooBiqGLKZjJ96UxL09yF6UQiYjKdB6jaR0YAdVTLncZ5uVDyIF2TfpQoWb8ArRuiEav/GpJK/XsnmHTB+Phq+DMcgouPZBUBOgOsXp2UdFpe9HAhGzR3zxYueaZ5LRc4XQc8QacuIRTTv5gA2IDR1HHlrZ6zr7nTJmfFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733653033; c=relaxed/simple;
	bh=iSk7qBPcuDjKWe/dJvRrHB51dAqOTbdPSdfEakWI4CM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u/QoJ9TFp+sZzwERV0v5YWWt/do9OqnQXxbhlXuou+85cIHHZySPlnPnCTPhs25RZQR0UOyQbXpa8r07Dqi3YcBBdy7wbLTBC79czil95Stcf3pkrNLvi3ByAWzBxH2XcRsYXpLhW3PQ9k9i1zAGkeK7tEsF/u9aZnG3eQGT088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XeSrbMub; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733653030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSk7qBPcuDjKWe/dJvRrHB51dAqOTbdPSdfEakWI4CM=;
	b=XeSrbMub/eoZ61p1cjzJ8n3TvLn0I6PWqHpBvEB3TOGAqP0H8AHJxcU7QXPlSa2iZlUn6W
	Q84gH3cUaL918yy2kFTa2rTzR2mFezCbHNHQIYNgDT4ODzyc/7lbU8KkaiX7VuTWrrIQ1v
	Gyv53lo+veR5PzUPb1USks/KIRlsXpc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-BMr1YWgpNoao4MHqgERCiQ-1; Sun, 08 Dec 2024 05:17:09 -0500
X-MC-Unique: BMr1YWgpNoao4MHqgERCiQ-1
X-Mimecast-MFC-AGG-ID: BMr1YWgpNoao4MHqgERCiQ
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa6732a1af5so42785166b.3
        for <ceph-devel@vger.kernel.org>; Sun, 08 Dec 2024 02:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733653028; x=1734257828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iSk7qBPcuDjKWe/dJvRrHB51dAqOTbdPSdfEakWI4CM=;
        b=c0zK0RV3FhuVH9LvCexDWDpInSzZeKGGzBYmBr/8wIk2FXEHdtTS1UzOwip6zxJeMl
         Tmj4gPOOabUpIbdFmYSGAJPwoKalI30E7bpuPiMHN7e0h7kKzHD1w4n+3ENXcoKtJKRV
         KcU4Di9b8+cF3x3niEDBTMxYazpak0x4RbKHNTbtJ1Z4+72199cNTcRh+G/OW3XU85A3
         Sy3S9JggGEmAGjpbbIqHIJ+AUJrccE+LgN0NwByi4p6kp5iBZ9jCqk470iT0snitDV6B
         4RRBpKAnMewKyPbbI1C0fjhSkMSTeoX2LlE5MNjvrIMja67ovViuqjHWZHwNU97FWVdR
         bOKg==
X-Forwarded-Encrypted: i=1; AJvYcCWWTaWhwz48FPRurFeifpfhOQp9rRBmnbqD4z+hVzH+SDT86nTx4mLMN2CQJlbxg5kqx2KfbK9boVt8@vger.kernel.org
X-Gm-Message-State: AOJu0YyCpN1gyw+JXHxZPr5JWQXYofPVIwY2FmGsD1mUn43OAlVlY4tj
	WGAc2p5pu8Mq2VIPGC1MNtMV55K69xxbzwD2DGQ/VaD0M3mbKCVG9JHeAtRe3QQbnlpTJLcP2sH
	s1MkwsAydYXe5+7egheUleLH7IdZFN3S8hQ9Z0qflo+cpyOYH3nkXNR6NuLKEZHZLmYc8Dezqcs
	hN3aMSKFzAMHjv3cpZwe1c0X9kt62Uw9/oRA==
X-Gm-Gg: ASbGncvQlnuHt28RbLN10EzICtmgG63LbV8cp7zEu1re2ydczH63to50BMSLFHiFeat
	lRdqQHQRTTma5Z9u6vhU62sdCXy6flGWTxWHshHDKYS3Dpq8=
X-Received: by 2002:a17:906:18b1:b0:aa4:9ab1:1985 with SMTP id a640c23a62f3a-aa63a2c6626mr776044366b.51.1733653027977;
        Sun, 08 Dec 2024 02:17:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFamKd09koQ2FZaKjQGaKQqbUfNzFN6quC7hLeEwoA1mVdlNypn6b1pc9Ybo1wSkeUjYV+Mp+R+DMrikNj2bp4=
X-Received: by 2002:a17:906:18b1:b0:aa4:9ab1:1985 with SMTP id
 a640c23a62f3a-aa63a2c6626mr776041466b.51.1733653027380; Sun, 08 Dec 2024
 02:17:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
 <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
 <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com>
 <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com>
 <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
 <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
 <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
 <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com>
 <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com> <CAKPOu+-d=hYUYt-Xd8VpudfvMNHCSmzhSeMrGnk+YQL6WBh95w@mail.gmail.com>
In-Reply-To: <CAKPOu+-d=hYUYt-Xd8VpudfvMNHCSmzhSeMrGnk+YQL6WBh95w@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sun, 8 Dec 2024 12:16:56 +0200
Message-ID: <CAO8a2ShQHCRWBGWs4rk69Gvm-NoKHyZPKJmmsazKeY3UZHeEdw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Illya, this patch is tested and it has my review by.

On Thu, Dec 5, 2024 at 10:24=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Wed, Dec 4, 2024 at 1:51=E2=80=AFPM Alex Markuze <amarkuze@redhat.com>=
 wrote:
> > It's already in a testing branch; what branch are you working on?
>
> I found this on branch "wip-shirnk-crash":
> https://github.com/ceph/ceph-client/commit/6cdec9f931e38980eb007d9704c5a2=
4535fb5ec5
> - did you mean this branch?
>
> This is my patch; but you removed the commit message, removed the
> explanation I wrote from the code comment, left the (useless and
> confusing) log message in, and then claimed authorship for my work.
>


