Return-Path: <ceph-devel+bounces-3875-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B97C09E0C
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Oct 2025 19:54:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5D6C1C81E1B
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Oct 2025 17:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 555FF2FC027;
	Sat, 25 Oct 2025 17:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1HUSyQO"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE9222156C
	for <ceph-devel@vger.kernel.org>; Sat, 25 Oct 2025 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761414856; cv=none; b=Icblqd/l9zgMaveUI/sy7YGh4NwVq8wEUAhBZmoLzF3rAV1XslMB/VuBOgUe4iTrwm8mzbOS+Ddqcyxu5KBXxtYHLEVzye+tit1kKV3HtcyRGJ95LvhwptZrGueD2MHRUVWWQrCCL15cZwo5/OAHKMcdTt36TLErDv8qKTGLhes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761414856; c=relaxed/simple;
	bh=/dCnsJxwgqeFs7PKSg+Ud/3vJjVEQ1NvMAtuR/PgdkQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rl9EE2FA1P2FQj+O+Ebz+XXCunT2RRk7LnfuoJrRwAhdL4fOyXNLlrSVdudTduIKf6y8dH9EyOt+w3VYKsDOYEWQKZMSOosShP0z3ckTTIPr6EEZPJVD4dQgLfMILcarvJVvsg2JoHWPDJhMq+EYeMQ5Whzdme7V1yWCghQPE08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1HUSyQO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761414853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dCnsJxwgqeFs7PKSg+Ud/3vJjVEQ1NvMAtuR/PgdkQ=;
	b=a1HUSyQO3OeEXPML4yQrxyZWqSEO1LoJqHzZ1SFDWzzW0DeJwHgzpqVEEc8ze1YvPMz5s2
	9hby4VJeQbzTaaB3tCtDYTc/iECcyOEsZGeqLRV55O3onaskzEjy+U+RRDLOocWyDl8pgh
	LIpxtI3B1SYL18yv6g+bInsR2xsj6BU=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-inzOW4tJNfOpiu-ZdUHXkA-1; Sat, 25 Oct 2025 13:54:11 -0400
X-MC-Unique: inzOW4tJNfOpiu-ZdUHXkA-1
X-Mimecast-MFC-AGG-ID: inzOW4tJNfOpiu-ZdUHXkA_1761414851
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-54a7e0cbb98so6663805e0c.3
        for <ceph-devel@vger.kernel.org>; Sat, 25 Oct 2025 10:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761414851; x=1762019651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/dCnsJxwgqeFs7PKSg+Ud/3vJjVEQ1NvMAtuR/PgdkQ=;
        b=L7+TVQdtagRA2EtGF4vwFMtcLDEhX5Kop6LmmGT0xFtTJc9NV5LWKOadjy+BDmYJyJ
         6B5+wDTOEaf5hgTO/Tj8GLQ+r4ugZSvwBUUDuFBMhOT4rKGgNb1Bj03mjZhJyJMWWu7Q
         XfGr/EkMMZyt4KA9aCtlDactUKGCNaTDFqyEjCANkJZgM23LOB0ombH+a0bsT30mOCM7
         b2gNWj4Ycp3S88h2wWYEFgX8hAqHmYnoS8anLS4vWQtmyVQtp1iB+uDR/p6bm+rwO6mL
         mesh1dUMACI6bJRLdwpRu1YQ5gM5sMm1/tLMdgW5T+/AiSV7YP08y/t6/F27C/pwNPY5
         lXFQ==
X-Gm-Message-State: AOJu0YwzU2BYXrUgSg50oBC7/kdh3mf+sn84RWaUyCeCkj/UMfJnAOzY
	kHltstf1P8ScBvY9KIo18phdRha7JvnVe/1MWVZUJ6VxeWsE7E1Q4HS0UaZOMesoI2E5sqSWB5s
	iK02Z/EGxGChUzIpgIxGIg3+ntFhDMxV84asJl40eF7mnwswGPhzWkhpFQ8pcecISk1FoGTxkKE
	gVV3eou/Z87dvTj1Pv8d2Pe7pfEDc1Gwb0v1unBw==
X-Gm-Gg: ASbGnctbL5jxG3llgYfDJwsOn3d5Xcg2LR4eO7Ry64JXPxh1/ZasZZjwk3Y8LzTid0Y
	Cc3NITuNvHoNopODxqh6gZHkL53sidA/CNWZr0lPOxEGiirkVHRW2SZ8/tlGY8qAnD3SmZuYdlV
	A4DnMnuiNEk6IUYoqg+WzaI23p5gLNxignsM1ZIORGPAQlg8dl7I2PS5NdIiGkMk7sof+eaqc=
X-Received: by 2002:a05:6122:3707:b0:537:3e57:6bdc with SMTP id 71dfb90a1353d-557cf0ca71amr1998844e0c.12.1761414851359;
        Sat, 25 Oct 2025 10:54:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgJOnM4bluQ6E9wHerRSTuFkaWRsBJjcnsXXzTai3J0SUYVYp4MA0v1jkm9r0t070IOxhPmLZo8Pqr0ynFtfU=
X-Received: by 2002:a05:6122:3707:b0:537:3e57:6bdc with SMTP id
 71dfb90a1353d-557cf0ca71amr1998840e0c.12.1761414851050; Sat, 25 Oct 2025
 10:54:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024084259.2359693-1-amarkuze@redhat.com> <20251024135301.0ed4b57d@gandalf.local.home>
 <CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com> <20251025105944.1a04e518@batman.local.home>
In-Reply-To: <20251025105944.1a04e518@batman.local.home>
From: Alex Markuze <amarkuze@redhat.com>
Date: Sat, 25 Oct 2025 20:54:00 +0300
X-Gm-Features: AWmQ_bn2KbQ7u7-I7QWQqLSntYdpaNFjyE6UUX-03Ig8JKgRbXdxkCbCcGhJeXw
Message-ID: <CAO8a2SgZ8gZ0VdtBAeW8wLMDxa+Eq42ppr-99tUpiu3Tpwqz5w@mail.gmail.com>
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

Please correct me if I am wrong, I was not aware that ftrace is used
by any kernel component as the default unstructured logger.
This is the point of BLog, having a low impact unstructured logger,
it's not always possible or easy to provide a debug kernel where
ftarce is both enabled and used for dumping logs.
Having an always-on binary logger facilitates better debuggability.
When anything happens, a client with BLog has the option to send a
large log file with their report.
An additional benefit is that each logging buffer is attached to the
associated tasks and the whole module has its own separate cyclical
log buffer.

On Sat, Oct 25, 2025 at 5:59=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org=
> wrote:
>
> On Sat, 25 Oct 2025 13:50:39 +0300
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > First of all, Ftrace is for debugging and development; you won't see
> > components or kernel modules run in production with ftrace enabled.
> > The main motivation is to have verbose logging that is usable for
> > production systems.
>
> That is totally untrue. Several production environments use ftrace. We
> have it enabled and used in Chromebooks and in Android. Google servers
> also have it enabled.
>
>
> > The second improvement is that the logs have a struct task hook which
> > facilitates better logging association between the kernel log and the
> > user process.
> > It's especially handy when debugging FS systems.
>
> So this is for use with debugging too?
>
> >
> > Specifically we had several bugs reported from the field that we could
> > not make progress on without additional logs.
>
> This still doesn't answer my question about not using ftrace. Heck,
> when I worked for Red Hat, we used ftrace to debug production
> environments. Did that change?
>
> -- Steve
>


