Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56C52C7A8A
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Nov 2020 19:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgK2SU4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 29 Nov 2020 13:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbgK2SUo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 29 Nov 2020 13:20:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1363C0613D4;
        Sun, 29 Nov 2020 10:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=EefFTETwdjTT2tc3Kw8m+h2v6iqXbIBFBB9JSH+56hw=; b=VhMuTeEiiHBfSw5NdViDL8pIQr
        9XMfTGxzE7EnRGvgfYGgWYUd3SCyDJV5ANGHvXRV04PgLjsXbYj2iHd02HVI2HqIyBAT9JLTe1t9f
        +2oJdvttHYxKfaFQIukm/IdW2FZ6u3m5hI2JQ5TvrF0e3Tj1LR0G0AOJNg22ZbDbs+EfOpbRjYdX+
        FgSpC9vHtZZJw43RiPa/scGhW29vvo4bbDsh7oKnDYX9DojEX7la2eQe637f45Iwlq3ThoXPusS5u
        XdgP16IwMB4q170Qtgwc90cLhYb9ixdGM4UUEaeckoOBvGRBAvWCqPaV1T1XgMyXVVknzbf30aGTs
        NIy2OjVg==;
Received: from [2001:4bb8:18c:1dd6:f89e:6884:c966:3d6c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjRIU-00078D-8U; Sun, 29 Nov 2020 18:19:43 +0000
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
Subject: [PATCH 3/4] nvme: allow revalidate to set a namespace read-only
Date:   Sun, 29 Nov 2020 19:19:25 +0100
Message-Id: <20201129181926.897775-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201129181926.897775-1-hch@lst.de>
References: <20201129181926.897775-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Unconditionally call set_disk_ro now that it only updates the hardware
state.  This allows to properly set up the Linux devices read-only when
the controller turns a previously writable namespace read-only.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bc89e8659c403f..2442f43a1a5624 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2047,8 +2047,7 @@ static void nvme_update_disk_info(struct gendisk *disk,
 	nvme_config_discard(disk, ns);
 	nvme_config_write_zeroes(disk, ns);
 
-	if (id->nsattr & NVME_NS_ATTR_RO)
-		set_disk_ro(disk, true);
+	set_disk_ro(disk, id->nsattr & NVME_NS_ATTR_RO);
 }
 
 static inline bool nvme_first_scan(struct gendisk *disk)
-- 
2.29.2

