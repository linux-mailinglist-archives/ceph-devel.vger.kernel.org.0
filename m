Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125442EFF05
	for <lists+ceph-devel@lfdr.de>; Sat,  9 Jan 2021 11:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbhAIKqF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 9 Jan 2021 05:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbhAIKqF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 9 Jan 2021 05:46:05 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB729C06179F;
        Sat,  9 Jan 2021 02:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=tk49uTd1GaXg7LbiRUxBP5Y/ceJT7HmrtRb4yzgC7VM=; b=Pg0QCTprj3/gbzelxrFki8OKj3
        +1KRU/Nvl8KvRv1cRa6jV1b87TP7hT9wT+rmYRS0ALSC2FVJGxkby4m0L8jwOBdI0Z57pl4ZK9huz
        6lwWRBN4y+iMGQ8NPbLohmuDminW5XLUOZvs+8iclVzwwyuoHsnuV0vLx8tVpnd6ExipYnMIwm208
        HbliFdEi/oNTTllpE41yZZ5QnORtVJeqEU4vQlfvQeMXMjdqVovkX6uNeHG/p/6qksS2eHpWjcOFR
        9d6W2dTRXWiZmb0YIm+H9RGjOUgE/NYdoXQQ8/M2Hrq92n8Sm4xapVnNUSV9vKpC6+AKx+H99kpka
        l0HNGRbw==;
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kyBhv-000Sux-9b; Sat, 09 Jan 2021 10:43:12 +0000
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
Subject: split hard read-only vs read-only policy v3 (resend)
Date:   Sat,  9 Jan 2021 11:42:48 +0100
Message-Id: <20210109104254.1077093-1-hch@lst.de>
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

Note that the last patch only applies to for-next and not to
for-5.11/block.  I can hold it back for the first NVMe pull request after
Linus pulled the block tree.

A git tree is available here:

    git://git.infradead.org/users/hch/block.git block-hard-ro

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-hard-ro

Changes since v3:
 - rebased to the latest block tree
 - indent commit log lines starting with a "#" to make sure git commit
   doesn't eat them

Changes since v2:
 - fix a few typos
 - add a patch to propagate the read-only status from the whole device to
   partitions
 - add a patch to remove a pointless check from bdev_read_only

Changes since v1:
 - don't propagate the policy flag from the whole disk to partitions
 - rebased on top of the merge block_device and hd_struct series
