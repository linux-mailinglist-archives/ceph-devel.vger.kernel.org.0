Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4B71DB903
	for <lists+ceph-devel@lfdr.de>; Wed, 20 May 2020 18:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgETQJV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 May 2020 12:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgETQJU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 20 May 2020 12:09:20 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5E2A206F1;
        Wed, 20 May 2020 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589990960;
        bh=LaTEXzTuYLKzn5eC/VgRfWYobROayoaolcsrEzkxVRk=;
        h=From:To:Cc:Subject:Date:From;
        b=O0yV+DOJ17jgoYcoqI5CATl/cXyRPDzoM9xSHw7+KqGWB2mEM71+n1EHQRmTsmnsm
         F8FRWJwxmjq9nEkBe63fKyw+MqD/d04GCoJEYxPg1VeA0FW0yTk4MeGyIESDVjr1Q2
         rAMhZhlQqdMUUZruZLf24P+JQLjPL/PdQw5bU/2s=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, andrej.filipcic@ijs.si
Subject: [PATCH] ceph: flush release queue when handling caps for unknown inode
Date:   Wed, 20 May 2020 12:09:18 -0400
Message-Id: <20200520160918.257146-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's possible for the VFS to completely forget about an inode, but for
it to still be sitting on the cap release queue. If the MDS sends the
client a cap message for such an inode, it just ignores it today, which
can lead to a stall of up to 5s until the cap release queue is flushed.

If we get a cap message for an inode that can't be located, then go
ahead and flush the cap release queue.

Cc: stable@vger.kernel.org
Fixes: 1e9c2eb6811e ("ceph: delete stale dentry when last reference is dropped")
Reported-by: Andrej Filipčič <andrej.filipcic@ijs.si>
Fix-suggested-by: Yan, Zheng <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 27c2e60f33dc..41eb999dadf0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4070,7 +4070,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 			__ceph_queue_cap_release(session, cap);
 			spin_unlock(&session->s_cap_lock);
 		}
-		goto done;
+		goto flush_cap_releases;
 	}
 
 	/* these will work even if we don't have a cap yet */
-- 
2.26.2

