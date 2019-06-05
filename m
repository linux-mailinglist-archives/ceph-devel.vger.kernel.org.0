Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E584535AED
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 13:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfFELNh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 07:13:37 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42046 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfFELNg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 07:13:36 -0400
Received: by mail-yw1-f67.google.com with SMTP id s5so10201129ywd.9
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 04:13:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9U+AhXsOninj/53MmFrFTrnO37eIpQmyBY+O5+1ZBog=;
        b=Hh9HECoZYakVwQdBZaLCagwyy9gEGZM8AKGIwIONsI5QSgIPUFfh5KfMD2fAFpC3oy
         yuWyFFvaR8rzmw+nggVskQUviS4p8QerwT2nrowNIBpTugSYUZQY9qQ1hrKTkamliScX
         M7HOvAx2jmMdQjC6bIxYktmsROBPRsqRusBMZe8JDy5Sie2oI9QNtdY/oaWM+1gjijk1
         DbFiZ80aFnMMn0hwLcHYcT1Y2GwrgMZkTkIqf1bYtqfj6d84c1JRrzlJiQfJC7YkDme2
         YuVy6RvmaXqK7b8g+GBcCt2NchZ7blddaeW7/cDESs9BvXcpQjNfSIpptWn7nG1WS/Iy
         1USA==
X-Gm-Message-State: APjAAAW+iH2Kz0hinUwYc4f+eFotqxyWXL6Z8fCLvodtv1QZ4fxNXyLW
        6veEkW6zyePq17tIwQ6wIgC1ww==
X-Google-Smtp-Source: APXvYqxZKEUh+zSabOoNcRhoEiuaM1vW0ipyq3oJtjMdwqk4njuVXEKXhn02brtXh9PVhxGCNdTq3A==
X-Received: by 2002:a81:9a8e:: with SMTP id r136mr20946823ywg.121.1559733215492;
        Wed, 05 Jun 2019 04:13:35 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-32F.dyn6.twc.com. [2606:a000:1100:37d::32f])
        by smtp.gmail.com with ESMTPSA id 203sm3712764ywq.24.2019.06.05.04.13.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 04:13:34 -0700 (PDT)
Message-ID: <cf72762eac9ddcb158915c24c7a458829e18e521.camel@redhat.com>
Subject: Re: [PATCH 1/4] libceph: add function that reset client's entity
 addr
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 05 Jun 2019 07:13:33 -0400
In-Reply-To: <CAAM7YAmkP98WgfnHSHNS9Gc-isdeoxQwz_SG0F4rNfd+-zRroQ@mail.gmail.com>
References: <20190604093908.30491-1-zyan@redhat.com>
         <b8e91fb1b19c36bd8493e316b60a2313b044ee8a.camel@redhat.com>
         <CAAM7YA=bDmbOvwYRghT30R=-Rgw2vTt0Wctxo6=xH137tgqiBg@mail.gmail.com>
         <271c6b6b44fcc4f8d84a6d4035179b94bc6986ba.camel@redhat.com>
         <CAAM7YAmkP98WgfnHSHNS9Gc-isdeoxQwz_SG0F4rNfd+-zRroQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-06-05 at 17:09 +0800, Yan, Zheng wrote:
