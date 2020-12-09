Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084472D390E
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 03:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgLIC4r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 21:56:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbgLIC4q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 21:56:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607482520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0WZQF5SlAEi9+waVA6LQzgtvN5ftR3nM5/xd5tk5h3g=;
        b=bNZP16f1I6XYP/c+d6wF95QMXWVtyL6fmAJ3aMBDf/BQOdQWefiS0oIhsVT/B0vWytuiZr
        GItwXQKzZjIA80GuMKR8JqAgwM3UlsjZIP+/BoiTjAFprQTLfvcLtQ14Yg5NDb3sJu/HzJ
        VcbNfThiU3m5yum1c0c2lgAmYTUUwB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-7xfTxa8XOY-IC20s3V-rdQ-1; Tue, 08 Dec 2020 21:55:19 -0500
X-MC-Unique: 7xfTxa8XOY-IC20s3V-rdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F945107ACE3;
        Wed,  9 Dec 2020 02:55:17 +0000 (UTC)
Received: from T590 (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B90D019725;
        Wed,  9 Dec 2020 02:55:01 +0000 (UTC)
Date:   Wed, 9 Dec 2020 10:54:56 +0800
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
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 6/6] nvme: allow revalidate to set a namespace read-only
Message-ID: <20201209025456.GF1217988@T590>
References: <20201208162829.2424563-1-hch@lst.de>
 <20201208162829.2424563-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208162829.2424563-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 05:28:29PM +0100, Christoph Hellwig wrote:
> Unconditionally call set_disk_ro now that it only updates the hardware
> state.  This allows to properly set up the Linux devices read-only when
> the controller turns a previously writable namespace read-only.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>  drivers/nvme/host/core.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index ce1b6151944131..3a0557ccc9fc5d 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2114,9 +2114,8 @@ static void nvme_update_disk_info(struct gendisk *disk,
>  	nvme_config_discard(disk, ns);
>  	nvme_config_write_zeroes(disk, ns);
>  
> -	if ((id->nsattr & NVME_NS_ATTR_RO) ||
> -	    test_bit(NVME_NS_FORCE_RO, &ns->flags))
> -		set_disk_ro(disk, true);
> +	set_disk_ro(disk, (id->nsattr & NVME_NS_ATTR_RO) ||
> +		test_bit(NVME_NS_FORCE_RO, &ns->flags));
>  }
>  
>  static inline bool nvme_first_scan(struct gendisk *disk)
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

