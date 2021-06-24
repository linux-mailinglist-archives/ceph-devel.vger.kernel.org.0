Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020463B343D
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Jun 2021 18:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhFXRAI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Jun 2021 13:00:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhFXRAI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 13:00:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35D5613EC;
        Thu, 24 Jun 2021 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624553869;
        bh=TnzKRjwDNY5CGLlDJfRZiqLQAcZzd5rZm98DK7CjoFk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Sp+iCC2H8ji7EfmXDc8DydLGvz/r+4HZm7OhNuIxQQbS5y9JMKid8T8/wAl8kyB2b
         mlF1QGEGYbavpWgNTDAbCbVZsrVDhjpv8Yg9AiEcfiIfP/cJ4xgSn1KrsEUDu94eiq
         7jFTQRepmVFZNeKKswdz1dHUYpxpz7CnexI+K6QrrD9B9AtwiQ2BPpkEcymDZyrxgn
         ezQG93OLsg6JX/Ocg2pEN9gwYG3aWLHDHiYwcJ5UlEvZECqYZn1Figv+1v9IAD1zn6
         WSM/3ZVsfcEDn79yqd+rWOxWvB1Mgl9kmhP/etcsr+zdw0RkSNUxs1/ZWbe7ASGNRv
         IzgFrljQwKyKQ==
