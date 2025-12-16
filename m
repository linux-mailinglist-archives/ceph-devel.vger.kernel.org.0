Return-Path: <ceph-devel+bounces-4178-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A94DECC0741
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 02:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 230E33005FD4
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Dec 2025 01:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151D327056F;
	Tue, 16 Dec 2025 01:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b="M6NzrzR3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.haak.id.au (mail.haak.id.au [172.105.183.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB91246BBA;
	Tue, 16 Dec 2025 01:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.105.183.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765848420; cv=none; b=Ujasok/EURBikOk0XnBoiBmDCEzDxPd18ikpyLbj078HKXSF5GZ/WC0FXiDvFPTw/Dep4JxL4kVaIo4LFvKmcO8Qv4e5Ips5u8WsqtmTllLk5ilP18RH0vjtrttj7B/FzGLIYm01KKPHmz7ghPQR6OgT7E4a3UXhI7dc+2uMsTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765848420; c=relaxed/simple;
	bh=mA0iYElrF+J+SPixhoTP9ze/sV+J+1KXSWrFo1inVB4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZY4O75OvUBhaWykGsrfX2TqJTddf5pP7zo0geEGfmkhYVfadNIhzsAtH1GcByHR10f/dU36w7CQV1QtdfrbsUY0a+QkKsHFqw4q8BwYqyFb+453b69MBDy/K6G8WBf7Yolw/04iQHp0jefqkTX+4BbP+txW4wwB55tEkXoM6Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au; spf=pass smtp.mailfrom=haak.id.au; dkim=pass (2048-bit key) header.d=haak.id.au header.i=@haak.id.au header.b=M6NzrzR3; arc=none smtp.client-ip=172.105.183.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=haak.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=haak.id.au
Received: from xps15mal (180-150-104-78.b49668.bne.static.aussiebb.net [180.150.104.78])
	by mail.haak.id.au (Postfix) with ESMTPSA id 0E2437F16C;
	Tue, 16 Dec 2025 11:26:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=haak.id.au; s=202002;
	t=1765848411; bh=mA0iYElrF+J+SPixhoTP9ze/sV+J+1KXSWrFo1inVB4=;
	h=Date:From:To:Subject:From;
	b=M6NzrzR3WGR0xZs6e9v3w0IB2UFdeuzMfFpv6NE1RPP5wNZ9lT1eXAfpk7KRR5iqi
	 R89tk+gsJIvYF3V3kz2GqRlNkOQAhozCoNiyqtQ17NGhxRpvvsqFoA7YyFuTQhhyM+
	 i3FV99YzyKYHDTtL6Ofse4fY9Qq892zvVqb7FPuSG6jyIT7W0ktuEb3rzaoaZ1LNR9
	 FiG+OkZphvM8dwdyufRNgRzvr7TkidzG7Rv6hClNen0Wqu6xuh0LC6OdPDPqrAbXvs
	 YwefLQw+kHLPg1PTyBzUbAwwBnzlRbS5qxxMgM1mZFzPpAAogPxtdijZ0/EDUISp4j
	 S0+gYlyiaFy1g==
Date: Tue, 16 Dec 2025 11:26:47 +1000
From: Mal Haak <malcolm@haak.id.au>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Cc: "00107082@163.com" <00107082@163.com>, "ceph-devel@vger.kernel.org"
 <ceph-devel@vger.kernel.org>, Xiubo Li <xiubli@redhat.com>,
 "idryomov@gmail.com" <idryomov@gmail.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "surenb@google.com" <surenb@google.com>
Subject: Re: RRe: Possible memory leak in 6.17.7
Message-ID: <20251216112647.39ac2295@xps15mal>
In-Reply-To: <8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
References: <20251110182008.71e0858b@xps15mal>
	<20251208110829.11840-1-00107082@163.com>
	<20251209090831.13c7a639@xps15mal>
	<17469653.4a75.19b01691299.Coremail.00107082@163.com>
	<20251210234318.5d8c2d68@xps15mal>
	<2a9ba88e.3aa6.19b0b73dd4e.Coremail.00107082@163.com>
	<20251211142358.563d9ac3@xps15mal>
	<8c8e8dc4d30a8ca37a57d7f29c5f29cdf7a904ee.camel@ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Dec 2025 19:42:56 +0000
