Return-Path: <ceph-devel+bounces-3214-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90833AE82FF
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 14:45:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0AFDC1BC7BF7
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 12:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C562609C3;
	Wed, 25 Jun 2025 12:45:08 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D5526059D
	for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 12:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750855508; cv=none; b=G8AVdX2sCUVxrwY+E2eSDzeF7TzcPmD+UuxVsxj7P4N0k5FC3eF9U/r6dUul3AlUd7kVu8yq08xDuMUDArbUqOEf3XgudFrHMMEm4FjGer6AONxJwZS8Vf4ObMQ1n+p/n41vfSe3Q89ZhO+QjUSDb5J5sochnVcE0XEMkMmeUH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750855508; c=relaxed/simple;
	bh=U6MI2PdJBFWRH5pUrWIaLIFI8PrLyw/SMKOxte+tblQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SgozrX5266O+5AqY50MYsE9z10Du1OAXDcxIqnTOask/DFe0ickSxK034TBkwLV1Wo6WtqKlFt1/EtMyG01VJqEGJ29+8Cd0S6pWO4jxGyRBbifYO1Kk+WwUVbk3ooY+LH188ZtyBLDw3GuFXptdpOcAu5h1NYf+d9MRnzzz+j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from trampoline.thunk.org (pool-173-48-82-219.bstnma.fios.verizon.net [173.48.82.219])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 55PCijuO005260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 08:44:46 -0400
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 067412E00D5; Wed, 25 Jun 2025 08:44:45 -0400 (EDT)
Date: Wed, 25 Jun 2025 08:44:45 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Simon Richter <Simon.Richter@hogyros.de>, linux-fscrypt@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <20250625124445.GC28249@mit.edu>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
 <20250625063252.GD8962@sol>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625063252.GD8962@sol>

On Tue, Jun 24, 2025 at 11:32:52PM -0700, Eric Biggers wrote:
> 
> That was the synchronous throughput.  However, submitting multiple requests
> asynchronously (which again, fscrypt doesn't actually do) barely helps.
> Apparently the STM32 crypto engine has only one hardware queue.
> 
> I already strongly suspected that these non-inline crypto engines
> aren't worth using.  But I didn't realize they are quite this bad.
> Even with AES on a Cortex-A7 CPU that lacks AES instructions, the
> CPU is much faster!

I wonder if the primary design goal of the STM32 crypto engine is that
it might reduce power consumption --- after all, one of the primary
benchmarketing metrics that vendors care about is "hours of You Tube
watch time" --- and decryptoing a video stream doesn't require high
performance.

Given that the typical benchmarketing number which handset vendors
tend to care about is SQLite transactions per second, maybe they
wouldn't be all that eager to use the crypto engine.  :-)

    	     	      	      	     	      - Ted

