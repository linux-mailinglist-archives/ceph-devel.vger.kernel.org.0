Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECB62C7F66
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Nov 2020 08:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgK3H5Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Nov 2020 02:57:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:38008 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727125AbgK3H5P (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Nov 2020 02:57:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 27F22AC55;
        Mon, 30 Nov 2020 07:56:34 +0000 (UTC)
Subject: Re: [PATCH 2/4] rbd: remove the ->set_read_only method
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
 <20201129181926.897775-3-hch@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <49777248-51c9-d0e5-ba48-40bd3ac66ad5@suse.de>
Date:   Mon, 30 Nov 2020 08:56:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201129181926.897775-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 11/29/20 7:19 PM, Christoph Hellwig wrote:
> Now that the hardware read-only state can't be changed by the BLKROSET
> ioctl, the code in this method is not required anymore.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/block/rbd.c | 19 -------------------
>   1 file changed, 19 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
