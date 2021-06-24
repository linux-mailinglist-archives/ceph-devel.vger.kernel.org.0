Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362233B3504
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Jun 2021 19:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhFXRvK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Jun 2021 13:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbhFXRvK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 24 Jun 2021 13:51:10 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F085C061574
        for <ceph-devel@vger.kernel.org>; Thu, 24 Jun 2021 10:48:51 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id d9so9321247ioo.2
        for <ceph-devel@vger.kernel.org>; Thu, 24 Jun 2021 10:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oJmKNhsQjFNevkCGTwLHKvLbydYbctXbsUcyHWG7SXY=;
        b=BljWn35aqbvqPqmuLgcITE+J7wuHo7bS72td7CveVEG/8ZUIc+ykwou6bWcDVEcQj/
         jJ1X1bH4VDtI0grSec7cF5HPcFEOVqbk3kdWyj53hRhzyiHwVbL+U5RNYQiru4rqJnXc
         BaH7YRvqsGFefWt+eJDDP+6bm3yGiHSbH3FSI1+ZCO5c+TEV0usfXZdyZuVe/pPUmObz
         ysnOAqYdT9wy2487lRwJ1UtGTGQTnovCePddfIxTd79XwWggeirZJM7SDu/2EBfueiFd
         qxNBOISoRcnp5EGnDTm7dejdkiGS/wI3sA4caBK8IpJUnMQug6ynr22v3eOhfDJB8XJj
         dqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oJmKNhsQjFNevkCGTwLHKvLbydYbctXbsUcyHWG7SXY=;
        b=paL4r62R+OEcGnHBT4qkk10Li2VFMegradamyBYWa8Tgq1omG7nErWkoGqCNrorToG
         Rs0uBasYPocB5iapJZdo9I+U421mnxYkVlYuRmz68vWKksrWM+pfi7UvK6Zs4V4j+bUm
         NTRHCMCy1AcegKKcrXPtMIW20zleS/X80HjDnifY8wYvItX5tEkruxavuCX/1iRyaG2L
         y1Q1IVNaor8PNXAmbgGJDOABgjQLv7OAUBpYRTZgesQ08qxgRJ3yJFeLfcgQuEJelkkH
         FdbEbBmgpkmiw6IW7nk83U8T4QH0GXN/0HnOhV9Kzlpo5sRg8cTaySP7WK+Cl2UfDjkg
         aI2Q==
X-Gm-Message-State: AOAM532PJNwJbMUOMgmvpSdD4DQEPWFx+KUv+uktF4oe2pyFVmV0ClDa
        QlheKCiT8ycS+cvoF7bVkvNLtIEnznQm/JtRXcE=
X-Google-Smtp-Source: ABdhPJwB52P2H+keqQMZWL+mT7dHu35of1DemyeTqqK8+wcpOG3Cuh+yorntkQEHh7WVHGZJbzKTXsPN8OwgqES3J3Q=
X-Received: by 2002:a6b:4418:: with SMTP id r24mr5010156ioa.123.1624556930467;
 Thu, 24 Jun 2021 10:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210623151352.18840-1-idryomov@gmail.com> <c1528d5100efff0a9ab9f654934127d9b9c3dc65.camel@kernel.org>
 <CAOi1vP8+w9vo3Jg_yTdXKuUERAA_jvPjaF--zqkFfr6YJ15wNA@mail.gmail.com> <298435f7a8248d21c192c79ffc9e361e05058f4f.camel@kernel.org>
