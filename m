Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBF2443779
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Nov 2021 21:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhKBUs0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Nov 2021 16:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229813AbhKBUsY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 16:48:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BC0360EB8;
        Tue,  2 Nov 2021 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635885949;
        bh=tmQuDYGFpaMo+iq9KNKk84t35BmtlWxsat5mlEXrevw=;
        h=From:To:Cc:Subject:Date:From;
        b=rJaIIkIT3qKNmntSOyxPBroUDnI0RHcKWle7qvwO7HcBCuJCgKE4hcPjvY5iMgbNT
         UnYungD9J0GQ92sZc3HlZbf+GHhN7hi/yB39xRUBLfu91faWC6NB8nGfUKaqIdv3sq
         lhfq+eD/UMirTFJTnF5NMntI1xRAjqJwDuvcTDKzUeAGoqXtsrMw82uTkYfrAHYXad
         rmftmPJNiwI+QLh1qRAdATItgjd8+L+ADq8r+eJkWKt69KNIJS+iF+LTzxs52bNyQF
         zlr/MvTTMBeycyvGiqOBnqlg/+AABRgzWVDud5/mz+4lOnBi5Ox9vf6r99LkREpOzT
         5C8QfH/fP7H5w==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     Sachin Prabhu <sprabhu@redhat.com>
Subject: [PATCH v2] ceph: properly handle statfs on multifs setups
Date:   Tue,  2 Nov 2021 16:45:47 -0400
Message-Id: <20211102204547.253710-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_statfs currently stuffs the cluster fsid into the f_fsid field.
This was fine when we only had a single filesystem per cluster, but now
that we have multiples we need to use something that will vary between
them.

Change ceph_statfs to xor each 32-bit chunk of the fsid (aka cluster id)
into the lower bits of the statfs->f_fsid. Change the lower bits to hold
the fscid (filesystem ID within the cluster).

That should give us a value that is guaranteed to be unique between
filesystems within a cluster, and should minimize the chance of
collisions between mounts of different clusters.

URL: https://tracker.ceph.com/issues/52812
Reported-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

While looking at making an equivalent change to the userland libraries,
it occurred to me that the earlier patch's method for computing this
was overly-complex. This makes it a bit simpler, and avoids the
intermediate step of setting up a u64.

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9bb88423417e..e7b839aa08f6 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -52,8 +52,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(d_inode(dentry));
 	struct ceph_mon_client *monc = &fsc->client->monc;
 	struct ceph_statfs st;
-	u64 fsid;
-	int err;
+	int i, err;
 	u64 data_pool;
 
 	if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
@@ -99,12 +98,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_namelen = NAME_MAX;
 
 	/* Must convert the fsid, for consistent values across arches */
+	buf->f_fsid.val[0] = 0;
 	mutex_lock(&monc->mutex);
-	fsid = le64_to_cpu(*(__le64 *)(&monc->monmap->fsid)) ^
-	       le64_to_cpu(*((__le64 *)&monc->monmap->fsid + 1));
+	for (i = 0; i < 4; ++i)
+		buf->f_fsid.val[0] ^= le32_to_cpu(((__le32 *)&monc->monmap->fsid)[i]);
 	mutex_unlock(&monc->mutex);
 
-	buf->f_fsid = u64_to_fsid(fsid);
+	/* fold the fs_cluster_id into the upper bits */
+	buf->f_fsid.val[1] = monc->fs_cluster_id;
 
 	return 0;
 }
-- 
2.31.1

