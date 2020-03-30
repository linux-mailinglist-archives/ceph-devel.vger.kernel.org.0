Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E311983D3
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Mar 2020 20:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgC3S7a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Mar 2020 14:59:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40221 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgC3S7a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 14:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585594769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4t7RyVSd9XanT2LDGaDJc6xxT7/lMJWX5/ylucb1Lac=;
        b=ZlfBEOTghakYbB1EzSeDoocHmF3exFT+q581UG1aR6Oa124Z/MLT9At3GYNKhlJq5ydB/o
        OVvDmO1wcmPVWyQ4H9EAq1jFtZq3In+CnVuWCZzt3xPs8qQBRz3g85Nrqk0l0uTVf7SceV
        WqoZ/uoVhV/ZA4+B5W+neeQhchH3KRk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-Ea20_Z9kOJ6ENe9Tzs4vSQ-1; Mon, 30 Mar 2020 14:59:26 -0400
X-MC-Unique: Ea20_Z9kOJ6ENe9Tzs4vSQ-1
Received: by mail-qk1-f199.google.com with SMTP id h186so15861336qkc.22
        for <ceph-devel@vger.kernel.org>; Mon, 30 Mar 2020 11:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4t7RyVSd9XanT2LDGaDJc6xxT7/lMJWX5/ylucb1Lac=;
        b=pTiEAORtPcnw5ZGvHC410GGbM6r5rL1X+BKBnNfBWF2KmXYS36b4n+Emsp6YfTZBa0
         HrE5afcY/K+C/dC1pi61qdpvURwhAUI3mG/5kaKfD8ErXyvoZiDAie7zswJxBtapvdWL
         9ggl+ybBWC5enMLD25vG2EPGZiptZJiSK85kO9hFzrPGJQiJXeZ18aujLZZVYd6maB1p
         z2AyFP6nupMCjEmwo5B5BGhSyDn7J6o4ApgX5C9yzdUDC3ZmeIi4g+w3k95NyRWItWR+
         XBf5LC9sDnAALaZ/7XUWq62B8wCTk8591F74uqRwvEuqUFlKVT5D+8FObVMkfNQzZfbg
         v9dA==
X-Gm-Message-State: ANhLgQ3QagR3K+4X2BI+pJ/PGQ72vquYTWBZ0MECyet+X2A0P4qfXb5j
        1qvnOlCG3kQxTpXd8rT4eacoZkxozG0yMIAGBP1Cix00EByq2UqH99qxebv8RYdWr0jgfqg1ToV
        XbG9kd+TT473/YPe7x6D3rg==
X-Received: by 2002:a37:a749:: with SMTP id q70mr1509222qke.226.1585594766294;
        Mon, 30 Mar 2020 11:59:26 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvNzdA8KkHOArlKUcC0iuPQRSFz05zmU/GGKaqE53ljdcfblXpd3jaAmAkrjus81Op9mhP39Q==
X-Received: by 2002:a37:a749:: with SMTP id q70mr1509193qke.226.1585594765914;
        Mon, 30 Mar 2020 11:59:25 -0700 (PDT)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id s11sm11285528qke.97.2020.03.30.11.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 11:59:25 -0700 (PDT)
Message-ID: <6ce0032223cf8a9e4e1693d4d7730b1525813bf1.camel@redhat.com>
Subject: Re: reducing s_mutex coverage in kcephfs client
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Sage Weil <sage@redhat.com>
Date:   Mon, 30 Mar 2020 14:59:24 -0400
In-Reply-To: <CAAM7YA=VtkVoXDe8FUocw9zi0OMn1p6+sYa+EK-g7c77ndDCxA@mail.gmail.com>
References: <d6e7fca9b7276f36f828182faceea92bdc254fb1.camel@redhat.com>
         <CAAM7YAk3AhWv0KKWAqAh3zP9Lbj7f9RSDMVXZ2A_1W8M6mSOSA@mail.gmail.com>
         <f4931c8940e982bd0bf0d4f02ed11b6867ece2ca.camel@redhat.com>
         <CAAM7YA=VtkVoXDe8FUocw9zi0OMn1p6+sYa+EK-g7c77ndDCxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, 2020-03-29 at 23:10 +0800, Yan, Zheng wrote:
