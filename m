Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADDF205A16
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jun 2020 20:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbgFWSCp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jun 2020 14:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728916AbgFWSCp (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Jun 2020 14:02:45 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D892D20781;
        Tue, 23 Jun 2020 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592935364;
        bh=s4EP9VDI6YbXr+P4Wy2uuw6kEQgE9UCXsHD+N0cXWlo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cDILlYqLDDj98DGk358rZ9/WZdIQohYrex46N2DPdq0MJYfTL1Dv86t4IbHnPDVZ1
         HjJ0hnEQZaAfV8vIadlY64kMw8tet9LwT02/w6stxVFLw8jaDcfXWXWOK3CtcJLLIA
         07ceJWqLupbrGTSG54rtD1BuoVfoEQoOe9GdKiHY=
Message-ID: <b16bcabfc073815609909c987bc1770ae3bbdc7a.camel@kernel.org>
Subject: Re: [PATCH v3 3/4] ceph: switch to WARN_ON and bubble up errnos to
 the callers
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 23 Jun 2020 14:02:42 -0400
In-Reply-To: <1592832300-29109-4-git-send-email-xiubli@redhat.com>
References: <1592832300-29109-1-git-send-email-xiubli@redhat.com>
         <1592832300-29109-4-git-send-email-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-06-22 at 09:24 -0400, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 46 +++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index f996363..f29cb11 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1168,7 +1168,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>  
>  static const unsigned char feature_bits[] = CEPHFS_FEATURES_CLIENT_SUPPORTED;
>  #define FEATURE_BYTES(c) (DIV_ROUND_UP((size_t)feature_bits[c - 1] + 1, 64) * 8)
> -static void encode_supported_features(void **p, void *end)
> +static int encode_supported_features(void **p, void *end)
>  {
>  	static const size_t count = ARRAY_SIZE(feature_bits);
>  
> @@ -1176,16 +1176,22 @@ static void encode_supported_features(void **p, void *end)
>  		size_t i;
>  		size_t size = FEATURE_BYTES(count);
>  
> -		BUG_ON(*p + 4 + size > end);
> +		if (WARN_ON(*p + 4 + size > end))
> +			return -ERANGE;
> +

Nice cleanup.

Let's use WARN_ON_ONCE instead?

It's better not to spam the logs if this is happening all over the
place. Also, I'm not sure that ERANGE is the right error here, but I
can't think of anything better. At least it should be distinctive.

>  		ceph_encode_32(p, size);
>  		memset(*p, 0, size);
>  		for (i = 0; i < count; i++)
>  			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
>  		*p += size;
>  	} else {
> -		BUG_ON(*p + 4 > end);
> +		if (WARN_ON(*p + 4 > end))
> +			return -ERANGE;
> +
>  		ceph_encode_32(p, 0);
>  	}
> +
> +	return 0;
>  }
>  
>  /*
> @@ -1203,6 +1209,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  	struct ceph_mount_options *fsopt = mdsc->fsc->mount_options;
>  	size_t size, count;
>  	void *p, *end;
> +	int ret;
>  
>  	const char* metadata[][2] = {
>  		{"hostname", mdsc->nodename},
> @@ -1232,7 +1239,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  			   GFP_NOFS, false);
>  	if (!msg) {
>  		pr_err("create_session_msg ENOMEM creating msg\n");
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  	p = msg->front.iov_base;
>  	end = p + msg->front.iov_len;
> @@ -1269,7 +1276,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  		p += val_len;
>  	}
>  
> -	encode_supported_features(&p, end);
> +	ret = encode_supported_features(&p, end);
> +	if (ret) {
> +		pr_err("encode_supported_features failed!\n");
> +		ceph_msg_put(msg);
> +		return ERR_PTR(ret);
> +	}
> +
>  	msg->front.iov_len = p - msg->front.iov_base;
>  	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
>  
> @@ -1297,8 +1310,8 @@ static int __open_session(struct ceph_mds_client *mdsc,
>  
>  	/* send connect message */
>  	msg = create_session_open_msg(mdsc, session->s_seq);
> -	if (!msg)
> -		return -ENOMEM;
> +	if (IS_ERR(msg))
> +		return PTR_ERR(msg);
>  	ceph_con_send(&session->s_con, msg);
>  	return 0;
>  }
> @@ -1312,6 +1325,7 @@ static int __open_session(struct ceph_mds_client *mdsc,
>  __open_export_target_session(struct ceph_mds_client *mdsc, int target)
>  {
>  	struct ceph_mds_session *session;
> +	int ret;
>  
>  	session = __ceph_lookup_mds_session(mdsc, target);
>  	if (!session) {
> @@ -1320,8 +1334,11 @@ static int __open_session(struct ceph_mds_client *mdsc,
>  			return session;
>  	}
>  	if (session->s_state == CEPH_MDS_SESSION_NEW ||
> -	    session->s_state == CEPH_MDS_SESSION_CLOSING)
> -		__open_session(mdsc, session);
> +	    session->s_state == CEPH_MDS_SESSION_CLOSING) {
> +		ret = __open_session(mdsc, session);
> +		if (ret)
> +			return ERR_PTR(ret);
> +	}
>  
>  	return session;
>  }
> @@ -2520,7 +2537,12 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
>  		ceph_encode_copy(&p, &ts, sizeof(ts));
>  	}
>  
> -	BUG_ON(p > end);
> +	if (WARN_ON(p > end)) {
> +		ceph_msg_put(msg);
> +		msg = ERR_PTR(-ERANGE);
> +		goto out_free2;
> +	}
> +
>  	msg->front.iov_len = p - msg->front.iov_base;
>  	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
>  
> @@ -2756,7 +2778,9 @@ static void __do_request(struct ceph_mds_client *mdsc,
>  		}
>  		if (session->s_state == CEPH_MDS_SESSION_NEW ||
>  		    session->s_state == CEPH_MDS_SESSION_CLOSING) {
> -			__open_session(mdsc, session);
> +			err = __open_session(mdsc, session);
> +			if (err)
> +				goto out_session;
>  			/* retry the same mds later */
>  			if (random)
>  				req->r_resend_mds = mds;

-- 
Jeff Layton <jlayton@kernel.org>

