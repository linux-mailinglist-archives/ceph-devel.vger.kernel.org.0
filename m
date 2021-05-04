Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297C6372C8F
	for <lists+ceph-devel@lfdr.de>; Tue,  4 May 2021 16:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhEDOyJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 May 2021 10:54:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:43678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbhEDOyI (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 May 2021 10:54:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AB316100A;
        Tue,  4 May 2021 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620139993;
        bh=AZJD4LNNoYuGNkLNV9vEqjPbW3kp5eiiXFTr6p2N2tE=;
        h=From:To:Cc:Subject:Date:From;
        b=txsw0KVy1G72tKOi68sIMoHNJVoMn5lpEKitLEsn6JCAHfEDq06WwSU7FA0/eI2aI
         6ldOXlqiEjQy491T/dyh3lZNIDuZ7XZ0R77KPhq4UaFjlDeR4yiBgOnfBOgO/+EPe2
         jIODO5lRY402UZc+x3n4xAwDowYBCVh42XSYC/Dygl5eUBtLgiPOAP+i4tePXlC3ov
         GBIZW0fZW+CK1SqbbxXocPeT/prsC/fkx1dFnoLhR9sxB6gPQZOJjXMLYVL1uyL9Vw
         FD4oFy6qhGrNQ6m8reeNpGXPLyA/YjaaQlTJ92EGc1XYHD+mmalKN/QY3WVHvAhYjZ
         9eT21lUrpQyDg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] ceph: remove bogus check for NULL mapping in ceph_set_page_dirty
Date:   Tue,  4 May 2021 10:53:11 -0400
Message-Id: <20210504145311.89432-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This check is odd, as set_page_dirty is an address_space operation, and
I don't see where it would be called on a non-pagecache page.

Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index b47303b3772a..01316cb1314c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -84,9 +84,6 @@ static int ceph_set_page_dirty(struct page *page)
 	struct ceph_snap_context *snapc;
 	int ret;
 
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
-
 	if (PageDirty(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
 		     mapping->host, page, page->index);
-- 
2.31.1

