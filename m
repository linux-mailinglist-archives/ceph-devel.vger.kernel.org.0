Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219F92D2962
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Dec 2020 11:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgLHK6c (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 05:58:32 -0500
Received: from verein.lst.de ([213.95.11.211]:45771 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728974AbgLHK6c (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 05:58:32 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 637ED6736F; Tue,  8 Dec 2020 11:57:47 +0100 (CET)
Date:   Tue, 8 Dec 2020 11:57:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/6] block: add a hard-readonly flag to struct gendisk
Message-ID: <20201208105747.GA21762@lst.de>
References: <20201207131918.2252553-1-hch@lst.de> <20201207131918.2252553-4-hch@lst.de> <20201208102211.GC1202995@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208102211.GC1202995@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 06:22:11PM +0800, Ming Lei wrote:
> >  int bdev_read_only(struct block_device *bdev)
> >  {
> > -	return bdev->bd_read_only;
> > +	return bdev->bd_read_only ||
> > +		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
> >  }
> >  EXPORT_SYMBOL(bdev_read_only);
> 
> Maybe one inline version can be added for fast path(bio_check_ro()), and the approach
> is good:

I thought of that, but our header mess means it would have to be a macro.
I have a plan to reorganize the headers in the not too far future, at which
point this should become an inline.