> On Sat, Mar 28, 2020 at 3:47 AM Jeff Layton <jlayton@redhat.com> wrote:
> > On Fri, 2020-03-27 at 22:31 +0800, Yan, Zheng wrote:
> > > On Fri, Mar 27, 2020 at 12:58 AM Jeff Layton <jlayton@redhat.com> wrote:
> > > > I had mentioned this in standup this morning, but it's a bit of a
> > > > complex topic and Zheng asked me to send email instead. I'm also cc'ing
> > > > ceph-devel for posterity...
> > > > 
> > > > The locking in the cap handling code is extremely hairy, with many
> > > > places where we need to take sleeping locks while we're in atomic
> > > > context (under spinlock, mostly). A lot of the problem is due to the
> > > > need to take the session->s_mutex.
> > > > 
> > > > For instance, there's this in ceph_check_caps:
> > > > 
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 1999)              if (session && session != cap->session) {
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2000)                      dout("oops, wrong session %p mutex\n", session);
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2001)                      mutex_unlock(&session->s_mutex);
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2002)                      session = NULL;
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2003)              }
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2004)              if (!session) {
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2005)                      session = cap->session;
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2006)                      if (mutex_trylock(&session->s_mutex) == 0) {
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2007)                              dout("inverting session/ino locks on %p\n",
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2008)                                   session);
> > > > be655596b3de5 (Sage Weil           2011-11-30 09:47:09 -0800 2009)                              spin_unlock(&ci->i_ceph_lock);
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2010)                              if (took_snap_rwsem) {
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2011)                                      up_read(&mdsc->snap_rwsem);
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2012)                                      took_snap_rwsem = 0;
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2013)                              }
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2014)                              mutex_lock(&session->s_mutex);
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2015)                              goto retry;
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2016)                      }
> > > > a8599bd821d08 (Sage Weil           2009-10-06 11:31:12 -0700 2017)              }
> > > > 
> > > > At this point, we're walking the inode's caps rbtree, while holding the
> > > > inode->i_ceph_lock. We're eventually going to need to send a cap message
> > > > to the MDS for this cap, but that requires the cap->session->s_mutex. We
> > > > try to take it without blocking first, but if that fails, we have to
> > > > unwind all of the locking and start over. Gross. That also makes the
> > > > handling of snap_rwsem much more complex than it really should be too.
> > > > 
> > > > It does this, despite the fact that the cap message doesn't actually
> > > > need much from the session (just the session->s_con, mostly). Most of
> > > > the info in the message comes from the inode and cap objects.
> > > > 
> > > > My question is: What is the s_mutex guaranteeing at this point?
> > > > 
> > > > More to the point, is it strictly required that we hold that mutex as we
> > > > marshal up the outgoing request? It would be much cleaner to be able to
> > > > just drop the spinlock after getting the ceph_msg_args ready to send,
> > > > then take the session mutex and send the request.
> > > > 
> > > > The state of the MDS session is not checked in this codepath before the
> > > > send, so it doesn't seem like ordering vs. session state messages is
> > > > very important. This _is_ ordered vs. regular MDS requests, but a
> > > > per-session mutex seems like a very heavyweight way to do that.
> > > > 
> > > > If we're concerned about reordering cap messages that involve the same
> > > > inode, then there are other ways to ensure that ordering that don't
> > > > require a coarse-grained mutex.
> > > > 
> > > > It's just not clear to me what data this mutex is protecting in this
> > > > case.
> > > 
> > > I think it's mainly for message ordering. For example,  a request may
> > > release multiple inodes' caps (by ceph_encode_inode_release).  Before
> > > sending the request out, we need to prevent ceph_check_caps() from
> > > touch these inodes' caps and sending cap messages.
> > 
> > I don't get it.
> > 
> > AFAICT, ceph_encode_inode_release is called while holding the
> > mdsc->mutex, not the s_mutex. That is serialized on the i_ceph_lock, but
> > I don't think there's any guarantee what order (e.g.) a racing cap
> > update and release would be sent.
> > 
> 
> You are right. cap messages can be slight out-of-order in above case.
> 

Thanks for confirming it.

> I checked the code again.  I think s_mutex is mainly for:
> 
> - cap message senders use s_mutex to ensure session does not get
> closed by CEPH_SESSION_CLOSE. For example __mark_caps_flushing() may
> race with remove_session_caps()

Ok, we should definitely try to prevent that race.

> - some functions such as ceph_iterate_session_caps are not reentrant.
> s_mutex is used for protecting these functions.

Good point. I'll have a look at that.

> - send_mds_reconnect() use s_mutex to prevent other threads from
> modifying cap states while it composing the reconnect message.
> 

Ok. I think we can reduce the coverage of the s_mutex somewhat, and
leave it in place for some of the more rare, heavyweight operations.

I think at this point, I realize that most of the cap message setup can
(and probably should) be done under the i_ceph_lock. It's only the
sending of the message the seems to require the s_mutex....which is a
shame, because the con has its own mutex, which could also be used to
ensure ordering.

Ideally, the queueing of outgoing messages to not require a mutex at
all, so we could queue them up under atomic context. That would do a lot
to simplify the cap handling, and it would probably be a lot more
efficient to boot.

It also stands out to me that most if not all of the operations under
ceph_con_send won't block. It doesn't seem like queueing up a message
and kicking the workqueue ought to require a mutex.
-- 
Jeff Layton <jlayton@redhat.com>

