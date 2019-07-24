Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA27335C
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Jul 2019 18:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfGXQHz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 12:07:55 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43033 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfGXQHz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jul 2019 12:07:55 -0400
Received: by mail-yw1-f65.google.com with SMTP id n205so18274580ywb.10
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 09:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=q1XCfdDPIH65Qe6wcJo113bVDsNEjxJDS+H6OACZEpM=;
        b=iM1UteWCUSZSnUnqcLxLWIhXDfgANGqW/t+2ct1JiFVJSnrAQCePi9XU3uhswJ/FKv
         0S5y0aENfLDFb1IFkz1jBIgbuzYHYkBGb65wX1V7xZft2l7Kn5UuDT6nDELrq9kbRsFz
         isIFf6GZLZR5pZ6uVEgY6NXxzxcsFnkL7wQ1hFTclWVncWQ61sCp1rCxBEN2+nCDsIWN
         SCrzyv7sn7R0gIqxbUqXifq4+Blw5spvCp6uwl1KlpZ2Ux3q75cbWPzI7gxQdeE/OYyp
         ra+2Y4Ar4hvigQ/avAGBb9gU40dklfRk5R6L61pxm9BK4LK3fr4i9s2U1yM/Xssr7neM
         9N5Q==
X-Gm-Message-State: APjAAAVqeBOoAloI+BfQx1ZjAXYmOV1PMdl3Q/1hy8d7G4GrE+wWWnBE
        pd08To0IQI9bbxI27I6UGgaClQ==
X-Google-Smtp-Source: APXvYqx9QQ0agc7w7BZd16YTjpHGOCDke101C0V+aQVCL6/42ParwWfwY+X2pjG/DY2JEpyeY55N1A==
X-Received: by 2002:a81:48cc:: with SMTP id v195mr51268866ywa.140.1563984474171;
        Wed, 24 Jul 2019 09:07:54 -0700 (PDT)
Received: from tleilax.poochiereds.net (cpe-2606-A000-1100-37D-0-0-0-62B.dyn6.twc.com. [2606:a000:1100:37d::62b])
        by smtp.gmail.com with ESMTPSA id w193sm5461046ywa.72.2019.07.24.09.07.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 24 Jul 2019 09:07:53 -0700 (PDT)
Message-ID: <6296fabac89a4969726b10ed288af6db9cb2df07.camel@redhat.com>
Subject: Re: [PATCH v2 1/9] libceph: add function that reset client's entity
 addr
From:   Jeff Layton <jlayton@redhat.com>
To:     "Yan, Zheng" <zyan@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
Date:   Wed, 24 Jul 2019 12:07:52 -0400
In-Reply-To: <20190724122120.17438-2-zyan@redhat.com>
References: <20190724122120.17438-1-zyan@redhat.com>
         <20190724122120.17438-2-zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-07-24 at 20:21 +0800, Yan, Zheng wrote:
> This function also re-open connections to OSD/MON, and re-send in-flight
> OSD requests after re-opening connections to OSD.
> 
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
> index 82156da3c650..b9dbda1c26aa 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -293,6 +293,7 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private);
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
> index b4d134d3312a..dbb8a6959a73 100644
> --- a/include/linux/ceph/mon_client.h
> +++ b/include/linux/ceph/mon_client.h
> @@ -109,6 +109,7 @@ extern int ceph_monmap_contains(struct ceph_monmap *m,
>  
>  extern int ceph_monc_init(struct ceph_mon_client *monc, struct ceph_client *cl);
>  extern void ceph_monc_stop(struct ceph_mon_client *monc);
> +extern void ceph_monc_reopen_session(struct ceph_mon_client *monc);
>  
>  enum {
>  	CEPH_SUB_MONMAP = 0,
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index ad7fe5d10dcd..d1c3e829f30d 100644
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
> index 1c811c74bfc0..6676f48d615c 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -694,6 +694,14 @@ void ceph_destroy_client(struct ceph_client *client)
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
> index 0473d9a7b1f4..53b9ca4b72e0 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -3030,6 +3030,11 @@ static void con_fault(struct ceph_connection *con)
>  }
>  
>  
> +void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
> +{
> +	msgr->inst.addr.nonce += 1000000;
> +	encode_my_addr(msgr);
> +}
>  

sparse complains here because nonce is a restricted __le32 value.
Something like this should fix it up:

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 53b9ca4b72e0..fbdc991334bd 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3032,7 +3032,9 @@ static void con_fault(struct ceph_connection *con)
 
 void ceph_messenger_reset_nonce(struct ceph_messenger *msgr)
 {
-       msgr->inst.addr.nonce += 1000000;
+       u32 nonce = le32_to_cpu(msgr->inst.addr.nonce) + 1000000;
+
+       msgr->inst.addr.nonce = cpu_to_le32(nonce);
        encode_my_addr(msgr);
 }


>  /*
>   * initialize a new messenger instance
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 0520bf9825aa..7256c402ebaa 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -213,6 +213,13 @@ static void reopen_session(struct ceph_mon_client *monc)
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
> index 0b2df09b2554..09e1857d033e 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5087,6 +5087,22 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
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

