Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C9D28B5D7
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 15:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388798AbgJLNQ0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 09:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388742AbgJLNQ0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Oct 2020 09:16:26 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD25C0613D0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:16:25 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p16so7473568ilq.5
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LubBmhCPp34Pi743pHqbb7YKD0ZsXvtHk9BgSh4f6yw=;
        b=icnWxMhJKQjcEIVWTWvd+v84dZvSUOJClPf1atmKCqGc4JeDWUXU7xjM6rk6QQkKec
         RuFcHusXhEJcCf0cTenpxP08Bv7cY3SW7V1OpYaX7Iux3tGVWeRtpVviJd4gGBvYj4ow
         jwWFsy74gfxcYO7Z71edUsfh+6NOvufvLvLa/1UD9asSsFcMBiJnBB6oVXTrKYxPIjQr
         9tUSp7G2VW8zoH+aZICaIa3R9SfEO7Cf0lxMXD0nTkaTCbSUxRdJWc+PRr4H6d7JubLL
         1fjuamdLbksPwfF68+1H42NPBWUsZ+Za6JIzsISjDIC446id7UgscITVXb/ENSLYZNG9
         qE8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LubBmhCPp34Pi743pHqbb7YKD0ZsXvtHk9BgSh4f6yw=;
        b=scPdTWtx9OkV6BdnHwOTZnrVSjIrt/Q14oQQE0/E9jH1DF6bj9WlyBmIAG9b+psa98
         IEqqBViw5ydsjTvwKcluR9J1IY3hpjPFMSJrXHTi5UFN4TpOiKwlo2S86F04p4Cn0jWu
         /oZ9bJfigT9HXEdjbEqTHekmal7YlM1MJS+Z5DRlYRAzDpUOSgQfjptBgGFUjJW6QVQl
         3vZHn5q4L61lPnfT7HAkDucd1lsacahjEL8cGEqVXgB7oYeBiN3g6pAEnI4r3jpJ53EI
         JktEAI85UyLEJvwtyUf+K1mkfhY315Ctp8FNI1ddeEEiLzTH9b0dUa4focyApq8cQkin
         pxdw==
X-Gm-Message-State: AOAM531LlUz7rB9YiJPuPkFRalG/RzSHx34LfB38a3JKEgrXi1AtxXLm
        JuKcYOxUFSpWetGPcn9s69ZUlE1sWqk5sgK2N9Trn1jCX34=
X-Google-Smtp-Source: ABdhPJzxCZF8bA+0rlBwAKJ3HuYk0TIy82ZVxW9McdZXq92M9MpH91RgcI95fD1Ee4jt6p/EC5a54QP5OADn8fqPjCo=
X-Received: by 2002:a92:6711:: with SMTP id b17mr19899220ilc.100.1602508584851;
 Mon, 12 Oct 2020 06:16:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200928220349.584709-1-jlayton@kernel.org> <CAOi1vP8zXLGscoa4QjiwW0BtbVnrkamWGzBeqARnVr8Maes3CQ@mail.gmail.com>
 <53e9b5c4635f4aa0f51c0c1870a72fc96d88bd10.camel@kernel.org>
 <CAOi1vP8w5kfVcsVL0n5UG3Ks4vNOEbW-wX-UMsniKPt5rE6nSA@mail.gmail.com>
 <b2a93049-969e-f889-e773-e326230b0efb@redhat.com> <5f41bef292d90066c650aa2e960beb5a1b11fbad.camel@kernel.org>
 <860ed81f-c8ab-c482-18ce-0080cedd3ec1@redhat.com>
