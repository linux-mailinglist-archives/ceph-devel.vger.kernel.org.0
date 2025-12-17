Return-Path: <ceph-devel+bounces-4189-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40689CC6490
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Dec 2025 07:46:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E1E833032A94
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Dec 2025 06:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700B121FF2A;
	Wed, 17 Dec 2025 06:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b="Bq+rP4Bd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.haak.id.au (mail.haak.id.au [172.105.183.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EF33254AC;
	Wed, 17 Dec 2025 06:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.183.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765953979; cv=none; b=ZICT9hjueghwq9hz3oUqioAxjjZqcU+dh5wlpSTzYA553Nh2EoAbQWJvQ/EEWyD2iXrKYSANo4dGnaDrcebqnGhl/O5NXY2flPTTZKxv18y06AgqueFfW3BS0lGmyeq7qKUkLQhbTRAx7rVJaIc8VjQqRhdIukT0kS9V8jaIhu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765953979; c=relaxed/simple;
	bh=280i07e/ItBS7CG7rQyVCoITfkXg1EfLvXpcUJiFHHM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d4C+qVb1aGfFaUqYBGt0F2FggnEbPOv9p/tnewC3f2/Naw3SKLNn88qHTety3XkusV55Ag3nmpDRfIr1YZ2tMUG/Vigax/r8R/SMME9ZWiQV7jkCF1ObUB2UBgL0+fYnH4aeaX5sCb/M0yeS26nji6ov4i2jPqdD6aKPfFyT63w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au; spf=pass smtp.mailfrom=haak.id.au; dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b=Bq+rP4Bd; arc=none smtp.client-ip=172.105.183.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=haak.id.au
Received: from xps15mal (180-150-104-78.b49668.bne.static.aussiebb.net [180.150.104.78])
	by mail.haak.id.au (Postfix) with ESMTPSA id 485FE833B1;
	Wed, 17 Dec 2025 16:46:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=haak.id.au; s=202002;
	t=1765953965; bh=280i07e/ItBS7CG7rQyVCoITfkXg1EfLvXpcUJiFHHM=;
	h=Date:From:To:Subject:From;
	b=Bq+rP4Bd9Q0lpxsBfqqSsrFfi31VXWOqv+jhqvWA/PjjKEWulgt5OJtWXAfNBMVYy
	 eP6RyaqPEpikWCtfKYXTUA2B0z3+b9j+ofNISA+ErH0HCoYy92sAtt3yXyK2nutB5B
	 kgIBve5pqfPjdfS5/ZZyYcRv43UignTt0VLj4fzOhheQrEfhhz0vO+UkeW3H5GrKKa
	 CaVdP7CuThx+3IvGLBRnYEwYZOFiW9tmNG9XJaIGa66ZKYNWhwGUzkKwo6JqhwgpSc
	 xL9CPv6Q50Ffg//PyDFqhaY/2XuNxqKmbPoF0GU+9SGW698GJk+yYFv+nBza2LbvJg
	 pY/URzXi9PnYg==
Date: Wed, 17 Dec 2025 16:46:02 +1000
From: Mal Haak <malcolm@haak.id.au>
To: "David Wang" <00107082@163.com>
Cc: "Viacheslav Dubeyko" <Slava.Dubeyko@ibm.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "Xiubo Li"
 <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "surenb@google.com" <surenb@google.com>
Subject: Re: Possible memory leak in 6.17.7
Message-ID: <20251217164602.563ddae3@xps15mal>
In-Reply-To: <12e9afa5.6f62.19b2ae4aaf2.Coremail.00107082@163.com>
References: <20251110182008.71e0858b@xps15mal>
	<20251208110829.11840-1-00107082@163.com>
	<20251209090831.13c7a639@xps15mal>
	<17469653.4a75.19b01691299.Coremail.00107082@163.com>
	<20251210234318.5d8c2d68@xps15mal>
	<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
	<20251211142358.563d9ac3@xps15mal>
	<8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
	<20251216112647.39ac2295@xps15mal>
	<12e9afa5.6f62.19b2ae4aaf2.Coremail.00107082@163.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Dec 2025 13:59:47 +0800 (CST)
"David Wang" <00107082@163.com> wrote:

