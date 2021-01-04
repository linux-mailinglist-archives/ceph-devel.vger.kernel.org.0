Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E702E958C
	for <lists+ceph-devel@lfdr.de>; Mon,  4 Jan 2021 14:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhADNFp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 4 Jan 2021 08:05:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbhADNFo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 08:05:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F9BB21D93;
        Mon,  4 Jan 2021 13:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609765503;
        bh=YLx4HhP2yRUvwxkbhWC/iDZk1L832tv1wN6LtxhTFFw=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=jyR2xsJAYHG2zzbR2cmE1LsC3PSMwwfUKTzbDKyrlorib3ilhmci0p1XWOyo87Qum
         4PcsXISQlk9ZyNJeoIrk+P+1zaRy7UnZ/g6PEwJtjGeD7CEt9fuesHH5F+Q722cSwm
         WMZX9DiKv5srkUivaN7LrmxtdKwkAFCAKhC4eQfm+gux9YIRpVv+7EAXrDh3qCBlni
         d4AGvmq2dxPzjpyuKdaMbr1Ci3y6ccefgCvsfl8rBWbdYFq+beJdKIk6prwIoM/lnP
         Fz9HGrc4zh5ZK2lTkn3JSK5LSwP04+H/yVh5b0olTkmLL6/P22OCMETbZp1QKcaKgY
         ZqLc/MfMh1aIw==