In-Reply-To: <860ed81f-c8ab-c482-18ce-0080cedd3ec1@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 12 Oct 2020 15:16:19 +0200
Message-ID: <CAOi1vP8HU5=0oOKmSouRamuo5y-VDi0=Gf595g7evPQkGkfuVw@mail.gmail.com>
Subject: Re: [PATCH] ceph: retransmit REQUEST_CLOSE every second if we don't
 get a response
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 2:41 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/10/12 19:52, Jeff Layton wrote:
> > On Mon, 2020-10-12 at 14:52 +0800, Xiubo Li wrote:
> >> On 2020/10/11 2:49, Ilya Dryomov wrote:
> >>> On Thu, Oct 8, 2020 at 8:14 PM Jeff Layton <jlayton@kernel.org> wrote:
> >>>> On Thu, 2020-10-08 at 19:27 +0200, Ilya Dryomov wrote:
> >>>>> On Tue, Sep 29, 2020 at 12:03 AM Jeff Layton <jlayton@kernel.org> wrote:
> >>>>>> Patrick reported a case where the MDS and client client had racing
> >>>>>> session messages to one anothe. The MDS was sending caps to the client
> >>>>>> and the client was sending a CEPH_SESSION_REQUEST_CLOSE message in order
> >>>>>> to unmount.
> >>>>>>
> >>>>>> Because they were sending at the same time, the REQUEST_CLOSE had too
> >>>>>> old a sequence number, and the MDS dropped it on the floor. On the
> >>>>>> client, this would have probably manifested as a 60s hang during umount.
> >>>>>> The MDS ended up blocklisting the client.
> >>>>>>
> >>>>>> Once we've decided to issue a REQUEST_CLOSE, we're finished with the
> >>>>>> session, so just keep sending them until the MDS acknowledges that.
> >>>>>>
> >>>>>> Change the code to retransmit a REQUEST_CLOSE every second if the
> >>>>>> session hasn't changed state yet. Give up and throw a warning after
> >>>>>> mount_timeout elapses if we haven't gotten a response.
> >>>>>>
> >>>>>> URL: https://tracker.ceph.com/issues/47563
> >>>>>> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> >>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> >>>>>> ---
> >>>>>>    fs/ceph/mds_client.c | 53 ++++++++++++++++++++++++++------------------
> >>>>>>    1 file changed, 32 insertions(+), 21 deletions(-)
> >>>>>>
> >>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >>>>>> index b07e7adf146f..d9cb74e3d5e3 100644
> >>>>>> --- a/fs/ceph/mds_client.c
> >>>>>> +++ b/fs/ceph/mds_client.c
> >>>>>> @@ -1878,7 +1878,7 @@ static int request_close_session(struct ceph_mds_session *session)
> >>>>>>    static int __close_session(struct ceph_mds_client *mdsc,
> >>>>>>                            struct ceph_mds_session *session)
> >>>>>>    {
> >>>>>> -       if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
> >>>>>> +       if (session->s_state > CEPH_MDS_SESSION_CLOSING)
> >>>>>>                   return 0;
> >>>>>>           session->s_state = CEPH_MDS_SESSION_CLOSING;
> >>>>>>           return request_close_session(session);
> >>>>>> @@ -4692,38 +4692,49 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
> >>>>>>           return atomic_read(&mdsc->num_sessions) <= skipped;
> >>>>>>    }
> >>>>>>
> >>>>>> +static bool umount_timed_out(unsigned long timeo)
> >>>>>> +{
> >>>>>> +       if (time_before(jiffies, timeo))
> >>>>>> +               return false;
> >>>>>> +       pr_warn("ceph: unable to close all sessions\n");
> >>>>>> +       return true;
> >>>>>> +}
> >>>>>> +
> >>>>>>    /*
> >>>>>>     * called after sb is ro.
> >>>>>>     */
> >>>>>>    void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
> >>>>>>    {
> >>>>>> -       struct ceph_options *opts = mdsc->fsc->client->options;
> >>>>>>           struct ceph_mds_session *session;
> >>>>>> -       int i;
> >>>>>> -       int skipped = 0;
> >>>>>> +       int i, ret;
> >>>>>> +       int skipped;
> >>>>>> +       unsigned long timeo = jiffies +
> >>>>>> +                             ceph_timeout_jiffies(mdsc->fsc->client->options->mount_timeout);
> >>>>>>
> >>>>>>           dout("close_sessions\n");
> >>>>>>
> >>>>>>           /* close sessions */
> >>>>>> -       mutex_lock(&mdsc->mutex);
> >>>>>> -       for (i = 0; i < mdsc->max_sessions; i++) {
> >>>>>> -               session = __ceph_lookup_mds_session(mdsc, i);
> >>>>>> -               if (!session)
> >>>>>> -                       continue;
> >>>>>> -               mutex_unlock(&mdsc->mutex);
> >>>>>> -               mutex_lock(&session->s_mutex);
> >>>>>> -               if (__close_session(mdsc, session) <= 0)
> >>>>>> -                       skipped++;
> >>>>>> -               mutex_unlock(&session->s_mutex);
> >>>>>> -               ceph_put_mds_session(session);
> >>>>>> +       do {
> >>>>>> +               skipped = 0;
> >>>>>>                   mutex_lock(&mdsc->mutex);
> >>>>>> -       }
> >>>>>> -       mutex_unlock(&mdsc->mutex);
> >>>>>> +               for (i = 0; i < mdsc->max_sessions; i++) {
> >>>>>> +                       session = __ceph_lookup_mds_session(mdsc, i);
> >>>>>> +                       if (!session)
> >>>>>> +                               continue;
> >>>>>> +                       mutex_unlock(&mdsc->mutex);
> >>>>>> +                       mutex_lock(&session->s_mutex);
> >>>>>> +                       if (__close_session(mdsc, session) <= 0)
> >>>>>> +                               skipped++;
> >>>>>> +                       mutex_unlock(&session->s_mutex);
> >>>>>> +                       ceph_put_mds_session(session);
> >>>>>> +                       mutex_lock(&mdsc->mutex);
> >>>>>> +               }
> >>>>>> +               mutex_unlock(&mdsc->mutex);
> >>>>>>
> >>>>>> -       dout("waiting for sessions to close\n");
> >>>>>> -       wait_event_timeout(mdsc->session_close_wq,
> >>>>>> -                          done_closing_sessions(mdsc, skipped),
> >>>>>> -                          ceph_timeout_jiffies(opts->mount_timeout));
> >>>>>> +               dout("waiting for sessions to close\n");
> >>>>>> +               ret = wait_event_timeout(mdsc->session_close_wq,
> >>>>>> +                                        done_closing_sessions(mdsc, skipped), HZ);
> >>>>>> +       } while (!ret && !umount_timed_out(timeo));
> >>>>>>
> >>>>>>           /* tear down remaining sessions */
> >>>>>>           mutex_lock(&mdsc->mutex);
> >>>>>> --
> >>>>>> 2.26.2
> >>>>>>
> >>>>> Hi Jeff,
> >>>>>
> >>>>> This seems wrong to me, at least conceptually.  Is the same patch
> >>>>> getting applied to ceph-fuse?
> >>>>>
> >>>> It's a grotesque workaround, I will grant you. I'm not sure what we want
> >>>> to do for ceph-fuse yet but it does seem to have the same issue.
> >>>> Probably, we should plan to do a similar fix there once we settle on the
> >>>> right approach.
> >>>>
> >>>>> Pretending to not know anything about the client <-> MDS protocol,
> >>>>> two questions immediately come to mind.  Why is MDS allowed to drop
> >>>>> REQUEST_CLOSE?
> >>>> It really seems like a protocol design flaw.
> >>>>
> >>>> IIUC, the idea overall with the low-level ceph protocol seems to be that
> >>>> the client should retransmit (or reevaluate, in the case of caps) calls
> >>>> that were in flight when the seq number changes.
> >>>>
> >>>> The REQUEST_CLOSE handling seems to have followed suit on the MDS side,
> >>>> but it doesn't really make a lot of sense for that, IMO.
> >>> (edit of my reply to https://github.com/ceph/ceph/pull/37619)
> >>>
> >>> After taking a look at the MDS code, it really seemed like it
> >>> had been written with the expectation that REQUEST_CLOSE would be
> >>> resent, so I dug around.  I don't fully understand these "push"
> >>> sequence numbers yet, but there is probably some race that requires
> >>> the client to confirm that it saw the sequence number, even if the
> >>> session is about to go.  Sage is probably the only one who might
> >>> remember at this point.
> >>>
> >>> The kernel client already has the code to retry REQUEST_CLOSE, only
> >>> every five seconds instead every second.  See check_session_state()
> >>> which is called from delayed_work() in mds_client.c.  It looks like
> >>> it got broken by Xiubo's commit fa9967734227 ("ceph: fix potential
> >>> mdsc use-after-free crash") which conditioned delayed_work() on
> >>> mdsc->stopping -- hence the misbehaviour.
> >> Without this commit it will hit this issue too. The umount old code will
> >> try to close sessions asynchronously, and then tries to cancel the
> >> delayed work, during which the last queued delayed_work() timer might be
> >> fired. This commit makes it easier to be reproduced.
> >>
> > Fixing the potential races to ensure that this is retransmitted is an
> > option, but I'm not sure it's the best one. Here's what I think we
> > probably ought to do:
> >
> > 1/ fix the MDS to just ignore the sequence number on REQUEST_CLOSE. I
> > don't see that the sequence number has any value on that call, as it's
> > an indicator that the client is finished with the session, and it's
> > never going to change its mind and do something different if the
> > sequence is wrong. I have a PR for that here:
> >
> >      https://github.com/ceph/ceph/pull/37619
> >
> > 2/ fix the clients to not wait on the REQUEST_CLOSE reply. As soon as
> > the call is sent, tear down the session and proceed with unmounting. The
> > client doesn't really care what the MDS has to say after that point, so
> > we may as well not wait on it before proceeding.
> >
> > Thoughts?
>
> I am thinking possibly we can just check the session's state when the
> client receives a request from MDS which will increase the s_seq number,
> if the session is in CLOSING state, the client needs to resend the
> REQUEST_CLOSE request again.

This is what ceph-fuse does, so I believe it is a viable approach.

As for changing the MDS to ignore the sequence number and changing
the clients to not wait for the reply, I don't think so.  It would
be a protocol change (more or less) and I don't think it should be
done until everyone has a clear understanding of the races that
the sequence number is supposed to protect against.  That might
mean waiting for Sage to chime in...

Both clients have the code to resend REQUEST_CLOSE, added over
ten years ago specifically to handle the case of MDS dropping the
original message.  Perhaps it's bogus at this point, but I'd be
wary of ignoring it without having the full history.

Thanks,

                Ilya
