Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA71958FF
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Mar 2020 15:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgC0Ob0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Mar 2020 10:31:26 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:42981 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgC0ObZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 Mar 2020 10:31:25 -0400
Received: by mail-qk1-f169.google.com with SMTP id 139so1071012qkd.9
        for <ceph-devel@vger.kernel.org>; Fri, 27 Mar 2020 07:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qn7sm9OrUpzMw1Qk+uTHixIroJXfVX7Y0klCIGXEG8E=;
        b=LR0aTnUfMRzCMEHstn0JbuUL6Olmxir4jQQ27tpSIoMg4E676cKBw960gFWmWaFU9N
         MSpCK/XgrAAM0N9LRxG2D5aoPEe6ORwnzB7Qn80EUpEJ6ewaVoRnV6ObGYyHT4XQoRyl
         MydnQdosVaVlj2NEFQXR6tYCsxpDRPAT/pg/Pgz9GJwOhPXLbF3OszKvaUV7a9xU5S7Z
         Hkwtlj942FVbhNlAAvuFsM2JEnaybIukgnAS8DyrM+XjT7mFqnanEnLQEEmbr7Zd3DAJ
         oVhd2FNgt5YzeI/OKN1P3XM/F2xvZqxSWd8Yrlx/CVGSzn3whV/dFIrOyS1s9KQa20vb
         wIEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qn7sm9OrUpzMw1Qk+uTHixIroJXfVX7Y0klCIGXEG8E=;
        b=LgxhVw+DL8S4I/tuwLxa6+zk0mr/kq4y+NV89PsJRBvGUE+MVllUqhO5h/icfoDvQ1
         e1MKMFbnGcaK0wS1UcgdkiXblmdHdJtqVkgPzzx2XsviU8N+YNU5ETdG1taF0RjCmA1j
         ZxuPFjTnMJgSQNLA0HaCMpW05FeicG/vL1Q+jev5qk1yBIgRMSJ654uBVOColBuNLoWr
         w/+ZpZU6eB1HPEwr1zhv+OkNcQW1BmXHv0XT9YeYiUVlnugs/BFnO0PtvuY2LkTYca3F
         Q7ZfkdeZbV0JmngqpbtIzhJ8NxrKe0t81akE2NF2JVvLme1QS64EJ3fzxTVNpIIvqF7C
         slZQ==
X-Gm-Message-State: ANhLgQ3rB1JYUHN0jD/Gv6erAxKqYN9B0TSe17Px8OIi8iKJRJhnmFng
        8LpqNkDEAjqvxYjDBK5fTH36vsRCIDwXYOpwaws=
X-Google-Smtp-Source: ADFU+vvfmqYPV4oQeKEs9ZikzZp+gyxK7WU7TxgbLS1BSArYrsZgJldr9uKcpAoLVCO3LCfdeCER1klACghdQpp3fkk=
X-Received: by 2002:a37:2c45:: with SMTP id s66mr14238559qkh.268.1585319484401;
 Fri, 27 Mar 2020 07:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <d6e7fca9b7276f36f828182faceea92bdc254fb1.camel@redhat.com>
In-Reply-To: <d6e7fca9b7276f36f828182faceea92bdc254fb1.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 27 Mar 2020 22:31:12 +0800
Message-ID: <CAAM7YAk3AhWv0KKWAqAh3zP9Lbj7f9RSDMVXZ2A_1W8M6mSOSA@mail.gmail.com>
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

On Fri, Mar 27, 2020 at 12:58 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> I had mentioned this in standup this morning, but it's a bit of a
> complex topic and Zheng asked me to send email instead. I'm also cc'ing
> ceph-devel for posterity...
>
> The locking in the cap handling code is extremely hairy, with many
> places where we need to take sleeping locks while we're in atomic
> context (under spinlock, mostly). A lot of the problem is due to the
> need to take the session->s_mutex.
>
> For instance, there's this in ceph_check_caps:
>
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 1999)              if (session && session != cap->session) {
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2000)                      dout("oops, wrong session %p mutex\n", session);
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2001)                      mutex_unlock(&session->s_mutex);
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2002)                      session = NULL;
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2003)              }
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2004)              if (!session) {
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2005)                      session = cap->session;
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2006)                      if (mutex_trylock(&session->s_mutex) == 0) {
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2007)                              dout("inverting session/ino locks on %p\n",
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2008)                                   session);
> be655596b3de5 (Sage Weil           2011-11-30 09:47:09 -0800 2009)                              spin_unlock(&ci->i_ceph_lock);
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2010)                              if (took_snap_rwsem) {
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2011)                                      up_read(&mdsc->snap_rwsem);
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2012)                                      took_snap_rwsem = 0;
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2013)                              }
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2014)                              mutex_lock(&session->s_mutex);
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2015)                              goto retry;
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2016)                      }
> a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2017)              }
>
> At this point, we're walking the inode's caps rbtree, while holding the
> inode->i_ceph_lock. We're eventually going to need to send a cap message
> to the MDS for this cap, but that requires the cap->session->s_mutex. We
> try to take it without blocking first, but if that fails, we have to
> unwind all of the locking and start over. Gross. That also makes the
> handling of snap_rwsem much more complex than it really should be too.
>
> It does this, despite the fact that the cap message doesn't actually
> need much from the session (just the session->s_con, mostly). Most of
> the info in the message comes from the inode and cap objects.
>
> My question is: What is the s_mutex guaranteeing at this point?
>
> More to the point, is it strictly required that we hold that mutex as we
> marshal up the outgoing request? It would be much cleaner to be able to
> just drop the spinlock after getting the ceph_msg_args ready to send,
> then take the session mutex and send the request.
>
> The state of the MDS session is not checked in this codepath before the
> send, so it doesn't seem like ordering vs. session state messages is
> very important. This _is_ ordered vs. regular MDS requests, but a
> per-session mutex seems like a very heavyweight way to do that.
>
> If we're concerned about reordering cap messages that involve the same
> inode, then there are other ways to ensure that ordering that don't
> require a coarse-grained mutex.
>
> It's just not clear to me what data this mutex is protecting in this
> case.

I think it's mainly for message ordering. For example,  a request may
release multiple inodes' caps (by ceph_encode_inode_release).  Before
sending the request out, we need to prevent ceph_check_caps() from
touch these inodes' caps and sending cap messages.

>
> Any hints would be welcome!
> --
> Jeff Layton <jlayton@redhat.com>
>
