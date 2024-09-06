Return-Path: <ceph-devel+bounces-1797-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD5C96F306
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 13:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E45581F24029
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Sep 2024 11:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADD51CB306;
	Fri,  6 Sep 2024 11:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="fCyj2f4n"
X-Original-To: ceph-devel@vger.kernel.org
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04931A2C39;
	Fri,  6 Sep 2024 11:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725621951; cv=none; b=D6lJNCoFhETyFnTFZbdgnJ6XcIROp8ZAJwb+DAwOuPM7SCyQAsFRA4rovpgf28UDjpY0iD/V5FiI5Dz1LWbHO/nong+AMf+FHthFiEF1Z4VyNIB3hbwByfC7cNXhQzwyq3o9+0AFxvmBNUOtwc1iOekGbSueaFBLqsUsCLedrt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725621951; c=relaxed/simple;
	bh=DmaEKJ8/NLpkXcaL6Xw0J9LfpkVpr/GixbnI3HWELqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hTYYiF6yPi8vobbc8bI2vIh718R/2TBybY04fxJbeGlQgF426I75Q5w/d+RW8d1RhsBNxaIJCXU5SRI0o4cLoWy9roNAw28KJzC82ISZvnMtJ5Z6HT+Eh+wUvd07iXB+ZzzSijUSWsDKMXeigwsayyFazcJtO1lxaVyr5LexHTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=fCyj2f4n; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	In-Reply-To:References; bh=TaGZSCH2FvEl+U3DsaRvbmj+4eIMbIhuHXZKV7y/t4c=;
	t=1725621949; x=1726053949; b=fCyj2f4nltQV+bRiY5m4WG/adQrs59mV7Wgc2bBi2lgkGNo
	QYSJt5gmQ3mQnOeNFTHNSUnbpib0hrSKf3mk8Sf76qCPUpK3LiA+QMZ9L45EiSVOxkyY7eYm2vwyc
	SxGhV9fu2qOtECcaN/31nileItTKcnvdNnaCGMmPJ/3ROcXBIJuDyR/tkpOAFbJH18J9VR61MbA8/
	wt/NY3r/UbnrUlImnShZpBey6w99or083DEYbHn8++rGcaONqNF9+XNJlxP2tFAweyybSwG+jEjaC
	ual9wI+XMprcSagUdabZv/EA6vtma053Mb3Z7VxZj7V8y8GQ+gt3IM/fJtxT/INg==;
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1smX5y-0006it-UN; Fri, 06 Sep 2024 13:25:42 +0200
Message-ID: <8bce309d-f7ef-4929-bfad-6f0b5c55cfff@leemhuis.info>
Date: Fri, 6 Sep 2024 13:25:42 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION]: cephfs: file corruption when reading content via
 in-kernel ceph client
To: Xiubo Li <xiubli@redhat.com>, Christian Ebner <c.ebner@proxmox.com>,
 David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>
Cc: regressions@lists.linux.dev, ceph-devel@vger.kernel.org,
 stable@vger.kernel.org
References: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
 <0e60c3b8-f9af-489a-ba6f-968cb12b55dd@redhat.com>
 <1679397305.24654.1725606946541@webmail.proxmox.com>
 <5335cdb5-7735-463e-907b-617774d6f01a@redhat.com>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Content-Language: en-US, de-DE
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <5335cdb5-7735-463e-907b-617774d6f01a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1725621949;8f53e1ec;
X-HE-SMSGID: 1smX5y-0006it-UN

On 06.09.24 13:09, Xiubo Li wrote:
> On 9/6/24 15:15, Christian Ebner wrote:
>>> On 06.09.2024 03:01 CEST Xiubo Li <xiubli@redhat.com> wrote:
>>>
>>> Thanks for reporting this.
>>>
>>> Let me have a look and how to fix this.
>>>
>> Thanks for looking into it, please do not hesitate to contact me if I
>> can be of help regarding debugging or testing a possible fix.
> 
> Sure, thanks in advance.
> 
> I will work on this next week or later because I am occupied by some
> other stuff recently.

Thx. FWIW, there were some other corruption bugs related to netfs, one
of them [1] was recently solved by c26096ee0278c5 ("mm: Fix
filemap_invalidate_inode() to use invalidate_inode_pages2_range()");
this is a v6.11-rc6-post commit. Makes me wonder if retesting with
latest mainline might be wise; OTOH I assume David might have mentioned
this if he suspects it might be related, so maybe I'm just confusing
everything with this message. Sending it nevertheless, but if that's
turns out to be the case: sorry!

Ciao, Thorsten

[1] like this
https://lore.kernel.org/all/pv2lcjhveti4sfua95o0u6r4i73r39srra@sonic.net/

