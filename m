Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52941D2DF7
	for <lists+ceph-devel@lfdr.de>; Thu, 14 May 2020 13:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgENLO5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 May 2020 07:14:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:60090 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgENLO5 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 May 2020 07:14:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 60498B03E;
        Thu, 14 May 2020 11:14:58 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id 5cfcdbe1;
        Thu, 14 May 2020 12:14:53 +0100 (WEST)
Date:   Thu, 14 May 2020 12:14:53 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: don't return -ESTALE if there's still an open file
Message-ID: <20200514111453.GA99187@suse.com>
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
 - open_by_handle_at()

The call to open_by_handle_at should not fail because the file still
exists and we do have a valid handle to it.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/export.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index 79dc06881e78..8556df9d94d0 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -171,12 +171,21 @@ struct inode *ceph_lookup_inode(struct super_block *sb, u64 ino)
 
 static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
 {
+	struct ceph_inode_info *ci;
 	struct inode *inode = __lookup_inode(sb, ino);
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 	if (inode->i_nlink == 0) {
-		iput(inode);
-		return ERR_PTR(-ESTALE);
+		bool is_open;
+		ci = ceph_inode(inode);
+		spin_lock(&ci->i_ceph_lock);
+		is_open = __ceph_is_file_opened(ci);
+		spin_unlock(&ci->i_ceph_lock);
+		if (!is_open) {
+			iput(inode);
+			return ERR_PTR(-ESTALE);
+		}
 	}
 	return d_obtain_alias(inode);
 }
