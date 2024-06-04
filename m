Return-Path: <ceph-devel+bounces-1263-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6C88FB617
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 16:50:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EEA91F27594
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2024 14:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573651527AA;
	Tue,  4 Jun 2024 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4L/sFM8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD7415250C;
	Tue,  4 Jun 2024 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717512146; cv=none; b=bxnJLQ+FpAdnidIFjLIlZ/QXsvCCBCQ2cBc/e8NhsgLOCC1r8EwUY6yDRrz3fJ7lRLqzv88SONpVKjHHJVgyL7o5iLVw4/heXKQ/ZQZ82Vdg13zb7+aa2B5mmiK0CfdhuzkmIkNrNaiCBaotFgAIpDACvecwF8fdKWUiAvSTmLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717512146; c=relaxed/simple;
	bh=fmlRiz5M5NjXBFuEtUQcEwmSqlNPoKCDWdQmvJU2bn8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFef4EKPFv3FJj/mi6+HxkutsUkVsXBVDPB36bkM00VUWnrRtziUIvpK7zJGSI7An7n8IQWn7EaawKzAnGbwbTrMmNfVepplW0RbEw5ZDmpoqlZ90MTfYWEnms+0aT/D05VutT29oOR73/6HzbvSx+syr1DCLtJ+f5sRmNyxciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4L/sFM8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9731AC32786;
	Tue,  4 Jun 2024 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717512146;
	bh=fmlRiz5M5NjXBFuEtUQcEwmSqlNPoKCDWdQmvJU2bn8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n4L/sFM8i0oFnDH7F8EaDAMFQuuQh8PoG7QQq1M8IxZeajDv8ixPlzS8RP5O5WSbo
	 fx1EtGxLjwFmVcfA7L6XJ9nj159hlyDZMc5x3Rop05fJhMF0pnorbMylNaXque9krv
	 nRofPSsBjJTBD+bxZ5P7AhVAicmfaTkOKshWmMLUxvyDRcPKU89n/WuKiFwbnGnmhg
	 7nCXXoiTqNiZjM8rwLtJ/ZsklEk4PWnKZZJZr8AwL96O1R3jn01o0gIHPfx3nzAUpc
	 gjuPAWdnyLbyguqM/uXLIwcHdQYnVguuAoMNTsqVxMHwDWIVHTh0ulOUvJoNsydamC
	 Bk9alCkb/mfng==
Date: Tue, 4 Jun 2024 07:42:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Ofir Gal <ofir.gal@volumez.com>, davem@davemloft.net,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 netdev@vger.kernel.org, ceph-devel@vger.kernel.org, dhowells@redhat.com,
 edumazet@google.com, pabeni@redhat.com, kbusch@kernel.org, axboe@kernel.dk,
 sagi@grimberg.me, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 0/4] bugfix: Introduce sendpages_ok() to check
 sendpage_ok() on contiguous pages
Message-ID: <20240604074224.44668dab@kernel.org>
In-Reply-To: <20240604043041.GA28886@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com>
	<20240531073214.GA19108@lst.de>
	<20240601153610.30a92740@kernel.org>
	<20240604043041.GA28886@lst.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 4 Jun 2024 06:30:41 +0200 Christoph Hellwig wrote:
> On Sat, Jun 01, 2024 at 03:36:10PM -0700, Jakub Kicinski wrote:
> > On Fri, 31 May 2024 09:32:14 +0200 Christoph Hellwig wrote:  
> > > I still find it hightly annoying that we can't have a helper that
> > > simply does the right thing for callers, but I guess this is the
> > > best thing we can get without a change of mind from the networking
> > > maintainers..  
> > 
> > Change mind about what? Did I miss a discussion?  
> 
> Having a net helper to just send some memory in the most efficient
> way and leave it up to the networking code to decide if it wants
> to use sendpage or sendmsg internally as needed instead of burdening
> the caller.

I'd guess the thinking was that if we push back the callers would
switch the relevant allocations to be page-backed. But we can add
a comment above the helper that says "you'd be better off using
page frags and calling sendmsg(MSG_SPLICE_PAGES) directly".

