Return-Path: <ceph-devel+bounces-3506-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5F8DB41755
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 09:56:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 789317B497B
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Sep 2025 07:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B2C2E03FF;
	Wed,  3 Sep 2025 07:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="nJrENByL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14E61E98E6;
	Wed,  3 Sep 2025 07:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756886158; cv=none; b=qE+nFRmdAdgk8KeW5BfkFdYX4q4IWLztPzJBDNyHwVMAElbuAsEdpfviphu9hBdmikQRry3ZV762k1vs7aHunyzaPL8aSvGFc3FLwOeheMMAUzcjH30SW0Odm3qvMUdV1mZAodEL2Juj9IIP4FArjrNNMq1koFEBa8BFkkRRKfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756886158; c=relaxed/simple;
	bh=s56ODqA+peudh7JXuPiVnjfNCTTLMukqjkCKX1xnu3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0o/EIfsl7kSPuthPNPHW5T9ibt9Sbi71axNLMCqKme9ij72+brZEzyDV9/rW3UNOmoJqPjVhbCM6FCcsYj6TfJzPhhiiuPkK+NnLOcBji0jDsoyfV96rTOCU+FU0760DfmHQXLHpg032DVma6ei9eAeEJqC2mPV0Q6jeSbl1Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=nJrENByL; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hxpC5vy7Hx8U7Nfsd9dimVqBCq+OqiehMFxgIJnMKBk=; b=nJrENByL+pAsQDNf3yUh/Tt8KL
	XEtmfGPJoz/YRme8YYEoyO9/ZSPUXREsNr+N/K8VNmqOzMYUAKisthVa7m1INPcq9w8KTUS+Clmhd
	ZYi1G/1RofSDFYx0MOK0iWQBY11SR7iMXN4uurBtKuIDtEMgKGydOrrRI9aCJlRhup0rlAYIa53sI
	5+/FcUB234SidsXXhGmRLseHEp0B70OPGfTKCwCRv27WjWu4XTymUUcGDq0lxPt+oOJnYNJk9+VDo
	0zaFofn45/1B7Yt4uluKRCVTOpuKY+TkcUe3E1O+oIPDnv7MrIK9U+Qb18uBZf3E4VGGrNvMbRQXZ
	bUxJDrCw==;
Received: from bl17-145-117.dsl.telepac.pt ([188.82.145.117] helo=localhost)
	by fanzine2.igalia.com with utf8esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1utiLB-0065FM-Bm; Wed, 03 Sep 2025 09:55:37 +0200
Date: Wed, 3 Sep 2025 08:55:36 +0100
From: Luis Henriques <luis@igalia.com>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>,
	"visitorckw@gmail.com" <visitorckw@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	"idryomov@gmail.com" <idryomov@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] ceph: optimize ceph_base64_encode() with block processing
Message-ID: <aLf0eJcvCj9zcn-g@igalia.com>
References: <20250830132822.7827-1-409411716@gms.tku.edu.tw>
 <fce1adab2b450097edbcea3ec83420257997ec00.camel@ibm.com>
 <aLdcNhKrPXxaEUtm@visitorckw-System-Product-Name>
 <f4f33ae461e0f1cf2f28d1c22546bd67cd9c4da3.camel@ibm.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4f33ae461e0f1cf2f28d1c22546bd67cd9c4da3.camel@ibm.com>

On Tue, Sep 02, 2025 at 09:21:14PM +0000, Viacheslav Dubeyko wrote:
> On Wed, 2025-09-03 at 05:05 +0800, Kuan-Wei Chiu wrote:
> > On Tue, Sep 02, 2025 at 07:37:22PM +0000, Viacheslav Dubeyko wrote:
> > > On Sat, 2025-08-30 at 21:28 +0800, Guan-Chun Wu wrote:
> > > > Previously, ceph_base64_encode() used a bitstream approach, handling one
> > > > input byte at a time and performing extra bit operations. While correct,
> > > > this method was suboptimal.
> > > > 
> > > 
> > > Sounds interesting!
> > > 
> > > Is ceph_base64_decode() efficient then?
> > > Do we have something in crypto library of Linux kernel? Maybe we can use
> > > something efficient enough from there?
> > > 
> > Hi Viacheslav,
> > 
> > FYI, we already have base64 encode/decode implementations in
> > lib/base64.c. As discussed in another thread [1], I think we can put
> > the optimized version there and have users switch to call the library
> > functions.
> > 
> > [1]: https://lore.kernel.org/lkml/38753d95-8503-4b72-9590-cb129aa49a41@t-8ch.de/  
> > 
> > 
> 
> Sounds great! Generalized version of this algorithm is much better than
> supporting some implementation in Ceph code.

Please note that ceph can not use the default base64 implementation because
it uses the '_' character in the encoding, as explained in commit

  64e86f632bf1 ("ceph: add base64 endcoding routines for encrypted names")

That's why it implements it's own version according to an IMAP RFC, which
uses '+' and ',' instead of '-' and '_'.

Cheers,
--
Luis

