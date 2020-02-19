Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44BC164456
	for <lists+ceph-devel@lfdr.de>; Wed, 19 Feb 2020 13:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbgBSMdI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 19 Feb 2020 07:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgBSMdI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 07:33:08 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AC124656;
        Wed, 19 Feb 2020 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582115587;
        bh=vKLJkxAYrEu/n/VfaNvK/rAGM2DpMW1Ht4zgO12xV1k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VwWAEX/1f3EWcn+nl+JGBn3ZkA0pOnoAVaQ+G5hZHZa9/r8yoBoPizBpn0W7scLRW
         KR4q+NNL8nM3dG6cVgtgQ5umMH445r4XTQ+TAvYEGUcjQoM+LPUnq+miTzLSIb7JUq
         hwkljPKFILhp4UesBVPEF4Eh+kng3/bjhd9xqD8M=
Message-ID: <1efef7a514b31b731d031a788e4bc89f508343a9.camel@kernel.org>
Subject: Re: BUG: ceph_inode_cachep and ceph_dentry_cachep caches are not
 clean when destroying
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 19 Feb 2020 07:33:06 -0500
In-Reply-To: <ee0c1043-b0b8-5107-3c78-c4a7b8fca4dc@redhat.com>
References: <23e2b9a7-5ff6-1f07-ff03-08abcbf1457f@redhat.com>
         <CAOi1vP8b1aCph3NkAENEtAKfPDa8J03cNxwOZ+KSn1-te=6g0w@mail.gmail.com>
         <bed8db55-50e1-a787-c9d4-a7c0f3c6c9d2@redhat.com>
         <CAOi1vP_=t+ppv2Ob1O44-zQz69Y5au2G+5XHvqQ8vvxLUee_2g@mail.gmail.com>
         <ee0c1043-b0b8-5107-3c78-c4a7b8fca4dc@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-02-19 at 19:29 +0800, Xiubo Li wrote:
> On 2020/2/19 19:27, Ilya Dryomov wrote:
> > On Wed, Feb 19, 2020 at 12:01 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > On 2020/2/19 18:53, Ilya Dryomov wrote:
> > > > On Wed, Feb 19, 2020 at 10:39 AM Xiubo Li <xiubli@redhat.com> wrote:
> > > > > Hi Jeff, Ilya and all
> > > > > 
> > > > > I hit this call traces by running some test cases when unmounting the fs
> > > > > mount points.
> > > > > 
> > > > > It seems there still have some inodes or dentries are not destroyed.
> > > > > 
> > > > > Will this be a problem ? Any idea ?
> > > > Hi Xiubo,
> > > > 
> > > > Of course it is a problem ;)
> > > > 
> > > > These are all in ceph_inode_info and ceph_dentry_info caches, but
> > > > I see traces of rbd mappings as well.  Could you please share your
> > > > test cases?  How are you unloading modules?
> > > I am not sure exactly in which one, mostly I was running the following
> > > commands.
> > > 
> > > 1, ./bin/rbd map share -o mount_timeout=30
> > > 
> > > 2, ./bin/rbd unmap share
> > > 
> > > 3, ./bin/mount.ceph :/ /mnt/cephfs/
> > > 
> > > 4, `for i in {0..1000}; do mkdir /mnt/cephfs/dir$0; done` and `for i in
> > > {0..1000}; do rm -rf /mnt/cephfs/dir$0; done`
> > > 
> > > 5, umount /mnt/cephfs/
> > > 
> > > 6, rmmod ceph; rmmod rbd; rmmod libceph
> > > 
> > > This it seems none business with the rbd mappings.
> > Is this on more or less plain upstream or with async unlink and
> > possibly other filesystem patches applied?
> 
> Using the latest test branch: 
> https://github.com/ceph/ceph-client/tree/testing.
> 
> thanks
> 

I've run a lot of tests like this and haven't see this at all. Did you
see any "Busy inodes after umount" messages in dmesg?

I note that your kernel is tainted -- sometimes if you're plugging in
modules that have subtle ABI incompatibilities, you can end up with
memory corruption like this.

What would be ideal would be to come up with a reliable reproducer if
possible.
-- 
Jeff Layton <jlayton@kernel.org>