> At 2025-12-16 09:26:47, "Mal Haak" <malcolm@haak.id.au> wrote:
> >On Mon, 15 Dec 2025 19:42:56 +0000
> >Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:
> >  
> >> Hi Mal,
> >>   
> ><SNIP>   
> >> 
> >> Thanks a lot for reporting the issue. Finally, I can see the
> >> discussion in email list. :) Are you working on the patch with the
> >> fix? Should we wait for the fix or I need to start the issue
> >> reproduction and investigation? I am simply trying to avoid patches
> >> collision and, also, I have multiple other issues for the fix in
> >> CephFS kernel client. :)
> >> 
> >> Thanks,
> >> Slava.  
> >
> >Hello,
> >
> >Unfortunately creating a patch is just outside my comfort zone, I've
> >lived too long in Lustre land.
> >
> >I've have been trying to narrow down a consistent reproducer that's
> >as fast as my production workload. (It crashes a 32GB VM in 2hrs)
> >And I haven't got it quite as fast. I think the dd workload is too
> >well behaved. 
> >
> >I can confirm the issue appeared in the major patch set that was
> >applied as part of the 6.15 kernel. So during the more complete pages
> >to folios switch and that nothing has changed in the bug behaviour
> >since then. I did have a look at all the diffs from 6.14 to 6.18 on
> >addr.c and didn't see any changes post 6.15 that looked like they
> >would impact the bug behavior.   
> 
> Hi,
> Just a suggestion, in case you run out of idea for further
> investigation. I think you can bisect *manually*  targeting changes
> of fs/cephfs between 6.14 and 6.15
> 
> 
> $ git log  --pretty='format:%h %an' v6.14..v6.15 fs/ceph
> 349b7d77f5a1 Linus Torvalds
> b261d2222063 Eric Biggers
> f452a2204614 David Howells
> e63046adefc0 Linus Torvalds
> 59b59a943177 Matthew Wilcox (Oracle)  <-----------3
> efbdd92ed9f6 Matthew Wilcox (Oracle)
> d1b452673af4 Matthew Wilcox (Oracle)
> ad49fe2b3d54 Matthew Wilcox (Oracle)
> a55cf4fd8fae Matthew Wilcox (Oracle)
> 15fdaf2fd60d Matthew Wilcox (Oracle)
> 62171c16da60 Matthew Wilcox (Oracle)
> baff9740bc8f Matthew Wilcox (Oracle)
> f9707a8b5b9d Matthew Wilcox (Oracle)
> 88a59bda3f37 Matthew Wilcox (Oracle)
> 19a288110435 Matthew Wilcox (Oracle)
> fd7449d937e7 Viacheslav Dubeyko  <---------2
> 1551ec61dc55 Viacheslav Dubeyko
> ce80b76dd327 Viacheslav Dubeyko
> f08068df4aa4 Viacheslav Dubeyko
> 3f92c7b57687 NeilBrown               <-----------1
> 88d5baf69082 NeilBrown
> 
> There were 3 major patch set (group by author),  the suspect could be
> narrowed down further.
> 
> 
> (Bisect, even over a short range of patch, is quite an unpleasant
> experience though....)
> 
> FYI
> David
> 
> >
<SNIP>

Yeah, I don't think it's a small patch that is the cause of the issue. 

It looks like there was a patch set that migrated cephfs off handling
individual pages and onto folios to enable wider use of netfs features
like local caching and encryption, as examples. I'm not sure that set
can be broken up and result in a working cephfs module. Which limits
the utility of a git-bisect. I'm pretty sure the issue is in addr.c
somewhere and most of the changes in there are one patch. That said,
after I get this crash dump I'll probably do it anyway. 

What I really need to do is get a crash dump to look at what state the
folios and their tracking is in. Assuming I can grok what I'm looking
at. This is the bit I'm most apprehensive of. I'm hoping I can find a
list of folios used by the reclaim machinery that is missing
a bunch of folios. That or a bunch with inflated refcounts or
something. 

Something is going awry, but it's not fast. I thought I had a quick
reproducer. I was wrong, I sized the DD workload incorrectly and
triggered the panic_on_oom due to that, not the bug. 

I'm re-running the reproducer now, on a VM with 2GB of ram and its been
running for around 3hrs and I think at most its leaked possibly
100MB-150MB of ram at most. (It was averaging 190-200MB of noncache
usage. It's now averaging 290-340MB). 

It does accelerate. The more folios that are in the weird state, the
more end up in the weird state. Which feels like fragmentation side
effects, but I'm just speculating.  

Anyway, one of the wonderful ceph developers is looking into it. I just
hope I can do enough to help them locate the issue. They are having
troubles reproducing last I heard from them but they might have been
expecting a slightly faster reproducer.

I have however recreated it on a physical host not just a vm. So I feel
like I can rule out being a VM as a cause.

Anyway thanks for your continued assistance!

Mal

