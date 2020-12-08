Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397392D3022
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 17:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgLHQqf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 11:46:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:39404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730083AbgLHQqf (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 11:46:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95A7CAD21;
        Tue,  8 Dec 2020 16:45:53 +0000 (UTC)
Subject: Re: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Ming Lei <ming.lei@redhat.com>
References: <20201208162829.2424563-1-hch@lst.de>
 <20201208162829.2424563-3-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5adf02c7-9f53-4162-2655-8063c118ce8f@suse.de>
Date:   Tue, 8 Dec 2020 17:45:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201208162829.2424563-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 12/8/20 5:28 PM, Christoph Hellwig wrote:
> Only a single caller can end up in bdev_read_only, so move the check
> there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   block/genhd.c | 3 ---
>   fs/super.c    | 3 ++-
>   2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index b84b8671e6270a..8f2b89d1161813 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1652,11 +1652,8 @@ EXPORT_SYMBOL(set_disk_ro);
>   
>   int bdev_read_only(struct block_device *bdev)
>   {
> -	if (!bdev)
> -		return 0;
>   	return bdev->bd_read_only;
>   }
> -
>   EXPORT_SYMBOL(bdev_read_only);
>   
>   /*
> diff --git a/fs/super.c b/fs/super.c
> index 2c6cdea2ab2d9e..5a1f384ffc74f6 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -865,7 +865,8 @@ int reconfigure_super(struct fs_context *fc)
>   
>   	if (fc->sb_flags_mask & SB_RDONLY) {
>   #ifdef CONFIG_BLOCK
> -		if (!(fc->sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
> +		if (!(fc->sb_flags & SB_RDONLY) && sb->s_bdev &&
> +		    bdev_read_only(sb->s_bdev))
>   			return -EACCES;
>   #endif
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
