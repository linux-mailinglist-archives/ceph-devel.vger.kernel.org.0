Return-Path: <ceph-devel+bounces-1215-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F0DA68D5B7E
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 09:32:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E4E41C21876
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2024 07:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FFA74045;
	Fri, 31 May 2024 07:32:23 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68115588D;
	Fri, 31 May 2024 07:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717140743; cv=none; b=daGsr+gjKMZaP3gkbuBrJXV8/gpXicq6cd4rVZ+qUVln78JzjRjckwAdzfy+qIGYWPHBISnQMIApTdMZLcV/xPzAwPbvoHjWLssmE5sqtiUxQhQCIaYjpU1pcxwmxukAbAM9vuZffPLmj2MqPeNIdoFFhJ7MRQVFQIo4vvpbj44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717140743; c=relaxed/simple;
	bh=prvFo1QmkAuBtaYZafOU/65r2uSc+CLjjoRQJfADFVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnV6PE2LDo41uBDJVA2ZctjBOVxckwP1WOBSFMBe48F3p/Hm6SYwJG5+C6kI705v6JKJxaFEhSSYyf03D7XNyNWYzh21/EudEmTsB5DiMH5/1a3v4XbScQU8R12wpUQGcz+zJrxdUSRPpfJzwMTBYv+p7B2vXKVYEs8H4UFCung=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 61B1F68BEB; Fri, 31 May 2024 09:32:15 +0200 (CEST)
Date: Fri, 31 May 2024 09:32:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
	ceph-devel@vger.kernel.org, dhowells@redhat.com,
	edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org,
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com, idryomov@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Message-ID: <20240531073214.GA19108@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530142417.146696-1-ofir.gal@volumez.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I still find it hightly annoying that we can't have a helper that
simply does the right thing for callers, but I guess this is the
best thing we can get without a change of mind from the networking
maintainers..


