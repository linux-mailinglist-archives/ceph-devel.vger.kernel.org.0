Return-Path: <ceph-devel+bounces-1266-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C9A8FC48C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2024 09:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 386011C20BE3
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2024 07:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E036E1922E6;
	Wed,  5 Jun 2024 07:27:48 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39EF1922D5;
	Wed,  5 Jun 2024 07:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717572468; cv=none; b=BSw16IcKCYF6A5NoZ7b5jhTdO9YbheKH1d7N2nqtXYA3X1Rva5FAP5HaeV1Vat1+PCK4itOzSJ2Sg44IgAWHZaZOyUnOE6G5BkwveyOhS8U4FnD40t0Dz++N0fy480AvzymCz2xnsO5N62Jxf9JbrFm35yQ5ammapVLV74t9ZVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717572468; c=relaxed/simple;
	bh=8LUykD/62bGMRfd/a9I1PHICud17UdPvZyyzW9ay8wM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pn/Htn1V3OYFJanM6koYswBZ4zfYlgJIBfwMO5vOnc+SeGNUA/1O87FIEOq8YupWJCpSOYCmZw/l9np/oTWFwjuhrbh4TDPKuzTOC7B2Kb0XiEkWuvPXTOLcqm5ySkpBl/ZGOItdlfn+HhEc0W1Fi5vDGnB/ERb1JIuPHlR0248=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6002E68D0D; Wed,  5 Jun 2024 09:27:43 +0200 (CEST)
Date: Wed, 5 Jun 2024 09:27:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ofir Gal <ofir.gal@volumez.com>,
	davem@davemloft.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org, dhowells@redhat.com,
	edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org,
	axboe@kernel.dk, sagi@grimberg.me, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
	idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Message-ID: <20240605072742.GA16306@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com> <20240531073214.GA19108@lst.de> <20240601153610.30a92740@kernel.org> <20240604043041.GA28886@lst.de> <20240604074224.44668dab@kernel.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240604074224.44668dab@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 04, 2024 at 07:42:24AM -0700, Jakub Kicinski wrote:
> I'd guess the thinking was that if we push back the callers would
> switch the relevant allocations to be page-backed. But we can add
> a comment above the helper that says "you'd be better off using
> page frags and calling sendmsg(MSG_SPLICE_PAGES) directly".

That's just not how network block devices or file systems work, they
don't control the allocations and need to take what gets fed to them.

