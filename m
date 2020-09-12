Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D937126796D
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Sep 2020 12:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbgILKSJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 12 Sep 2020 06:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgILKSD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 12 Sep 2020 06:18:03 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 420B4214D8;
        Sat, 12 Sep 2020 10:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599905882;
        bh=OF+hVNfMyyA5VO21wxb0KC4fe+IoHLmDQsnwVS+NKpQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EWG1EZkQIVq6mvVTm7iZYY8FQvavBuv7kkX7e3+jDFZDpnh7sSsHGjD3k+9h6Fkpm
         OmXQJv+z+wROFFpYe5Son+WGuBjdbkQ6CYgSJ0eMiIOf4ZV36HUz6Gz4NH5JmNKH2m
         8bYKsQzm9GPrCC8797hzCnk43+1YNrHnHduuGoGg=
Message-ID: <f6c10f718fcb7ce2643bea899953516d1df53033.camel@kernel.org>
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Sat, 12 Sep 2020 06:18:01 -0400
In-Reply-To: <d71bf067-50ce-36f3-a627-409aff755a16@redhat.com>
References: <20200903130140.799392-1-xiubli@redhat.com>
         <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
         <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
         <CAOi1vP-8rbzZ=-Apir2B4Z6U10ZKrp41d6+BYgvGsyL+ND-JnQ@mail.gmail.com>
         <cdf40ea5-ecd0-0df6-7db4-7897aa3a5ad0@redhat.com>
         <CAOi1vP-XxXVcvyZgQF7mWaxm-21hiY5fF4tRYkua-F9ikof7UA@mail.gmail.com>
         <e291d899acee9f9218fe9a62f7300ab82592c459.camel@kernel.org>
         <9a5c5d2f-d105-21c4-327e-5ad18bf49518@redhat.com>
         <a281843181d1c97d099a2dd88c216ca94cf8d544.camel@kernel.org>
         <d174f7f99b4da9a2959b93bad622792fb693e495.camel@kernel.org>
         <d71bf067-50ce-36f3-a627-409aff755a16@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2020-09-12 at 12:04 +0800, Xiubo Li wrote:
