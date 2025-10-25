Return-Path: <ceph-devel+bounces-3873-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BB2C08F45
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Oct 2025 12:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B1BC4047A9
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Oct 2025 10:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B4962F532F;
	Sat, 25 Oct 2025 10:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAwq7C7q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FC02F5316
	for <ceph-devel@vger.kernel.org>; Sat, 25 Oct 2025 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761389455; cv=none; b=r7OZsxkkca8ElGuaeb19gWnap16sPk1ETE3kuFxq4F7wnqXvsva7VsPxa/hppWkYOrv2ki/gR31e+s6ZWBKXLM5EHgLcxTAy2PD7wrKBqWSmuSHI+BgD1/F/zNGyzCIV/x0Zi+3uUb0rK7N0yXIMrmAS+d8YvFUGml4lviuPsCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761389455; c=relaxed/simple;
	bh=POkOiJXxYyVdXoybLfPGciVsCYLxYpIyRuwaeTZ4nlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a26bghwpoL2LsFVEr+lQAdh//Qulv0LkDEEMJH+uMDo1CTJZAxXv57KZ0P3cJ4/FcAe4OFOooEpisFY/zJ8PVwiTTztCVE8DHH1L9+1tkXvSyMsprLy+ZBkG4cM6gl2eV5DzhobIox4EZ9u5fLhf/8J3mqAYlOurU04Y+qXmYlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EAwq7C7q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761389452;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=POkOiJXxYyVdXoybLfPGciVsCYLxYpIyRuwaeTZ4nlg=;
	b=EAwq7C7qAt6Si4hjyiH+tKn59yTrAoRk/hlOL8kDzBy/Q+OcSHCuj2j/YM2baunzcGk1mP
	v07Slp788osDc32N+NU7DNFQqTRwKMLhcq8l9+JwYcE/qkxbB1lEvl8p0TMEG/JD0TA/g9
	Hbp2MfpYSrXNCzXPHPlknRm3Sxi22JA=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-1mXnk7MwOQKKHsRy5YZzew-1; Sat, 25 Oct 2025 06:50:50 -0400
X-MC-Unique: 1mXnk7MwOQKKHsRy5YZzew-1
X-Mimecast-MFC-AGG-ID: 1mXnk7MwOQKKHsRy5YZzew_1761389450
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5db2a7e1bcaso7183003137.1
        for <ceph-devel@vger.kernel.org>; Sat, 25 Oct 2025 03:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761389450; x=1761994250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=POkOiJXxYyVdXoybLfPGciVsCYLxYpIyRuwaeTZ4nlg=;
        b=J1k60O8AMUIaXAnsjQ0P5gJSx/9JVlXS0h/8IrccGTfRt+nHDv3p8j9dPhwefO4OJ0
         dCVlY+81xceZGXbrPyhcMA+M+7JWggFKoW8YyGt0QIOvSkl3EJycrGqJkY0TbpcDSW7K
         4b/oFiIHEn7fqLdNmZAPSNiEFLZDQP1iEmDqT9K5tvLhtRv25LX5vGwIWx43J4qL5piG
         x8Z70MW7Wc1SHKUVL28Gm/ad7DoQfE7KmFV9iWdNMBU6njxUZMsyZAMKYk1GjezdlOuc
         7sN+SJLm103XJsH3o032eU3gNgf3VCvKzd9chmwRbovyMyGuotyjx66Co79Pp8ci5EUV
         GvoQ==
X-Gm-Message-State: AOJu0Yztek2VbM5cbBqzgISK8Qn/RQBG8PnFUiMOtf7KWZKCEtGr4x17
	jNEVi/qG1sTE9rWwQz20t6bb9SVJ/PHdSY3urheay1NKrgHm7RUJZJexIDuieAZWXwPdgam8ice
	zkgCEw1zBSTWVIGIlltPIFhiBzgyg7kpYx01jF+yHyyD5n8BPUDxKk7VUpFWK8uWFAicm9/CD31
	I4XvgmUDt73FzD/ojLrLCUaXa6cCkx8BE9NbCKAg==
X-Gm-Gg: ASbGnctbmdm4chnzS++1R97LARU5oqeRbA4eZTR37AhplzChjohvbsdxuG4rfI1u4KQ
	vwen4eWaE3yY+W71e6LJfdAq8Qy5esFTmg5oSkp47VNIH17fIwu+xwe0+TCz7tw6oclLuK3ledN
	TZQrTPfQx4URkdN+hP6ITilF0DXyqNpmjANyq8VyU0JRm26Vj+UJ//PYc5CTYarzCQktoRuoI=
X-Received: by 2002:a05:6102:32cb:b0:5d5:f6ae:3913 with SMTP id ada2fe7eead31-5db3e1ed199mr1939921137.21.1761389450367;
        Sat, 25 Oct 2025 03:50:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwsyffeJ+eI1nKhYc20dry/5VXueJq+gvTP2aaGjDy37dbuMYWFrmN6kkfCaw0QToy5vgyRxRXy6SQbOpVh7I=
X-Received: by 2002:a05:6102:32cb:b0:5d5:f6ae:3913 with SMTP id
 ada2fe7eead31-5db3e1ed199mr1939895137.21.1761389450000; Sat, 25 Oct 2025
 03:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024084259.2359693-1-amarkuze@redhat.com> <20251024135301.0ed4b57d@gandalf.local.home>
In-Reply-To: <20251024135301.0ed4b57d@gandalf.local.home>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sat, 25 Oct 2025 13:50:39 +0300
X-Gm-Features: AWmQ_bmwcw8JGGEkkE3wWPKO0fCAY3lGT5ZQ4OURnSkGm9gSZBzLJvO3Udtlllo
Message-ID: <CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph consumer
To: Steven Rostedt <rostedt@goodmis.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com, 
	idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com, kees@kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, rppt@kernel.org, 
	peterz@infradead.org, surenb@google.com, vschneid@redhat.com, 
	vincent.guittot@linaro.org, vbabka@suse.cz, xiubli@redhat.com, 
	Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

First of all, Ftrace is for debugging and development; you won't see
components or kernel modules run in production with ftrace enabled.
The main motivation is to have verbose logging that is usable for
production systems.
The second improvement is that the logs have a struct task hook which
facilitates better logging association between the kernel log and the
user process.
It's especially handy when debugging FS systems.

Specifically we had several bugs reported from the field that we could
not make progress on without additional logs.

Re: MM folks, apologies for including unrelated people, the only
change is the addition of a field in struct task.

On Fri, Oct 24, 2025 at 8:52=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Fri, 24 Oct 2025 08:42:54 +0000
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > Motivation: improve observability in production by providing subsystems=
awith
> > a logger that keeps up with their verbouse unstructured logs and aggreg=
ating
> > logs at the process context level, akin to userspace TLS.
> >
>
> I still don't understand the motivation behind this.
>
> What exactly is this doing that the current tracing infrastructure can't =
do?
>
> -- Steve
>


