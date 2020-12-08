Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBA62D2880
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 11:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgLHKIR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 05:08:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729016AbgLHKIQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 05:08:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607422010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sko6C5wfWDgDz/llZ4T/WVRUdYqT5janpxHYpC7QfeM=;
        b=CYjiDIBxlggrd+CEZp8cB3an9Uy5dZPzr3NiNftUNqDHWXBTeQdhFbGAHFZLGIbUhqR532
        VY6ZScBkZgTzqZctZFrtDuWO3AN02R5LAE4VGn7Iiv9tXfH6O4LPqgm7wvxbOprO1kL+0M
        aSyviMBu0Jr7+8IWmOnpp9eolAEgfig=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-4DRUqOqZO8mqDRBrFYJALQ-1; Tue, 08 Dec 2020 05:06:46 -0500
X-MC-Unique: 4DRUqOqZO8mqDRBrFYJALQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58F63107ACE3;
        Tue,  8 Dec 2020 10:06:44 +0000 (UTC)
Received: from T590 (ovpn-12-237.pek2.redhat.com [10.72.12.237])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0471960BE2;
        Tue,  8 Dec 2020 10:06:26 +0000 (UTC)
Date:   Tue, 8 Dec 2020 18:06:21 +0800
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
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH 2/6] block: remove the NULL bdev check in bdev_read_only
Message-ID: <20201208100621.GB1202995@T590>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207131918.2252553-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Dec 07, 2020 at 02:19:14PM +0100, Christoph Hellwig wrote:
> Only a single caller can end up in bdev_read_only, so move the check there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/genhd.c | 3 ---
>  fs/super.c    | 3 ++-
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index 09ff6cef028729..c87013879b8650 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -1445,11 +1445,8 @@ EXPORT_SYMBOL(set_disk_ro);
>  
>  int bdev_read_only(struct block_device *bdev)
>  {
> -	if (!bdev)
> -		return 0;
>  	return bdev->bd_read_only;
>  }
> -
>  EXPORT_SYMBOL(bdev_read_only);
>  
>  /*
> diff --git a/fs/super.c b/fs/super.c
> index 2c6cdea2ab2d9e..5a1f384ffc74f6 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -865,7 +865,8 @@ int reconfigure_super(struct fs_context *fc)
>  
>  	if (fc->sb_flags_mask & SB_RDONLY) {
>  #ifdef CONFIG_BLOCK
> -		if (!(fc->sb_flags & SB_RDONLY) && bdev_read_only(sb->s_bdev))
> +		if (!(fc->sb_flags & SB_RDONLY) && sb->s_bdev &&
> +		    bdev_read_only(sb->s_bdev))
>  			return -EACCES;
>  #endif
>  
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

