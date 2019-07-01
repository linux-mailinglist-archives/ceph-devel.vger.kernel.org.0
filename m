Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF005B43F
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 07:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfGAFfB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 01:35:01 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:24640 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfGAFfB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 1 Jul 2019 01:35:01 -0400
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAAnkXRRmhld7X7wAA--.1243S2;
        Mon, 01 Jul 2019 13:29:53 +0800 (CST)
Subject: Re: [PATCH 18/20] rbd: call rbd_dev_mapping_set() from
 rbd_dev_image_probe()
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20190625144111.11270-1-idryomov@gmail.com>
 <20190625144111.11270-19-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5D199A51.6080500@easystack.cn>
Date:   Mon, 1 Jul 2019 13:29:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20190625144111.11270-19-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAAnkXRRmhld7X7wAA--.1243S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjTRAjjkUUUUU
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiZxHkellZuk-83gAAs-
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 06/25/2019 10:41 PM, Ilya Dryomov wrote:
> Snapshot object map will be loaded in rbd_dev_image_probe(), so we need
> to know snapshot's size (as opposed to HEAD's size) sooner.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index c9f88b0cb730..671041b67957 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -6014,6 +6014,7 @@ static void rbd_dev_unprobe(struct rbd_device *rbd_dev)
>   	struct rbd_image_header	*header;
>   
>   	rbd_dev_parent_put(rbd_dev);
> +	rbd_dev_mapping_clear(rbd_dev);
>   
>   	/* Free dynamic fields from the header, then zero it out */
>   
> @@ -6114,7 +6115,6 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
>   static void rbd_dev_device_release(struct rbd_device *rbd_dev)
>   {
>   	clear_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
> -	rbd_dev_mapping_clear(rbd_dev);
>   	rbd_free_disk(rbd_dev);
>   	if (!single_major)
>   		unregister_blkdev(rbd_dev->major, rbd_dev->name);
> @@ -6148,23 +6148,17 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
>   	if (ret)
>   		goto err_out_blkdev;
>   
> -	ret = rbd_dev_mapping_set(rbd_dev);
> -	if (ret)
> -		goto err_out_disk;
> -
>   	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
>   	set_disk_ro(rbd_dev->disk, rbd_dev->opts->read_only);
>   
>   	ret = dev_set_name(&rbd_dev->dev, "%d", rbd_dev->dev_id);
>   	if (ret)
> -		goto err_out_mapping;
> +		goto err_out_disk;
>   
>   	set_bit(RBD_DEV_FLAG_EXISTS, &rbd_dev->flags);
>   	up_write(&rbd_dev->header_rwsem);
>   	return 0;
>   
> -err_out_mapping:
> -	rbd_dev_mapping_clear(rbd_dev);
>   err_out_disk:
>   	rbd_free_disk(rbd_dev);
>   err_out_blkdev:
> @@ -6265,6 +6259,10 @@ static int rbd_dev_image_probe(struct rbd_device *rbd_dev, int depth)
>   		goto err_out_probe;
>   	}
>   
> +	ret = rbd_dev_mapping_set(rbd_dev);
> +	if (ret)
> +		goto err_out_probe;
> +
>   	if (rbd_dev->header.features & RBD_FEATURE_LAYERING) {
>   		ret = rbd_dev_v2_parent_info(rbd_dev);
>   		if (ret)


