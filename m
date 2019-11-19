Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF12101DCF
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKSIhg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:37:36 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:2252 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfKSIhg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:37:36 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACXr1_OqdNdVRbvAw--.126S2;
        Tue, 19 Nov 2019 16:37:34 +0800 (CST)
Subject: Re: [PATCH 1/9] rbd: introduce rbd_is_snap()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-2-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3A9CD.4010801@easystack.cn>
Date:   Tue, 19 Nov 2019 16:37:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-2-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACXr1_OqdNdVRbvAw--.126S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw15XFy7WF17ArWfKF13twb_yoW5uFWxpF
        W8Xay5tFW8Gr4I9a1kXrn0qryUWa10q3srW3s8C3WfAwn5KrsYyr1IkFyUtFW7JFWqyr4k
        ZF45JrW5Ar40krDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRDGYXUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiGw5yelpcg-S3MwAAso
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2aaa56e4cec9..cf2a7d094890 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -514,6 +514,11 @@ static int minor_to_rbd_dev_id(int minor)
>   	return minor >> RBD_SINGLE_MAJOR_PART_SHIFT;
>   }
>   
> +static bool rbd_is_snap(struct rbd_device *rbd_dev)
> +{
> +	return rbd_dev->spec->snap_id != CEPH_NOSNAP;
> +}
> +
>   static bool __rbd_is_lock_owner(struct rbd_device *rbd_dev)
>   {
>   	lockdep_assert_held(&rbd_dev->lock_rwsem);
> @@ -696,7 +701,7 @@ static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
>   		return -EFAULT;
>   
>   	/* Snapshots can't be marked read-write */
> -	if (rbd_dev->spec->snap_id != CEPH_NOSNAP && !ro)
> +	if (rbd_is_snap(rbd_dev) && !ro)
>   		return -EROFS;
>   
>   	/* Let blkdev_roset() handle it */
> @@ -3538,7 +3543,7 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
>   	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK))
>   		return false;
>   
> -	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
> +	if (rbd_is_snap(rbd_dev))
>   		return false;
>   
>   	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
> @@ -4809,7 +4814,7 @@ static void rbd_queue_workfn(struct work_struct *work)
>   		goto err_rq;
>   	}
>   
> -	if (op_type != OBJ_OP_READ && rbd_dev->spec->snap_id != CEPH_NOSNAP) {
> +	if (op_type != OBJ_OP_READ && rbd_is_snap(rbd_dev)) {
>   		rbd_warn(rbd_dev, "%s on read-only snapshot",
>   			 obj_op_name(op_type));
>   		result = -EIO;
> @@ -4824,7 +4829,7 @@ static void rbd_queue_workfn(struct work_struct *work)
>   	 */
>   	if (!test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags)) {
>   		dout("request for non-existent snapshot");
> -		rbd_assert(rbd_dev->spec->snap_id != CEPH_NOSNAP);
> +		rbd_assert(rbd_is_snap(rbd_dev));
>   		result = -ENXIO;
>   		goto err_rq;
>   	}
> @@ -5067,7 +5072,7 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>   			goto out;
>   	}
>   
> -	if (rbd_dev->spec->snap_id == CEPH_NOSNAP) {
> +	if (!rbd_is_snap(rbd_dev)) {
>   		rbd_dev->mapping.size = rbd_dev->header.image_size;
>   	} else {
>   		/* validate mapped snapshot's EXISTS flag */
> @@ -6656,7 +6661,7 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
>   		return -EINVAL;
>   	}
>   
> -	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
> +	if (rbd_is_snap(rbd_dev))
>   		return 0;
>   
>   	rbd_assert(!rbd_is_lock_owner(rbd_dev));
> @@ -7027,7 +7032,7 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
>   	if (ret)
>   		goto err_out_probe;
>   
> -	if (rbd_dev->spec->snap_id != CEPH_NOSNAP &&
> +	if (rbd_is_snap(rbd_dev) &&
>   	    (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP)) {
>   		ret = rbd_object_map_load(rbd_dev);
>   		if (ret)
> @@ -7116,7 +7121,7 @@ static ssize_t do_rbd_add(struct bus_type *bus,
>   	}
>   
>   	/* If we are mapping a snapshot it must be marked read-only */
> -	if (rbd_dev->spec->snap_id != CEPH_NOSNAP)
> +	if (rbd_is_snap(rbd_dev))
>   		rbd_dev->opts->read_only = true;
>   
>   	if (rbd_dev->opts->alloc_size > rbd_dev->layout.object_size) {


