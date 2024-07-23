Return-Path: <ceph-devel+bounces-1546-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65EE4939793
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 02:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0ED4A1F22245
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 00:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA103131732;
	Tue, 23 Jul 2024 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ip1viDcW"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A6130AF6;
	Tue, 23 Jul 2024 00:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695565; cv=none; b=VGtnIBabXx7pn5vXFckLHhdCwtm2xxBRSo1TZamyVqOhmlJXA2c9Wc1jnhgsWP9IbeGgVORwRWGTUeBtn2zcC+UfuQuiw48ym/AlsLcCPUVTSTo9zT9rJvfNJ0eaPLQE1iQhExCpDLvJ4DfadmsbKM+gznN/BX799BWtNTLpp6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695565; c=relaxed/simple;
	bh=HKx7wPs7b7QPHMuQbYeVTG9h9TBUySKj97W9ZT0Ui0c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnKq0y/KHo9oTqjepPBM/oWXAi0zQ+6LXCs1LPX7zabbuJZY0HPlyvj6vZE8gkfGSCIMs1vKtsMP6ddAKteA+m14AUB7CvGnts+UUXjX9Bgp2qmbwKcB9zkhd5QgAqVw0aZL1W150IjQtjPPHRcrKzN439nirgv1/WzUQrFzCdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ip1viDcW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8252C116B1;
	Tue, 23 Jul 2024 00:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721695565;
	bh=HKx7wPs7b7QPHMuQbYeVTG9h9TBUySKj97W9ZT0Ui0c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ip1viDcWaSjKqoYTdz3UQLSXT7PJajQPTVUsUiYEDGIDN1MbedUq5D3fFRCkGIZKg
	 WInHaCAf+JGIwnPQc5oz3J2OegfOUReTqNHWT29Ln8C0Y44Ba8vvEf+q8MUvXjkRIU
	 uthxFtTJUBFMMtzJquCR0aESi6/zqZNRRaiaR/mgNdjMmRBR1dyQu1yLp+Uk1i2+AU
	 tGMWL58dS3RoydwI2GT+WY7aJJrZ8fz5XMCuNBlF1x29v0BdeRZsqucz6UfReFZQkM
	 kTjnYvjZf3TaVb+JcTjFkVQyaxOkw2CqPPZFAqhUEXfCLYtO88lbM58lh1ucN3tqZE
	 Fm52rSbhxZdbw==
Date: Mon, 22 Jul 2024 17:46:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com,
 edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org, hch@lst.de,
 sagi@grimberg.me, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 0/3] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Message-ID: <20240722174603.048fc4d8@kernel.org>
In-Reply-To: <20240722174548.404086ec@kernel.org>
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
	<0cc50a53-fd8f-433d-bb69-c9d3f73ceace@kernel.dk>
	<20240722174548.404086ec@kernel.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jul 2024 17:45:48 -0700 Jakub Kicinski wrote:
> On Mon, 22 Jul 2024 16:21:37 -0600 Jens Axboe wrote:
> > Who's queuing up these patches? I can certainly do it, but would be nice
> > with an ack on the networking patch if so.  
> 
> For for it!

Go..

