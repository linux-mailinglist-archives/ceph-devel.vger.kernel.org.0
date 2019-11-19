Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C36101DD0
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 09:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfKSIhl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 03:37:41 -0500
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:2367 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfKSIhl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 03:37:41 -0500
Received: from yds-pc.domain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAB3A13RqdNddhbvAw--.92S2;
        Tue, 19 Nov 2019 16:37:37 +0800 (CST)
Subject: Re: [PATCH 2/9] rbd: introduce RBD_DEV_FLAG_READONLY
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
References: <20191118133816.3963-1-idryomov@gmail.com>
 <20191118133816.3963-3-idryomov@gmail.com>
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
Message-ID: <5DD3A9D0.6010708@easystack.cn>
Date:   Tue, 19 Nov 2019 16:37:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.0
MIME-Version: 1.0
In-Reply-To: <20191118133816.3963-3-idryomov@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: u+CowAB3A13RqdNddhbvAw--.92S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw4rJw18WFyUCw4UtFyxKrg_yoW5ZF45pa
        y8Ja95tFW7JrnF9a18Jan8XF1rXa18t3yDuryYkw1xGrn5Grs0yryxKa4YqrW7JFW7Ar4f
        tF45AFZ8AryjgFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR8-PUUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiHBFyelpchtO3ZQAAsE
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org



On 11/18/2019 09:38 PM, Ilya Dryomov wrote:
> rbd_dev->opts is not available for parent images, making checking
> rbd_dev->opts->read_only in various places (rbd_dev_image_probe(),
> need_exclusive_lock(), use_object_map() in the following patches)
> harder than it needs to be.
>
> Keeping rbd_dev_image_probe() in mind, move the initialization in
> do_rbd_add() up.  snap_id isn't filled in at that point, so replace
> rbd_is_snap() with a snap_name comparison.
>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>   drivers/block/rbd.c | 19 ++++++++++++++-----
>   1 file changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index cf2a7d094890..330d2789f373 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -464,6 +464,7 @@ struct rbd_device {
>   enum rbd_dev_flags {
>   	RBD_DEV_FLAG_EXISTS,	/* mapped snapshot has not been deleted */
>   	RBD_DEV_FLAG_REMOVING,	/* this mapping is being removed */
> +	RBD_DEV_FLAG_READONLY,  /* -o ro or snapshot */
>   };
>   
>   static DEFINE_MUTEX(client_mutex);	/* Serialize client creation */
> @@ -514,6 +515,11 @@ static int minor_to_rbd_dev_id(int minor)
>   	return minor >> RBD_SINGLE_MAJOR_PART_SHIFT;
>   }
>   
> +static bool rbd_is_ro(struct rbd_device *rbd_dev)
> +{
> +	return test_bit(RBD_DEV_FLAG_READONLY, &rbd_dev->flags);
> +}
> +
>   static bool rbd_is_snap(struct rbd_device *rbd_dev)
>   {
>   	return rbd_dev->spec->snap_id != CEPH_NOSNAP;
> @@ -6867,6 +6873,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
>   	__rbd_get_client(rbd_dev->rbd_client);
>   	rbd_spec_get(rbd_dev->parent_spec);
>   
> +	__set_bit(RBD_DEV_FLAG_READONLY, &parent->flags);
> +
>   	ret = rbd_dev_image_probe(parent, depth);
>   	if (ret < 0)
>   		goto out_err;
> @@ -6918,7 +6926,7 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
>   		goto err_out_blkdev;
>   
>   	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
> -	set_disk_ro(rbd_dev->disk, rbd_dev->opts->read_only);
> +	set_disk_ro(rbd_dev->disk, rbd_is_ro(rbd_dev));
>   
>   	ret = dev_set_name(&rbd_dev->dev, "%d", rbd_dev->dev_id);
>   	if (ret)
> @@ -7107,6 +7115,11 @@ static ssize_t do_rbd_add(struct bus_type *bus,
>   	ctx.rbd_spec = NULL;	/* rbd_dev now owns this */
>   	ctx.rbd_opts = NULL;	/* rbd_dev now owns this */
>   
> +	/* if we are mapping a snapshot it will be a read-only mapping */
> +	if (rbd_dev->opts->read_only ||
> +	    strcmp(rbd_dev->spec->snap_name, RBD_SNAP_HEAD_NAME))
> +		__set_bit(RBD_DEV_FLAG_READONLY, &rbd_dev->flags);
> +
>   	rbd_dev->config_info = kstrdup(buf, GFP_KERNEL);
>   	if (!rbd_dev->config_info) {
>   		rc = -ENOMEM;
> @@ -7120,10 +7133,6 @@ static ssize_t do_rbd_add(struct bus_type *bus,
>   		goto err_out_rbd_dev;
>   	}
>   
> -	/* If we are mapping a snapshot it must be marked read-only */
> -	if (rbd_is_snap(rbd_dev))
> -		rbd_dev->opts->read_only = true;
> -
>   	if (rbd_dev->opts->alloc_size > rbd_dev->layout.object_size) {
>   		rbd_warn(rbd_dev, "alloc_size adjusted to %u",
>   			 rbd_dev->layout.object_size);


