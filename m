Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7514A403A41
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbhIHNFI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:05:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235591AbhIHNEt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 303BB61163;
        Wed,  8 Sep 2021 13:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106220;
        bh=m8Wh4FYioSxicPi3kGRsyoOrcFb8crodjVm0ooh5MyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnNvrfvZH0kcxizzEq06nofNsyCuiMgkv0Bx0Lc56dDipvjrz1iUPEX29mFU5FZCo
         f6sL60KMwb7mHWjm/VXpyTF9QxiCNFcIG40NlW4Y+2PO1Y0yBfGcDQhFAN5fOC6dGc
         I56L+R4BcJ2IhDAAW1D79ggMZ/p65XCFDrnquiekQjDNxhq6YwG1rxDSdOVnU3iJBW
         4OQLfeUVEEBikABRrwLzvaithLPHE1Jp+/cDxhkv7b9Tl0d5AslYNz5kKFoLuBcpIo
         dWAz33RKMprr3oC/HE8aUOP7tsdTPYY4gncgXEm9xSqxJw74gb1pnr+PbDwebJmHw9
         BMh2udwQ5OoVQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 4/6] ceph: fix auth cap handling logic in remove_session_caps_cb
Date:   Wed,  8 Sep 2021 09:03:34 -0400
Message-Id: <20210908130336.56668-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210908130336.56668-1-jlayton@kernel.org>
References: <20210908130336.56668-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The existing logic relies on ci->i_auth_cap being NULL, but if we end up
removing the auth cap early, then we'll do a lot of useless work and
lock-taking on the remaining caps. Ensure that we only do the auth cap
removal when we're _actually_ removing the auth cap.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2ff4e6481d09..4b3ef0412539 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1626,6 +1626,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	bool is_auth;
 	bool dirty_dropped = false;
 	bool invalidate = false;
 	int capsnap_release = 0;
@@ -1633,8 +1634,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	dout("removing cap %p, ci is %p, inode is %p\n",
 	     cap, ci, &ci->vfs_inode);
 	spin_lock(&ci->i_ceph_lock);
+	is_auth = (cap == ci->i_auth_cap);
 	__ceph_remove_cap(cap, false);
-	if (!ci->i_auth_cap) {
+	if (is_auth) {
 		struct ceph_cap_flush *cf;
 
 		if (READ_ONCE(fsc->mount_state) >= CEPH_MOUNT_SHUTDOWN) {
-- 
2.31.1

