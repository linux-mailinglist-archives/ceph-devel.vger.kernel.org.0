Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAE45B427
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727162AbfGAFdk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:33:40 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22636 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfGAFdk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:33:40 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABXLGr+mRldE3zwAA--.1066S2;
        Mon, 01 Jul 2019 13:28:30 +0800 (CST)
Subject: Re: [PATCH 04/20] rbd: move OSD request submission into object
 request state machines
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-5-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D1999FD.3060904@easystack.cn>
Date:   Mon, 1 Jul 2019 13:28:29 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-5-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABXLGr+mRldE3zwAA--.1066S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr4kGw13Aw4xCF45ZF4fKrg_yoWxXryxpF
        WUtF4Yka1DJwnrJws5K3yDJr1rKF4xAry7X3yrt34xGa1kXFnakFyxGa4j9Fy7ArWrJF4x
        Kr4q9r93Ar42grDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRijjgUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbicB7kellZuqgKiAAAsg
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:40 PM, Ilya Dryomov wrote:
> Start eliminating asymmetry where the initial OSD request is allocated
> and submitted from outside the state machine, making error handling and
> restarts harder than they could be.  This commit deals with submission,
> a commit that deals with allocation will follow.
>
> Note that this commit adds parent chain recursion on the submission
> side:
>
>    rbd_img_request_submit
>      rbd_obj_handle_request
>        __rbd_obj_handle_request
>          rbd_obj_handle_read
>            rbd_obj_handle_write_guard
>              rbd_obj_read_from_parent
>                rbd_img_request_submit
>
> This will be fixed in the next commit.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>   drivers/block/rbd.c | 60 ++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 49 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 488da877a2bb..9c6be82353c0 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -223,7 +223,8 @@ enum obj_operation_type {
>   #define RBD_OBJ_FLAG_COPYUP_ENABLED		(1U << 1)
>   
>   enum rbd_obj_read_state {
> -	RBD_OBJ_READ_OBJECT = 1,
> +	RBD_OBJ_READ_START = 1,
> +	RBD_OBJ_READ_OBJECT,
>   	RBD_OBJ_READ_PARENT,
>   };
>   
> @@ -253,7 +254,8 @@ enum rbd_obj_read_state {
>    * even if there is a parent).
>    */
>   enum rbd_obj_write_state {
> -	RBD_OBJ_WRITE_OBJECT = 1,
> +	RBD_OBJ_WRITE_START = 1,
> +	RBD_OBJ_WRITE_OBJECT,
>   	RBD_OBJ_WRITE_READ_FROM_PARENT,
>   	RBD_OBJ_WRITE_COPYUP_EMPTY_SNAPC,
>   	RBD_OBJ_WRITE_COPYUP_OPS,
> @@ -284,6 +286,7 @@ struct rbd_obj_request {
>   
>   	struct ceph_osd_request	*osd_req;
>   
> +	struct mutex		state_mutex;
>   	struct kref		kref;
>   };
>   
> @@ -1560,6 +1563,7 @@ static struct rbd_obj_request *rbd_obj_request_create(void)
>   		return NULL;
>   
>   	ceph_object_extent_init(&obj_request->ex);
> +	mutex_init(&obj_request->state_mutex);
>   	kref_init(&obj_request->kref);
>   
>   	dout("%s %p\n", __func__, obj_request);
> @@ -1802,7 +1806,7 @@ static int rbd_obj_setup_read(struct rbd_obj_request *obj_req)
>   	rbd_osd_req_setup_data(obj_req, 0);
>   
>   	rbd_osd_req_format_read(obj_req);
> -	obj_req->read_state = RBD_OBJ_READ_OBJECT;
> +	obj_req->read_state = RBD_OBJ_READ_START;
>   	return 0;
>   }
>   
> @@ -1885,7 +1889,7 @@ static int rbd_obj_setup_write(struct rbd_obj_request *obj_req)
>   			return ret;
>   	}
>   
> -	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> +	obj_req->write_state = RBD_OBJ_WRITE_START;
>   	__rbd_obj_setup_write(obj_req, which);
>   	return 0;
>   }
> @@ -1943,7 +1947,7 @@ static int rbd_obj_setup_discard(struct rbd_obj_request *obj_req)
>   				       off, next_off - off, 0, 0);
>   	}
>   
> -	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> +	obj_req->write_state = RBD_OBJ_WRITE_START;
>   	rbd_osd_req_format_write(obj_req);
>   	return 0;
>   }
> @@ -2022,7 +2026,7 @@ static int rbd_obj_setup_zeroout(struct rbd_obj_request *obj_req)
>   			return ret;
>   	}
>   
> -	obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> +	obj_req->write_state = RBD_OBJ_WRITE_START;
>   	__rbd_obj_setup_zeroout(obj_req, which);
>   	return 0;
>   }
> @@ -2363,11 +2367,17 @@ static void rbd_img_request_submit(struct rbd_img_request *img_request)
>   
>   	rbd_img_request_get(img_request);
>   	for_each_obj_request(img_request, obj_request)
> -		rbd_obj_request_submit(obj_request);
> +		rbd_obj_handle_request(obj_request, 0);
>   
>   	rbd_img_request_put(img_request);
>   }
>   
> +static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
> +{
> +	rbd_obj_request_submit(obj_req);
> +	return 0;
always return 0? So if I understand it correctly, this function will be 
filled by other operations in later commits, right?
> +}
> +
>   static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
>   {
>   	struct rbd_img_request *img_req = obj_req->img_request;
> @@ -2415,12 +2425,22 @@ static int rbd_obj_read_from_parent(struct rbd_obj_request *obj_req)
>   	return 0;
>   }
>   
> -static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
> +static bool rbd_obj_advance_read(struct rbd_obj_request *obj_req, int *result)
>   {
>   	struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
>   	int ret;
>   
>   	switch (obj_req->read_state) {
> +	case RBD_OBJ_READ_START:
> +		rbd_assert(!*result);
> +
> +		ret = rbd_obj_read_object(obj_req);
> +		if (ret) {
> +			*result = ret;
> +			return true;
> +		}
> +		obj_req->read_state = RBD_OBJ_READ_OBJECT;
> +		return false;
>   	case RBD_OBJ_READ_OBJECT:
>   		if (*result == -ENOENT && rbd_dev->parent_overlap) {
>   			/* reverse map this object extent onto the parent */
> @@ -2464,6 +2484,12 @@ static bool rbd_obj_handle_read(struct rbd_obj_request *obj_req, int *result)
>   	}
>   }
>   
> +static int rbd_obj_write_object(struct rbd_obj_request *obj_req)
> +{
> +	rbd_obj_request_submit(obj_req);
> +	return 0;
> +}
> +
>   /*
>    * copyup_bvecs pages are never highmem pages
>    */
> @@ -2661,11 +2687,21 @@ static int rbd_obj_handle_write_guard(struct rbd_obj_request *obj_req)
>   	return rbd_obj_read_from_parent(obj_req);
>   }
>   
> -static bool rbd_obj_handle_write(struct rbd_obj_request *obj_req, int *result)
> +static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
>   {
>   	int ret;
>   
>   	switch (obj_req->write_state) {
> +	case RBD_OBJ_WRITE_START:
> +		rbd_assert(!*result);
> +
> +		ret = rbd_obj_write_object(obj_req);
> +		if (ret) {
> +			*result = ret;
> +			return true;
> +		}
> +		obj_req->write_state = RBD_OBJ_WRITE_OBJECT;
> +		return false;
>   	case RBD_OBJ_WRITE_OBJECT:
>   		if (*result == -ENOENT) {
>   			if (obj_req->flags & RBD_OBJ_FLAG_COPYUP_ENABLED) {
> @@ -2722,10 +2758,12 @@ static bool __rbd_obj_handle_request(struct rbd_obj_request *obj_req,
>   	struct rbd_img_request *img_req = obj_req->img_request;
>   	bool done;
>   
> +	mutex_lock(&obj_req->state_mutex);
>   	if (!rbd_img_is_write(img_req))
> -		done = rbd_obj_handle_read(obj_req, result);
> +		done = rbd_obj_advance_read(obj_req, result);
>   	else
> -		done = rbd_obj_handle_write(obj_req, result);
> +		done = rbd_obj_advance_write(obj_req, result);
> +	mutex_unlock(&obj_req->state_mutex);
Okey, looks this lock can solve the race condition problem I mentioned 
in 02/20.

Thanx
>   
>   	return done;
>   }


