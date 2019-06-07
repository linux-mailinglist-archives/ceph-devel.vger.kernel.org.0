Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9AC38F47
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfFGPij (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730010AbfFGPi3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:29 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E5BA21655;
        Fri,  7 Jun 2019 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921909;
        bh=VRJOytUCj/aUHeySva5DONr4fD3ZvULl8qvlSHtr38w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyCBIS/z8ci5idkSiZYoXrwxTXJnA4PtUISeeC+sDqTA6n5XmsgXE+V9+Ujf93Sc4
         aa8nqf5YLkhjlqblCqcKwchYMCI0PzJAM2iFl6Dn+Ubvmbb3XdJT45c8Ja90P3Kjef
         6kX7w1gPTbuUzUnOW1lVCw1sKGS5EU6SaOpL9Q1Y=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 12/16] ceph: allow querying of STATX_BTIME in ceph_getattr
Date:   Fri,  7 Jun 2019 11:38:12 -0400
Message-Id: <20190607153816.12918-13-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
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

