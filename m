Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293B87E3C7
	for <lists+ceph-devel@lfdr.de>; Thu,  1 Aug 2019 22:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbfHAUMp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 1 Aug 2019 16:12:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfHAUMo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 16:12:44 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AADB20838;
        Thu,  1 Aug 2019 20:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564690363;
        bh=16OP9B8PElPILh/kv6q3USDVuOOh3diLFzT7DNkqrB4=;
        h=From:To:Cc:Subject:Date:From;
        b=HqX6JCVbhAQ9hapm/eH+2R5NzzLoTw7RwHVRlqWIF7gtNXJBzdmRUalV4waoexOn3
         Y/Ywn5EVZk0rqizRR9ZxwF7BUO04sSIwffdw29ijxuQ8G14gPFBdiVAyW0J3c8tzwp
         7tnRjRLpeWXcCsf9KOPjBx92s3cdperQGOg63Wvc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: don't freeze during write page faults
Date:   Thu,  1 Aug 2019 16:12:42 -0400
Message-Id: <20190801201242.16675-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Prevent freezing operations during write page faults. This is good
practice for most filesystems, but especially for ceph since we're
monkeying with the signal table here.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 563423891a98..731d96f8270d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1548,6 +1548,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	if (!prealloc_cf)
 		return VM_FAULT_OOM;
 
+	sb_start_pagefault(inode->i_sb);
 	ceph_block_sigs(&oldset);
 
 	if (ci->i_inline_version != CEPH_INLINE_NONE) {
@@ -1622,6 +1623,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
 	ceph_put_cap_refs(ci, got);
 out_free:
 	ceph_restore_sigs(&oldset);
+	sb_end_pagefault(inode->i_sb);
 	ceph_free_cap_flush(prealloc_cf);
 	if (err < 0)
 		ret = vmf_error(err);
-- 
2.21.0

