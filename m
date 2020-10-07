Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F29C285EE7
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Oct 2020 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgJGMRF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Oct 2020 08:17:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgJGMRF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Oct 2020 08:17:05 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D6B9207EA;
        Wed,  7 Oct 2020 12:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602073024;
        bh=W+WRJiA5Dyo40yCBkIH+gN+ujGTSXHZQ4oEjCxbLe9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DSVKKII5xM9AmVEcUJGz8RKpgR7sQzfReroUEAcGtLTLG1LWFg43NKS45THYxpOHP
         skUuhUZxW+WmsaC8leOSrgO97u6a3uuQlggvLnE2mwGSbu0UJuQLzL3etwl5ns/AGC
         6wyteHzJYOkNztuGrz18STHYNeSzx03KfjHYOt04=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [PATCH v4 1/5] ceph: don't WARN when removing caps due to blocklisting
Date:   Wed,  7 Oct 2020 08:16:56 -0400
Message-Id: <20201007121700.10489-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007121700.10489-1-jlayton@kernel.org>
References: <20201007121700.10489-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We expect to remove dirty caps when the client is blocklisted. Don't
throw a warning in that case.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c7e69547628e..2ee3f316afcf 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1149,7 +1149,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	/* remove from inode's cap rbtree, and clear auth cap */
 	rb_erase(&cap->ci_node, &ci->i_caps);
 	if (ci->i_auth_cap == cap) {
-		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item));
+		WARN_ON_ONCE(!list_empty(&ci->i_dirty_item) && !mdsc->fsc->blocklisted);
 		ci->i_auth_cap = NULL;
 	}
 
-- 
2.26.2

