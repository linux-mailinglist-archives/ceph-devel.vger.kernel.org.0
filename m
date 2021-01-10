Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4A5B2F07AE
	for <lists+ceph-devel@lfdr.de>; Sun, 10 Jan 2021 16:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbhAJPA3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 10 Jan 2021 10:00:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:50728 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbhAJPA3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 10 Jan 2021 10:00:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1B71EAAF1;
        Sun, 10 Jan 2021 14:59:47 +0000 (UTC)
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
References: <20210109104254.1077093-1-hch@lst.de>
 <20210109104254.1077093-3-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9ed48321-4fa9-84a6-ac39-9b4ca56e81e6@suse.de>
Date:   Sun, 10 Jan 2021 15:59:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210109104254.1077093-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/9/21 11:42 AM, Christoph Hellwig wrote:
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
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
