Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F9341A254
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Sep 2021 00:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhI0WFv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 18:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237825AbhI0WF3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 27 Sep 2021 18:05:29 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DCC5C061236;
        Mon, 27 Sep 2021 15:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ZkT9FE665rmf8UpSxZyO8BPu+CPWLAGeLNJNLOPTTWI=; b=jQRwJkNvsHzweXjq7n4G6KFKmL
        ofbRgWdQkPMTllrenBBgx4ZQWIlM0gY2tsatloKYmDbJOnlpgxBjInGzhLZExzYRi7cyr7QwjEGJc
        bF5od1uHWsqxiTy0/oj3ys16eNILoUZ/QX7u5TwETPYRmj7CRuZei9xxlH9NXkkBejjR4Ixx4gA9I
        nY9up+2C9P49deZ6c/4uM+2RQBysJImZUkmWnTi2OrnXHORSJQ1QRs0R/VajSPXa3+56BOpd2DIZn
        OkaPUVPSR5c4G7lXj1w+Mu0vdOLXExnqHIii4AroBfDNIT6HraEYmorq7KXTPn2jRd8S6ULaV/Zt6
        YIFlCf1g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyhl-004Utg-Hp; Mon, 27 Sep 2021 22:02:33 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, oberpar@linux.ibm.com,
        tj@kernel.org
Cc:     linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 0/6] block: 5th batch of add_disk() error handling conversions
Date:   Mon, 27 Sep 2021 15:02:26 -0700
Message-Id: <20210927220232.1071926-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the 5th series of driver conversions for add_disk() error
handling. This set along with the entire 7th set of patches can be
found on my 20210927-for-axboe-add-disk-error-handling branch [0].

On this v2 series the following changes have been made
since the first iteration of this patchset:

  - rebased onto linux-next tag 20210927
  - ms_block: dropped this patch as its already merged on linux-next
  - mspro_block: dropped this patch as its already merged on linux-next
  - dropped the s390/block/xpram patch as that driver is now removed
  - s390/block/dcssblk: dropped my patch in favor of Gerald Schaefer's
  - added respective reviewed-by/acked-by tags

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210927-for-axboe-add-disk-error-handling

Gerald Schaefer (1):
  s390/block/dcssblk: add error handling support for add_disk()

Luis Chamberlain (5):
  cdrom/gdrom: add error handling support for add_disk()
  rbd: add add_disk() error handling
  mtd: add add_disk() error handling
  s390/block/dasd_genhd: add error handling support for add_disk()
  s390/block/scm_blk: add error handling support for add_disk()

 drivers/block/rbd.c             |  6 +++++-
 drivers/cdrom/gdrom.c           |  7 ++++++-
 drivers/mtd/mtd_blkdevs.c       |  6 +++++-
 drivers/s390/block/dasd_genhd.c | 10 ++++++++--
 drivers/s390/block/dcssblk.c    |  8 +++++++-
 drivers/s390/block/scm_blk.c    |  7 ++++++-
 6 files changed, 37 insertions(+), 7 deletions(-)

-- 
2.30.2

