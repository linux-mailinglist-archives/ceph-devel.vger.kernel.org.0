Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F422D3901
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 03:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLICxN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 21:53:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24848 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgLICxN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 21:53:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607482307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8pDCkiQqUQi4Q65srKJy8fmgGe7yBxTF+/wHQ2CwMUo=;
        b=ZMZjI67tYrQ4keVRGRzw7Pfc1eghKGupuY/+dzAdyDQKzqVIjSPNTIuEnZF/iaxklGafIt
        bjY2R+cnkS76UDQaxYR9+mlJf3RqpgDWts66Tgf6FAKFUJ1xm2Iadb1alpfI3+mkTcALVE
        x6Rp151v8MuE8Ewsk4FFetfAizhujhU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-4E9pikj7Phyndmk0FTVmHw-1; Tue, 08 Dec 2020 21:51:43 -0500
X-MC-Unique: 4E9pikj7Phyndmk0FTVmHw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A1F0801FD4;
        Wed,  9 Dec 2020 02:51:41 +0000 (UTC)
Received: from T590 (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40E645D6AB;
        Wed,  9 Dec 2020 02:51:25 +0000 (UTC)
Date:   Wed, 9 Dec 2020 10:51:21 +0800
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
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 4/6] block: propagate BLKROSET on the whole device to all
 partitions
Message-ID: <20201209025121.GD1217988@T590>
References: <20201208162829.2424563-1-hch@lst.de>
 <20201208162829.2424563-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208162829.2424563-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 05:28:27PM +0100, Christoph Hellwig wrote:
> Change the policy so that a BLKROSET on the whole device also affects
> partitions.  To quote Martin K. Petersen:
> 
> It's very common for database folks to twiddle the read-only state of
> block devices and partitions. I know that our users will find it very
> counter-intuitive that setting /dev/sda read-only won't prevent writes
> to /dev/sda1.
> 
> The existing behavior is inconsistent in the sense that doing:
> 
>   # blockdev --setro /dev/sda
>   # echo foo > /dev/sda1
> 
> permits writes. But:
> 
>   # blockdev --setro /dev/sda
>   <something triggers revalidate>
>   # echo foo > /dev/sda1
> 
> doesn't.
> 
> And a subsequent:
> 
>   # blockdev --setrw /dev/sda
>   # echo foo > /dev/sda1
> 
> doesn't work either since sda1's read-only policy has been inherited
> from the whole-disk device.
> 
> You need to do:
> 
>   # blockdev --rereadpt
> 
> after setting the whole-disk device rw to effectuate the same change on
> the partitions, otherwise they are stuck being read-only indefinitely.
> 
> However, setting the read-only policy on a partition does *not* require
> the revalidate step. As a matter of fact, doing the revalidate will blow
> away the policy setting you just made.
> 
> So the user needs to take different actions depending on whether they
> are trying to read-protect a whole-disk device or a partition. Despite
> using the same ioctl. That is really confusing.
> 
> I have lost count how many times our customers have had data clobbered
> because of ambiguity of the existing whole-disk device policy. The
> current behavior violates the principle of least surprise by letting the
> user think they write protected the whole disk when they actually
> didn't.
> 
> Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  block/genhd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index d9f989c1514123..6e51ecb9280aca 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1656,8 +1656,7 @@ EXPORT_SYMBOL(set_disk_ro);
>  
>  int bdev_read_only(struct block_device *bdev)
>  {
> -	return bdev->bd_read_only ||
> -		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
> +	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
>  }
>  EXPORT_SYMBOL(bdev_read_only);
>  
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

