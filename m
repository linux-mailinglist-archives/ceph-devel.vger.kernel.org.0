Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71533FF3DB
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Sep 2021 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239024AbhIBTIQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Sep 2021 15:08:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347348AbhIBTIG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 15:08:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D12E96054E;
        Thu,  2 Sep 2021 19:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609628;
        bh=/VUzbhURx1s8b9RV4Amxc5CupQ4K7t2d0n5SCzYtJCc=;
        h=From:To:Cc:Subject:Date:From;
        b=WGllVGHdpZA2V3fgW/p7a2hGi59CUAVPQXK8L7V2byhRliiRmNhkesKEd3600SDVV
         J/rtsR2sZifxlS6Umyfh7A1gQ4c1Ohkb7PoCOBiktMnWDuVNdl+gXFWcBnIIWJycZG
         KurWIYTXdp+Y8WfLPtZo9GWjE8wfSx9LFoG8yjYBmOaiJpsgZ20sxfpCIZPv4sVxDD
         1J2Eg+ONdKeWByNA2PfsuZkC0YiXb0aYtdwiIyew6Kp0di8+SzkHrUXLjzDSRCIbmF
         UX75Rv/PyIEXD/Br8Zq/bW7s6UOQNdBqXcHPJ9Ql29OMgg5N+U0CwUxY2iI9oBALU6
         PUDnvCwkmxgkA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] ceph: lockdep annotations for try_nonblocking_invalidate
Date:   Thu,  2 Sep 2021 15:07:06 -0400
Message-Id: <20210902190706.46125-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cdd0ff376c6d..d22db2183d45 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1847,6 +1847,8 @@ static u64 __mark_caps_flushing(struct inode *inode,
  * try to invalidate mapping pages without blocking.
  */
 static int try_nonblocking_invalidate(struct inode *inode)
+	__releases(ci->i_ceph_lock)
+	__acquires(ci->i_ceph_lock)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u32 invalidating_gen = ci->i_rdcache_gen;
-- 
2.31.1

