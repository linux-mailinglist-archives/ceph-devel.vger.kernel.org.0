Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3C528A231
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Oct 2020 00:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389190AbgJJWz0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 10 Oct 2020 18:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730315AbgJJStj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 10 Oct 2020 14:49:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEF0C05BD39
        for <ceph-devel@vger.kernel.org>; Sat, 10 Oct 2020 11:49:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id 67so13684752iob.8
        for <ceph-devel@vger.kernel.org>; Sat, 10 Oct 2020 11:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PCe0qeEHqkiUGJgxNOWkMgy/o30sgp66wOY8hEo8b4w=;
        b=dggFMSWyIMJLfAMTOcozUla5rgNeH0Z0GXIvsBGDB3iBstnp4R9DyLqt3UYaAPg6tu
         nzQeMIqgsYIDZVtx4k7v9CsLqSgdvQMtaUkBko3v/x/7xGKaAqSDgCL6sV2z80Qfe4J6
         DRRT2zT5hK87iDPlIAuV7yjlZaTXGHyBbY+1V+Fo7yz8xCIB2RZEv4LKZ5MUord4TN6W
         YkoBpZouBXMYUWCQtAkqhqs31OnXVC8FcVx+cbZ+yIvbW/EJwRa2+f917rq4huCMD0DY
         q3CZUFgdrINAFtSdV1LdshJv/bL//a2lXbPe2U7NOcZTN0lwyOplkVuoSaKV43zEq+lp
         JMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PCe0qeEHqkiUGJgxNOWkMgy/o30sgp66wOY8hEo8b4w=;
        b=HzO+/spS0JsMoU0LioeoZKWVaVrBVtV0lI66hPG7HSkrKD+dv/Uy0JW92IzP4itptL
         SM+C/wq16BZ/TftQT+0mcpMcQC9SidEHzKAWEuPxKft0rNrGkKyDQXY/EHEy8E3mKeoc
         gyNCJItwoueUUBjZyyyoTlN0G0j3fDosbNZJZEGWqf2YemNEDZ7CtiuCDLtw9fjI7VLP
         ABQjC5OF88BCTajqX67uM8M/61RQovXkwHEddQkm1xwy0o5vCzCoF073yzHNRs23GxQ0
         rAk/gTTWlZOaKT478LLBWYpFyuGUM5rKew3tRNbADyIc/5T4zxzcb0EfAUCL7/5i0TRK
         Y9Uw==
X-Gm-Message-State: AOAM530mqSOVTpjD5pAGjTIPa3S77ZwCIHV8Wyf/InDMivUnPp8no02S
        kjHbYbbNI0I/tQ2yz1JK2DmQ2v2CgV0ZIp36LQI=
X-Google-Smtp-Source: ABdhPJzFnNoS1OSxSX12oHI0gklxA5GpU5Uhm9wErpIAaFlAZAh6i4RF8y+3o7pzVqWrjXo825s6J0r2Om+0BVBDlJM=
X-Received: by 2002:a6b:920b:: with SMTP id u11mr3963031iod.191.1602355778464;
 Sat, 10 Oct 2020 11:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200928220349.584709-1-jlayton@kernel.org> <CAOi1vP8zXLGscoa4QjiwW0BtbVnrkamWGzBeqARnVr8Maes3CQ@mail.gmail.com>
 <53e9b5c4635f4aa0f51c0c1870a72fc96d88bd10.camel@kernel.org>
In-Reply-To: <53e9b5c4635f4aa0f51c0c1870a72fc96d88bd10.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sat, 10 Oct 2020 20:49:32 +0200
Message-ID: <CAOi1vP8w5kfVcsVL0n5UG3Ks4vNOEbW-wX-UMsniKPt5rE6nSA@mail.gmail.com>
Subject: Re: [PATCH] ceph: retransmit REQUEST_CLOSE every second if we don't
 get a response
To:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 8, 2020 at 8:14 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2020-10-08 at 19:27 +0200, Ilya Dryomov wrote:
> > On Tue, Sep 29, 2020 at 12:03 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > Patrick reported a case where the MDS and client client had racing
> > > session messages to one anothe. The MDS was sending caps to the client
> > > and the client was sending a CEPH_SESSION_REQUEST_CLOSE message in order
> > > to unmount.
> > >
> > > Because they were sending at the same time, the REQUEST_CLOSE had too
> > > old a sequence number, and the MDS dropped it on the floor. On the
> > > client, this would have probably manifested as a 60s hang during umount.
> > > The MDS ended up blocklisting the client.
> > >
> > > Once we've decided to issue a REQUEST_CLOSE, we're finished with the
> > > session, so just keep sending them until the MDS acknowledges that.
> > >
> > > Change the code to retransmit a REQUEST_CLOSE every second if the
> > > session hasn't changed state yet. Give up and throw a warning after
> > > mount_timeout elapses if we haven't gotten a response.
> > >
> > > URL: https://tracker.ceph.com/issues/47563
> > > Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/mds_client.c | 53 ++++++++++++++++++++++++++------------------
> > >  1 file changed, 32 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index b07e7adf146f..d9cb74e3d5e3 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -1878,7 +1878,7 @@ static int request_close_session(struct ceph_mds_session *session)
> > >  static int __close_session(struct ceph_mds_client *mdsc,
> > >                          struct ceph_mds_session *session)
> > >  {
> > > -       if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
> > > +       if (session->s_state > CEPH_MDS_SESSION_CLOSING)
> > >                 return 0;
> > >         session->s_state = CEPH_MDS_SESSION_CLOSING;
> > >         return request_close_session(session);
> > > @@ -4692,38 +4692,49 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
> > >         return atomic_read(&mdsc->num_sessions) <= skipped;
> > >  }
> > >
> > > +static bool umount_timed_out(unsigned long timeo)
> > > +{
> > > +       if (time_before(jiffies, timeo))
> > > +               return false;
> > > +       pr_warn("ceph: unable to close all sessions\n");
> > > +       return true;
> > > +}
> > > +
> > >  /*
> > >   * called after sb is ro.
> > >   */
> > >  void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
> > >  {
> > > -       struct ceph_options *opts = mdsc->fsc->client->options;
> > >         struct ceph_mds_session *session;
> > > -       int i;
> > > -       int skipped = 0;
> > > +       int i, ret;
> > > +       int skipped;
> > > +       unsigned long timeo = jiffies +
> > > +                             ceph_timeout_jiffies(mdsc->fsc->client->options->mount_timeout);
> > >
> > >         dout("close_sessions\n");
> > >
> > >         /* close sessions */
> > > -       mutex_lock(&mdsc->mutex);
> > > -       for (i = 0; i < mdsc->max_sessions; i++) {
> > > -               session = __ceph_lookup_mds_session(mdsc, i);
> > > -               if (!session)
> > > -                       continue;
> > > -               mutex_unlock(&mdsc->mutex);
> > > -               mutex_lock(&session->s_mutex);
> > > -               if (__close_session(mdsc, session) <= 0)
> > > -                       skipped++;
> > > -               mutex_unlock(&session->s_mutex);
> > > -               ceph_put_mds_session(session);
> > > +       do {
> > > +               skipped = 0;
> > >                 mutex_lock(&mdsc->mutex);
> > > -       }
> > > -       mutex_unlock(&mdsc->mutex);
> > > +               for (i = 0; i < mdsc->max_sessions; i++) {
> > > +                       session = __ceph_lookup_mds_session(mdsc, i);
> > > +                       if (!session)
> > > +                               continue;
> > > +                       mutex_unlock(&mdsc->mutex);
> > > +                       mutex_lock(&session->s_mutex);
> > > +                       if (__close_session(mdsc, session) <= 0)
> > > +                               skipped++;
> > > +                       mutex_unlock(&session->s_mutex);
> > > +                       ceph_put_mds_session(session);
> > > +                       mutex_lock(&mdsc->mutex);
> > > +               }
> > > +               mutex_unlock(&mdsc->mutex);
> > >
> > > -       dout("waiting for sessions to close\n");
> > > -       wait_event_timeout(mdsc->session_close_wq,
> > > -                          done_closing_sessions(mdsc, skipped),
> > > -                          ceph_timeout_jiffies(opts->mount_timeout));
> > > +               dout("waiting for sessions to close\n");
> > > +               ret = wait_event_timeout(mdsc->session_close_wq,
> > > +                                        done_closing_sessions(mdsc, skipped), HZ);
> > > +       } while (!ret && !umount_timed_out(timeo));
> > >
> > >         /* tear down remaining sessions */
> > >         mutex_lock(&mdsc->mutex);
> > > --
> > > 2.26.2
> > >
> >
> > Hi Jeff,
> >
> > This seems wrong to me, at least conceptually.  Is the same patch
> > getting applied to ceph-fuse?
> >
>
> It's a grotesque workaround, I will grant you. I'm not sure what we want
> to do for ceph-fuse yet but it does seem to have the same issue.
> Probably, we should plan to do a similar fix there once we settle on the
> right approach.
>
> > Pretending to not know anything about the client <-> MDS protocol,
> > two questions immediately come to mind.  Why is MDS allowed to drop
> > REQUEST_CLOSE?
>
> It really seems like a protocol design flaw.
>
> IIUC, the idea overall with the low-level ceph protocol seems to be that
> the client should retransmit (or reevaluate, in the case of caps) calls
> that were in flight when the seq number changes.
>
> The REQUEST_CLOSE handling seems to have followed suit on the MDS side,
> but it doesn't really make a lot of sense for that, IMO.

(edit of my reply to https://github.com/ceph/ceph/pull/37619)

After taking a look at the MDS code, it really seemed like it
had been written with the expectation that REQUEST_CLOSE would be
resent, so I dug around.  I don't fully understand these "push"
sequence numbers yet, but there is probably some race that requires
the client to confirm that it saw the sequence number, even if the
session is about to go.  Sage is probably the only one who might
remember at this point.

The kernel client already has the code to retry REQUEST_CLOSE, only
every five seconds instead every second.  See check_session_state()
which is called from delayed_work() in mds_client.c.  It looks like
it got broken by Xiubo's commit fa9967734227 ("ceph: fix potential
mdsc use-after-free crash") which conditioned delayed_work() on
mdsc->stopping -- hence the misbehaviour.

Thanks,

                Ilya
