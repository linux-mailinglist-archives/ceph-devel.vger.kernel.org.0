Return-Path: <ceph-devel+bounces-4246-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AE7C5CF3AE7
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 14:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 27937300876D
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 13:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE9D2F84F;
	Mon,  5 Jan 2026 13:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mzzkxz5W"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E1517736
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 13:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767618122; cv=none; b=hR37pJ9cmgRaSevrGKroroZAYW24HLL8+4iE75DRzSHEq0hBFE/oaUK4qmM5NUPcMckcQNYr8Ge2fXvsc0T1RcwAPS0WzgNJp0pMbxcAaMTu/lVq83oGIuxzAzSPsvKDT43OfAeCm4Rx2PI5P108uoMFizBE9dgtAO5cVuXYmGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767618122; c=relaxed/simple;
	bh=+ST6C6fNnsgZvzYjV2/rW+xuraOFacdykI0B8YiWUog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hKNnhu0raZilM9qVhhcYWio8NVuKcyqQ1EJ5hSk84JOEuAzpJGo8xBYEDkr5CaCTJ7K11VX3p0pEDwrRvSsICMMQc5L9ka/2kQYgiocw7vVxaLfxWcvstueBQJHF7XWAm8gSICUjfGjiA74H5vkpn5QuDreLr4zJAIE69X8+wOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mzzkxz5W; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-121b251438eso2579754c88.0
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 05:02:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767618120; x=1768222920; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q38tTxcHhQYXj4Ya7jdNvxwYbmmHz0J2xNhuehz16t0=;
        b=Mzzkxz5WrUpDeSP4bVPB4xXGHB22pD0p6LTQW2pP/6rvd4IEkXp19wfyK+jbbwr4ZN
         sqLp8FMCcBeUJqK7Xnu++ayEBoN8cqqFss/yLOD8Ayrv5r2xUGvNcoJuSDB76dyqbmg7
         kj1LzjUGqcMbFe4T1KK1o6KrwBQUwrnrBlAMJbHjANxAsf8zIS2NjIVtoCgPNs4ozsfo
         pYAc9xryqu/Dt7v//ekP719ZDCQ48v/fkL6V97nZj1LkOF2tnEFoA6ZZRLCVNy3E3u9m
         beYB0Wlkw5Kl7Bo9gfbhWaQJOzmhIb2yVq+WVvgv7UXyvDk7gRlJZwJZ7kTU86IBeZti
         gw/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767618120; x=1768222920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q38tTxcHhQYXj4Ya7jdNvxwYbmmHz0J2xNhuehz16t0=;
        b=HxKNT0x1RmIR4n5u3aQpzLiFQVwxJANm6rYEhD/kr1Il9/2ghxcEqhyKgXwwtNPagz
         IMwc3F6xnZc26VeF95SU4yePYpPDxPmehidsR8NytL8gc9OusxFUTrzxtfZ6NedTSkZQ
         JxTXj9n11R1W6NN3NMuPNMnIYDNXY0tRV0Ym5wtO5MujSQQKt1sgenGJOXpJP2x9bTCs
         7ZvAVFbKc8gYD/MODaxUquxIRSZpHFf9lJIjY7jP68Jj7RucUxrFzZbDy9SFKudN/rsm
         qkaU4H/lPt7+O6zbwG8MxqHFWkIxun/2fEnNNsmx1UdG+XOBa+uE+h8NoTFbEFR1dGdy
         TS8A==
X-Forwarded-Encrypted: i=1; AJvYcCUQH2YAjHZLwplxPAsZvxF0gRsD2gSvdMAieGF7ywZdjOgcTxGfNydPpY6Vx6DonoU8CRqKS/M1VMCK@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8rF5jdgAqdVzfxNhCQ2PcB4h1CB4ulpIDQkm8eAcIAYZGM3Zk
	ejoI9SMVGs+MafVxcEckerdYTM04XM3Y7ReI1aDZ+wLfPSc5AG4cWVISPlKq/T6cUMiykmzir5B
	+9QKzTtTRPjZLyrlhiYpMBOKwyyi29o0=
