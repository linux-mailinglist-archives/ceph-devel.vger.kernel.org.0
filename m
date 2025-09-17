Return-Path: <ceph-devel+bounces-3632-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F99B7C5CE
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 13:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31F8F188C6D2
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 08:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E0A53090EF;
	Wed, 17 Sep 2025 08:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N0dvV/9/"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECE829AB13
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 08:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758097432; cv=none; b=nsT8TpuxW0JUujzGU/vlAkRDEB7i1pGsDp0ptAP6hrLfXThpREEJPH4Fb+2BNbqA6nx5bz2IptGpv3e7XQccgZINudPbMvB1+fnFoQqs2nd0PU0MH+XdoVx067hB1v4uvHYzcDgYKyRwFfW/RO1tqi0ottqe2UKPxNHV4D/2YlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758097432; c=relaxed/simple;
	bh=mhLSR++8oh48OFsFslw+TVcT7JWmq9x/XBi/kIafei8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V3mdht6colA0crTVRFkCWMJnYBtFRzsizKqq3DypXHejqM4ysc7nJGtMJk0gXa8kVkLFBAcxbhuguxbxRwiOTaHcZOOblNPUdf0//0lq2Hh2MtPXtnTtrH5agUY9uj74A1viAQxu8/AqKiWul5E0jXYvVv8r/36a8vqJjQGLxMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N0dvV/9/; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3eb3f05c35bso2294963f8f.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 01:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758097429; x=1758702229; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nKoz1wwq4W5nsOBVejmSw904t2QivJCV9ZZ14IEmXqc=;
        b=N0dvV/9/kBiocbwVdb0YYYxasmRGTHiWkz8XK1E5bDEs8h4kitT/61U2VWvtBjeux4
         Ptr0XY6kQwviTfwsd61UHGDZn5lk/ZhuA9vri2yK4igN2CVQd8SNtONzx+PasNohnKOx
         T6fmcZggTtGrGQqrRKtzxZqbWXzo6mh3X9d7fBt5cndRgfGN75owW8ZTSPtUllJL37S5
         eJhNnkvcYNPJZyawkUHZU9vB4H1RYSfAHBjcdVPpAAR0Jvx+cYErpNq26wXKPI5F7Rrm
         FoTMRg5yzfEkiXeKOdcPdvD+xc+BO85cHWbYj6zzYpjN6pyjJaTcCtgxOrkl5Fb/2BsQ
         potw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758097429; x=1758702229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKoz1wwq4W5nsOBVejmSw904t2QivJCV9ZZ14IEmXqc=;
        b=A8i+5L69Zb6uIoJ/AzLDOb/eqgsjWPU1eGmhNMDSnPF/rdeAh854Ilcackv4qI3eIp
         tLUTyjKOOygsSifu8u/8I+19nC4Lh9SYAvTIFd41DpLjVp9ufLQPDLmdhw0RUy9cpRXN
         T9lZSs3PNwGPtoSbZzOkvDAQG7VR5rEDGTR/w2nVrwuK8GnRZD0pkXR9UedHevf0gsiu
         Qb4ldycahuOztdP5sL4S0hfph3hgMPK5YaXT8xecYFDUuC1ZNVQe3iQTorBDWfiUgxcd
         RmWBCLDLpHtE2nestHceKX60xK0sZljwg26XMH1OjZUm9WZwK6q2DObWpLxZ7Q/n/sro
         KFZw==
X-Forwarded-Encrypted: i=1; AJvYcCXCYeekF8AZMQSAou61ayGP+GDCfQc2K55p9cKjKZggjeZdd7kHHcm4vTkBvp/wqKtnYggr8EDAD5Fb@vger.kernel.org
X-Gm-Message-State: AOJu0YwubUrE4gGOIRttoaCigJIcBU93lZNXGI2h1I2Asn1tUQ9tcNHU
	gVCEtOKRA1MuPeCTIpMRGjY6fQ12En/cSeeqVr1c1DbdxCQ3eZI9crW4vwbPlNsF