> On 2020/9/12 3:46, Jeff Layton wrote:
> > On Fri, 2020-09-11 at 07:49 -0400, Jeff Layton wrote:
> > > On Fri, 2020-09-11 at 11:43 +0800, Xiubo Li wrote:
> > > > On 2020/9/10 20:13, Jeff Layton wrote:
> > > > > On Thu, 2020-09-10 at 08:00 +0200, Ilya Dryomov wrote:
> > > > > > On Thu, Sep 10, 2020 at 2:59 AM Xiubo Li <xiubli@redhat.com> wrote:
> > > > > > > On 2020/9/10 4:34, Ilya Dryomov wrote:
> > > > > > > > On Thu, Sep 3, 2020 at 4:22 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > > > > > > > On 2020/9/3 22:18, Jeff Layton wrote:
> > > > > > > > > > On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
> > > > > > > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > > > > > > 
> > > > > > > > > > > Changed in V5:
> > > > > > > > > > > - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
> > > > > > > > > > > - Remove the is_opened member.
> > > > > > > > > > > 
> > > > > > > > > > > Changed in V4:
> > > > > > > > > > > - A small fix about the total_inodes.
> > > > > > > > > > > 
> > > > > > > > > > > Changed in V3:
> > > > > > > > > > > - Resend for V2 just forgot one patch, which is adding some helpers
> > > > > > > > > > > support to simplify the code.
> > > > > > > > > > > 
> > > > > > > > > > > Changed in V2:
> > > > > > > > > > > - Add number of inodes that have opened files.
> > > > > > > > > > > - Remove the dir metrics and fold into files.
> > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > Xiubo Li (2):
> > > > > > > > > > >       ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
> > > > > > > > > > >       ceph: metrics for opened files, pinned caps and opened inodes
> > > > > > > > > > > 
> > > > > > > > > > >      fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
> > > > > > > > > > >      fs/ceph/debugfs.c | 11 +++++++++++
> > > > > > > > > > >      fs/ceph/dir.c     | 20 +++++++-------------
> > > > > > > > > > >      fs/ceph/file.c    | 13 ++++++-------
> > > > > > > > > > >      fs/ceph/inode.c   | 11 ++++++++---
> > > > > > > > > > >      fs/ceph/locks.c   |  2 +-
> > > > > > > > > > >      fs/ceph/metric.c  | 14 ++++++++++++++
> > > > > > > > > > >      fs/ceph/metric.h  |  7 +++++++
> > > > > > > > > > >      fs/ceph/quota.c   | 10 +++++-----
> > > > > > > > > > >      fs/ceph/snap.c    |  2 +-
> > > > > > > > > > >      fs/ceph/super.h   |  6 ++++++
> > > > > > > > > > >      11 files changed, 103 insertions(+), 34 deletions(-)
> > > > > > > > > > > 
> > > > > > > > > > Looks good. I went ahead and merge this into testing.
> > > > > > > > > > 
> > > > > > > > > > Small merge conflict in quota.c, which I guess is probably due to not
> > > > > > > > > > basing this on testing branch. I also dropped what looks like an
> > > > > > > > > > unrelated hunk in the second patch.
> > > > > > > > > > 
> > > > > > > > > > In the future, if you can be sure that patches you post apply cleanly to
> > > > > > > > > > testing branch then that would make things easier.
> > > > > > > > > Okay, will do it.
> > > > > > > > Hi Xiubo,
> > > > > > > > 
> > > > > > > > There is a problem with lifetimes here.  mdsc isn't guaranteed to exist
> > > > > > > > when ->free_inode() is called.  This can lead to crashes on a NULL mdsc
> > > > > > > > in ceph_free_inode() in case of e.g. "umount -f".  I know it was Jeff's
> > > > > > > > suggestion to move the decrement of total_inodes into ceph_free_inode(),
> > > > > > > > but it doesn't look like it can be easily deferred past ->evict_inode().
> > > > > > > Okay, I will take a look.
> > > > > > Given that it's just a counter which we don't care about if the
> > > > > > mount is going away, some form of "if (mdsc)" check might do, but
> > > > > > need to make sure that it covers possible races, if any.
> > > > > > 
> > > > > Good catch, Ilya.
> > > > > 
> > > > > What may be best is to move the increment out of ceph_alloc_inode and
> > > > > instead put it in ceph_set_ino_cb. Then the decrement can go back into
> > > > > ceph_evict_inode.
> > > > Hi Jeff, Ilya
> > > > 
> > > > Checked the code, it seems in the ceph_evict_inode() we will also hit
> > > > the same issue .
> > > > 
> > > > With the '-f' options when umounting, it will skip the inodes whose
> > > > i_count ref > 0. And then free the fsc/mdsc in ceph. And later the
> > > > iput_final() will call the ceph_evict_inode() and then ceph_free_inode().
> > > > 
> > > > Could we just check if !!(sb->s_flags & SB_ACTIVE) is false will we skip
> > > > the counting ?
> > > > 
> > > Note that umount -f (MNT_FORCE) just means that ceph_umount_begin is
> > > called before unmounting.
> > > 
> > > If what you're saying it true, then we have bigger problems.
> > > ceph_evict_inode does this today when ci->i_snap_realm is set:
> > > 
> > >      struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
> > > 
> > > ...and then goes on to use that mdsc pointer.
> > > 
> > Now that I look, I don't think that this is a problem. ceph_kill_sb
> > calls generic_shutdown_super, which calls evict_inodes before the client
> > is torn down. That should ensure that the mdsc is still good when evict
> > is called.
> > 
> > We will need to move the increment into the iget5_locked "set" function.
> > Maybe we can squash the patch below into yours?
> 
> Yeah, the following patch looks good.
> 

Great, folded and re-pushed into testing. Please take a look and make sure the resulting patch looks ok to you.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

