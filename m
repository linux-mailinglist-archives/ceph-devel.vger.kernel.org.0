Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD8B10EB00
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Dec 2019 14:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLBNoX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Dec 2019 08:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727362AbfLBNoX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:44:23 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A1E52053B;
        Mon,  2 Dec 2019 13:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575294262;
        bh=Tr02DtGubNIfVE2SrGAnvSIJoFURCsjYBu0ow8hTARc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cVo106OQ6M5VmfKFG1gEEqhpZPkDRAn/8c6efmbP9FLUoN6KNtJWSAKZRyj4tODf8
         3vdAflDp7E4HCGuYcKyfplwgKhr5BZBwMGg7OxgyLSOrZ4N1QU8KpiJWUMy3Aj6cMy
         +nsH3Yr3Ex9WKH21tzqguY98RpuPpB3KI3/l7EKg=
Message-ID: <9686712e4c2e9f0c218f4d719145231f5f2f934c.camel@kernel.org>
Subject: Re: [BUG]cephfs hang for ever
From:   Jeff Layton <jlayton@kernel.org>
To:     norman <norman.kern@gmx.com>, ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com
Date:   Mon, 02 Dec 2019 08:44:21 -0500
In-Reply-To: <e81c2147-f2f0-bcc3-87fd-ec2fc1554c3c@gmx.com>
References: <e81c2147-f2f0-bcc3-87fd-ec2fc1554c3c@gmx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-12-02 at 21:12 +0800, norman wrote:
> I found a problem in my cephfs kernel client,  a thread hung for days, 
> and I check the stack
> 
> debug-user@CEPH0207:/home/debug-user$ sudo cat /proc/46071/stack
> [<ffffffffc0e8fb60>] ceph_mdsc_do_request+0x180/0x240 [ceph]
> [<ffffffffc0e70e51>] __ceph_do_getattr+0xd1/0x1e0 [ceph]
> [<ffffffffc0e70fcc>] ceph_getattr+0x2c/0x100 [ceph]
> [<ffffffffbc05b943>] vfs_getattr_nosec+0x73/0x90
> [<ffffffffbc05b996>] vfs_getattr+0x36/0x40
> [<ffffffffbc05baae>] vfs_statx+0x8e/0xe0
> [<ffffffffbc05c00d>] SYSC_newstat+0x3d/0x70
> [<ffffffffbc05c7ae>] SyS_newstat+0xe/0x10
> [<ffffffffbc8001a1>] entry_SYSCALL_64_fastpath+0x24/0xab
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> and I found the the session has lost its connection,
> 
> debug-user@CEPH0207:/home/debug-user$ sudo cat
> /sys/kernel/debug/ceph/64803197-c207-4012-b8f3-18825d34196c.client15099020/mds_sessions
> global_id 15099020
> name "text"
> mds.0 reconnecting
> 
> I guess the client has been in the black list, but it's not, someone can
> give me some ideas about how to solve the problem or it's a known bug?
> Thanks.
> 
> The envrionment info:
> 
> OS: Ubuntu
> 
> kernel:  linux-image-4.13.0-36-generic
> 
> cpeh version: luminous

v4.13 based kernels are pretty old at this point, so I'd not spend a lot
of time troubleshooting if you have the ability to update to something
(much) newer. I know there have been some bugs fixed within the last
year or two that exhibited symptoms like that, but I don't see the
specific commits, right offhand.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

