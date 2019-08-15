Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5853F8EB56
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Aug 2019 14:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfHOMP6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Aug 2019 08:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfHOMP6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 15 Aug 2019 08:15:58 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B90CD206C1;
        Thu, 15 Aug 2019 12:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565871357;
        bh=lpBB5rL6iSyC2tL/c3Rxz5x9oakvbHsLI5jDMyBEhbs=;
        h=From:To:Cc:Subject:Date:From;
        b=1EA0vTOJ+hjqAYzHffwp8CH8+YpPEgqHCyKIMcBZXovHiOPYBpjAv9fNc3pY2Xhuk
         /OVCYcvxGccENhrt9d+EZHawSrZhhNbTlOsrO+BU4QtN7r17Y5Nw4eWDzG5lIeAfOi
         9lAmliZs3mTfMb8/xKo/p3bQjgq2JVxPqiTS7FH4=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     hector@marcansoft.com, idryomov@gmail.com, sage@redhat.com,
        ukernel@gmail.com
Subject: [PATCH] ceph: don't try fill file_lock on unsuccessful GETFILELOCK reply
Date:   Thu, 15 Aug 2019 08:15:55 -0400
Message-Id: <20190815121555.15825-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When ceph_mdsc_do_request returns an error, we can't assume that the
filelock_reply pointer will be set. Only try to fetch fields out of
the r_reply_info when it returns success.

Cc: stable@vger.kernel.org
Reported-by: Hector Martin <hector@marcansoft.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/locks.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index cb216501c959..544e9e85b120 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -115,8 +115,7 @@ static int ceph_lock_message(u8 lock_type, u16 operation, struct inode *inode,
 		req->r_wait_for_completion = ceph_lock_wait_for_completion;
 
 	err = ceph_mdsc_do_request(mdsc, inode, req);
-
-	if (operation == CEPH_MDS_OP_GETFILELOCK) {
+	if (!err && operation == CEPH_MDS_OP_GETFILELOCK) {
 		fl->fl_pid = -le64_to_cpu(req->r_reply_info.filelock_reply->pid);
 		if (CEPH_LOCK_SHARED == req->r_reply_info.filelock_reply->type)
 			fl->fl_type = F_RDLCK;
-- 
2.21.0

