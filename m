Return-Path: <ceph-devel+bounces-1786-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 785C696C33B
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2024 18:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB7A71C24B8F
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2024 16:00:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9D71E0B70;
	Wed,  4 Sep 2024 15:58:43 +0000 (UTC)
X-Original-To: ceph-devel@vger.kernel.org
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD9A1E0B6E;
	Wed,  4 Sep 2024 15:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465523; cv=none; b=GVTDrtAApyk7car8bOt0/rIqWLVzieEDUBFYcbiYeWB1RU2/zBG/+46oqy6+vanD49+QcKei+++5gPZxi6nP5Tr/LcoRkfxAmyYKMs8TSt1DWTfQfZPImnCcQKRGhA2wYYbWeL2ANIRa1XP+yWlVfmgGZedOBlm/wxFstquIExQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465523; c=relaxed/simple;
	bh=Vp+fcDwe0I7fH8fIp60ulHhQK+XVLedtB7wO3n3NvF8=;
	h=Message-ID:Date:MIME-Version:Cc:From:Subject:To:Content-Type; b=bKu4LBQNcfNXyIvF4qCgWSNmgE91OfR+ok5d2SvLa/g0T3vaeZZovA41Nw18LqWovBEimYU5Ag9Zrs+Fv8DBSsa7/iXzhjwhQ2iGSIpmutOLR+jk3/hIWT/l5vALCNhw5xj8ZiQHdDSfMzW9zSy6ajEHm/1lSat+7df6dQVAwpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 0743547432;
	Wed,  4 Sep 2024 17:49:13 +0200 (CEST)
Message-ID: <85bef384-4aef-4294-b604-83508e2fc350@proxmox.com>
Date: Wed, 4 Sep 2024 17:49:11 +0200
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US, de-DE
Cc: regressions@lists.linux.dev, ceph-devel@vger.kernel.org,
 stable@vger.kernel.org
From: Christian Ebner <c.ebner@proxmox.com>
Subject: [REGRESSION]: cephfs: file corruption when reading content via
 in-kernel ceph client
To: David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>,
 Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

some of our customers (Proxmox VE) are seeing issues with file 
corruptions when accessing contents located on CephFS via the in-kernel 
Ceph client [0,1], we managed to reproduce this regression on kernels up 
to the latest 6.11-rc6.
Accessing the same content on the CephFS using the FUSE client or the 
in-kernel ceph client with older kernels (Ubuntu kernel on v6.5) does 
not show file corruptions.
Unfortunately the corruption is hard to reproduce, seemingly only a 
small subset of files is affected. However, once a file is affected, the 
issue is persistent and can easily be reproduced.

Bisection with the reproducer points to this commit:

"92b6cc5d: netfs: Add iov_iters to (sub)requests to describe various 
buffers"

Description of the issue:

A file was copied from local filesystem to cephfs via:
```
cp /tmp/proxmox-backup-server_3.2-1.iso 
/mnt/pve/cephfs/proxmox-backup-server_3.2-1.iso
```
* sha256sum on local 
filesystem:`1d19698e8f7e769cf0a0dcc7ba0018ef5416c5ec495d5e61313f9c84a4237607 
/tmp/proxmox-backup-server_3.2-1.iso`
* sha256sum on cephfs with kernel up to above commit: 
`1d19698e8f7e769cf0a0dcc7ba0018ef5416c5ec495d5e61313f9c84a4237607 
/mnt/pve/cephfs/proxmox-backup-server_3.2-1.iso`
* sha256sum on cephfs with kernel after above commit: 
`89ad3620bf7b1e0913b534516cfbe48580efbaec944b79951e2c14e5e551f736 
/mnt/pve/cephfs/proxmox-backup-server_3.2-1.iso`
* removing and/or recopying the file does not change the issue, the 
corrupt checksum remains the same.
* accessing the same file from different clients results in the same 
output: the one with above patch applied do show the incorrect checksum, 
ones without the patch show the correct checksum.
* the issue persists even across reboot of the ceph cluster and/or clients.
* the file is indeed corrupt after reading, as verified by a `cmp -b`. 
Interestingly, the first 4M contain the correct data, the following 4M 
are read as all zeros, which differs from the original data.
* the issue is related to the readahead size: mounting the cephfs with a 
`rasize=0` makes the issue disappear, same is true for sizes up to 128k 
(please note that the ranges as initially reported on the mailing list 
[3] are not correct for rasize [0..128k] the file is not corrupted).

In the bugtracker issue [4] I attached a  ftrace with "*ceph*" as filter 
while performing a read on the latest kernel 6.11-rc6 while performing
```
dd if=/mnt/pve/cephfs/proxmox-backup-server_3.2-1.iso of=/tmp/test.out 
bs=8M count=1
```
the relevant part shown by task `dd-26192`.

Please let me know if I can provide further information or debug outputs 
in order to narrow down the issue.

[0] https://forum.proxmox.com/threads/78340/post-676129
[1] https://forum.proxmox.com/threads/149249/
[2] https://forum.proxmox.com/threads/151291/
[3] 
https://lore.kernel.org/lkml/db686d0c-2f27-47c8-8c14-26969433b13b@proxmox.com/
[4] https://bugzilla.kernel.org/show_bug.cgi?id=219237

#regzbot introduced: 92b6cc5d

Regards,
Christian Ebner


