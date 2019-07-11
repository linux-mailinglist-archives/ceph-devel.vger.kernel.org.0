Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C091D65F94
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2019 20:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfGKSlo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 14:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730246AbfGKSlo (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 14:41:44 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE54A2166E;
        Thu, 11 Jul 2019 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562870503;
        bh=E0XgnaRjFv6HDkww4jzqZoNYTr7VDJpb2nWWDEcSvvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nz19vKWQ4RQjEeKWBa2GPrTfA3bhAdHFfdcNOCJv0Xun6FTwfND0BPgl/bT78X+IT
         aruD4J2tXKjiidWTjr1doCctgKqbXmaHV0/ONV/ffmSw3Kh00rO2d+tUv1PqPlc2JT
         QKIUpQXaMc7ife6BfjddYM2UnXlb7Zs6nY6BQkRM=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, idryomov@gmail.com, sage@redhat.com,
        lhenriques@suse.com
Subject: [PATCH v2 4/5] ceph: lock page before checking Uptodate flag
Date:   Thu, 11 Jul 2019 14:41:35 -0400
Message-Id: <20190711184136.19779-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711184136.19779-1-jlayton@kernel.org>
References: <20190711184136.19779-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We could end up racing with a call to set or clear the Uptodate flag
prior to taking the page lock. Use find_lock_page instead to have
it return a locked page and unlock it before releasing it if it's not
Uptodate.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 4606da82da6f..83b1f6dccab8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1715,12 +1715,12 @@ int ceph_uninline_data(struct inode *inode, struct page *provided_page)
 		WARN_ON(!PageUptodate(page));
 	} else if (ceph_caps_issued(ci) &
 		   (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) {
-		page = find_get_page(inode->i_mapping, 0);
+		page = find_lock_page(inode->i_mapping, 0);
 		if (page) {
 			if (PageUptodate(page)) {
 				from_pagecache = true;
-				lock_page(page);
 			} else {
+				unlock_page(page);
 				put_page(page);
 				page = NULL;
 			}
-- 
2.21.0

