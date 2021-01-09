Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336A72EFF12
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 11:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbhAIKsk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 05:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbhAIKsk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 05:48:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A5BC0617A3;
        Sat,  9 Jan 2021 02:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OuO8kXBwOVg2a0qlGOHd+KBfCRFHK5StyY10tKFHVS8=; b=VeZFfshSf9Ix0EcE41evKramMP
        jn5vZju+vCViJE/nGVWD9jxUQ4zuFVyTiarcua3S0nKzo7UtPQ3qIvoDASsUtzBegY+tOdk/8xOJU
        SYiCsPCW7JhSvmDRJr6Lorz+5qbHCPXUzOT+g++UB3pV/FLKrxmLDRt7hyQoDNuep1RFkMyXYIeP3
        NbSdIibjh9ZG/rL8H6VX4+ebq8g12ZsuZ8yV1igsjWwJ+tzmCwWzJWONL0ss00jAta8hq2Gpvoi6u
        KxUiqhoHwmWMvQ0hEVuPfAn7NQKRcax/09Nx9Mv0b82q3hBiycqDf9GEL376cuzLHC4Vov+fP779e
        nSUoU8fw==;
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyBl7-000TC6-Dn; Sat, 09 Jan 2021 10:46:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: [PATCH 4/6] block: propagate BLKROSET on the whole device to all partitions
Date:   Sat,  9 Jan 2021 11:42:52 +0100
Message-Id: <20210109104254.1077093-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Change the policy so that a BLKROSET on the whole device also affects
partitions.  To quote Martin K. Petersen:

It's very common for database folks to twiddle the read-only state of
block devices and partitions. I know that our users will find it very
counter-intuitive that setting /dev/sda read-only won't prevent writes
to /dev/sda1.

The existing behavior is inconsistent in the sense that doing:

  # blockdev --setro /dev/sda
  # echo foo > /dev/sda1

permits writes. But:

  # blockdev --setro /dev/sda
  <something triggers revalidate>
  # echo foo > /dev/sda1

doesn't.

And a subsequent:

  # blockdev --setrw /dev/sda
  # echo foo > /dev/sda1

doesn't work either since sda1's read-only policy has been inherited
from the whole-disk device.

You need to do:

  # blockdev --rereadpt

after setting the whole-disk device rw to effectuate the same change on
the partitions, otherwise they are stuck being read-only indefinitely.

However, setting the read-only policy on a partition does *not* require
the revalidate step. As a matter of fact, doing the revalidate will blow
away the policy setting you just made.

So the user needs to take different actions depending on whether they
are trying to read-protect a whole-disk device or a partition. Despite
using the same ioctl. That is really confusing.

I have lost count how many times our customers have had data clobbered
because of ambiguity of the existing whole-disk device policy. The
current behavior violates the principle of least surprise by letting the
user think they write protected the whole disk when they actually
didn't.

Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e70bdc9b0893c1..10c76320510fef 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1658,8 +1658,7 @@ EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
-	return bdev->bd_read_only ||
-		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
+	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
 }
 EXPORT_SYMBOL(bdev_read_only);
 
-- 
2.29.2

