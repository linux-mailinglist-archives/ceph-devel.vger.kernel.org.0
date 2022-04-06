Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944214F5E55
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Apr 2022 14:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiDFMsS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Apr 2022 08:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiDFMrq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Apr 2022 08:47:46 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D72493770
        for <ceph-devel@vger.kernel.org>; Wed,  6 Apr 2022 01:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649235161; x=1680771161;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LFM3dJ4XtmmQmpjm/ADKwYliPf/iPacGMSt9/3x5IFU=;
  b=YwUb/pma4Lx1KNQVj+B9QWV49gGHqY/Qgm1sYd7FsGkEISZrqOZV1oey
   iP6+Oe4F0ZhrE6EwiVqYfzdGLWgg6MI5EL6LP0ZCl7nlJvIx7xx4jtnVL
   ScUECxvWLZGPJ5x3MNRY+6QoRTf5N8sssKBQPA2qoOTY0nu136AsvJ/5T
   Fo22MITSBugUYQRpHPiJ7PbuuU5rBKr90sm7SiOXRSX+pevKZufIeCN9o
   fJc+HywAkm/O0Az9was0+x0lk1Db4rTALT9aM88IsNZGXGWalJ1eRkOxd
   2EeRdWZj43Iqf9kgSzcQjw9AVDXyDtR78QTyGTYzhhlFKtJBskeZirQRI
   g==;
X-IronPort-AV: E=Sophos;i="5.90,239,1643644800"; 
   d="scan'208";a="197223417"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 16:52:41 +0800
IronPort-SDR: CoIUQ46u2VEk2FCvs5CeXbcSC0om7p4eqciDSDYKexfqQEuaBl3TLp+dPtl10FGYN3DuS05uGQ
 1JpUZui82GDzDGDLEXx/PJDYn2pPeiKsuGyUd3VJ+bEoUcW2GuiNczdeNwEJJRqmaCeuc2k6K7
 CLt4DOo9JCp9/iRYNEDf1fuITE2xRf5oStaaSlVNc4YWgGeiAoO8Gxwqi8qPY0YUgJeENIJS9Z
 nK/JcHnmF11MrGg8E2PZwLsiYVjaxtIrxlh8X62DXSKdclAa3lbFQ8UlQ4Yt3xMkDaeJDA/7/1
 QW5C5G6yI3CHEvo9AWDp43ts
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 01:24:13 -0700
IronPort-SDR: ZlKrV+9NXOVw3t9aTyJPL9oGQotmTv3FmVBBQfGQ5/R94Lk+vYeRUp3c7M7ZqbSR/Tfl5NPs2V
 rUei2OVIfSFOlebh4Ds/sVvPIrxOEN9SbYdMejfmDv9/9w+sLWhs0frLurgk4rIAros24djdL9
 ZNoEq8xxdPFiIkC3tXhy2tzKRAg4ybj7Nf1GFGsCb3g/IBCw5SRAhTAYclGerr0zok63I2gyLY
 Z0AoNGxp/bmjn6UZ4Vzk+oDBVO/o1k9zg7dX0cTNNbqVK6qd27TWIzwyxH5jECZ/hVsxcnEZxr
 iu4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Apr 2022 01:52:42 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KYJDm3kgWz1Rwrw
        for <ceph-devel@vger.kernel.org>; Wed,  6 Apr 2022 01:52:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649235159; x=1651827160; bh=LFM3dJ4XtmmQmpjm/ADKwYliPf/iPacGMSt
        9/3x5IFU=; b=ikqDdTG9ODAQQF/gXGSxdqGX933yPoUen760dZAYRlO1pjUicgY
        QNTmeVuFXL3991m5ocJlTZlAM/kL9Y+0/7Vqh369/+y1rd8dHIZCsirzcij49SEY
        lzAIBh2wf5Sf3ey+zlsq0uODq7OVssECPvEDwFf8vv6EXSj1/hUZOIgCb1YrW8o1
        2M9SVtb0B4XKp93g7XBI0ujENrB5hIjr3CO5qzrkEqkMATglY4o3RYlHRiXsW1Sz
        sYLuDt6RTZ47ylFhS4lgN/BBnpVQ7fdiQZnyYCU5qRit9Am3tawi9wutpwWz+FNF
        LQkskhLFb7giNbGTHrp0y0pi3f33Krg86Fg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 98BK2GiCYy7H for <ceph-devel@vger.kernel.org>;
        Wed,  6 Apr 2022 01:52:39 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KYJDg4WyPz1Rvlx;
        Wed,  6 Apr 2022 01:52:35 -0700 (PDT)
Message-ID: <ea3d14cb-00ea-8d7b-4615-9347fdd7aa27@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 17:52:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 14/27] block: add a bdev_max_zone_append_sectors helper
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
References: <20220406060516.409838-1-hch@lst.de>
 <20220406060516.409838-15-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220406060516.409838-15-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 4/6/22 15:05, Christoph Hellwig wrote:
> Add a helper to check the max supported sectors for zone append based on
> the block_device instead of having to poke into the block layer internal
> request_queue.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/nvme/target/zns.c | 3 +--
>   fs/zonefs/super.c         | 3 +--
>   include/linux/blkdev.h    | 6 ++++++
>   3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/nvme/target/zns.c b/drivers/nvme/target/zns.c
> index e34718b095504..82b61acf7a72b 100644
> --- a/drivers/nvme/target/zns.c
> +++ b/drivers/nvme/target/zns.c
> @@ -34,8 +34,7 @@ static int validate_conv_zones_cb(struct blk_zone *z,
>   
>   bool nvmet_bdev_zns_enable(struct nvmet_ns *ns)
>   {
> -	struct request_queue *q = ns->bdev->bd_disk->queue;
> -	u8 zasl = nvmet_zasl(queue_max_zone_append_sectors(q));
> +	u8 zasl = nvmet_zasl(bdev_max_zone_append_sectors(ns->bdev));
>   	struct gendisk *bd_disk = ns->bdev->bd_disk;
>   	int ret;
>   
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 3614c7834007d..7a63807b736c4 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -678,13 +678,12 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
>   	struct inode *inode = file_inode(iocb->ki_filp);
>   	struct zonefs_inode_info *zi = ZONEFS_I(inode);
>   	struct block_device *bdev = inode->i_sb->s_bdev;
> -	unsigned int max;
> +	unsigned int max = bdev_max_zone_append_sectors(bdev);
>   	struct bio *bio;
>   	ssize_t size;
>   	int nr_pages;
>   	ssize_t ret;
>   
> -	max = queue_max_zone_append_sectors(bdev_get_queue(bdev));
>   	max = ALIGN_DOWN(max << SECTOR_SHIFT, inode->i_sb->s_blocksize);
>   	iov_iter_truncate(from, max);
>   
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index a433798c3343e..f8c50b77543eb 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1188,6 +1188,12 @@ static inline unsigned int queue_max_zone_append_sectors(const struct request_qu
>   	return min(l->max_zone_append_sectors, l->max_sectors);
>   }
>   
> +static inline unsigned int
> +bdev_max_zone_append_sectors(struct block_device *bdev)
> +{
> +	return queue_max_zone_append_sectors(bdev_get_queue(bdev));
> +}
> +
>   static inline unsigned queue_logical_block_size(const struct request_queue *q)
>   {
>   	int retval = 512;

Looks good.

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
