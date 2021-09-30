Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E915741DFB5
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Sep 2021 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345855AbhI3REr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Sep 2021 13:04:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345220AbhI3REr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 13:04:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6C69613D0;
        Thu, 30 Sep 2021 17:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633021384;
        bh=fZAKLyOUQRksMyEmkyscUDhk7mdnRw+7fwiEtM8mk1g=;
        h=From:To:Cc:Subject:Date:From;
        b=LrdU0s4jU6p8RwoFf3BiTXkAExgjU7YCNixJrXOT36mvdttqXUCJsdtL8iJ7b5djC
         LUPffAm3GcCqCQl0ul7AIWdtEFuOydJMBUjJKJuZJ7odreLDEqIGRGUn0v2NQCFByc
         IJYXoMS3WL0fWksEPgs5HPNCNFhOxtAuQtfTqTB577H2vSK0fLwPmuQR17MkIPDWni
         9BZMM1qZS9KauRDIj/N9zMMu7cZ/i/XJoLNlCxhHDx/GLbPnoF+u9wHuyO75RMHSM5
         4CJjKrJrWy7j0zYi8AFL0SpRdH+qeDdWkSiJVReks8t4BcqzEFpD/0ZtnZ9eHdZ1sY
         ssjC8d9nVgkiw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        Niels de Vos <ndevos@redhat.com>
Subject: [PATCH v2] ceph: skip existing superblocks that are blocklisted when mounting
Date:   Thu, 30 Sep 2021 13:03:02 -0400
Message-Id: <20210930170302.74924-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently when mounting, we may end up finding an existing superblock
that corresponds to a blocklisted MDS client. This means that the new
mount ends up being unusable.

If we've found an existing superblock with a client that is already
blocklisted, and the client is not configured to recover on its own,
fail the match.

While we're in here, also rename "other" to the more conventional "fsc".

Cc: Patrick Donnelly <pdonnell@redhat.com>
Cc: Niels de Vos <ndevos@redhat.com>
URL: https://bugzilla.redhat.com/show_bug.cgi?id=1901499
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f517ad9eeb26..a7f1b66a91a7 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1123,16 +1123,16 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 	struct ceph_fs_client *new = fc->s_fs_info;
 	struct ceph_mount_options *fsopt = new->mount_options;
 	struct ceph_options *opt = new->client->options;
-	struct ceph_fs_client *other = ceph_sb_to_client(sb);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
 
 	dout("ceph_compare_super %p\n", sb);
 
-	if (compare_mount_options(fsopt, opt, other)) {
+	if (compare_mount_options(fsopt, opt, fsc)) {
 		dout("monitor(s)/mount options don't match\n");
 		return 0;
 	}
 	if ((opt->flags & CEPH_OPT_FSID) &&
-	    ceph_fsid_compare(&opt->fsid, &other->client->fsid)) {
+	    ceph_fsid_compare(&opt->fsid, &fsc->client->fsid)) {
 		dout("fsid doesn't match\n");
 		return 0;
 	}
@@ -1140,6 +1140,11 @@ static int ceph_compare_super(struct super_block *sb, struct fs_context *fc)
 		dout("flags differ\n");
 		return 0;
 	}
+	/* Exclude any blocklisted superblocks */
+	if (fsc->blocklisted && !(fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)) {
+		dout("mds client is blocklisted (and CLEANRECOVER is not set)\n");
+		return 0;
+	}
 	return 1;
 }
 
-- 
2.31.1