In-Reply-To: <298435f7a8248d21c192c79ffc9e361e05058f4f.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 24 Jun 2021 19:48:36 +0200
Message-ID: <CAOi1vP9wO6+UJXiX2NmfH4G-=114tJ-7EWviEFA-tvWm=zAmeQ@mail.gmail.com>
Subject: Re: [PATCH] libceph: set global_id as soon as we get an auth ticket
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 24, 2021 at 7:30 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Thu, 2021-06-24 at 19:16 +0200, Ilya Dryomov wrote:
> > On Thu, Jun 24, 2021 at 6:57 PM Jeff Layton <jlayton@kernel.org> wrote:
> > >
> > > On Wed, 2021-06-23 at 17:13 +0200, Ilya Dryomov wrote:
> > > > Commit 61ca49a9105f ("libceph: don't set global_id until we get an
> > > > auth ticket") delayed the setting of global_id too much.  It is set
> > > > only after all tickets are received, but in pre-nautilus clusters an
> > > > auth ticket and the service tickets are obtained in separate steps
> > > > (for a total of three MAuth replies).  When the service tickets are
> > > > requested, global_id is used to build an authorizer; if global_id is
> > > > still 0 we never get them and fail to establish the session.
> > > >
> > > > Moving the setting of global_id into protocol implementations.  This
> > > > way global_id can be set exactly when an auth ticket is received, not
> > > > sooner nor later.
> > > >
> > > > Fixes: 61ca49a9105f ("libceph: don't set global_id until we get an auth ticket")
> > > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > > ---
> > > >  include/linux/ceph/auth.h |  4 +++-
> > > >  net/ceph/auth.c           | 13 +++++--------
> > > >  net/ceph/auth_none.c      |  3 ++-
> > > >  net/ceph/auth_x.c         | 11 ++++++-----
> > > >  4 files changed, 16 insertions(+), 15 deletions(-)
> > > >
> > > > diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
> > > > index 39425e2f7cb2..6b138fa97db8 100644
> > > > --- a/include/linux/ceph/auth.h
> > > > +++ b/include/linux/ceph/auth.h
> > > > @@ -50,7 +50,7 @@ struct ceph_auth_client_ops {
> > > >        * another request.
> > > >        */
> > > >       int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
> > > > -     int (*handle_reply)(struct ceph_auth_client *ac,
> > > > +     int (*handle_reply)(struct ceph_auth_client *ac, u64 global_id,
> > > >                           void *buf, void *end, u8 *session_key,
> > > >                           int *session_key_len, u8 *con_secret,
> > > >                           int *con_secret_len);
> > > > @@ -104,6 +104,8 @@ struct ceph_auth_client {
> > > >       struct mutex mutex;
> > > >  };
> > > >
> > > > +void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id);
> > > > +
> > > >  struct ceph_auth_client *ceph_auth_init(const char *name,
> > > >                                       const struct ceph_crypto_key *key,
> > > >                                       const int *con_modes);
> > > > diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> > > > index d07c8cd6cb46..d38c9eadbe2f 100644
> > > > --- a/net/ceph/auth.c
> > > > +++ b/net/ceph/auth.c
> > > > @@ -36,7 +36,7 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
> > > >       }
> > > >  }
> > > >
> > > > -static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
> > > > +void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id)
> > > >  {
> > > >       dout("%s global_id %llu\n", __func__, global_id);
> > > >
> > > > @@ -262,7 +262,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
> > > >               goto out;
> > > >       }
> > > >
> > > > -     ret = ac->ops->handle_reply(ac, payload, payload_end,
> > > > +     ret = ac->ops->handle_reply(ac, global_id, payload, payload_end,
> > > >                                   NULL, NULL, NULL, NULL);
> > > >       if (ret == -EAGAIN) {
> > > >               ret = build_request(ac, true, reply_buf, reply_len);
> > > > @@ -271,8 +271,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
> > > >               goto out;
> > > >       }
> > > >
> > > > -     set_global_id(ac, global_id);
> > > > -
> > > >  out:
> > > >       mutex_unlock(&ac->mutex);
> > > >       return ret;
> > > > @@ -480,7 +478,7 @@ int ceph_auth_handle_reply_more(struct ceph_auth_client *ac, void *reply,
> > > >       int ret;
> > > >
> > > >       mutex_lock(&ac->mutex);
> > > > -     ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
> > > > +     ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
> > > >                                   NULL, NULL, NULL, NULL);
> > >
> > > Won't this trigger a KERN_ERR message? The the handle_reply routines
> > > call ceph_auth_set_global_id unconditionally, which will fire off the
> > > pr_err message and not do anything in this case.
> >
> > No, it won't get to calling ceph_auth_set_global_id() in this case because we
> > are handling the "more" frame.  An auth ticket is shared in the "done" frame,
> > anything before that can't end up in handle_auth_session_key().
> >
>
> Ok, so ceph_x_handle_reply only calls that in the
> CEPHX_GET_AUTH_SESSION_KEY case...
>
> I suppose we can't get any of this in the auth_none case, correct? If
> so, then I think this looks good:

Correct.  In the auth_none case the "done" frame is sent right away.

Thanks,

                Ilya
