Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA5346EE
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 14:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfFDMfm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 08:35:42 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38741 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbfFDMfm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 08:35:42 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so2666211qkk.5
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 05:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JS6U2CJ7hl7+2c49gYugaBLH6l7N9VoVZhWGoMxhS9I=;
        b=Bryv71+t4UKn5zl74Y51YFs2f1GmkHQ1+cO4zyvyAj1ATdYMq/j9pKuOh7Jo8PMrz9
         fq9p6EmmckI7izogorrLfo4H13yN+lxwlCq0AyybQgbS7mO39kwfC69ydD4Q3FrRxief
         cAn80hp2SjaZTV9dMGN1zrl1DdRWlgdpCz0IasqpmYB6qkhaa4dr8yfaQNJ25NRZ9Rfr
         rFz1IPz61WWeJEM9Bprfm5HWCvgs/+Lu03jch59QsNpeT9/3XGpHSMRKQu/fgHWkLRB0
         jZRopTpuDgwyYUd0evzT3YulJI34Eqvg1jKuu9ITL0yg1Q4BLB8vpmoYCENq18rnx6hJ
         SesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JS6U2CJ7hl7+2c49gYugaBLH6l7N9VoVZhWGoMxhS9I=;
        b=Eia3mOu1AXPtF7bia1EoUqNJyMW/yjKN4e+2l3eSrcQ8Ub08/CtWzpulDfv5PKurG+
         I4mavo6k53fTF14GHQbSsiwv07jLTYtE2F6/ughrUg9CWG27L5xlbU44wxTFR6csahM2
         tWJp2ZYwBl2xz4aOQHdFIMmVuMiBp/ZtD7O4OjoEXLLKb+H5N6gCmqIGW7KKtDO0a5k8
         W72m4kvN9k/ioRClSNVs5NgDZsOSvadf09b64MEeEb8tALTQ5Mr3O4Xra6a6waV7bzBg
         7BBWH4t6vQQ12XttwRh2oVpsF3d8V/3jNsB87sbSTkl7YlmLcpfi5LWWijAOi+81+i78
         88Hg==
X-Gm-Message-State: APjAAAWpp+rHCnlZbNVKt4EhO+gS+4CyarFVFxzFTxSxeNia0MYcvTeq
        XQKEgZj3GxY1T+C5BN58oMkoQ5lnYrum7OVzh2c=
X-Google-Smtp-Source: APXvYqwzRgKwANpu7rnvj2lcyZw2RBXn/0K1nVPnp6eeMM/gfz9dmp0W6SwyHPaga4qGk5xQj+WPY8zmdczwSaBlwPU=
X-Received: by 2002:a37:d244:: with SMTP id f65mr3433674qkj.227.1559651740471;
 Tue, 04 Jun 2019 05:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190604093908.30491-1-zyan@redhat.com> <b8e91fb1b19c36bd8493e316b60a2313b044ee8a.camel@redhat.com>
