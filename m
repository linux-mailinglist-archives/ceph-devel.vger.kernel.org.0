Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D96221F701
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfEOO4r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 10:56:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:52322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbfEOO4q (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 15 May 2019 10:56:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BAAF0AFC7;
        Wed, 15 May 2019 14:56:45 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, David Disseldorp <ddiss@suse.de>
Subject: [PATCH] ceph: fix "ceph.dir.rctime" vxattr value
Date:   Wed, 15 May 2019 16:56:39 +0200
Message-Id: <20190515145639.5206-1-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The vxattr value incorrectly places a "09" prefix to the nanoseconds
field, instead of providing it as a zero-pad width specifier after '%'.

Link: https://tracker.ceph.com/issues/39943
Fixes: 3489b42a72a4 ("ceph: fix three bugs, two in ceph_vxattrcb_file_layout()")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---

@Yan, Zheng: given that the padding has been broken for so long, another
             option might be to drop the "09" completely and keep it
             variable width.

 fs/ceph/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 0cc42c8879e9..aeb8550fb863 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -224,7 +224,7 @@ static size_t ceph_vxattrcb_dir_rbytes(struct ceph_inode_info *ci, char *val,
 static size_t ceph_vxattrcb_dir_rctime(struct ceph_inode_info *ci, char *val,
 				       size_t size)
 {
-	return snprintf(val, size, "%lld.09%ld", ci->i_rctime.tv_sec,
+	return snprintf(val, size, "%lld.%09ld", ci->i_rctime.tv_sec,
 			ci->i_rctime.tv_nsec);
 }
 
-- 
2.16.4

