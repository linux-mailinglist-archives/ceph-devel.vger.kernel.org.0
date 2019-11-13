Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43D4FB4CD
	for <lists+ceph-devel@lfdr.de>; Wed, 13 Nov 2019 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfKMQS4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 11:18:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfKMQS4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 11:18:56 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5C7222C6;
        Wed, 13 Nov 2019 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573661935;
        bh=OPzS5aUYdZuug5fCIMkqOUbbKKbUnnyae09YWlQgcoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2zr2C4riNJ9tovoM1GA+Wa1J+Oo6fgdBv31Fg3zlZ5WGAKL8qHI5X/5+ZwlUQROp
         qMdDZoWGdHCsSLlX9V1ezWA8uhV1Pf9gtgtWwi+JHOv2l/MM0TLrs54CwUb58na8X+
         lIrbWs1GGNvIRh3gPyKzQjFmTOJfXnXmN+Glcslw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: increment/decrement dio counter on async requests
Date:   Wed, 13 Nov 2019 11:18:48 -0500
Message-Id: <20191113161848.91812-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191113161848.91812-1-jlayton@kernel.org>
References: <20191113161848.91812-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ceph can in some cases issue an async DIO request, in which case we can
end up calling ceph_end_io_direct before the I/O is actually complete.
That may allow buffered operations to proceed while DIO requests are
still in flight.

Fix this by incrementing the i_dio_count when issuing an async DIO
request, and decrement it when tearing down the aio_req.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 06efeaff3b57..8de633964dc3 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -753,6 +753,9 @@ static void ceph_aio_complete(struct inode *inode,
 	if (!atomic_dec_and_test(&aio_req->pending_reqs))
 		return;
 
+	if (aio_req->iocb->ki_flags & IOCB_DIRECT)
+		inode_dio_end(inode);
+
 	ret = aio_req->error;
 	if (!ret)
 		ret = aio_req->total_len;
@@ -1091,6 +1094,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 					      CEPH_CAP_FILE_RD);
 
 		list_splice(&aio_req->osd_reqs, &osd_reqs);
+		inode_dio_begin(inode);
 		while (!list_empty(&osd_reqs)) {
 			req = list_first_entry(&osd_reqs,
 					       struct ceph_osd_request,
-- 
2.23.0

