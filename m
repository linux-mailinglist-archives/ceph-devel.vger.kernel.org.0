Return-Path: <ceph-devel+bounces-1245-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3245B8D7288
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Jun 2024 00:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD0A4281EB0
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Jun 2024 22:34:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997D02BD1E;
	Sat,  1 Jun 2024 22:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qk6XOP7Q"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357E217CD;
	Sat,  1 Jun 2024 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717281273; cv=none; b=hIlQ2mJPaojQxHWcLVL7wA2ccExG/qC81NUMJkfm2lgNRhWuzCx9lHMaEE7XuV9jEE5mvdBhdlAQJtbODuQMY1/7iGGxS5kdkyh4buH41wuVObdfQlMtLFXpTYFbhQF82dx5jpXt8TG4fas8kV5YR6hjLDYBnOatUOlgYbC0eCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717281273; c=relaxed/simple;
	bh=/7RICJIhdkyAioWDSfVcToOPLi7N+lZhkwn9ZdLZwdk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UDMyJsc1vAOfPr1IcWLd0KOl0P/6h3OaQjcdeTMpc7vDSMRjrUoMJbmMxTBp8Qtq3HzogQ3V44F1xsbq5U/BIZHEtXaVGiv9Du+kwMMQFRAMJxQXy2XB7A4CuvoJs7ZHhtebSr8l8dZp5P534Tm9iMWubrD7iqMh6HZss5ieRHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qk6XOP7Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC77DC116B1;
	Sat,  1 Jun 2024 22:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717281272;
	bh=/7RICJIhdkyAioWDSfVcToOPLi7N+lZhkwn9ZdLZwdk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qk6XOP7QLxQvaJzodYjBXICKyCzfEgMKoWWU5SAiIbhOXBRMoPxzxtGW36qKFUYTY
	 /lgnajbB7HY9YMb/JuGjrMvoPQ5asrGNOcOtsPfFxEbxOahDO2ApTq3E5kzMs9u9+R
	 S3tmpAldw7pcUxWvJh0KGWS5YSMUyyCdSUoXi406ZHFVCnl6Ruua3qdN/iaUqLAsCC
	 Vd7vTTN1qfvuCS5KgZestXPC03BlHzd+Futp2/PA4hpbMRuL1os5Yglx/0q8dD5mic
	 /B94tN1RbmdJ/e9shnyaY/YQevuckGqbZEVsFdUSFvCVLIxaGJMMebvp0unYLGI6YK
	 zdfpZ3X8A/9Ow==
Date: Sat, 1 Jun 2024 15:34:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Ofir Gal <ofir.gal@volumez.com>
Cc: davem@davemloft.net, linux-block@vger.kernel.org,
 linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
 ceph-devel@vger.kernel.org, dhowells@redhat.com, edumazet@google.com,
 pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Message-ID: <20240601153430.19416989@kernel.org>
In-Reply-To: <20240530142417.146696-1-ofir.gal@volumez.com>
References: <20240530142417.146696-1-ofir.gal@volumez.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 May 2024 17:24:10 +0300 Ofir Gal wrote:
> skbuff: before sendpage_ok - i: 0. page: 0x654eccd7 (pfn: 120755)
> skbuff: before sendpage_ok - i: 1. page: 0x1666a4da (pfn: 120756)
> skbuff: before sendpage_ok - i: 2. page: 0x54f9f140 (pfn: 120757)

noob question, how do you get 3 contiguous pages, the third of which 
is slab? is_slab doesn't mean what I think it does, or we got extremely
lucky with kmalloc?

