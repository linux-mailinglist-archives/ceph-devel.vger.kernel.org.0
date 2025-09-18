Return-Path: <ceph-devel+bounces-3675-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D9FB82782
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 03:07:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F124E4A251D
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Sep 2025 01:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DE11F5413;
	Thu, 18 Sep 2025 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2Oq2G53j"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352181DDE9
	for <ceph-devel@vger.kernel.org>; Thu, 18 Sep 2025 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758157640; cv=none; b=HKs1QulCvFh9JfRKGy8HAJ025LvOhxg3lIFAQGc4MCBzWmkaKv1+YfHnTvpR3M31FlUuAc+HrfhcVofqA2tk2wWfXyaFb83BRPTeif3Nx30Hp+/WinEJ+tc2FN4iPELwQBRbWGJlp0qvCkcN/oZbeK+ile6o4HW2QwfxIeWxKCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758157640; c=relaxed/simple;
	bh=Jyh/T1VQujpBIetRlEwQ9WKQ0pDM9Occu70Vj9kJ3PA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=emf6aNKVy4ZBi3kwbwEUb3yeTytTAq/7GgM8bpPTS7l81L0niMaVU19+Gtlpcj0ilb7uHB+SYmCJu8HANSSfKL1xev8XsyOyiR+IGWz66/vN/5+6Xb11jKqkoAPUBub2hMKYMwbZry5HZZjF1kcILYj+K+x+mRRV7BHRccxM7a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2Oq2G53j; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-77796ad4c13so308840b3a.0
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 18:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1758157638; x=1758762438; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p3n6Uf5fmho3K1YmaoGj4njt8YRbuIHtLi1zAXG6OwM=;
        b=2Oq2G53jiImhW9tX7gMzXIqb746T/KHiolWjo9MhwMcmkOJWUdUilafdNEy5FEC2Lv
         f144ESPYsmq+enFn/UH5FgTuGu7rKoPe1h6aSkIZUCSFMI/VND1Vbfl8fD/EtkmHDEVe
         vIDRcKrjsAQGgp3bkDZTq+IPaJYukxNbTn/DNJGSzARiZOuEHxFxQMHMeBgI14YPmiw3
         qDEF2TuHKMN6Hg96bnmfulLcNDGQfX+7EsaRSzk7PdMQj4g2YMJYM3ZY8TkCOxs3U7MV
         +jMWJusmd/DA6NjdU3oAQYRD1tcb1Y23QVEbCMbDKNAE2aq6yDFdkG7y2/7AI+pWdEr+
         z2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758157638; x=1758762438;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p3n6Uf5fmho3K1YmaoGj4njt8YRbuIHtLi1zAXG6OwM=;
        b=omscDXHIScwpCikcbF10pKgUWHq53G7U/3tVDENL801OyiSL6tr3kSvhp1l0qiPaHT
         7heQ4U1qIbr5xtxboFsgXxpjVNJHHwev9fDil/meiYDQRy3xL09RekSGQcmE0zZN9h+M
         jCdwM4Mjv0HTLabtu1/oKdCuQur7TweG4SpFcFPvXWBPyLtzhdUA5y9AHWYjzObKpo4s
         jPMQzIRPu6Ho0g2NNduRLdVIkq7lfBFfdHA8HmOtfi2ZsqlHaZ7GpjwlA47A9e1ikgJP
         q6XWc7siV2JfpwpiaM+f2bveA1F90V5xf+xvEL4nyywhv4xeFcRyVV4z9xeXWv7Y1mdV
         PEtg==
X-Forwarded-Encrypted: i=1; AJvYcCUCJKG4llw6eggtX9Ra5BkkyoxnWqqZwp2H3x2s7IGaq52DaESJemjtoXJoF9htXG1RrqyBdLJKQ5tK@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy0Ql91rgHJF0Hors/NyPC/ky5mKxPWURqwrPzQ0xEIupCdCpa
	gJQj7w7Lrm6WyJX2F/FwUjJGUz/+Y14vkebIeLOcuKNivhOItKwG468euHQ5dwFHbVw=
