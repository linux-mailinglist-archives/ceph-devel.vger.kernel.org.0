Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2049BDBA
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jan 2022 22:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbiAYVK1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jan 2022 16:10:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50234 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbiAYVK0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jan 2022 16:10:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64EE5B81AC6
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jan 2022 21:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30C6C340E6;
        Tue, 25 Jan 2022 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643145024;
        bh=t9sLcvDrKHZ/cimpRC39aqht6OgXzBsuCwY1/bNFfFw=;
        h=From:To:Cc:Subject:Date:From;
        b=vI7/YocGNRxBYenRo6HNHRooCzsSROZymieYMM37VMDewmqiJnYKf5Gcs2QK8tf2w
         xQmRrQYtMQNqwjgQeqXstvtoV8aWdGRZgVEn8jc8uaLP2mCTqZ/vx5wS08qJHjXoC/
         TmUuZcF30brEItbtKrySOLUbkFuJsN27uRma68+75B084Thghl5w1RTS49Mc47hlOj
         EREtwon21gNfl9WpLGOxlvGGkQh0/GCeSrYzxRBpurQBIGXmo4bhfVANSUf8862vPE
         lFjzmHdtJNiqOQFmlb9/8SeUe3GArHNNhv/hWRX+IXNhPfyP0bO/7Sp04bJRKrHldl
         X7GCAb+S+V8lA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Dan van der Ster <dan@vanderster.com>
Subject: [PATCH] ceph: set pool_ns in new inode layout for async creates
Date:   Tue, 25 Jan 2022 16:10:22 -0500
Message-Id: <20220125211022.114286-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dan reported that he was unable to write to files that had been
asynchronously created when the client's OSD caps are restricted to a
particular namespace.

The issue is that the layout for the new inode is only partially being
filled. Ensure that we populate the pool_ns_data and pool_ns_len in the
iinfo before calling ceph_fill_inode.

Reported-by: Dan van der Ster <dan@vanderster.com>
Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index cbe4d5a5cde5..efea321ff643 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -599,6 +599,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	struct ceph_inode_info *ci = ceph_inode(dir);
 	struct inode *inode;
 	struct timespec64 now;
+	struct ceph_string *pool_ns;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
 	struct ceph_vino vino = { .ino = req->r_deleg_ino,
 				  .snap = CEPH_NOSNAP };
@@ -648,11 +649,17 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	in.max_size = cpu_to_le64(lo->stripe_unit);
 
 	ceph_file_layout_to_legacy(lo, &in.layout);
+	pool_ns = ceph_try_get_string(lo->pool_ns);
+	if (pool_ns) {
+		iinfo.pool_ns_len = pool_ns->len;
+		iinfo.pool_ns_data = pool_ns->str;
+	}
 
 	down_read(&mdsc->snap_rwsem);
 	ret = ceph_fill_inode(inode, NULL, &iinfo, NULL, req->r_session,
 			      req->r_fmode, NULL);
 	up_read(&mdsc->snap_rwsem);
+	ceph_put_string(pool_ns);
 	if (ret) {
 		dout("%s failed to fill inode: %d\n", __func__, ret);
 		ceph_dir_clear_complete(dir);
-- 
2.34.1

