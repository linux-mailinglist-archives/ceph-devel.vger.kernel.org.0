Return-Path: <ceph-devel+bounces-1578-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E1F93F430
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 13:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D3F71F20F9E
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2024 11:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC9C51422C4;
	Mon, 29 Jul 2024 11:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="e6NJG+AU"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504DD1442F2
	for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 11:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722252981; cv=none; b=OvJBn4iQOfGYYdXKom9U5IyXiucTlyxmGeYIGapduob8Xs9vN3OuTjHSbfPCgpHeaF2TWimIZ7/HeD5uyRZoKyqwPMEaxYbfCOv7Q4ImJLFN51qpC93gQVxIHk2n/6wfZzBPU1dcmBRfOCESNi9Wagzwy0VZ6q+TLIXsnUVog/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722252981; c=relaxed/simple;
	bh=9d/TuvIi2gaVki/61lDkSdIbeGequPDx+pBjCZNjcnk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rpjOTqIQc8VPmvQGSTAnzFAUI+rYLjZGQ6fXOMDq+SljJy63YAhhPT4jENmGtDgVtNiq6JDR4NxLDgDSQzubzMObpBHz1zujN+dxv8vQo0/g8drNKxx6/KK2cgEx8jcKsgU+F8dvQmKMBFY3TcBCQJ6AObYQmU4ykOPdgZZqHYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=e6NJG+AU; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a77ec5d3b0dso405684366b.0
        for <ceph-devel@vger.kernel.org>; Mon, 29 Jul 2024 04:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1722252978; x=1722857778; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KF3mlZEDxsHIPxRij6eufhwBQK9CK0HzJYTYEnEj7k=;
        b=e6NJG+AU7bvhMyO7XK7VFDXFLBSLx+wSJlNE5GeqDoKWmFcx93lSZqNzOnEcfZBsm1
         +KexIa7bISvCIVHTwIkeyPqv/qdqC+hfcJr6V/rlLZcK7SircOPysAgxaoZ4OcLjJcqv
         qjbOO6E96Cq2+JGydEodAZt54+gdbLTs7bdXhXRmlo4+4JPkEXmaBEe8mNfqsGMFQlZL
         wfJAqBrij6i63xeJnZ1x7qiloaDhWFaRYppzUTcKukS98nh7rm9cu24nqzdWq3mFJEBf
         6nV7YGcvmaWIQaN7Pf3yjLc7cejOFJcxjPcet4sx6TDMvoee2p6gAjQ/5HyP1qJUVEmz
         AvCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722252978; x=1722857778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9KF3mlZEDxsHIPxRij6eufhwBQK9CK0HzJYTYEnEj7k=;
        b=OKWCFVj9z35vYz4wxk9VMTpc9+nvL6U2hXLhCxAQgJHTyXhR/QIxkAAkPTQcY5I8ew
         wgAQmQU21msywYcqVPpc27oWr3nlXqQxmRjkU2jLwnFZ2rEXavKfTvtX2c+zZSlTLYq5
         D5R4EMbKekh3VTq/hsoc6ki2F+hcAxbCpkv0PCD9/5+1PMjUMoPVXHVR0Gm+dKnRjxf4
         iEAdtBlr2WIGZBX04acNyT55E1AJgEqszGGXDijcPj0bEsY6gSt1LkzE75VhhudBlwXX
         ODZ85D0LFS92vs6nkbLc/Eb66rlY+gza06vn63euAg0grHo3nPVoHZFF7myLOreb5VXL
         TMEA==
X-Forwarded-Encrypted: i=1; AJvYcCWPOELWjRP5anOmf/GFllaOiDmr77VRlOJFUBj6t8yuGrjzY+9PQRymLSDYySnjbxqnOCH4EbNDmNPA8edw9J1+atNd3xXOa4+vZw==
X-Gm-Message-State: AOJu0Ywmvh3bgi0c0KjGoKaSvG30XhSV8Hp7oPLZ2Gf9bGaUzbLX3boY
	1xo5dqb9B+dV1fImtLwErr7FIpGH98qsO1BQr+4Rl2zhvwqJuC7gXGeyrm7TkDONg85MWvjt0UD
	qBkBPYestR6q+k/R/srHZhXBcne3JJx16/vUc8pbhwopoISjsb+o=
X-Google-Smtp-Source: AGHT+IGKpUG8GjQyZSSGXOjOMOggSW6ZJ6EszzZi7IF1MSWLkKJ/Q8dWEZAXvw9LMoCLxfRh6TQumDR0DdnGLtVJdlI=
X-Received: by 2002:a17:907:160a:b0:a7a:8cb9:7490 with SMTP id
 a640c23a62f3a-a7d4013523dmr456527566b.47.1722252977589; Mon, 29 Jul 2024
 04:36:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+_DA8XiMAA2ApMj7Pyshve_YWknw8Hdt1=zCy9Y87R1qw@mail.gmail.com>
 <CAKPOu+8s3f8WdhyEPqfXMBrbE+j4OqzGXCUv=rTTmWzbWvr-Tg@mail.gmail.com> <CAKPOu+9xQXpYndbeCdx-sDZb1ZF3q5R-KC-ZYv_Z1nRezTn2fQ@mail.gmail.com>
In-Reply-To: <CAKPOu+9xQXpYndbeCdx-sDZb1ZF3q5R-KC-ZYv_Z1nRezTn2fQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 29 Jul 2024 13:36:05 +0200
Message-ID: <CAKPOu+8q_1rCnQndOj3KAitNY2scPQFuSS-AxeGru02nP9ZO0w@mail.gmail.com>
Subject: Re: RCU stalls and GPFs in ceph/netfs
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, netfs@lists.linux.dev, linux-kernel@vger.kernel.org, 
	ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 12:17=E2=80=AFPM Max Kellermann
<max.kellermann@ionos.com> wrote:
>  BUG: kernel NULL pointer dereference, address: 0000000000000356

This is obviously NETFS_FOLIO_COPY_TO_CACHE; this looks like it was
caused by 2ff1e97587f4 ("netfs: Replace PG_fscache by setting
folio->private and marking dirty"). That commit uses
folio_attach_private(), but fs/ceph already used
folio_attach_private() for something else.

