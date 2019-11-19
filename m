Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 988EC101DD4
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfKSIhu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:37:50 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:2723 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbfKSIhu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:37:50 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowABnbV7aqdNd+RbvAw--.116S2;
        Tue, 19 Nov 2019 16:37:46 +0800 (CST)
Subject: Re: [PATCH 4/9] rbd: disallow read-write partitions on images mapped
 read-only
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-5-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3A9DA.8050108@easystack.cn>
Date:   Tue, 19 Nov 2019 16:37:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-5-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowABnbV7aqdNd+RbvAw--.116S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjfUU_MaDUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiKBpyelz4rO7ijQAAsz
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> If an image is mapped read-only, don't allow setting its partition(s)
> to read-write via BLKROSET: with the previous patch all writes to such
> images are failed anyway.
>
> If an image is mapped read-write, its partition(s) can be set to
> read-only (and back to read-write) as before.  Note that at the rbd
> level the image will remain writeable: anything sent down by the block
> layer will be executed, including any write from internal kernel users.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 842b92ef2c06..979203cd934c 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -706,9 +706,16 @@ static int rbd_ioctl_set_ro(struct rbd_device *rbd_dev, unsigned long arg)
>   	if (get_user(ro, (int __user *)arg))
>   		return -EFAULT;
>   
> -	/* Snapshots can't be marked read-write */
> -	if (rbd_is_snap(rbd_dev) && !ro)
> -		return -EROFS;
> +	/*
> +	 * Both images mapped read-only and snapshots can't be marked
> +	 * read-write.
> +	 */
> +	if (!ro) {
> +		if (rbd_is_ro(rbd_dev))
> +			return -EROFS;
> +
> +		rbd_assert(!rbd_is_snap(rbd_dev));
> +	}
>   
>   	/* Let blkdev_roset() handle it */
>   	return -ENOTTY;


