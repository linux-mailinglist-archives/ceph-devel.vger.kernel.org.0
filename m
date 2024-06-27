Return-Path: <ceph-devel+bounces-1504-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6F6491A301
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2024 11:50:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5EC801F2371E
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jun 2024 09:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6288013A895;
	Thu, 27 Jun 2024 09:50:00 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC0B7D3E3;
	Thu, 27 Jun 2024 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719481800; cv=none; b=bS9sVaW5CrrJKWpxxZy6/u/tDoLdpVPAtymNe3XCiAB2g+QfkeXbMfYNFYbdihzYW9bof4VXGVkaxQ/kt6j8z9syci84TJbuCJBDZhNvy/9T8NnptO2dI9cuaapbrxaEHYusT0efSkv40gOdukcyDM2kirppDOw9AEZowNoQpnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719481800; c=relaxed/simple;
	bh=kzf43A3ALBgL+2ssH2xTiGHqeASyyD/ZyRxF0gs9Bro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d6/nw/WpTZnhGIGsqubldqvClRTdsjzAYM1cqW78klSpZgNSm2eM5JK1Fc1zTl55iILVIDBQYBQMsLc3wDj8agz1EASNYi2g/3C7iMbvOBEhuwaamDBsc5Bos6UDI0kbkc63Ab+I/ck6QiIn84s9IIRDh0N/fh6Zof01q0B3t+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4527768BEB; Thu, 27 Jun 2024 11:49:50 +0200 (CEST)
Date: Thu, 27 Jun 2024 11:49:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Justin Sanders <justin@coraid.com>,
	Denis Efremov <efremov@linux.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Geoff Levand <geoff@infradead.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, Ming Lei <ming.lei@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	linux-block@vger.kernel.org, nbd@other.debian.org,
	ceph-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 17/17] mmc: pass queue_limits to blk_mq_alloc_disk
Message-ID: <20240627094950.GA30655@lst.de>
References: <20240215070300.2200308-1-hch@lst.de> <20240215070300.2200308-18-hch@lst.de> <89164197-7218-4f24-bf24-0e67a1882c78@nvidia.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89164197-7218-4f24-bf24-0e67a1882c78@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 27, 2024 at 10:43:24AM +0100, Jon Hunter wrote:
> We have just noticed that since Linux v6.9 was released, that if we
> build the kernel with 64kB MMU pages, then we see the following WARNING
> and probe failure ...

The old code upgraded the limits to the PAGE_SIZE for this case after
issunig a warning.  Your driver probably incorrectly advertised the
lower max_segment_size.  Try setting it to 64k.  I would have sent you
a patch for that, but I can't see what mmc host driver you are using.