Message-ID: <f2021da0e7592c7eb39f62b8f4a7a9fac19daddc.camel@kernel.org>
Subject: Re: [PATCH] libceph: disambiguate ceph_connection_operations
 handlers
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Mon, 04 Jan 2021 08:05:01 -0500
In-Reply-To: <20201230173157.2556-1-idryomov@gmail.com>
References: <20201230173157.2556-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-12-30 at 18:31 +0100, Ilya Dryomov wrote:
> Since a few years, kernel addresses are no longer included in oops
> dumps, at least on x86.  All we get is a symbol name with offset and
> size.
> 
> This is a problem for ceph_connection_operations handlers, especially
> con->ops->dispatch().  All three handlers have the same name and there
> is little context to disambiguate between e.g. monitor and OSD clients
> because almost everything is inlined.  gdb sneakily stops at the first
> matching symbol, so one has to resort to nm and addr2line.
> 
> Some of these are already prefixed with mon_, osd_ or mds_.  Let's do
> the same for all others.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/ceph/mds_client.c  | 34 +++++++++++++++++-----------------
>  net/ceph/mon_client.c | 14 +++++++-------
>  net/ceph/osd_client.c | 40 ++++++++++++++++++++--------------------
>  3 files changed, 44 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 840587037b59..d87bd852ed96 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -5038,7 +5038,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
>  	return;
>  }
>  
> 
> -static struct ceph_connection *con_get(struct ceph_connection *con)
> +static struct ceph_connection *mds_get_con(struct ceph_connection *con)
>  {
>  	struct ceph_mds_session *s = con->private;
>  
> 
> @@ -5047,7 +5047,7 @@ static struct ceph_connection *con_get(struct ceph_connection *con)
>  	return NULL;
>  }
>  
> 
> -static void con_put(struct ceph_connection *con)
> +static void mds_put_con(struct ceph_connection *con)
>  {
>  	struct ceph_mds_session *s = con->private;
>  
> 
> @@ -5058,7 +5058,7 @@ static void con_put(struct ceph_connection *con)
>   * if the client is unresponsive for long enough, the mds will kill
>   * the session entirely.
>   */
> -static void peer_reset(struct ceph_connection *con)
> +static void mds_peer_reset(struct ceph_connection *con)
>  {
>  	struct ceph_mds_session *s = con->private;
>  	struct ceph_mds_client *mdsc = s->s_mdsc;
> @@ -5067,7 +5067,7 @@ static void peer_reset(struct ceph_connection *con)
>  	send_mds_reconnect(mdsc, s);
>  }
>  
> 
> -static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> +static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  {
>  	struct ceph_mds_session *s = con->private;
>  	struct ceph_mds_client *mdsc = s->s_mdsc;
> @@ -5125,8 +5125,8 @@ static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>   * Note: returned pointer is the address of a structure that's
>   * managed separately.  Caller must *not* attempt to free it.
>   */
> -static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
> -					int *proto, int force_new)
> +static struct ceph_auth_handshake *
> +mds_get_authorizer(struct ceph_connection *con, int *proto, int force_new)
>  {
>  	struct ceph_mds_session *s = con->private;
>  	struct ceph_mds_client *mdsc = s->s_mdsc;
> @@ -5142,7 +5142,7 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
>  	return auth;
>  }
>  
> 
> -static int add_authorizer_challenge(struct ceph_connection *con,
> +static int mds_add_authorizer_challenge(struct ceph_connection *con,
>  				    void *challenge_buf, int challenge_buf_len)
>  {
>  	struct ceph_mds_session *s = con->private;
> @@ -5153,7 +5153,7 @@ static int add_authorizer_challenge(struct ceph_connection *con,
>  					    challenge_buf, challenge_buf_len);
>  }
>  
> 
> -static int verify_authorizer_reply(struct ceph_connection *con)
> +static int mds_verify_authorizer_reply(struct ceph_connection *con)
>  {
>  	struct ceph_mds_session *s = con->private;
>  	struct ceph_mds_client *mdsc = s->s_mdsc;
> @@ -5165,7 +5165,7 @@ static int verify_authorizer_reply(struct ceph_connection *con)
>  		NULL, NULL, NULL, NULL);
>  }
>  
> 
> -static int invalidate_authorizer(struct ceph_connection *con)
> +static int mds_invalidate_authorizer(struct ceph_connection *con)
>  {
>  	struct ceph_mds_session *s = con->private;
>  	struct ceph_mds_client *mdsc = s->s_mdsc;
> @@ -5288,15 +5288,15 @@ static int mds_check_message_signature(struct ceph_msg *msg)
>  }
>  
> 
>  static const struct ceph_connection_operations mds_con_ops = {
> -	.get = con_get,
> -	.put = con_put,
> -	.dispatch = dispatch,
> -	.get_authorizer = get_authorizer,
> -	.add_authorizer_challenge = add_authorizer_challenge,
> -	.verify_authorizer_reply = verify_authorizer_reply,
> -	.invalidate_authorizer = invalidate_authorizer,
> -	.peer_reset = peer_reset,
> +	.get = mds_get_con,
> +	.put = mds_put_con,
>  	.alloc_msg = mds_alloc_msg,
> +	.dispatch = mds_dispatch,
> +	.peer_reset = mds_peer_reset,
> +	.get_authorizer = mds_get_authorizer,
> +	.add_authorizer_challenge = mds_add_authorizer_challenge,
> +	.verify_authorizer_reply = mds_verify_authorizer_reply,
> +	.invalidate_authorizer = mds_invalidate_authorizer,
>  	.sign_message = mds_sign_message,
>  	.check_message_signature = mds_check_message_signature,
>  	.get_auth_request = mds_get_auth_request,
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index b9d54ed9f338..195ceb8afb06 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1433,7 +1433,7 @@ static int mon_handle_auth_bad_method(struct ceph_connection *con,
>  /*
>   * handle incoming message
>   */
> -static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> +static void mon_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  {
>  	struct ceph_mon_client *monc = con->private;
>  	int type = le16_to_cpu(msg->hdr.type);
> @@ -1565,21 +1565,21 @@ static void mon_fault(struct ceph_connection *con)
>   * will come from the messenger workqueue, which is drained prior to
>   * mon_client destruction.
>   */
> -static struct ceph_connection *con_get(struct ceph_connection *con)
> +static struct ceph_connection *mon_get_con(struct ceph_connection *con)
>  {
>  	return con;
>  }
>  
> 
> -static void con_put(struct ceph_connection *con)
> +static void mon_put_con(struct ceph_connection *con)
>  {
>  }
>  
> 
>  static const struct ceph_connection_operations mon_con_ops = {
> -	.get = con_get,
> -	.put = con_put,
> -	.dispatch = dispatch,
> -	.fault = mon_fault,
> +	.get = mon_get_con,
> +	.put = mon_put_con,
>  	.alloc_msg = mon_alloc_msg,
> +	.dispatch = mon_dispatch,
> +	.fault = mon_fault,
>  	.get_auth_request = mon_get_auth_request,
>  	.handle_auth_reply_more = mon_handle_auth_reply_more,
>  	.handle_auth_done = mon_handle_auth_done,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index bd2a994bf0f1..6bf7c981874c 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5468,7 +5468,7 @@ void ceph_osdc_cleanup(void)
>  /*
>   * handle incoming message
>   */
> -static void dispatch(struct ceph_connection *con, struct ceph_msg *msg)
> +static void osd_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
>  {
>  	struct ceph_osd *osd = con->private;
>  	struct ceph_osd_client *osdc = osd->o_osdc;
> @@ -5590,9 +5590,9 @@ static struct ceph_msg *alloc_msg_with_page_vector(struct ceph_msg_header *hdr)
>  	return m;
>  }
>  
> 
> -static struct ceph_msg *alloc_msg(struct ceph_connection *con,
> -				  struct ceph_msg_header *hdr,
> -				  int *skip)
> +static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
> +				      struct ceph_msg_header *hdr,
> +				      int *skip)
>  {
>  	struct ceph_osd *osd = con->private;
>  	int type = le16_to_cpu(hdr->type);
> @@ -5616,7 +5616,7 @@ static struct ceph_msg *alloc_msg(struct ceph_connection *con,
>  /*
>   * Wrappers to refcount containing ceph_osd struct
>   */
> -static struct ceph_connection *get_osd_con(struct ceph_connection *con)
> +static struct ceph_connection *osd_get_con(struct ceph_connection *con)
>  {
>  	struct ceph_osd *osd = con->private;
>  	if (get_osd(osd))
> @@ -5624,7 +5624,7 @@ static struct ceph_connection *get_osd_con(struct ceph_connection *con)
>  	return NULL;
>  }
>  
> 
> -static void put_osd_con(struct ceph_connection *con)
> +static void osd_put_con(struct ceph_connection *con)
>  {
>  	struct ceph_osd *osd = con->private;
>  	put_osd(osd);
> @@ -5638,8 +5638,8 @@ static void put_osd_con(struct ceph_connection *con)
>   * Note: returned pointer is the address of a structure that's
>   * managed separately.  Caller must *not* attempt to free it.
>   */
> -static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
> -					int *proto, int force_new)
> +static struct ceph_auth_handshake *
> +osd_get_authorizer(struct ceph_connection *con, int *proto, int force_new)
>  {
>  	struct ceph_osd *o = con->private;
>  	struct ceph_osd_client *osdc = o->o_osdc;
> @@ -5655,7 +5655,7 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
>  	return auth;
>  }
>  
> 
> -static int add_authorizer_challenge(struct ceph_connection *con,
> +static int osd_add_authorizer_challenge(struct ceph_connection *con,
>  				    void *challenge_buf, int challenge_buf_len)
>  {
>  	struct ceph_osd *o = con->private;
> @@ -5666,7 +5666,7 @@ static int add_authorizer_challenge(struct ceph_connection *con,
>  					    challenge_buf, challenge_buf_len);
>  }
>  
> 
> -static int verify_authorizer_reply(struct ceph_connection *con)
> +static int osd_verify_authorizer_reply(struct ceph_connection *con)
>  {
>  	struct ceph_osd *o = con->private;
>  	struct ceph_osd_client *osdc = o->o_osdc;
> @@ -5678,7 +5678,7 @@ static int verify_authorizer_reply(struct ceph_connection *con)
>  		NULL, NULL, NULL, NULL);
>  }
>  
> 
> -static int invalidate_authorizer(struct ceph_connection *con)
> +static int osd_invalidate_authorizer(struct ceph_connection *con)
>  {
>  	struct ceph_osd *o = con->private;
>  	struct ceph_osd_client *osdc = o->o_osdc;
> @@ -5787,18 +5787,18 @@ static int osd_check_message_signature(struct ceph_msg *msg)
>  }
>  
> 
>  static const struct ceph_connection_operations osd_con_ops = {
> -	.get = get_osd_con,
> -	.put = put_osd_con,
> -	.dispatch = dispatch,
> -	.get_authorizer = get_authorizer,
> -	.add_authorizer_challenge = add_authorizer_challenge,
> -	.verify_authorizer_reply = verify_authorizer_reply,
> -	.invalidate_authorizer = invalidate_authorizer,
> -	.alloc_msg = alloc_msg,
> +	.get = osd_get_con,
> +	.put = osd_put_con,
> +	.alloc_msg = osd_alloc_msg,
> +	.dispatch = osd_dispatch,
> +	.fault = osd_fault,
>  	.reencode_message = osd_reencode_message,
> +	.get_authorizer = osd_get_authorizer,
> +	.add_authorizer_challenge = osd_add_authorizer_challenge,
> +	.verify_authorizer_reply = osd_verify_authorizer_reply,
> +	.invalidate_authorizer = osd_invalidate_authorizer,
>  	.sign_message = osd_sign_message,
>  	.check_message_signature = osd_check_message_signature,
> -	.fault = osd_fault,
>  	.get_auth_request = osd_get_auth_request,
>  	.handle_auth_reply_more = osd_handle_auth_reply_more,
>  	.handle_auth_done = osd_handle_auth_done,

I like distinct names.

Acked-by: Jeff Layton <jlayton@kernel.org>

