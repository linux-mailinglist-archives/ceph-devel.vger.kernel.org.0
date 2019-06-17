Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194394887A
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 18:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfFQQOR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 12:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFQQOR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 12:14:17 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 004D8208E4;
        Mon, 17 Jun 2019 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560788056;
        bh=n5GqyTDHdRl1Gj/lxJ4hIDIcQBkb9v5/eBJVlA3vW7I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nQKhyQkTi8H0xMertjHcOfVUQPkLuv7jx2EUN58P4VMrIhIOIBks3tPB89+H15Kui
         E2fNRyXG5NaekvWt1n4CrravDapBGZhjPNFhfJMdpUELBDiSwnb+dGxzQEyZkCKw0e
         I8yLgd661+FglCr7c7uOR7nYS0jlit0vUmV0B3W8=
Message-ID: <a44fac7a098955eb0149eb084041f60fdb05c30f.camel@kernel.org>
Subject: Re: [PATCH v2 09/18] libceph: use TYPE_LEGACY for entity addrs
 instead of TYPE_NONE
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Date:   Mon, 17 Jun 2019 12:14:14 -0400
In-Reply-To: <20190617153753.3611-10-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
         <20190617153753.3611-10-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-06-17 at 11:37 -0400, Jeff Layton wrote:
> Going forward, we'll have different address types so let's use
> the addr2 TYPE_LEGACY for internal tracking rather than TYPE_NONE.
> 
> Also, make ceph_pr_addr print the address type value as well.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/decode.h |  7 +++++++
>  net/ceph/decode.c           | 20 ++++++++------------
>  net/ceph/messenger.c        |  7 +++++--
>  3 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
> index 1c0a665bfc03..ce488d95be89 100644
> --- a/include/linux/ceph/decode.h
> +++ b/include/linux/ceph/decode.h
> @@ -218,16 +218,23 @@ static inline void ceph_encode_timespec64(struct ceph_timespec *tv,
>  /*
>   * sockaddr_storage <-> ceph_sockaddr
>   */
> +#define CEPH_ENTITY_ADDR_TYPE_NONE	0
> +#define CEPH_ENTITY_ADDR_TYPE_LEGACY	__cpu_to_le32(1)
> +
>  static inline void ceph_encode_addr(struct ceph_entity_addr *a)
>  {
>  	__be16 ss_family = htons(a->in_addr.ss_family);
>  	a->in_addr.ss_family = *(__u16 *)&ss_family;
> +
> +	/* Banner addresses require TYPE_NONE */
> +	a->type = CEPH_ENTITY_ADDR_TYPE_NONE;
>  }
>  static inline void ceph_decode_addr(struct ceph_entity_addr *a)
>  {
>  	__be16 ss_family = *(__be16 *)&a->in_addr.ss_family;
>  	a->in_addr.ss_family = ntohs(ss_family);
>  	WARN_ON(a->in_addr.ss_family == 512);
> +	a->type = CEPH_ENTITY_ADDR_TYPE_LEGACY;
>  }
>  
>  extern int ceph_decode_entity_addr(void **p, void *end,
> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> index b82981199549..cbfc48614c87 100644
> --- a/net/ceph/decode.c
> +++ b/net/ceph/decode.c
> @@ -21,17 +21,6 @@ ceph_decode_entity_addr_versioned(void **p, void *end,
>  
>  	ceph_decode_copy_safe(p, end, &addr->type, sizeof(addr->type), bad);
>  
> -	/*
> -	 * TYPE_NONE == 0
> -	 * TYPE_LEGACY == 1
> -	 *
> -	 * Clients that don't support ADDR2 always send TYPE_NONE.
> -	 * For now, since all we support is msgr1, just set this to 0
> -	 * when we get a TYPE_LEGACY type.
> -	 */
> -	if (addr->type == cpu_to_le32(1))
> -		addr->type = 0;
> -
>  	ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
>  
>  	ceph_decode_32_safe(p, end, addr_len, bad);
> @@ -61,7 +50,14 @@ ceph_decode_entity_addr_legacy(void **p, void *end,
>  
>  	/* Skip rest of type field */
>  	ceph_decode_skip_n(p, end, 3, bad);
> -	addr->type = 0;
> +
> +	/*
> +	 * Clients that don't support ADDR2 always send TYPE_NONE, change it
> +	 * to TYPE_LEGACY for forward compatibility.
> +	 */
> +	if (addr->type == CEPH_ENTITY_ADDR_TYPE_NONE)
> +		addr->type = CEPH_ENTITY_ADDR_TYPE_LEGACY;
> +

Oops, the "if" above is not necessary. We want to unconditionally set
this to TYPE_LEGACY here. I've fixed it up in my tree, but I won't
repost unless I need to respin for some other reason.

>  	ceph_decode_copy_safe(p, end, &addr->nonce, sizeof(addr->nonce), bad);
>  	memset(&addr->in_addr, 0, sizeof(addr->in_addr));
>  	ceph_decode_copy_safe(p, end, &addr->in_addr,
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index a25e71fa8124..57cb0554c9e2 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -199,12 +199,14 @@ const char *ceph_pr_addr(const struct ceph_entity_addr *addr)
>  
>  	switch (ss.ss_family) {
>  	case AF_INET:
> -		snprintf(s, MAX_ADDR_STR_LEN, "%pI4:%hu", &in4->sin_addr,
> +		snprintf(s, MAX_ADDR_STR_LEN, "(%d)%pI4:%hu",
> +			 le32_to_cpu(addr->type), &in4->sin_addr,
>  			 ntohs(in4->sin_port));
>  		break;
>  
>  	case AF_INET6:
> -		snprintf(s, MAX_ADDR_STR_LEN, "[%pI6c]:%hu", &in6->sin6_addr,
> +		snprintf(s, MAX_ADDR_STR_LEN, "(%d)[%pI6c]:%hu",
> +			 le32_to_cpu(addr->type), &in6->sin6_addr,
>  			 ntohs(in6->sin6_port));
>  		break;
>  
> @@ -1982,6 +1984,7 @@ int ceph_parse_ips(const char *c, const char *end,
>  		}
>  
>  		addr_set_port(&addr[i], port);
> +		addr[i].type = CEPH_ENTITY_ADDR_TYPE_LEGACY;
>  
>  		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i]));
>  

-- 
Jeff Layton <jlayton@kernel.org>

