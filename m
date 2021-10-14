Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F8042DFA8
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Oct 2021 18:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhJNQwL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Oct 2021 12:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231129AbhJNQwJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 12:52:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18BB06109E;
        Thu, 14 Oct 2021 16:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634230204;
        bh=rguS+p9ReWy9ScN7XVZPgG/sPYxmove/17TmuJNjH5g=;
        h=From:To:Cc:Subject:Date:From;
        b=l8D7VERUwvpPcDKfxTbntK6vH4drT6zSZl7t+ozFWybV3wVCFFyRsevcFFVuBAZfn
         vpBcUVheZsabtvP/o6dQHyIVCZsXGgAKNxnuRkpDCzxONT4d2CJrx4LY1tU+dCkTxI
         g18Vlafinckb8UpeOWMvC8QNqwA8akjATVLciOKushnoBQDjWByjqgvOdkWyKa1sBP
         VF/dany3f8cHyVfWRTLr38NUYGgJ6wx0GuRZ0Gt1rjVjmmDTPXKkyZAI3/tXuq5mlb
         Xbk0jwJiw3bnIQD80r96gnhKc9P39G0XVNMUBsFDhF7zVCT/wap2j0teeKOcZh9Ut5
         6MDnnRGN9mDEQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Greg Farnum <gfarnum@redhat.com>
Subject: [PATCH] ceph: shut down mount on bad mdsmap or fsmap decode
Date:   Thu, 14 Oct 2021 12:50:02 -0400
Message-Id: <20211014165002.92052-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

As Greg pointed out, if we get a mangled mdsmap or fsmap, then something
has gone very wrong, and we should avoid doing any activity on the
filesystem.

When this occurs, shut down the mount the same way we would with a
forced umount by calling ceph_umount_begin when decoding fails on either
map. This causes most operations done against the filesystem to return
an error. Any dirty data or caps in the cache will be dropped as well.

The effect is not reversible, so the only remedy is to umount.

URL: https://tracker.ceph.com/issues/52303
Cc: Greg Farnum <gfarnum@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 6 ++++--
 fs/ceph/super.c      | 2 +-
 fs/ceph/super.h      | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 598425ccd020..5490f3422ae2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5011,7 +5011,8 @@ void ceph_mdsc_handle_fsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 	return;
 
 bad:
-	pr_err("error decoding fsmap\n");
+	pr_err("error decoding fsmap. Shutting down mount.\n");
+	ceph_umount_begin(mdsc->fsc->sb);
 err_out:
 	mutex_lock(&mdsc->mutex);
 	mdsc->mdsmap_err = err;
@@ -5078,7 +5079,8 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 bad_unlock:
 	mutex_unlock(&mdsc->mutex);
 bad:
-	pr_err("error decoding mdsmap %d\n", err);
+	pr_err("error decoding mdsmap %d. Shutting down mount.\n", err);
+	ceph_umount_begin(mdsc->fsc->sb);
 	return;
 }
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 580dad2c832e..fea6e69b94a0 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -969,7 +969,7 @@ static void __ceph_umount_begin(struct ceph_fs_client *fsc)
  * ceph_umount_begin - initiate forced umount.  Tear down the
  * mount, skipping steps that may hang while waiting for server(s).
  */
-static void ceph_umount_begin(struct super_block *sb)
+void ceph_umount_begin(struct super_block *sb)
 {
 	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 49ca2106f853..7c3990cd3c3b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -947,6 +947,7 @@ extern void ceph_put_snapid_map(struct ceph_mds_client* mdsc,
 				struct ceph_snapid_map *sm);
 extern void ceph_trim_snapid_map(struct ceph_mds_client *mdsc);
 extern void ceph_cleanup_snapid_map(struct ceph_mds_client *mdsc);
+void ceph_umount_begin(struct super_block *sb);
 
 
 /*
-- 
2.31.1

