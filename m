Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC032C7A86
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Nov 2020 19:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgK2SUo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 13:20:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgK2SUn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 13:20:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B5CC0613CF;
        Sun, 29 Nov 2020 10:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=qBRhvARBbEpJSd0Ov2jhrf+2eiK0Ps4WvsnESinAIOA=; b=J0xbwQ+AZIdA4pOmO61IxJEmsb
        v/zKchTU+og2KXjyj1UatA6rvsgVzDzPlBTMVM2Kp7d2suehkxXuG9SIkwnIZ2IcRsNKucXDHaier
        6opmQz+HQvM9wxTbSTlQQR/JBN8vdr1E+Ya6ne1T1b6dvxrRASmvt1A0AFbFjC7zIfPiow4ssUZVb
        GogYVxBh5mT49CiexJRFYSbUdEMem1LfzQBor9ORiaRc/QfcjFyke35cOt4OqYutJEbqTIo0/v4Mc
        18ATFPYzOr1Z9Tw0eHZ+OmdfRIB5zGGSQMxqrGfDzCz/90gvA15ZpiKpwdBtsIJJVGqgP/TABm21T
        k40jR2Mw==;
Received: from [2001:4bb8:18c:1dd6:f89e:6884:c966:3d6c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRIJ-00077F-BY; Sun, 29 Nov 2020 18:19:33 +0000
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
Subject: split hard read-only vs read-only policy v2
Date:   Sun, 29 Nov 2020 19:19:22 +0100
Message-Id: <20201129181926.897775-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Jens,

this series resurrects a patch from Martin to properly split the flag
indicating a disk has been set read-only by the hardware vs the userspace
policy set through the BLKROSET ioctl.

This series is based on top of the

   "merge struct block_device and struct hd_struct v4"

series and won't apply to mainline or Jens' for-5.11 tree.

A git tree is available here:

    git://git.infradead.org/users/hch/block.git block-hard-ro

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-hard-ro


Changes since v1:
 - don't propagate the policy flag from the whole disk to partitions
 - rebased on top of the merge block_device and hd_struct series
