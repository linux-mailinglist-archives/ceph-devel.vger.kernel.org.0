Return-Path: <ceph-devel+bounces-3679-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54F13B82E65
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 06:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D6EB1C06C54
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 04:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A9BE274B46;
	Thu, 18 Sep 2025 04:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="PNBi5cJd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0023B2727EE
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 04:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758170612; cv=none; b=a3H2kYEZdb4dJgG5VJmZ2sn9/MlcBVXZifqmaFYvH4mPZuh6Cy3MFlloq27EobDVR1iYQ6+PjsfRIMbJCshgkv0p5PnwfkC63cntmLt7nlXbBz/Hu2+pLGUKeBJWphwl5goVXFhcj+43aq8M0yUXN6Wsl/pt+AEOCQCJ5+DtGww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758170612; c=relaxed/simple;
	bh=bvQKqbZUHSmC9Cgyqlv2yW20y6m1kbKZ+PzcmlxuJdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TTlhG/4RNaQ2gdFD8Ss611UMbMmVtAmDEn0D6V08ccgD26YU/cmcJcZpHtCUfNPvd2AMeASu8KpRa8ihcrZ97nyMM/Z8mQgJvXKaLf1pzzZ+D8Exqt2LofBL6f9M7Eu81pB5G6o17hTx0myDQzspE9JZ1zvMfdjWP0L5krK/ERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=PNBi5cJd; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b0473327e70so88209766b.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 21:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758170607; x=1758775407; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FF2mZRwJKtzsGK7DJVHcrnEuIs9i65jp/kWrZEcj7/k=;
        b=PNBi5cJdKb61AR69OvOnVOEoyrnSW+Jt3k9rfHifyaHDfqLk3ptS1BvpdF7s9Awy9F
         LYiAS9VDemdh4t0hw+LfbNvUgY2qs8iqsBlZOBQg1UvMHpeFuldby4a9vhaWZpii0PQh
         2F+hg/AVVZ53AiT+o+/XelJr35ZQECe/OM0sxGaXVxiVzGdn9QYzqhefC6pmCGEB8dXF
         KjpJr0Xz5SPKJMMVrqVGdfZ+4yFgyPdDLNP0RQXdi6oJumbGczqIEM2WgZfN148p0Xpk
         GLpu5lYnraC+JB4opqDja1lDF97artNDYpERNrjlEvCZ5T12gn6wrHXGP+BjEJzocwlV
         ODnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758170607; x=1758775407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FF2mZRwJKtzsGK7DJVHcrnEuIs9i65jp/kWrZEcj7/k=;
        b=bf1ivkoJIjYFqNa0efyuipleG9mHgHy/FXz6xGkob27Vy0wVSVRRc21KMKYLmQsOhc
         tHCtjqtSwRrNhL+M/Hq0cngqZ4nnvXKr3lHjtz0tP7OhgeRD3Hd++j3O31AF7zGErss2
         H1Q3yqKAU9AZBL4fapJREbSpo/b6AdJeAKPt8k+mZojHe891JS4x01vn7XNLacS/Gsh+
         yygQkVkylxaaPhq3WhhUl33O21a+EHMpueXTalmPQo6sVgFEMSpi+tMb4pHO8FfgPnJa
         9p8mrTQKd/PayLLNFfRghQkV89CNBhM0bYUTa7C7Aq3qd9p1T8RqPo7bzomuS40rxWGq
         KU/g==
X-Forwarded-Encrypted: i=1; AJvYcCXklgTUDAK+Nw8oQdR6a3ihXjtw6WG+iY956FZR0q+TZFfwtOWU8sJ/1BE6Tgf3Rg+pdt5quP59zA6h@vger.kernel.org
X-Gm-Message-State: AOJu0YydGBfp3Ad1c1xkS8GiZWwErXVIf61Q0l4ATtaIjjRv2ef3lu5B
	5ErQbArXVTJiKM8XCAIUeoKmZ31NXkQczW9zcrxAfsPH55uoUZCUhaqohS6exPj7PkTiVJEdDBp
	dSxcep0EcuA1lz26oAKuOAAn7mwc6s3PtZchcIWlNag==
X-Gm-Gg: ASbGncuqkjb2ONFNXiTVgLZZdEfsEUbn4Q6mbI2Htg8YmY2tTZrY3SOGCL0XrIKtMJF
	38DrfWjtrhK7HsQred5NIyjHrejya78v3PIy2dfrYKax7OGGOo2AqjrU6RLSnVLkDeLbPQ2FY67
	QU2YiVDMjKBqYbu+xcl/1nxUEFGNbqHFBbQ9cyCxl6zqZqY5xhLVlrnKOuhYImwaDjKRvzqgCLm
	vJRpJUaoioaFn6eAJnxw+vHY0lyw1kKN9igp/arPyNDaWj36bRvhCI=
X-Google-Smtp-Source: AGHT+IFdanVNfWfNv8HWsgTltRUqGbgVYdYb/7YWgH/k9KVu04DfDvwoBsaR56HasWl+Vm1bcuV82HMzZ0TGHEI2ctM=
X-Received: by 2002:a17:906:4fca:b0:ae3:8c9b:bd61 with SMTP id
 a640c23a62f3a-b1bb17c9028mr565217566b.12.1758170607385; Wed, 17 Sep 2025
 21:43:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917124404.2207918-1-max.kellermann@ionos.com> <aMs7WYubsgGrcSXB@dread.disaster.area>
In-Reply-To: <aMs7WYubsgGrcSXB@dread.disaster.area>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 18 Sep 2025 06:43:15 +0200
X-Gm-Features: AS18NWC_NdTi_yqxzEjcc4DGgSbWqBjqdGn8xuCbd_fnQdBXhfAk81_WXjHssKE
Message-ID: <CAKPOu+9io3n=PzwFPPgmGSE0moe3KDbyp7MXmwx=xU=Hsvqrvw@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Dave Chinner <david@fromorbit.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, amarkuze@redhat.com, 
	ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Mateusz Guzik <mjguzik@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 12:51=E2=80=AFAM Dave Chinner <david@fromorbit.com>=
 wrote:
> - wait for Josef to finish his inode refcount rework patchset that
>   gets rid of this whole "writeback doesn't hold an inode reference"
>   problem that is the root cause of this the deadlock.

No, it is necessary to have a minimal fix that is eligible for stable backp=
orts.

Of course, my patch is a kludge; this problem is much larger and a
general, global solution should be preferred. But my patch is minimal,
easy to understand, doesn't add overhead and piggybacks on an existing
Ceph feature (per-inode work) that is considered mature and stable.
It can be backported easily to 6.12 and 6.6 (with minor conflicts due
to renamed netfs functions in adjacent lines).

