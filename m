Return-Path: <ceph-devel+bounces-3640-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE4F0B7E8C1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 14:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 840B64A1FB4
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 12:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5BE31BC88;
	Wed, 17 Sep 2025 12:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="ETkHo1t5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9D631A81D
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 12:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113305; cv=none; b=rMTN0FH10uLsxu+UIL4PtP2/MY2WYaDk+ixiUL2twzvv+lSAf3b668gnwumikzMIHe9SAtr1VKap9HqyanQ0LUGOMAb66bMsXTWR9JwX5+ePUyLW5xCrlYLc8gMuN2gWeknaaFgdJqzoEICrSrdryASXDe/rPZQGMUFPCUHm/xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113305; c=relaxed/simple;
	bh=mzoJJTaUHkHZHToYowEQCZnMPpDM4R66Ou5zGDbIBXA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/VD6SJJzTMW96rVe62Mbitq9LHkEuJLgkfA4Ppl5d3S2nGspqVTnbuEI35EWxSj3ab4CM0Aros4EUdoaQvqFsn+8S1qUBM/D/ML+wDJq5G5J6i4I009JyfUVK+7lqua09x3pArzhvp7Zx624ApRsGvzB6BpKPcLqln4qih/f4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=ETkHo1t5; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b04b55d5a2cso1137618066b.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 05:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758113302; x=1758718102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzoJJTaUHkHZHToYowEQCZnMPpDM4R66Ou5zGDbIBXA=;
        b=ETkHo1t5/fH68nL00o46lcBWJ+P0Ki2i8Dg7OMeHJO7xeiNHWbhkWjnnOKKctte3o6
         054nQ1yd/BCp0Cq8Nbi3C0tH8YKyIfubSIDa9JzNlqqUfXSdFF4dXBVQjhSBMhiqVTgh
         x089w+kboEtFFzIC18olyp8s22J8J1yZ7UUoIYUOUoTY3ZUdRmOZSuSgngKae/oOOMo1
         0vj7jnDDOmVM3KL6JGyEGoATB8ShHuRgNDRARwDh2idMpVlWlr1GptF/uYONU386kt1r
         qGNbcCZquEMTJ/ZpQU98fM+1zqONG1yIuxzsFbcfba4BiIdKM4uq6wvzlbffuBMco0cK
         J8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758113302; x=1758718102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mzoJJTaUHkHZHToYowEQCZnMPpDM4R66Ou5zGDbIBXA=;
        b=Wxrr7O1pBG49Ad2xx2G7UjuRh7fFPNzcGPhEUnonbx9lpUrgRTmrlJ8/xLGfGFPUs0
         azIDgdFkr3Ob9azZHzG3JhVTJpRwDH0/6/nwrHwS5SZZMsBDmcO4AvWSj9RMXHU6d+k3
         GioN+BcV/ooyaPs4yS+opyA2ao4SmoXdCfVH8WupOTkutFifnavEax7eRlEZlv5m14rg
         1AyyanYs7z2lsqStWZw29VJM7lS7hpb5Uyy/v7hZDQhFMD/hIubo+EyUX22xiOQkKqVZ
         hVjpUf+nB3t3lH15rVDrMUfuunfD0UJwXwaBhdbQg0g4xo1xA4CUpdLQwGruwi5hUZoY
         1F3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEIeZxkCvauRaWxXn4MFbQlV68d/6+DtGYFgibI8JN3RgX6uUce0CXUydN5SPAKFGeZDsmnyMC9nil@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj++6KOeijZyNX2jmGn/yyS7GZbF5rja6TMyJjm6vvn/c8bbVv
	U4isQKDoPDy6dT5JnjjaSSXqK2X/4Mk1TNdQ7odl0JZggnck/HFn53U3/1oU7QwTZQBk1YzAfA8
	wutSa5x/B/j6c1KJbF0pHZs5ZMCxS0ahsjRI3ZHuemq0+lpGSxILR
X-Gm-Gg: ASbGncsxRe/KQ6v7vyh1HP/l570eZUNm3eLZNQRUSeaHtpINT+qtU2vsRAW93ZUe9iL
	WJuZEe7kS/IFtCq+sdiz7TrRakLrnP+3b6kd+cJ25PkfvTCPsP8mLncZ0I2KFrpd9MCFy1SgpmV
	0hDZzTErOgbw9RqpQlorLiQsOOsDuGMaaU6AMbfKJUI6leDe90uVfmgbN+D+F0fETnr7f20GewW
	6xsZ9S9Ndhtr/ypTIVJmucRoV3fDuzHStLs
X-Google-Smtp-Source: AGHT+IGxLydLDJb0VdYSaq6Lk+OQ4q1aEqSqriHtwbCsy+e8WDZN7b+TQjeMCOhaF7PVT8Bkog08GU6BKCkdGttIS0I=
X-Received: by 2002:a17:907:3e27:b0:b09:6ff1:e65d with SMTP id
 a640c23a62f3a-b1bc2778d71mr257244066b.61.1758113298807; Wed, 17 Sep 2025
 05:48:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
In-Reply-To: <CAKPOu+_B=0G-csXEw2OshD6ZJm0+Ex9dRNf6bHpVuQFgBB7-Zw@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 14:48:07 +0200
X-Gm-Features: AS18NWBvdouXUe1Mvci0ghTgQgjd6tzI9CRI7bVed8MohvrSsbtpRmVZImWkHk8
Message-ID: <CAKPOu+-xr+nQuzfjtQCgZCqPtec=8uQiz29H5+5AeFzTbp=1rw@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 11:20=E2=80=AFAM Max Kellermann
<max.kellermann@ionos.com> wrote:
> I had already started writing exactly this, very similar to your
> sketch.

I just submitted the patch, and it was even simpler than my first
draft, because I could use the existing work_struct in ceph_inode_info
and donate the inode reference to it.
I'd welcome your opinion on this approach.