X-Gm-Gg: AY/fxX6fcVP5NR9y/uE8lkkPgerQdBzweLBJ/XRW2oWUnSNAR1uHGh3CQI9yreYmhsw
	8IMLibgakQk+5J+TqDxtRwffQPQGQP2W6Ptdb9DG0s0VMm18ODqx7QSBCqWHDKZZU4jYO2v461E
	Tw7zvb1A+COCSL2g5bswVvsz0XM4u6nBjb224zkWMUWu4PEFe0QvRxdz4r1Ij51vIFzn2FgJyiB
	z8yVBpB31Aspxrv0K98i8kAmvAeh8ji+N7GJSzA7fB5/Q7MosZjgt0lmT2Q2ZH64t9VC2M=
X-Google-Smtp-Source: AGHT+IE9AE8MYZdB076F/34GlsSNi7AHzkkpVcZr1pALSKkFYKqdV+4U+xjEZk2dG67zGBuekIEBboID6P4CZKhxNx8=
X-Received: by 2002:a05:7022:f212:b0:119:e569:f874 with SMTP id
 a92af1059eb24-121d80b9761mr6392534c88.17.1767618115114; Mon, 05 Jan 2026
 05:01:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251216200005.16281-2-slava@dubeyko.com> <bff1133f-d07f-441c-aab4-d0b6b313b7ac@redhat.com>
In-Reply-To: <bff1133f-d07f-441c-aab4-d0b6b313b7ac@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Mon, 5 Jan 2026 14:01:43 +0100
X-Gm-Features: AQt7F2pwcAJGPr5wvJO_zNTT87r_TiHWO3xq3pfcgwx7ciZnItlsPnmzpzO4Rfs
Message-ID: <CAOi1vP-HvPNh_cEViZBM8NYLg+S2+6MwLrG7my9F-ap6hL9TwQ@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: rework co-maintainers list in MAINTAINERS file
To: Xiubo Li <xiubli@redhat.com>
Cc: Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, amarkuze@redhat.com, 
	Slava.Dubeyko@ibm.com, vdubeyko@redhat.com, Pavan.Rallabhandi@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2025 at 12:44=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote=
:
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thank you for all your work over the years, Xiubo!  Now applied.

                Ilya

>
> On 12/17/25 04:00, Viacheslav Dubeyko wrote:
> > From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> >
> > This patch reworks the list of co-mainteainers for
> > Ceph file system in MAINTAINERS file.
> >
> > Fixes: d74d6c0e9895 ("ceph: add bug tracking system info to MAINTAINERS=
")
> > Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> > cc: Alex Markuze <amarkuze@redhat.com>
> > cc: Ilya Dryomov <idryomov@gmail.com>
> > cc: Ceph Development <ceph-devel@vger.kernel.org>
> > ---
> >   MAINTAINERS | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5b11839cba9d..f17933667828 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5801,7 +5801,8 @@ F:      drivers/power/supply/cw2015_battery.c
> >
> >   CEPH COMMON CODE (LIBCEPH)
> >   M:  Ilya Dryomov <idryomov@gmail.com>
> > -M:   Xiubo Li <xiubli@redhat.com>
> > +M:   Alex Markuze <amarkuze@redhat.com>
> > +M:   Viacheslav Dubeyko <slava@dubeyko.com>
> >   L:  ceph-devel@vger.kernel.org
> >   S:  Supported
> >   W:  http://ceph.com/
> > @@ -5812,8 +5813,9 @@ F:      include/linux/crush/
> >   F:  net/ceph/
> >
> >   CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)
> > -M:   Xiubo Li <xiubli@redhat.com>
> >   M:  Ilya Dryomov <idryomov@gmail.com>
> > +M:   Alex Markuze <amarkuze@redhat.com>
> > +M:   Viacheslav Dubeyko <slava@dubeyko.com>
> >   L:  ceph-devel@vger.kernel.org
> >   S:  Supported
> >   W:  http://ceph.com/
>

