Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0842B0301
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 11:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgKLKpD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 05:45:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:49932 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgKLKpC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 05:45:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BEE5BABCC;
        Thu, 12 Nov 2020 10:45:00 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 753283bd;
        Thu, 12 Nov 2020 10:45:13 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] ceph: fix race in concurrent __ceph_remove_cap invocations
Date:   Thu, 12 Nov 2020 10:45:12 +0000
Message-Id: <20201112104512.17472-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

A NULL pointer dereference may occur in __ceph_remove_cap with some of the
callbacks used in ceph_iterate_session_caps, namely trim_caps_cb and
remove_session_caps_cb.  These aren't protected against the concurrent
execution of __ceph_remove_cap.

Since the callers of this function hold the i_ceph_lock, the fix is simply
a matter of returning immediately if caps->ci is NULL.

Based on a patch from Jeff Layton.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/43272
Link: https://www.spinics.net/lists/ceph-devel/msg47064.html
Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
 fs/ceph/caps.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index ded4229c314a..443f164760d5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1140,12 +1140,19 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 {
 	struct ceph_mds_session *session = cap->session;
 	struct ceph_inode_info *ci = cap->ci;
-	struct ceph_mds_client *mdsc =
-		ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
+	struct ceph_mds_client *mdsc;
 	int removed = 0;
 
+	/* 'ci' being NULL means he remove have already occurred */
+	if (!ci) {
+		dout("%s: cap inode is NULL\n", __func__);
+		return;
+	}
+
 	dout("__ceph_remove_cap %p from %p\n", cap, &ci->vfs_inode);
 
+	mdsc = ceph_inode_to_client(&ci->vfs_inode)->mdsc;
+
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
 	if (ci->i_auth_cap == cap) {
