Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B162D285C
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 11:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgLHKBf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 05:01:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29682 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLHKBe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 05:01:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607421608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0iZqkZAphNZf99PJFIaYexFrQFdjyflH/vT614+uZb8=;
        b=ZJt2GBq8EDxiQZO3MnAP7b51S8dpvPO4IniN1G18ZzMPbHv7YDDvPYMZxCZdeDvvbsoD99
        o2r/Szb5p2uAIC5XvjeMaN655bAdzlKCiynO03oJf9CPZF6El61n6fe7ZLy7utsCVGKCke
        j8oQtAQ1QZPb7k+lbaElne5zhPyc8gU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-k_m0i4LmMCqeNxMYW764Fg-1; Tue, 08 Dec 2020 05:00:04 -0500
X-MC-Unique: k_m0i4LmMCqeNxMYW764Fg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9573F10054FF;
        Tue,  8 Dec 2020 09:59:59 +0000 (UTC)
Received: from T590 (ovpn-12-237.pek2.redhat.com [10.72.12.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F1AF2B394;
        Tue,  8 Dec 2020 09:59:40 +0000 (UTC)
Date:   Tue, 8 Dec 2020 17:59:35 +0800
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
Subject: Re: [PATCH 1/6] dm: use bdev_read_only to check if a device is
 read-only
Message-ID: <20201208095935.GA1202995@T590>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207131918.2252553-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 07, 2020 at 02:19:13PM +0100, Christoph Hellwig wrote:
> dm-thin and dm-cache also work on partitions, so use the proper
> interface to check if the device is read-only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-cache-metadata.c | 2 +-
>  drivers/md/dm-thin-metadata.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
> index af6d4f898e4c1d..89a73204dbf47f 100644
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -449,7 +449,7 @@ static int __check_incompat_features(struct cache_disk_superblock *disk_super,
>  	/*
>  	 * Check for read-only metadata to skip the following RDWR checks.
>  	 */
> -	if (get_disk_ro(cmd->bdev->bd_disk))
> +	if (bdev_read_only(cmd->bdev))
>  		return 0;
>  
>  	features = le32_to_cpu(disk_super->compat_ro_flags) & ~DM_CACHE_FEATURE_COMPAT_RO_SUPP;
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 6ebb2127f3e2e0..e75b20480e460e 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -636,7 +636,7 @@ static int __check_incompat_features(struct thin_disk_superblock *disk_super,
>  	/*
>  	 * Check for read-only metadata to skip the following RDWR checks.
>  	 */
> -	if (get_disk_ro(pmd->bdev->bd_disk))
> +	if (bdev_read_only(pmd->bdev))
>  		return 0;
>  
>  	features = le32_to_cpu(disk_super->compat_ro_flags) & ~THIN_FEATURE_COMPAT_RO_SUPP;
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

