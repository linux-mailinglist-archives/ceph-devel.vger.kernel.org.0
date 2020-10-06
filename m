Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333F2284D5F
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Oct 2020 16:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgJFONK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Oct 2020 10:13:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbgJFONK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 10:13:10 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F36420760;
        Tue,  6 Oct 2020 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601993589;
        bh=AzW2h7m1+8+R+eXyNgkeytCbOkzLE5LkNMgglOpNI3I=;
        h=From:To:Cc:Subject:Date:From;
        b=gJcDtzfnfI01Q1pVvad0TQSAhJ6++Plnztr+aRvh+wXNUW90q/DkRL5nTh1TEbpjg
         EGwXmvZYJCINAHirfX+ZHUjlsqV0FWPWIw28bYeGnvwq5jkvYQY2dcyMQn7wI9M+dR
         AWhtbCjc2M516MHkIIKsAnx65R7C7PmAQHWVLP5Q=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     willy@infradead.org, idryomov@gmail.com, ukernel@gmail.com
Subject: [PATCH] ceph: don't SetPageError on readpage errors
Date:   Tue,  6 Oct 2020 10:13:07 -0400
Message-Id: <20201006141307.309650-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

PageError really only has meaning within a particular subsystem. Nothing
looks at this bit in the core kernel code, and ceph itself doesn't care
about it. Don't bother setting the PageError bit on error.

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 97827f68a3e7..137c0a5a2a0d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -241,7 +241,6 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	if (err == -ENOENT)
 		err = 0;
 	if (err < 0) {
-		SetPageError(page);
 		ceph_fscache_readpage_cancel(inode, page);
 		if (err == -EBLOCKLISTED)
 			fsc->blocklisted = true;
-- 
2.26.2

