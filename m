Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B306A14DE02
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Jan 2020 16:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgA3Pjk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Jan 2020 10:39:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:33530 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgA3Pjk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 10:39:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CDCDFAFFC;
        Thu, 30 Jan 2020 15:39:36 +0000 (UTC)
Subject: Re: [PATCH] rbd: lock object request list
To:     Laurence Oberman <loberman@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Sage Weil <sage@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
References: <20200130114258.8482-1-hare@suse.de>
 <2fc165f5ad9ea0ec8a0878eabe800ca0af3e10b8.camel@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <b786e9dd-02c1-e117-db92-aa3f50804bc7@suse.de>
Date:   Thu, 30 Jan 2020 16:39:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2fc165f5ad9ea0ec8a0878eabe800ca0af3e10b8.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/30/20 3:26 PM, Laurence Oberman wrote:
> On Thu, 2020-01-30 at 12:42 +0100, Hannes Reinecke wrote:
>> The object request list can be accessed from various contexts
>> so we need to lock it to avoid concurrent modifications and
>> random crashes.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/block/rbd.c | 31 ++++++++++++++++++++++++-------
>>  1 file changed, 24 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
>> index 5710b2a8609c..ddc170661607 100644
>> --- a/drivers/block/rbd.c
>> +++ b/drivers/block/rbd.c
>> @@ -344,6 +344,7 @@ struct rbd_img_request {
>>  
>>  	struct list_head	lock_item;
>>  	struct list_head	object_extents;	/* obj_req.ex structs */
>> +	struct mutex		object_mutex;
>>  
>>  	struct mutex		state_mutex;
>>  	struct pending_result	pending;
>> @@ -1664,6 +1665,7 @@ static struct rbd_img_request
>> *rbd_img_request_create(
>>  	INIT_LIST_HEAD(&img_request->lock_item);
>>  	INIT_LIST_HEAD(&img_request->object_extents);
>>  	mutex_init(&img_request->state_mutex);
>> +	mutex_init(&img_request->object_mutex);
>>  	kref_init(&img_request->kref);
>>  
>>  	return img_request;
>> @@ -1680,8 +1682,10 @@ static void rbd_img_request_destroy(struct
>> kref *kref)
>>  	dout("%s: img %p\n", __func__, img_request);
>>  
>>  	WARN_ON(!list_empty(&img_request->lock_item));
>> +	mutex_lock(&img_request->object_mutex);
>>  	for_each_obj_request_safe(img_request, obj_request,
>> next_obj_request)
>>  		rbd_img_obj_request_del(img_request, obj_request);
>> +	mutex_unlock(&img_request->object_mutex);
>>  
>>  	if (img_request_layered_test(img_request)) {
>>  		img_request_layered_clear(img_request);
>> @@ -2486,6 +2490,7 @@ static int __rbd_img_fill_request(struct
>> rbd_img_request *img_req)
>>  	struct rbd_obj_request *obj_req, *next_obj_req;
>>  	int ret;
>>  
>> +	mutex_lock(&img_req->object_mutex);
>>  	for_each_obj_request_safe(img_req, obj_req, next_obj_req) {
>>  		switch (img_req->op_type) {
>>  		case OBJ_OP_READ:
>> @@ -2510,7 +2515,7 @@ static int __rbd_img_fill_request(struct
>> rbd_img_request *img_req)
>>  			continue;
>>  		}
>>  	}
>> -
>> +	mutex_unlock(&img_req->object_mutex);
>>  	img_req->state = RBD_IMG_START;
>>  	return 0;
>>  }
>> @@ -2569,6 +2574,7 @@ static int rbd_img_fill_request_nocopy(struct
>> rbd_img_request *img_req,
>>  	 * position in the provided bio (list) or bio_vec array.
>>  	 */
>>  	fctx->iter = *fctx->pos;
>> +	mutex_lock(&img_req->object_mutex);
>>  	for (i = 0; i < num_img_extents; i++) {
>>  		ret = ceph_file_to_extents(&img_req->rbd_dev->layout,
>>  					   img_extents[i].fe_off,
>> @@ -2576,10 +2582,12 @@ static int rbd_img_fill_request_nocopy(struct
>> rbd_img_request *img_req,
>>  					   &img_req->object_extents,
>>  					   alloc_object_extent,
>> img_req,
>>  					   fctx->set_pos_fn, &fctx-
>>> iter);
>> -		if (ret)
>> +		if (ret) {
>> +			mutex_unlock(&img_req->object_mutex);
>>  			return ret;
>> +		}
>>  	}
>> -
>> +	mutex_unlock(&img_req->object_mutex);
>>  	return __rbd_img_fill_request(img_req);
>>  }
>>  
>> @@ -2620,6 +2628,7 @@ static int rbd_img_fill_request(struct
>> rbd_img_request *img_req,
>>  	 * or bio_vec array because when mapped, those bio_vecs can
>> straddle
>>  	 * stripe unit boundaries.
>>  	 */
>> +	mutex_lock(&img_req->object_mutex);
>>  	fctx->iter = *fctx->pos;
>>  	for (i = 0; i < num_img_extents; i++) {
>>  		ret = ceph_file_to_extents(&rbd_dev->layout,
>> @@ -2629,15 +2638,17 @@ static int rbd_img_fill_request(struct
>> rbd_img_request *img_req,
>>  					   alloc_object_extent,
>> img_req,
>>  					   fctx->count_fn, &fctx-
>>> iter);
>>  		if (ret)
>> -			return ret;
>> +			goto out_unlock;
>>  	}
>>  
>>  	for_each_obj_request(img_req, obj_req) {
>>  		obj_req->bvec_pos.bvecs = kmalloc_array(obj_req-
>>> bvec_count,
>>  					      sizeof(*obj_req-
>>> bvec_pos.bvecs),
>>  					      GFP_NOIO);
>> -		if (!obj_req->bvec_pos.bvecs)
>> -			return -ENOMEM;
>> +		if (!obj_req->bvec_pos.bvecs) {
>> +			ret = -ENOMEM;
>> +			goto out_unlock;
>> +		}
>>  	}
>>  
>>  	/*
>> @@ -2652,10 +2663,14 @@ static int rbd_img_fill_request(struct
>> rbd_img_request *img_req,
>>  					   &img_req->object_extents,
>>  					   fctx->copy_fn, &fctx->iter);
>>  		if (ret)
>> -			return ret;
>> +			goto out_unlock;
>>  	}
>> +	mutex_unlock(&img_req->object_mutex);
>>  
>>  	return __rbd_img_fill_request(img_req);
>> +out_unlock:
>> +	mutex_unlock(&img_req->object_mutex);
>> +	return ret;
>>  }
>>  
>>  static int rbd_img_fill_nodata(struct rbd_img_request *img_req,
>> @@ -3552,6 +3567,7 @@ static void rbd_img_object_requests(struct
>> rbd_img_request *img_req)
>>  
>>  	rbd_assert(!img_req->pending.result && !img_req-
>>> pending.num_pending);
>>  
>> +	mutex_lock(&img_req->object_mutex);
>>  	for_each_obj_request(img_req, obj_req) {
>>  		int result = 0;
>>  
>> @@ -3564,6 +3580,7 @@ static void rbd_img_object_requests(struct
>> rbd_img_request *img_req)
>>  			img_req->pending.num_pending++;
>>  		}
>>  	}
>> +	mutex_unlock(&img_req->object_mutex);
>>  }
>>  
>>  static bool rbd_img_advance(struct rbd_img_request *img_req, int
>> *result)
> 
> Looks good to me. Just wonder how we escaped this for so long.
> 
> Reviewed-by: Laurence Oberman <loberman@redhat.com>
> 
The whole state machine is utterly fragile.
I'll be posting a patchset to clean stuff up somewhat,
but it's still a beast.
I'm rather surprised that it doesn't break more often ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
