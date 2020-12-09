Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EA22D3844
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 02:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgLIBZH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 20:25:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbgLIBZH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 20:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607477021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ks3Ply4N96m4k2H0dn1kKwtldUSUQfBTesh+Kzg2SfY=;
        b=QP4Y65M2xtnSp0GawFA8xDwy/C+Ktg9Gyvi4u3RzO09gbMo7s+t/sllOvjntgJtDWt12Hv
        0LDmiuQLCpQJ7YN+YeRzTr9G5wR9CJq/sDWUU1ijJHaBB76YsP75C1TCKlcJILk+URlMHc
        Ah70duf0R443FCh888ztbbMoYmUzcJw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-8a_meGOmMGOcPRAitz_oJQ-1; Tue, 08 Dec 2020 20:23:39 -0500
X-MC-Unique: 8a_meGOmMGOcPRAitz_oJQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89BB41005513;
        Wed,  9 Dec 2020 01:23:37 +0000 (UTC)
Received: from T590 (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEBD660BE2;
        Wed,  9 Dec 2020 01:23:21 +0000 (UTC)
Date:   Wed, 9 Dec 2020 09:23:17 +0800
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
Message-ID: <20201209012317.GC1217988@T590>
References: <20201207131918.2252553-1-hch@lst.de>
 <20201207131918.2252553-5-hch@lst.de>
 <20201208102923.GD1202995@T590>
 <20201208105927.GB21762@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208105927.GB21762@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 11:59:27AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 08, 2020 at 06:29:23PM +0800, Ming Lei wrote:
> > > -		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
> > > +	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
> > >  }
> > >  EXPORT_SYMBOL(bdev_read_only);
> > 
> > I think this patch should be folded into previous one, otherwise
> > bdev_read_only(part) may return false even though ioctl(BLKROSET)
> > has been done on the whole disk.
> 
> The above is the existing behavior going back back very far, and I feel
> much more comfortable having a small self-contained patch that changes
> this behavior.
> 

OK, then looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

