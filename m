Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8DC67354
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2019 18:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfGLQdx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Jul 2019 12:33:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfGLQdx (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Jul 2019 12:33:53 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7273320838;
        Fri, 12 Jul 2019 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562949232;
        bh=+xeUGsfb4Sq9JDLGXMlZyhUeCbNonjcXqbyqbbCErBw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sU0mWUaxYxUKTtdEwn5k/imtwvBvQF+icY/hL4HHI8cGSDYBqgWiSOwZuAgjXp8u6
         B5NgnF0t/aE7lPNNXknyE0rUhUizEtCA2a7kXWwPxuQXmrTJaPETZg6Rpj7PI8Lf0S
         bbRcOm93YwZe273ryyOBKXyMUj1/ya1HpQSdwB7M=
Message-ID: <5f9f895b9c0980f714fa76763e746a1cb42ac2ae.camel@kernel.org>
Subject: Re: [PATCH v2 3/5] ceph: fix potential races in ceph_uninline_data
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Zheng Yan <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sage@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Date:   Fri, 12 Jul 2019 12:33:50 -0400
In-Reply-To: <90861198da779dc1d36d3a85e6028aed15ebfdfa.camel@kernel.org>
References: <20190711184136.19779-1-jlayton@kernel.org>
         <20190711184136.19779-4-jlayton@kernel.org>
         <CAAM7YA=b7-Rj641+jR3vsEQwiuZTtgv_2MRfiMQ6r52N0+H83A@mail.gmail.com>
         <90861198da779dc1d36d3a85e6028aed15ebfdfa.camel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-07-12 at 09:30 -0400, Jeff Layton wrote:
> On Fri, 2019-07-12 at 10:44 +0800, Yan, Zheng wrote:
> > On Fri, Jul 12, 2019 at 3:17 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > The current code will do the uninlining but it relies on the callers to
> > > set the i_inline_version appropriately afterward. Multiple tasks can end
> > > up attempting to uninline the data, and overwrite changes that follow
> > > the first uninlining.
> > > 
> > > Protect against competing uninlining attempts by having the callers take
> > > the i_truncate_mutex and then have ceph_uninline_data update the version
> > > itself before dropping it. This means that we also need to have
> > > ceph_uninline_data mark the caps dirty and pass back I_DIRTY_* flags if
> > > any of them are newly dirty.
> > > 
> > > We can't mark the caps dirty though unless we actually have them, so
> > > move the uninlining after the point where Fw caps are acquired in all of
> > > the callers.
> > > 
> > > Finally, since we are doing a lockless check first in all cases, just
> > > move that into ceph_uninline_data as well, and have the callers call it
> > > unconditionally.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/addr.c | 119 +++++++++++++++++++++++++++++++++----------------
> > >  fs/ceph/file.c |  39 +++++++---------
> > >  2 files changed, 97 insertions(+), 61 deletions(-)
> > > 
> > > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > > index 038678963cf9..4606da82da6f 100644
> > > --- a/fs/ceph/addr.c
> > > +++ b/fs/ceph/addr.c
> > > @@ -1531,7 +1531,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> > >         loff_t off = page_offset(page);
> > >         loff_t size = i_size_read(inode);
> > >         size_t len;
> > > -       int want, got, err;
> > > +       int want, got, err, dirty;
> > >         sigset_t oldset;
> > >         vm_fault_t ret = VM_FAULT_SIGBUS;
> > > 
> > > @@ -1541,12 +1541,6 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> > > 
> > >         ceph_block_sigs(&oldset);
> > > 
> > > -       if (ci->i_inline_version != CEPH_INLINE_NONE) {
> > > -               err = ceph_uninline_data(inode, off == 0 ? page : NULL);
> > > -               if (err < 0)
> > > -                       goto out_free;
> > > -       }
> > > -
> > >         if (off + PAGE_SIZE <= size)
> > >                 len = PAGE_SIZE;
> > >         else
> > > @@ -1565,6 +1559,11 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> > >         if (err < 0)
> > >                 goto out_free;
> > > 
> > > +       err = ceph_uninline_data(inode, off == 0 ? page : NULL);
> > > +       if (err < 0)
> > > +               goto out_put_caps;
> > > +       dirty = err;
> > > +
> > >         dout("page_mkwrite %p %llu~%zd got cap refs on %s\n",
> > >              inode, off, len, ceph_cap_string(got));
> > > 
> > > @@ -1591,11 +1590,9 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> > > 
> > >         if (ret == VM_FAULT_LOCKED ||
> > >             ci->i_inline_version != CEPH_INLINE_NONE) {
> > > -               int dirty;
> > >                 spin_lock(&ci->i_ceph_lock);
> > > -               ci->i_inline_version = CEPH_INLINE_NONE;
> > > -               dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
> > > -                                              &prealloc_cf);
> > > +               dirty |= __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
> > > +                                               &prealloc_cf);
> > >                 spin_unlock(&ci->i_ceph_lock);
> > >                 if (dirty)
> > >                         __mark_inode_dirty(inode, dirty);
> > > @@ -1603,6 +1600,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> > > 
> > >         dout("page_mkwrite %p %llu~%zd dropping cap refs on %s ret %x\n",
> > >              inode, off, len, ceph_cap_string(got), ret);
> > > +out_put_caps:
> > >         ceph_put_cap_refs(ci, got);
> > >  out_free:
> > >         ceph_restore_sigs(&oldset);
> > > @@ -1656,27 +1654,60 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
> > >         }
> > >  }
> > > 
> > > +/**
> > > + * ceph_uninline_data - convert an inlined file to uninlined
> > > + * @inode: inode to be uninlined
> > > + * @page: optional pointer to first page in file
> > > + *
> > > + * Convert a file from inlined to non-inlined. We borrow the i_truncate_mutex
> > > + * to serialize callers and prevent races. Returns either a negative error code
> > > + * or a positive set of I_DIRTY_* flags that the caller should apply when
> > > + * dirtying the inode.
> > > + */
> > >  int ceph_uninline_data(struct inode *inode, struct page *provided_page)
> > >  {
> > >         struct ceph_inode_info *ci = ceph_inode(inode);
> > >         struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> > >         struct ceph_osd_request *req;
> > > +       struct ceph_cap_flush *prealloc_cf = NULL;
> > >         struct page *page = NULL;
> > >         u64 len, inline_version;
> > > -       int err = 0;
> > > +       int ret = 0;
> > >         bool from_pagecache = false;
> > >         bool allocated_page = false;
> > > 
> > > +       /* Do a lockless check first -- paired with i_ceph_lock for changes */
> > > +       inline_version = READ_ONCE(ci->i_inline_version);
> > > +       if (likely(inline_version == CEPH_INLINE_NONE))
> > > +               return 0;
> > > +
> > > +       dout("uninline_data %p %llx.%llx inline_version %llu\n",
> > > +            inode, ceph_vinop(inode), inline_version);
> > > +
> > > +       mutex_lock(&ci->i_truncate_mutex);
> > > +
> > > +       /* Double check the version after taking mutex */
> > >         spin_lock(&ci->i_ceph_lock);
> > >         inline_version = ci->i_inline_version;
> > >         spin_unlock(&ci->i_ceph_lock);
> > > 
> > > -       dout("uninline_data %p %llx.%llx inline_version %llu\n",
> > > -            inode, ceph_vinop(inode), inline_version);
> > > +       /* If someone beat us to the uninlining then just return. */
> > > +       if (inline_version == CEPH_INLINE_NONE)
> > > +               goto out;
> > > 
> > > -       if (inline_version == 1 || /* initial version, no data */
> > I'd like to avoid this optimization. check i_size instead.
> > 
> 
> This one is being removed already...
> 
> > > -           inline_version == CEPH_INLINE_NONE)
> > > +       prealloc_cf = ceph_alloc_cap_flush();
> > > +       if (!prealloc_cf) {
> > > +               ret = -ENOMEM;
> > >                 goto out;
> > > +       }
> > > +
> > > +       /*
> > > +        * Handle the initial version (1) as a a special case: switch the
> > > +        * version to CEPH_INLINE_NONE, but we don't need to do any uninlining
> > > +        * in that case since there is no data yet.
> > > +        */
> > > +       if (inline_version == 1)
> > > +               goto out_set_vers;
> > 
> > ditto
> > 
> 
> Fixed this up in my tree, and removed the places that set the
> i_inline_version to CEPH_INLINE_NONE in aio completion and cfr
> codepaths. I went ahead and pushed the result to the ceph-client/testing 
> branch.
> 
> Thanks to you and Luis for the review so far!
> 

Dang...I was going to do that, but I hit a deadlock this morning in
testing on xfstest generic/198:

[  160.393788] kworker/11:1    D    0   177      2 0x80004000
[  160.394953] Workqueue: ceph-msgr ceph_con_workfn [libceph]
[  160.396105] Call Trace:
[  160.396849]  ? __schedule+0x29f/0x680
[  160.397762]  schedule+0x33/0x90
[  160.398576]  io_schedule+0x12/0x40
[  160.399436]  __lock_page+0x13a/0x230
[  160.400329]  ? file_fdatawait_range+0x20/0x20
[  160.401326]  pagecache_get_page+0x196/0x370
[  160.402293]  ceph_fill_inline_data+0x190/0x2d0 [ceph]
[  160.403381]  handle_cap_grant+0x465/0xcd0 [ceph]
[  160.404409]  ceph_handle_caps+0xb1f/0x1900 [ceph]
[  160.405442]  dispatch+0x5a6/0x1220 [ceph]
[  160.406387]  ceph_con_workfn+0xd48/0x27e0 [libceph]
[  160.407432]  ? __switch_to_asm+0x40/0x70
[  160.408349]  ? __switch_to_asm+0x34/0x70
[  160.409264]  ? __switch_to_asm+0x40/0x70
[  160.410162]  ? __switch_to_asm+0x34/0x70
[  160.411048]  ? __switch_to_asm+0x40/0x70
[  160.411967]  ? __switch_to_asm+0x40/0x70
[  160.412850]  ? __switch_to+0x152/0x440
[  160.413697]  ? __switch_to_asm+0x34/0x70
[  160.414550]  process_one_work+0x19d/0x380
[  160.415415]  worker_thread+0x50/0x3b0
[  160.416236]  kthread+0xfb/0x130
[  160.416981]  ? process_one_work+0x380/0x380
[  160.417884]  ? kthread_park+0x90/0x90
[  160.418708]  ret_from_fork+0x22/0x40

[  160.435539] aiodio_sparse2  D    0  1615   1474 0x00004000
[  160.436575] Call Trace:
[  160.437226]  ? __schedule+0x29f/0x680
[  160.438020]  schedule+0x33/0x90
[  160.438751]  schedule_preempt_disabled+0xa/0x10
[  160.439652]  __mutex_lock.isra.0+0x25a/0x4b0
[  160.440533]  ceph_check_caps+0x66a/0xa80 [ceph]
[  160.441450]  ? __mark_inode_dirty+0xd2/0x370
[  160.442336]  ceph_put_cap_refs+0x1f5/0x350 [ceph]
[  160.443285]  ? __ceph_mark_dirty_caps+0x14e/0x270 [ceph]
[  160.444312]  ceph_page_mkwrite+0x1d2/0x360 [ceph]
[  160.445252]  do_page_mkwrite+0x30/0xc0
[  160.446067]  __handle_mm_fault+0x1020/0x1ac0
[  160.446941]  handle_mm_fault+0xc4/0x1f0
[  160.447777]  do_user_addr_fault+0x1f6/0x450
[  160.448638]  do_page_fault+0x33/0x120
[  160.449445]  ? async_page_fault+0x8/0x30
[  160.450298]  async_page_fault+0x1e/0x30

I think page_mkwrite has locked the page, and is trying to lock the
s_mutex, but handle_cap_grant already holds that mutex and is trying to
lock the page. So, an ABBA deadlock...

The interesting bit is that this does not seem to involve any of the
code that I touched. I think the changes I've made may be exposing this
somehow, possibly changing how caps are being handed out or something.

I'm still looking how best to fix it.
-- 
Jeff Layton <jlayton@kernel.org>

