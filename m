Return-Path: <ceph-devel+bounces-3514-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85B12B42FC2
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 04:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C9261B21793
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Sep 2025 02:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 530091DE2D7;
	Thu,  4 Sep 2025 02:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sakjn+pl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0125F18E377;
	Thu,  4 Sep 2025 02:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756953143; cv=none; b=RBTfLsimsdyYNn+h7aPsInPCKZQkDBWisvr+yET4kKo7gkLX74jgWAvzqC/oRle9SeQw5qT0NpWtZHsNuKOmQeaZ++DWOUFojxr4mh5U2S2ax/qW+wteW2UcKLuWhzOhneB+oS1FqoQijtp/u9kzm0HvHJA7HXTlsciCZoVtCh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756953143; c=relaxed/simple;
	bh=d1HX5kbdii01Il8BhF3SgrCUJovaRc+a+uD95Y4ZCNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvW/F4JC2ohd7ofpyx/uny6J76bY8pjpTUj7PcmW74+KSD6ELPKor4ajIp/jJ15PMfzavZPTlGynQpiGVXfXveeIcb7WYoi3zEgEAIHUZb5DQLOmRIxi8qq0UPTepBp4FSYIGSdQo62PEmTPmx+glQ77Yj77IpxhZ5YtDvjhT8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sakjn+pl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619ACC4CEE7;
	Thu,  4 Sep 2025 02:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756953140;
	bh=d1HX5kbdii01Il8BhF3SgrCUJovaRc+a+uD95Y4ZCNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sakjn+pllfL0vg0o8Vgx2SKyf0chSnFJW0yZNCX0qGlCj/oXndkOb/DUbxs6WwDqm
	 ZoBP5dzYiFlCFXS2EVuyqkyDWBU5tXuq+DKDXumW3apn/LlJFf+Z4hNRuAE1gYMz8c
	 bOfevbI2dVjvv58zfJ1USfobSqJvt5Xzxj7FgWo1O8aggJTjBIZkPjF+C13mqMP+sB
	 +4yHOf+dPHpPn2Dc2yJwFcIuzO2CVi1RI+LVTqHuOTAveWEIa0CZT11PKbiZHj8dFq
	 pen71qiCbb6mKTZpVcwTKDt/VAPt69YRM2s9HHFXl37E52g5MvwvYW1L4Tnzj12xdS
	 KxErBZ3kR5bIA==
Date: Wed, 3 Sep 2025 19:31:10 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: ceph-devel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libceph: Use HMAC-SHA256 library instead of crypto_shash
Message-ID: <20250904023110.GB1345@sol>
References: <20250731190227.16187-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731190227.16187-1-ebiggers@kernel.org>

On Thu, Jul 31, 2025 at 12:02:27PM -0700, Eric Biggers wrote:
> Use the HMAC-SHA256 library functions instead of crypto_shash.  This is
> simpler and faster.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/linux/ceph/messenger.h |  4 +-
>  net/ceph/Kconfig               |  3 +-
>  net/ceph/messenger_v2.c        | 77 ++++++++++------------------------
>  3 files changed, 26 insertions(+), 58 deletions(-)

Looks like this patch hasn't been applied yet.  Can it be taken through
the ceph tree?  Thanks,

- Eric

