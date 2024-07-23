Return-Path: <ceph-devel+bounces-1545-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BC32B939790
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 02:45:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 791671F22276
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2024 00:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B2891311AC;
	Tue, 23 Jul 2024 00:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vEx8pyTp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA676130AF6;
	Tue, 23 Jul 2024 00:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695550; cv=none; b=efFhi0JBwckqLYpdW9rBeRGldQ8O67L25OH0QzOnk7qazC9SGxmchlzbnmNBWGP37rxYe1QaSy6ThNfNmVqudibYmIJEI8cFSIsm3zHTyFLSo++x9maDZiCtIM23VHKrV12So5WYtPs0zJdSOOqnrJ8e+oWBkX+si4/BDSfY28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695550; c=relaxed/simple;
	bh=GkJYFDmi++srkAyLAt3+Jwc6GNdjUpaQfArvFb/GpQk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VB7LQ+XBTlc8ZXNH9me8+wzOlPIOESNVXgHNBSuEyy2zNimYBI87SHiU9k/OdKgYIT0hnE/JMVtOwQKRO/4SFCMAqtiqYfwIxeayyVoe3BjQMY/VnRmxYd+SzcuMkPzk6OYYfPa7799X3aIUZ+3idwwlfOuabm4Rx5dQxJLmMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vEx8pyTp; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31930C4AF0A;
	Tue, 23 Jul 2024 00:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721695549;
	bh=GkJYFDmi++srkAyLAt3+Jwc6GNdjUpaQfArvFb/GpQk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vEx8pyTpm7Ry0LvK3iONtB7g7kb2ORTSzy+SDxKk49cxZRaujmCT/7aQtqlOkhjBK
	 E6CZFTqexYw7xRRjcDtZWd77N7zBxdpXdGX36CS5qA+aVlI9IFZT1n0hvSp62Pi6WJ
	 92NdmP8ZR9S463RHLqddVNfiN5h80Tr+5jQXIgakmdV5sy/bq07Nhf1onLCDVwLwzT
	 7Scr2iiWlsgWxU5Zjz5QGupora2UCK/RxbISOI3quDw/1Au8229TtgciflnVXmWxWk
	 TO8JLkEnH+0C0h6PraGxV3Uve8ElkseriFjFdqrHYCSw3fgcOjYWzLbepXh4tsmFbt
	 pZZVogBof4GaA==
Date: Mon, 22 Jul 2024 17:45:48 -0700
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
Message-ID: <20240722174548.404086ec@kernel.org>
In-Reply-To: <0cc50a53-fd8f-433d-bb69-c9d3f73ceace@kernel.dk>
References: <20240718084515.3833733-1-ofir.gal@volumez.com>
	<0cc50a53-fd8f-433d-bb69-c9d3f73ceace@kernel.dk>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jul 2024 16:21:37 -0600 Jens Axboe wrote:
> Who's queuing up these patches? I can certainly do it, but would be nice
> with an ack on the networking patch if so.

For for it!

