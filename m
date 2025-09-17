Return-Path: <ceph-devel+bounces-3673-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 958EEB823CB
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 01:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53E21627E4E
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 23:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BEF30E82B;
	Wed, 17 Sep 2025 23:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3GfjjVD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2569478
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 23:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758150526; cv=none; b=cmFbuRjfmnnxVsji/Ku2gVr5dzu9/M8g6wFJFuIm/hOyGPxPfSImhSH/L97FJJNGxGbQTtfy3brunorvOY7yLWqdIFUD1l9DeYnfvb6xK2MAtBDS6d8Bq8Uj0uI0FgGjbnBk7p3lCzBjDNrWdvrRmom79UJBk4GBMHRAdrq2n+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758150526; c=relaxed/simple;
	bh=fiHidarY3es8NBA+LEW3pv6bjjvuMZYa+mJzlo0B1L4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lAWTN5hOQD/tV5w4ZJyB9H0Nkq5oX8wlT0vhKdWy1UrivBmd7cd90fM/45aqWsDDkwmd827zjvBcdWnplObnjlUI1COICxdb1g+CMLYtGmNgqJyR44Zx6MMLYaGacnf/0R5XPwmCJplX66vQRJwfnh4go6/efzmkcx+gXDM0A5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3GfjjVD; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b07d4d24d09so54359466b.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 16:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758150522; x=1758755322; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRGj/ILyJWi2Bsgex4Gvbo4N7e1wLDw4WJvnSHlYoZY=;
        b=a3GfjjVDOZloiF3VHg1fDTK/uGAjwoqZxrDmljLKWUYqeFDkG4puWSop+iNpdtY33S
         NdJ/cP+klOKHxsi6s4nCGtkbcYEDAr91Zn8tCT7GSnFwGfC6ggfa2Q5GgWRsLQpgHBpM
         EpHymmtQJ0Lf27fTlyD1EBlsqIOChVPhkRy9Lf+4/l3T5KNkiTqz6hMJeKiwi5b3DZrB
         AYGyHTdN5Je9sN4jCvevyClImXvu8bsCKeLyPITDphDybU3LBlBAkM1rHHfFUagqm+EG
         iIJWJWDWxzZn54aHP90ddn90W5Mz38hCIIC1IFhAfEdK5vwq35TO1TBkGVofSdTYJNs0
         2l7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758150522; x=1758755322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRGj/ILyJWi2Bsgex4Gvbo4N7e1wLDw4WJvnSHlYoZY=;
        b=r44DDuhASTxquoIAkXP65F1FgKyHP3FyFc7ykzC5Oaw+RzYHjcco2or7E6sgB1M1Zk
         YM5H5cxwJ9bqn1b3jpROT2iPqqJvyvRsMk1kZOnaPzMuvalrVnsUp+N5PtuHcliQ4grB
         6Kt8vcZ9FSvfjKJlKEOwlZh58JAfPyry6NZnl3uKrATKWd8a9FjPP5WXqVZL8YQVCsmq
         PTyXRxX/69rDQxCq4WvKDmz5hGH2OrdMsh+ikWr4ks8+4B7cx5/LgE0AIUAoAp1JL/OO
         dcjDGoHRrpRjxFAVVKkbLOLfBHLctFOTjEaVu3x3ueEAZePB3LkjXKRTZ0O5NW5v70Bl
         T61g==
X-Forwarded-Encrypted: i=1; AJvYcCWjEXVIrumYrHmBq9h/8S+OQWeriXpD6EljNegqrZY+q0NEoQfaci6RUZ9QDmhk8JQrER1Mh6W1AiaX@vger.kernel.org
X-Gm-Message-State: AOJu0Yyuoyxjij7laL0x3BnTJeLBV4TTb62iBTtk/dVc8pRxDhgJy4h2
	ucKXlxDvVaq742eD0phYR/0aX77cNt1dbosr3ZMxnVLHsHCNkQ8smj6j/9RRFUFfUKXDlEvMBfz
	zZ58eT/qapduGXCnvsNJluV+aBHpcYg0=
X-Gm-Gg: ASbGncs0vN9JQMk8gDPGR2p7qkPeUXZKJHJaxyntOpmOKWhvn0usWh56yAMOFT1mEHg
	MkFUT7oupAbs/mFwJx0oaeMcCh6ZOm4osYWdarL7wcJhJhTScAeh1E3/qeMXwz6TPPjHdY5VebK
	qmxgXkz5eiXmKGpsi/8rDkQTYt3KBIm9bXQ+ndG0z147RhfAFR8gu0SOMgj1b81PjTl//65C+Hq
	aZ5MYsHYNjVwLlIZSYSroYqjZLXoNcDvISLaFQl37Vdhj0bu5K/oKEIqQ==
X-Google-Smtp-Source: AGHT+IFTShsh8t7nrREG3sNteTvvDWCztpJ0irdoYHone0kblikor9dVjpl7/+XtSzyEetSqaaCdKn/NmlZEPTV0vhE=
X-Received: by 2002:a17:907:6093:b0:afd:d994:7d1a with SMTP id
 a640c23a62f3a-b1bbc545b99mr380535666b.63.1758150522536; Wed, 17 Sep 2025
 16:08:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917124404.2207918-1-max.kellermann@ionos.com> <aMs7WYubsgGrcSXB@dread.disaster.area>
In-Reply-To: <aMs7WYubsgGrcSXB@dread.disaster.area>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 18 Sep 2025 01:08:29 +0200
X-Gm-Features: AS18NWAPWaGTXxRYRzp3XafBT13uBoehIcp4zLeoIa2AaJjHnaVuMpyaFs-UzhE
Message-ID: <CAGudoHHb38eeqPdwjBpkweEwsa6_DTvdrXr2jYmcJ7h2EpMyQg@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Dave Chinner <david@fromorbit.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, slava.dubeyko@ibm.com, xiubli@redhat.com, 
	idryomov@gmail.com, amarkuze@redhat.com, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 12:51=E2=80=AFAM Dave Chinner <david@fromorbit.com>=
 wrote:
> - wait for Josef to finish his inode refcount rework patchset that
>   gets rid of this whole "writeback doesn't hold an inode reference"
>   problem that is the root cause of this the deadlock.
>
> All that adding a whacky async iput work around does right now is
> make it harder for Josef to land the patchset that makes this
> problem go away entirely....
>

Per Max this is a problem present on older kernels as well, something
of this sort is needed to cover it regardless of what happens in
mainline.

As for mainline, I don't believe Josef's patchset addresses the problem.

The newly added refcount now taken by writeback et al only gates the
inode getting freed, it does not gate almost any of iput/evict
processing. As in with the patchset writeback does not hold a real
reference.

So ceph can still iput from writeback and find itself waiting in
inode_wait_for_writeback, unless the filesystem can be converted to
use the weaker refcounts and iobj_put instead (but that's not
something I would be betting on).

