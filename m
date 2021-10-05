Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222DC422C86
	for <lists+ceph-devel@lfdr.de>; Tue,  5 Oct 2021 17:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhJEPcN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 5 Oct 2021 11:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhJEPcL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 5 Oct 2021 11:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CED961159;
        Tue,  5 Oct 2021 15:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633447820;
        bh=Xao5G81KefyfLoku0fs2YYIQFHEYjpe5xHDpDyL5y10=;
        h=From:To:Cc:Subject:Date:From;
        b=NUzgcDk5aMaZ1Pxjk1+ZmlLFnD4IxxdMEJ9Cqrh9ZykBBpU0YaFmrh6m+k0MeWk8u
         c2zvNbDPkFoznzac2eTKDAS6phzfSjl1UDZcIFzosafg6F6latrXFQAXeQ/Yt5aRmW
         5UVax4Xq+lBWstTHWx97JTkbmkKI7oDfMBDOfwD0hgurgYYV7mgI2JOMPSsndYrMmf
         t6wGKZvRwAfbA6a+VR7Arp9lbmK+ox1UENDD0ARBs1zMh+RPsRhoXRaqylnBTAb0NV
         9q8QLGFiqEPaePv50TWWiXA5pi72tSTXmJYK3JKv4Fv+EC/TLpJsSIIsf6V9kuGScm
         6Io0uSqDXLOIA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Sachin Prabhu <sprabhu@redhat.com>
Subject: [PATCH] ceph: properly handle statfs on multifs setups
Date:   Tue,  5 Oct 2021 11:30:19 -0400
Message-Id: <20211005153019.79956-1-jlayton@kernel.org>
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

Change ceph_statfs to mix the current 64 bit hashed fsid down to 32 bits
using a trivial xor hash. Shift that to be the upper 32 bits in the
64 bit field and then fold in the fs_cluster_id from the mon client.

That should give us a value that is guaranteed to be unique between
filesystems within a cluster, and should minimize the chance of
collisions between mounts of different clusters.

URL: https://tracker.ceph.com/issues/52812
Reported-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 42c502eee80a..b6d2e20e857b 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -104,6 +104,12 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
 	       le64_to_cpu(*((__le64 *)&monc->monmap->fsid + 1));
 	mutex_unlock(&monc->mutex);
 
+	/* mix the fsid down to 32 bits */
+	fsid = *(u32 *)&fsid ^ *((u32 *)&fsid + 1);
+
+	/* fold the fs_cluster_id into the upper bits */
+	fsid |= ((u64)monc->fs_cluster_id << 32);
+
 	buf->f_fsid = u64_to_fsid(fsid);
 
 	return 0;
-- 
2.31.1

