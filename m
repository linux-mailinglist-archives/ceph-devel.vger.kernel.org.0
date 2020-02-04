Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290B4152009
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Feb 2020 18:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBDRw6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Feb 2020 12:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgBDRw6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 12:52:58 -0500
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D3A2084E;
        Tue,  4 Feb 2020 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580838777;
        bh=i6I9apX4Gx93srSmpD0ey0m7U+NiBF4f6HaysbGlBtE=;
        h=From:To:Cc:Subject:Date:From;
        b=udFJSub+Avubmfbn6cN91lVI8Lx2nC85gal1i/JxnJqOgCchzCBAPghoWcFJTIDkv
         K30JU/zZNmTTiZa9wnxqTSOGWq2qsj9FJwSCkdsZCcviMidiHp9s/nr8CruGfrFr3y
         RMHWFqNi6sa2IaqeiUSmBf/8uxLbY2oI1II4v5lc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     dhowells@redhat.com
Subject: [PATCH] ceph: don't ClearPageChecked in ceph_invalidatepage
Date:   Tue,  4 Feb 2020 12:52:56 -0500
Message-Id: <20200204175256.362163-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CephFS doesn't set this bit to begin with, so there should be no need
to clear it.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 7ab616601141..6067847bc03b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -159,8 +159,6 @@ static void ceph_invalidatepage(struct page *page, unsigned int offset,
 	if (!PagePrivate(page))
 		return;
 
-	ClearPageChecked(page);
-
 	dout("%p invalidatepage %p idx %lu full dirty page\n",
 	     inode, page, page->index);
 
-- 
2.24.1

