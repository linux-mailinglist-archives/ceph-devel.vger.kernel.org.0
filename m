Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A449EC3E
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jan 2022 21:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbiA0UIy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Jan 2022 15:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiA0UIx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Jan 2022 15:08:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A32AC061714
        for <ceph-devel@vger.kernel.org>; Thu, 27 Jan 2022 12:08:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 683BDB8210C
        for <ceph-devel@vger.kernel.org>; Thu, 27 Jan 2022 20:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E376DC340E4;
        Thu, 27 Jan 2022 20:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643314131;
        bh=/NIgIGgTeSnCxxrxcu1RKz9eRPXX9m8lrZSG3fTqu2k=;
        h=From:To:Cc:Subject:Date:From;
        b=cO0R0Skya5D2UUVLVHQBydJxra2VauFcsunUov4M5WPlokchV+7oKUpfT3XLRFZ25
         iKqXPxUuXMbCJcxFrhUQ9kdY6wDPnwFjWvbb05iIdDsX1tA/SLBK+RyGIFqoAPiOH6
         9KuHY0KLU4OGhkh1BGpOPQNIfX+oTF6OaQJCatejP+R/yKuPVXbKstDCjY6gHMAa4N
         846IJ6TnOlVhbvyifAzAC9SHJgcqZkHiijp5O/VoO3nMI+Xi4S+O5nb0wRbETMwe9X
         ds3HVJ/2PEgNKH3UtYGBJagKUKWkz6qQ1LrvXUXpW2OpR+k0SK7BtNzaW5/G027vSQ
         WGFaqBZsjK14Q==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: wake waiters on any IMPORT that grants new caps
Date:   Thu, 27 Jan 2022 15:08:49 -0500
Message-Id: <20220127200849.96580-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've noticed an intermittent hang waiting for caps in some testing. What
I see is that the client will try to get caps for an operation (e.g. a
read), and ends up waiting on the waitqueue forever. The caps debugfs
file however shows that the caps it's waiting on have already been
granted.

The current grant handling code will wake the waitqueue when it sees
that there are newly-granted caps in the issued set. On an import
however, we'll end up adding a new cap first, which fools the logic into
thinking that nothing has changed. A later hack in the code works around
this, but only for auth caps.

Ensure we wake the waiters whenever we get an IMPORT that grants new
caps for the inode.

URL: https://tracker.ceph.com/issues/54044
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

I'm still testing this patch, but I think this may be the cause of some
mysterious hangs I've hit in testing.

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e668cdb9c99e..06b65a68e920 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3541,21 +3541,22 @@ static void handle_cap_grant(struct inode *inode,
 			fill_inline = true;
 	}
 
-	if (ci->i_auth_cap == cap &&
-	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
+	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
 		if (newcaps & ~extra_info->issued)
 			wake = true;
 
-		if (ci->i_requested_max_size > max_size ||
-		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
-			/* re-request max_size if necessary */
-			ci->i_requested_max_size = 0;
-			wake = true;
-		}
+		if (ci->i_auth_cap == cap) {
+			if (ci->i_requested_max_size > max_size ||
+			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
+				/* re-request max_size if necessary */
+				ci->i_requested_max_size = 0;
+				wake = true;
+			}
 
-		ceph_kick_flushing_inode_caps(session, ci);
-		spin_unlock(&ci->i_ceph_lock);
-		up_read(&session->s_mdsc->snap_rwsem);
+			ceph_kick_flushing_inode_caps(session, ci);
+			spin_unlock(&ci->i_ceph_lock);
+			up_read(&session->s_mdsc->snap_rwsem);
+		}
 	} else {
 		spin_unlock(&ci->i_ceph_lock);
 	}
-- 
2.34.1

