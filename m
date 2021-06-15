Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABAD3A85D4
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Jun 2021 17:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhFOQBI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Jun 2021 12:01:08 -0400
Received: from verein.lst.de ([213.95.11.211]:50038 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231899AbhFOQA1 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 12:00:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 757AD67373; Tue, 15 Jun 2021 17:58:17 +0200 (CEST)
Date:   Tue, 15 Jun 2021 17:58:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>,
        Denis Efremov <efremov@linux.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Tim Waugh <tim@cyberelk.net>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Alex Dubov <oakad@yahoo.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        nbd@other.debian.org, linuxppc-dev@lists.ozlabs.org,
        ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 09/30] mtd_blkdevs: use blk_mq_alloc_disk
Message-ID: <20210615155817.GA31047@lst.de>
References: <20210602065345.355274-1-hch@lst.de> <20210602065345.355274-10-hch@lst.de> <CGME20210615154746eucas1p1321b6f1cf38d21899632e132cf025e61@eucas1p1.samsung.com> <13b21a07-b7c7-37db-fdc9-77bf174b6f8f@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13b21a07-b7c7-37db-fdc9-77bf174b6f8f@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 15, 2021 at 05:47:44PM +0200, Marek Szyprowski wrote:
> Hi,
> 
> On 02.06.2021 08:53, Christoph Hellwig wrote:
> > Use the blk_mq_alloc_disk API to simplify the gendisk and request_queue
> > allocation.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch landed in linux-next as commit 6966bb921def ("mtd_blkdevs: 
> use blk_mq_alloc_disk"). It causes the following regression on my QEMU 
> arm64 setup:

Please try the patch below:

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 5dc4c966ea73..6ce4bc57f919 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -382,6 +382,7 @@ int add_mtd_blktrans_dev(struct mtd_blktrans_dev *new)
 	}
 
 	new->disk = gd;
+	new->rq = new->disk->queue;
 	gd->private_data = new;
 	gd->major = tr->major;
 	gd->first_minor = (new->devnum) << tr->part_bits;
