Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357C12D296B
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 12:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgLHLAM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 06:00:12 -0500
Received: from verein.lst.de ([213.95.11.211]:45789 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729179AbgLHLAM (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 06:00:12 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1A43D6736F; Tue,  8 Dec 2020 11:59:29 +0100 (CET)
Date:   Tue, 8 Dec 2020 11:59:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 4/6] block: propagate BLKROSET on the whole device to
 all partitions
Message-ID: <20201208105927.GB21762@lst.de>
References: <20201207131918.2252553-1-hch@lst.de> <20201207131918.2252553-5-hch@lst.de> <20201208102923.GD1202995@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208102923.GD1202995@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 06:29:23PM +0800, Ming Lei wrote:
> > -		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
> > +	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
> >  }
> >  EXPORT_SYMBOL(bdev_read_only);
> 
> I think this patch should be folded into previous one, otherwise
> bdev_read_only(part) may return false even though ioctl(BLKROSET)
> has been done on the whole disk.

The above is the existing behavior going back back very far, and I feel
much more comfortable having a small self-contained patch that changes
this behavior.
