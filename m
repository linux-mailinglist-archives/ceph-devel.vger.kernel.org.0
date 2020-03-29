Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2A8196E18
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Mar 2020 17:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgC2PKU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Mar 2020 11:10:20 -0400
Received: from mail-qv1-f45.google.com ([209.85.219.45]:37150 "EHLO
        mail-qv1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727488AbgC2PKU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Mar 2020 11:10:20 -0400
Received: by mail-qv1-f45.google.com with SMTP id n1so7597791qvz.4
        for <ceph-devel@vger.kernel.org>; Sun, 29 Mar 2020 08:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPHLUB9k99VdbJXfM6J13rE7V/kHuAUibe6viaG4GqY=;
        b=RQ+82zVPPMeOkmXqnEFVODLFJpE5iKTZo0L/19TPEtFh2U19UnUVt+xiZm0L2G4VU6
         xChwv7X0o8LJMIqWpQFB9Mp59j9hjBEPWz7ym4e9fUXPajAJMtK0hID4W9n6WvZWBw93
         gy7C/y6naEWhlVNKOhjxUUJSiXb3pMCHGLLTe0c4CqWtIyJcQAQZkyUXjwVOqcK4tbaR
         izdnwBKP/1ZvNZZzE9S5ZgI02WcQa+vuuam32gFMYHzJNBlgLZHeperJ2q0hYn7hGzCz
         P1R3UhbtrcVIR1soV+mW6eaETr76XP4sGiEbZlfHhpkVJ1kmZqBwpoWhcvd2NibHrJDB
         Lx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPHLUB9k99VdbJXfM6J13rE7V/kHuAUibe6viaG4GqY=;
        b=biKtWckAzGV28LvIHANIeDKy83EA77g3EJH5Wy61zYufurGbbibpz8OySSwftN3k+U
         LVVvP0pyv3/sbod/xd/WTOtsJkjH1lHWJZlD/MUOv3t6onTugX520IjODcsKj6tvynQi
         zAR7qZ9hZOHQUJ3KXmCHxSfbbO9N/e2R9s2dMYNKXeCnRhbdpYqz4LJrrRVJirXxbM9Q
         v+xBOyyb3WWt5+wpUcF7bLGD6NwcFVEGmxqrp7fKHoKycrViW9poIGg/hW3kqskmcGW7
         eshxFbDVYwHHn+6F6DXlENpHCM3q9VBrI7Oc/nJNUtOf93Vijo8XhUetniij9eOTdVVg
         pd5A==
X-Gm-Message-State: ANhLgQ3EOtzZWl22CIzFcRG+BbhTYZUFTuEhF5+NWbwZfLIhISkJkwMC
        qcrxoXV/Q7VEOAJpgumxAmIdQQpd5B42LdD55g7jdyqh
X-Google-Smtp-Source: ADFU+vtj/h5SYJC4TpHNNB2nisEPfp68cTk2Z6IBIlT+vvRH/X+pCPnq997uAEH5PYfVpFvwWCS6n7cIPru9KMI5mxw=
X-Received: by 2002:ad4:4182:: with SMTP id e2mr8065941qvp.32.1585494618850;
 Sun, 29 Mar 2020 08:10:18 -0700 (PDT)
MIME-Version: 1.0
References: <d6e7fca9b7276f36f828182faceea92bdc254fb1.camel@redhat.com>
 <CAAM7YAk3AhWv0KKWAqAh3zP9Lbj7f9RSDMVXZ2A_1W8M6mSOSA@mail.gmail.com> <f4931c8940e982bd0bf0d4f02ed11b6867ece2ca.camel@redhat.com>
In-Reply-To: <f4931c8940e982bd0bf0d4f02ed11b6867ece2ca.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Sun, 29 Mar 2020 23:10:24 +0800
Message-ID: <CAAM7YA=VtkVoXDe8FUocw9zi0OMn1p6+sYa+EK-g7c77ndDCxA@mail.gmail.com>
Subject: Re: reducing s_mutex coverage in kcephfs client
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Mar 28, 2020 at 3:47 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2020-03-27 at 22:31 +0800, Yan, Zheng wrote:
> > On Fri, Mar 27, 2020 at 12:58 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > I had mentioned this in standup this morning, but it's a bit of a
> > > complex topic and Zheng asked me to send email instead. I'm also cc'ing
> > > ceph-devel for posterity...
> > >
> > > The locking in the cap handling code is extremely hairy, with many
> > > places where we need to take sleeping locks while we're in atomic
> > > context (under spinlock, mostly). A lot of the problem is due to the
> > > need to take the session->s_mutex.
> > >
> > > For instance, there's this in ceph_check_caps:
> > >
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 1999)              if (session && session != cap->session) {
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2000)                      dout("oops, wrong session %p mutex\n", session);
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2001)                      mutex_unlock(&session->s_mutex);
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2002)                      session = NULL;
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2003)              }
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2004)              if (!session) {
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2005)                      session = cap->session;
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2006)                      if (mutex_trylock(&session->s_mutex) == 0) {
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2007)                              dout("inverting session/ino locks on %p\n",
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2008)                                   session);
> > > be655596b3de5 (Sage Weil           2011-11-30 09:47:09 -0800 2009)                              spin_unlock(&ci->i_ceph_lock);
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2010)                              if (took_snap_rwsem) {
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2011)                                      up_read(&mdsc->snap_rwsem);
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2012)                                      took_snap_rwsem = 0;
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2013)                              }
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2014)                              mutex_lock(&session->s_mutex);
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2015)                              goto retry;
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2016)                      }
> > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2017)              }
> > >
> > > At this point, we're walking the inode's caps rbtree, while holding the
> > > inode->i_ceph_lock. We're eventually going to need to send a cap message
> > > to the MDS for this cap, but that requires the cap->session->s_mutex. We
> > > try to take it without blocking first, but if that fails, we have to
> > > unwind all of the locking and start over. Gross. That also makes the
> > > handling of snap_rwsem much more complex than it really should be too.
> > >
> > > It does this, despite the fact that the cap message doesn't actually
> > > need much from the session (just the session->s_con, mostly). Most of
> > > the info in the message comes from the inode and cap objects.
> > >
> > > My question is: What is the s_mutex guaranteeing at this point?
> > >
> > > More to the point, is it strictly required that we hold that mutex as we
> > > marshal up the outgoing request? It would be much cleaner to be able to
> > > just drop the spinlock after getting the ceph_msg_args ready to send,
> > > then take the session mutex and send the request.
> > >
> > > The state of the MDS session is not checked in this codepath before the
> > > send, so it doesn't seem like ordering vs. session state messages is
> > > very important. This _is_ ordered vs. regular MDS requests, but a
> > > per-session mutex seems like a very heavyweight way to do that.
> > >
> > > If we're concerned about reordering cap messages that involve the same
> > > inode, then there are other ways to ensure that ordering that don't
> > > require a coarse-grained mutex.
> > >
> > > It's just not clear to me what data this mutex is protecting in this
> > > case.
> >
> > I think it's mainly for message ordering. For example,  a request may
> > release multiple inodes' caps (by ceph_encode_inode_release).  Before
> > sending the request out, we need to prevent ceph_check_caps() from
> > touch these inodes' caps and sending cap messages.
>
> I don't get it.
>
> AFAICT, ceph_encode_inode_release is called while holding the
> mdsc->mutex, not the s_mutex. That is serialized on the i_ceph_lock, but
> I don't think there's any guarantee what order (e.g.) a racing cap
> update and release would be sent.
>

You are right. cap messages can be slight out-of-order in above case.

I checked the code again.  I think s_mutex is mainly for:

- cap message senders use s_mutex to ensure session does not get
closed by CEPH_SESSION_CLOSE. For example __mark_caps_flushing() may
race with remove_session_caps()
- some functions such as ceph_iterate_session_caps are not reentrant.
s_mutex is used for protecting these functions.
- send_mds_reconnect() use s_mutex to prevent other threads from
modifying cap states while it composing the reconnect message.
Regards
Yan, Zheng



> --
> Jeff Layton <jlayton@redhat.com>
>
