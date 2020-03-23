Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46EB18F953
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 17:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgCWQHS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 12:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgCWQHP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 12:07:15 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42B3120722;
        Mon, 23 Mar 2020 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584979634;
        bh=nAtWltXtB/RI+VhP4YFP0ZqGlKEcizz/ohcMBrFhkQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/VgKcaDvmhXKgtiMKoqcno4EG9oPVn39toGESTju/kZGnD+XkAHRJvf0VVv1UF0n
         Tciklo8XhQOmdVyInGaf4kNp24F+djtyV0FxEe6YN4OSmNhe+ziU9tvTBGZ4h77xzi
         Ug8VP1QXKbotR6zA3ANaLUf4spE72bXroHUtVdh8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 6/8] ceph: document what protects i_dirty_item and i_flushing_item
Date:   Mon, 23 Mar 2020 12:07:06 -0400
Message-Id: <20200323160708.104152-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-1-jlayton@kernel.org>
References: <20200323160708.104152-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/super.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 47cfd8935b9c..bb372859c0ad 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -351,7 +351,9 @@ struct ceph_inode_info {
 	struct rb_root i_caps;           /* cap list */
 	struct ceph_cap *i_auth_cap;     /* authoritative cap, if any */
 	unsigned i_dirty_caps, i_flushing_caps;     /* mask of dirtied fields */
-	struct list_head i_dirty_item, i_flushing_item;
+	struct list_head i_dirty_item, i_flushing_item; /* protected by
+							 * mdsc->cap_dirty_lock
+							 */
 	/* we need to track cap writeback on a per-cap-bit basis, to allow
 	 * overlapping, pipelined cap flushes to the mds.  we can probably
 	 * reduce the tid to 8 bits if we're concerned about inode size. */
-- 
2.25.1

