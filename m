Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869D52C7F64
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Nov 2020 08:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgK3H4h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Nov 2020 02:56:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:37856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgK3H4h (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 02:56:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CF14DAD09;
        Mon, 30 Nov 2020 07:55:55 +0000 (UTC)
Subject: Re: [PATCH 1/4] block: add a hard-readonly flag to struct gendisk
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20201129181926.897775-1-hch@lst.de>
 <20201129181926.897775-2-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d28dc6f5-bae1-ddfa-8874-9c22235a69f3@suse.de>
Date:   Mon, 30 Nov 2020 08:55:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129181926.897775-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/29/20 7:19 PM, Christoph Hellwig wrote:
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
>   - If BLKROSET is used to set a whole-disk device read-only, any
>     partitions will end up in a read-only state until the user
>     explicitly clears the flag.
> 
>   - If BLKROSET sets a given partition read-only, that partition will
>     remain read-only even if the underlying storage stack initiates a
>     revalidate. However, the BLKRRPART ioctl will cause the partition
>     table to be dropped and any user policy on partitions will be lost.
> 
>   - If BLKROSET has not been set, both the whole disk device and any
>     partitions will reflect the current write-protect state of the
>     underlying device.
> 
> Based on a patch from Martin K. Petersen <martin.petersen@oracle.com>.
> 
> Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-core.c        |  2 +-
>   block/genhd.c           | 34 +++++++++++++++++++---------------
>   block/partitions/core.c |  3 +--
>   include/linux/genhd.h   |  6 ++++--
>   4 files changed, 25 insertions(+), 20 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
