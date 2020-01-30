Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A035C14DCC3
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 15:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgA3O0b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 09:26:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726980AbgA3O0b (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Jan 2020 09:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580394389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScpmxLi/R8T49iU+nFtREz09YTFB53waXex14KNBO3U=;
        b=hYis5rz+nY/nK/KuOttS4rsiH77/FjeGlGnwoF4O7qTfyqOB68xq4ohgP+v6U28ugLpmre
        CtpG0jy/RdLzmErFnCIFXON93XNgh4xeJ3zhy1Nzrj9dCjiLHafbFozy6B1gD9bZrUtzlQ
        b/Azq0Kwl+cuNNFQBF2Hih6HKrCXjfo=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-317-H8_-UVPRNgGfEqKFV91hmA-1; Thu, 30 Jan 2020 09:26:27 -0500
X-MC-Unique: H8_-UVPRNgGfEqKFV91hmA-1
Received: by mail-yw1-f69.google.com with SMTP id a190so3411560ywe.15
        for <ceph-devel@vger.kernel.org>; Thu, 30 Jan 2020 06:26:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ScpmxLi/R8T49iU+nFtREz09YTFB53waXex14KNBO3U=;
        b=XFGDr8QSGgYr3EuVp/HLrItxYCl31pdrHO0q1Ryy9VdDb+rslAk+NHpg20DqoWrWZe
         3P3pM+DCgw0H9kSTSPF89YwkAxZurccGg0tI8GWNLpcPmNoi2CmnUNhKJQjjvXSGNkj0
         3ENdMiq1R2YHt2lsdVeAXUUZmOY63UBau+aapUkK9HwI3abp7heh+26G6e4is75lCJeU
         C+Ls8ucu4Gn0ib2TzOciv4ac1+psGBEKpoYn4vBLkPUQybqEg7imOhgxm9RsmI3tpAlg
         AiH0b0JpinkZg76lwkNIr5d40S10ktDRjPJdhEvE38lCIV7YtxlQzt/rDSZYoZKMHrOM
         M9VA==
X-Gm-Message-State: APjAAAXwGbHUAlx2Xm8imQDtdbNAG3BVQstVdPUqs8b6eQfGIHQaTlmy
        4novUa3ld5zqwW+CDGfFH482s2qFlQyfHjN1L/uxvlHP+Qej67XFdcK2iKSTE6mmWg2+Q8mvJl5
        TzL6cRNNT/DQ8wo2CO9tF+A==
X-Received: by 2002:a25:8502:: with SMTP id w2mr3860393ybk.161.1580394387210;
        Thu, 30 Jan 2020 06:26:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqyL77v1P/IVmm9gA18ewJmXh/TwTk6cOZj6mK+jE4IB7PvqOGXy6zGSImUV3Zuv4nT3sJy4NA==
X-Received: by 2002:a25:8502:: with SMTP id w2mr3860363ybk.161.1580394386822;
        Thu, 30 Jan 2020 06:26:26 -0800 (PST)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id m62sm2430799ywb.107.2020.01.30.06.26.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 06:26:26 -0800 (PST)
Message-ID: <2fc165f5ad9ea0ec8a0878eabe800ca0af3e10b8.camel@redhat.com>
Subject: Re: [PATCH] rbd: lock object request list
From:   Laurence Oberman <loberman@redhat.com>
To:     Hannes Reinecke <hare@suse.de>, Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
Date:   Thu, 30 Jan 2020 09:26:25 -0500
In-Reply-To: <20200130114258.8482-1-hare@suse.de>
References: <20200130114258.8482-1-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-30 at 12:42 +0100, Hannes Reinecke wrote:
> The object request list can be accessed from various contexts
> so we need to lock it to avoid concurrent modifications and
> random crashes.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/block/rbd.c | 31 ++++++++++++++++++++++++-------
>  1 file changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 5710b2a8609c..ddc170661607 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -344,6 +344,7 @@ struct rbd_img_request {
>  
>  	struct list_head	lock_item;
>  	struct list_head	object_extents;	/* obj_req.ex structs */
> +	struct mutex		object_mutex;
>  
>  	struct mutex		state_mutex;
>  	struct pending_result	pending;
> @@ -1664,6 +1665,7 @@ static struct rbd_img_request
> *rbd_img_request_create(
>  	INIT_LIST_HEAD(&img_request->lock_item);
>  	INIT_LIST_HEAD(&img_request->object_extents);
>  	mutex_init(&img_request->state_mutex);
> +	mutex_init(&img_request->object_mutex);
>  	kref_init(&img_request->kref);
>  
>  	return img_request;
> @@ -1680,8 +1682,10 @@ static void rbd_img_request_destroy(struct
> kref *kref)
>  	dout("%s: img %p\n", __func__, img_request);
>  
>  	WARN_ON(!list_empty(&img_request->lock_item));
> +	mutex_lock(&img_request->object_mutex);
>  	for_each_obj_request_safe(img_request, obj_request,
> next_obj_request)
>  		rbd_img_obj_request_del(img_request, obj_request);
> +	mutex_unlock(&img_request->object_mutex);
>  
>  	if (img_request_layered_test(img_request)) {
>  		img_request_layered_clear(img_request);
> @@ -2486,6 +2490,7 @@ static int __rbd_img_fill_request(struct
> rbd_img_request *img_req)
>  	struct rbd_obj_request *obj_req, *next_obj_req;
>  	int ret;
>  
> +	mutex_lock(&img_req->object_mutex);
>  	for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
>  		switch (img_req->op_type) {
>  		case OBJ_OP_READ:
> @@ -2510,7 +2515,7 @@ static int __rbd_img_fill_request(struct
> rbd_img_request *img_req)
>  			continue;
>  		}
>  	}
> -
> +	mutex_unlock(&img_req->object_mutex);
>  	img_req->state = RBD_IMG_START;
>  	return 0;
>  }
> @@ -2569,6 +2574,7 @@ static int rbd_img_fill_request_nocopy(struct
> rbd_img_request *img_req,
>  	 * position in the provided bio (list) or bio_vec array.
>  	 */
>  	fctx->iter = *fctx->pos;
> +	mutex_lock(&img_req->object_mutex);
>  	for (i = 0; i < num_img_extents; i++) {
>  		ret = ceph_file_to_extents(&img_req->rbd_dev->layout,
>  					   img_extents[i].fe_off,
> @@ -2576,10 +2582,12 @@ static int rbd_img_fill_request_nocopy(struct
> rbd_img_request *img_req,
>  					   &img_req->object_extents,
>  					   alloc_object_extent,
> img_req,
>  					   fctx->set_pos_fn, &fctx-
> >iter);
> -		if (ret)
> +		if (ret) {
> +			mutex_unlock(&img_req->object_mutex);
>  			return ret;
> +		}
>  	}
> -
> +	mutex_unlock(&img_req->object_mutex);
>  	return __rbd_img_fill_request(img_req);
>  }
>  
> @@ -2620,6 +2628,7 @@ static int rbd_img_fill_request(struct
> rbd_img_request *img_req,
>  	 * or bio_vec array because when mapped, those bio_vecs can
> straddle
>  	 * stripe unit boundaries.
>  	 */
> +	mutex_lock(&img_req->object_mutex);
>  	fctx->iter = *fctx->pos;
>  	for (i = 0; i < num_img_extents; i++) {
>  		ret = ceph_file_to_extents(&rbd_dev->layout,
> @@ -2629,15 +2638,17 @@ static int rbd_img_fill_request(struct
> rbd_img_request *img_req,
>  					   alloc_object_extent,
> img_req,
>  					   fctx->count_fn, &fctx-
> >iter);
>  		if (ret)
> -			return ret;
> +			goto out_unlock;
>  	}
>  
>  	for_each_obj_request(img_req, obj_req) {
>  		obj_req->bvec_pos.bvecs = kmalloc_array(obj_req-
> >bvec_count,
>  					      sizeof(*obj_req-
> >bvec_pos.bvecs),
>  					      GFP_NOIO);
> -		if (!obj_req->bvec_pos.bvecs)
> -			return -ENOMEM;
> +		if (!obj_req->bvec_pos.bvecs) {
> +			ret = -ENOMEM;
> +			goto out_unlock;
> +		}
>  	}
>  
>  	/*
> @@ -2652,10 +2663,14 @@ static int rbd_img_fill_request(struct
> rbd_img_request *img_req,
>  					   &img_req->object_extents,
>  					   fctx->copy_fn, &fctx->iter);
>  		if (ret)
> -			return ret;
> +			goto out_unlock;
>  	}
> +	mutex_unlock(&img_req->object_mutex);
>  
>  	return __rbd_img_fill_request(img_req);
> +out_unlock:
> +	mutex_unlock(&img_req->object_mutex);
> +	return ret;
>  }
>  
>  static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
> @@ -3552,6 +3567,7 @@ static void rbd_img_object_requests(struct
> rbd_img_request *img_req)
>  
>  	rbd_assert(!img_req->pending.result && !img_req-
> >pending.num_pending);
>  
> +	mutex_lock(&img_req->object_mutex);
>  	for_each_obj_request(img_req, obj_req) {
>  		int result = 0;
>  
> @@ -3564,6 +3580,7 @@ static void rbd_img_object_requests(struct
> rbd_img_request *img_req)
>  			img_req->pending.num_pending++;
>  		}
>  	}
> +	mutex_unlock(&img_req->object_mutex);
>  }
>  
>  static bool rbd_img_advance(struct rbd_img_request *img_req, int
> *result)

Looks good to me. Just wonder how we escaped this for so long.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

