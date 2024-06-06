Return-Path: <ceph-devel+bounces-1270-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0621C8FE838
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 15:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A357B283D3B
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2024 13:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEC9196457;
	Thu,  6 Jun 2024 13:52:40 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7521EEEC5;
	Thu,  6 Jun 2024 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717681960; cv=none; b=TC92blZ49BRt6lXNrvTwtDKMlGGmOFb3SGlheNfzBsAJf5wWF6ATh7RvoSARGiaGUZ19plcf1obmywjz2tKya0pwdvdttbE5gl0MYyYQMzbI2QmzoAPuHzsxwc4Nll53FPMtwyvO+N/EJKQ4pRarDkFf8eVGRXaoiB/tU/KGXbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717681960; c=relaxed/simple;
	bh=cVxaS123yfZeIrKJV4voHSXfQdb4plAeio9mxmmDMPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WdkFR8KvkyTDjfjYEU1O6MqPxyYcWu40uX5JkMdBIGsl+FJq7FepS4BgO6V9bFhpzzmA98BotCueRy8M7pd7bXZlIpvTmvppROcc2NRkaHfZmgTNd4Vw9ewIugRj2zPYgdgG3lJ2oZJcqNeCBDIehFvW66ntvoaLm8hUOr8q6XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B4E9268D07; Thu,  6 Jun 2024 15:52:33 +0200 (CEST)
Date: Thu, 6 Jun 2024 15:52:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	davem@davemloft.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org, dhowells@redhat.com,
	edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org,
	axboe@kernel.dk, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
	idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 1/4] net: introduce helper sendpages_ok()
Message-ID: <20240606135233.GA8879@lst.de>
References: <20240530142417.146696-2-ofir.gal@volumez.com> <8d0c198f-9c15-4a8f-957a-2e4aecddd2e5@grimberg.me> <23821101-adf0-4e38-a894-fb05a19cb9c3@volumez.com> <86e60615-9286-4c9c-bffc-72304bd3cc1f@grimberg.me> <20240604042738.GA28853@lst.de> <62c2b8cd-ce6a-4e13-a58c-a6b30a0dcf17@grimberg.me> <ef7ea4a8-c0e4-4fd9-9abb-42ae95090fc8@grimberg.me> <b13305d7-35c8-432e-bea1-616410a9da15@volumez.com> <20240606130832.GA5925@lst.de> <ace6e7a9-3a77-43eb-ad86-83eabc42cdb4@volumez.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ace6e7a9-3a77-43eb-ad86-83eabc42cdb4@volumez.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 06, 2024 at 04:18:29PM +0300, Ofir Gal wrote:
> I agree. Do we want to proceed with my patch or would we prefer a more
> efficient solution?

We'll need something for sure.  I don't like the idea of hacking
special cases that call into the networking code into the core block
layer, so I think it'll have to be something more like your original
patch.

