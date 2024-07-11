Return-Path: <ceph-devel+bounces-1521-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5746B92E9A8
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 15:35:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAEBCB2707E
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2024 13:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCF515FCED;
	Thu, 11 Jul 2024 13:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoYUAGOx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1132C15ECD6;
	Thu, 11 Jul 2024 13:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720704894; cv=none; b=qc0kDG6IYa4va0bmvWvCMg4WRgg7IuEUJKDxAt4aFIItSgx3xKOx6K15akecrET4UBpVfZv7qjE7GivgreP/m5qmVJCAfCbiI/tI3e380HleNLDexKLjBswsXuKExs+NdY46ULYFhAdL/ak2Xb9W5YsvRUZcgnE5+98dDFyEV50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720704894; c=relaxed/simple;
	bh=kajOBRfoA6WFVWgCgi1DP00EMj9Q8CGGNokxoWvBAKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uk5miI2nAc+22yPaQFyYVfDFtkhUj7aqI80ZKhaJL1JoKX3MLyxbIncsMEu0Sy7jM2QIjdlJf/xRU+RHJQa0s5LiFAFJeyT97R6q7FyIxNOZylRcf9jXIo1W+NIB8wvPqOx7hTitNgZwMkldVQCubLIQ6gJkXUXL9d1adI+0iug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoYUAGOx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A08AC116B1;
	Thu, 11 Jul 2024 13:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720704893;
	bh=kajOBRfoA6WFVWgCgi1DP00EMj9Q8CGGNokxoWvBAKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoYUAGOxovEwvOFVTpiiHPe9pP6oMN4ibUG5EpgEWVIKtG3kzIHCOKESD8txRJ9rg
	 3lgi7eKRbhFkdj8Gig0/qpg8ispPvDvCa2sjEX8F6VHy2bknHL2u3iOa/ZUNV2H/ga
	 qbaiXNMs+XnbXxSTGst1mxYdOHU1yZXDOl/2atxCcifAET3+vULaMRZ2k9Lo7x3dV7
	 KPwD0CnP+3DzhDeqEC+c1mDkHTXOvLKsBRkyrpI2TDUkGSKiD3tqcc1UaE+sSlAwHG
	 6UIvr7H2fZPpR350Ire+fyArY9CX+vEPSZTKEiPpeHLW84YSSAubIyKTVf7Wnth9uY
	 RHxpO9OW4fNNQ==
Date: Thu, 11 Jul 2024 14:34:49 +0100
From: Simon Horman <horms@kernel.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] libceph: fix crush_choose_firstn()
 kernel-doc warnings
Message-ID: <20240711133449.GF8788@kernel.org>
References: <20240710-kd-crush_choose_indep-v1-0-fe2b85f322c6@quicinc.com>
 <20240710-kd-crush_choose_indep-v1-2-fe2b85f322c6@quicinc.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240710-kd-crush_choose_indep-v1-2-fe2b85f322c6@quicinc.com>

On Wed, Jul 10, 2024 at 11:10:04AM -0700, Jeff Johnson wrote:
> Currently, when built with "make W=1", the following warnings are
> generated:
> 
> net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'work' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'weight' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'weight_max' not described in 'crush_choose_firstn'
> net/ceph/crush/mapper.c:466: warning: Function parameter or struct member 'choose_args' not described in 'crush_choose_firstn'
> 
> Update the crush_choose_firstn() kernel-doc to document these
> parameters.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>

Reviewed-by: Simon Horman <horms@kernel.org>


