Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7F235948
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 11:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfFEJJi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 05:09:38 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33445 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfFEJJi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 05:09:38 -0400
Received: by mail-qt1-f195.google.com with SMTP id 14so17150169qtf.0
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 02:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RyWcudqjZ19I9d1KFJt2wGsUB6dssMoMq0dUWpd27Ds=;
        b=XBalon7XvZvWX/GECK1hFX6+Iay69osk+f9AZiGgNcrGhcI/juu0+GoW8i7x6clXG/
         okarBa5qszw4cW00a0AFLT9qG3jxHqo4vMhmF1smse3qJCwlRSjzG638NepI1KWuZgaI
         qh1VNvdgUX8+1b/F9mnZZaupq+EfWgD8eI/JuFvXxrGK3fL11VVmB6NcZmN0Wt2endJC
         sIB92S0fWPsgnyVLfQKXGwDxxqjBmM/pPAEzzSeCq9+pTGHBXsePKhk9wwkRDwniJ7fI
         nX7YvkxJ9ETXp3fdB79YY4MDtDg0Cr1Nye9t2lfEDcBpV63uaBuCoDMuZ5ca5BATeBFE
         fWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RyWcudqjZ19I9d1KFJt2wGsUB6dssMoMq0dUWpd27Ds=;
        b=CS3KuhVSU3mV4FApSVPU+sHC8TD+EXTbINyXxBC3tRjwsUx/KdXhPCebEHzCEWgroi
         dINq1a4s5+moV/lk2KHoqdY9aZJFvXPJaX9bmGPxhzNOZtS1kuwnWE+Gc/bwxHEZ2IT0
         vuxf0JTaZ8OnYlhfdFzfxH43ygbDvvXinbofsI7Sr2uX6phHcqowoBtQBrGawXNLV3EA
         lGdjOfd8W7xaPFIk4Qxi2lFfyZ6gnu0HVHQqR3z+A2yBA2ImGdCFzzZbkKtnCCVKL1jE
         7I/xLuNpVFdr0CS7X5vmARiCHIErv0IcmpPkvx6VnDAyVz0W7211A9eFTsi7STZurPMq
         jG9Q==
X-Gm-Message-State: APjAAAW4BnM+nqZ1lEJrDsRyqZoG6w2M+YHFH/LV0uqXIoHpdjS2vOAH
        3a08feA/uwiHOHT/UAZQIkpSkYIADDuxABtLDCAFcP9Mbdo=
X-Google-Smtp-Source: APXvYqy5zz9C+tsoYTq/5XNFBBNEiEK3nTtzu//4ek8gfzgYABzZHbycoox4HjIwLgacLTkua80Oei5kD48pzEvqRoI=
X-Received: by 2002:a0c:9916:: with SMTP id h22mr11650109qvd.95.1559725777013;
 Wed, 05 Jun 2019 02:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190604093908.30491-1-zyan@redhat.com> <b8e91fb1b19c36bd8493e316b60a2313b044ee8a.camel@redhat.com>
 <CAAM7YA=bDmbOvwYRghT30R=-Rgw2vTt0Wctxo6=xH137tgqiBg@mail.gmail.com> <271c6b6b44fcc4f8d84a6d4035179b94bc6986ba.camel@redhat.com>
