Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF742D3028
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 17:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgLHQsT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 11:48:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:41052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729966AbgLHQsT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 11:48:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C329AD21;
        Tue,  8 Dec 2020 16:47:37 +0000 (UTC)
Subject: Re: [PATCH 4/6] block: propagate BLKROSET on the whole device to all
 partitions
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20201208162829.2424563-1-hch@lst.de>
 <20201208162829.2424563-5-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8df170f5-3000-7eba-0482-0066cc24ae71@suse.de>
Date:   Tue, 8 Dec 2020 17:47:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208162829.2424563-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 12/8/20 5:28 PM, Christoph Hellwig wrote:
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
>    # blockdev --setro /dev/sda
>    # echo foo > /dev/sda1
> 
> permits writes. But:
> 
>    # blockdev --setro /dev/sda
>    <something triggers revalidate>
>    # echo foo > /dev/sda1
> 
> doesn't.
> 
> And a subsequent:
> 
>    # blockdev --setrw /dev/sda
>    # echo foo > /dev/sda1
> 
> doesn't work either since sda1's read-only policy has been inherited
> from the whole-disk device.
> 
> You need to do:
> 
>    # blockdev --rereadpt
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
>   block/genhd.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index d9f989c1514123..6e51ecb9280aca 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1656,8 +1656,7 @@ EXPORT_SYMBOL(set_disk_ro);
>   
>   int bdev_read_only(struct block_device *bdev)
>   {
> -	return bdev->bd_read_only ||
> -		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
> +	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
>   }
>   EXPORT_SYMBOL(bdev_read_only);
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
