Return-Path: <ceph-devel+bounces-3645-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8A7B7FBED
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 16:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 362FBB634D2
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 13:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46979332A24;
	Wed, 17 Sep 2025 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OtTJ71C2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C626C332A5E
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758116733; cv=none; b=AhIzqsZMHQfeFkoaNTJicXpyq/x/ZWz73qenFV2d94KzKgeo0r4Ht9MPWCfvsxKEheEgyC47Ah7JAwI72xC97cVykXOCnSVzSVEx5t1EzjJaAuzz4Isw/DQgrS3Ggy0ay/p9L3pEyxgykQFkBMQTMA9zLfHz5B1tyhwGBOuaC1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758116733; c=relaxed/simple;
	bh=4rCjPUqBe5hDzKQsNZsZO0Si8lwcnSgwqoA91a8w/qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ugkPCDBs0DwnPhSXfb4i8tvqKznWDnHTjNy/GPWA3Rl3km7SHy31uUoeyT2KbCSVyqV2zudfVIkRM0LEG2ajw7V1AIoZ7OcU0MJO5jUaQIUT9RfYr+wjBCSxcPl0HfGUGXCcGnoIY9R1r53yR6QeiibtJpjTKwxVO3r2+/Ro1uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OtTJ71C2; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b07883a5feeso1158434266b.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 06:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758116729; x=1758721529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4rCjPUqBe5hDzKQsNZsZO0Si8lwcnSgwqoA91a8w/qA=;
        b=OtTJ71C2+f60SZTiEhIWHBQ4o7kLP6xIlRwXDOQmyb2tfI7Ixqe3jdodyDCZ6I/pci
         VrYugBtsM39gl26uU6q8zCgyF3duHSoLIBD9gl91+nd7Px5uTUgcH93KyfqjILZ45oob
         2hyQT1b5NVbgDk8Otqi+IB+ja1semJyZPKvQsfEAC7hIng7aXqM1XAr15ts6n9oJs0l/
         gNxXp4EOLAnzzRWO/qH2GU7yPe4BIjcYQBgQAwknAMvNqZL7IxAeaJvAQQmxzrM6U+58
         Kh1khv7J8EK+n1DRN18PQrohtPa6NfRFhGUeWL6KmBB8uCPW5EUPeAG+sA/Av8BLTks9
         vfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758116729; x=1758721529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4rCjPUqBe5hDzKQsNZsZO0Si8lwcnSgwqoA91a8w/qA=;
        b=Ftlx7FobwarcM8i8hBufo0iq2yqVATYOI7qW4Ilf76PhkTeHPiIDshWrUZFlgp/POn
         aKR9UoLEpn93rYxwEfWMrxP8tjEMO2x1hYJShTa5OMDI7M8nVqLX5BDV7cRdXiZtG0mX
         rCEDlZrvOOgSX2H22ONpGv9DKJiGSX+PlRf+NbHHyVcOOPoOAK9yaCODBUbZKwBrWmBw
         /hC31tYqwEWfJLioCmtiBct6UwKmgkO6IOXBlPUKnSO2f/pE3PuZAkIaASPzJeQxoTVh
         YjO1wTM9hLgozDPlvd2eMNZlieRpzPS06uo6TIv/HWl2axYwdMPgBYfeAhRN0/sSSb7A
         2dEg==
X-Forwarded-Encrypted: i=1; AJvYcCWTSnXAmMRpxOTfW4R1igHAdPmfNQXDQN9UzZtteeu3W6M/OLgGrKpQLX/W+ksEEIaXeqWNmII4X+o7@vger.kernel.org
X-Gm-Message-State: AOJu0YyH+1H0YGV2WpDhf/hNRmf9QqYdCYUTcXtPRDq5dlJsH3ZOwkk5
	FjG2LdT4V7l8yOGV3pd4RyDZ4WujHaTpzT1ExYJHcbHw/Jmp0AYU9lCTe2S19rFBpUrzx1yrgK/
	H2YjNaQ7Mw/Dd5zzoGD2N/ehI4eGYd3k=
