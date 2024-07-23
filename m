Return-Path: <ceph-devel+bounces-1544-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD3993978D
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 02:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB7E282934
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 00:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E624130A76;
	Tue, 23 Jul 2024 00:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHV8tTO5"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162C130AD7;
	Tue, 23 Jul 2024 00:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695540; cv=none; b=MMCDQ90nVlGIMNMegvr5tncHoiquPeFxxvJ+w7aRAjWjIPzDnQW4Hqzy3cCSeZqRQfMX/lvxE5P7Y0ZmRCfKIJvqKdlfpnQj5jZeV5HGXfaYj+42nOB5qXltI4Ta4pIvXYPugL9ewG5HfyffqHKz+GwQXkSTCDKZOoyFVVQoYqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695540; c=relaxed/simple;
	bh=UFq8TD0aNOJmVzfMqq4NoRuO6kLMdPZWR9goKFLapXs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SipHxYn00uU+dHo/3kC5jIF8ijsurjk6LtzzRo/z2p5x5hz3F3PZ1VbXnu/qhCxbTOv9rJ0Yz8zLH7K0TcRt7pJSSDUwtcbBaNhtSUwEi3Row1GuKkUWktH8zzShY2mawtbUYyWIuGYo92L23bFiMNLTzQqHSTuEwRIGAahWf0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHV8tTO5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2308CC4AF0E;
	Tue, 23 Jul 2024 00:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721695540;
	bh=UFq8TD0aNOJmVzfMqq4NoRuO6kLMdPZWR9goKFLapXs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aHV8tTO5tkp8k5YT+4PsPbZ1X9n9IBb48I3ONpPaTeA+6FpuYASA27MvO46bLyhpa
	 EigO2+jSm7ZvvEUkNIuSq9/E1JoOHwD+pqKM0xYTaDS6O776Sepa3E+ho9theTTNjG
	 Te1Juhp+iBU9kWPsSiQpOlhk5Ligr29K1Rp6ypl1l1/GESJhVIXPNHFaeY4lEHld9g
	 Z/KAPtU4ZSFscIQg7mbxZQVkU7V8IgdlBArLFbFF6AbWmJiJs1I2+fAKcy3DahRsEs
	 D7JnfyCcuna5FP+93Qj8LnIEZ8HJRYvgyAQtaTveTVYaFB20jqrTplWHJQhytwfv2I
	 yawbUrMSzFmSw==
Date: Mon, 22 Jul 2024 17:45:39 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 1/3] net: introduce helper sendpages_ok()
Message-ID: <20240722174539.461bd2dd@kernel.org>
In-Reply-To: <20240718084515.3833733-2-ofir.gal@volumez.com>
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
	<20240718084515.3833733-2-ofir.gal@volumez.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Jul 2024 11:45:12 +0300 Ofir Gal wrote:
> Network drivers are using sendpage_ok() to check the first page of an
> iterator in order to disable MSG_SPLICE_PAGES. The iterator can
> represent list of contiguous pages.
> 
> When MSG_SPLICE_PAGES is enabled skb_splice_from_iter() is being used,
> it requires all pages in the iterator to be sendable. Therefore it needs
> to check that each page is sendable.
> 
> The patch introduces a helper sendpages_ok(), it returns true if all the
> contiguous pages are sendable.
> 
> Drivers who want to send contiguous pages with MSG_SPLICE_PAGES may use
> this helper to check whether the page list is OK. If the helper does not
> return true, the driver should remove MSG_SPLICE_PAGES flag.

Acked-by: Jakub Kicinski <kuba@kernel.org>

