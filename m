Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12276199908
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Mar 2020 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgCaO4R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Mar 2020 10:56:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730511AbgCaO4R (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 10:56:17 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B09720675;
        Tue, 31 Mar 2020 14:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585666575;
        bh=OOZ/XYwxVESe0oYwJ1LyN7poodjIGDH8Yn9TlzjfQAk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R8PQGEsBrV2Xt+afDExWOdZBOz6sexXV8smQPPwLKymZTAF9xnCKBGUnw0WuUXkJ9
         9m2fkWfwS+KB/Oh2wq07F4bhIOaHyA9u8mbJS/WsQ+4Q4BVLIAqxKtpMTWnigusaP3
         xkwyzF8vtxw1SxDL9CGlW7K2LNwhOjYJGD2UO5Ek=
Message-ID: <924ac730ea35f3a10c3828f3b532a2b7642776dc.camel@kernel.org>
Subject: Re: [PATCH] ceph: request expedited service when flushing caps
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 31 Mar 2020 10:56:13 -0400
In-Reply-To: <CAJ4mKGbMgoQ6tgsiQchR2QirxOW_oPOuNo5X26YKpy66yHD+FA@mail.gmail.com>
References: <20200331105223.9610-1-jlayton@kernel.org>
         <CAAM7YAmzyYrREBtmX+JrEQMMuo9LhZ2J2c-PyahQaAiVVEn2fQ@mail.gmail.com>
         <CAJ4mKGbMgoQ6tgsiQchR2QirxOW_oPOuNo5X26YKpy66yHD+FA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-03-31 at 07:00 -0700, Gregory Farnum wrote:
> On Tue, Mar 31, 2020 at 6:49 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > On Tue, Mar 31, 2020 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Jan noticed some long stalls when flushing caps using sync() after
> > > doing small file creates. For instance, running this:
> > > 
> > >     $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done
> > > 
> > > Could take more than 90s in some cases. The sync() will flush out caps,
> > > but doesn't tell the MDS that it's waiting synchronously on the
> > > replies.
> > > 
> > > When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
> > > CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
> > > into that fact and it can then expedite the reply.
> > > 
> > > URL: https://tracker.ceph.com/issues/44744
> > > Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/caps.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 61808793e0c0..6403178f2376 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> > > 
> > >                 mds = cap->mds;  /* remember mds, so we don't repeat */
> > > 
> > > -               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> > > -                          retain, flushing, flush_tid, oldest_flush_tid);
> > > +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
> > > +                          (flags & CHECK_CAPS_FLUSH) ?
> > > +                           CEPH_CLIENT_CAPS_SYNC : 0,
> > > +                          cap_used, want, retain, flushing, flush_tid,
> > > +                          oldest_flush_tid);
> > >                 spin_unlock(&ci->i_ceph_lock);
> > > 
> > 
> > this is too expensive for syncfs case. mds needs to flush journal for
> > each dirty inode.  we'd better to track dirty inodes by session, and
> > only set the flag when flushing the last inode in session dirty list.

I think this will be more difficult than that...

> 
> Yeah, see the userspace Client::_sync_fs() where we have an internal
> flags argument which is set on the last cap in the dirty set and tells
> the actual cap message flushing code to set FLAG_SYNC on the
> MClientCaps message. I presume the kernel is operating on a similar
> principle here?

Not today, but we need it to.

The caps are not tracked on a per-session basis (as Zheng points out),
and the locking and ordering of these requests is not as straightforward
as it is in the (trivial) libcephfs case. Fixing this will be a lot more
invasive than I had originally hoped.

It's also not 100% clear to me how we'll gauge which cap will be
"last".  As we move the last cap on the session's list from dirty to
flushing state, we can mark it so that it sets the SYNC flag when it
goes out, but what happens if we have a process that is actively
dirtying other inodes during this? You might never see the per-session
list go empty.

It may also go empty for reasons that have nothing to do with issuing a
sync(), (or fsync() or...) so we don't want to universally set this flag
in that case.

I'm not sure what the right solution is yet.
-- 
Jeff Layton <jlayton@kernel.org>

