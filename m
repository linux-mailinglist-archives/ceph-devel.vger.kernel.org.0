Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE983F03D9
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Aug 2021 14:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhHRMmC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Aug 2021 08:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236050AbhHRMmA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 08:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DA5D61042;
        Wed, 18 Aug 2021 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629290485;
        bh=5JukVRcG8H705Stpy5sVk7sqZB5bGVSslKFZcD5NyIs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HcsDUYIe25inUMOOe/RwUeOCGK8yy4hh183zFP7q5WqsuAntYpFa03fxYC8bVkYE1
         CQj7rGjmawl39gv2iw6YPi05L4u4Ul5WOt7wIaB+jNx/QxIiU0Nq8wSU0/4s7OQe+q
         7lnhxI28Estggh1i9gI8JdR147spv7z1OwserVFyWdA4PN+K6vKXb6okZfXBcijj9a
         jvcQZFRWvnGXH9litKnXizK8nY7t/LfPsllLQCcfBfGQNSze/hRd6Jw+nMgE3oF+S6
         kqPlF/DGALLq+xyGSRzQK5d3xiZ0vCakSxI3tHux6UnLEwCjioa8IbrGfrkPXvQ8I0
         1WpU2LhTU7MCw==
Message-ID: <b4209c59c4ab68b7f98e32f82a900aabd888aebb.camel@kernel.org>
Subject: Re: [PATCH v3] ceph: correctly release memory from capsnap
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Date:   Wed, 18 Aug 2021 08:41:23 -0400
In-Reply-To: <CAOi1vP96mWo_pOyRX__t6gNhPofdY_HTqe+b8ekM40vjoEmShg@mail.gmail.com>
References: <20210818012515.64564-1-xiubli@redhat.com>
         <CAOi1vP96mWo_pOyRX__t6gNhPofdY_HTqe+b8ekM40vjoEmShg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-08-18 at 13:18 +0200, Ilya Dryomov wrote:
> On Wed, Aug 18, 2021 at 3:25 AM <xiubli@redhat.com> wrote:
> > 
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > When force umounting, it will try to remove all the session caps.
> > If there has any capsnap is in the flushing list, the remove session
> > caps callback will try to release the capsnap->flush_cap memory to
> > "ceph_cap_flush_cachep" slab cache, while which is allocated from
> > kmalloc-256 slab cache.
> > 
> > At the same time switch to list_del_init() because just in case the
> > force umount has removed it from the lists and the
> > handle_cap_flushsnap_ack() comes then the seconds list_del_init()
> > won't crash the kernel.
> > 
> > URL: https://tracker.ceph.com/issues/52283
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> > 
> > V3:
> > - rebase to the upstream
> > 
> > 
> >  fs/ceph/caps.c       | 18 ++++++++++++++----
> >  fs/ceph/mds_client.c |  7 ++++---
> >  2 files changed, 18 insertions(+), 7 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 1b9ca437da92..e239f06babbc 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1712,7 +1712,16 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
> > 
> >  struct ceph_cap_flush *ceph_alloc_cap_flush(void)
> >  {
> > -       return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> > +       struct ceph_cap_flush *cf;
> > +
> > +       cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
> > +       /*
> > +        * caps == 0 always means for the capsnap
> > +        * caps > 0 means dirty caps being flushed
> > +        * caps == -1 means preallocated, not used yet
> > +        */
> 
> Hi Xiubo,
> 
> This comment should be in super.h, on struct ceph_cap_flush
> definition.
> 
> But more importantly, are you sure that overloading cf->caps this way
> is safe?  For example, __kick_flushing_caps() tests for cf->caps != 0
> and cf->caps == -1 would be interpreted as a cue to call __prep_cap().
> 
> Thanks,
> 
>                 Ilya
> 

The cf->caps field should get set to a sane value when it goes onto the
i_cap_flush_list, and I don't see how we'd get into testing against the
->caps field before that point. That said, this mechanism does seem a
bit fragile and subject to later breakage, and the caps code is anything
but clear and easy to follow.

pahole says that there is a 3 byte hole just after the "wake" field in
ceph_cap_flush on x86_64, and that's probably true on other arches as
well. Rather than overloading the caps field with this info, you could
add a new bool there to indicate whether it's embedded or not.


> > +       cf->caps = -1;
> > +       return cf;
> >  }
> > 
> >  void ceph_free_cap_flush(struct ceph_cap_flush *cf)
> > @@ -1747,7 +1756,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
> >                 prev->wake = true;
> >                 wake = false;
> >         }
> > -       list_del(&cf->g_list);
> > +       list_del_init(&cf->g_list);
> >         return wake;
> >  }
> > 
> > @@ -1762,7 +1771,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
> >                 prev->wake = true;
> >                 wake = false;
> >         }
> > -       list_del(&cf->i_list);
> > +       list_del_init(&cf->i_list);
> >         return wake;
> >  }
> > 
> > @@ -3642,7 +3651,8 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
> >                 cf = list_first_entry(&to_remove,
> >                                       struct ceph_cap_flush, i_list);
> >                 list_del(&cf->i_list);
> > -               ceph_free_cap_flush(cf);
> > +               if (cf->caps)
> > +                       ceph_free_cap_flush(cf);
> >         }
> > 
> >         if (wake_ci)
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 1e013fb09d73..a44adbd1841b 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -1636,7 +1636,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >                 spin_lock(&mdsc->cap_dirty_lock);
> > 
> >                 list_for_each_entry(cf, &to_remove, i_list)
> > -                       list_del(&cf->g_list);
> > +                       list_del_init(&cf->g_list);
> > 
> >                 if (!list_empty(&ci->i_dirty_item)) {
> >                         pr_warn_ratelimited(
> > @@ -1688,8 +1688,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >                 struct ceph_cap_flush *cf;
> >                 cf = list_first_entry(&to_remove,
> >                                       struct ceph_cap_flush, i_list);
> > -               list_del(&cf->i_list);
> > -               ceph_free_cap_flush(cf);
> > +               list_del_init(&cf->i_list);
> > +               if (cf->caps)
> > +                       ceph_free_cap_flush(cf);
> >         }
> > 
> >         wake_up_all(&ci->i_cap_wq);
> > --
> > 2.27.0
> > 

-- 
Jeff Layton <jlayton@kernel.org>

