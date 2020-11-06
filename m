Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4097A2A9CFB
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Nov 2020 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgKFTE0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Nov 2020 14:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgKFTET (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Nov 2020 14:04:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2C4C0613D4;
        Fri,  6 Nov 2020 11:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WRVMysZVU7Ci7qCB6ml6ZPr77ooiCVZTgGNm0z1Kbac=; b=EwEW1dmIzT0KztvNtJRW2Uubcj
        tlurSCjfhNkHrGfPqn0+Kq/EJbeTYzgj/PyWhFzEzqGwDqMIQgTxH+4oNmCQ8LfrXPJFUgGFC+Cq9
        F1IZ+/cmfA2k4ZHSyD2l4TZouA9lJMPSR6Q5sWOPNWLmVZx8CHk9p9r181uX//s3t7DHRcDusqPUa
        9w9+yAWsWRC+aRbLhdpzbhO2y/7jPPlu5VvKDsF8GH0RYI5IXw8u5pwL5aW0jbllMeck6ak0oKTQr
        GwpmBUxE2ovzhZAP8VMIeX9plnE1wp7Omf0GdvOKlmwNyJpTTBo9MvNnbQMgbExiCingPKDwlDSjX
        5fWfThtA==;
Received: from [2001:4bb8:184:9a8d:9e34:f7f4:e59e:ad6f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kb71h-0000us-6I; Fri, 06 Nov 2020 19:03:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, nbd@other.debian.org,
        ceph-devel@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 05/24] block: remove the update_bdev parameter from set_capacity_revalidate_and_notify
Date:   Fri,  6 Nov 2020 20:03:17 +0100
Message-Id: <20201106190337.1973127-6-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106190337.1973127-1-hch@lst.de>
References: <20201106190337.1973127-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The update_bdev argument is always set to true, so remove it.  Also
rename the function to the slighly less verbose set_capacity_and_notify,
as propagating the disk size to the block device isn't really
revalidation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c                | 13 +++++--------
 drivers/block/loop.c         | 11 +++++------
 drivers/block/virtio_blk.c   |  2 +-
 drivers/block/xen-blkfront.c |  2 +-
 drivers/nvme/host/core.c     |  2 +-
 drivers/scsi/sd.c            |  5 ++---
 include/linux/genhd.h        |  3 +--
 7 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 0a273211fec283..d8d9d6c1c916e1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -46,17 +46,15 @@ static void disk_del_events(struct gendisk *disk);
 static void disk_release_events(struct gendisk *disk);
 
 /*
- * Set disk capacity and notify if the size is not currently
- * zero and will not be set to zero
+ * Set disk capacity and notify if the size is not currently zero and will not
+ * be set to zero.
  */
-void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
-					bool update_bdev)
+void set_capacity_and_notify(struct gendisk *disk, sector_t size)
 {
 	sector_t capacity = get_capacity(disk);
 
 	set_capacity(disk, size);
-	if (update_bdev)
-		revalidate_disk_size(disk, true);
+	revalidate_disk_size(disk, true);
 
 	if (capacity != size && capacity != 0 && size != 0) {
 		char *envp[] = { "RESIZE=1", NULL };
@@ -64,8 +62,7 @@ void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
 		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
 	}
 }
-
-EXPORT_SYMBOL_GPL(set_capacity_revalidate_and_notify);
+EXPORT_SYMBOL_GPL(set_capacity_and_notify);
 
 /*
  * Format the device name of the indicated disk into the supplied buffer and
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 86eb7e0691eef5..77937b760ee0fc 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1146,8 +1146,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);
 
-	set_capacity_revalidate_and_notify(lo->lo_disk, get_loop_size(lo, file),
-			true);
+	set_capacity_and_notify(lo->lo_disk, get_loop_size(lo, file));
 	set_blocksize(bdev, S_ISBLK(inode->i_mode) ?
 		      block_size(inode->i_bdev) : PAGE_SIZE);
 
@@ -1383,9 +1382,9 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	lo->lo_flags |= prev_lo_flags & ~LOOP_SET_STATUS_CLEARABLE_FLAGS;
 
 	if (size_changed) {
-		set_capacity_revalidate_and_notify(lo->lo_disk,
+		set_capacity_and_notify(lo->lo_disk,
 				get_size(lo->lo_offset, lo->lo_sizelimit,
-					 lo->lo_backing_file), true);
+					 lo->lo_backing_file));
 	}
 
 	loop_config_discard(lo);
@@ -1563,8 +1562,8 @@ static int loop_set_capacity(struct loop_device *lo)
 {
 	if (unlikely(lo->lo_state != Lo_bound))
 		return -ENXIO;
-	set_capacity_revalidate_and_notify(lo->lo_disk,
-			get_loop_size(lo, lo->lo_backing_file), true);
+	set_capacity_and_notify(lo->lo_disk,
+			get_loop_size(lo, lo->lo_backing_file));
 	return 0;
 }
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index a314b9382442b6..3e812b4c32e669 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -470,7 +470,7 @@ static void virtblk_update_capacity(struct virtio_blk *vblk, bool resize)
 		   cap_str_10,
 		   cap_str_2);
 
-	set_capacity_revalidate_and_notify(vblk->disk, capacity, true);
+	set_capacity_and_notify(vblk->disk, capacity);
 }
 
 static void virtblk_config_changed_work(struct work_struct *work)
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 48629d3433b4c3..79521e33d30ed5 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2370,7 +2370,7 @@ static void blkfront_connect(struct blkfront_info *info)
 			return;
 		printk(KERN_INFO "Setting capacity to %Lu\n",
 		       sectors);
-		set_capacity_revalidate_and_notify(info->gd, sectors, true);
+		set_capacity_and_notify(info->gd, sectors);
 
 		return;
 	case BLKIF_STATE_SUSPENDED:
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4e86c9aafd88a7..aa6e27c2eec945 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2053,7 +2053,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 			capacity = 0;
 	}
 
-	set_capacity_revalidate_and_notify(disk, capacity, true);
+	set_capacity_and_notify(disk, capacity);
 
 	nvme_config_discard(disk, ns);
 	nvme_config_write_zeroes(disk, ns);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4a34dd5b153196..a2a4f385833d6c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3263,8 +3263,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	sdkp->first_scan = 0;
 
-	set_capacity_revalidate_and_notify(disk,
-		logical_to_sectors(sdp, sdkp->capacity), true);
+	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
 	sd_config_write_same(sdkp);
 	kfree(buffer);
 
@@ -3274,7 +3273,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * capacity to 0.
 	 */
 	if (sd_zbc_revalidate_zones(sdkp))
-		set_capacity_revalidate_and_notify(disk, 0, true);
+		set_capacity_and_notify(disk, 0);
 
  out:
 	return 0;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 38f23d75701379..596f31b5a3e133 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -315,8 +315,7 @@ static inline int get_disk_ro(struct gendisk *disk)
 extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
-void set_capacity_revalidate_and_notify(struct gendisk *disk, sector_t size,
-		bool update_bdev);
+void set_capacity_and_notify(struct gendisk *disk, sector_t size);
 
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk) __latent_entropy;
-- 
2.28.0