Viacheslav Dubeyko <Slava.Dubeyko@ibm.com> wrote:

> Hi Mal,
> 
<SNIP> 
> 
> Thanks a lot for reporting the issue. Finally, I can see the
> discussion in email list. :) Are you working on the patch with the
> fix? Should we wait for the fix or I need to start the issue
> reproduction and investigation? I am simply trying to avoid patches
> collision and, also, I have multiple other issues for the fix in
> CephFS kernel client. :)
> 
> Thanks,
> Slava.

Hello,

Unfortunately creating a patch is just outside my comfort zone, I've
lived too long in Lustre land.

I've have been trying to narrow down a consistent reproducer that's as
fast as my production workload. (It crashes a 32GB VM in 2hrs) And I
haven't got it quite as fast. I think the dd workload is too well
behaved. 

I can confirm the issue appeared in the major patch set that was
applied as part of the 6.15 kernel. So during the more complete pages
to folios switch and that nothing has changed in the bug behaviour since
then. I did have a look at all the diffs from 6.14 to 6.18 on addr.c
and didn't see any changes post 6.15 that looked like they would impact
the bug behavior. 

Again, I'm not super familiar with the CephFS code but to hazard a
guess, but I think that the web download workload triggers things faster
suggests that unaligned writes might make things worse. But again, I'm
not 100% sure. I can't find a reproducer as fast as downloading a
dataset. Rsync of lots and lots of tiny files is a tad faster than the
dd case.

I did see some changes in ceph_check_page_before_write where the
previous code unlocked pages and then continued where as the changed
folio code just returns ENODATA and doesn't unlock anything with most
of the rest of the logic unchanged. This might be perfectly fine, but
in my, admittedly limited, reading of the code I couldn't figure out
where anything that was locked prior to this being called would get
unlocked like it did prior to the change. Again, I could be miles off
here and one of the bulk reclaim/unlock passes that was added might be
cleaning this up correctly or some other functional change might take
care of this, but it looks to be potentially in the code path I'm
excising and it has had some unlock logic changed. 

I've spent most of my time trying to find a solid quick reproducer. Not
that it takes long to start leaking folios, but I wanted something that
aggressively triggered it so a small vm would oom quickly and when
combined with crash_on_oom it could potentially be used for regression
testing by way of "did vm crash?".

I'm not sure if it will super help, but I'll provide what details I can
about the actual workload that really sets it off. It's a python based
tool for downloading datasets. Datasets are split into N chunks and the
tool downloads them in parallel 100 at a time until all N chunks are
down. The compressed dataset is then unpacked and reassembled for
use with workloads. 

This is replicating a common home folder usecase in HPC. CephFS is very
attractive for home folders due to it's "NFS-like" utility and
performance. And many tools use a similar method for fetching large
datasets. Tools are frequently written in python or go. 

None of my customers have hit this yet, not have any enterprise
customers as none have moved to a new enough kernel yet due to slow
upgrade cycles. Even Proxmox have only just started testing on a kernel
version > 6.14. 

I'm more than happy to help however I can with testing. I can run
instrumented kernels or test patches or whatever you need. I am sorry I
haven't been able to produce a super clean, fast reproducer (my test
cluster at home is all spinners and only 500TB usable). But I figured I
needed to get the word out asap as distros and soon customers are going
to be moving past 6.12-6.14 kernels as the 5-7 year update cycle
marches on. Especially those wanting to take full advantage of CacheFS
and encryption functionality. 

Again thanks for looking at this and do reach out if I can help in
anyway. I am in the ceph slack if it's faster to reach out that way.

Regards

Mal Haak

