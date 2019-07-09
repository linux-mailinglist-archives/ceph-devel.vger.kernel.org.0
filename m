Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCD163884
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2019 17:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfGIPVL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Jul 2019 11:21:11 -0400
Received: from mail-yw1-f42.google.com ([209.85.161.42]:44789 "EHLO
        mail-yw1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPVK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Jul 2019 11:21:10 -0400
Received: by mail-yw1-f42.google.com with SMTP id l79so6436473ywe.11
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=fhkriF/Y+cl7u876De+fplkGc9QVLsWt8YZh1XKoh1Y=;
        b=c5qAB/RiXPhPhkmPwA3MnX4MejAne1t6fQ7NlxIV9YLKAAgQdWzqy9VduloIui9+Ju
         bjFRvGicB1ArXJCeEfr5SYftyEfNUKpaFAW/u3Op8iMGjrXgT01H0RkfkMyN9OsAnUfD
         +qjrE2Ao8i0Shz3uIEew0zCUG1niMUzTwQXWcLadTWVgBtqORA3k8n4fiPO5sduDLbid
         epMovEfWaOhqP/9RBXondDEUlFG4y3r55g8GFi4Nr+ovrZFzeTWLzo/Hab0kVTEAclqp
         f2iFEFE6rCTnSxCvq6vxWL3Nb71nYNLOft4kDS6KGU2ICVYWSTKEXZobzAYaCRBZDT2o
         2Z3g==
X-Gm-Message-State: APjAAAVsE1Qx1pwhttyUOSmo4IA+zYLoXT779ysPmIE+/cwH/eM5KtiZ
        +HNfJK1Q6+espuDJbcssnP7g1Q==
X-Google-Smtp-Source: APXvYqzv8TsAfU29L4/jS3aHo+2PSajWZwhxlIHLxS7/cjbWlZ+bBNDjschfkE5o+rHCwWVRsyOVEw==
X-Received: by 2002:a0d:df4b:: with SMTP id i72mr15718057ywe.106.1562685669745;
        Tue, 09 Jul 2019 08:21:09 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-43E.dyn6.twc.com. [2606:a000:1100:37d::43e])
        by smtp.gmail.com with ESMTPSA id z6sm5977990ywj.97.2019.07.09.08.21.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:21:09 -0700 (PDT)
Message-ID: <eefeb9f64aac3a678c31250ef91ea189caf10aef.camel@redhat.com>
Subject: Re: ceph_fsync race with reconnect?
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@newdream.net>,
        "open list:CEPH DISTRIBUTED..." <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 09 Jul 2019 11:21:07 -0400
In-Reply-To: <CAAM7YA=Cug6x+2m+RVNjmEaJaMsTAufx__yZug5SeREQSfy2tA@mail.gmail.com>
References: <f93a412ecd6b17389622ac7d0ae9b225921e4163.camel@redhat.com>
         <CAAM7YA=DW5jYtWkz-gqZ_Eg8ko-sK8mChMGB7yOV=Xz8o=AhLQ@mail.gmail.com>
         <35a7c9dce30f557a3be756cfeb15c0e471ae80ce.camel@redhat.com>
         <CAAM7YA=Cug6x+2m+RVNjmEaJaMsTAufx__yZug5SeREQSfy2tA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-07-09 at 22:50 +0800, Yan, Zheng wrote:
> On Tue, Jul 9, 2019 at 6:13 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Tue, 2019-07-09 at 07:52 +0800, Yan, Zheng wrote:
> > > On Tue, Jul 9, 2019 at 3:23 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > I've been working on a patchset to add inline write support to kcephfs,
> > > > and have run across a potential race in fsync. I could use someone to
> > > > sanity check me though since I don't have a great grasp of the MDS
> > > > session handling:
> > > > 
> > > > ceph_fsync() calls try_flush_caps() to flush the dirty metadata back to
> > > > the MDS when Fw caps are flushed back.  try_flush_caps does this,
> > > > however:
> > > > 
> > > >                 if (cap->session->s_state < CEPH_MDS_SESSION_OPEN) {
> > > >                         spin_unlock(&ci->i_ceph_lock);
> > > >                         goto out;
> > > >                 }
> > > > 
> > > 
> > > enum {
> > >         CEPH_MDS_SESSION_NEW = 1,
> > >         CEPH_MDS_SESSION_OPENING = 2,
> > >         CEPH_MDS_SESSION_OPEN = 3,
> > >         CEPH_MDS_SESSION_HUNG = 4,
> > >         CEPH_MDS_SESSION_RESTARTING = 5,
> > >         CEPH_MDS_SESSION_RECONNECTING = 6,
> > >         CEPH_MDS_SESSION_CLOSING = 7,
> > >         CEPH_MDS_SESSION_REJECTED = 8,
> > > };
> > > 
> > > the value of reconnect state is larger than 2
> > > 
> > 
> > Right, I get that. The big question is whether you can ever move from a
> > higher state to something less than CEPH_MDS_SESSION_OPEN.
> > 
> 
> I guess it does not happen because closing session happens only when
> umounting.
> 

Got it, that makes some sense.

> But there is a corner case in handle_cap_export(). It set inode's auth
> cap to a place holder cap. the placeholder cap's session can be in
> opening state.
> 
> > __do_request can do this:
> > 
> >                 if (session->s_state == CEPH_MDS_SESSION_NEW ||
> >                     session->s_state == CEPH_MDS_SESSION_CLOSING)
> >                         __open_session(mdsc, session);
> > 


Given that though, does it make sense to call __open_session when the
state is CLOSING? Should we not just set req->r_err and return at that
point?

> > ...and __open_session does this:
> > 
> >         session->s_state = CEPH_MDS_SESSION_OPENING;
> > 
> > ...so it sort of looks like you can go from CLOSING(7) to OPENING(2).
> > That said, I don't have a great feel for the session state transitions,
> > and don't know whether this is a real possibility.
> > 
> > > > ...at that point, try_flush_caps will return 0, and set *ptid to 0 on
> > > > the way out. ceph_fsync won't see that Fw is still dirty at that point
> > > > and won't wait, returning without flushing metadata.
> > > > 
> > > > Am I missing something that prevents this? I can open a tracker bug for
> > > > this if it is a problem, but I wanted to be sure it was a bug before I
> > > > did so.
> > > > 
> > > > Thanks,
> > > > --
> > > > Jeff Layton <jlayton@redhat.com>
> > > > 
> > 
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 

-- 
Jeff Layton <jlayton@redhat.com>

