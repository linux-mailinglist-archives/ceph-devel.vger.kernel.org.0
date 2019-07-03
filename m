Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620975E91B
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 18:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfGCQcJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 12:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfGCQcJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 12:32:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 117092187F;
        Wed,  3 Jul 2019 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562171528;
        bh=x2uZQGgZID9yaZA5DwY/5R6+0aOQLUg52g5KF+rrCZg=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=jNOrY2kiOfVojbKFr8BT8X/l6WS0I6pMdgiErfrdMpP173/8+YsIGyF/VJsotv/9P
         yhMFRK/x46KNMQTuvOaM3deNsY3tByJGHvkHudR3WNYyIoQz0VY1cj1LgdF+x2lhDR
         mAvNDyKgoztVne1V4oGVwy84+KpwTHleQkuBpUvI=
Message-ID: <88bf708d3470c367736da477c6444225d98efe99.camel@kernel.org>
Subject: Re: [PATCH] libceph: handle OSD op ceph_pagelist_append() errors
From:   Jeff Layton <jlayton@kernel.org>
To:     David Disseldorp <ddiss@suse.de>, ceph-devel@vger.kernel.org
Date:   Wed, 03 Jul 2019 12:32:06 -0400
In-Reply-To: <20190703155920.2809-1-ddiss@suse.de>
References: <20190703155920.2809-1-ddiss@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-07-03 at 17:59 +0200, David Disseldorp wrote:
> osd_req_op_cls_init() and osd_req_op_xattr_init() currently propagate
> ceph_pagelist_alloc() ENOMEM errors but ignore ceph_pagelist_append()
> memory allocation failures. Add these checks and cleanup on error.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  net/ceph/osd_client.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 9a8eca5eda65..83a7382bbe86 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -849,6 +849,7 @@ int osd_req_op_cls_init(struct ceph_osd_request *osd_req, unsigned int which,
>  	struct ceph_pagelist *pagelist;
>  	size_t payload_len = 0;
>  	size_t size;
> +	int ret;
>  
>  	op = _osd_req_op_init(osd_req, which, CEPH_OSD_OP_CALL, 0);
>  
> @@ -860,20 +861,28 @@ int osd_req_op_cls_init(struct ceph_osd_request *osd_req, unsigned int which,
>  	size = strlen(class);
>  	BUG_ON(size > (size_t) U8_MAX);
>  	op->cls.class_len = size;
> -	ceph_pagelist_append(pagelist, class, size);
> +	ret = ceph_pagelist_append(pagelist, class, size);
> +	if (ret)
> +		goto err_pagelist_free;
>  	payload_len += size;
>  
>  	op->cls.method_name = method;
>  	size = strlen(method);
>  	BUG_ON(size > (size_t) U8_MAX);
>  	op->cls.method_len = size;
> -	ceph_pagelist_append(pagelist, method, size);
> +	ret = ceph_pagelist_append(pagelist, method, size);
> +	if (ret)
> +		goto err_pagelist_free;
>  	payload_len += size;
>  
>  	osd_req_op_cls_request_info_pagelist(osd_req, which, pagelist);
>  
>  	op->indata_len = payload_len;
>  	return 0;
> +
> +err_pagelist_free:
> +	ceph_pagelist_release(pagelist);
> +	return ret;
>  }
>  EXPORT_SYMBOL(osd_req_op_cls_init);
>  
> @@ -885,6 +894,7 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
>  						      opcode, 0);
>  	struct ceph_pagelist *pagelist;
>  	size_t payload_len;
> +	int ret;
>  
>  	BUG_ON(opcode != CEPH_OSD_OP_SETXATTR && opcode != CEPH_OSD_OP_CMPXATTR);
>  
> @@ -894,10 +904,14 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
>  
>  	payload_len = strlen(name);
>  	op->xattr.name_len = payload_len;
> -	ceph_pagelist_append(pagelist, name, payload_len);
> +	ret = ceph_pagelist_append(pagelist, name, payload_len);
> +	if (ret)
> +		goto err_pagelist_free;
>  
>  	op->xattr.value_len = size;
> -	ceph_pagelist_append(pagelist, value, size);
> +	ret = ceph_pagelist_append(pagelist, value, size);
> +	if (ret)
> +		goto err_pagelist_free;
>  	payload_len += size;
>  
>  	op->xattr.cmp_op = cmp_op;
> @@ -906,6 +920,10 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
>  	ceph_osd_data_pagelist_init(&op->xattr.osd_data, pagelist);
>  	op->indata_len = payload_len;
>  	return 0;
> +
> +err_pagelist_free:
> +	ceph_pagelist_release(pagelist);
> +	return ret;
>  }
>  EXPORT_SYMBOL(osd_req_op_xattr_init);
>  

Good catch:

Reviewed-by: Jeff Layton <jlayton@kernel.org>

