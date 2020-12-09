Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 142842D3906
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 03:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgLICyc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 21:54:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727012AbgLICy3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 21:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607482383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cFNY6oR+hixdAWaVKQm4SgGYUWW8X4hMf/ko6NanEgg=;
        b=Cds9MCj9zTNt580aj687JYv2uwlK5g/aR20yGlmmdtjQQ8+tKgvuFWdJV1LsocXv/28VcK
        /KYUMnw+oiGqXaPplN3xLz3EK+1EmmIj4t4tCd+opZU5UXKi3tffzp4eiheDtZYt7pmync
        AZKp5i63jN2t4bM8pUmU+4MGKYGD0m0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-q6C_rUbMONuOm0y1RKtmGw-1; Tue, 08 Dec 2020 21:52:59 -0500
X-MC-Unique: q6C_rUbMONuOm0y1RKtmGw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A816107ACE3;
        Wed,  9 Dec 2020 02:52:57 +0000 (UTC)
Received: from T590 (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84BED6064B;
        Wed,  9 Dec 2020 02:52:41 +0000 (UTC)
Date:   Wed, 9 Dec 2020 10:52:36 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] rbd: remove the ->set_read_only method
Message-ID: <20201209025236.GE1217988@T590>
References: <20201208162829.2424563-1-hch@lst.de>
 <20201208162829.2424563-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208162829.2424563-6-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 05:28:28PM +0100, Christoph Hellwig wrote:
> Now that the hardware read-only state can't be changed by the BLKROSET
> ioctl, the code in this method is not required anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Acked-by: Ilya Dryomov <idryomov@gmail.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/block/rbd.c | 19 -------------------
>  1 file changed, 19 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 2ed79b09439a82..2c64ca15ca079f 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -692,29 +692,10 @@ static void rbd_release(struct gendisk *disk, fmode_t mode)
>  	put_device(&rbd_dev->dev);
>  }
>  
> -static int rbd_set_read_only(struct block_device *bdev, bool ro)
> -{
> -	struct rbd_device *rbd_dev = bdev->bd_disk->private_data;
> -
> -	/*
> -	 * Both images mapped read-only and snapshots can't be marked
> -	 * read-write.
> -	 */
> -	if (!ro) {
> -		if (rbd_is_ro(rbd_dev))
> -			return -EROFS;
> -
> -		rbd_assert(!rbd_is_snap(rbd_dev));
> -	}
> -
> -	return 0;
> -}
> -
>  static const struct block_device_operations rbd_bd_ops = {
>  	.owner			= THIS_MODULE,
>  	.open			= rbd_open,
>  	.release		= rbd_release,
> -	.set_read_only		= rbd_set_read_only,
>  };
>  
>  /*
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

