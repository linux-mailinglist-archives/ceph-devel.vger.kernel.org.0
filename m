Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBA6EFC636
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 13:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfKNMSl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 07:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbfKNMSl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 07:18:41 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2EC206D4;
        Thu, 14 Nov 2019 12:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573733920;
        bh=p/g7jjE3ALxvY9YW1V6Po3Vh3BOVksDNV8kP1xqxivY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QZTNNJD1C14cxWpP44cHyM22MdXF3YbaPvjvY7MonJ1dX2H7DydqCvFHYFSV3/Apw
         1c8BuL3omxcuBWZ24lmv5sPtIpHNe+4TzVQsuJCy9aw/1OEGGzGFXgmOvYAxEQcyV0
         SO06K/9H4F59sBMqfT7wZ0FRtzsq2yPJPCjs9jiU=
Message-ID: <b1ae185b3c9a420713d21e9f3d6318f0ab557081.camel@kernel.org>
Subject: Re: [RFC PATCH v2 1/4] ceph: add support for TYPE_MSGR2 address
 decode
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Nov 2019 07:18:24 -0500
In-Reply-To: <20191114105736.8636-2-lhenriques@suse.com>
References: <20191114105736.8636-1-lhenriques@suse.com>
         <20191114105736.8636-2-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-11-14 at 10:57 +0000, Luis Henriques wrote:
> The new format actually includes two addresses: one the new messenger v2,
> and other for the legacy v1, which is the only one currently understood
> by kernel clients.  Add code to pick the legacy address and ignore the v2
> one.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  include/linux/ceph/decode.h |  3 ++-
>  net/ceph/decode.c           | 33 +++++++++++++++++++++++++++++++--
>  2 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
> index 450384fe487c..2a2f07dfb39c 100644
> --- a/include/linux/ceph/decode.h
> +++ b/include/linux/ceph/decode.h
> @@ -219,7 +219,8 @@ static inline void ceph_encode_timespec64(struct ceph_timespec *tv,
>   * sockaddr_storage <-> ceph_sockaddr
>   */
>  #define CEPH_ENTITY_ADDR_TYPE_NONE	0
> -#define CEPH_ENTITY_ADDR_TYPE_LEGACY	__cpu_to_le32(1)
> +#define CEPH_ENTITY_ADDR_TYPE_LEGACY	__cpu_to_le32(1) /* legacy msgr1 */
> +#define CEPH_ENTITY_ADDR_TYPE_MSGR2	__cpu_to_le32(2) /* msgr2 protocol */
>  
>  static inline void ceph_encode_banner_addr(struct ceph_entity_addr *a)
>  {
> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> index eea529595a7a..613a2bc6f805 100644
> --- a/net/ceph/decode.c
> +++ b/net/ceph/decode.c
> @@ -67,16 +67,45 @@ ceph_decode_entity_addr_legacy(void **p, void *end,
>  	return ret;
>  }
>  
> +static int
> +ceph_decode_entity_addr_versioned_msgr2(void **p, void *end,
> +					struct ceph_entity_addr *addr)
> +{
> +	struct ceph_entity_addr tmp_addr;
> +	struct ceph_entity_addr *paddr = addr;
> +	int ret = -EINVAL;
> +
> +	ceph_decode_skip_32(p, end, bad); /* hard-coded '2' */
> +	ceph_decode_skip_8(p, end, bad);  /* hard-coded '1' */
> +
> +	ret = ceph_decode_entity_addr_versioned(p, end, paddr);
> +	if (ret)
> +		goto bad;
> +	/* If we already have a v1 address, simply skip over the other address */
> +	if (paddr->type == CEPH_ENTITY_ADDR_TYPE_LEGACY)
> +		paddr = &tmp_addr;
> +
> +	ceph_decode_skip_8(p, end, bad);  /* hard-coded '1' */
> +
> +	ret = ceph_decode_entity_addr_versioned(p, end, paddr);
> +
> +bad:
> +	return ret;
> +}
> +
>  int
>  ceph_decode_entity_addr(void **p, void *end, struct ceph_entity_addr *addr)
>  {
>  	u8 marker;
>  
>  	ceph_decode_8_safe(p, end, marker, bad);
> -	if (marker == 1)
> +	if (marker == CEPH_ENTITY_ADDR_TYPE_MSGR2)
> +		return ceph_decode_entity_addr_versioned_msgr2(p, end, addr);
> +	else if (marker == CEPH_ENTITY_ADDR_TYPE_LEGACY)
>  		return ceph_decode_entity_addr_versioned(p, end, addr);
> -	else if (marker == 0)
> +	else if (marker == CEPH_ENTITY_ADDR_TYPE_NONE)
>  		return ceph_decode_entity_addr_legacy(p, end, addr);

You're decoding a byte into "marker" and then comparing that to a __le32
value. They almost certainly won't match correctly on a BE arch.

> +
>  bad:
>  	return -EINVAL;
>  }

-- 
Jeff Layton <jlayton@kernel.org>

