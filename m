Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EDA19AB45
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Apr 2020 14:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732267AbgDAMIE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Apr 2020 08:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726804AbgDAMID (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 08:08:03 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFC8E20776;
        Wed,  1 Apr 2020 12:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585742882;
        bh=BIlp8gq2dWJFAYEHPLLkx4OrC/HXUMMAIqST7SGRIzs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vRt98nRHC2xD6LPY5/8iG60wiSIdbeAZMbFA+W7rWkgMMRg6YnuUs6X++2tgatRms
         qMnxOuxbeNk7/EugnDyzvMfKFb/icG1Ag2oubhyHnbExB7rfUMO29Yt9o7V1IgB3oX
         RETqC0hQOBJmmIjZW17FWJJXlEN4QMPIJDvCk0EY=
Message-ID: <7c3ab3cdda4abae4e43a8bae15cb98c689b0f717.camel@kernel.org>
Subject: Re: [PATCH] ceph: request expedited service when flushing caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>
Date:   Wed, 01 Apr 2020 08:08:00 -0400
In-Reply-To: <CAAM7YAmwduzm6kWw7rv62TMgJoZCqstZWOiQTVoP8LhxutHUuw@mail.gmail.com>
References: <20200331105223.9610-1-jlayton@kernel.org>
         <CAAM7YAmzyYrREBtmX+JrEQMMuo9LhZ2J2c-PyahQaAiVVEn2fQ@mail.gmail.com>
         <CAJ4mKGbMgoQ6tgsiQchR2QirxOW_oPOuNo5X26YKpy66yHD+FA@mail.gmail.com>
         <924ac730ea35f3a10c3828f3b532a2b7642776dc.camel@kernel.org>
         <CAAM7YAmwduzm6kWw7rv62TMgJoZCqstZWOiQTVoP8LhxutHUuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-04-01 at 19:04 +0800, Yan, Zheng wrote:
> On Tue, Mar 31, 2020 at 10:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Tue, 2020-03-31 at 07:00 -0700, Gregory Farnum wrote:
> > > On Tue, Mar 31, 2020 at 6:49 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > > > On Tue, Mar 31, 2020 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > Jan noticed some long stalls when flushing caps using sync() after
> > > > > doing small file creates. For instance, running this:
> > > > > 
> > > > >     $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done
> > > > > 
> > > > > Could take more than 90s in some cases. The sync() will flush out caps,
> > > > > but doesn't tell the MDS that it's waiting synchronously on the
> > > > > replies.
> > > > > 
> > > > > When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
> > > > > CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
> > > > > into that fact and it can then expedite the reply.
> > > > > 
> > > > > URL: https://tracker.ceph.com/issues/44744
> > > > > Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/ceph/caps.c | 7 +++++--
> > > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > > index 61808793e0c0..6403178f2376 100644
> > > > > --- a/fs/ceph/caps.c
> > > > > +++ b/fs/ceph/caps.c
> > > > > @@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> > > > > 
> > > > >                 mds = cap->mds;  /* remember mds, so we don't repeat */
> > > > > 
> > > > > -               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> > > > > -                          retain, flushing, flush_tid, oldest_flush_tid);
> > > > > +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
> > > > > +                          (flags & CHECK_CAPS_FLUSH) ?
> > > > > +                           CEPH_CLIENT_CAPS_SYNC : 0,
> > > > > +                          cap_used, want, retain, flushing, flush_tid,
> > > > > +                          oldest_flush_tid);
> > > > >                 spin_unlock(&ci->i_ceph_lock);
> > > > > 
> > > > 
> > > > this is too expensive for syncfs case. mds needs to flush journal for
> > > > each dirty inode.  we'd better to track dirty inodes by session, and
> > > > only set the flag when flushing the last inode in session dirty list.
> > 
> > I think this will be more difficult than that...
> > 
> > > Yeah, see the userspace Client::_sync_fs() where we have an internal
> > > flags argument which is set on the last cap in the dirty set and tells
> > > the actual cap message flushing code to set FLAG_SYNC on the
> > > MClientCaps message. I presume the kernel is operating on a similar
> > > principle here?
> > 
> > Not today, but we need it to.
> > 
> > The caps are not tracked on a per-session basis (as Zheng points out),
> > and the locking and ordering of these requests is not as straightforward
> > as it is in the (trivial) libcephfs case. Fixing this will be a lot more
> > invasive than I had originally hoped.
> > 
> > It's also not 100% clear to me how we'll gauge which cap will be
> > "last".  As we move the last cap on the session's list from dirty to
> > flushing state, we can mark it so that it sets the SYNC flag when it
> > goes out, but what happens if we have a process that is actively
> > dirtying other inodes during this? You might never see the per-session
> > list go empty.
> > 
> 
> It's not necessary to be strict 'last'.  just the one before exiting the loop
> 

What loop?

I added a little debugging code and ran Jan's reproducer, and it turns
out that we generally move the inode to flushing state in
ceph_put_wrbuffer_cap_refs while doing writeback under the sync syscall.
By the time we get to any sort of looping in the ceph code, the cap
flushes have already been issued.

My tentative idea was to just check whether this was the last dirty cap
associated with the session and set the flag on it if so, but we don't
really have visibility into that info, because we don't determine the
session until we move the inode from dirty->flushing.

So at this point, I'm still looking at options for fixing this. I really
don't want to just hack this in, as the technical debt in this code is
already substantial and that'll just make it worse.
-- 
Jeff Layton <jlayton@kernel.org>

