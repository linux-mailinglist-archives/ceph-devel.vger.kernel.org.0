Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B201A2EFF0F
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 11:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbhAIKsV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 05:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbhAIKsU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 05:48:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532B0C06179F;
        Sat,  9 Jan 2021 02:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Txv6EQ9gPaV4zZ3R/07xKBssgYf1qHOamsO3WQ5Virc=; b=vdL7EDVfs1JBqD2gJqh+nMGPOM
        8AGpKaHriyLHGo359OoH80hrREqezfsuIBBS7Uf2xnuQi0AFEb3EVZPPZAANHknbAZLuEYfnpG8Dy
        UX0rLLw2ZwnysN71+JB2n2BabuKfaDmGgeKydp4PgjSa6dbaU30VIxwygB3R3kImZ/JjtKnPdZXd0
        0xupqMbuH6OEflj3aJmeabtMy6uo+ZbCMIYdWdsizOX2hSAHc2NkB4sAzzgLgpgoj/0kKyZWQvKCl
        ZtEkAhLNwgP4s32pizfLIN3k7xGoW2y9svoCxpV0aMQKdb2Es92GK6jX771EtEk4bYCLkkJqGQA1e
        h12XtSzA==;
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyBkd-000TAI-LX; Sat, 09 Jan 2021 10:45:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Oleksii Kurochko <olkuroch@cisco.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Mike Snitzer <snitzer@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/6] block: add a hard-readonly flag to struct gendisk
Date:   Sat,  9 Jan 2021 11:42:51 +0100
Message-Id: <20210109104254.1077093-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Commit 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading
partition") addressed a long-standing problem with user read-only
policy being overridden as a result of a device-initiated revalidate.
The commit has since been reverted due to a regression that left some
USB devices read-only indefinitely.

To fix the underlying problems with revalidate we need to keep track
of hardware state and user policy separately.

The gendisk has been updated to reflect the current hardware state set
by the device driver. This is done to allow returning the device to
the hardware state once the user clears the BLKROSET flag.

The resulting semantics are as follows:

 - If BLKROSET sets a given partition read-only, that partition will
   remain read-only even if the underlying storage stack initiates a
   revalidate. However, the BLKRRPART ioctl will cause the partition
   table to be dropped and any user policy on partitions will be lost.

 - If BLKROSET has not been set, both the whole disk device and any
   partitions will reflect the current write-protect state of the
   underlying device.

Based on a patch from Martin K. Petersen <martin.petersen@oracle.com>.

Reported-by: Oleksii Kurochko <olkuroch@cisco.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=201221
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c        |  4 +---
 block/genhd.c           | 33 +++++++++++++++++++--------------
 block/partitions/core.c |  3 +--
 include/linux/genhd.h   |  6 ++++--
 4 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7663a9b94b8002..08ff8ca325296e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -694,9 +694,7 @@ static inline bool should_fail_request(struct block_device *part,
 
 static inline bool bio_check_ro(struct bio *bio, struct block_device *part)
 {
-	const int op = bio_op(bio);
-
-	if (part->bd_read_only && op_is_write(op)) {
+	if (op_is_write(bio_op(bio)) && bdev_read_only(part)) {
 		char b[BDEVNAME_SIZE];
 
 		if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
diff --git a/block/genhd.c b/block/genhd.c
index 4f90f80d7aa76d..e70bdc9b0893c1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1634,27 +1634,32 @@ static void set_disk_ro_uevent(struct gendisk *gd, int ro)
 	kobject_uevent_env(&disk_to_dev(gd)->kobj, KOBJ_CHANGE, envp);
 }
 
-void set_disk_ro(struct gendisk *disk, int flag)
+/**
+ * set_disk_ro - set a gendisk read-only
+ * @disk:	gendisk to operate on
+ * @ready_only:	%true to set the disk read-only, %false set the disk read/write
+ *
+ * This function is used to indicate whether a given disk device should have its
+ * read-only flag set. set_disk_ro() is typically used by device drivers to
+ * indicate whether the underlying physical device is write-protected.
+ */
+void set_disk_ro(struct gendisk *disk, bool read_only)
 {
-	struct disk_part_iter piter;
-	struct block_device *part;
-
-	if (disk->part0->bd_read_only != flag) {
-		set_disk_ro_uevent(disk, flag);
-		disk->part0->bd_read_only = flag;
+	if (read_only) {
+		if (test_and_set_bit(GD_READ_ONLY, &disk->state))
+			return;
+	} else {
+		if (!test_and_clear_bit(GD_READ_ONLY, &disk->state))
+			return;
 	}
-
-	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
-	while ((part = disk_part_iter_next(&piter)))
-		part->bd_read_only = flag;
-	disk_part_iter_exit(&piter);
+	set_disk_ro_uevent(disk, read_only);
 }
-
 EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
-	return bdev->bd_read_only;
+	return bdev->bd_read_only ||
+		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
 }
 EXPORT_SYMBOL(bdev_read_only);
 
diff --git a/block/partitions/core.c b/block/partitions/core.c
index e7d776db803b12..168d5906077cfd 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -195,7 +195,7 @@ static ssize_t part_start_show(struct device *dev,
 static ssize_t part_ro_show(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%d\n", dev_to_bdev(dev)->bd_read_only);
+	return sprintf(buf, "%d\n", bdev_read_only(dev_to_bdev(dev)));
 }
 
 static ssize_t part_alignment_offset_show(struct device *dev,
@@ -361,7 +361,6 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 
 	bdev->bd_start_sect = start;
 	bdev_set_nr_sectors(bdev, len);
-	bdev->bd_read_only = get_disk_ro(disk);
 
 	if (info) {
 		err = -ENOMEM;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 809aaa32d53cba..a62ccbfac54b48 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -163,6 +163,7 @@ struct gendisk {
 	int flags;
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
+#define GD_READ_ONLY			1
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
@@ -249,11 +250,12 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
 extern void del_gendisk(struct gendisk *gp);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
 
-extern void set_disk_ro(struct gendisk *disk, int flag);
+void set_disk_ro(struct gendisk *disk, bool read_only);
 
 static inline int get_disk_ro(struct gendisk *disk)
 {
-	return disk->part0->bd_read_only;
+	return disk->part0->bd_read_only ||
+		test_bit(GD_READ_ONLY, &disk->state);
 }
 
 extern void disk_block_events(struct gendisk *disk);
-- 
2.29.2

