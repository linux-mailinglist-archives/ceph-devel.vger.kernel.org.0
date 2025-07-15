Return-Path: <ceph-devel+bounces-3318-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50F5AB05189
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jul 2025 08:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C820A7A7EFB
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jul 2025 06:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8009F2D375A;
	Tue, 15 Jul 2025 06:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sNYuvV1R"
X-Original-To: ceph-devel@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA025C81F
	for <ceph-devel@vger.kernel.org>; Tue, 15 Jul 2025 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752559807; cv=none; b=k0+hLfWFOnWcMYN5V/A33UG5Ocp6Moh4QYEoyqXRFLwtchTuzWJQOG1CNKqzTsakgdv1ull7XeRtMfqCmyaOQmcm8oDeR2SZbr+g6OJTvuFbSjSS5brHhbeVitWeNAvE98IeFjSPuZJ4QBGnB2RzwmW7BE18onI9N7OMvUNKXPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752559807; c=relaxed/simple;
	bh=f7fN8JqB0BdD/Ftv/9MXBPnmnQcdzNxqGAHPPY9scus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oUJMVre5bYg351bQBHZJwf6pMefo9kDzxpvn0OxYuYmpyXNXTdsovoG+t+JojnC5U1QlKjd2CUlwrCrC/tetO7gpQaWCctvZ95LzNEeYQf6ZKpH9FQiXOUveSMjZf0hpY3oTJHyVPYJxVLF5MOexaXxl3tlNgmHGcmSMLIEzV3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sNYuvV1R; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xz2GLmgvReeKjErUkW1mHM3DWQa0LXilqMoaa5kelzo=; b=sNYuvV1RR+/8HZAv2+9HTxVoB8
	ioUqNydP5KUuj/QjT9zt7L9C3jh/D7fGenWUAh+Bt5s7dLvA0DaMWb0/vm8kN1sGzmBUTCdxCwENM
	SBBVf9DE2B4eAlg9TgTiP8TtdB1pJvRTelozRFH089KrCq9k23hpclbztZxLiQ9iv8sC9Rt5Zsm1P
	DhlhsQZQ6Wj/QoU4c1znccWcoafiLKoJ7RwgMghbKRROM8MlQb5YA1gksiSbFwCauh8qnRenR0Srh
	Dm5nGcdRdV1BJLoFQrVbs4U+eSTAC0zHAIKsqHD3TxWZiKZoIA/BRAK82pCEyVwK9575KETdTs07F
	A2hIuI2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ubYrd-00000004BMt-1HK1;
	Tue, 15 Jul 2025 06:10:05 +0000
Date: Mon, 14 Jul 2025 23:10:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: discarding an rbd device results in partial zero-filling without
 any errors
Message-ID: <aHXwvbXUOCXnJCsZ@infradead.org>
References: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMym5wv+R8Wu8-jXkEX9fN7tgKzh_SjpPnDkbKFwjgUfjw83+w@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jul 11, 2025 at 11:36:07PM +0900, Satoru Takeuchi wrote:
> Hi,
> 
> I tried to discard an RBD device by `blkdiscard -o 1K -l 64K
> <devpath>`. It filled zero from 1K to 4K and didn't
> touch other data. In addition, it didn't return any errors.

So it behave exactly as expected.

> IIUC, the
> expected behavior
> is "discarding specified region with no error"

Which is exactly what it did.


