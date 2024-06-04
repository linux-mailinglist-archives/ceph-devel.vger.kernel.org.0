Return-Path: <ceph-devel+bounces-1259-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 362E88FA934
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 06:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67B271C220D1
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 04:27:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294B613D62F;
	Tue,  4 Jun 2024 04:27:51 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2E76FC3;
	Tue,  4 Jun 2024 04:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717475270; cv=none; b=ZW8/XX/ceFeVmb8bOIbBb9Aq4iA+e5zyeB++QYLAkIzFmD7BtNZNd/N0OiZtKTNwboIAR8oLGiz90MayF853SatuOHpml75GN8ZKXZmdMs/ttRbiAHjHOMmeOnu8nPSHNWz+BujHjmgYbAFYDkqTyZvwmf4bWMXT7Amog6m1l3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717475270; c=relaxed/simple;
	bh=37f7u7mBYGmUYzgLNpaGQX9mYm3p2zstizOQJ0T1qow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JymW8c1/Yk2nPGz8PtgeJH46dpQ2gzO5gei4bc/zkmostQQctsDZOB/7p/KVUG6El6oAkBlTpMyJEtcRSzNQPGBzptaBvwOZmUfHCeO4z6VaNFJ4T1wpBJNXU0pYOUiRZWcOpmgjvQWX0NLMdOwvTgVR9CbLmLNvXSG9ad8Mhpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A2E5F68D15; Tue,  4 Jun 2024 06:27:38 +0200 (CEST)
Date: Tue, 4 Jun 2024 06:27:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	netdev@vger.kernel.org, ceph-devel@vger.kernel.org,
	dhowells@redhat.com, edumazet@google.com, pabeni@redhat.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, idryomov@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
Message-ID: <20240604042738.GA28853@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com> <20240530142417.146696-2-ofir.gal@volumez.com> <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me> <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com> <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 04, 2024 at 12:27:06AM +0300, Sagi Grimberg wrote:
>>> I still don't understand how a page in the middle of a contiguous range ends
>>> up coming from the slab while others don't.
>> I haven't investigate the origin of the IO
>> yet. I suspect the first 2 pages are the superblocks of the raid
>> (mdp_superblock_1 and bitmap_super_s) and the rest of the IO is the bitmap.
>
> Well, if these indeed are different origins and just *happen* to be a 
> mixture
> of slab originated pages and non-slab pages combined together in a single 
> bio of a bvec entry,
> I'd suspect that it would be more beneficial to split the bvec (essentially 
> not allow bio_add_page
> to append the page to tail bvec depending on a queue limit (similar to how 
> we handle sg gaps).

So you want to add a PageSlab check to bvec_try_merge_page?  That sounds
fairly expensive..


