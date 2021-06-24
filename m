Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4873B34CF
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Jun 2021 19:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhFXRdL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Jun 2021 13:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFXRdL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 13:33:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B17AD613C0;
        Thu, 24 Jun 2021 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624555852;
        bh=3dXx0XryUTvEVJqlYYsFBMCcLkxnjvhqdcgckMus/Vw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h9enBJ/7ovmjinO8uV3LWMCvd+ewnf37LjUMUN/yXtMbJqbo5RfOSE3j8LDuGiD28
         9u6qlhZ+8is6t9NzZZOQ2nW3G9oj52pf2JeFyJT3hp41Ibedhzf2r7B55Fx6G9246w
         Ohcd7IxBc6kMnvgmFHF262j3jkwQZMwhMmbTqGs7om/AqqAFQ18O2wxNPs5CUJAAbx
         Ug3YvTjD6O2phlRBYTdP0wL+36WwRNntBtiSGJ79eQIl4diChrbB41YF795gBOmQ6F
         rnFwtdGkfT3/mhqvHA9DkDaoL3klj/5zG9PRtUhRSk0FuY0j3rVk3DXHRKCC8YEFAY
         jbF3jd7nNPh6w==
Message-ID: <298435f7a8248d21c192c79ffc9e361e05058f4f.camel@kernel.org>
Subject: Re: [PATCH] libceph: set global_id as soon as we get an auth ticket
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Date:   Thu, 24 Jun 2021 13:30:50 -0400
In-Reply-To: <CAOi1vP8+w9vo3Jg_yTdXKuUERAA_jvPjaF--zqkFfr6YJ15wNA@mail.gmail.com>
References: <20210623151352.18840-1-idryomov@gmail.com>
         <c1528d5100efff0a9ab9f654934127d9b9c3dc65.camel@kernel.org>
         <CAOi1vP8+w9vo3Jg_yTdXKuUERAA_jvPjaF--zqkFfr6YJ15wNA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-06-24 at 19:16 +0200, Ilya Dryomov wrote:
> On Thu, Jun 24, 2021 at 6:57 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Wed, 2021-06-23 at 17:13 +0200, Ilya Dryomov wrote:
> > > Commit 61ca49a9105f ("libceph: don't set global_id until we get an
> > > auth ticket") delayed the setting of global_id too much.  It is set
> > > only after all tickets are received, but in pre-nautilus clusters an
> > > auth ticket and the service tickets are obtained in separate steps
> > > (for a total of three MAuth replies).  When the service tickets are
> > > requested, global_id is used to build an authorizer; if global_id is
> > > still 0 we never get them and fail to establish the session.
> > > 
> > > Moving the setting of global_id into protocol implementations.  This
> > > way global_id can be set exactly when an auth ticket is received, not
> > > sooner nor later.
> > > 
> > > Fixes: 61ca49a9105f ("libceph: don't set global_id until we get an auth ticket")
> > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > ---
> > >  include/linux/ceph/auth.h |  4 +++-
> > >  net/ceph/auth.c           | 13 +++++--------
> > >  net/ceph/auth_none.c      |  3 ++-
> > >  net/ceph/auth_x.c         | 11 ++++++-----
> > >  4 files changed, 16 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
> > > index 39425e2f7cb2..6b138fa97db8 100644
> > > --- a/include/linux/ceph/auth.h
> > > +++ b/include/linux/ceph/auth.h
> > > @@ -50,7 +50,7 @@ struct ceph_auth_client_ops {
> > >        * another request.
> > >        */
> > >       int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
> > > -     int (*handle_reply)(struct ceph_auth_client *ac,
> > > +     int (*handle_reply)(struct ceph_auth_client *ac, u64 global_id,
> > >                           void *buf, void *end, u8 *session_key,
> > >                           int *session_key_len, u8 *con_secret,
> > >                           int *con_secret_len);
> > > @@ -104,6 +104,8 @@ struct ceph_auth_client {
> > >       struct mutex mutex;
> > >  };
> > > 
> > > +void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id);
> > > +
> > >  struct ceph_auth_client *ceph_auth_init(const char *name,
> > >                                       const struct ceph_crypto_key *key,
> > >                                       const int *con_modes);
> > > diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> > > index d07c8cd6cb46..d38c9eadbe2f 100644
> > > --- a/net/ceph/auth.c
> > > +++ b/net/ceph/auth.c
> > > @@ -36,7 +36,7 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
> > >       }
> > >  }
> > > 
> > > -static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
> > > +void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id)
> > >  {
> > >       dout("%s global_id %llu\n", __func__, global_id);
> > > 
> > > @@ -262,7 +262,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
> > >               goto out;
> > >       }
> > > 
> > > -     ret = ac->ops->handle_reply(ac, payload, payload_end,
> > > +     ret = ac->ops->handle_reply(ac, global_id, payload, payload_end,
> > >                                   NULL, NULL, NULL, NULL);
> > >       if (ret == -EAGAIN) {
> > >               ret = build_request(ac, true, reply_buf, reply_len);
> > > @@ -271,8 +271,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
> > >               goto out;
> > >       }
> > > 
> > > -     set_global_id(ac, global_id);
> > > -
> > >  out:
> > >       mutex_unlock(&ac->mutex);
> > >       return ret;
> > > @@ -480,7 +478,7 @@ int ceph_auth_handle_reply_more(struct ceph_auth_client *ac, void *reply,
> > >       int ret;
> > > 
> > >       mutex_lock(&ac->mutex);
> > > -     ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
> > > +     ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
> > >                                   NULL, NULL, NULL, NULL);
> > 
> > Won't this trigger a KERN_ERR message? The the handle_reply routines
> > call ceph_auth_set_global_id unconditionally, which will fire off the
> > pr_err message and not do anything in this case.
> 
> No, it won't get to calling ceph_auth_set_global_id() in this case because we
> are handling the "more" frame.  An auth ticket is shared in the "done" frame,
> anything before that can't end up in handle_auth_session_key().
> 

Ok, so ceph_x_handle_reply only calls that in the
CEPHX_GET_AUTH_SESSION_KEY case...

I suppose we can't get any of this in the auth_none case, correct? If
so, then I think this looks good:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

