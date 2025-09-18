Return-Path: <ceph-devel+bounces-3674-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9F6B82585
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 02:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 230711893064
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 00:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BFF28E7;
	Thu, 18 Sep 2025 00:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCnMfX9n"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578C4A2D
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 00:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758153908; cv=none; b=jf6dEzxPnR5omFf2U2iXbp631fhZGZJLtU5WkVmEdwlUa9X3qJZezL8Jubm+wpTMh4+OTrCQbjLoBzOjuNk4152c7T0a4qsupJYfy+jHRfa68idayksR2Q7lwugsTKHI4nnuoIynRf7mKBtvKUi9q7ILlzWUbbkssIySgwKu/Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758153908; c=relaxed/simple;
	bh=/60HjsF5kDxVQb13pIAAZhD9mjEiPULAqqfFawaT56Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eDlEpdVXcwtgISgN1oLNowpdC7aJ++iNgvck6TEFtACkBsFdM7KD5rZe23BbjPlKLyH8l757J0TkTkYTQqJuQZFQ1At9V2ssMaOZRP9geOdGL5y9qCjFk+AGgULiWlhKdSoToYTiEqpHJOwN9jTcazFU68kVhkdV9PwulLzEc4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCnMfX9n; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-62f330eeb86so492497a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 17:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758153905; x=1758758705; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7rBzal2frbQpnRlW30Mxkh3elZt0aXaSIdElcYyVLY=;
        b=eCnMfX9nb2niiMkElvWbWYpa4nkIf/PMO+FAJQTRxvqJJGHMmwDnPPSsVwmRt6mTI4
         260q3Mgnk2P0OrD98cBMEpZBvS5gyw1QVeTi9UNkIZ8yPFslTSr1muU6PHgYrMY6g4Kv
         9DouSVdfLJ67uRCL8NW78Joa/ZZ3uQFjbXiRhUNvSXEuLwEGmOnWX0gPPzT65S9HMxfk
         Sf2sxR91myFqMafdi9ZiM1RhLzShswJDnBVqWxoV17/ZczzMiPmL4Zpvxn5LrjyQD2Lm
         pEgRkvoAtHupuZtkZfLNAK9v16g5hPnbd4BgaTitsvlI1P5YQcIR3217kztIGBnK5yau
         PQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758153905; x=1758758705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J7rBzal2frbQpnRlW30Mxkh3elZt0aXaSIdElcYyVLY=;
        b=UdC5pwh5CnBICKK4Juggq7xyKRXkMPAVIgn0RZW7Hd61QL4b3x6UdCDX1yp5s1At4t
         RJ0KyTcphuWwLAUEXz8tAPcYdVhQs90fH3OwWPHyPnu4pfy4Sigr3+N/oQmtWxOlyxv2
         SLNJYxsKpV6M60Ybcx96JHrgnjTRdfU/8op6V7z+ekJW7rX2V4w32W1jqDyFXFf90Bsn
         D8JwpHRkuO6ERva1DIxh3khexxHSSeUxbuhrqxbRNcM4f1UAsEp2Wm1IaZLSXXFbuJ84
         aL13YbfxN7iwj+js+BMJqMcuupYvbSQKNiFBmvg1CMu145hKAM+v7H2H13Lg/+Q5P3P9
         +pIg==
X-Forwarded-Encrypted: i=1; AJvYcCXhBvZb7DhB1pk61AY+zPypj67IuroVOVqYguN5C9xv0oY6GJUPPKuvFGeSHGcnQWBLLOc4IoB2nksW@vger.kernel.org
X-Gm-Message-State: AOJu0YzX94UTxCFvDS7MsmceqH3kTkq+92/twakYm7PQC8YHoQT8mKIV
	mASZ1pCEWhV4f9cZt9pySWGG4c3nI/wnsCBZXhlF84rsssjUaO7tDivSSI5L2GR8OowomUdJVNj
	h95TJMGszWds/yOoTqxuVOE30/2GQiAk=
X-Gm-Gg: ASbGnctGNllln5wP6ioq4o8C71HgPliv1GkucDdfJu/BaOnRMYgu4DPIvm50pLVu36K
	36bTUgj1q4kTzmsCe75l9ESWb0zaVQC7YFe0o6FxqNNAQrJjAGIMppjGMYG5ux0C2Ngm4XGQrQx
	wgDzL+yziu8JuP8yZTQpCTvDmWiWGIYWsmzu+fUXh8ta+aSTscaUYDkufxlWMyFYoxcjaaJkRU2
	5byJm48Ue7uyh16f5FA4ChKBVdAjE1IAIXZkpXBzUQZzPP6/cYn64TzPQ==
