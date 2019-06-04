Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13734500
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 13:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfFDLBV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 07:01:21 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33538 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbfFDLBU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 07:01:20 -0400
Received: by mail-yb1-f196.google.com with SMTP id w127so7798017yba.0
        for <ceph-devel@vger.kernel.org>; Tue, 04 Jun 2019 04:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=NkE8E+xWRdFZxUxcr2xAhhtX7Fdp/tIM+EHrq1k/AK8=;
        b=S0ONEDKxXdQSeP6bmyLyUzddOOlfiPo58KKiipfwKOmCEa3+pZ5uyhUiuWltOU9ZAi
         PX4NuWT7kYEjW0XYM0TNmzopDJPMw7iZgPmuGbfqtNl5WeFF9BEGwyXXzGJqvLLZB3sG
         ytFKXoqYsHn2ePgP0QZrlIGZss1ldi+KcNw9FGB4eU1F0BQOAADJZ/qXK4kufWr61Bjk
         7Hyh8qk5Qe+dJpDCwzzu3WbHbXQw/2Q5wQqPgRGHzKCS2+z2bOoQCG61lnlLE18yxeWG
         ATFIHEN/jrDGgFwGuSXwu95YeuhouVY4c0mBXBBmLq5TrApKRNomIfUeLSHZ7uLCwrEa
         sDWQ==
X-Gm-Message-State: APjAAAUX9BWpK1JWGkpC67MK/JPeLxFyiI+wRspU8ENFCDERiEstj/nm
        2xuttcPlD7EOyj10dHyx7aFn3Q==
X-Google-Smtp-Source: APXvYqwJPCwupsz3fnPHiVAeXHYgbfWSPgoBCNIeTATZ9DLFoMEDVQz20O//+8KrpN0WPk/KIDROdA==
X-Received: by 2002:a25:2f4e:: with SMTP id v75mr14846557ybv.470.1559646079971;
        Tue, 04 Jun 2019 04:01:19 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-2AF.dyn6.twc.com. [2606:a000:1100:37d::2af])
        by smtp.gmail.com with ESMTPSA id 205sm4398430ywu.84.2019.06.04.04.01.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 04 Jun 2019 04:01:18 -0700 (PDT)
Message-ID: <b8e91fb1b19c36bd8493e316b60a2313b044ee8a.camel@redhat.com>
Subject: Re: [PATCH 1/4] libceph: add function that reset client's entity
 addr
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Tue, 04 Jun 2019 07:01:17 -0400
In-Reply-To: <20190604093908.30491-1-zyan@redhat.com>
References: <20190604093908.30491-1-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-04 at 17:39 +0800, Yan, Zheng wrote:
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

I'd like to better understand what happens to file descriptors that were
opened before the blacklisting occurred.

Suppose I hold a POSIX lock on a O_RDWR fd, and then get blacklisted.
The admin then remounts the mount. What happens to my fd? Can I carry on
using it, or will it be shut down in some fashion? What about the lock?
I've definitely lost it during the blacklisting -- how do we make the
application aware of that fact?

I wonder if we would to resurrect the revoke/frevoke work to make this
safe, so that we could revoke any open fds when blacklisting occurs.
-- 
Jeff Layton <jlayton@redhat.com>

