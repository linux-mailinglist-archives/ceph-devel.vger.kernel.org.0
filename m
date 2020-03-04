Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECCD1799A8
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 21:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgCDUX2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 15:23:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727137AbgCDUX2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 15:23:28 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C445320870;
        Wed,  4 Mar 2020 20:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583353407;
        bh=TIIs+LZqBnrMOdn3JM0D6n0S7UEK96K4d+T297MUPwU=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=b59Rhv20ky7n4PJluaNzay4goa78Jn8sc3WWwsU9g6y4yrk/CZs69ueRnge6nn5MM
         yM1sRY3IJ61gk8J5APrcfAEN5cnxsuiGpm6nclWyO4UL8DY48Sc4vsHIvVgRiqmuS0
         tGEWEvfaJhyJ0b1GjIwQirbQOrgQCvQouk1Buc00=
Message-ID: <9695e9d9bfa91c1f9fefc4c99a2f9f90ef291f0c.camel@kernel.org>
Subject: Re: [PATCH v4 0/6] ceph: don't request caps for idle open files
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Date:   Wed, 04 Mar 2020 15:23:25 -0500
In-Reply-To: <6b5dc83aed4beb82103e0db8d43eb738125defda.camel@kernel.org>
References: <20200304173258.48377-1-zyan@redhat.com>
         <9922f9e850f52fd68bc67be675d7571fc9bb55f1.camel@kernel.org>
         <6b5dc83aed4beb82103e0db8d43eb738125defda.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-03-04 at 14:24 -0500, Jeff Layton wrote:
> On Wed, 2020-03-04 at 12:48 -0500, Jeff Layton wrote:
> > On Thu, 2020-03-05 at 01:32 +0800, Yan, Zheng wrote:
> > > This series make cephfs client not request caps for open files that
> > > idle for a long time. For the case that one active client and multiple
> > > standby clients open the same file, this increase the possibility that
> > > mds issues exclusive caps to the active client.
> > > 
> > > Yan, Zheng (6):
> > >   ceph: always renew caps if mds_wanted is insufficient
> > >   ceph: consider inode's last read/write when calculating wanted caps
> > >   ceph: remove delay check logic from ceph_check_caps()
> > >   ceph: simplify calling of ceph_get_fmode()
> > >   ceph: update i_requested_max_size only when sending cap msg to auth mds
> > >   ceph: check all mds' caps after page writeback
> > > 
> > >  fs/ceph/caps.c               | 338 ++++++++++++++++-------------------
> > >  fs/ceph/file.c               |  45 ++---
> > >  fs/ceph/inode.c              |  21 +--
> > >  fs/ceph/ioctl.c              |   2 +
> > >  fs/ceph/mds_client.c         |   5 -
> > >  fs/ceph/super.h              |  37 ++--
> > >  include/linux/ceph/ceph_fs.h |   1 +
> > >  7 files changed, 202 insertions(+), 247 deletions(-)
> > > 
> > > changes since v2
> > >  - make __ceph_caps_file_wanted() more readable
> > >  - add patch 5 and 6, which fix hung write during testing patch 1~4
> > > 
> > > changes since v3
> > >  - don't queue delayed cap check for snap inode
> > >  - initialize ci->{last_rd,last_wr} to jiffies - 3600 * HZ
> > >  - make __ceph_caps_file_wanted() check inode type
> > > 
> > 
> > I just tried this out, and it still seems to kill unlink performance
> > with -o nowsync. From the script I posted to the other thread:
> > 
> > --------8<--------
> > $ ./test-async-dirops.sh 
> >   File: /mnt/cephfs/test-dirops.1401
> >   Size: 0         	Blocks: 0          IO Block: 65536  directory
> > Device: 26h/38d	Inode: 1099511627778  Links: 2
> > Access: (0775/drwxrwxr-x)  Uid: ( 4447/ jlayton)   Gid: ( 4447/ jlayton)
> > Context: system_u:object_r:cephfs_t:s0
> > Access: 2020-03-04 12:42:03.914006772 -0500
> > Modify: 2020-03-04 12:42:03.914006772 -0500
> > Change: 2020-03-04 12:42:03.914006772 -0500
> >  Birth: 2020-03-04 12:42:03.914006772 -0500
> > Creating files in /mnt/cephfs/test-dirops.1401
> > 
> > real	0m6.269s
> > user	0m0.123s
> > sys	0m0.454s
> > 
> > sync
> > 
> > real	0m5.358s
> > user	0m0.003s
> > sys	0m0.011s
> > Starting rm
> > 
> > real	0m18.932s
> > user	0m0.169s
> > sys	0m0.713s
> > 
> > rmdir
> > 
> > real	0m0.135s
> > user	0m0.000s
> > sys	0m0.002s
> > 
> > sync
> > 
> > real	0m1.725s
> > user	0m0.000s
> > sys	0m0.002s
> > --------8<--------
> > 
> > Create and sync parts look reasonable. Usually, the rm part finishes in
> > less than a second as we end up doing most of the removes
> > asynchronously, but here it didn't. I suspect that means that unlink
> > didn't get caps for some reason, but I'd need to do some debugging to
> > figure out what's actually happening.
> > 
> 
> A bit more investigation. I piled on some tracepoints that I had plumbed
> in a while back:
> 
> It starts with doing making a directory (NOSNAP:0x1000000c6c0) and then
> doing the first sync create:
> 
>      kworker/7:1-2021  [007] ....  5316.161752: ceph_add_cap: ino=NOSNAP:0x1 mds=0 issued=pAsLsXs implemented=pAsLsXs mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.163241: ceph_add_cap: ino=NOSNAP:0x1 mds=0 issued=pAsLsXs implemented=pAsLsXs mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.163250: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsxLsXsxFsx implemented=pAsxLsXsxFsx mds_wanted=-
>      kworker/7:1-2021  [007] ....  5316.168011: ceph_handle_cap_grant: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsxFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.168830: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=pAsLsXsFsxcral
>      kworker/7:1-2021  [007] ....  5316.168839: ceph_add_cap: ino=NOSNAP:0x1000000c6c1 mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxXsxFxwb
>  test-async-diro-2257  [005] ....  5316.169004: ceph_sync_create: name=NOSNAP:0x1000000c6c0/1(0x1000000c6c1)
> 
> We get a cap grant on the directory in the sync create reply and that sets mds_wanted:
> 
>      kworker/7:1-2021  [007] ....  5316.169075: ceph_handle_cap_grant: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsxc implemented=pAsLsXsFsxc mds_wanted=pAsLsXsFsxcral
>      kworker/7:1-2021  [007] ....  5316.170209: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsxc implemented=pAsLsXsFsxc mds_wanted=pAsLsXsFsxcral
> 
> ...eventually we start doing async creates and continue that to the end
> of the creates. (Side note: the second create was also synchronous --
> not sure why):
> 
>      kworker/7:1-2021  [007] ....  5316.170216: ceph_add_cap: ino=NOSNAP:0x1000000c6c2 mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxXsxFxwb
>  test-async-diro-2257  [005] ....  5316.170251: ceph_sync_create: name=NOSNAP:0x1000000c6c0/2(0x1000000c6c2)
>  test-async-diro-2257  [005] ....  5316.170412: ceph_add_cap: ino=NOSNAP:0x1000000c554 mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxLsXsxFsxcrwb
>  test-async-diro-2257  [005] ....  5316.170415: ceph_async_create: name=NOSNAP:0x1000000c6c0/3(0x1000000c554)
>  test-async-diro-2257  [005] ....  5316.170571: ceph_add_cap: ino=NOSNAP:0x1000000c555 mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxLsXsxFsxcrwb
> 
> Eventually we finish creating and soon after, get a cap revoke and that
> resets mds_wanted back to only "p":
> 
>      kworker/7:1-2021  [007] ....  5316.461890: ceph_handle_cap_grant: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFs implemented=pAsLsXsFsc mds_wanted=p
> 
> ...and it never changes and we're never granted Du caps (aka Fr):
> 
>               rm-2262  [006] ....  5316.466221: ceph_sync_unlink: name=NOSNAP:0x1000000c6c0/1(0x1000000c6c1)
>      kworker/7:1-2021  [007] ....  5316.467108: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.467676: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.467679: ceph_add_cap: ino=NOSNAP:0x1000000c55b mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxXsxFxwb
>               rm-2262  [006] ....  5316.467714: ceph_sync_unlink: name=NOSNAP:0x1000000c6c0/10(0x1000000c55b)
>      kworker/7:1-2021  [007] ....  5316.468424: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.468956: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.468960: ceph_add_cap: ino=NOSNAP:0x1000000c5b5 mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxXsxFxwb
>               rm-2262  [006] ....  5316.468994: ceph_sync_unlink: name=NOSNAP:0x1000000c6c0/100(0x1000000c5b5)
>      kworker/7:1-2021  [007] ....  5316.469728: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.470237: ceph_add_cap: ino=NOSNAP:0x1000000c6c0 mds=0 issued=pAsLsXsFsx implemented=pAsLsXsFsx mds_wanted=p
>      kworker/7:1-2021  [007] ....  5316.470242: ceph_add_cap: ino=NOSNAP:0x1000000c55c mds=0 issued=pAsxLsXsxFsxcrwb implemented=pAsxLsXsxFsxcrwb mds_wanted=pAsxXsxFxwb
> 
> Given that we've overloaded Fr caps for Du, I wonder if the new timeout
> logic is creeping in here. In particular, we don't want those caps to
> ever time out.
> 

I did a bisect and the first two patches in the series seem to be fine.
This patch causes the problem:

     [PATCH v4 3/6] ceph: remove delay check logic from ceph_check_caps()

...though I've not yet spotted the problem.
-- 
Jeff Layton <jlayton@kernel.org>