X-Gm-Gg: ASbGncvi1Qo/omqEPQUyWTvAFd7BJuFsAfzYo/i8FGZFyIOa2OcV1c2gZDvRI2NdLB3
	ZJKTA18AsWMP7bvDbc8kQRzUvcW5k1OqVCf0l08YcQwY9XZLh84E6kvNKUUWrq5/IcwgBbBRh0P
	Hg0rpr4w2xWRTZB3rob62nD3i2RgbZJMHUXQB4DGDL2vIOTGbLaW0hTvplkyFZI+Eox/IqqyP17
	HUDfj/nhEomebfKnfR9PsyVOCoQn2FvtKbEEth9HWoguzowwyDaT6veUWIyajFJW6TL9WMr0Uud
	gtVfaX+XIE9UxR3nCWGdDWvHeQG11X9UbZYwlYlu+5xPgP4TCgDg9K9etdzDFybEMPZoAwTHlZC
	jdhK+3bH7WggEdx2gEzaWtnk6jJSSzo6QpZBTzpBemfh/YNMI4Lz9Sedf66mUUfd0wJlXgA==
X-Google-Smtp-Source: AGHT+IFKMCiumtXuFHiGcWUdk7gpPAgdJxoS/pj8Bc5c/MZoNMZOI0Hlp4G3KTEeO9vtK7wNlz2G/w==
X-Received: by 2002:a5d:508f:0:b0:3ec:e226:d458 with SMTP id ffacd0b85a97d-3ece226d48dmr52888f8f.0.1758097428696;
        Wed, 17 Sep 2025 01:23:48 -0700 (PDT)
Received: from f (cst-prg-88-146.cust.vodafone.cz. [46.135.88.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e8b7b6ff8fsm17004415f8f.61.2025.09.17.01.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Sep 2025 01:23:48 -0700 (PDT)
Date: Wed, 17 Sep 2025 10:23:03 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>

On Wed, Sep 17, 2025 at 10:07:11AM +0200, Max Kellermann wrote:
> Hi,
> 
> I am currently hunting several deadlock bugs in the Ceph filesystem
> that have been causing server downtimes repeatedly.
> 
> One of the deadlocks looks like this:
> 
>  INFO: task kworker/u777:6:1270802 blocked for more than 122 seconds.
>        Not tainted 6.16.7-i1-es #773
>  task:kworker/u777:6  state:D stack:0     pid:1270802 tgid:1270802
> ppid:2      task_flags:0x4208060 flags:0x00004000
>  Workqueue: writeback wb_workfn (flush-ceph-3)
>  Call Trace:
>   <TASK>
>   __schedule+0x4ea/0x17d0
>   schedule+0x1c/0xc0
>   inode_wait_for_writeback+0x71/0xb0
>   evict+0xcf/0x200
>   ceph_put_wrbuffer_cap_refs+0xdd/0x220
>   ceph_invalidate_folio+0x97/0xc0
>   ceph_writepages_start+0x127b/0x14d0
>   do_writepages+0xba/0x150
>   __writeback_single_inode+0x34/0x290
>   writeback_sb_inodes+0x203/0x470
>   __writeback_inodes_wb+0x4c/0xe0
>   wb_writeback+0x189/0x2b0
>   wb_workfn+0x30b/0x3d0
>   process_one_work+0x143/0x2b0
> 
> There's a writeback, and during that writeback, Ceph invokes iput()
> releasing the last reference to that inode; iput() sees there's
> pending writeback and waits for writeback to complete. But there's
> nobody who will ever be able to finish writeback, because this is the
> very thread that is supposed to finish writeback, so it's waiting for
> itself.
> 

So that we are clear, this is a legally held ref by ceph and you are
legally releasing it? It's not that the code assumes there is a ref
because it came from writeback?

> Anyway, I was wondering who is usually supposed to hold the inode
> reference during writeback. If there is pending writeback, somebody
> must still have a reference, or else the inode could have been evicted
> before writeback even started - does that lead to UAF when writeback
> actually happens?
> 

One of the ways to stall inode teardown is to have writeback running. It
does not need a reference because inode_wait_for_writeback() explicitly
waits for it like in the very deadlock you encountered.

> One idea would be to postpone iput() calls to a workqueue to have it
> in a different, safe context. Of course, that sounds overhead - and it
> feels like a lousy kludge. There must be another way, a canonical
> approach to avoiding this deadlock. I have a feeling that Ceph is
> behaving weirdly, that Ceph is "holding it wrong".

Doing it *by default* is indeed a no-go.

I don't know what other filesystems are doing, I would consider iput()
from writeback to be a bug.

However, assuming that's not avoidable, iput_async() or whatever could
be added to sort this out in a similar way fput() is.

As a temporary bandaid iput() itself could check if I_SYNC is set and if
so roll with the iput_async() option.

I can cook something up later.

