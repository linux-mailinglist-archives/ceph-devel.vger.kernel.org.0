Return-Path: <ceph-devel+bounces-1268-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3688E8FE72D
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 15:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46AD51C23D97
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 13:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA7E6195F06;
	Thu,  6 Jun 2024 13:08:40 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB16195B24;
	Thu,  6 Jun 2024 13:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717679320; cv=none; b=F//ZxK4oEJuIiFXaOwR2OtH4knQBwdgcBVIqFnnv0pHuOF8lcZYAhmGR1feFjsNcI5U9MvyFsxm/tlH4o0bQYohYFwj9ukB6a13A/YcORTRTg0urPrsg6EAhIFa3nFICyjDIKe16l+g2MnpkBjXRX6UWTPlEpYSAP9nSqViDeE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717679320; c=relaxed/simple;
	bh=e+1YPH2j9ibGkj0JGgRkMZEvj6bvHIz6BuGoL2xj08w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dUoPXr2B+J3Crg0hoBg2n79TGcUSANi+lO8DB8VHh7AfD28eiDUAGoJmVPabcwtrxrMe591zTjH4dWVmtKsshmYY0o4n3Y5BvExOMKAuxgImR7BH4s2/QJfPp1CXsaRD/IQPTJ7IjydIdgVlClUCzn2BvOah6XjjEs0vWF167rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 77ABA68D08; Thu,  6 Jun 2024 15:08:32 +0200 (CEST)
Date: Thu, 6 Jun 2024 15:08:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>,
	davem@davemloft.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org, dhowells@redhat.com,
	edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org,
	axboe@kernel.dk, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
	idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
Message-ID: <20240606130832.GA5925@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com> <20240530142417.146696-2-ofir.gal@volumez.com> <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me> <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com> <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me> <20240604042738.GA28853@lst.de> <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me> <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me> <b13305d7-35c8-432e-bea1-616410a9da15@volumez.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b13305d7-35c8-432e-bea1-616410a9da15@volumez.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 06, 2024 at 03:57:25PM +0300, Ofir Gal wrote:
> The slab pages aren't allocated by the md-bitmap, they are pages that
> happens to be after the allocated pages. I'm applying a patch to the md
> subsystem asap.

Similar cases could happen by other means as well.  E.g. if you write
to the last blocks in an XFS allocation group while also writing something
to superblock copy at the beginnig of the next one and the two writes get
merged.  Probably not easy to reproduce but entirely possible.  Just as
as lot of other scenarious could happen due to merges.


