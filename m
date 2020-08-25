Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6725F2521B3
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Aug 2020 22:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHYUNa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Aug 2020 16:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgHYUN3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 16:13:29 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 039D720738;
        Tue, 25 Aug 2020 20:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598386408;
        bh=dDKr53+7ttUJeZVS9IPyfzZqUJRglBH1P8qpU+3WGKg=;
        h=From:To:Cc:Subject:Date:From;
        b=BnqtAFcGT9p72ooyNcTYbP7UWw3pEPUBu4qSjA/DNrkRwVadQcOvUOxFtOvpW8hBZ
         S02dpXGSZFKBNAsrYE0+gFWIeLoY7ul8DtXt4/oAJPLyZtFnrR0PxZA9aubK0sAbRk
         DMJhyMnHR2FTjJ+P5mpZSYPJBe4Jp0pu64XlQPD0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, jhubbard@nvidia.com,
        viro@zeniv.linux.org.uk
Subject: [PATCH] ceph: drop special-casing for ITER_PIPE in ceph_sync_read
Date:   Tue, 25 Aug 2020 16:13:26 -0400
Message-Id: <20200825201326.286242-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

This special casing was added in 7ce469a53e71 (ceph: fix splice
read for no Fc capability case). The confirm callback for ITER_PIPE
expects that the page is Uptodate or a pagecache page and and returns
an error otherwise.

A simpler workaround is just to use the Uptodate bit, which has no
meaning for anonymous pages. Rip out the special casing for ITER_PIPE
and just SetPageUptodate before we copy to the iter.

Cc: "Yan, Zheng" <ukernel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ceph/file.c | 71 +++++++++++++++++---------------------------------
 1 file changed, 24 insertions(+), 47 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index fb3ea715a19d..ed8fbfe3bddc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -863,6 +863,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 		size_t page_off;
 		u64 i_size;
 		bool more;
+		int idx;
+		size_t left;
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,
 					ci->i_vino, off, &len, 0, 1,
@@ -876,29 +878,13 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 
 		more = len < iov_iter_count(to);
 
-		if (unlikely(iov_iter_is_pipe(to))) {
-			ret = iov_iter_get_pages_alloc(to, &pages, len,
-						       &page_off);
-			if (ret <= 0) {
-				ceph_osdc_put_request(req);
-				ret = -ENOMEM;
-				break;
-			}
-			num_pages = DIV_ROUND_UP(ret + page_off, PAGE_SIZE);
-			if (ret < len) {
-				len = ret;
-				osd_req_op_extent_update(req, 0, len);
-				more = false;
-			}
-		} else {
-			num_pages = calc_pages_for(off, len);
-			page_off = off & ~PAGE_MASK;
-			pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
-			if (IS_ERR(pages)) {
-				ceph_osdc_put_request(req);
-				ret = PTR_ERR(pages);
-				break;
-			}
+		num_pages = calc_pages_for(off, len);
+		page_off = off & ~PAGE_MASK;
+		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
+		if (IS_ERR(pages)) {
+			ceph_osdc_put_request(req);
+			ret = PTR_ERR(pages);
+			break;
 		}
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, page_off,
@@ -929,32 +915,23 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			ret += zlen;
 		}
 
-		if (unlikely(iov_iter_is_pipe(to))) {
-			if (ret > 0) {
-				iov_iter_advance(to, ret);
-				off += ret;
-			} else {
-				iov_iter_advance(to, 0);
-			}
-			ceph_put_page_vector(pages, num_pages, false);
-		} else {
-			int idx = 0;
-			size_t left = ret > 0 ? ret : 0;
-			while (left > 0) {
-				size_t len, copied;
-				page_off = off & ~PAGE_MASK;
-				len = min_t(size_t, left, PAGE_SIZE - page_off);
-				copied = copy_page_to_iter(pages[idx++],
-							   page_off, len, to);
-				off += copied;
-				left -= copied;
-				if (copied < len) {
-					ret = -EFAULT;
-					break;
-				}
+		idx = 0;
+		left = ret > 0 ? ret : 0;
+		while (left > 0) {
+			size_t len, copied;
+			page_off = off & ~PAGE_MASK;
+			len = min_t(size_t, left, PAGE_SIZE - page_off);
+			SetPageUptodate(pages[idx]);
+			copied = copy_page_to_iter(pages[idx++],
+						   page_off, len, to);
+			off += copied;
+			left -= copied;
+			if (copied < len) {
+				ret = -EFAULT;
+				break;
 			}
-			ceph_release_page_vector(pages, num_pages);
 		}
+		ceph_release_page_vector(pages, num_pages);
 
 		if (ret < 0) {
 			if (ret == -EBLACKLISTED)
-- 
2.26.2

