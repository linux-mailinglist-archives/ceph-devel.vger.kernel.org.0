Return-Path: <ceph-devel+bounces-1803-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72CCF97014E
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Sep 2024 11:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4C1DB234C9
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Sep 2024 09:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4089D1442F2;
	Sat,  7 Sep 2024 09:15:01 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADA42B9B1;
	Sat,  7 Sep 2024 09:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725700501; cv=none; b=IpNUR0D87erAw6aWmUjM9jSZaDY5vX9+ldD78f4CYziZojhyZkemUkN23QMTLlrM9mZTMaxm3czj4leCh7ZkueD4F+SfKzfvIFPKEZbzNobWyhZbiC1aVEVzOc9HSJsUyUC7AE2cblGOvZ29+nm8iHxcyHAIIeQ+CrIVH4klIhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725700501; c=relaxed/simple;
	bh=pcMYQV4zeU5q8ZXdvmN8ApU3rDQlqpYKuFiuKp67fxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V7+UgfzPoSivfYBqKx0dvvfQONoCG98wHLiMF9lBAh9pQl9p4PQsObczhayfNZ9UQjuryqN7LI97oqizv5YLgcoFO+eDKYJg2Gk6nPDghc1XtHVA/yKcV8vTIG4ZZH07GyQ0Q/1nT779coz2h7kPTdBhMitpc3fbOfR5VbJWVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 414FA455DF;
	Sat,  7 Sep 2024 11:14:51 +0200 (CEST)
Message-ID: <5e1785ec-157a-4e7c-953f-3d33f0f2a037@proxmox.com>
Date: Sat, 7 Sep 2024 11:14:49 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION]: cephfs: file corruption when reading content via
 in-kernel ceph client
To: David Howells <dhowells@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>,
 Xiubo Li <xiubli@redhat.com>, regressions@lists.linux.dev,
 ceph-devel@vger.kernel.org, stable@vger.kernel.org
References: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
 <127721.1725639777@warthog.procyon.org.uk>
Content-Language: en-US, de-DE
From: Christian Ebner <c.ebner@proxmox.com>
In-Reply-To: <127721.1725639777@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/24 18:22, David Howells wrote:
> 
> Are they using local caching with cachefiles?
> 
> David

Hi David,

if you are referring to [0] than no, there is no such caching layer active.

Output of
```
$ cat /proc/fs/fscache/{caches,cookies,requests,stats,volumes}
CACHE    REF   VOLS  OBJS  ACCES S NAME
======== ===== ===== ===== ===== = ===============
COOKIE   VOLUME   REF ACT ACC S FL DEF
======== ======== === === === = == ================
REQUEST  OR REF FL ERR  OPS COVERAGE
======== == === == ==== === =========
Netfs  : DR=0 RA=140 RF=0 WB=0 WBZ=0
Netfs  : BW=0 WT=0 DW=0 WP=0
Netfs  : ZR=0 sh=0 sk=0
Netfs  : DL=548 ds=548 df=0 di=0
Netfs  : RD=0 rs=0 rf=0
Netfs  : UL=0 us=0 uf=0
Netfs  : WR=0 ws=0 wf=0
Netfs  : rr=0 sr=0 wsc=0
-- FS-Cache statistics --
Cookies: n=0 v=0 vcol=0 voom=0
Acquire: n=0 ok=0 oom=0
LRU    : n=0 exp=0 rmv=0 drp=0 at=0
Invals : n=0
Updates: n=0 rsz=0 rsn=0
Relinqs: n=0 rtr=0 drop=0
NoSpace: nwr=0 ncr=0 cull=0
IO     : rd=0 wr=0 mis=0
VOLUME   REF   nCOOK ACC FL CACHE           KEY
======== ===== ===== === == =============== ================
```

Also, disabling caching by stetting `client_cache_size` to 0 and 
`client_oc` to false as found in [1] did not change the corrupted read 
behavior.

[0] https://www.kernel.org/doc/html/latest/filesystems/caching/fscache.html
[1] 
https://docs.ceph.com/en/latest/cephfs/client-config-ref/#client-config-reference

Regards,
Chris


