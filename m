Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1ED2D28EF
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 11:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgLHKbs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 05:31:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgLHKbs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 05:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607423422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=93jbxpYyv2YGTT1dmSIY9OMo6/h6rcAr8GzYCcg92HY=;
        b=fbEln43f9d/bUXb/ge1Y9MG9YKQRBxoL/3wq+IOYaozI6a/Rrb4IZu/LSmY3Hp368XJdiC
        CJR9wjSFt4WsYuYSU+RMCekuvZJUk/Ww1o6E7LNpN3Uxf5DXB3jXN3lTjuYBanuu4lmamz
        orkWrbKRTOGoLopuccUzi5bVoFpflPQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-qlkjLPEHOkmMUAAGcwQkUQ-1; Tue, 08 Dec 2020 05:30:18 -0500
X-MC-Unique: qlkjLPEHOkmMUAAGcwQkUQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51F1A107AD5B;
        Tue,  8 Dec 2020 10:29:34 +0000 (UTC)
Received: from T590 (ovpn-12-237.pek2.redhat.com [10.72.12.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C59065C1A1;
        Tue,  8 Dec 2020 10:29:28 +0000 (UTC)
Date:   Tue, 8 Dec 2020 18:29:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 4/6] block: propagate BLKROSET on the whole device to all
 partitions
Message-ID: <20201208102923.GD1202995@T590>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207131918.2252553-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 07, 2020 at 02:19:16PM +0100, Christoph Hellwig wrote:
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
> permits writes. But:
> 
> <something triggers revalidate>
> 
> doesn't.
> 
> And a subsequent:
> 
> doesn't work either since sda1's read-only policy has been inherited
> from the whole-disk device.
> 
> You need to do:
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
> ---
>  block/genhd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 878f94727aaa96..c214fcd25a05c9 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1449,8 +1449,7 @@ EXPORT_SYMBOL(set_disk_ro);
>  
>  int bdev_read_only(struct block_device *bdev)
>  {
> -	return bdev->bd_read_only ||
> -		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
> +	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
>  }
>  EXPORT_SYMBOL(bdev_read_only);

I think this patch should be folded into previous one, otherwise
bdev_read_only(part) may return false even though ioctl(BLKROSET)
has been done on the whole disk.

-- 
Ming

