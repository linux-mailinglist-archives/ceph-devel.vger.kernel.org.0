Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C392D75C8
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Dec 2020 13:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395266AbgLKMk2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Dec 2020 07:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436538AbgLKMjl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 07:39:41 -0500
From:   Jeff Layton <jlayton@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, idryomov@gmail.com
Subject: [PATCH 1/3] ceph: fix flush_snap logic after putting caps
Date:   Fri, 11 Dec 2020 07:38:56 -0500
Message-Id: <20201211123858.7522-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211123858.7522-1-jlayton@kernel.org>
References: <20201211123858.7522-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A primary reason for skipping ceph_check_caps after putting the
references was to avoid the locking in ceph_check_caps during a
reconnect. __ceph_put_cap_refs can still call ceph_flush_snaps in that
case though, and that takes many of the same inconvenient locks.

Fix the logic in __ceph_put_cap_refs to skip flushing snaps when the
skip_checking_caps flag is set.

Fixes: e64f44a88465 (ceph: skip checking caps when session reconnecting and releasing reqs)
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e46871e2d9e0..336348e733b9 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3092,10 +3092,12 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
 	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
 	     last ? " last" : "", put ? " put" : "");
 
-	if (last && !skip_checking_caps)
-		ceph_check_caps(ci, 0, NULL);
-	else if (flushsnaps)
-		ceph_flush_snaps(ci, NULL);
+	if (!skip_checking_caps) {
+		if (last)
+			ceph_check_caps(ci, 0, NULL);
+		else if (flushsnaps)
+			ceph_flush_snaps(ci, NULL);
+	}
 	if (wake)
 		wake_up_all(&ci->i_cap_wq);
 	while (put-- > 0)
-- 
2.29.2

