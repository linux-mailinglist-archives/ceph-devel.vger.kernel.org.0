Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6C148777
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfFQPiJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbfFQPiH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:07 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452BE21873;
        Mon, 17 Jun 2019 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785886;
        bh=VRJOytUCj/aUHeySva5DONr4fD3ZvULl8qvlSHtr38w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2OZdLbFYPRxWbMgizY0VH6gFpSS48JV/HEcQXtlDTixJ8yWz8s6dro47othIZn/J
         glBgcIM92jDb2eQbpTLsh6SpeBlL4HBnErSy5iEavOui9Hu4FhXMXoOptvh/QqZ9aA
         yaH9deJc2TnSKRbBSgSWe0Yy3emlGcj5oQwEEdRM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 14/18] ceph: allow querying of STATX_BTIME in ceph_getattr
Date:   Mon, 17 Jun 2019 11:37:49 -0400
Message-Id: <20190617153753.3611-15-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 211947e3c737..d06c492a2947 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2307,7 +2307,7 @@ static int statx_to_caps(u32 want)
 {
 	int mask = 0;
 
-	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME))
+	if (want & (STATX_MODE|STATX_UID|STATX_GID|STATX_CTIME|STATX_BTIME))
 		mask |= CEPH_CAP_AUTH_SHARED;
 
 	if (want & (STATX_NLINK|STATX_CTIME))
@@ -2332,6 +2332,7 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	u32 valid_mask = STATX_BASIC_STATS;
 	int err = 0;
 
 	/* Skip the getattr altogether if we're asked not to sync */
@@ -2344,6 +2345,16 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
 
 	generic_fillattr(inode, stat);
 	stat->ino = ceph_translate_ino(inode->i_sb, inode->i_ino);
+
+	/*
+	 * btime on newly-allocated inodes is 0, so if this is still set to
+	 * that, then assume that it's not valid.
+	 */
+	if (ci->i_btime.tv_sec || ci->i_btime.tv_nsec) {
+		stat->btime = ci->i_btime;
+		valid_mask |= STATX_BTIME;
+	}
+
 	if (ceph_snap(inode) == CEPH_NOSNAP)
 		stat->dev = inode->i_sb->s_dev;
 	else
@@ -2367,7 +2378,6 @@ int ceph_getattr(const struct path *path, struct kstat *stat,
 			stat->nlink = 1 + 1 + ci->i_subdirs;
 	}
 
-	/* Mask off any higher bits (e.g. btime) until we have support */
-	stat->result_mask = request_mask & STATX_BASIC_STATS;
+	stat->result_mask = request_mask & valid_mask;
 	return err;
 }
-- 
2.21.0

