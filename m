Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E3B2D11C6
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Dec 2020 14:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgLGNXS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Dec 2020 08:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgLGNXQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Dec 2020 08:23:16 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA9FC061A51;
        Mon,  7 Dec 2020 05:21:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=W03PdcPB+vlMKGBqYsRRQuyZ1LSfMAxcuv9MFZzn4hQ=; b=jiyUndFtmZvRKMeXuCrruwaWhp
        Z95eJKehelQPebCoVeQCAkPPP6sBjAgZS+IWgJz7aMmumtD3tYZSApO4tJrh0hPh6fAnbBTZO43BH
        PqglVpskWlGYk+LRdE5mEPHxyaYYOGBeXJbDCrg0Aza5Fo/Ux7JL+FeloCrY7E3aVRQ9obroifmms
        hsJ9hlOmXVGH80n6cFJZdIicb/ltvLUCUdaXQVw+UHKB/+9ezcqsUmy3S+STWHgPE0bYl0P38lf8A
        q2IEXd8pY2mLt+BnlSxwP7TxtP54KARfzrDrStVke5Cw6LchV/p76FGQ3jvsF/Q5GXntrYt1xCD9P
        igM/Dsrg==;
Received: from 089144200046.atnat0009.highway.a1.net ([89.144.200.46] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmGSH-0006Oq-U3; Mon, 07 Dec 2020 13:21:30 +0000
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
Date:   Mon,  7 Dec 2020 14:19:12 +0100
Message-Id: <20201207131918.2252553-1-hch@lst.de>
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

Changes since v2:
 - fix a few typos
 - add a patch to propagate the read-only status from the whole device to
   partitions
 - add a patch to remove a pointless check from bdev_read_only

Changes since v1:
 - don't propagate the policy flag from the whole disk to partitions
 - rebased on top of the merge block_device and hd_struct series
