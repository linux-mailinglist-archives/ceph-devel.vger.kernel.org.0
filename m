Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080492DEB2D
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Dec 2020 22:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgLRVhN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Dec 2020 16:37:13 -0500
Received: from mail-qk1-f179.google.com ([209.85.222.179]:33979 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLRVhN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Dec 2020 16:37:13 -0500
Received: by mail-qk1-f179.google.com with SMTP id c7so3520130qke.1
        for <ceph-devel@vger.kernel.org>; Fri, 18 Dec 2020 13:36:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zY4RrYLLWf6/2rBQfiRyfYj7g1grLM82+6ej15zCWhE=;
        b=jQDA6VXSNIdzVHJBXeFU9msmzmVTQJ1EyJmHZ3TI5knRMtaFQzOOpzbTtNPkCUHvXA
         sg/BbjSmDWRbQx1AeweglyeNz9njqdrSa+t6pP0j9oqZ0kRpk/iEJb1rLcIsibbYXH5f
         cVVsOh5TFft/nT/BcXTZWFaCZ+1hAbjyTnP/XXwZGpA2DRxTkDAEEhLco3lhybLRpYsI
         1VOTv2GPQrTNbFi3/tTh+rePL62x17EmfOqKOGgDDvNG5bVaAqcqjHgcjrTED4j619Mp
         j2LIta3zSG7OPq4GhJ0p51Y2OPZ5uM8ibrUmZjVThvHJSxNM/VE9EE8/5Isod71BCtVD
         jjbw==
X-Gm-Message-State: AOAM532EfE9Th1S302VYzDx/r8mGuuO6Rnf57jbZ7hIyuu8OXU4ADfc5
        LfNQvMzanK8OSMihzd4vq5YSHm0ZftDeTg==
X-Google-Smtp-Source: ABdhPJxoRiJ8uV1/sSpl6msbTzLsWAlmHxlkmRjJ3qg643lWXCldS5WLCa4eFYfixqzw+we3QZwjow==
X-Received: by 2002:a37:4c05:: with SMTP id z5mr7019286qka.245.1608327392380;
        Fri, 18 Dec 2020 13:36:32 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 9sm6474963qtr.64.2020.12.18.13.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 13:36:31 -0800 (PST)
Date:   Fri, 18 Dec 2020 16:36:29 -0500
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Subject: Re: [PATCH 3/3] ceph: allow queueing cap/snap handling after putting
 cap references
Message-ID: <20201218213629.GA1254519@tleilax.poochiereds.net>
References: <20201211123858.7522-1-jlayton@kernel.org>
 <20201211123858.7522-4-jlayton@kernel.org>
 <CAOi1vP-qh2YWn_c=zUVB3czepSYau+n2paMZHA2nJDVhwyk-EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOi1vP-qh2YWn_c=zUVB3czepSYau+n2paMZHA2nJDVhwyk-EQ@mail.gmail.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Dec 18, 2020 at 03:22:51PM +0100, Ilya Dryomov wrote:
> On Fri, Dec 11, 2020 at 1:39 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > Testing with the fscache overhaul has triggered some lockdep warnings
> > about circular lock dependencies involving page_mkwrite and the
> > mmap_lock. It'd be better to do the "real work" without the mmap lock
> > being held.
> >
> > Change the skip_checking_caps parameter in __ceph_put_cap_refs to an
> > enum, and use that to determine whether to queue check_caps, do it
> > synchronously or not at all. Change ceph_page_mkwrite to do a
> > ceph_put_cap_refs_async().
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/addr.c  |  2 +-
> >  fs/ceph/caps.c  | 28 ++++++++++++++++++++++++----
> >  fs/ceph/inode.c |  6 ++++++
> >  fs/ceph/super.h | 19 ++++++++++++++++---
> >  4 files changed, 47 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 950552944436..26e66436f005 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1662,7 +1662,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> >
> >         dout("page_mkwrite %p %llu~%zd dropping cap refs on %s ret %x\n",
> >              inode, off, len, ceph_cap_string(got), ret);
> > -       ceph_put_cap_refs(ci, got);
> > +       ceph_put_cap_refs_async(ci, got);
> >  out_free:
> >         ceph_restore_sigs(&oldset);
> >         sb_end_pagefault(inode->i_sb);
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 336348e733b9..a95ab4c02056 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -3026,6 +3026,12 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
> >         return 0;
> >  }
> >
> > +enum PutCapRefsMode {
> > +       PutCapRefsModeSync = 0,
> > +       PutCapRefsModeSkip,
> > +       PutCapRefsModeAsync,
> > +};
> 
> Hi Jeff,
> 
> A couple style nits, since mixed case stood out ;)
> 
> Let's avoid CamelCase.  Page flags and existing protocol definitions
> like SMB should be the only exception.  I'd suggest PUT_CAP_REFS_SYNC,
> etc.
> 
> > +
> >  /*
> >   * Release cap refs.
> >   *
> > @@ -3036,7 +3042,7 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
> >   * cap_snap, and wake up any waiters.
> >   */
> >  static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
> > -                               bool skip_checking_caps)
> > +                               enum PutCapRefsMode mode)
> >  {
> >         struct inode *inode = &ci->vfs_inode;
> >         int last = 0, put = 0, flushsnaps = 0, wake = 0;
> > @@ -3092,11 +3098,20 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
> >         dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
> >              last ? " last" : "", put ? " put" : "");
> >
> > -       if (!skip_checking_caps) {
> > +       switch(mode) {
> > +       default:
> > +               break;
> > +       case PutCapRefsModeSync:
> >                 if (last)
> >                         ceph_check_caps(ci, 0, NULL);
> >                 else if (flushsnaps)
> >                         ceph_flush_snaps(ci, NULL);
> > +               break;
> > +       case PutCapRefsModeAsync:
> > +               if (last)
> > +                       ceph_queue_check_caps(inode);
> > +               else if (flushsnaps)
> > +                       ceph_queue_flush_snaps(inode);
> 
> Add a break here.  I'd also move the default clause to the end.
> 
> >         }
> >         if (wake)
> >                 wake_up_all(&ci->i_cap_wq);
> > @@ -3106,12 +3121,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
> >
> >  void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
> >  {
> > -       __ceph_put_cap_refs(ci, had, false);
> > +       __ceph_put_cap_refs(ci, had, PutCapRefsModeSync);
> > +}
> > +
> > +void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had)
> > +{
> > +       __ceph_put_cap_refs(ci, had, PutCapRefsModeAsync);
> >  }
> >
> >  void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
> >  {
> > -       __ceph_put_cap_refs(ci, had, true);
> > +       __ceph_put_cap_refs(ci, had, PutCapRefsModeSkip);
> 
> Perhaps name the enum member PUT_CAP_REFS_NO_CHECK to match the
> exported function?
> 
> Thanks,
> 
>                 Ilya

That all sounds reasonable. I'll send a v2 patch here in a few mins.

Thanks,
Jeff
