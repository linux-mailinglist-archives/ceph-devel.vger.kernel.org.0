Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A75101DD5
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfKSIhw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:37:52 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:2846 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfKSIhw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:37:52 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAXF1feqdNdGhfvAw--.94S2;
        Tue, 19 Nov 2019 16:37:50 +0800 (CST)
Subject: Re: [PATCH 5/9] rbd: don't acquire exclusive lock for read-only
 mappings
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-6-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3A9DE.9080905@easystack.cn>
Date:   Tue, 19 Nov 2019 16:37:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-6-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAXF1feqdNdGhfvAw--.94S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUUBT5DUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiaB5yellZu4lmWgAAsw
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> A read-only mapping should be usable with read-only OSD caps, so
> neither the header lock nor the object map lock can be acquired.
> Unfortunately, this means that images mapped read-only lose the
> advantage of the object map.
>
> Snapshots, however, can take advantage of the object map without
> any exclusionary locks, so if the object map is desired, snapshot
> the image and map the snapshot instead of the image.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 979203cd934c..aaa359561356 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1833,6 +1833,17 @@ static u8 rbd_object_map_get(struct rbd_device *rbd_dev, u64 objno)
>   
>   static bool use_object_map(struct rbd_device *rbd_dev)
>   {
> +	/*
> +	 * An image mapped read-only can't use the object map -- it isn't
> +	 * loaded because the header lock isn't acquired.  Someone else can
> +	 * write to the image and update the object map behind our back.
> +	 *
> +	 * A snapshot can't be written to, so using the object map is always
> +	 * safe.
> +	 */
> +	if (!rbd_is_snap(rbd_dev) && rbd_is_ro(rbd_dev))
> +		return false;
> +
>   	return ((rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) &&
>   		!(rbd_dev->object_map_flags & RBD_FLAG_OBJECT_MAP_INVALID));
>   }
> @@ -3556,7 +3567,7 @@ static bool need_exclusive_lock(struct rbd_img_request *img_req)
>   	if (!(rbd_dev->header.features & RBD_FEATURE_EXCLUSIVE_LOCK))
>   		return false;
>   
> -	if (rbd_is_snap(rbd_dev))
> +	if (rbd_is_ro(rbd_dev))
>   		return false;
>   
>   	rbd_assert(!test_bit(IMG_REQ_CHILD, &img_req->flags));
> @@ -6677,7 +6688,7 @@ static int rbd_add_acquire_lock(struct rbd_device *rbd_dev)
>   		return -EINVAL;
>   	}
>   
> -	if (rbd_is_snap(rbd_dev))
> +	if (rbd_is_ro(rbd_dev))
>   		return 0;
>   
>   	rbd_assert(!rbd_is_lock_owner(rbd_dev));


