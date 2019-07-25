Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E969C74C6F
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391541AbfGYLGK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:06:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389082AbfGYLGK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:06:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 231CF22BE8
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564052769;
        bh=upwtm3gLb5t2035HAVVsZXQXdVjMwUrlQqbAAtcl2Pw=;
        h=From:To:Subject:Date:From;
        b=ZVs9H03du4NwbsLOXCz6ZlrNXr+eiJz266pJVTnCc9tofEPcU/mLtdEvAPzD3i7CO
         5QHL70pJQD8F/bfvEmOIVuA/GsW9c7B7lzNOthIegj/k9lko5C1DGjZEgKoy6HFHg6
         RGxTEkqxzC0Lq3/pd3/c8NhDnJ/kUm3DOmEvEkFw=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: don't SetPageError on writepage errors
Date:   Thu, 25 Jul 2019 07:06:07 -0400
Message-Id: <20190725110607.9445-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We already mark the mapping in that case, and doing this can cause
false positives to occur at fsync time, as well as spurious read
errors.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3793116fcb33..9051e2063d36 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -573,7 +573,7 @@ static u64 get_writepages_data_length(struct inode *inode,
 /*
  * Write a single page, but leave the page locked.
  *
- * If we get a write error, set the page error bit, but still adjust the
+ * If we get a write error, mark the mapping for error, but still adjust the
  * dirty page accounting (i.e., page is no longer dirty).
  */
 static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
@@ -648,7 +648,6 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 			fsc->blacklisted = 1;
 		dout("writepage setting page/mapping error %d %p\n",
 		     err, page);
-		SetPageError(page);
 		mapping_set_error(&inode->i_data, err);
 		wbc->pages_skipped++;
 	} else {
-- 
2.21.0