X-Gm-Gg: ASbGncs3y09s5jVnHkHhGzmSzHg5Eny+OY6oR9QDiZ9tzL/fIP2GKznJWPutR7DT9U3
	phQSsgQseyyxnkeoG67jmCkGp4UtKd0PSDA1t+3D8JGRgbmokQiaJzTz8VgJnXidGFx/3Cjzhws
	CGIBNgJGNC4BMdAhy2fET/XFkJwqfxZqt1QfTf2vQqPpqCuJwjenBN51GmVSjWz71lg+tj3B/9j
	u8x9IyYk5xroQ65qK45deP8Pimc+GCkNiuuR1hvhP7rcNLL2Q==
X-Google-Smtp-Source: AGHT+IHJjSAqFzQR7vsvzpBHIle/SM7pkbfcfwBMTr+P1896d+alN/SQihemXVKbkiSRCNaNWJtZu6qP46KZEuNFGWc=
X-Received: by 2002:a17:907:3c8b:b0:b04:aadd:b8d7 with SMTP id
 a640c23a62f3a-b1bb5e56d85mr276690166b.13.1758116728681; Wed, 17 Sep 2025
 06:45:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917124404.2207918-1-max.kellermann@ionos.com>
 <CAGudoHHSpP_x8MN5wS+e6Ea9UhOfF0PHii=hAx9XwFLbv2EJsg@mail.gmail.com> <CAKPOu+9nLUhtVBuMtsTP=7cUR29kY01VedUvzo=GMRez0ZX9rw@mail.gmail.com>
In-Reply-To: <CAKPOu+9nLUhtVBuMtsTP=7cUR29kY01VedUvzo=GMRez0ZX9rw@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 15:45:16 +0200
X-Gm-Features: AS18NWBMJGX1M7gmLnyGCZI8UTIw8c6hYUtKDGdB2cO4qtZ9mDWgO1MIhRf_XYA
Message-ID: <CAGudoHEhvNyQhHG516a6R+vz3b69d-5dCU=_8JpXdRdGnGsjew@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Max Kellermann <max.kellermann@ionos.com>
Cc: slava.dubeyko@ibm.com, xiubli@redhat.com, idryomov@gmail.com, 
	amarkuze@redhat.com, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 3:39=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Wed, Sep 17, 2025 at 3:14=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com>=
 wrote:
> > Does the patch convert literally all iput calls within ceph into the
> > async variant? I would be worried that mandatory deferral of literally
> > all final iputs may be a regression from perf standpoint.
>

ok, in that case i have no further commentary

> I don't think this affects performance at all. It almost never happens
> that the last reference gets dropped by somebody other than dcache
> (which only happens under memory pressure).

Well only changing the problematic consumers as opposed *everyone*
should be the end of it.

> (Forgot to reply to this part)
> No, I changed just the ones that are called from Writeback+Messenger.
>
> I don't think this affects performance at all. It almost never happens
> that the last reference gets dropped by somebody other than dcache
> (which only happens under memory pressure).
> It was very difficult to reproduce this bug:
> - "echo 2 >drop_caches" in a loop
> - a kernel patch that adds msleep() to several functions
> - another kernel patch that allows me to disconnect the Ceph server via i=
octl
> The latter was to free inode references that are held by Ceph caps.
> For this deadlock to occur, all references other than
> writeback/messenger must be gone already.
> (It did happen on our production servers, crashing all of them a few
> days ago causing a major service outage, but apparently in all these
> years we're the first ones to observe this deadlock bug.)
>

This makes sense to me.

The VFS layer is hopefully going to get significantly better assert
coverage, so I expect this kind of trouble will be reported on without
having to actually run into it. Presumably including
yet-to-be-discovered deadlocks. ;)

