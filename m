Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D031D8160
	for <lists+ceph-devel@lfdr.de>; Mon, 18 May 2020 19:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgERRrf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 May 2020 13:47:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:53750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729715AbgERRra (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 May 2020 13:47:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 027DCACE6;
        Mon, 18 May 2020 17:47:30 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 1911f9ee;
        Mon, 18 May 2020 18:47:26 +0100 (WEST)
Date:   Mon, 18 May 2020 18:47:26 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] ceph: don't return -ESTALE if there's still an open file
Message-ID: <20200518174726.GA84496@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Similarly to commit 03f219041fdb ("ceph: check i_nlink while converting
a file handle to dentry"), this fixes another corner case with
name_to_handle_at/open_by_handle_at.  The issue has been detected by
xfstest generic/467, when doing:

 - name_to_handle_at("/cephfs/myfile")
 - open("/cephfs/myfile")
 - unlink("/cephfs/myfile")
 - sync; sync;
 - drop caches
 - open_by_handle_at()

The call to open_by_handle_at should not fail because the file hasn't been
deleted yet (only unlinked) and we do have a valid handle to it.  -ESTALE
shall be returned only if i_nlink is 0 *and* i_count is 1.

This patch also makes sure we have LINK caps before checking i_nlink.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
Hi!

(and sorry for the delay in my reply!)

So, from the discussion thread and some IRC chat with Jeff, I'm sending
v2.  What changed?  Everything! :-)

- Use i_count instead of __ceph_is_file_opened to check for open files
- Add call to ceph_do_getattr to make sure we have LINK caps before
  accessing i_nlink

Cheers,
--
Luis

 fs/ceph/export.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 79dc06881e78..e088843a7734 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -172,9 +172,16 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
 static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 {
 	struct inode *inode = __lookup_inode(sb, ino);
+	int err;
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
-	if (inode->i_nlink == 0) {
+	/* We need LINK caps to reliably check i_nlink */
+	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
+	if (err)
+		return ERR_PTR(err);
+	/* -ESTALE if inode as been unlinked and no file is open */
+	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}

