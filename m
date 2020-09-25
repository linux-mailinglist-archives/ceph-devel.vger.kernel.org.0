Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C735278A61
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Sep 2020 16:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgIYOI4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Sep 2020 10:08:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728056AbgIYOIz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 10:08:55 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B00C20936;
        Fri, 25 Sep 2020 14:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601042934;
        bh=W+WRJiA5Dyo40yCBkIH+gN+ujGTSXHZQ4oEjCxbLe9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvfWgr8n58t26XHAJWVQuhkrIxRWz81tfvloI2JYWZNe9XImhQhT7GWyO62AjcZVT
         c/FTNLaohoiJMRw4HzFgzu5h6ng3JyLe7cNkHQo5x4qBLkExK+1eLhSK3av5tdJfMV
         qCYvxlKhgUYq20KLqPyKCoqLwSMKxzMnphaLe5jk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [RFC PATCH 1/4] ceph: don't WARN when removing caps due to blocklisting
Date:   Fri, 25 Sep 2020 10:08:48 -0400
Message-Id: <20200925140851.320673-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925140851.320673-1-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
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

