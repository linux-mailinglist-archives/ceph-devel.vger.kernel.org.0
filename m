Return-Path: <ceph-devel+bounces-4112-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD33C84DDE
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 13:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE7CA34E150
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Nov 2025 12:06:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0E63164B1;
	Tue, 25 Nov 2025 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b="S6EBpEmx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [185.226.149.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0940E265CBE;
	Tue, 25 Nov 2025 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764072364; cv=none; b=OU4wR8ByYLajGSk5Ch2GjE6fVqeLtrF67WSPblHROSuxB7GSMaZ9S9ofy91cdXmGw1yCaVDlULVPuwyk9eYuGVeW+yKqGE3WpLdeg+QH2JP17PHdIJ3PSEcS20nsMlRZIkoetJ56Ssa/zxa2wqFS2uy5QopFRtto1DZonxxASB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764072364; c=relaxed/simple;
	bh=UF+A5wzFCeNiTZ1bxSFjWsz3Q0pRPQgsicXcxlit6cc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T+vARYJUAM2xqSJ200CkWwXSFs2PnaNWaEM2wxDm55oxOXedIZpdnN5o0UNf2mAF5HdOoY5JRb8t0262ZI5zaNW4IGbLDF949AROW+4ZorP4QODg81eHvoX4dv/9df8fhMGW0bnB6K+dgBft/xIOQiQhwZQnH5uoYg+2CKo9DF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com; spf=pass smtp.mailfrom=runbox.com; dkim=pass (2048-bit key) header.d=runbox.com header.i=@runbox.com header.b=S6EBpEmx; arc=none smtp.client-ip=185.226.149.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=runbox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=runbox.com
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vNrnw-006C3D-UT; Tue, 25 Nov 2025 13:05:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=YnfimGH31nyRXt64WZIw1dHDCPxGLzpBIw6iod9dyCc=; b=S6EBpEmxcVSLZyYFbjEHkluR3f
	EVrrqxgTzQZQmCk9DTNBQN+GhrNLKlziO5Cd36gt5AGRjFK9xLlGy4C30GDhgnfwjKOYwZdJJjhTt
	UounXywRoQ2JmHulphBUsGAKeNk44PjoNK7oc0EC2ArlshnPC1TK6sgnLNWbAvUHTXrtcjOvieDFo
	pozqyPIFbTHoNcGRAM6nKIdXwyJdD2q9gjRAmOR5l/9z0pW1mFoDUQRivY5sktiCRUoqkPJzyiTkd
	oo58wqPRfC6lWjhGv6tiEkQG6h7P/yz0naaoZx/G4K911EN1cOaHrBTNKp8p3COBAsmbSEmSM6HQx
	5YrEKS5g==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vNrnv-0007lA-ID; Tue, 25 Nov 2025 13:05:55 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vNrnl-00C2Cg-8t; Tue, 25 Nov 2025 13:05:45 +0100
Date: Tue, 25 Nov 2025 12:05:43 +0000
From: david laight <david.laight@runbox.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
 <idryomov@gmail.com>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling
 <morbo@google.com>, Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH v1 1/1] ceph: Amend checking to fix `make W=1` build
 breakage
Message-ID: <20251125120543.49107d8d@pumpkin>
In-Reply-To: <aSWCJhA3cNSEIUir@smile.fi.intel.com>
References: <20251110144404.369928-1-andriy.shevchenko@linux.intel.com>
	<20251125095516.40a3d57c@pumpkin>
	<aSWCJhA3cNSEIUir@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Nov 2025 12:17:10 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Tue, Nov 25, 2025 at 09:55:16AM +0000, david laight wrote:
> > On Mon, 10 Nov 2025 15:44:04 +0100
> > Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> >   
> > > In a few cases the code compares 32-bit value to a SIZE_MAX derived
> > > constant which is much higher than that value on 64-bit platforms,
> > > Clang, in particular, is not happy about this
> > > 
> > > fs/ceph/snap.c:377:10: error: result of comparison of constant 2305843009213693948 with expression of type 'u32' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
> > >   377 |         if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
> > >       |             ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 
> > > Fix this by casting to size_t. Note, that possible replacement of SIZE_MAX
> > > by U32_MAX may lead to the behaviour changes on the corner cases.  
> > 
> > Did you really read the code?  
> 
> I read the piece that prevents builds. The exercise on how to fix this properly
> is delegated to the authors and maintainers.
> 
> > The test itself needs moving into ceph_create_snap_context().
> > Possibly by using kmalloc_array() to do the multiply.
> > 
> > But in any case are large values sane at all?
> > Allocating very large kernel memory blocks isn't a good idea at all.
> > 
> > In fact this does a kmalloc(... GFP_NOFS) which is pretty likely to
> > fail for even moderate sized requests. I bet it fails 64k (order 4?)
> > on a regular basis.
> > 
> > Perhaps all three value that get added to make 'num' need 'sanity limits'
> > that mean a large allocation just can't happen.  
> 
> Nice, can you send a followup to fix all that in a better way?
> (I don't care about the fix as long as it doesn't break my builds)
> 

Perhaps -Wtautological-constant-out-of-range-compare should just be delegated
to W=2 like (IIRC) -Wtype-bounds has been which is pretty much the same test.

	David