X-Gm-Gg: ASbGnctxJA9akxw6kQVQjcDiMZbLnediw+cHNJa+XGKxbl1Tuvu6oi2VMZW+ohTCCWn
	jvb7nJhlSJjNFlQbns2xRS/r1hjpEP0hhgfJEf/auYFFmDDslEsDQHpJsKurLNvAyhtdxHJXQBP
	H2S9hlxll6kKHwtNw7tJoqEDnMRQKAHX6XSbzuXjkJbDfLn2sn05PgvZXY58sTjA7CAamAeAtUm
	svbPQ7ywYnppwremvBwMXz//vn0jR+tyvkq27i49Z/iB683iVtNxeraH8CKIa2qlI5r138OX4zy
	LOQq4K5XDErV+v9L6mAJtsv56uKAGFmt/0th5AGgUEFoqwjLoefWL+E5ylXTv9BJdOuw7ruOgzj
	7M/XUFQZMpXUGHqtFnqKqO9eLuQVPB7l5hEXXuYQsE95VdMDJlxi7C3sn7L4MJOkM75wcpypUnD
	LI8CdtHg==
X-Google-Smtp-Source: AGHT+IGuCJoEhQgAv+Omg49c7c/B2Tcr3E0BGIChrElfWl6Pxd6ZK4K1F7fPmkeQRRASiKleSW/EoQ==
X-Received: by 2002:a05:6a00:2350:b0:776:1834:c8c7 with SMTP id d2e1a72fcca58-77bf9664586mr4517640b3a.26.1758157638566;
        Wed, 17 Sep 2025 18:07:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfec40185sm605187b3a.77.2025.09.17.18.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 18:07:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uz37D-00000003LBO-2MNV;
	Thu, 18 Sep 2025 11:07:15 +1000
Date: Thu, 18 Sep 2025 11:07:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Max Kellermann <max.kellermann@ionos.com>, slava.dubeyko@ibm.com,
	xiubli@redhat.com, idryomov@gmail.com, amarkuze@redhat.com,
	ceph-devel@vger.kernel.org, netfs@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls
 asynchronous
Message-ID: <aMtbQzb-aFPtjttc@dread.disaster.area>
References: <20250917124404.2207918-1-max.kellermann@ionos.com>
 <aMs7WYubsgGrcSXB@dread.disaster.area>
 <CAGudoHHb38eeqPdwjBpkweEwsa6_DTvdrXr2jYmcJ7h2EpMyQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGudoHHb38eeqPdwjBpkweEwsa6_DTvdrXr2jYmcJ7h2EpMyQg@mail.gmail.com>

On Thu, Sep 18, 2025 at 01:08:29AM +0200, Mateusz Guzik wrote:
> On Thu, Sep 18, 2025 at 12:51 AM Dave Chinner <david@fromorbit.com> wrote:
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

Hmmmm. That patchset holds a real active reference when it is on the
LRU list.

I thought the new pinned inode list also did the same, but you are
right in that it only holds an object reference.  i.e. whilst the
inode is pinned, iput_final won't move such inodes to the LRU and so
they don't get a new active reference whilst they are waiting for
writeback/page cache reclaim.

That in itself is probably OK, but it means that writeback really
needs to take an active reference to the inode itself while it is
flushing (i.e. whilst it has I_SYNC is set). This prevents the fs
writeback code from dropping the last active reference and trying to
evict the inode whilst writeback is active on the inode...

Indeed, comments in the patchset imply writeback takes an active
reference and so on completion will put inodes back on the correct
list, but that does not appear to be the behaviour that has been
implemented:

	"When we call inode_add_lru(), if the inode falls into one of these
	categories, we will add it to the cached inode list and hold an
	i_obj_count reference.  If the inode does not fall into one of these
	categories it will be moved to the normal LRU, which is already holds an
	i_obj_count reference.

	The dirty case we will delete it from the LRU if it is on one, and then
	the iput after the writeout will make sure it's placed onto the correct
	list at that point."

It's the "iput after the writeout" that implies writeback should be
holding an active reference, as is done with the LRU a couple of
patches later in the series.

> So ceph can still iput from writeback and find itself waiting in
> inode_wait_for_writeback, unless the filesystem can be converted to
> use the weaker refcounts and iobj_put instead (but that's not
> something I would be betting on).

See above; I think the ref counting needs to be the other way
around: writeback needs to take an active ref to prevent eviction
from a nested iput() call from the filesystem...


-- 
Dave Chinner
david@fromorbit.com

