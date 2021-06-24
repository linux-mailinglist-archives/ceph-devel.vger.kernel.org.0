Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D233B341E
	for <lists+ceph-devel@lfdr.de>; Thu, 24 Jun 2021 18:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhFXQqn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 24 Jun 2021 12:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229721AbhFXQqn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 24 Jun 2021 12:46:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75E2C613CA;
        Thu, 24 Jun 2021 16:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624553063;
        bh=mq2J/4ZeoAqTtf6WOVk9Y1k5UiMiDZ1NnBttvnXQHaw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sQNxKEpcGx65clIQjSX6rPeK4oS/8o3bIKcJ6Ey2+1MZmFJaQYSsZNf0m06bBXDeS
         RgLL3oyfHVNwcFRsl8bMrHghdCapwaj4O7yLeNPC85QNL9gZSp3nipqQ8Xu2F86p37
         Syl1q/zyWFcTxF/1DH0TVt0bG/3XpvTyRNDIYkCaC2qT02zIKF+ehrv3qMZMqPjgOy
         aIG8QYB55P7G774yCZtDqeC93eKAi+Z1NltpHeI2p7itTSgUT1MFFtoR0A2wGJvgm8
         +uJDtAC3aSVDRZVg082c3BOcHhvGlcohTmH46AiolRhJzVu1YBOf7+o0McwFbR/850
         R6/mPAVJJRTvQ==
Message-ID: <3e3678dd62568c192f91271c261dc5e9c1d78103.camel@kernel.org>
Subject: Re: [PATCH] libceph: don't pass result into ac->ops->handle_reply()
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Sage Weil <sage@redhat.com>
Date:   Thu, 24 Jun 2021 12:44:22 -0400
In-Reply-To: <20210623151247.18734-1-idryomov@gmail.com>
References: <20210623151247.18734-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-06-23 at 17:12 +0200, Ilya Dryomov wrote:
> There is no result to pass in msgr2 case because authentication
> failures are reported through auth_bad_method frame and in MAuth
> case an error is returned immediately.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  include/linux/ceph/auth.h |  2 +-
>  net/ceph/auth.c           | 15 ++++++++++-----
>  net/ceph/auth_none.c      |  4 ++--
>  net/ceph/auth_x.c         |  6 ++----
>  4 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
> index 71b5d481c653..39425e2f7cb2 100644
> --- a/include/linux/ceph/auth.h
> +++ b/include/linux/ceph/auth.h
> @@ -50,7 +50,7 @@ struct ceph_auth_client_ops {
>  	 * another request.
>  	 */
>  	int (*build_request)(struct ceph_auth_client *ac, void *buf, void *end);
> -	int (*handle_reply)(struct ceph_auth_client *ac, int result,
> +	int (*handle_reply)(struct ceph_auth_client *ac,
>  			    void *buf, void *end, u8 *session_key,
>  			    int *session_key_len, u8 *con_secret,
>  			    int *con_secret_len);
> diff --git a/net/ceph/auth.c b/net/ceph/auth.c
> index b824a48a4c47..d07c8cd6cb46 100644
> --- a/net/ceph/auth.c
> +++ b/net/ceph/auth.c
> @@ -255,14 +255,19 @@ int ceph_handle_auth_reply(struct ceph_auth_client *ac,
>  		ac->negotiating = false;
>  	}
>  
> -	ret = ac->ops->handle_reply(ac, result, payload, payload_end,
> +	if (result) {
> +		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
> +		       ceph_auth_proto_name(ac->protocol), result);
> +		ret = result;
> +		goto out;
> +	}
> +
> +	ret = ac->ops->handle_reply(ac, payload, payload_end,
>  				    NULL, NULL, NULL, NULL);
>  	if (ret == -EAGAIN) {
>  		ret = build_request(ac, true, reply_buf, reply_len);
>  		goto out;
>  	} else if (ret) {
> -		pr_err("auth protocol '%s' mauth authentication failed: %d\n",
> -		       ceph_auth_proto_name(ac->protocol), result);
>  		goto out;
>  	}
>  
> @@ -475,7 +480,7 @@ int ceph_auth_handle_reply_more(struct ceph_auth_client *ac, void *reply,
>  	int ret;
>  
>  	mutex_lock(&ac->mutex);
> -	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
> +	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
>  				    NULL, NULL, NULL, NULL);
>  	if (ret == -EAGAIN)
>  		ret = build_request(ac, false, buf, buf_len);
> @@ -493,7 +498,7 @@ int ceph_auth_handle_reply_done(struct ceph_auth_client *ac,
>  	int ret;
>  
>  	mutex_lock(&ac->mutex);
> -	ret = ac->ops->handle_reply(ac, 0, reply, reply + reply_len,
> +	ret = ac->ops->handle_reply(ac, reply, reply + reply_len,
>  				    session_key, session_key_len,
>  				    con_secret, con_secret_len);
>  	if (!ret)
> diff --git a/net/ceph/auth_none.c b/net/ceph/auth_none.c
> index dbf22df10a85..533a2d85dbb9 100644
> --- a/net/ceph/auth_none.c
> +++ b/net/ceph/auth_none.c
> @@ -69,7 +69,7 @@ static int build_request(struct ceph_auth_client *ac, void *buf, void *end)
>   * the generic auth code decode the global_id, and we carry no actual
>   * authenticate state, so nothing happens here.
>   */
> -static int handle_reply(struct ceph_auth_client *ac, int result,
> +static int handle_reply(struct ceph_auth_client *ac,
>  			void *buf, void *end, u8 *session_key,
>  			int *session_key_len, u8 *con_secret,
>  			int *con_secret_len)
> @@ -77,7 +77,7 @@ static int handle_reply(struct ceph_auth_client *ac, int result,
>  	struct ceph_auth_none_info *xi = ac->private;
>  
>  	xi->starting = false;
> -	return result;
> +	return 0;
>  }
>  
>  static void ceph_auth_none_destroy_authorizer(struct ceph_authorizer *a)
> diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
> index 79641c4afee9..cab99c5581b0 100644
> --- a/net/ceph/auth_x.c
> +++ b/net/ceph/auth_x.c
> @@ -661,7 +661,7 @@ static int handle_auth_session_key(struct ceph_auth_client *ac,
>  	return -EINVAL;
>  }
>  
> -static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
> +static int ceph_x_handle_reply(struct ceph_auth_client *ac,
>  			       void *buf, void *end,
>  			       u8 *session_key, int *session_key_len,
>  			       u8 *con_secret, int *con_secret_len)
> @@ -669,13 +669,11 @@ static int ceph_x_handle_reply(struct ceph_auth_client *ac, int result,
>  	struct ceph_x_info *xi = ac->private;
>  	struct ceph_x_ticket_handler *th;
>  	int len = end - buf;
> +	int result;
>  	void *p;
>  	int op;
>  	int ret;
>  
> -	if (result)
> -		return result;  /* XXX hmm? */
> -
>  	if (xi->starting) {
>  		/* it's a hello */
>  		struct ceph_x_server_challenge *sc = buf;

Nice cleanup.

Reviewed-by: Jeff Layton <jlayton@kernel.org>

