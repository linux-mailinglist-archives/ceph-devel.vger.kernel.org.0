Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB52D3BECFB
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jul 2021 19:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhGGR0a (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jul 2021 13:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229949AbhGGR0a (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 13:26:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67BEA61C9A;
        Wed,  7 Jul 2021 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625678629;
        bh=kKASO9gEv9DBUtIrpnleVt/rO1uZBQ/CW94hA7BwEww=;
        h=From:To:Cc:Subject:Date:From;
        b=lFgDxlHzMHyIds6X6vTjZpRhUQJBhNG/pkL8DwfQ841yvZLQMsnrW8sbSa7QHjpUM
         0D2eRA0nA62GJnDw3sEfiGM4O7+orCZChUi36e4ONdYkrKZrCjfB1vK6Mb8xDh7HFw
         JAyBK7zX6ESmixmEqSC7jPqBLCmRwHUiVlm8De3M2jhAtFaMMwKIp07gB/AMX/ED8U
         WUyQB/LW1DGE1rhlkxNMzP5n5VowVFOqlaw0eLZwBlMeyzjbcKEp5mrPqUReT76adH
         uI8UOURAGrftqWDY5dsimFWPLSCoanZUH58b5MjIFzohiNl6XS6M/UNGsA08Fgql/m
         hTXcULtzZFbzQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Steve French <smfrench@gmail.com>
Subject: [PATCH] ceph: remove some defunct forward declarations
Date:   Wed,  7 Jul 2021 13:23:48 -0400
Message-Id: <20210707172348.38635-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We missed these in the recent fscache rework.

Reported-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/cache.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ceph/cache.h b/fs/ceph/cache.h
index 1409d6149281..058ea2a04376 100644
--- a/fs/ceph/cache.h
+++ b/fs/ceph/cache.h
@@ -26,12 +26,6 @@ void ceph_fscache_unregister_inode_cookie(struct ceph_inode_info* ci);
 void ceph_fscache_file_set_cookie(struct inode *inode, struct file *filp);
 void ceph_fscache_revalidate_cookie(struct ceph_inode_info *ci);
 
-int ceph_readpage_from_fscache(struct inode *inode, struct page *page);
-int ceph_readpages_from_fscache(struct inode *inode,
-				struct address_space *mapping,
-				struct list_head *pages,
-				unsigned *nr_pages);
-
 static inline void ceph_fscache_inode_init(struct ceph_inode_info *ci)
 {
 	ci->fscache = NULL;
-- 
2.31.1

