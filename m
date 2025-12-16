Return-Path: <ceph-devel+bounces-4181-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AAFFECC13E4
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 08:09:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4916C3017654
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 07:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1970933B963;
	Tue, 16 Dec 2025 07:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b="fvxqVkPe"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.haak.id.au (mail.haak.id.au [172.105.183.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A033BBA4;
	Tue, 16 Dec 2025 07:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.183.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765868970; cv=none; b=rVOd/7bBPolcdMsK/CbG/tchpZYAGAhLL8yvaWRP76Idvcj4nv27e5lZFKzuA8hEgJ736SVrE63C+VgufVjeRiIBthjK7mWgL/sLKgIFOjjTvclHAE2edPSp8BP9jT3fN7oxExp33y9SQWAiua0/zhtT0SfRBDWk1fkqxNvKJiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765868970; c=relaxed/simple;
	bh=UOVHxpr0y8f19QHNbJVrr89DdZHVrZp7XC6XWzU4kdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vr2bLSn2jrF/h1bqEtfjX3GuPzrGDJs/JPs8SJl/j6t8bm3EgBlELvUcEolnF/1B0QlvtIlFVn1hVgiGTQ1H/dAlc+F+rFOqMc1HmAcSnLMbtQSRLCkKZBbJejrzTK3x0hbwuxMnjDYIWB/H6VUIBQhoVcUeeIyjyd3e/iD9uDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au; spf=pass smtp.mailfrom=haak.id.au; dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b=fvxqVkPe; arc=none smtp.client-ip=172.105.183.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=haak.id.au
Received: from xps15mal (180-150-104-78.b49668.bne.static.aussiebb.net [180.150.104.78])
	by mail.haak.id.au (Postfix) with ESMTPSA id D2539833DE;
	Tue, 16 Dec 2025 17:09:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=haak.id.au; s=202002;
	t=1765868962; bh=UOVHxpr0y8f19QHNbJVrr89DdZHVrZp7XC6XWzU4kdQ=;
	h=Date:From:To:Subject:From;
	b=fvxqVkPevBGHRySVehR1ktZ6p8/yKz3EaHXQgDDcqSYJT8Hg6zbbK0LYZW8tmtNl2
	 WXLcL93SwTlbiKCnwzUI61/ocjRl4O/vXQ8n2FbojeSpleh0C9epmwRDH278rh6Z0a
	 Aov+RgJie1KkrVgbnJ5xpj8K2fkR+GTu87YuP4nxwgRJxJ/d6u0TCJajafg5ssRJ5F
	 GxzoSYtD2g+cA2vP5ZHvf1Jwc/J3JGXuAqKqXNAHuMSMgZ5Kcxq3qH6OCzgLp6zIMu
	 Yz8ZwmfvOq3mNh2m6Vvh6nN09sHcYM97bDajSrvBZ2Kj+oGrE/4i+BApp/AHkpp98q
	 yu37jtYByv89g==
Date: Tue, 16 Dec 2025 17:09:18 +1000
From: Mal Haak <malcolm@haak.id.au>
To: "David Wang" <00107082@163.com>
Cc: "Viacheslav Dubeyko" <Slava.Dubeyko@ibm.com>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "Xiubo Li"
 <xiubli@redhat.com>, "idryomov@gmail.com" <idryomov@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "surenb@google.com" <surenb@google.com>
Subject: Re: Possible memory leak in 6.17.7
Message-ID: <20251216170918.5f7848cc@xps15mal>
In-Reply-To: <63fa6bc2.6afc.19b25f618ad.Coremail.00107082@163.com>
References: <20251110182008.71e0858b@xps15mal>
	<20251208110829.11840-1-00107082@163.com>
	<20251209090831.13c7a639@xps15mal>
	<17469653.4a75.19b01691299.Coremail.00107082@163.com>
	<20251210234318.5d8c2d68@xps15mal>
	<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
	<20251211142358.563d9ac3@xps15mal>
	<8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
	<20251216112647.39ac2295@xps15mal>
	<63fa6bc2.6afc.19b25f618ad.Coremail.00107082@163.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 Dec 2025 15:00:43 +0800 (CST)
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
> 
> Hi, just out of curiosity, have you narrowed down the caller of
> __filemap_get_folio causing the memory problem? Or do you have
> trouble applying the debug patch for memory allocation profiling?
> 
> David 
> 
Hi David,

I hadn't yet as I did test XFS and NFS to see if it replicated the
behaviour and it did not. 

But actually this could speed things up considerably. I will do that
now and see what I get.

Thanks

Mal

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
> >
> >Again, I'm not super familiar with the CephFS code but to hazard a
> >guess, but I think that the web download workload triggers things
> >faster suggests that unaligned writes might make things worse. But
> >again, I'm not 100% sure. I can't find a reproducer as fast as
> >downloading a dataset. Rsync of lots and lots of tiny files is a tad
> >faster than the dd case.
> >
> >I did see some changes in ceph_check_page_before_write where the
> >previous code unlocked pages and then continued where as the changed
> >folio code just returns ENODATA and doesn't unlock anything with most
> >of the rest of the logic unchanged. This might be perfectly fine, but
> >in my, admittedly limited, reading of the code I couldn't figure out
> >where anything that was locked prior to this being called would get
> >unlocked like it did prior to the change. Again, I could be miles off
> >here and one of the bulk reclaim/unlock passes that was added might
> >be cleaning this up correctly or some other functional change might
> >take care of this, but it looks to be potentially in the code path
> >I'm excising and it has had some unlock logic changed. 
> >
> >I've spent most of my time trying to find a solid quick reproducer.
> >Not that it takes long to start leaking folios, but I wanted
> >something that aggressively triggered it so a small vm would oom
> >quickly and when combined with crash_on_oom it could potentially be
> >used for regression testing by way of "did vm crash?".
> >
> >I'm not sure if it will super help, but I'll provide what details I
> >can about the actual workload that really sets it off. It's a python
> >based tool for downloading datasets. Datasets are split into N
> >chunks and the tool downloads them in parallel 100 at a time until
> >all N chunks are down. The compressed dataset is then unpacked and
> >reassembled for use with workloads. 
> >
> >This is replicating a common home folder usecase in HPC. CephFS is
> >very attractive for home folders due to it's "NFS-like" utility and
> >performance. And many tools use a similar method for fetching large
> >datasets. Tools are frequently written in python or go. 
> >
> >None of my customers have hit this yet, not have any enterprise
> >customers as none have moved to a new enough kernel yet due to slow
> >upgrade cycles. Even Proxmox have only just started testing on a
> >kernel version > 6.14. 
> >
> >I'm more than happy to help however I can with testing. I can run
> >instrumented kernels or test patches or whatever you need. I am
> >sorry I haven't been able to produce a super clean, fast reproducer
> >(my test cluster at home is all spinners and only 500TB usable). But
> >I figured I needed to get the word out asap as distros and soon
> >customers are going to be moving past 6.12-6.14 kernels as the 5-7
> >year update cycle marches on. Especially those wanting to take full
> >advantage of CacheFS and encryption functionality. 
> >
> >Again thanks for looking at this and do reach out if I can help in
> >anyway. I am in the ceph slack if it's faster to reach out that way.
> >
> >Regards
> >
> >Mal Haak  