In-Reply-To: <271c6b6b44fcc4f8d84a6d4035179b94bc6986ba.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 5 Jun 2019 17:09:25 +0800
Message-ID: <CAAM7YAmkP98WgfnHSHNS9Gc-isdeoxQwz_SG0F4rNfd+-zRroQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] libceph: add function that reset client's entity addr
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 9:12 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2019-06-04 at 20:35 +0800, Yan, Zheng wrote:
> > On Tue, Jun 4, 2019 at 7:04 PM Jeff Layton <jlayton@redhat.com> wrote:
> > > On Tue, 2019-06-04 at 17:39 +0800, Yan, Zheng wrote:
> > > > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > > > ---
> > > >  include/linux/ceph/libceph.h    |  1 +
> > > >  include/linux/ceph/messenger.h  |  1 +
> > > >  include/linux/ceph/mon_client.h |  1 +
> > > >  include/linux/ceph/osd_client.h |  1 +
> > > >  net/ceph/ceph_common.c          |  8 ++++++++
> > > >  net/ceph/messenger.c            |  5 +++++
> > > >  net/ceph/mon_client.c           |  7 +++++++
> > > >  net/ceph/osd_client.c           | 16 ++++++++++++++++
> > > >  8 files changed, 40 insertions(+)
> > > >
> > > > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > > > index a3cddf5f0e60..f29959eed025 100644
> > > > --- a/include/linux/ceph/libceph.h
> > > > +++ b/include/linux/ceph/libceph.h
> > > > @@ -291,6 +291,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
> > > >  struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
> > > >  u64 ceph_client_gid(struct ceph_client *client);
> > > >  extern void ceph_destroy_client(struct ceph_client *client);
> > > > +extern void ceph_reset_client_addr(struct ceph_client *client);
> > > >  extern int __ceph_open_session(struct ceph_client *client,
> > > >                              unsigned long started);
> > > >  extern int ceph_open_session(struct ceph_client *client);
> > > > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> > > > index 23895d178149..c4458dc6a757 100644
> > > > --- a/include/linux/ceph/messenger.h
> > > > +++ b/include/linux/ceph/messenger.h
> > > > @@ -337,6 +337,7 @@ extern void ceph_msgr_flush(void);
> > > >  extern void ceph_messenger_init(struct ceph_messenger *msgr,
> > > >                               struct ceph_entity_addr *myaddr);
> > > >  extern void ceph_messenger_fini(struct ceph_messenger *msgr);
> > > > +extern void ceph_messenger_reset_nonce(struct ceph_messenger *msgr);
> > > >
> > > >  extern void ceph_con_init(struct ceph_connection *con, void *private,
> > > >                       const struct ceph_connection_operations *ops,
> > > > diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
> > > > index 3a4688af7455..0d8d890c6759 100644
> > > > --- a/include/linux/ceph/mon_client.h
> > > > +++ b/include/linux/ceph/mon_client.h
> > > > @@ -110,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
> > > >
> > > >  extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
> > > >  extern void ceph_monc_stop(struct ceph_mon_client *monc);
> > > > +extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
> > > >
> > > >  enum {
> > > >       CEPH_SUB_MONMAP = 0,
> > > > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > > > index 2294f963dab7..a12b7fc9cfd6 100644
> > > > --- a/include/linux/ceph/osd_client.h
> > > > +++ b/include/linux/ceph/osd_client.h
> > > > @@ -381,6 +381,7 @@ extern void ceph_osdc_cleanup(void);
> > > >  extern int ceph_osdc_init(struct ceph_osd_client *osdc,
> > > >                         struct ceph_client *client);
> > > >  extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
> > > > +extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
> > > >
> > > >  extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
> > > >                                  struct ceph_msg *msg);
> > > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > > index 79eac465ec65..55210823d1cc 100644
> > > > --- a/net/ceph/ceph_common.c
> > > > +++ b/net/ceph/ceph_common.c
> > > > @@ -693,6 +693,14 @@ void ceph_destroy_client(struct ceph_client *client)
> > > >  }
> > > >  EXPORT_SYMBOL(ceph_destroy_client);
> > > >
> > > > +void ceph_reset_client_addr(struct ceph_client *client)
> > > > +{
> > > > +     ceph_messenger_reset_nonce(&client->msgr);
> > > > +     ceph_monc_reopen_session(&client->monc);
> > > > +     ceph_osdc_reopen_osds(&client->osdc);
> > > > +}
> > > > +EXPORT_SYMBOL(ceph_reset_client_addr);
> > > > +
> > > >  /*
> > > >   * true if we have the mon map (and have thus joined the cluster)
> > > >   */
> > > > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > > > index 3ee380758ddd..cd03a1cba849 100644
> > > > --- a/net/ceph/messenger.c
> > > > +++ b/net/ceph/messenger.c
> > > > @@ -3028,6 +3028,11 @@ static void con_fault(struct ceph_connection *con)
> > > >  }
> > > >
> > > >
> > > > +void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
> > > > +{
> > > > +     msgr->inst.addr.nonce += 1000000;
> > > > +     encode_my_addr(msgr);
> > > > +}
> > > >
> > > >  /*
> > > >   * initialize a new messenger instance
> > > > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > > > index 895679d3529b..6dab6a94e9cc 100644
> > > > --- a/net/ceph/mon_client.c
> > > > +++ b/net/ceph/mon_client.c
> > > > @@ -209,6 +209,13 @@ static void reopen_session(struct ceph_mon_client *monc)
> > > >       __open_session(monc);
> > > >  }
> > > >
> > > > +void ceph_monc_reopen_session(struct ceph_mon_client *monc)
> > > > +{
> > > > +     mutex_lock(&monc->mutex);
> > > > +     reopen_session(monc);
> > > > +     mutex_unlock(&monc->mutex);
> > > > +}
> > > > +
> > > >  static void un_backoff(struct ceph_mon_client *monc)
> > > >  {
> > > >       monc->hunt_mult /= 2; /* reduce by 50% */
> > > > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > > > index e6d31e0f0289..67e9466f27fd 100644
> > > > --- a/net/ceph/osd_client.c
> > > > +++ b/net/ceph/osd_client.c
> > > > @@ -5089,6 +5089,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
> > > >  }
> > > >  EXPORT_SYMBOL(ceph_osdc_call);
> > > >
> > > > +/*
> > > > + * reset all osd connections
> > > > + */
> > > > +void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
> > > > +{
> > > > +     struct rb_node *n;
> > > > +     down_write(&osdc->lock);
> > > > +     for (n = rb_first(&osdc->osds); n; ) {
> > > > +             struct ceph_osd *osd = rb_entry(n, struct ceph_osd, o_node);
> > > > +             n = rb_next(n);
> > > > +             if (!reopen_osd(osd))
> > > > +                     kick_osd_requests(osd);
> > > > +     }
> > > > +     up_write(&osdc->lock);
> > > > +}
> > > > +
> > > >  /*
> > > >   * init, shutdown
> > > >   */
> > >
> > > I'd like to better understand what happens to file descriptors that were
> > > opened before the blacklisting occurred.
> > >
> > > Suppose I hold a POSIX lock on a O_RDWR fd, and then get blacklisted.
> > > The admin then remounts the mount. What happens to my fd? Can I carry on
> > > using it, or will it be shut down in some fashion? What about the lock?
> > > I've definitely lost it during the blacklisting -- how do we make the
> > > application aware of that fact?
> >
> > After 'mount -f',  cephfs return -EIO for any operation on open files.
> > After remount, operations except fsync and close work as normal. fsync
> > and close return error if any dirty data got dropped.
> >
> > Current cephfs code already handle file lock. after session get
> > evicted, cephfs return -EIO for any lock operation until all local
> > locks are released. (see commit b3f8d68f38a87)
> >
>
> I think that's not sufficient. After a blacklisting event, we need to
> shut down all file descriptors that were open before the event.
>
> Consider:
>
> Suppose I have an application (maybe a distributed database) that opens
> a file O_RDWR and takes out a lock on the file. The client gets
> blacklisted and loses its lock, and then the admin remounts the thing
> leaving the fd intact.
>
> After the blacklisting, the application then performs some writes to the
> file and fsyncs and that all succeeds. Those writes are now being done
> without holding the file lock, even though the application thinks it has
> the lock. That seems like potential silent data corruption.
>

Is it possible that application uses one file descriptor to do file
locking, and use different file descriptors to do read/write.  If it
is, allowing read/write from new file descriptor is not safe either.

Regards
Yan, Zheng

> Remounting is fine if we're just interested in getting the mount working
> again, but I don't see how we can reasonably allow applications to
> assume continuity of stateful objects across such an event.



> --
> Jeff Layton <jlayton@redhat.com>
>
