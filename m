Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E592C7F6F
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Nov 2020 08:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgK3H7N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Nov 2020 02:59:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:38842 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgK3H7N (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 02:59:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCA36AC55;
        Mon, 30 Nov 2020 07:58:31 +0000 (UTC)
Subject: Re: [PATCH 4/4] dm: use bdev_read_only to check if a device is
 read-only
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
 <20201129181926.897775-5-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1d5128b7-4da4-951d-78b5-74fa0144299b@suse.de>
Date:   Mon, 30 Nov 2020 08:58:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129181926.897775-5-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/29/20 7:19 PM, Christoph Hellwig wrote:
> dm-thin and dm-cache also work on partitions, so use the proper
> interface to check if the device is read-only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/dm-cache-metadata.c | 2 +-
>   drivers/md/dm-thin-metadata.c  | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