> On Tue, Jun 4, 2019 at 9:12 PM Jeff Layton <jlayton@redhat.com> wrote:
> > On Tue, 2019-06-04 at 20:35 +0800, Yan, Zheng wrote:
> > > On Tue, Jun 4, 2019 at 7:04 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > > On Tue, 2019-06-04 at 17:39 +0800, Yan, Zheng wrote:
> > > > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > > > ---
> > > > >  include/linux/ceph/libceph.h    |  1 +
> > > > >  include/linux/ceph/messenger.h  |  1 +
> > > > >  include/linux/ceph/mon_client.h |  1 +
> > > > >  include/linux/ceph/osd_client.h |  1 +
> > > > >  net/ceph/ceph_common.c          |  8 ++++++++
> > > > >  net/ceph/messenger.c            |  5 +++++
> > > > >  net/ceph/mon_client.c           |  7 +++++++
> > > > >  net/ceph/osd_client.c           | 16 ++++++++++++++++
> > > > >  8 files changed, 40 insertions(+)
> > > > > 
> > > > > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > > > > index a3cddf5f0e60..f29959eed025 100644
> > > > > --- a/include/linux/ceph/libceph.h
> > > > > +++ b/include/linux/ceph/libceph.h
> > > > > @@ -291,6 +291,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
> > > > >  struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
> > > > >  u64 ceph_client_gid(struct ceph_client *client);
> > > > >  extern void ceph_destroy_client(struct ceph_client *client);
> > > > > +extern void ceph_reset_client_addr(struct ceph_client *client);
> > > > >  extern int __ceph_open_session(struct ceph_client *client,
> > > > >                              unsigned long started);
> > > > >  extern int ceph_open_session(struct ceph_client *client);
> > > > > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> > > > > index 23895d178149..c4458dc6a757 100644
> > > > > --- a/include/linux/ceph/messenger.h
> > > > > +++ b/include/linux/ceph/messenger.h
> > > > > @@ -337,6 +337,7 @@ extern void ceph_msgr_flush(void);
> > > > >  extern void ceph_messenger_init(struct ceph_messenger *msgr,
> > > > >                               struct ceph_entity_addr *myaddr);
> > > > >  extern void ceph_messenger_fini(struct ceph_messenger *msgr);
> > > > > +extern void ceph_messenger_reset_nonce(struct ceph_messenger *msgr);
> > > > > 
> > > > >  extern void ceph_con_init(struct ceph_connection *con, void *private,
> > > > >                       const struct ceph_connection_operations *ops,
> > > > > diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
> > > > > index 3a4688af7455..0d8d890c6759 100644
> > > > > --- a/include/linux/ceph/mon_client.h
> > > > > +++ b/include/linux/ceph/mon_client.h
> > > > > @@ -110,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
> > > > > 
> > > > >  extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
> > > > >  extern void ceph_monc_stop(struct ceph_mon_client *monc);
> > > > > +extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
> > > > > 
> > > > >  enum {
> > > > >       CEPH_SUB_MONMAP = 0,
> > > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > > index 2294f963dab7..a12b7fc9cfd6 100644
> > > > > --- a/include/linux/ceph/osd_client.h
> > > > > +++ b/include/linux/ceph/osd_client.h
> > > > > @@ -381,6 +381,7 @@ extern void ceph_osdc_cleanup(void);
> > > > >  extern int ceph_osdc_init(struct ceph_osd_client *osdc,
> > > > >                         struct ceph_client *client);
> > > > >  extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
> > > > > +extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
> > > > > 
> > > > >  extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
> > > > >                                  struct ceph_msg *msg);
> > > > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > > > index 79eac465ec65..55210823d1cc 100644
> > > > > --- a/net/ceph/ceph_common.c
> > > > > +++ b/net/ceph/ceph_common.c
> > > > > @@ -693,6 +693,14 @@ void ceph_destroy_client(struct ceph_client *client)
> > > > >  }
> > > > >  EXPORT_SYMBOL(ceph_destroy_client);
> > > > > 
> > > > > +void ceph_reset_client_addr(struct ceph_client *client)
> > > > > +{
> > > > > +     ceph_messenger_reset_nonce(&client->msgr);
> > > > > +     ceph_monc_reopen_session(&client->monc);
> > > > > +     ceph_osdc_reopen_osds(&client->osdc);
> > > > > +}
> > > > > +EXPORT_SYMBOL(ceph_reset_client_addr);
> > > > > +
> > > > >  /*
> > > > >   * true if we have the mon map (and have thus joined the cluster)
> > > > >   */
> > > > > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > > > > index 3ee380758ddd..cd03a1cba849 100644
> > > > > --- a/net/ceph/messenger.c
> > > > > +++ b/net/ceph/messenger.c
> > > > > @@ -3028,6 +3028,11 @@ static void con_fault(struct ceph_connection *con)
> > > > >  }
> > > > > 
> > > > > 
> > > > > +void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
> > > > > +{
> > > > > +     msgr->inst.addr.nonce += 1000000;
> > > > > +     encode_my_addr(msgr);
> > > > > +}
> > > > > 
> > > > >  /*
> > > > >   * initialize a new messenger instance
> > > > > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > > > > index 895679d3529b..6dab6a94e9cc 100644
> > > > > --- a/net/ceph/mon_client.c
> > > > > +++ b/net/ceph/mon_client.c
> > > > > @@ -209,6 +209,13 @@ static void reopen_session(struct ceph_mon_client *monc)
> > > > >       __open_session(monc);
> > > > >  }
> > > > > 
> > > > > +void ceph_monc_reopen_session(struct ceph_mon_client *monc)
> > > > > +{
> > > > > +     mutex_lock(&monc->mutex);
> > > > > +     reopen_session(monc);
> > > > > +     mutex_unlock(&monc->mutex);
> > > > > +}
> > > > > +
> > > > >  static void un_backoff(struct ceph_mon_client *monc)
> > > > >  {
> > > > >       monc->hunt_mult /= 2; /* reduce by 50% */
> > > > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > > > index e6d31e0f0289..67e9466f27fd 100644
> > > > > --- a/net/ceph/osd_client.c
> > > > > +++ b/net/ceph/osd_client.c
> > > > > @@ -5089,6 +5089,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
> > > > >  }
> > > > >  EXPORT_SYMBOL(ceph_osdc_call);
> > > > > 
> > > > > +/*
> > > > > + * reset all osd connections
> > > > > + */
> > > > > +void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
> > > > > +{
> > > > > +     struct rb_node *n;
> > > > > +     down_write(&osdc->lock);
> > > > > +     for (n = rb_first(&osdc->osds); n; ) {
> > > > > +             struct ceph_osd *osd = rb_entry(n, struct ceph_osd, o_node);
> > > > > +             n = rb_next(n);
> > > > > +             if (!reopen_osd(osd))
> > > > > +                     kick_osd_requests(osd);
> > > > > +     }
> > > > > +     up_write(&osdc->lock);
> > > > > +}
> > > > > +
> > > > >  /*
> > > > >   * init, shutdown
> > > > >   */
> > > > 
> > > > I'd like to better understand what happens to file descriptors that were
> > > > opened before the blacklisting occurred.
> > > > 
> > > > Suppose I hold a POSIX lock on a O_RDWR fd, and then get blacklisted.
> > > > The admin then remounts the mount. What happens to my fd? Can I carry on
> > > > using it, or will it be shut down in some fashion? What about the lock?
> > > > I've definitely lost it during the blacklisting -- how do we make the
> > > > application aware of that fact?
> > > 
> > > After 'mount -f',  cephfs return -EIO for any operation on open files.
> > > After remount, operations except fsync and close work as normal. fsync
> > > and close return error if any dirty data got dropped.
> > > 
> > > Current cephfs code already handle file lock. after session get
> > > evicted, cephfs return -EIO for any lock operation until all local
> > > locks are released. (see commit b3f8d68f38a87)
> > > 
> > 
> > I think that's not sufficient. After a blacklisting event, we need to
> > shut down all file descriptors that were open before the event.
> > 
> > Consider:
> > 
> > Suppose I have an application (maybe a distributed database) that opens
> > a file O_RDWR and takes out a lock on the file. The client gets
> > blacklisted and loses its lock, and then the admin remounts the thing
> > leaving the fd intact.
> > 
> > After the blacklisting, the application then performs some writes to the
> > file and fsyncs and that all succeeds. Those writes are now being done
> > without holding the file lock, even though the application thinks it has
> > the lock. That seems like potential silent data corruption.
> > 
> 
> Is it possible that application uses one file descriptor to do file
> locking, and use different file descriptors to do read/write.  If it
> is, allowing read/write from new file descriptor is not safe either.
> 

Sure, applications do all sorts of crazy things. PostgreSQL (for
instance) has a process separate from the writers to handle fsyncs. That
could also be problematic in this scenario.

The main point here is that a file description is (partly) a
representation of state granted by the MDS, and that state can no longer
be considered valid after the client has been blacklisted.

In practice, applications would need to have special handling to detect
and deal with this situation, and >99% of them won't have it. Most
applications will need to be restarted altogether after an event like
this, which makes me question whether this is something we should do at
all.
-- 
Jeff Layton <jlayton@redhat.com>

