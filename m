Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A95287B68
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Oct 2020 20:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgJHSOF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Oct 2020 14:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgJHSOF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 14:14:05 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB1121527;
        Thu,  8 Oct 2020 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602180843;
        bh=yMDnfzgaMP+AHPZWqdDOpZq4/bh4PeE7pliYnHquBzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dX6xa5Ur79MV6gguDxX8MipIzL0scasEP8ZE1nteQCi7ojvSEZ1cywN62Vseacskq
         0yd+ulIZA7tdUU+PzTnii55ZZ5sWruwYaB+3N+9lmuaSZgFu742QCMLA8t0BMOML+v
         LhG3PD0Hp+NH5rWyyBU3weUoRa5+DL7+8wpFDFQ0=
Message-ID: <53e9b5c4635f4aa0f51c0c1870a72fc96d88bd10.camel@kernel.org>
Subject: Re: [PATCH] ceph: retransmit REQUEST_CLOSE every second if we don't
 get a response
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 08 Oct 2020 14:14:01 -0400
In-Reply-To: <CAOi1vP8zXLGscoa4QjiwW0BtbVnrkamWGzBeqARnVr8Maes3CQ@mail.gmail.com>
References: <20200928220349.584709-1-jlayton@kernel.org>
         <CAOi1vP8zXLGscoa4QjiwW0BtbVnrkamWGzBeqARnVr8Maes3CQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-10-08 at 19:27 +0200, Ilya Dryomov wrote:
> On Tue, Sep 29, 2020 at 12:03 AM Jeff Layton <jlayton@kernel.org> wrote:
> > Patrick reported a case where the MDS and client client had racing
> > session messages to one anothe. The MDS was sending caps to the client
> > and the client was sending a CEPH_SESSION_REQUEST_CLOSE message in order
> > to unmount.
> > 
> > Because they were sending at the same time, the REQUEST_CLOSE had too
> > old a sequence number, and the MDS dropped it on the floor. On the
> > client, this would have probably manifested as a 60s hang during umount.
> > The MDS ended up blocklisting the client.
> > 
> > Once we've decided to issue a REQUEST_CLOSE, we're finished with the
> > session, so just keep sending them until the MDS acknowledges that.
> > 
> > Change the code to retransmit a REQUEST_CLOSE every second if the
> > session hasn't changed state yet. Give up and throw a warning after
> > mount_timeout elapses if we haven't gotten a response.
> > 
> > URL: https://tracker.ceph.com/issues/47563
> > Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/mds_client.c | 53 ++++++++++++++++++++++++++------------------
> >  1 file changed, 32 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index b07e7adf146f..d9cb74e3d5e3 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -1878,7 +1878,7 @@ static int request_close_session(struct ceph_mds_session *session)
> >  static int __close_session(struct ceph_mds_client *mdsc,
> >                          struct ceph_mds_session *session)
> >  {
> > -       if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
> > +       if (session->s_state > CEPH_MDS_SESSION_CLOSING)
> >                 return 0;
> >         session->s_state = CEPH_MDS_SESSION_CLOSING;
> >         return request_close_session(session);
> > @@ -4692,38 +4692,49 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
> >         return atomic_read(&mdsc->num_sessions) <= skipped;
> >  }
> > 
> > +static bool umount_timed_out(unsigned long timeo)
> > +{
> > +       if (time_before(jiffies, timeo))
> > +               return false;
> > +       pr_warn("ceph: unable to close all sessions\n");
> > +       return true;
> > +}
> > +
> >  /*
> >   * called after sb is ro.
> >   */
> >  void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
> >  {
> > -       struct ceph_options *opts = mdsc->fsc->client->options;
> >         struct ceph_mds_session *session;
> > -       int i;
> > -       int skipped = 0;
> > +       int i, ret;
> > +       int skipped;
> > +       unsigned long timeo = jiffies +
> > +                             ceph_timeout_jiffies(mdsc->fsc->client->options->mount_timeout);
> > 
> >         dout("close_sessions\n");
> > 
> >         /* close sessions */
> > -       mutex_lock(&mdsc->mutex);
> > -       for (i = 0; i < mdsc->max_sessions; i++) {
> > -               session = __ceph_lookup_mds_session(mdsc, i);
> > -               if (!session)
> > -                       continue;
> > -               mutex_unlock(&mdsc->mutex);
> > -               mutex_lock(&session->s_mutex);
> > -               if (__close_session(mdsc, session) <= 0)
> > -                       skipped++;
> > -               mutex_unlock(&session->s_mutex);
> > -               ceph_put_mds_session(session);
> > +       do {
> > +               skipped = 0;
> >                 mutex_lock(&mdsc->mutex);
> > -       }
> > -       mutex_unlock(&mdsc->mutex);
> > +               for (i = 0; i < mdsc->max_sessions; i++) {
> > +                       session = __ceph_lookup_mds_session(mdsc, i);
> > +                       if (!session)
> > +                               continue;
> > +                       mutex_unlock(&mdsc->mutex);
> > +                       mutex_lock(&session->s_mutex);
> > +                       if (__close_session(mdsc, session) <= 0)
> > +                               skipped++;
> > +                       mutex_unlock(&session->s_mutex);
> > +                       ceph_put_mds_session(session);
> > +                       mutex_lock(&mdsc->mutex);
> > +               }
> > +               mutex_unlock(&mdsc->mutex);
> > 
> > -       dout("waiting for sessions to close\n");
> > -       wait_event_timeout(mdsc->session_close_wq,
> > -                          done_closing_sessions(mdsc, skipped),
> > -                          ceph_timeout_jiffies(opts->mount_timeout));
> > +               dout("waiting for sessions to close\n");
> > +               ret = wait_event_timeout(mdsc->session_close_wq,
> > +                                        done_closing_sessions(mdsc, skipped), HZ);
> > +       } while (!ret && !umount_timed_out(timeo));
> > 
> >         /* tear down remaining sessions */
> >         mutex_lock(&mdsc->mutex);
> > --
> > 2.26.2
> > 
> 
> Hi Jeff,
> 
> This seems wrong to me, at least conceptually.  Is the same patch
> getting applied to ceph-fuse?
> 

It's a grotesque workaround, I will grant you. I'm not sure what we want
to do for ceph-fuse yet but it does seem to have the same issue.
Probably, we should plan to do a similar fix there once we settle on the
right approach.

> Pretending to not know anything about the client <-> MDS protocol,
> two questions immediately come to mind.  Why is MDS allowed to drop
> REQUEST_CLOSE? 

It really seems like a protocol design flaw.

IIUC, the idea overall with the low-level ceph protocol seems to be that
the client should retransmit (or reevaluate, in the case of caps) calls
that were in flight when the seq number changes.

The REQUEST_CLOSE handling seems to have followed suit on the MDS side,
but it doesn't really make a lot of sense for that, IMO.

> If the client is really done with the session, why
> does it block on the acknowledgement from the MDS?
> 

That's certainly one thing we could do instead. That would likely
prevent the unmount hangs, but would do nothing for the MDS deciding to
blacklist it. Maybe that's good enough though and we should fix that
problem on the MDS side by having it ignore the seq number on
REQUEST_CLOSE?

-- 
Jeff Layton <jlayton@kernel.org>

