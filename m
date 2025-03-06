Return-Path: <ceph-devel+bounces-2869-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F14A54CAD
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 14:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3B0AC3AE91B
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 13:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 040617DA7F;
	Thu,  6 Mar 2025 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ih1qdPJg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F8E74059
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 13:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741269338; cv=none; b=WqMRq4aiQ21jM09BUdQZUE20KY1bpHc9p+nimG7ROxB68Lxc9dSJSPNhVCuWR1jj5EicAOLjfvamPcBDYegD1RysAGsCvQLBp6MAqWknPJjTKGnBke5S31Qe2R2Fh801RiXCACtga2DjVUkC6hdZ6J5NHcWDKiCkEdsinm+yco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741269338; c=relaxed/simple;
	bh=e4dIS6uRGrNz4cNFNpjtZYbdKDDxOseAZRayz8xAZGs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QZc5ds0T3ujgPz/d8yZMIQV6WnjdxYfI7TnOA9NXaA/cUHau+08ap1A6QiykOwtq1SktsVj7iUke4a9jg/nLQDXjhB5Lno0OZWBtBU534+rhqD+ViLhtgUpAflb59hkIMhMS06/C1GpFP6T311d8YHj+HATuDc72Kvc8AB6MWg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ih1qdPJg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741269335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e4dIS6uRGrNz4cNFNpjtZYbdKDDxOseAZRayz8xAZGs=;
	b=ih1qdPJgAPRIrsMu6IewAYsWA+etr5h2lppyiHSPQzQZIyiTRHWgP0mg3PEgmc4afBxNj4
	Wtaoz7tKdoFztTfr806pTorO+rUge3IiXlBGK3XEaDOr84OzVF+dRgKjrWh85RmDTjAGdI
	UpmkvDc+7+Cu9JxO4a1J5RdTbZIe2qk=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-yuadf3xDMTqOmpVoeX6Hcg-1; Thu, 06 Mar 2025 08:55:25 -0500
X-MC-Unique: yuadf3xDMTqOmpVoeX6Hcg-1
X-Mimecast-MFC-AGG-ID: yuadf3xDMTqOmpVoeX6Hcg_1741269324
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5237ee8edb1so539639e0c.2
        for <ceph-devel@vger.kernel.org>; Thu, 06 Mar 2025 05:55:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741269324; x=1741874124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4dIS6uRGrNz4cNFNpjtZYbdKDDxOseAZRayz8xAZGs=;
        b=UaF0JUTsYeiDcm8wb3B8Bn2xeXl/9ffgzXIN621lNziicDAuY/at5df0AAqgypcsUf
         PLWK90y5eUXgLwNLI1EfUL9VB/tlTO7uXMP87SdCKZOQtsmWtZKT+/3g5xzcNaqgHgRC
         YP/iSj9jo75CmCtgrS1bO3HQQHeeK5emDvcxuTjFu6XR1v+1McWmyO6mtM67Ch1iaAmm
         nFW/TmacVr0ZQyRLXKdH5zZhQt9RxkwMhTETXSTp0o6L9/Xf7nJGWy/p6RNOfK7ASttU
         NQ4pA5Bl13UarOc5vWg4J8VVGWu5Q2dZ19qI4uJgca62BgrN9FmyTbGexFRVJo+hD5LF
         ohqg==
X-Forwarded-Encrypted: i=1; AJvYcCW8u+AEdknOxXK34sRY+jv4DjPiZrOf+1/9BJGuPitE24+mF8xKvgY+b13T/u8/c+lB6FklaHnicJbR@vger.kernel.org
X-Gm-Message-State: AOJu0YxxlYc+wu9emVATkPOm5tfOhJoFbJSQ/wtUGK5AKIMtb64o7cbg
	TcjFyVM4sPDCiUglVQkbwZVhLkQRd6o9zz8O2g4ZVlmO9kccoUdFclmdrbd5QkL/rZVUQxcpHf5
	cS7aGEY5P6NdiojNY6FV833Ddl6daGX6KDFgtv6EVtcY/hhgeUJTTAbGaqhXXNRglLzvPJ+eTQG
	rmzkoD/GA3hML7CoQ2EnSOlL3M3XwfkcGwUA==
X-Gm-Gg: ASbGnctxzuEzF2RVepRWfZt2tS4WmqrnUuRZ1viglQi6musDwQZ0BNCButB9s50o5Ou
	lCZ5Y5qDbZpNPR8ks/eoeNcYKcW/tpvar1/CVaz04PuBo3/CEhV3Brdg95eM2aHyMwBYmcoSD
X-Received: by 2002:a05:6122:311d:b0:520:8a22:8ea5 with SMTP id 71dfb90a1353d-523c62d0b59mr4131937e0c.11.1741269324520;
        Thu, 06 Mar 2025 05:55:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFTTtFaQhbGWpFrtu91D+m0udH4MOo8rOp9CuZE6mF/YlW49JAX1pbPGdZ/JS2Fbm94bLdqsM0Q1gDbgqI9T6Q=
X-Received: by 2002:a05:6122:311d:b0:520:8a22:8ea5 with SMTP id
 71dfb90a1353d-523c62d0b59mr4131927e0c.11.1741269324263; Thu, 06 Mar 2025
 05:55:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
 <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com>
 <4177847.1741206158@warthog.procyon.org.uk> <CAO8a2SjC7EVW5VWCwVHMepXfYFtv9EqQhOuqDSLt9iuYzj7qEg@mail.gmail.com>
 <127230.1741268910@warthog.procyon.org.uk>
In-Reply-To: <127230.1741268910@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 6 Mar 2025 15:55:13 +0200
X-Gm-Features: AQ5f1JpnxGdeKrhKSz9blMqZa5LrOlpVW18iGxm4IojQwEugdRw4hShfJAhqRKI
Message-ID: <CAO8a2SiCLxrLMFx94Au2X47fiTwBhW=6YZrfC8O4D5G0x+VRjQ@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Gregory Farnum <gfarnum@redhat.com>, Venky Shankar <vshankar@redhat.com>, 
	Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

That's just one example, presumably any request that is serailsed from
the network may contain this error code.
Specifically the ser/des of the messages happens in net/ceph
(libcephfs) code and fs/ceph handles the fs logic.

On Thu, Mar 6, 2025 at 3:48=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > Yes, that won't work on sparc/parsic/alpha and mips.
> > Both the Block device server and the meta data server may return a
> > code 85 to a client's request.
> > Notice in this example that the rc value is taken from the request
> > struct which in turn was serialised from the network.
> >
> > static void ceph_aio_complete_req(struct ceph_osd_request *req)
> > {
> > int rc =3D req->r_result;
>
> The term "ewww" springs to mind :-)
>
> Does that mean that EOLDSNAPC can arrive by this function?
>
> David
>