X-Google-Smtp-Source: AGHT+IEG0rY/6zoPQ0V4J9TEMxL5qWtyUtLwQjBHHbE0kU7UOpID9Vbuyc6wLRhaE+GAd8+JbDeWJnkobCY95bQb0m8=
X-Received: by 2002:a17:906:eec3:b0:afe:e9ee:4ae0 with SMTP id
 a640c23a62f3a-b1bbb7425fdmr420216666b.59.1758153905204; Wed, 17 Sep 2025
 17:05:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917124404.2207918-1-max.kellermann@ionos.com>
 <aMs7WYubsgGrcSXB@dread.disaster.area> <CAGudoHHb38eeqPdwjBpkweEwsa6_DTvdrXr2jYmcJ7h2EpMyQg@mail.gmail.com>
In-Reply-To: <CAGudoHHb38eeqPdwjBpkweEwsa6_DTvdrXr2jYmcJ7h2EpMyQg@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Thu, 18 Sep 2025 02:04:52 +0200
X-Gm-Features: AS18NWA8wIEg-rpkslqLzmFrp09CSxzRRbJVlRWEvQeLl_2xapCCNgyg1L-JlpY
Message-ID: <CAGudoHEpd++aMp8zcquh6SwAAT+2uKOhHcWRcBEyC6DRS73osA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, slava.dubeyko@ibm.com, xiubli@redhat.com, 
	idryomov@gmail.com, amarkuze@redhat.com, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 1:08=E2=80=AFAM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> On Thu, Sep 18, 2025 at 12:51=E2=80=AFAM Dave Chinner <david@fromorbit.co=
m> wrote:
> > - wait for Josef to finish his inode refcount rework patchset that
> >   gets rid of this whole "writeback doesn't hold an inode reference"
> >   problem that is the root cause of this the deadlock.
> >
> > All that adding a whacky async iput work around does right now is
> > make it harder for Josef to land the patchset that makes this
> > problem go away entirely....
> >
>
> Per Max this is a problem present on older kernels as well, something
> of this sort is needed to cover it regardless of what happens in
> mainline.
>
> As for mainline, I don't believe Josef's patchset addresses the problem.
>
> The newly added refcount now taken by writeback et al only gates the
> inode getting freed, it does not gate almost any of iput/evict
> processing. As in with the patchset writeback does not hold a real
> reference.
>
> So ceph can still iput from writeback and find itself waiting in
> inode_wait_for_writeback, unless the filesystem can be converted to
> use the weaker refcounts and iobj_put instead (but that's not
> something I would be betting on).

To further elaborate, an extra count which only gates the struct being
freed has limited usefulness. Notably it does not help filesystems
which need the inode to be valid for use the entire time as evict() is
only stalled *after* ->evict_inode(), which might have destroyed the
vital parts.

Or to put it differently, the patchset tries to fit btrfs's needs
which don't necessarily line up with other filesystems. For example it
may be ceph needs the full reference in writeback, then the new ref is
of no use here. But for the sake of argument let's say ceph will get
away with the ligher ref instead. Even then this is on the clock for a
different filesystem to show up which can't do it and needs an async
iput and then its developers are looking at "whacky work arounds".

The actual generic async iput is the actual async iput, not an
arbitrary chunk of it after the inode is partway through processing.
But then any form of extra refcounting is of no significance.

To that end a non-whacky mechanism to defer iput would be most
welcome, presumably provided by the vfs layer itself. Per remarks by
Al elsewhere, care needs to be taken to make sure all inodes are
sorted out before the super block gets destroyed.

This suggests expanding the super_block to track all of the deferred
iputs and drain them early in sb destruction. The current struct inode
on LP64 has 2 * 4 byte holes and llist linkage is only 8 bytes, so
this can be added without growing the struct above stock kernel.

I would argue it would be good if the work could be deffered to
task_work if possible (fput-style). Waiting for these should be easy
enough, but arguably the thread which is supposed to get to them can
be stalled elsewhere indefinitely, so perhaps this bit is a no-go.

