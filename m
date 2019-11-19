Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B63A101DDA
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfKSIiE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:38:04 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:3261 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfKSIiD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:38:03 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADXM13nqdNdihfvAw--.126S2;
        Tue, 19 Nov 2019 16:37:59 +0800 (CST)
Subject: Re: [PATCH 7/9] rbd: remove snapshot existence validation code
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-8-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3A9E7.3040503@easystack.cn>
Date:   Tue, 19 Nov 2019 16:37:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-8-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowADXM13nqdNdihfvAw--.126S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw1DKFWDWF1fXryDXrykGrg_yoW5uFWxpa
        yfGa43tFWxGr1293WUXrn8tFyUWF4DJ3yDu3s0kas3CFnY9r1qyr97Ka4FqrW7J348Xr48
        JF45CFZxCr1j9rDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRSoGdUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiZgdyellZuvW1qwAAs4
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> RBD_DEV_FLAG_EXISTS check in rbd_queue_workfn() is racy and leads to
> inconsistent behaviour.  If the object (or its snapshot) isn't there,
> the OSD returns ENOENT.  A read submitted before the snapshot removal
> notification is processed would be zero-filled and ended with status
> OK, while future reads would be failed with IOERR.  It also doesn't
> handle a case when an image that is mapped read-only is removed.
>
> On top of this, because watch is no longer established for read-only
> mappings, we no longer get notifications, so rbd_exists_validate() is
> effectively dead code.  While failing requests rather than returning
> zeros is a good thing, RBD_DEV_FLAG_EXISTS is not it.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 42 +++---------------------------------------
>   1 file changed, 3 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index bfff195e8e23..aba60e37b058 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -462,7 +462,7 @@ struct rbd_device {
>    *   by rbd_dev->lock
>    */
>   enum rbd_dev_flags {
> -	RBD_DEV_FLAG_EXISTS,	/* mapped snapshot has not been deleted */
> +	RBD_DEV_FLAG_EXISTS,	/* rbd_dev_device_setup() ran */
>   	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
>   	RBD_DEV_FLAG_READONLY,  /* -o ro or snapshot */
>   };
> @@ -4848,19 +4848,6 @@ static void rbd_queue_workfn(struct work_struct *work)
>   		rbd_assert(!rbd_is_snap(rbd_dev));
>   	}
>   
> -	/*
> -	 * Quit early if the mapped snapshot no longer exists.  It's
> -	 * still possible the snapshot will have disappeared by the
> -	 * time our request arrives at the osd, but there's no sense in
> -	 * sending it if we already know.
> -	 */
> -	if (!test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags)) {
> -		dout("request for non-existent snapshot");
> -		rbd_assert(rbd_is_snap(rbd_dev));
> -		result = -ENXIO;
> -		goto err_rq;
> -	}
> -
>   	if (offset && length > U64_MAX - offset + 1) {
>   		rbd_warn(rbd_dev, "bad request range (%llu~%llu)", offset,
>   			 length);
> @@ -5040,25 +5027,6 @@ static int rbd_dev_v1_header_info(struct rbd_device *rbd_dev)
>   	return ret;
>   }
>   
> -/*
> - * Clear the rbd device's EXISTS flag if the snapshot it's mapped to
> - * has disappeared from the (just updated) snapshot context.
> - */
> -static void rbd_exists_validate(struct rbd_device *rbd_dev)
> -{
> -	u64 snap_id;
> -
> -	if (!test_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags))
> -		return;
> -
> -	snap_id = rbd_dev->spec->snap_id;
> -	if (snap_id == CEPH_NOSNAP)
> -		return;
> -
> -	if (rbd_dev_snap_index(rbd_dev, snap_id) == BAD_SNAP_INDEX)
> -		clear_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
> -}
> -
>   static void rbd_dev_update_size(struct rbd_device *rbd_dev)
>   {
>   	sector_t size;
> @@ -5099,12 +5067,8 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
>   			goto out;
>   	}
>   
> -	if (!rbd_is_snap(rbd_dev)) {
> -		rbd_dev->mapping.size = rbd_dev->header.image_size;
> -	} else {
> -		/* validate mapped snapshot's EXISTS flag */
> -		rbd_exists_validate(rbd_dev);
> -	}
> +	rbd_assert(!rbd_is_snap(rbd_dev));
> +	rbd_dev->mapping.size = rbd_dev->header.image_size;
>   
>   out:
>   	up_write(&rbd_dev->header_rwsem);


