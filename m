Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FA3265F06
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Sep 2020 13:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgIKLti (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Sep 2020 07:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgIKLtT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Sep 2020 07:49:19 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6D8221E7;
        Fri, 11 Sep 2020 11:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599824958;
        bh=iHOEuqY2IISIowcVjExJxn/MeIDiEYvblEe/lfZwOvs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0QK1ej+AM/3twvbQQ/q27JJVckLUo5EUO6Fh+rABImMr3EbHCLMUsC817OGCimv/k
         FkpQgf/BeAXpHCBa637vVu1NiatUXW3UkLyEZu59bNJhBvFDddpaMXTKnuWcKb5lcV
         YNySgZA2mxy8/PxQCSwZ0Jm1R5XjwH1V6wzCd6D4=
Message-ID: <a281843181d1c97d099a2dd88c216ca94cf8d544.camel@kernel.org>
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Fri, 11 Sep 2020 07:49:16 -0400
In-Reply-To: <9a5c5d2f-d105-21c4-327e-5ad18bf49518@redhat.com>
References: <20200903130140.799392-1-xiubli@redhat.com>
         <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
         <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
         <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
         <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
         <CAOi1vP-XxXVcvyZgQF7mWaxm-21hiY5fF4tRYkua-F9ikof7UA@mail.gmail.com>
         <e291d899acee9f9218fe9a62f7300ab82592c459.camel@kernel.org>
         <9a5c5d2f-d105-21c4-327e-5ad18bf49518@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-09-11 at 11:43 +0800, Xiubo Li wrote:
> On 2020/9/10 20:13, Jeff Layton wrote:
> > On Thu, 2020-09-10 at 08:00 +0200, Ilya Dryomov wrote:
> > > On Thu, Sep 10, 2020 at 2:59 AM Xiubo Li <xiubli@redhat.com> wrote:
> > > > On 2020/9/10 4:34, Ilya Dryomov wrote:
> > > > > On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > > > > On 2020/9/3 22:18, Jeff Layton wrote:
> > > > > > > On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
> > > > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > > > 
> > > > > > > > Changed in V5:
> > > > > > > > - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
> > > > > > > > - Remove the is_opened member.
> > > > > > > > 
> > > > > > > > Changed in V4:
> > > > > > > > - A small fix about the total_inodes.
> > > > > > > > 
> > > > > > > > Changed in V3:
> > > > > > > > - Resend for V2 just forgot one patch, which is adding some helpers
> > > > > > > > support to simplify the code.
> > > > > > > > 
> > > > > > > > Changed in V2:
> > > > > > > > - Add number of inodes that have opened files.
> > > > > > > > - Remove the dir metrics and fold into files.
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 
> > > > > > > > Xiubo Li (2):
> > > > > > > >      ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
> > > > > > > >      ceph: metrics for opened files, pinned caps and opened inodes
> > > > > > > > 
> > > > > > > >     fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
> > > > > > > >     fs/ceph/debugfs.c | 11 +++++++++++
> > > > > > > >     fs/ceph/dir.c     | 20 +++++++-------------
> > > > > > > >     fs/ceph/file.c    | 13 ++++++-------
> > > > > > > >     fs/ceph/inode.c   | 11 ++++++++---
> > > > > > > >     fs/ceph/locks.c   |  2 +-
> > > > > > > >     fs/ceph/metric.c  | 14 ++++++++++++++
> > > > > > > >     fs/ceph/metric.h  |  7 +++++++
> > > > > > > >     fs/ceph/quota.c   | 10 +++++-----
> > > > > > > >     fs/ceph/snap.c    |  2 +-
> > > > > > > >     fs/ceph/super.h   |  6 ++++++
> > > > > > > >     11 files changed, 103 insertions(+), 34 deletions(-)
> > > > > > > > 
> > > > > > > Looks good. I went ahead and merge this into testing.
> > > > > > > 
> > > > > > > Small merge conflict in quota.c, which I guess is probably due to not
> > > > > > > basing this on testing branch. I also dropped what looks like an
> > > > > > > unrelated hunk in the second patch.
> > > > > > > 
> > > > > > > In the future, if you can be sure that patches you post apply cleanly to
> > > > > > > testing branch then that would make things easier.
> > > > > > Okay, will do it.
> > > > > Hi Xiubo,
> > > > > 
> > > > > There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
> > > > > when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
> > > > > in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
> > > > > suggestion to move the decrement of total_inodes into ceph_free_inode(),
> > > > > but it doesn't look like it can be easily deferred past ->evict_inode().
> > > > Okay, I will take a look.
> > > Given that it's just a counter which we don't care about if the
> > > mount is going away, some form of "if (mdsc)" check might do, but
> > > need to make sure that it covers possible races, if any.
> > > 
> > Good catch, Ilya.
> > 
> > What may be best is to move the increment out of ceph_alloc_inode and
> > instead put it in ceph_set_ino_cb. Then the decrement can go back into
> > ceph_evict_inode.
> 
> Hi Jeff, Ilya
> 
> Checked the code, it seems in the ceph_evict_inode() we will also hit 
> the same issue .
> 
> With the '-f' options when umounting, it will skip the inodes whose 
> i_count ref > 0. And then free the fsc/mdsc in ceph. And later the 
> iput_final() will call the ceph_evict_inode() and then ceph_free_inode().
> 
> Could we just check if !!(sb->s_flags & SB_ACTIVE) is false will we skip 
> the counting ?
> 

Note that umount -f (MNT_FORCE) just means that ceph_umount_begin is
called before unmounting.

If what you're saying it true, then we have bigger problems.
ceph_evict_inode does this today when ci->i_snap_realm is set:

    struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;

...and then goes on to use that mdsc pointer.

I wonder if we ought to be moving move some of the operations in
ceph_kill_sb into ceph_put_super... particularly the call to
destroy_fs_client()?
-- 
Jeff Layton <jlayton@kernel.org>

