Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A830E3B7591
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 17:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhF2Pg5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 11:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234669AbhF2Pg4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 11:36:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5AF261CE4;
        Tue, 29 Jun 2021 15:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624980869;
        bh=fvy3vZPoJNM6xwvhT5CxhoToNr59umttiaPzM7KsOdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QBAlKeXTF3Lzv726GSIoHgUK4hIE9MOkbdBRFtM8qer0Do2j4HuxXne30x55VNl3G
         s3yju3wDp2754+O2FdbPx7EZpAmfixrTEkDhQlkymx0SiFKEJj+S6n2Uzslgs58/Lj
         XUANj/YtKy0UvftW7hF+78LlFU8b1dCGTRJZgY53PWKPFhNLxj00rGbLLq8XDZvrLO
         iQoV+kH9+zeL/YsAGTlWB+1PHxVM6ShTd8+fZDCa+ybo8JAoUbwlf8aMx4QvTPvhS0
         wJUrtiSYAhE/+j+I/3Nxq/JTU9tovDri85z/zjGSH3zdYR+jbLAhENM3D+7DBPeIQl
         vqay449+AP0GQ==
Message-ID: <74d612a2a09533fcd184f89e8a1c4d4c0d7354cb.camel@kernel.org>
Subject: Re: [PATCH 3/5] ceph: flush mdlog before umounting
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 29 Jun 2021 11:34:27 -0400
In-Reply-To: <20210629044241.30359-4-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
         <20210629044241.30359-4-xiubli@redhat.com>
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
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         | 29 +++++++++++++++++++++++++++++
>  fs/ceph/mds_client.h         |  1 +
>  include/linux/ceph/ceph_fs.h |  1 +
>  3 files changed, 31 insertions(+)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 96bef289f58f..2db87a5c68d4 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4689,6 +4689,34 @@ static void wait_requests(struct ceph_mds_client *mdsc)
>  	dout("wait_requests done\n");
>  }
>  
> +static void send_flush_mdlog(struct ceph_mds_session *s)
> +{
> +	u64 seq = s->s_seq;
> +	struct ceph_msg *msg;
> +

The s_seq field is protected by the s_mutex (at least, AFAICT). I think
you probably need to take it before fetching the s_seq and release it
after calling ceph_con_send.

Long term, we probably need to rethink how the session sequence number
handling is done. The s_mutex is a terribly heavyweight mechanism for
this.

> +	/*
> +	 * For the MDS daemons lower than Luminous will crash when it
> +	 * saw this unknown session request.
> +	 */
> +	if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
> +		return;
> +
> +	dout("send_flush_mdlog to mds%d (%s)s seq %lld\n",
> +	     s->s_mds, ceph_session_state_name(s->s_state), seq);
> +	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG, seq);
> +	if (!msg) {
> +		pr_err("failed to send_flush_mdlog to mds%d (%s)s seq %lld\n",
> +		       s->s_mds, ceph_session_state_name(s->s_state), seq);
> +	} else {
> +		ceph_con_send(&s->s_con, msg);
> +	}
> +}
> +
> +void flush_mdlog(struct ceph_mds_client *mdsc)
> +{
> +	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
> +}
> +
>  /*
>   * called before mount is ro, and before dentries are torn down.
>   * (hmm, does this still race with new lookups?)
> @@ -4698,6 +4726,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>  	dout("pre_umount\n");
>  	mdsc->stopping = 1;
>  
> +	flush_mdlog(mdsc);
>  	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>  	ceph_flush_dirty_caps(mdsc);
>  	wait_requests(mdsc);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index fca2cf427eaf..79d5b8ed62bf 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -537,6 +537,7 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>  				     int (*cb)(struct inode *,
>  					       struct ceph_cap *, void *),
>  				     void *arg);
> +extern void flush_mdlog(struct ceph_mds_client *mdsc);
>  extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>  
>  static inline void ceph_mdsc_free_path(char *path, int len)
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 57e5bd63fb7a..ae60696fe40b 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -300,6 +300,7 @@ enum {
>  	CEPH_SESSION_FLUSHMSG_ACK,
>  	CEPH_SESSION_FORCE_RO,
>  	CEPH_SESSION_REJECT,
> +	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
>  };
>  
>  extern const char *ceph_session_op_name(int op);

-- 
Jeff Layton <jlayton@kernel.org>

