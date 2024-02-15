Return-Path: <ceph-devel+bounces-868-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F23DB8569F5
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 17:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 317C51C22140
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Feb 2024 16:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F4CC135A52;
	Thu, 15 Feb 2024 16:49:56 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B2413398C;
	Thu, 15 Feb 2024 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708015795; cv=none; b=CBo2edYnk4MnSuRK8IKoFliavQJHp+mIEoJ8zUko1pJ7nUeCDuxBCuXb22xNAVynlLyX9GyBFF/NlYVJv4FYCBSUVq90B4A+cFUYCQ0xJRnn63x1HS71nSHrdGbcp5BSECse7agYLYPqd/r1+gOcTy1QP1aLd3LzmcerZ8qkjNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708015795; c=relaxed/simple;
	bh=TE3D8fpad8zNmWgzvvTXnh84sY8vAJE16zBniS9sU/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESvPHIw7QxDldU1Sx/gOwnWyls9HglKQRvrhDjNDcihJgAyOSLnBH05PS2QiMH9ArOoC71ff24BAjinPpvMR2Uy1M/v/FQ3TKbh9LUUDtmVjuhaojoBizCCW7cQtiyHuJqsYf/ufAEBFdcXeHsXpfc4BJgZ/j0x8UayLQxJvgag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CE1C468B05; Thu, 15 Feb 2024 17:49:42 +0100 (CET)
Date: Thu, 15 Feb 2024 17:49:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
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
	Alex Dubov <oakad@yahoo.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	linux-block@vger.kernel.org, nbd@other.debian.org,
	ceph-devel@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 17/17] mmc: pass queue_limits to blk_mq_alloc_disk
Message-ID: <20240215164942.GA19722@lst.de>
References: <20240215070300.2200308-1-hch@lst.de> <20240215070300.2200308-18-hch@lst.de> <CAPDyKFqPnC9jwWnoVz+UVJJ_SGYnB4CrB8jmJOSxCnT7AYQrKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFqPnC9jwWnoVz+UVJJ_SGYnB4CrB8jmJOSxCnT7AYQrKg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 15, 2024 at 05:40:37PM +0100, Ulf Hansson wrote:
> Looks like $subject patch, patch11 and patch12  have already been
> queued up as they are cooking linux-next. Normally I prefer to funnel
> these via my mmc tree, to avoid potential conflicts (mostly for mmc,
> where more active developments are ongoing).

None of this is in my fresh linux-next pull, which would be rather
surprising anyway as I've just sent them out and Jens isn't that
quick to merge unreviewed series :)

That being said it depends on prep patches in the block tree and thus
I'd prefer merging this entire series through that tree.

