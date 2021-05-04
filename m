Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 377B5372AD8
	for <lists+ceph-devel@lfdr.de>; Tue,  4 May 2021 15:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhEDNWL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 May 2021 09:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230413AbhEDNWK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 May 2021 09:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CA57613C6;
        Tue,  4 May 2021 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620134475;
        bh=MripJ7scYEalrEVND/wM+ltVqVvP696Kcq+LIyYqqE8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cbog64o4fx5nwxXKcpX8qrW5lpYBZ8V+UUtXuSRDiXN6Lxxwf9gA4hbjfULrXzDRy
         ogbiSlfZ+F7NbIniHCc7Qwv9r1H/DVTFiK+4PiPtax+xY9f5+DYiAwaXxbufVS22q0
         PpgRyOx5o1n+CiblJ3YaaJ4GE8vtdOcDzRHd3yLjwEB8CXXXebcyvqL3vpHBD4thpi
         14bQ4L0fy3KHfMDdj9gE1k+GQncNedAm0fIdWPKV9oHLOZAnNDj1CZb6XGZShhCxvL
         uyU2WKfq7gXWf8zCLJhpQq0Jyn1lgv8Nn0WMju+eft7GSfzG83ysr7VmIXS/9m0VVK
         hHRFGmTw99A/w==
Message-ID: <f389505b985f2bad7e56acd8113917cb6f06a4c6.camel@kernel.org>
Subject: Re: [PATCH] libceph: allow addrvecs with a single NONE/blank address
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Magnus Harlander <magnus@harlan.de>
Date:   Tue, 04 May 2021 09:21:14 -0400
In-Reply-To: <20210504105408.6035-1-idryomov@gmail.com>
References: <20210504105408.6035-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-05-04 at 12:54 +0200, Ilya Dryomov wrote:
> Normally, an unused OSD id/slot is represented by an empty addrvec.
> However, it also appears to be possible to generate an osdmap where
> an unused OSD id/slot has an addrvec with a single blank address of
> type NONE.  Allow such addrvecs and make the end result be exactly
> the same as for the empty addrvec case -- leave addr intact.
> 
> Cc: stable@vger.kernel.org # 5.11+
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/decode.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/net/ceph/decode.c b/net/ceph/decode.c
> index b44f7651be04..bc109a1a4616 100644
> --- a/net/ceph/decode.c
> +++ b/net/ceph/decode.c
> @@ -4,6 +4,7 @@
>  #include <linux/inet.h>
>  
>  #include <linux/ceph/decode.h>
> +#include <linux/ceph/messenger.h>  /* for ceph_pr_addr() */
>  
>  static int
>  ceph_decode_entity_addr_versioned(void **p, void *end,
> @@ -110,6 +111,7 @@ int ceph_decode_entity_addrvec(void **p, void *end, bool msgr2,
>  	}
>  
>  	ceph_decode_32_safe(p, end, addr_cnt, e_inval);
> +	dout("%s addr_cnt %d\n", __func__, addr_cnt);
>  
>  	found = false;
>  	for (i = 0; i < addr_cnt; i++) {
> @@ -117,6 +119,7 @@ int ceph_decode_entity_addrvec(void **p, void *end, bool msgr2,
>  		if (ret)
>  			return ret;
>  
> +		dout("%s i %d addr %s\n", __func__, i, ceph_pr_addr(&tmp_addr));
>  		if (tmp_addr.type == my_type) {
>  			if (found) {
>  				pr_err("another match of type %d in addrvec\n",
> @@ -128,13 +131,18 @@ int ceph_decode_entity_addrvec(void **p, void *end, bool msgr2,
>  			found = true;
>  		}
>  	}
> -	if (!found && addr_cnt != 0) {
> -		pr_err("no match of type %d in addrvec\n",
> -		       le32_to_cpu(my_type));
> -		return -ENOENT;
> -	}
>  
> -	return 0;
> +	if (found)
> +		return 0;
> +
> +	if (!addr_cnt)
> +		return 0;  /* normal -- e.g. unused OSD id/slot */
> +
> +	if (addr_cnt == 1 && !memchr_inv(&tmp_addr, 0, sizeof(tmp_addr)))
> +		return 0;  /* weird but effectively the same as !addr_cnt */
> +
> +	pr_err("no match of type %d in addrvec\n", le32_to_cpu(my_type));
> +	return -ENOENT;
>  
>  e_inval:
>  	return -EINVAL;

Reviewed-by: Jeff Layton <jlayton@kernel.org>

