Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0C3FF287
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 19:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346770AbhIBRmR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 13:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346632AbhIBRmQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Sep 2021 13:42:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575FEC061575;
        Thu,  2 Sep 2021 10:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=bq7aygA/HlITheyoOHX4TDfVgRy1coZaxPOc4Dj9QXQ=; b=dXAtDVZTAgUbP9IB7I6GZ486uQ
        a0TNXad+2o7Gn9TsGoapvByiWqL5vJwhHo5WzweXMHbySRmpGB/cF/Xa91cL5cqT7HvCaYcfr0XGe
        +IXl01u13V/qnAzTnki5UJez2+pYCUVrY2nlHvOI998w8KYWfO5lUQhrw+rMDy+DBmU9bDAjyG7xC
        SkyLoqr4Ephh62sazlqQJM+ndk83dL+8yHfpqoMzkKYXb5wGZyBiP57PSZ7aJHp8R3VhKngkfMFBq
        OE/FdbsfCoNshb82/Hiw0+3/gKMNQWVIPn0ivWs3gDAREtUBBNRpVWC9kzYiq05jPfJAaHB+B23aA
        rBOunPrg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mLqi1-00A9FA-My; Thu, 02 Sep 2021 17:41:05 +0000
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
Subject: [PATCH 0/9] block: 5th batch of add_disk() error handling conversions 
Date:   Thu,  2 Sep 2021 10:40:56 -0700
Message-Id: <20210902174105.2418771-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is the 5th of 7 set of driver conversion over to use the new
add_disk() error handling. Please let me know if you spot
any issues. This set deals with miscellaneous block drivers.

This patch set is based on axboe/master, you can find the
full set of changes on my 20210901-for-axboe-add-disk-error-handling
branch [0].

It would seem there are going to be a total of 7 sets of patches. The
next one will be the wonderful and exciting world of floppy drivers.
The last is the required changes to add a __must_check for the return
value for the caller.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210901-for-axboe-add-disk-error-handling

Luis Chamberlain (9):
  cdrom/gdrom: add error handling support for add_disk()
  ms_block: add error handling support for add_disk()
  mspro_block: add error handling support for add_disk()
  rbd: add add_disk() error handling
  mtd: add add_disk() error handling
  s390/block/dasd_genhd: add error handling support for add_disk()
  s390/block/dcssblk: add error handling support for add_disk()
  s390/block/scm_blk: add error handling support for add_disk()
  s390/block/xpram: add error handling support for add_disk()

 drivers/block/rbd.c                 | 6 +++++-
 drivers/cdrom/gdrom.c               | 7 ++++++-
 drivers/memstick/core/ms_block.c    | 6 +++++-
 drivers/memstick/core/mspro_block.c | 6 +++++-
 drivers/mtd/mtd_blkdevs.c           | 6 +++++-
 drivers/s390/block/dasd_genhd.c     | 8 ++++++--
 drivers/s390/block/dcssblk.c        | 4 +++-
 drivers/s390/block/scm_blk.c        | 7 ++++++-
 drivers/s390/block/xpram.c          | 4 +++-
 9 files changed, 44 insertions(+), 10 deletions(-)

-- 
2.30.2

