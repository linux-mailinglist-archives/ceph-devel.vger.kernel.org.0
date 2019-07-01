Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A97E5B432
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbfGAFe0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:34:26 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:23795 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfGAFe0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:34:26 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowACXibAsmhldtX3wAA--.1291S2;
        Mon, 01 Jul 2019 13:29:17 +0800 (CST)
Subject: Re: [PATCH 12/20] rbd: lock should be quiesced on reacquire
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-13-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A2C.6070905@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-13-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowACXibAsmhldtX3wAA--.1291S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF4DWrWftFyDGr45WFW8Xrb_yoWrGF1UpF
        Wxta45tFWjgr12gw17ZFs8Zr1rX3Wvg3s8WryIy3srCFn5JrZrGryIkFy0yrWUXry7AFs7
        Jr45JFs5Ar4jvrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR78n7UUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbibQ3kellZul2XTQAAsD
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> Quiesce exclusive lock at the top of rbd_reacquire_lock() instead
> of only when ceph_cls_set_cookie() fails.  This avoids a deadlock on
> rbd_dev->lock_rwsem.
>
> If rbd_dev->lock_rwsem is needed for I/O completion, set_cookie can
> hang ceph-msgr worker thread if set_cookie reply ends up behind an I/O
> reply, because, like lock and unlock requests, set_cookie is sent and
> waited upon with rbd_dev->lock_rwsem held for write.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 35 +++++++++++++++++++++--------------
>   1 file changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 34bd45d336e6..5fcb4ebd981a 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -3004,6 +3004,7 @@ static void __rbd_lock(struct rbd_device *rbd_dev, const char *cookie)
>   {
>   	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
>   
> +	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
>   	strcpy(rbd_dev->lock_cookie, cookie);
>   	rbd_set_owner_cid(rbd_dev, &cid);
>   	queue_work(rbd_dev->task_wq, &rbd_dev->acquired_lock_work);
> @@ -3028,7 +3029,6 @@ static int rbd_lock(struct rbd_device *rbd_dev)
>   	if (ret)
>   		return ret;
>   
> -	rbd_dev->lock_state = RBD_LOCK_STATE_LOCKED;
>   	__rbd_lock(rbd_dev, cookie);
>   	return 0;
>   }
> @@ -3411,13 +3411,11 @@ static void rbd_acquire_lock(struct work_struct *work)
>   	}
>   }
>   
> -/*
> - * lock_rwsem must be held for write
> - */
> -static bool rbd_release_lock(struct rbd_device *rbd_dev)
> +static bool rbd_quiesce_lock(struct rbd_device *rbd_dev)
>   {
> -	dout("%s rbd_dev %p read lock_state %d\n", __func__, rbd_dev,
> -	     rbd_dev->lock_state);
> +	dout("%s rbd_dev %p\n", __func__, rbd_dev);
> +	lockdep_assert_held_exclusive(&rbd_dev->lock_rwsem);
> +
>   	if (rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED)
>   		return false;
>   
> @@ -3433,12 +3431,22 @@ static bool rbd_release_lock(struct rbd_device *rbd_dev)
>   	up_read(&rbd_dev->lock_rwsem);
>   
>   	down_write(&rbd_dev->lock_rwsem);
> -	dout("%s rbd_dev %p write lock_state %d\n", __func__, rbd_dev,
> -	     rbd_dev->lock_state);
>   	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
>   		return false;
>   
> +	return true;
> +}
> +
> +/*
> + * lock_rwsem must be held for write
> + */
> +static void rbd_release_lock(struct rbd_device *rbd_dev)
> +{
> +	if (!rbd_quiesce_lock(rbd_dev))
> +		return;
> +
>   	rbd_unlock(rbd_dev);
> +
>   	/*
>   	 * Give others a chance to grab the lock - we would re-acquire
>   	 * almost immediately if we got new IO during ceph_osdc_sync()
> @@ -3447,7 +3455,6 @@ static bool rbd_release_lock(struct rbd_device *rbd_dev)
>   	 * after wake_requests() in rbd_handle_released_lock().
>   	 */
>   	cancel_delayed_work(&rbd_dev->lock_dwork);
> -	return true;
>   }
>   
>   static void rbd_release_lock_work(struct work_struct *work)
> @@ -3795,7 +3802,8 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
>   	char cookie[32];
>   	int ret;
>   
> -	WARN_ON(rbd_dev->lock_state != RBD_LOCK_STATE_LOCKED);
> +	if (!rbd_quiesce_lock(rbd_dev))
> +		return;
>   
>   	format_lock_cookie(rbd_dev, cookie);
>   	ret = ceph_cls_set_cookie(osdc, &rbd_dev->header_oid,
> @@ -3811,9 +3819,8 @@ static void rbd_reacquire_lock(struct rbd_device *rbd_dev)
>   		 * Lock cookie cannot be updated on older OSDs, so do
>   		 * a manual release and queue an acquire.
>   		 */
> -		if (rbd_release_lock(rbd_dev))
> -			queue_delayed_work(rbd_dev->task_wq,
> -					   &rbd_dev->lock_dwork, 0);
> +		rbd_unlock(rbd_dev);
> +		queue_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
>   	} else {
>   		__rbd_lock(rbd_dev, cookie);
>   	}