Message-ID: <c1528d5100efff0a9ab9f654934127d9b9c3dc65.camel@kernel.org>
Subject: Re: [PATCH] libceph: set global_id as soon as we get an auth ticket
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>
Date:   Thu, 24 Jun 2021 12:57:47 -0400
In-Reply-To: <20210623151352.18840-1-idryomov@gmail.com>
References: <20210623151352.18840-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-06-23 at 17:13 +0200, Ilya Dryomov wrote:
> Commit 61ca49a9105f ("libceph: don't set global_id until we get an
> auth ticket") delayed the setting of global_id too much.  It is set
> only after all tickets are received, but in pre-nautilus clusters an
> auth ticket and the service tickets are obtained in separate steps
> (for a total of three MAuth replies).  When the service tickets are
> requested, global_id is used to build an authorizer; if global_id is
> still 0 we never get them and fail to establish the session.
> 
> Moving the setting of global_id into protocol implementations.  This
> way global_id can be set exactly when an auth ticket is received, not
> sooner nor later.
> 
> Fixes: 61ca49a9105f ("libceph: don't set global_id until we get an auth ticket")
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/auth.h |  4 +++-
>  net/ceph/auth.c           | 13 +++++--------
>  net/ceph/auth_none.c      |  3 ++-
>  net/ceph/auth_x.c         | 11 ++++++-----
>  4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
> index 39425e2f7cb2..6b138fa97db8 100644
> --- a/include/linux/ceph/auth.h
> +++ b/include/linux/ceph/auth.h
> @@ -50,7 +50,7 @@ struct ceph_auth_client_ops {
>  	 * another request.
>  	 */
>  	int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
> -	int (*handle_reply)(struct ceph_auth_client *ac,
> +	int (*handle_reply)(struct ceph_auth_client *ac, u64 global_id,
>  			    void *buf, void *end, u8 *session_key,
>  			    int *session_key_len, u8 *con_secret,
>  			    int *con_secret_len);
> @@ -104,6 +104,8 @@ struct ceph_auth_client {
>  	struct mutex mutex;
>  };
>  
> +void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id);
> +
>  struct ceph_auth_client *ceph_auth_init(const char *name,
>  					const struct ceph_crypto_key *key,
>  					const int *con_modes);
> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> index d07c8cd6cb46..d38c9eadbe2f 100644
> --- a/net/ceph/auth.c
> +++ b/net/ceph/auth.c
> @@ -36,7 +36,7 @@ static int init_protocol(struct ceph_auth_client *ac, int proto)
>  	}
>  }
>  
> -static void set_global_id(struct ceph_auth_client *ac, u64 global_id)
> +void ceph_auth_set_global_id(struct ceph_auth_client *ac, u64 global_id)
>  {
>  	dout("%s global_id %llu\n", __func__, global_id);
>  
> @@ -262,7 +262,7 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>  		goto out;
>  	}
>  
> -	ret = ac->ops->handle_reply(ac, payload, payload_end,
> +	ret = ac->ops->handle_reply(ac, global_id, payload, payload_end,
>  				    NULL, NULL, NULL, NULL);
>  	if (ret == -EAGAIN) {
>  		ret = build_request(ac, true, reply_buf, reply_len);
> @@ -271,8 +271,6 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>  		goto out;
>  	}
>  
> -	set_global_id(ac, global_id);
> -
>  out:
>  	mutex_unlock(&ac->mutex);
>  	return ret;
> @@ -480,7 +478,7 @@ int ceph_auth_handle_reply_more(struct ceph_auth_client *ac, void *reply,
>  	int ret;
>  
>  	mutex_lock(&ac->mutex);
> -	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
> +	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
>  				    NULL, NULL, NULL, NULL);

Won't this trigger a KERN_ERR message? The the handle_reply routines
call ceph_auth_set_global_id unconditionally, which will fire off the
pr_err message and not do anything in this case.

>  	if (ret == -EAGAIN)
>  		ret = build_request(ac, false, buf, buf_len);
> @@ -498,11 +496,10 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
>  	int ret;
>  
>  	mutex_lock(&ac->mutex);
> -	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
> +	ret = ac->ops->handle_reply(ac, global_id, reply, reply + reply_len,
>  				    session_key, session_key_len,
>  				    con_secret, con_secret_len);
> -	if (!ret)
> -		set_global_id(ac, global_id);
> +	WARN_ON(ret == -EAGAIN || ret > 0);
>  	mutex_unlock(&ac->mutex);
>  	return ret;
>  }
> diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
> index 533a2d85dbb9..77b5519bc45f 100644
> --- a/net/ceph/auth_none.c
> +++ b/net/ceph/auth_none.c
> @@ -69,7 +69,7 @@ static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
>   * the generic auth code decode the global_id, and we carry no actual
>   * authenticate state, so nothing happens here.
>   */
> -static int handle_reply(struct ceph_auth_client *ac,
> +static int handle_reply(struct ceph_auth_client *ac, u64 global_id,
>  			void *buf, void *end, u8 *session_key,
>  			int *session_key_len, u8 *con_secret,
>  			int *con_secret_len)
> @@ -77,6 +77,7 @@ static int handle_reply(struct ceph_auth_client *ac,
>  	struct ceph_auth_none_info *xi = ac->private;
>  
>  	xi->starting = false;
> +	ceph_auth_set_global_id(ac, global_id);
>  	return 0;
>  }
>  
> diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
> index cab99c5581b0..b71b1635916e 100644
> --- a/net/ceph/auth_x.c
> +++ b/net/ceph/auth_x.c
> @@ -597,7 +597,7 @@ static int decode_con_secret(void **p, void *end, u8 *con_secret,
>  	return -EINVAL;
>  }
>  
> -static int handle_auth_session_key(struct ceph_auth_client *ac,
> +static int handle_auth_session_key(struct ceph_auth_client *ac, u64 global_id,
>  				   void **p, void *end,
>  				   u8 *session_key, int *session_key_len,
>  				   u8 *con_secret, int *con_secret_len)
> @@ -613,6 +613,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
>  	if (ret)
>  		return ret;
>  
> +	ceph_auth_set_global_id(ac, global_id);
>  	if (*p == end) {
>  		/* pre-nautilus (or didn't request service tickets!) */
>  		WARN_ON(session_key || con_secret);
> @@ -661,7 +662,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
>  	return -EINVAL;
>  }
>  
> -static int ceph_x_handle_reply(struct ceph_auth_client *ac,
> +static int ceph_x_handle_reply(struct ceph_auth_client *ac, u64 global_id,
>  			       void *buf, void *end,
>  			       u8 *session_key, int *session_key_len,
>  			       u8 *con_secret, int *con_secret_len)
> @@ -695,9 +696,9 @@ static int ceph_x_handle_reply(struct ceph_auth_client *ac,
>  	switch (op) {
>  	case CEPHX_GET_AUTH_SESSION_KEY:
>  		/* AUTH ticket + [connection secret] + service tickets */
> -		ret = handle_auth_session_key(ac, &p, end, session_key,
> -					      session_key_len, con_secret,
> -					      con_secret_len);
> +		ret = handle_auth_session_key(ac, global_id, &p, end,
> +					      session_key, session_key_len,
> +					      con_secret, con_secret_len);
>  		break;
>  
>  	case CEPHX_GET_PRINCIPAL_SESSION_KEY:

-- 
Jeff Layton <jlayton@kernel.org>

