Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D61E215C06
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jul 2020 18:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgGFQlJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jul 2020 12:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgGFQlI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jul 2020 12:41:08 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A260D206CD;
        Mon,  6 Jul 2020 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594053667;
        bh=VFZaxmpDnE5c/xSERcHFWHT/nx79QYt+HzZJImrhGCI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t3etd0pMZo9smo466zLH2aep4DTRv2tjIJwu2kJc9fLp5j1NhVZnRbqWwFHy8qqCM
         +WMA/rwR65Ph1sbXbl50PSJ7ut8dkBYMwOHZ3MeD516r02xuWCJ91g4DI8sMRzCle8
         5nU6GHao3YOZV71CmbNBw4rtIsNFPGJpG67nsW0Q=
Message-ID: <c331c66935cbeab95bd7e32198afb2bc72186df6.camel@kernel.org>
Subject: Re: [PATCH 1/4] libceph: just have osd_req_op_init return a pointer
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 06 Jul 2020 12:41:06 -0400
In-Reply-To: <20200701155446.41141-2-jlayton@kernel.org>
References: <20200701155446.41141-1-jlayton@kernel.org>
         <20200701155446.41141-2-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-07-01 at 11:54 -0400, Jeff Layton wrote:
> The caller can just ignore the return. No need for this wrapper that
> just casts the other function to void.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/osd_client.h |  2 +-
>  net/ceph/osd_client.c           | 31 ++++++++++++-------------------
>  2 files changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index c60b59e9291b..8d63dc22cb36 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -404,7 +404,7 @@ void ceph_osdc_clear_abort_err(struct ceph_osd_client *osdc);
>  	&__oreq->r_ops[__whch].typ.fld;					\
>  })
>  
> -extern void osd_req_op_init(struct ceph_osd_request *osd_req,
> +extern struct ceph_osd_req_op *osd_req_op_init(struct ceph_osd_request *osd_req,
>  			    unsigned int which, u16 opcode, u32 flags);
>  
>  extern void osd_req_op_raw_data_in_pages(struct ceph_osd_request *,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index db6abb5a5511..3cff29d38b9f 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -525,7 +525,7 @@ EXPORT_SYMBOL(ceph_osdc_put_request);
>  
>  static void request_init(struct ceph_osd_request *req)
>  {
> -	/* req only, each op is zeroed in _osd_req_op_init() */
> +	/* req only, each op is zeroed in osd_req_op_init() */
>  	memset(req, 0, sizeof(*req));
>  
>  	kref_init(&req->r_kref);
> @@ -746,8 +746,8 @@ EXPORT_SYMBOL(ceph_osdc_alloc_messages);
>   * other information associated with them.  It also serves as a
>   * common init routine for all the other init functions, below.
>   */
> -static struct ceph_osd_req_op *
> -_osd_req_op_init(struct ceph_osd_request *osd_req, unsigned int which,
> +struct ceph_osd_req_op *
> +osd_req_op_init(struct ceph_osd_request *osd_req, unsigned int which,
>  		 u16 opcode, u32 flags)
>  {
>  	struct ceph_osd_req_op *op;
> @@ -762,12 +762,6 @@ _osd_req_op_init(struct ceph_osd_request *osd_req, unsigned int which,
>  
>  	return op;
>  }
> -
> -void osd_req_op_init(struct ceph_osd_request *osd_req,
> -		     unsigned int which, u16 opcode, u32 flags)
> -{
> -	(void)_osd_req_op_init(osd_req, which, opcode, flags);
> -}
>  EXPORT_SYMBOL(osd_req_op_init);
>  
>  void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
> @@ -775,8 +769,7 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
>  				u64 offset, u64 length,
>  				u64 truncate_size, u32 truncate_seq)
>  {
> -	struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which,
> -						      opcode, 0);
> +	struct ceph_osd_req_op *op = osd_req_op_init(osd_req, which, opcode, 0);
>  	size_t payload_len = 0;
>  
>  	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
> @@ -822,7 +815,7 @@ void osd_req_op_extent_dup_last(struct ceph_osd_request *osd_req,
>  	BUG_ON(which + 1 >= osd_req->r_num_ops);
>  
>  	prev_op = &osd_req->r_ops[which];
> -	op = _osd_req_op_init(osd_req, which + 1, prev_op->op, prev_op->flags);
> +	op = osd_req_op_init(osd_req, which + 1, prev_op->op, prev_op->flags);
>  	/* dup previous one */
>  	op->indata_len = prev_op->indata_len;
>  	op->outdata_len = prev_op->outdata_len;
> @@ -845,7 +838,7 @@ int osd_req_op_cls_init(struct ceph_osd_request *osd_req, unsigned int which,
>  	size_t size;
>  	int ret;
>  
> -	op = _osd_req_op_init(osd_req, which, CEPH_OSD_OP_CALL, 0);
> +	op = osd_req_op_init(osd_req, which, CEPH_OSD_OP_CALL, 0);
>  
>  	pagelist = ceph_pagelist_alloc(GFP_NOFS);
>  	if (!pagelist)
> @@ -883,7 +876,7 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
>  			  u16 opcode, const char *name, const void *value,
>  			  size_t size, u8 cmp_op, u8 cmp_mode)
>  {
> -	struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which,
> +	struct ceph_osd_req_op *op = osd_req_op_init(osd_req, which,
>  						      opcode, 0);
>  	struct ceph_pagelist *pagelist;
>  	size_t payload_len;
> @@ -928,7 +921,7 @@ static void osd_req_op_watch_init(struct ceph_osd_request *req, int which,
>  {
>  	struct ceph_osd_req_op *op;
>  
> -	op = _osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
> +	op = osd_req_op_init(req, which, CEPH_OSD_OP_WATCH, 0);
>  	op->watch.cookie = cookie;
>  	op->watch.op = watch_opcode;
>  	op->watch.gen = 0;
> @@ -943,7 +936,7 @@ void osd_req_op_alloc_hint_init(struct ceph_osd_request *osd_req,
>  				u64 expected_write_size,
>  				u32 flags)
>  {
> -	struct ceph_osd_req_op *op = _osd_req_op_init(osd_req, which,
> +	struct ceph_osd_req_op *op = osd_req_op_init(osd_req, which,
>  						      CEPH_OSD_OP_SETALLOCHINT,
>  						      0);
>  
> @@ -4799,7 +4792,7 @@ static int osd_req_op_notify_ack_init(struct ceph_osd_request *req, int which,
>  	struct ceph_pagelist *pl;
>  	int ret;
>  
> -	op = _osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY_ACK, 0);
> +	op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY_ACK, 0);
>  
>  	pl = ceph_pagelist_alloc(GFP_NOIO);
>  	if (!pl)
> @@ -4868,7 +4861,7 @@ static int osd_req_op_notify_init(struct ceph_osd_request *req, int which,
>  	struct ceph_pagelist *pl;
>  	int ret;
>  
> -	op = _osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
> +	op = osd_req_op_init(req, which, CEPH_OSD_OP_NOTIFY, 0);
>  	op->notify.cookie = cookie;
>  
>  	pl = ceph_pagelist_alloc(GFP_NOIO);
> @@ -5332,7 +5325,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>  	if (IS_ERR(pages))
>  		return PTR_ERR(pages);
>  
> -	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
> +	op = osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
>  			      dst_fadvise_flags);
>  	op->copy_from.snapid = src_snapid;
>  	op->copy_from.src_version = src_version;

Hi Ilya,

This patch was part of the series that I sent last week. I know you
nacked the other patches, but were you also opposed to this one? It's a
fairly straightforward cleanup that gets rid of some unnecessary (and
odd) casting.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

