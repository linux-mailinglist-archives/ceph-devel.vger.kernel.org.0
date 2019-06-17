Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFB9489F2
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 19:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbfFQRVY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 13:21:24 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45813 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQRVY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jun 2019 13:21:24 -0400
Received: by mail-yb1-f193.google.com with SMTP id v104so4758843ybi.12
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 10:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8/kc+J1GVu1rKV/sK6E5USDRzvkE6GI4uIJua1FJaSI=;
        b=KMfMcinoklN8xsXSByOgjy0DDZNRxL3yJaxmXvcY7d7NzS1HtjBJpQcjmaju3fkORl
         J4HRpXPEqPeoooo+aYledr1gKLmY3Zn/CfyNjqDN0HltMh5EVHbtTYnDtsMX7uOo5X8m
         rG5rVgW9NlhFrLEoln1ai2JE+h/LtBdqMWtbbm1AJSF8vL5Qts7XEoApDQk+94dt/NWJ
         TvcsQ86X07rmzRGNJGhXnK2AB9O/PEmrIe3eYUfTKUDOhvVA3PfxxvCCMt9C55fAU3C/
         vGQWjjRHCuPLsgTNv2IP2GlMwQp3oWSJ8fIHllcwbA4gMg1zppuDHLRUMiWlLQTkHOR2
         SI7Q==
X-Gm-Message-State: APjAAAXEjlzHdvWyd4dNxigBhxNfhF0973jXeq3J5qsB+BXnmV9ZZxq7
        9zW+qPyxp/DdPLvpZcclhmx7eCZyW+s=
X-Google-Smtp-Source: APXvYqweQWKaxOiKkajOaumlg/vYcsFDtNqKzUFil5fRPtS4dFDBCy5uAJGgzEDhXr5BEEHIKf97Tw==
X-Received: by 2002:a25:7712:: with SMTP id s18mr15797117ybc.134.1560792080478;
        Mon, 17 Jun 2019 10:21:20 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-8C7.dyn6.twc.com. [2606:a000:1100:37d::8c7])
        by smtp.gmail.com with ESMTPSA id v192sm3593081ywv.40.2019.06.17.10.21.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 17 Jun 2019 10:21:19 -0700 (PDT)
Message-ID: <956c1db29cb1c1c1a0bfb87e6d8e6b846abe0b0d.camel@redhat.com>
Subject: Re: [PATCH 1/8] libceph: add function that reset client's entity
 addr
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Mon, 17 Jun 2019 13:21:18 -0400
In-Reply-To: <20190617125529.6230-2-zyan@redhat.com>
References: <20190617125529.6230-1-zyan@redhat.com>
         <20190617125529.6230-2-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  include/linux/ceph/libceph.h    |  1 +
>  include/linux/ceph/messenger.h  |  1 +
>  include/linux/ceph/mon_client.h |  1 +
>  include/linux/ceph/osd_client.h |  1 +
>  net/ceph/ceph_common.c          |  8 ++++++++
>  net/ceph/messenger.c            |  5 +++++
>  net/ceph/mon_client.c           |  7 +++++++
>  net/ceph/osd_client.c           | 16 ++++++++++++++++
>  8 files changed, 40 insertions(+)
> 
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index a3cddf5f0e60..f29959eed025 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -291,6 +291,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
>  struct ceph_entity_addr *ceph_client_addr(struct ceph_client *client);
>  u64 ceph_client_gid(struct ceph_client *client);
>  extern void ceph_destroy_client(struct ceph_client *client);
> +extern void ceph_reset_client_addr(struct ceph_client *client);
>  extern int __ceph_open_session(struct ceph_client *client,
>  			       unsigned long started);
>  extern int ceph_open_session(struct ceph_client *client);
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index 23895d178149..c4458dc6a757 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -337,6 +337,7 @@ extern void ceph_msgr_flush(void);
>  extern void ceph_messenger_init(struct ceph_messenger *msgr,
>  				struct ceph_entity_addr *myaddr);
>  extern void ceph_messenger_fini(struct ceph_messenger *msgr);
> +extern void ceph_messenger_reset_nonce(struct ceph_messenger *msgr);
>  
>  extern void ceph_con_init(struct ceph_connection *con, void *private,
>  			const struct ceph_connection_operations *ops,
> diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
> index 3a4688af7455..0d8d890c6759 100644
> --- a/include/linux/ceph/mon_client.h
> +++ b/include/linux/ceph/mon_client.h
> @@ -110,6 +110,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
>  
>  extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
>  extern void ceph_monc_stop(struct ceph_mon_client *monc);
> +extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
>  
>  enum {
>  	CEPH_SUB_MONMAP = 0,
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 2294f963dab7..a12b7fc9cfd6 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -381,6 +381,7 @@ extern void ceph_osdc_cleanup(void);
>  extern int ceph_osdc_init(struct ceph_osd_client *osdc,
>  			  struct ceph_client *client);
>  extern void ceph_osdc_stop(struct ceph_osd_client *osdc);
> +extern void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc);
>  
>  extern void ceph_osdc_handle_reply(struct ceph_osd_client *osdc,
>  				   struct ceph_msg *msg);
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 79eac465ec65..55210823d1cc 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -693,6 +693,14 @@ void ceph_destroy_client(struct ceph_client *client)
>  }
>  EXPORT_SYMBOL(ceph_destroy_client);
>  
> +void ceph_reset_client_addr(struct ceph_client *client)
> +{
> +	ceph_messenger_reset_nonce(&client->msgr);
> +	ceph_monc_reopen_session(&client->monc);
> +	ceph_osdc_reopen_osds(&client->osdc);
> +}
> +EXPORT_SYMBOL(ceph_reset_client_addr);
> +
>  /*
>   * true if we have the mon map (and have thus joined the cluster)
>   */
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 3ee380758ddd..cd03a1cba849 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -3028,6 +3028,11 @@ static void con_fault(struct ceph_connection *con)
>  }
>  
>  
> +void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
> +{
> +	msgr->inst.addr.nonce += 1000000;

Why 1000000 here? This is originally set by get_random_bytes, AFAICT.
Should we be calling that again instead?

> +	encode_my_addr(msgr);
> +}
>  
>  /*
>   * initialize a new messenger instance
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 895679d3529b..6dab6a94e9cc 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -209,6 +209,13 @@ static void reopen_session(struct ceph_mon_client *monc)
>  	__open_session(monc);
>  }
>  
> +void ceph_monc_reopen_session(struct ceph_mon_client *monc)
> +{
> +	mutex_lock(&monc->mutex);
> +	reopen_session(monc);
> +	mutex_unlock(&monc->mutex);
> +}
> +
>  static void un_backoff(struct ceph_mon_client *monc)
>  {
>  	monc->hunt_mult /= 2; /* reduce by 50% */
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index e6d31e0f0289..67e9466f27fd 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5089,6 +5089,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  }
>  EXPORT_SYMBOL(ceph_osdc_call);
>  
> +/*
> + * reset all osd connections
> + */
> +void ceph_osdc_reopen_osds(struct ceph_osd_client *osdc)
> +{
> +	struct rb_node *n;
> +	down_write(&osdc->lock);
> +	for (n = rb_first(&osdc->osds); n; ) {
> +		struct ceph_osd *osd = rb_entry(n, struct ceph_osd, o_node);
> +		n = rb_next(n);
> +		if (!reopen_osd(osd))
> +			kick_osd_requests(osd);
> +	}
> +	up_write(&osdc->lock);
> +}
> +
>  /*
>   * init, shutdown
>   */

-- 
Jeff Layton <jlayton@redhat.com>

