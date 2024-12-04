Return-Path: <ceph-devel+bounces-2242-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F52C9E3A5E
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 13:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45A0F280E8A
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2024 12:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10FA81B4130;
	Wed,  4 Dec 2024 12:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bXNLgNva"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406211B395B
	for <ceph-devel@vger.kernel.org>; Wed,  4 Dec 2024 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733316702; cv=none; b=ArJ+GUIMHpUvjDjlgrqFChsnukZp5H4Z0yzUfzEvYzN+qPJCCO3WLaroORb/Zz68i6LidEvIA7N+qIMhyoE3xLTqNbDtOOAWaK6c/4rL3cXSwMlm7nFCrWbDTDCm0ZAOy2Xy2xteTNP7gUJ+4hfmCD8ccEa6+ilSAlUKmfNZQVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733316702; c=relaxed/simple;
	bh=I9NCyPO4krisSUhdqeg72XRIllo/A9wyK93lujKfyPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rROzh6GJIT1+K34+4co6qWqtNh6v068kpl2/EEiII/M7loQ5DojEL35CszPEoXiDQaRreYwwEJKOBJ6mW7RG7lV3iAfRW+cU32FhpqQBMZaJuS3NhrpiPeCtSaljnU31jpyy6X4TycVyUwrmRJjzRfqgwclC2LuTVlzfLYuzU98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bXNLgNva; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733316700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9NCyPO4krisSUhdqeg72XRIllo/A9wyK93lujKfyPU=;
	b=bXNLgNvadHU22Dt4aXgAM/HcwG6hT3HhVkwvdGFER2vVmHpuFJQXY1FXuGSwRPlxabsIcd
	FvHs0WKvS9boQ9alp/r9EtqAW68NQM3GzBW6PpizRkmGTlmxG0tDNPGKiYlZOjFQaIB8oM
	7NZRohsJtqmmNA0iqlBavFoOPFfNYfo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-sF34ycfYM7mcmeJtI9zzaA-1; Wed, 04 Dec 2024 07:51:39 -0500
X-MC-Unique: sF34ycfYM7mcmeJtI9zzaA-1
X-Mimecast-MFC-AGG-ID: sF34ycfYM7mcmeJtI9zzaA
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5d035c8f3afso4319330a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 04 Dec 2024 04:51:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733316698; x=1733921498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I9NCyPO4krisSUhdqeg72XRIllo/A9wyK93lujKfyPU=;
        b=Y88ZerhXLq5+BBO2bVJQ4bwSX5cbk4KRcJNnQW7Zv2jmbJxXzVs/3ZHvieS48CpR8g
         06fNIbb5SsgzQ37g30HG6KcGrq/3z8OgK2YZIUWWZ39QM/nqXXFJodVJjJNZiNIejcfS
         3aLkL2JPTS0hGx6Q2XGsJ7s/xRtIeh/4uKGT3FXwzSikygzABa+sML4miu7e6I/ccNhD
         eM9E5EHXjQnKNHLmAUlSvRNM7FhkVVf27CXO1SaN6TDulPr6MDiwclUHy+81NMGlj3df
         Gh22+nrgGmgjZCAokx07lrOtLznx9A2O5P8S7BaqFj+OOy+dtFV4tGMkpThgplXm9JXZ
         qUpw==
X-Forwarded-Encrypted: i=1; AJvYcCV/wmzE7KgXSDmzxB9UdIbhhQaNAbYlEa0NOOI3j8mMjMcBuUL+Ap41tIMjjoaRqBr2Vw9WoH1Hc1+T@vger.kernel.org
X-Gm-Message-State: AOJu0Yza3z54xzNHs5pZ850XwifVAt50oe365yGr67QZTBB2hlU/jnjx
	k7l+G8GGGSXHQr639mjZTHmbId+HnfsX2VEGbRnEDwVgt2VsIvX/F3jl6v+HwUD3qU60y/gtf4P
	iE8ghnGC+1On5AWSwWYg6dcmU5c/8EuIAztCAhmx3B3kZfumg7IGPTYReJ7q3wgzoy6x0Xk6Mif
	dMhW9PVy+2SC7HimRTYi/zT38JMR7QxDhLuA==
X-Gm-Gg: ASbGncvD+I4mYXxTrhd4MYpo/35ensJ01V4dcPuLgX1Ao6lN0ZU2rKI965Ru6aaqzAD
	m5Un5ShceSXQaq7fpyBwx3NmyhDRv
X-Received: by 2002:a05:6402:2553:b0:5d0:e826:f0f5 with SMTP id 4fb4d7f45d1cf-5d10cb4d7f8mr6517525a12.7.1733316697967;
        Wed, 04 Dec 2024 04:51:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE20wvu66FctTl9GL0qP1II/9zpj8SnN8HlRgU9qZLjUzSG6Cef4lVTKQt72r7wwVeJdCksU1lfkJH214DU+Z0=
X-Received: by 2002:a05:6402:2553:b0:5d0:e826:f0f5 with SMTP id
 4fb4d7f45d1cf-5d10cb4d7f8mr6517499a12.7.1733316697667; Wed, 04 Dec 2024
 04:51:37 -0800 (PST)
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
 <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com> <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com>
In-Reply-To: <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 4 Dec 2024 14:51:26 +0200
Message-ID: <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It's already in a testing branch; what branch are you working on?

On Tue, Dec 3, 2024 at 2:21=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Mon, Nov 25, 2024 at 3:33=E2=80=AFPM Alex Markuze <amarkuze@redhat.com=
> wrote:
> > You and Illia agree on this point. I'll wait for replies and take your
> > original patch into the testing branch unless any concerns are raised.
>
> How long will you wait? It's been more than two weeks since I reported
> this DoS vulnerability.
>


