Return-Path: <ceph-devel+bounces-2320-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 72A759EC9EB
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 11:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2C43188B2BC
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2024 10:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F3B236FBE;
	Wed, 11 Dec 2024 10:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JsGXISkj"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E25B236F98
	for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 10:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733911449; cv=none; b=jWlTpE3ogNDQjZLn9hyhMmt+FC431mlz7IWj9xx6ZI29339kevueCEzp1ArBr5BNAa5oX/PLX3ZPwiwaVmH6b+vLkDES3mQFOEKluY4P5vFG56vrUdChJSIl43dWroUJ32i/XtmSdAP/9wynoDAkLgsn3UaUmk94GQ7cnb4OAFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733911449; c=relaxed/simple;
	bh=rKYrqQl4T8s2CXES0J8ZMyz+dspbXU3tZmAw41YdKcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jahwkuT1s8JgnVYaG9bCHdvX2ThyDfzEEHyRXxLFdquqQ7lPzvEJbPUMtXSp7ZwVtiPgX1mRb0D/YFJnt6k8UhEfn7hY1ohw+cfuqJIByQ9pf+zSUENIBgmYTlPHHJ2zRf/l6l8Yy4CDyk1VzNXyOuVo612VGwwc0LVupvMDkjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JsGXISkj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733911446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rKYrqQl4T8s2CXES0J8ZMyz+dspbXU3tZmAw41YdKcg=;
	b=JsGXISkjZ5WiUUo47Vnl/c5adFDomYdHzTnwTzYhbqRUMalHQRJWgHZ5YDiO/7Z+uqn6o7
	Huz2g4/26wijId4YH5yW/lKkPXmeEo9tBFPeGSokICXCqF/iidhteVDkMuPwEUwpJZJG6U
	8rlfFEaOnMTf+wU0DOZzN1udNAEu5rg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-VgB_UnViNlK69Gas9JcJ6w-1; Wed, 11 Dec 2024 05:04:04 -0500
X-MC-Unique: VgB_UnViNlK69Gas9JcJ6w-1
X-Mimecast-MFC-AGG-ID: VgB_UnViNlK69Gas9JcJ6w
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aa67fcbb549so308350266b.0
        for <ceph-devel@vger.kernel.org>; Wed, 11 Dec 2024 02:04:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733911443; x=1734516243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKYrqQl4T8s2CXES0J8ZMyz+dspbXU3tZmAw41YdKcg=;
        b=kKbN79Ft50wRZFisoMx568/fycSctD1HT9vdMCFR3lS2y+8nixQhuPwnondSsL/w4+
         uhUUnx2lU/hzYg2tSWVomQgOXbwsmKQXH4CIj8bNlnUnX6AP1P52tKPppxpaltIpjpJx
         e40YmkcCMNxzyeN4dmUDBQglCoSfOqrmYGGMPcrZvyFQBmrm262uFZjyOlUJvaMm1L4q
         YGuvPgG11gQ3vnTd4DrtqHcs/8wKoAvj9ct3nI3R6hI1q6ic2dcL5yaCwnpAhr6dlGFJ
         HuvuKSc1Usc1gFw/+0B2+1lcFEa/L60y2RYrEVAyI6Vp1BvUdBvTl1JDP2czLkR6gWus
         yWPQ==
X-Gm-Message-State: AOJu0YzCoPQ/VIYs8qhmki9eoRJPbtJpNMQHfIUhPFhVGhpBSUazZ2ec
	sIgb0x96YMkX4I35WHIaYFBkcEBOEegV0ala1SgiSHubB58vVOjGC15vjiVaGBDcjoveG6GAo6X
	Mgn/bHRo+GKYbkILKCZc/qhIn721ZpbG+BUCG8b2df4xKrdPTt5dKepetAIchciwR/XhMT3xEvw
	dxyC97ecJ1DQL9eXVGi84sz2b5eZVyTvYbtA==
X-Gm-Gg: ASbGncuW4ILyC5p/G58AxmlLhUkTzAhpbAf0AKAdnA07S/MTVg4q7qg8xbrZZPS3f7f
	CU1blAXQdmqm5CLi7ZV3/BbFNyWMkTmOo2OY=
X-Received: by 2002:a17:907:3e8b:b0:aa6:75d3:7d2d with SMTP id a640c23a62f3a-aa6b13aff69mr219126266b.40.1733911443504;
        Wed, 11 Dec 2024 02:04:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFuyQXneW3zNITc+iCyFOUZaLwr6ZZ7a5as15VxZV09VcmJYFa3g5u1NEyngKwdVMnnW2lLqT5/QIGv4iY3x5U=
X-Received: by 2002:a17:907:3e8b:b0:aa6:75d3:7d2d with SMTP id
 a640c23a62f3a-aa6b13aff69mr219123866b.40.1733911443165; Wed, 11 Dec 2024
 02:04:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209114359.1309965-1-amarkuze@redhat.com> <547b3a59c43751dfa793fef35a66f03fafea84ea.camel@ibm.com>
 <CAO8a2ShtipAxNUgrD7JkWdPG9brHjGreKnOGBQ3jYpXu+BFLpQ@mail.gmail.com> <bc3877022a3ec25c4b69752743d0ecdf40a4d5c0.camel@ibm.com>
In-Reply-To: <bc3877022a3ec25c4b69752743d0ecdf40a4d5c0.camel@ibm.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Wed, 11 Dec 2024 12:03:52 +0200
Message-ID: <CAO8a2SiivviV0HbDft71MBPQZdYyY=r87+BCUUFvX6EVgJEhdg@mail.gmail.com>
Subject: Re: [PATCH] ceph: improve error handling and short/overflow-read
 logic in __ceph_sync_read()
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, Luis Henriques <luis.henriques@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I agree this function needs work, there is a major performance issue
in there as well. One step at a time.
Meanwhile I need this patch to be acked so It can move to the main
branch, as it fixes multiple bugs seen in production.

On Tue, Dec 10, 2024 at 9:28=E2=80=AFPM Viacheslav Dubeyko
<Slava.Dubeyko@ibm.com> wrote:
>
> On Tue, 2024-12-10 at 21:12 +0200, Alex Markuze wrote:
> > The main goal of this patch is to solve erroneous read sizes and
> > overflows.
> > The convoluted 'if else' chain is a recipe for disaster. Currently,
> > exec stops immediately on first ret that indicates an error.
> > If you have additional refactoring thoughts feel free to add more
> > patches, This is mainly a bug fix, that solves both the immediate
> > overflow bug and attempts to make this code more manageable to
> > mitigate future bugs.
>
> I see your point. I simply see several cases of ret > 0 check:
>
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1150
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1158
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1163 <-
> your fix here
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1192 <-
> your fix here too
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1236
>
> And there are places to check ret for negative values:
>
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1160
> https://elixir.bootlin.com/linux/v6.12.3/source/fs/ceph/file.c#L1226
>
> These checks distributes in the function's code, it could be confusing
> and, potentially, be the source of new bugs during modifications. I
> simply have feelings that this logic somehow requires refactoring to
> improve the execution flow. But if you would like not to do it, then I
> am OK with it.
>
> Thanks,
> Slava.
>
>


