Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C818C3B7300
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 15:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhF2NPX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 09:15:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233956AbhF2NPW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 09:15:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99F0D61DC2;
        Tue, 29 Jun 2021 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624972370;
        bh=cUzTvMzXE2oxvfuH+fPxH1iB8Eb9RrIR40ROAFMVtX4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ENbAr8r32g8LMrNVuCADyOuLprjf+oO1xKRKc+2qZUk1NXN/oeID31AxGjf4eXM/9
         FiqvaGo5FpWGpdnq8YkQKz1tRz32rcMsWZt7AZ+Ezueb5uSPOb7FZvR+GamLFLoTXJ
         dF03rjNQYGegAZXuMG8F7fbt8ahSYhHLC/CGTIr+iy4b8dM6rZ5YiNdeyS/1DusUa6
         90Bk8/hGmMHZIUQ7DsZpwbZ1Spb0f2Q1wXNKO9nmm+VV8S9rk5/DX9GWFr5aP9k2Gc
         oixzTVRTaxeynWgc8jYX0fO5RyG4M1PNe4kkjHdfKdoT8S+d+A1oEWTFyvV4jbxP3S
         hz71QFRHzYUhA==
Message-ID: <88c1bdbf8235b35671a84f0b0d5feca855017940.camel@kernel.org>
Subject: Re: [PATCH 1/5] ceph: export ceph_create_session_msg
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 29 Jun 2021 09:12:48 -0400
In-Reply-To: <20210629044241.30359-2-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-2-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 

nit: the subject of this patch is not quite right. You aren't exporting
it here, just making it a global symbol (within ceph.ko).
 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 15 ++++++++-------
>  fs/ceph/mds_client.h |  1 +
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2d7dcd295bb9..e49d3e230712 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1150,7 +1150,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
>  /*
>   * session messages
>   */
> -static struct ceph_msg *create_session_msg(u32 op, u64 seq)
> +struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
>  {
>  	struct ceph_msg *msg;
>  	struct ceph_mds_session_head *h;
> @@ -1158,7 +1158,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>  	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
>  			   false);
>  	if (!msg) {
> -		pr_err("create_session_msg ENOMEM creating msg\n");
> +		pr_err("ceph_create_session_msg ENOMEM creating msg\n");

instead of hardcoding the function names in these error messages, use
__func__ instead? That makes it easier to keep up with code changes.

	pr_err("%s ENOMEM creating msg\n", __func__);

>  		return NULL;
>  	}
>  	h = msg->front.iov_base;
> @@ -1289,7 +1289,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
>  			   GFP_NOFS, false);
>  	if (!msg) {
> -		pr_err("create_session_msg ENOMEM creating msg\n");
> +		pr_err("ceph_create_session_msg ENOMEM creating msg\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
>  	p = msg->front.iov_base;
> @@ -1801,8 +1801,8 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
>  
>  	dout("send_renew_caps to mds%d (%s)\n", session->s_mds,
>  		ceph_mds_state_name(state));
> -	msg = create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
> -				 ++session->s_renew_seq);
> +	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
> +				      ++session->s_renew_seq);
>  	if (!msg)
>  		return -ENOMEM;
>  	ceph_con_send(&session->s_con, msg);
> @@ -1816,7 +1816,7 @@ static int send_flushmsg_ack(struct ceph_mds_client *mdsc,
>  
>  	dout("send_flushmsg_ack to mds%d (%s)s seq %lld\n",
>  	     session->s_mds, ceph_session_state_name(session->s_state), seq);
> -	msg = create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
> +	msg = ceph_create_session_msg(CEPH_SESSION_FLUSHMSG_ACK, seq);
>  	if (!msg)
>  		return -ENOMEM;
>  	ceph_con_send(&session->s_con, msg);
> @@ -1868,7 +1868,8 @@ static int request_close_session(struct ceph_mds_session *session)
>  	dout("request_close_session mds%d state %s seq %lld\n",
>  	     session->s_mds, ceph_session_state_name(session->s_state),
>  	     session->s_seq);
> -	msg = create_session_msg(CEPH_SESSION_REQUEST_CLOSE, session->s_seq);
> +	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_CLOSE,
> +				      session->s_seq);
>  	if (!msg)
>  		return -ENOMEM;
>  	ceph_con_send(&session->s_con, msg);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index bf99c5ba47fc..bf2683f0ba43 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -523,6 +523,7 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
>  	kref_put(&req->r_kref, ceph_mdsc_release_request);
>  }
>  
> +extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
>  extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
>  				    struct ceph_cap *cap);
>  extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,

-- 
Jeff Layton <jlayton@kernel.org>

