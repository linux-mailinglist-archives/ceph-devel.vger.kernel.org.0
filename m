Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CFB2D11C7
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Dec 2020 14:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgLGNXS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Dec 2020 08:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgLGNXQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Dec 2020 08:23:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FEDC061A4F;
        Mon,  7 Dec 2020 05:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Onf2Push4rguxXZ1Ztu3vt8dSy5R2KexTj8GPT3owek=; b=gvjtxGFmxRD94KCiNQPbE61Z4O
        DGjMQpu2Lf0edVjAJPlLsfgAKT7oWhe4AqWd+56fmodjaN8Q4I2lqrZuhNkvYyanei+ZT6+hAO7GU
        u7wDsePMMeIarG9g1/qXd2EQL4SaIZE7sI7vBO13J1XNJBuft14vsC8nkhEQoIzsk/qSmoEzfVkbW
        ROY+XNX5NnFwp3mEL+9g2FhLM6cLEkVY9aZD/84ckobim3BUYN7VfcTRzx/omLCKjbjWUDmOCNySk
        g0BxrnPxrmG3I8ylq9TmMH77fQsZL59cipDZNvocXnjDB4ZEdrp8E4q4m9plwGctlMoIzxuL+t0q8
        9EHCxfsQ==;
Received: from [2001:4bb8:188:f36:4fd9:254f:b3b5:5284] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmGSN-0006PM-Ps; Mon, 07 Dec 2020 13:21:36 +0000
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
Date:   Mon,  7 Dec 2020 14:19:16 +0100
Message-Id: <20201207131918.2252553-5-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201207131918.2252553-1-hch@lst.de>
References: <20201207131918.2252553-1-hch@lst.de>
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

permits writes. But:

<something triggers revalidate>

doesn't.

And a subsequent:

doesn't work either since sda1's read-only policy has been inherited
from the whole-disk device.

You need to do:

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
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 878f94727aaa96..c214fcd25a05c9 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1449,8 +1449,7 @@ EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
-	return bdev->bd_read_only ||
-		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
+	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
 }
 EXPORT_SYMBOL(bdev_read_only);
 
-- 
2.29.2

