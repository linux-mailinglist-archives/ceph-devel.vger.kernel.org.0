Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB0C455B69
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Nov 2021 13:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344580AbhKRMWz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Nov 2021 07:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344577AbhKRMWw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 07:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0F7961548;
        Thu, 18 Nov 2021 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637237992;
        bh=IlvSNE4NcSNGiLHbnA6kR2pPXY0Fd/+M6VZjEFuHPlU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MDFUJAEOPcmft26dSM4CtjYaymBpofhTfuoow2LkH15BgErdIOtN2W1zPuDWoemWJ
         SxUfo0HhjbPFAUGzPWCJ/dXJ/wIBW9uZyEDMW6AfzJorylKC9bfLpvK5Zn3Tn/Gaau
         hwy6RnBLUso5T+g38FMGQJV//0ilXqRVK1dnf5lptbHtuwTXnvgTJzz7fPWwEfLKXe
         WO5V4TvtiVfIXTY9/MPBe/RPKlvpejaqIUyF5gbDupRFeG0W4wlz/RL6eYlAAO60Bt
         KOVq58MeMe8CQzXqzgFTetX2qEDQ8cW8yTCztyr1YRqLByVWg/prG0m0Y++ifud+Qb
         tmFXSg5H5mKVQ==
Message-ID: <b7d901c7f1c660f2f1ec634e18d17988f0e348eb.camel@kernel.org>
Subject: Re: [PATCH] ceph: do not truncate pagecache if truncate size
 doesn't change
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 18 Nov 2021 07:19:50 -0500
In-Reply-To: <3eae0499-6ab3-4541-f26e-89b0f518ab46@redhat.com>
References: <20211116092002.99439-1-xiubli@redhat.com>
         <d37b49e0048ba3cf6763b83c82ad2fd8f8f36663.camel@kernel.org>
         <672440f9-e812-e97f-1c85-0343d7e8359e@redhat.com>
         <07f04cd3e3aeedf0d37db4acf4c7e8916c85f2b2.camel@kernel.org>
         <3eae0499-6ab3-4541-f26e-89b0f518ab46@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-11-18 at 10:38 +0800, Xiubo Li wrote:
