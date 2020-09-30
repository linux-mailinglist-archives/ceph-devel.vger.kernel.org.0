Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F39827E83F
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Sep 2020 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgI3MKa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Sep 2020 08:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgI3MKa (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 08:10:30 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 139AE20789;
        Wed, 30 Sep 2020 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601467829;
        bh=QwuRINCGtX1bXvsKTty6G1UeJJCNBikXox0OBaxpkUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y76Opl9zS0/LnIET59Em/KiIwLTntuLlKFe6hHeIAp4fT1axBnntq6AKH+7uUIyWn
         ORPjPm69ue7/DwilAlJ0eXESX3rumVqqlTCzgC6zFxAiGoviY5IkdQejemZHhwirsl
         2hM8pnhl7qyFMTkuaoziimANnCCk/d7ccR1tj2NE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [RFC PATCH v2 2/4] ceph: don't mark mount as SHUTDOWN when recovering session
Date:   Wed, 30 Sep 2020 08:10:23 -0400
Message-Id: <20200930121025.9257-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930121025.9257-1-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
 <20200930121025.9257-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When recovering a session (a'la recover_session=clean), we want to do
all of the operations that we do on a forced umount, but changing the
mount state to SHUTDOWN is wrong and can cause queued MDS requests to
fail when the session comes back.

Only mark it as SHUTDOWN when umount_begin is called.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 2516304379d3..46a0e4e1b177 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -832,6 +832,13 @@ static void destroy_caches(void)
 	ceph_fscache_unregister();
 }
 
+static void __ceph_umount_begin(struct ceph_fs_client *fsc)
+{
+	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
+	ceph_mdsc_force_umount(fsc->mdsc);
+	fsc->filp_gen++; // invalidate open files
+}
+
 /*
  * ceph_umount_begin - initiate forced umount.  Tear down the
  * mount, skipping steps that may hang while waiting for server(s).
@@ -844,9 +851,7 @@ static void ceph_umount_begin(struct super_block *sb)
 	if (!fsc)
 		return;
 	fsc->mount_state = CEPH_MOUNT_SHUTDOWN;
-	ceph_osdc_abort_requests(&fsc->client->osdc, -EIO);
-	ceph_mdsc_force_umount(fsc->mdsc);
-	fsc->filp_gen++; // invalidate open files
+	__ceph_umount_begin(fsc);
 }
 
 static const struct super_operations ceph_super_ops = {
@@ -1235,7 +1240,7 @@ int ceph_force_reconnect(struct super_block *sb)
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 	int err = 0;
 
-	ceph_umount_begin(sb);
+	__ceph_umount_begin(fsc);
 
 	/* Make sure all page caches get invalidated.
 	 * see remove_session_caps_cb() */
-- 
2.26.2

