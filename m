Return-Path: <ceph-devel+bounces-2188-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E90209D29D6
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 16:40:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65556B341DB
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 15:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0417A1D0E3C;
	Tue, 19 Nov 2024 15:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hvLaduA/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1074D1D0E33
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732029267; cv=none; b=T5a7eJPZC1dRvfAOVwGE45IINvOMnauRlBa6SY4Ko7vEkZDP0sEL/KdkdC02fjY9H6p4lzY5fx3kg35ypQ44dzxBYv6jAcb3IAFj6Jg6ciSeQ/QJLY9m0/CybpNnH/R6QfL3hZdIIOHYMjS9RXky+KCTC9pF9FGwz1rlAKFlCNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732029267; c=relaxed/simple;
	bh=if69drRBCTV4awSjdBUuTYvDa30Qxaap9FKm1O56q7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UvJRFQyGZP8A0pW9JYRQgmmWL+MhkWxTfuBigXQAE2k+p6AUgbTqRPYvD1YjhPf12lk75gYngZgiLgbdJugaLfyI52EfCW/7A7ssfo5+rEK9ISmlWJ57GR9q26lYCHPsHoCwbLh7etpZVgtHosZQlEEb+adxAXprMZRmpsGqBUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hvLaduA/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732029265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=if69drRBCTV4awSjdBUuTYvDa30Qxaap9FKm1O56q7U=;
	b=hvLaduA/YeMJRELxaKy4GA9mAPTzp3g3zZneUfI+66IBVFoo0GFzk7HjQkmfEX9CD1fb/O
	KWRj4uVVORnw+MW5kO5Wmmrmbqo42DjijLTCvFQ28z0t0m0T9vw3w0lAGxNvTVVKy0waZQ
	GadvTD/E5qaXkLi+wS3PWNCY3FsegkU=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-zqBZgpXzNXq3cFKFof_MAg-1; Tue, 19 Nov 2024 10:14:23 -0500
X-MC-Unique: zqBZgpXzNXq3cFKFof_MAg-1
X-Mimecast-MFC-AGG-ID: zqBZgpXzNXq3cFKFof_MAg
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d40cc92ff6so61568256d6.3
        for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 07:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732029263; x=1732634063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=if69drRBCTV4awSjdBUuTYvDa30Qxaap9FKm1O56q7U=;
        b=wcly0FoEt01DNl6/PauujNlstF1k8a/B4tBzp6ULNwdZ4SEfR6yXhjEwjB+LlYjfcB
         bTVsJ6D/cMTnUZtjjnzm5UGiphmNPKwWPqu51z5oPmGZByp16Jhltl0GC9rSJuLji0Pi
         CngV1Ws5pMRcUhdtgPsrnGvjyTHFQ6ra7A3I1LxDVfpZ98yE9FclK30FRhUyukRIiG7J
         tZSPkHEdny//p6gPvaARCOsi6buEl63tng/aXE9gX+IF6rZxCjdP2uog0T1vYZB6WvWC
         oJXXMVZ9gUCzUMGbK4+0OEm7A3Qv7NSPl79oQFZaBEGev3v/yR1OeIPOjm0C/Wip95u0
         8XRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpcbLPqDh4Eju2Jn8oXnZ4vGwtXwuWtOykw9XTrdS9njk9pSH2IJUJVtFf39g69cBjUGRQuTa/0MgV@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5gnA3Y8ZIGcQ6YAlT7RHzKBD6zhO3mQ5orjp3wcAo4C5MIUM0
	b4KZwFKTO9kqBidDR7ENeMXaL0M/Wj24yfQvbHQOnCHz2Twzpdbt2BsH1Y3qS+8rn6z8GsOJTTB
	wCGtJ7ZpT3P+PEm9dUdPFtaNEkTHjMWnbnk/COfdcDGv7GY5M2OYo/oK006i0CZY1m2xV8XmQiQ
	LC0QUAkll55SvdFkL3Y8NQSuUzX3wDa3NBFw==
X-Received: by 2002:a05:6214:5342:b0:6d3:f1ff:f8d6 with SMTP id 6a1803df08f44-6d3fb897fabmr211989946d6.40.1732029263245;
        Tue, 19 Nov 2024 07:14:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0SlS3oVJQi6iYOznIb2/23KkAp5532+AGyC12c5UZIJ3MNw9YvtejqtSgZStLfm5g2gA2QzoeQinXwBB7eLA=
X-Received: by 2002:a05:6214:5342:b0:6d3:f1ff:f8d6 with SMTP id
 6a1803df08f44-6d3fb897fabmr211989736d6.40.1732029263001; Tue, 19 Nov 2024
 07:14:23 -0800 (PST)
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
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com> <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
In-Reply-To: <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
From: Patrick Donnelly <pdonnell@redhat.com>
Date: Tue, 19 Nov 2024 10:13:57 -0500
Message-ID: <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, 
	Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dario@cure53.de, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 9:54=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Tue, Nov 19, 2024 at 2:58=E2=80=AFPM Patrick Donnelly <pdonnell@redhat=
.com> wrote:
> > The protocol does **not** require building the full path for most
> > operations unless it involves a snapshot.
>
> We don't use Ceph snapshots, but before today's emergency update, we
> could shoot down an arbitrary server with a single (unprivileged)
> system call using this vulnerability.
>
> I'm not sure what your point is, but this vulnerability exists, it
> works without snapshots and we think it's serious.

I'm not suggesting there isn't a bug. I'm correcting a misunderstanding.

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


