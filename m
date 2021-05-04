Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4D6372CF9
	for <lists+ceph-devel@lfdr.de>; Tue,  4 May 2021 17:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbhEDPeS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 May 2021 11:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:32810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230112AbhEDPeR (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 May 2021 11:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C383A6112F;
        Tue,  4 May 2021 15:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620142402;
        bh=5OLQbK1jg3+ANuSrVbLRW6BvwmTY1QUlx+oajrR5rk0=;
        h=From:To:Cc:Subject:Date:From;
        b=Pw9xjmSfZI1O7F9UZG8hTgRZzHdZrK3SNSYiFbqAb8eOIU1YudB+ULdf3/NmM60p3
         arpmm4O+r9G1d9/Z1bz0trZZ/DTczFiD4vgunj8RVdUbvlYyP7PWxDaiuKy/bXDTji
         JC1GVwmuCm0SAwC/UzRNQFl3te6uwW+gblA5vmzCAqyO0vVc5s+JuD40onIG7XKjmo
         p4gtj3w+bYcHjs2TEvJ+7eIraRTNxUWkcSyh+f6g6jy8sitZjevr7wA6DSBGqfXI/U
         OGuC4OU1EeGB5l4Dvk70sTUWxcqcuTaNQLS7/YWU2XbwgYiq/WA6jo2an0T6zuZ3xd
         xEc8EEXyqxqKw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Sha Zhengju <handai.szj@taobao.com>,
        Sage Weil <sage@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2] ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
Date:   Tue,  4 May 2021 11:33:20 -0400
Message-Id: <20210504153320.97068-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The checks for page->mapping are odd, as set_page_dirty is an
address_space operation, and I don't see where it would be called on a
non-pagecache page.

The warning about the page lock is also seems bogus.  The comment over
set_page_dirty() says that it can be called without the page lock in
some rare cases. I don't think we want to warn if that's the case.

Cc: Sha Zhengju <handai.szj@taobao.com>
Cc: Sage Weil <sage@redhat.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b47303b3772a..ecbc0f71e3ab 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -82,10 +82,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_snap_context *snapc;
-	int ret;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
@@ -130,11 +126,7 @@ static int ceph_set_page_dirty(struct page *page)
 	BUG_ON(PagePrivate(page));
 	attach_page_private(page, snapc);
 
-	ret = __set_page_dirty_nobuffers(page);
-	WARN_ON(!PageLocked(page));
-	WARN_ON(!page->mapping);
-
-	return ret;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /*
-- 
2.31.1

