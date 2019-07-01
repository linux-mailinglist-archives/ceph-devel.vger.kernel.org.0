Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16D05BA4C
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 13:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbfGALFL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 07:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727162AbfGALFK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 07:05:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34A8D20673;
        Mon,  1 Jul 2019 11:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561979109;
        bh=CRgbHYJiNLO4WaTXJtjNDtzXMAWHoPJYnuD1dBu9HtM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xs/Ue5i303dCI0beTLgNImSUBmx+W/YVC3KxjovicslEqf/pSu2oGc+/BiL5GC+3L
         J9ahuZ7+kd6gcwLPGvRZyOl/ecTQMHJ9B9mXE0IQr8Og+FZrrlAZkF07HaFx3klOtq
         OsgmaPr1TtrIC4Xoiev+utgGewMeXvhbNJJiDnVg=
Message-ID: <20e87a955b7969148eeaa5e4b2c4eaeb24c34f45.camel@kernel.org>
Subject: Re: [PATCH 16/20] libceph: change ceph_osdc_call() to take page
 vector for response
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Date:   Mon, 01 Jul 2019 07:05:07 -0400
In-Reply-To: <20190625144111.11270-17-idryomov@gmail.com>
References: <20190625144111.11270-1-idryomov@gmail.com>
         <20190625144111.11270-17-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-06-25 at 16:41 +0200, Ilya Dryomov wrote:
> This will be used for loading object map.  rbd_obj_read_sync() isn't
> suitable because object map must be accessed through class methods.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  drivers/block/rbd.c             |  8 ++++----
>  include/linux/ceph/osd_client.h |  2 +-
>  net/ceph/cls_lock_client.c      |  2 +-
>  net/ceph/osd_client.c           | 10 +++++-----
>  4 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index fd3f248ba9c2..c9f88b0cb730 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4072,7 +4072,7 @@ static int rbd_obj_method_sync(struct rbd_device *rbd_dev,
>  
>  	ret = ceph_osdc_call(osdc, oid, oloc, RBD_DRV_NAME, method_name,
>  			     CEPH_OSD_FLAG_READ, req_page, outbound_size,
> -			     reply_page, &inbound_size);
> +			     &reply_page, &inbound_size);
>  	if (!ret) {
>  		memcpy(inbound, page_address(reply_page), inbound_size);
>  		ret = inbound_size;
> @@ -5098,7 +5098,7 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
>  
>  	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>  			     "rbd", "parent_get", CEPH_OSD_FLAG_READ,
> -			     req_page, sizeof(u64), reply_page, &reply_len);
> +			     req_page, sizeof(u64), &reply_page, &reply_len);
>  	if (ret)
>  		return ret == -EOPNOTSUPP ? 1 : ret;
>  
> @@ -5110,7 +5110,7 @@ static int __get_parent_info(struct rbd_device *rbd_dev,
>  
>  	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>  			     "rbd", "parent_overlap_get", CEPH_OSD_FLAG_READ,
> -			     req_page, sizeof(u64), reply_page, &reply_len);
> +			     req_page, sizeof(u64), &reply_page, &reply_len);
>  	if (ret)
>  		return ret;
>  
> @@ -5141,7 +5141,7 @@ static int __get_parent_info_legacy(struct rbd_device *rbd_dev,
>  
>  	ret = ceph_osdc_call(osdc, &rbd_dev->header_oid, &rbd_dev->header_oloc,
>  			     "rbd", "get_parent", CEPH_OSD_FLAG_READ,
> -			     req_page, sizeof(u64), reply_page, &reply_len);
> +			     req_page, sizeof(u64), &reply_page, &reply_len);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 2294f963dab7..edb191c40a5c 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -497,7 +497,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  		   const char *class, const char *method,
>  		   unsigned int flags,
>  		   struct page *req_page, size_t req_len,
> -		   struct page *resp_page, size_t *resp_len);
> +		   struct page **resp_pages, size_t *resp_len);
>  
>  extern int ceph_osdc_readpages(struct ceph_osd_client *osdc,
>  			       struct ceph_vino vino,
> diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
> index 4cc28541281b..56bbfe01e3ac 100644
> --- a/net/ceph/cls_lock_client.c
> +++ b/net/ceph/cls_lock_client.c
> @@ -360,7 +360,7 @@ int ceph_cls_lock_info(struct ceph_osd_client *osdc,
>  	dout("%s lock_name %s\n", __func__, lock_name);
>  	ret = ceph_osdc_call(osdc, oid, oloc, "lock", "get_info",
>  			     CEPH_OSD_FLAG_READ, get_info_op_page,
> -			     get_info_op_buf_size, reply_page, &reply_len);
> +			     get_info_op_buf_size, &reply_page, &reply_len);
>  
>  	dout("%s: status %d\n", __func__, ret);
>  	if (ret >= 0) {
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 9a8eca5eda65..cc2bf296583d 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5044,12 +5044,12 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  		   const char *class, const char *method,
>  		   unsigned int flags,
>  		   struct page *req_page, size_t req_len,
> -		   struct page *resp_page, size_t *resp_len)
> +		   struct page **resp_pages, size_t *resp_len)
>  {
>  	struct ceph_osd_request *req;
>  	int ret;
>  
> -	if (req_len > PAGE_SIZE || (resp_page && *resp_len > PAGE_SIZE))
> +	if (req_len > PAGE_SIZE)
>  		return -E2BIG;
>  
>  	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_NOIO);
> @@ -5067,8 +5067,8 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  	if (req_page)
>  		osd_req_op_cls_request_data_pages(req, 0, &req_page, req_len,
>  						  0, false, false);
> -	if (resp_page)
> -		osd_req_op_cls_response_data_pages(req, 0, &resp_page,
> +	if (resp_pages)
> +		osd_req_op_cls_response_data_pages(req, 0, resp_pages,
>  						   *resp_len, 0, false, false);
>  
>  	ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
> @@ -5079,7 +5079,7 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  	ret = ceph_osdc_wait_request(osdc, req);
>  	if (ret >= 0) {
>  		ret = req->r_ops[0].rval;
> -		if (resp_page)
> +		if (resp_pages)
>  			*resp_len = req->r_ops[0].outdata_len;
>  	}
>  

Reviewed-by: Jeff Layton <jlayton@kernel.org>

