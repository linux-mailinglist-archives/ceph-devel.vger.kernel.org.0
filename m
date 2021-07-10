Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55B53C398C
	for <lists+ceph-devel@lfdr.de>; Sun, 11 Jul 2021 01:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhGKAA4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 10 Jul 2021 20:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233499AbhGJX6e (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B7AE61420;
        Sat, 10 Jul 2021 23:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961194;
        bh=K/um/lfJ9Ws0nA0pA/xXEP7knKZgHoSKQ7OfxnKKJuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mTxwcceT+Q5IBhr+njBNIt8E8u8UaDntX2U9/ic77HVvI/e/QHJvVTCAM/DMfmAC6
         MVTkHlTvPfdvoh73TTd+vQEpCBQvqfs4uNLzSfM6iSK7FQp8w6NN+XZxImgUtLqX+3
         kV5yWJqL+xElsbzaHv0V8zuesePj/mO8YRCPKK9AEuCTZg0s4Ot39XRRkJOPMv0u62
         rbyFjU2K1VKkwSf2ghtKqY2+OhH4yOnczabNmIEAuu7hOq2zhS8AfKFk6Sb+oT0uTj
         uPifzVx22XjKbXFTCYoyAFb8Eea7iyqlbnBFRTJluiNvFhwkVvxXrF4w39DzB2tTZC
         cOZsCSR0bLJLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 08/12] ceph: remove bogus checks and WARN_ONs from ceph_set_page_dirty
Date:   Sat, 10 Jul 2021 19:52:58 -0400
Message-Id: <20210710235302.3222809-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235302.3222809-1-sashal@kernel.org>
References: <20210710235302.3222809-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 22d41cdcd3cfd467a4af074165357fcbea1c37f5 ]

The checks for page->mapping are odd, as set_page_dirty is an
address_space operation, and I don't see where it would be called on a
non-pagecache page.

The warning about the page lock also seems bogus.  The comment over
set_page_dirty() says that it can be called without the page lock in
some rare cases. I don't think we want to warn if that's the case.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index fbf383048409..26de74684c17 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -72,10 +72,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct inode *inode;
 	struct ceph_inode_info *ci;
 	struct ceph_snap_context *snapc;
-	int ret;
-
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
@@ -121,11 +117,7 @@ static int ceph_set_page_dirty(struct page *page)
 	page->private = (unsigned long)snapc;
 	SetPagePrivate(page);
 
-	ret = __set_page_dirty_nobuffers(page);
-	WARN_ON(!PageLocked(page));
-	WARN_ON(!page->mapping);
-
-	return ret;
+	return __set_page_dirty_nobuffers(page);
 }
 
 /*
-- 
2.30.2

