Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0E55C1D5
	for <lists+ceph-devel@lfdr.de>; Mon,  1 Jul 2019 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfGARQl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 1 Jul 2019 13:16:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:45608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727094AbfGARQl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 13:16:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAD8BAEC3;
        Mon,  1 Jul 2019 17:16:39 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc:     zhengbin <zhengbin13@huawei.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Henriques <lhenriques@suse.com>
Subject: [PATCH] ceph: fix end offset in truncate_inode_pages_range call
Date:   Mon,  1 Jul 2019 18:16:34 +0100
Message-Id: <20190701171634.20290-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Commit e450f4d1a5d6 ("ceph: pass inclusive lend parameter to
filemap_write_and_wait_range()") fixed the end offset parameter used to
call filemap_write_and_wait_range and invalidate_inode_pages2_range.
Unfortunately it missed truncate_inode_pages_range, introducing a
regression that is easily detected by xfstest generic/130.

The problem is that when doing direct IO it is possible that an extra page
is truncated from the page cache when the end offset is page aligned.
This can cause data loss if that page hasn't been sync'ed to the OSDs.

While there, change code to use PAGE_ALIGN macro instead.

Fixes: e450f4d1a5d6 ("ceph: pass inclusive lend parameter to filemap_write_and_wait_range()")
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 183c37c0a8fc..7a57db8e2fa9 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1007,7 +1007,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			 * may block.
 			 */
 			truncate_inode_pages_range(inode->i_mapping, pos,
-					(pos+len) | (PAGE_SIZE - 1));
+						   PAGE_ALIGN(pos + len) - 1);
 
 			req->r_mtime = mtime;
 		}