In-Reply-To: <b8e91fb1b19c36bd8493e316b60a2313b044ee8a.camel@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 4 Jun 2019 20:35:28 +0800
Message-ID: <CAAM7YA=bDmbOvwYRghT30R=-Rgw2vTt0Wctxo6=xH137tgqiBg@mail.gmail.com>
Subject: Re: [PATCH 1/4] libceph: add function that reset client's entity addr
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 7:04 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Tue, 2019-06-04 at 17:39 +0800, Yan, Zheng wrote:
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  include/linux/ceph/libceph.h    |  1 +
> >  include/linux/ceph/messenger.h  |  1 +
> >  include/linux/ceph/mon_client.h |  1 +
> >  include/linux/ceph/osd_client.h |  1 +
> >  net/ceph/ceph_common.c          |  8 ++++++++
> >  net/ceph/messenger.c            |  5 +++++
> >  net/ceph/mon_client.c           |  7 +++++++
> >  net/ceph/osd_client.c           | 16 ++++++++++++++++
> >  8 files changed, 40 insertions(+)
> >
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > index a3cddf5f0e60..f29959eed025 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -291,6 +291,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
> >  struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
> >  u64 ceph_client_gid(struct ceph_client *client);
> >  extern void ceph_destroy_client(struct ceph_client *client);
> > +extern void ceph_reset_client_addr(struct ceph_client *client);
> >  extern int __ceph_open_session(struct ceph_client *client,
> >                              unsigned long started);
> >  extern int ceph_open_session(struct ceph_client *client);
> > diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> > index 23895d178149..c4458dc6a757 100644
> > --- a/include/linux/ceph/messenger.h
> > +++ b/include/linux/ceph/messenger.h
> > @@ -337,6 +337,7 @@ extern void ceph_msgr_flush(void);
> >  extern void ceph_messenger_init(struct ceph_messenger *msgr,
> >                               struct ceph_entity_addr *myaddr);
> >  extern void ceph_messenger_fini(struct ceph_messenger *msgr);
> > +extern void ceph_messenger_reset_nonce(struct ceph_messenger *msgr);
> >
> >  extern void ceph_con_init(struct ceph_connection *con, void *private,
> >                       const struct ceph_connection_operations *ops,
> > diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
> > index 3a4688af7455..0d8d890c6759 100644
> > --- a/include/linux/ceph/mon_client.h
> > +++ b/include/linux/ceph/mon_client.h
> > @@ -110,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
> >
> >  extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
> >  extern void ceph_monc_stop(struct ceph_mon_client *monc);
> > +extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
> >
> >  enum {
> >       CEPH_SUB_MONMAP = 0,
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 2294f963dab7..a12b7fc9cfd6 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -381,6 +381,7 @@ extern void ceph_osdc_cleanup(void);
> >  extern int ceph_osdc_init(struct ceph_osd_client *osdc,
> >                         struct ceph_client *client);
> >  extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
> > +extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
> >
> >  extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
> >                                  struct ceph_msg *msg);
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index 79eac465ec65..55210823d1cc 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -693,6 +693,14 @@ void ceph_destroy_client(struct ceph_client *client)
> >  }
> >  EXPORT_SYMBOL(ceph_destroy_client);
> >
> > +void ceph_reset_client_addr(struct ceph_client *client)
> > +{
> > +     ceph_messenger_reset_nonce(&client->msgr);
> > +     ceph_monc_reopen_session(&client->monc);
> > +     ceph_osdc_reopen_osds(&client->osdc);
> > +}
> > +EXPORT_SYMBOL(ceph_reset_client_addr);
> > +
> >  /*
> >   * true if we have the mon map (and have thus joined the cluster)
> >   */
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > index 3ee380758ddd..cd03a1cba849 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -3028,6 +3028,11 @@ static void con_fault(struct ceph_connection *con)
> >  }
> >
> >
> > +void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
> > +{
> > +     msgr->inst.addr.nonce += 1000000;
> > +     encode_my_addr(msgr);
> > +}
> >
> >  /*
> >   * initialize a new messenger instance
> > diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> > index 895679d3529b..6dab6a94e9cc 100644
> > --- a/net/ceph/mon_client.c
> > +++ b/net/ceph/mon_client.c
> > @@ -209,6 +209,13 @@ static void reopen_session(struct ceph_mon_client *monc)
> >       __open_session(monc);
> >  }
> >
> > +void ceph_monc_reopen_session(struct ceph_mon_client *monc)
> > +{
> > +     mutex_lock(&monc->mutex);
> > +     reopen_session(monc);
> > +     mutex_unlock(&monc->mutex);
> > +}
> > +
> >  static void un_backoff(struct ceph_mon_client *monc)
> >  {
> >       monc->hunt_mult /= 2; /* reduce by 50% */
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index e6d31e0f0289..67e9466f27fd 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -5089,6 +5089,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
> >  }
> >  EXPORT_SYMBOL(ceph_osdc_call);
> >
> > +/*
> > + * reset all osd connections
> > + */
> > +void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
> > +{
> > +     struct rb_node *n;
> > +     down_write(&osdc->lock);
> > +     for (n = rb_first(&osdc->osds); n; ) {
> > +             struct ceph_osd *osd = rb_entry(n, struct ceph_osd, o_node);
> > +             n = rb_next(n);
> > +             if (!reopen_osd(osd))
> > +                     kick_osd_requests(osd);
> > +     }
> > +     up_write(&osdc->lock);
> > +}
> > +
> >  /*
> >   * init, shutdown
> >   */
>
> I'd like to better understand what happens to file descriptors that were
> opened before the blacklisting occurred.
>
> Suppose I hold a POSIX lock on a O_RDWR fd, and then get blacklisted.
> The admin then remounts the mount. What happens to my fd? Can I carry on
> using it, or will it be shut down in some fashion? What about the lock?
> I've definitely lost it during the blacklisting -- how do we make the
> application aware of that fact?

After 'mount -f',  cephfs return -EIO for any operation on open files.
After remount, operations except fsync and close work as normal. fsync
and close return error if any dirty data got dropped.

Current cephfs code already handle file lock. after session get
evicted, cephfs return -EIO for any lock operation until all local
locks are released. (see commit b3f8d68f38a87)

Regards
Yan, Zheng
>
> I wonder if we would to resurrect the revoke/frevoke work to make this
> safe, so that we could revoke any open fds when blacklisting occurs.
> --
> Jeff Layton <jlayton@redhat.com>
>
