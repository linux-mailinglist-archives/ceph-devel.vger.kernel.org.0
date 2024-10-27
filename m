Return-Path: <ceph-devel+bounces-1988-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 897979B20A5
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 22:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D788B1C20957
	for <lists+ceph-devel@lfdr.de>; Sun, 27 Oct 2024 21:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E854D17C7BE;
	Sun, 27 Oct 2024 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="IxFVHPji"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21439383B1;
	Sun, 27 Oct 2024 21:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730062860; cv=none; b=sp5zSBAUD94PmwUVB6rtjyEKzW/dJXBChox6svzgUNJWV7mhpNJYFtfKFL7uANTSGP+NFNQR58NzK3MxqqElVVuA3azhj8r9srkkBNJkgLUuT3Lxaq6UvafZxl5c5M0emGG3AUUP2Z2s14FnBGmDT6fDVVGIKUmlMsSAjw7Iy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730062860; c=relaxed/simple;
	bh=c9UpbuLEyqapXKHXHiyLbtKcciMx1I4w3UxScbZeItI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyFJSID8h56AZli8En7ROaQl+bYYTzQdLamlg9mSBD5ioHEHHkKgtUBy+fVg33yHkVR8PO/OfFerEadIPs4rgtcrTW+LGGxmPYz5C1zz5iLuoPgDVeqhbZ+2jW0qxhaxvcv+5uBNrMcRAEo45Niwxe/9Vm4kHWvUYc6iA+5L+5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=IxFVHPji; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=PKxI0/VOQYWRLOBVduIwTeVISkuyWycw5GG77Ghthhw=; b=IxFVHPjifErstcW5
	rFuyl5u/1ej9/6ZgMBvmcs0EXpkLr2re0VrYZWiSByKuMRHjOcGtBkMYfE6ZxBWNKpxVw8dEnvi4D
	ufsUOs8jiBnUgUndSHR8Qh+p1e+PNPlSREi3uVJGLhf4q1k79a7yHBjJGAE0/vWPzVAomZHn8h5Yw
	nWldzXS2TU1TjieetjaiL8gvVg2uUhrL6i9+svcA/TkMMCm5u5bSbSdVVr8AA1xdEHrlc4e91wLL+
	x0EYvN0CxP75PC5vHZlOZUb9pIan9f91BRWX7svj/LCKeUJW3qJbbDQpoEBjn8VJ6MHd3vRPP6aYf
	B+qKrvvDvfOWkF3neA==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1t5ANb-00DoVI-1A;
	Sun, 27 Oct 2024 21:00:55 +0000
Date: Sun, 27 Oct 2024 21:00:55 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: xiubli@redhat.com, ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libceph: Remove crush deadcode
Message-ID: <Zx6qB75QaDqlEsi1@gallifrey>
References: <20241011224736.236863-1-linux@treblig.org>
 <CAOi1vP9au=SqKfmyD79YA3gCGOCj1FjLNJxtF9N_k0cafCJ3uw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP9au=SqKfmyD79YA3gCGOCj1FjLNJxtF9N_k0cafCJ3uw@mail.gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-21-amd64 (x86_64)
X-Uptime: 20:59:00 up 172 days,  8:13,  1 user,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Ilya Dryomov (idryomov@gmail.com) wrote:
> On Sat, Oct 12, 2024 at 12:47 AM <linux@treblig.org> wrote:
> >
> > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> >
> > crush_bucket_alg_name(), crush_get_bucket_item_weight(), crush_hash32(),
> > and crush_hash32_5() were added by commit
> > 5ecc0a0f8128 ("ceph: CRUSH mapping algorithm")
> > in 2009 but never used.
> >
> > crush_hash_name() was added a little later by commit
> > fb690390e305 ("ceph: make CRUSH hash function a bucket property")
> > and also not used.
> >
> > Remove them.
> 
> Hi David,
> 
> The implementation of the CRUSH algorithm is shared with userspace and
> these functions are used there (except for crush_hash32_5() perhaps).
> They are all trivial code, so I'd prefer to keep them for convenience.

OK, no problem.
(Although perhaps an ifndef __KERNEL__ might save a few bytes?)

Dave

> Thanks,
> 
>                 Ilya
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