> On 11/17/21 11:06 PM, Jeff Layton wrote:
> > On Wed, 2021-11-17 at 09:21 +0800, Xiubo Li wrote:
> > > On 11/17/21 4:06 AM, Jeff Layton wrote:
> > > > On Tue, 2021-11-16 at 17:20 +0800, xiubli@redhat.com wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > In case truncating a file to a smaller sizeA, the sizeA will be kept
> > > > > in truncate_size. And if truncate the file to a bigger sizeB, the
> > > > > MDS will only increase the truncate_seq, but still using the sizeA as
> > > > > the truncate_size.
> > > > > 
> > > > Do you mean "kept in ci->i_truncate_size" ?
> > > Sorry for confusing. It mainly will be kept in the MDS side's
> > > CInode->inode.truncate_size. And also will be propagated to all the
> > > clients' ci->i_truncate_size member.
> > > 
> > > The MDS will only change CInode->inode.truncate_size when truncating a
> > > smaller size.
> > > 
> > > 
> > > > If so, is this really the
> > > > correct fix? I'll note this in the sources:
> > > > 
> > > >           u32 i_truncate_seq;        /* last truncate to smaller size */
> > > >           u64 i_truncate_size;       /*  and the size we last truncated down to */
> > > > 
> > > > Maybe the MDS ought not bump the truncate_seq unless it was truncating
> > > > to a smaller size? If not, then that comment seems wrong at least.
> > > Yeah, the above comments are inconsistent with what the MDS is doing.
> > > 
> > > Okay, I missed reading the code, I found in MDS that is introduced by
> > > commit :
> > > 
> > >        bf39d32d936 mds: bump truncate seq when fscrypt_file changes
> > > 
> > > With the size handling feature support, I think this commit will make no
> > > sense any more since we will calculate the 'truncating_smaller' by not
> > > only comparing the new_size and old_size, which both are rounded up to
> > > FSCRYPT BLOCK SIZE, will also check the 'req->get_data().length()' if
> > > the new_size and old_size are the same.
> > > 
> > > 
> > > > > So when filling the inode it will truncate the pagecache by using
> > > > > truncate_sizeA again, which makes no sense and will trim the inocent
> > > > > pages.
> > > > > 
> > > > Is there a reproducer for this? It would be nice to put something in
> > > > xfstests for it if so.
> > > In xfstests' generic/075 has already testing this, but i didn't see any
> > > issue it reproduce. I just found this strange logs when it's doing
> > > something like:
> > > 
> > > truncateA 0x10000 --> 0x2000
> > > 
> > > truncateB 0x2000   --> 0x8000
> > > 
> > > truncateC 0x8000   --> 0x6000
> > > 
> > > For the truncateC, the log says:
> > > 
> > > ceph:  truncate_size 0x2000 -> 0x6000
> > > 
> > > 
> > > The problem is that the truncateB will also do the vmtruncate by using
> > > the 0x2000 instead, the vmtruncate will not flush the dirty pages to the
> > > OSD and will just discard them from the pagecaches. Then we may lost
> > > some new updated data in case there has any write before the truncateB
> > > in range [0x2000, 0x8000).
> > > 
> > > 
> > > Thanks
> > > 
> > > BRs
> > > 
> > > -- Xiubo
> > > 
> > > 
> > I tested this today and was still able to reproduce failures in
> > generic/029 and generic/075 with test_dummy_encryption enabled.
> 
> Hi Jeff,
> 
> I tested these two cases many times again today and both worked well for me.
> 
> [root@lxbceph1 xfstests]# ./check generic/075
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
> MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
> MOUNT_OPTIONS -- -o 
> test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ== 
> -o context=system_u:object_r:root_t:s0 10.72.7.17:40543:/testB 
> /mnt/kcephfs/testD
> 
> generic/075 106s ... 356s
> Ran: generic/075
> Passed all 1 tests
> 
> [root@lxbceph1 xfstests]# ./check generic/029
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 lxbceph1 5.15.0+
> MKFS_OPTIONS  -- 10.72.7.17:40543:/testB
> MOUNT_OPTIONS -- -o 
> test_dummy_encryption,name=admin,secret=AQDS3IFhEtxvORAAxn1d4FVN2bRUsc/TZMpQvQ== 
> -o context=system_u:object_r:root_t:s0 10.72.7.17:40543:/testB 
> /mnt/kcephfs/testD
> 
> generic/029 4s ... 3s
> Ran: generic/029
> Passed all 1 tests
> 
> 
> > On the cluster-side, I'm using a cephadm cluster built using an image
> > based on your fsize_support branch, rebased onto master (the Oct 7 base
> > you're using is not good for cephadm).
> 
> I have updated this branch last night by rebasing it onto the latest 
> upstream master.
> 
> And at the same time I have removed the commit:
> 
>          bf39d32d936 mds: bump truncate seq when fscrypt_file changes
> 
> > On the client side, I'm using the ceph-client/wip-fscrypt-size branch,
> > along with this patch on top.
> 
> This I am also using the same branch from ceph-client repo. Nothing 
> changed in my side.
> 
> To be safe I just deleted my local branches and synced from ceph-client 
> repo today and test them again, still the same and worked for me.
> 

Ok, I think I see the problem. You sent this patch with just a [PATCH]
prefix and there is no mention in the description that it's only
intended to work on top of the other fscrypt changes, so I interpreted
that to mean that this was a pre-existing bug and that this needed to go
in ahead of those patches.

That's not the case here. This patch does seem to work OK on top of the
regular fscrypt series (but I did still see some failures in certain
tests even with that). I'll look more closely at those today.

It would probably have been clearer to send this patch along with the
rest of the series to make that clear. Alternately, when you post a
series and then find that it needs a follow-on patch, you can send it as
if you're continuing the series:

    [PATCH v7 10/9] ceph: do not truncate pagecache if truncate size doesn't change

Ideally though, this change would be rolled into one of the other
patches in your series.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>
