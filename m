Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2FDF3EF194
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 20:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhHQSOp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 14:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231438AbhHQSOm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 14:14:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D18D060F5E;
        Tue, 17 Aug 2021 18:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629224049;
        bh=Y21xT+A5/PnV88lDM/MEa+u2Gz9I320v+eFGnPb4CK4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IUr67fRRAUzUoNu/nvyY2NhT/hNGO+2NcCwq8Q5Zgde/JqRZUKaUfhjor8nwTMim1
         SP7xEuuj9dwnzN37hDwV3Diz5RiEHAp9xjTO8qutO978UqSSAdSx5rnEf3ArfZ5qks
         4H/384pDihCJmhfRkvpZ4ZJ1coDQWXhRewKQxiby7mUApIRsUEDhiXBpwX/NFz59t5
         ttVhpfPzF1ubb5UTQInBt3RhbU9taKqt34Omn8QXVzGQnoqrw3S1xRcoHvV0v3AGGt
         2c98sVTzRQqfGkd80vfhfGiJUrVjC6KSN59M9rtH7dWlHH/s9UQKgBZSeOW6p0vd4s
         uEfNFiO+LcNmQ==
Message-ID: <6b29b8b523fa3e45635b02c455dfecd5a0cf9b88.camel@kernel.org>
Subject: Re: [PATCH] ceph: try to reconnect to the export targets
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Tue, 17 Aug 2021 14:14:07 -0400
In-Reply-To: <CAJ4mKGb5oR-3mOKpoQ-d2aHbRhq0qMHm4gBCAqz-Lrm4n4kQgg@mail.gmail.com>
References: <20210812041042.132984-1-xiubli@redhat.com>
         <bc940c0fe07921d6e63b4a2316e93d84c96da201.camel@kernel.org>
         <CAJ4mKGb5oR-3mOKpoQ-d2aHbRhq0qMHm4gBCAqz-Lrm4n4kQgg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-08-17 at 10:56 -0700, Gregory Farnum wrote:
> On Mon, Aug 16, 2021 at 5:06 AM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Thu, 2021-08-12 at 12:10 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > In case the export MDS is crashed just after the EImportStart journal
> > > is flushed, so when a standby MDS takes over it and when replaying
> > > the EImportStart journal the MDS will wait the client to reconnect,
> > > but the client may never register/open the sessions yet.
> > > 
> > > We will try to reconnect that MDSes if they're in the export targets
> > > and in RECONNECT state.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >  fs/ceph/mds_client.c | 58 +++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 57 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 14e44de05812..7dfe7a804320 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -4182,13 +4182,24 @@ static void check_new_map(struct ceph_mds_client *mdsc,
> > >                         struct ceph_mdsmap *newmap,
> > >                         struct ceph_mdsmap *oldmap)
> > >  {
> > > -     int i;
> > > +     int i, err;
> > > +     int *export_targets;
> > >       int oldstate, newstate;
> > >       struct ceph_mds_session *s;
> > > +     struct ceph_mds_info *m_info;
> > > 
> > >       dout("check_new_map new %u old %u\n",
> > >            newmap->m_epoch, oldmap->m_epoch);
> > > 
> > > +     m_info = newmap->m_info;
> > > +     export_targets = kcalloc(newmap->possible_max_rank, sizeof(int), GFP_NOFS);
> > > +     if (export_targets && m_info) {
> > > +             for (i = 0; i < m_info->num_export_targets; i++) {
> > > +                     BUG_ON(m_info->export_targets[i] >= newmap->possible_max_rank);
> > 
> > In general, we shouldn't BUG() in response to bad info sent by the MDS.
> > It would probably be better to check these values in
> > ceph_mdsmap_decode() and return an error there if it doesn't look right.
> > That way we can just toss out the new map instead of crashing.
> 
> While I agree we don’t want to crash on unexpected input from the
> network, if we are tossing out a map we need to shut down the mount as
> well. If we think the system metadata is invalid, that’s not really a
> recoverable condition and continuing to do IO is a mistake from the
> whole-system perspective — either the server has failed horribly or
> there’s something the client doesn’t understand which may be critical
> to correctness; either way there's a big problem with the basic system
> operation. (I mean, if we hit this point obviously the server has
> failed horribly since we should have gated it, but it may have failed
> horribly in some non-code-logic fashion.)
> -Greg
> 

I see this as essentially the same as any other parsing error in the
mdsmap. When we hit one of those, we currently just do this:

    pr_err("error decoding fsmap\n");

...and soldier on. It's been this way since the beginning, afaict.

If we want to do something more involved there, then that could probably
be done, but it's not as simple as throwing a switch. We may have open
files and dirty data to deal with. We do have some code to deal with
attempting to reconnect after a blacklist event, so you might be able to
treat this similarly. 

In any case, this would be a pretty unusual situation, and I don't see
us having the manpower to spend on coding up an elegant solution to this
potential problem anytime soon. It might be worth opening a tracker for
it though if that changes in the future.


> > 
> > > +                     export_targets[m_info->export_targets[i]] = 1;
> > > +             }
> > > +     }
> > > +
> > >       for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
> > >               if (!mdsc->sessions[i])
> > >                       continue;
> > > @@ -4242,6 +4253,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
> > >               if (s->s_state == CEPH_MDS_SESSION_RESTARTING &&
> > >                   newstate >= CEPH_MDS_STATE_RECONNECT) {
> > >                       mutex_unlock(&mdsc->mutex);
> > > +                     if (export_targets)
> > > +                             export_targets[i] = 0;
> > >                       send_mds_reconnect(mdsc, s);
> > >                       mutex_lock(&mdsc->mutex);
> > >               }
> > > @@ -4264,6 +4277,47 @@ static void check_new_map(struct ceph_mds_client *mdsc,
> > >               }
> > >       }
> > > 
> > > +     for (i = 0; i < newmap->possible_max_rank; i++) {
> > 
> > The condition on this loop is slightly different from the one below it,
> > and I'm not sure why. Should this also be checking this?
> > 
> >     i < newmap->possible_max_rank && i < mdsc->max_sessions
> > 
> > ...do we need to look at export targets where i >= mdsc->max_sessions ?
> > 
> > > +             if (!export_targets)
> > > +                     break;
> > > +
> > > +             /*
> > > +              * Only open and reconnect sessions that don't
> > > +              * exist yet.
> > > +              */
> > > +             if (!export_targets[i] || __have_session(mdsc, i))
> > > +                     continue;
> > > +
> > > +             /*
> > > +              * In case the export MDS is crashed just after
> > > +              * the EImportStart journal is flushed, so when
> > > +              * a standby MDS takes over it and is replaying
> > > +              * the EImportStart journal the new MDS daemon
> > > +              * will wait the client to reconnect it, but the
> > > +              * client may never register/open the sessions
> > > +              * yet.
> > > +              *
> > > +              * It will try to reconnect that MDS daemons if
> > > +              * the MDSes are in the export targets and is the
> > > +              * RECONNECT state.
> > > +              */
> > > +             newstate = ceph_mdsmap_get_state(newmap, i);
> > > +             if (newstate != CEPH_MDS_STATE_RECONNECT)
> > > +                     continue;
> > > +             s = __open_export_target_session(mdsc, i);
> > > +             if (IS_ERR(s)) {
> > > +                     err = PTR_ERR(s);
> > > +                     pr_err("failed to open export target session, err %d\n",
> > > +                            err);
> > > +                     continue;
> > > +             }
> > > +             dout("send reconnect to target mds.%d\n", i);
> > > +             mutex_unlock(&mdsc->mutex);
> > > +             send_mds_reconnect(mdsc, s);
> > > +             mutex_lock(&mdsc->mutex);
> > > +             ceph_put_mds_session(s);
> > 
> > Suppose we end up in this part of the code, and we have to drop the
> > mdsc->mutex like this. What ensures that an earlier session in the array
> > won't end up going back into CEPH_MDS_STATE_RECONNECT before we can get
> > into the loop below? This looks racy.
> > 
> > > +     }
> > > +
> > >       for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
> > >               s = mdsc->sessions[i];
> > >               if (!s)
> > > @@ -4278,6 +4332,8 @@ static void check_new_map(struct ceph_mds_client *mdsc,
> > >                       __open_export_target_sessions(mdsc, s);
> > >               }
> > >       }
> > > +
> > > +     kfree(export_targets);
> > >  }
> > > 
> > > 
> > 
> > --
> > Jeff Layton <jlayton@kernel.org>
> > 
> 

-- 
Jeff Layton <jlayton@kernel.org>

