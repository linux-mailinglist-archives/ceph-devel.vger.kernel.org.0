Return-Path: <ceph-devel+bounces-1246-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91CE68D728B
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Jun 2024 00:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C2741F21B34
	for <lists+ceph-devel@lfdr.de>; Sat,  1 Jun 2024 22:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E74EF2D60A;
	Sat,  1 Jun 2024 22:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRMX44sv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F84817CD;
	Sat,  1 Jun 2024 22:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717281372; cv=none; b=RwIslEvtXKN8DVjEm3qexQluDFjBB5kKhwhlkB3Gs97F1P65CEKvBLxND1dydn+CYzXGuczx/ZV/tqUsNuon6rO4AduquA5TO+ncdm2IOiEtW91jNsxVthCtXYJhXmTGCAn1pSbGD0wChwN6H1zhvtn1lEx9uByeo5jZypaUcDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717281372; c=relaxed/simple;
	bh=4tWNO49yRaxUSn0/n0YaA8EXqphEBZlHly9o1vpDrpo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxr80/SLOdABdKqbkGP6A2DjH1Bbxls6K4TfBn56DKEwHdg2iVJCBZK62JTrujWSYw/hISZ7UmDZNVYu23nqmXIy7u572VVA+8Jarj3w6YNM5gOYLjBkikeBrXhXkTHftcFCvd8M88Iut0O6FxP/OGYxch++BCA+KvwfFYRDMU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRMX44sv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44769C116B1;
	Sat,  1 Jun 2024 22:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717281372;
	bh=4tWNO49yRaxUSn0/n0YaA8EXqphEBZlHly9o1vpDrpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HRMX44sv00rOCbSAF60lPGH3JRZzhEsoDNFeng5E6garNf7q6rEb+1GW5qvaSCCaU
	 UR7SHXGQZ1Ze5i1UOo4MLPW/aALT+oC93AFcPPBPXo7cKvdRuleZty+tvjcHoG/JC0
	 m4lkKezVuhfirWKmSWRFqFhaZgF1i8Dh82hiSbCpNR4BqAiOSStrCNTA05PQuaiDLL
	 3xecdOQiaikuyVm5SnmU6jUS9jB+N+GtO8wXtrrJr/DjUVx09q+PrFRSatxQDQqRYS
	 bAFjqMVinp/g+4iFnNcFP0tskVaGsMMxcLmT3n5PKQNqrUX9BcSHNC10ZnJH3yqjT/
	 LzIJTYpQF1fZw==
Date: Sat, 1 Jun 2024 15:36:10 -0700
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
Message-ID: <20240601153610.30a92740@kernel.org>
In-Reply-To: <20240531073214.GA19108@lst.de>
References: <20240530142417.146696-1-ofir.gal@volumez.com>
	<20240531073214.GA19108@lst.de>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 May 2024 09:32:14 +0200 Christoph Hellwig wrote:
> I still find it hightly annoying that we can't have a helper that
> simply does the right thing for callers, but I guess this is the
> best thing we can get without a change of mind from the networking
> maintainers..

Change mind about what? Did I miss a discussion?
There are no Fixes tags here, but the sendpage conversions are recent
work from David Howells, the interface is hardly set in stone..

