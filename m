Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAD0B2D28C2
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 11:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbgLHKYF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 05:24:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57959 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728312AbgLHKYF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 05:24:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607422958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CbRwXof5BfleheY9ylmF59cZ8VjqZIDWfRUHUpV3i68=;
        b=X9n+aHCSpDQudSgBodpLHQveaPVmfxYjf0sXWTMqVSt61ng6vQH3P5Sg+IUsvvRfE673af
        qNUKZJa9K11wS5tRA0WAw8vxWOW9IT6KYWFyNxSH41sjYUPwPcKXnLgieVVon7TAG8iQW8
        lJmmuSz6GRjV8k441euadb6frOpBFAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-BAOAnsQvOaSGOX-DanZ9aA-1; Tue, 08 Dec 2020 05:22:35 -0500
X-MC-Unique: BAOAnsQvOaSGOX-DanZ9aA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F36BC107ACE6;
        Tue,  8 Dec 2020 10:22:33 +0000 (UTC)
Received: from T590 (ovpn-12-237.pek2.redhat.com [10.72.12.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F6B260636;
        Tue,  8 Dec 2020 10:22:15 +0000 (UTC)
Date:   Tue, 8 Dec 2020 18:22:11 +0800
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
Subject: Re: [PATCH 3/6] block: add a hard-readonly flag to struct gendisk
Message-ID: <20201208102211.GC1202995@T590>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207131918.2252553-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 07, 2020 at 02:19:15PM +0100, Christoph Hellwig wrote:
> Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
> partition") addressed a long-standing problem with user read-only
> policy being overridden as a result of a device-initiated revalidate.
> The commit has since been reverted due to a regression that left some
> USB devices read-only indefinitely.
> 
> To fix the underlying problems with revalidate we need to keep track
> of hardware state and user policy separately.
> 
> The gendisk has been updated to reflect the current hardware state set
> by the device driver. This is done to allow returning the device to
> the hardware state once the user clears the BLKROSET flag.
> 
> The resulting semantics are as follows:
> 
>  - If BLKROSET sets a given partition read-only, that partition will
>    remain read-only even if the underlying storage stack initiates a
>    revalidate. However, the BLKRRPART ioctl will cause the partition
>    table to be dropped and any user policy on partitions will be lost.
> 
>  - If BLKROSET has not been set, both the whole disk device and any
>    partitions will reflect the current write-protect state of the
>    underlying device.
> 
> Based on a patch from Martin K. Petersen <martin.petersen@oracle.com>.
> 
> Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  block/blk-core.c        |  2 +-
>  block/genhd.c           | 33 +++++++++++++++++++--------------
>  block/partitions/core.c |  3 +--
>  include/linux/genhd.h   |  6 ++++--
>  4 files changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index ad041e903b0a8f..ecd68415c6acad 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -693,7 +693,7 @@ static inline bool should_fail_request(struct block_device *part,
>  
>  static inline bool bio_check_ro(struct bio *bio)
>  {
> -	if (op_is_write(bio_op(bio)) && bio->bi_bdev->bd_read_only) {
> +	if (op_is_write(bio_op(bio)) && bdev_read_only(bio->bi_bdev))
>  		char b[BDEVNAME_SIZE];
>  
>  		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
> diff --git a/block/genhd.c b/block/genhd.c
> index c87013879b8650..878f94727aaa96 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1425,27 +1425,32 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
>  	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
>  }
>  
> -void set_disk_ro(struct gendisk *disk, int flag)
> +/**
> + * set_disk_ro - set a gendisk read-only
> + * @disk:	gendisk to operate on
> + * @ready_only:	%true to set the disk read-only, %false set the disk read/write
> + *
> + * This function is used to indicate whether a given disk device should have its
> + * read-only flag set. set_disk_ro() is typically used by device drivers to
> + * indicate whether the underlying physical device is write-protected.
> + */
> +void set_disk_ro(struct gendisk *disk, bool read_only)
>  {
> -	struct disk_part_iter piter;
> -	struct block_device *part;
> -
> -	if (disk->part0->bd_read_only != flag) {
> -		set_disk_ro_uevent(disk, flag);
> -		disk->part0->bd_read_only = flag;
> +	if (read_only) {
> +		if (test_and_set_bit(GD_READ_ONLY, &disk->state))
> +			return;
> +	} else {
> +		if (!test_and_clear_bit(GD_READ_ONLY, &disk->state))
> +			return;
>  	}
> -
> -	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
> -	while ((part = disk_part_iter_next(&piter)))
> -		part->bd_read_only = flag;
> -	disk_part_iter_exit(&piter);
> +	set_disk_ro_uevent(disk, read_only);
>  }
> -
>  EXPORT_SYMBOL(set_disk_ro);
>  
>  int bdev_read_only(struct block_device *bdev)
>  {
> -	return bdev->bd_read_only;
> +	return bdev->bd_read_only ||
> +		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
>  }
>  EXPORT_SYMBOL(bdev_read_only);

Maybe one inline version can be added for fast path(bio_check_ro()), and the approach
is good:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

