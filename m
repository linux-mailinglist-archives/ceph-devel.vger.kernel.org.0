Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B543BA2AA
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 17:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhGBPRO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 11:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232248AbhGBPRO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 11:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4CC061420;
        Fri,  2 Jul 2021 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625238882;
        bh=WnaAQzxMF6RUphCQtr0eQpppsZ8f7sYYN4MYla25xx4=;
        h=From:To:Cc:Subject:Date:From;
        b=Pe1jcHBYtAAgCuLfMHwUhm24ouG+c1HKZnCFa/kiuEODRan5hVyBtkbHHscIVtwG6
         iUZSOTmAzB+MHQCQQyhn5aQUevsHSiUrwzppt9XjYWR4ugzaadTVib0OVfvfl5OVhh
         S9zDx/ulHWargfzCMclm6+DWPOtGcqrURHFp6bmoEHXGFmE7VjD/MVud9vCoXvBbOh
         +5axXm5MefY1NjAdcD8oiv7NVPp3Bc5N3sLT6e/r3v4VYQxtlPrdRg/I3koK7+Znd2
         t5a6Nnk0X5yInXBx44Ysl23IgzSY07rHoJgTNIAf0rIyhJnd7N804ZBUfulG5wkiKj
         EtTYqYK46SOoA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: fix memory leak on decode error in ceph_handle_caps
Date:   Fri,  2 Jul 2021 11:14:40 -0400
Message-Id: <20210702151440.93978-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If we hit a decoding error late in the frame, then we might exit the
function without putting the pool_ns string. Ensure that we always put
that reference on the way out of the function.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7bdefd0c789a..a7120fe23055 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4129,8 +4129,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 done:
 	mutex_unlock(&session->s_mutex);
 done_unlocked:
-	ceph_put_string(extra_info.pool_ns);
 	iput(inode);
+out:
+	ceph_put_string(extra_info.pool_ns);
 	return;
 
 flush_cap_releases:
@@ -4141,11 +4142,10 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	 */
 	ceph_flush_cap_releases(mdsc, session);
 	goto done;
-
 bad:
 	pr_err("ceph_handle_caps: corrupt message\n");
 	ceph_msg_dump(msg);
-	return;
+	goto out;
 }
 
 /*
-- 
2.31.1

