Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8E845E4AB
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Nov 2021 03:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357822AbhKZCgL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Nov 2021 21:36:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357609AbhKZCeK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Nov 2021 21:34:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 900E261165;
        Fri, 26 Nov 2021 02:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893838;
        bh=3C/rKkiptL+Jw3Rga40jDqWCcCfnE9hvLpo2X7VYOwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL5wl1cRml8DtGUaN0mKaoZ5GTLCVIceRxY1UHoPm3rLs5qrT1JXl+Afxps6ft0U7
         5lJ49oSZLEfPCnqSzsKFOTqdKRI25ka5U07+pZA6rECie0xj1Di1RpWUtHk0jiCW/L
         rilQuOqBR5ECW4hpxErJr2rGz7DOw57pyBQITVgjM8l9jJMyvsmE8wDyADuT1pGMKa
         f6yxDfeAAcj/KZgi9UpzIqB9Sy3oMj8JiFTP3lbxDGRGDqnrkETXUqG7tK5U9o21lf
         tjmZX66TE77i3xu7siSDe66bncnEB/RcmhZl58Iq1QiodNAFB/BaRvR7KXTFxD62Cg
         9WgZVB2ULK8CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Sachin Prabhu <sprabhu@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 2/4] ceph: properly handle statfs on multifs setups
Date:   Thu, 25 Nov 2021 21:30:32 -0500
Message-Id: <20211126023034.440961-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023034.440961-1-sashal@kernel.org>
References: <20211126023034.440961-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8cfc0c7ed34f7929ce7e5d7c6eecf4d01ba89a84 ]

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
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index f33bfb255db8f..08c8d34c98091 100644
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
+	for (i = 0 ; i < sizeof(monc->monmap->fsid) / sizeof(__le32) ; ++i)
+		buf->f_fsid.val[0] ^= le32_to_cpu(((__le32 *)&monc->monmap->fsid)[i]);
 	mutex_unlock(&monc->mutex);
 
-	buf->f_fsid = u64_to_fsid(fsid);
+	/* fold the fs_cluster_id into the upper bits */
+	buf->f_fsid.val[1] = monc->fs_cluster_id;
 
 	return 0;
 }
-- 
2.33.0

