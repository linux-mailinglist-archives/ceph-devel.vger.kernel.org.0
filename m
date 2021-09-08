Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07FDD403A3E
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Sep 2021 15:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbhIHNE6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Sep 2021 09:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234530AbhIHNEt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 8 Sep 2021 09:04:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0673C6115B;
        Wed,  8 Sep 2021 13:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631106219;
        bh=d96ZmnTw2j0tNdd9LwhacrzX2FZsWIOGyAgxiNkjwI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h9yOyrKQkbYNqQY6klZo50NM9NWq9vU4vUtfPBTw4NsmRHHdk5C1HlcutnF6FI3SN
         ew57nm5m9I07ZktkhzqUjFl237Wr574wj//Eyw7UUaQwzuIV5IgD9bcFqp0Om3X514
         hECxHs6P0mKdNz4d3K7Wow0c796VHL7N+0dujBW3vTGsKsKBYAPGAdxhq8uiyoslMb
         ur1wOIoXeJMtXXbaEmxXphu6fLj0925pKd1ZTO4XeCGFQIebHoOhwxFCjy1IJvTS4T
         T6rsP9ns6Eq7GszG+sxEUpjxLIisi7n0dZMzjysRoPtCfrWGa9ffaiwMqidF62jhb+
         l8LCRqd14GzXA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com
Subject: [PATCH 2/6] ceph: don't use -ESTALE as special return code in try_get_cap_refs
Date:   Wed,  8 Sep 2021 09:03:32 -0400
Message-Id: <20210908130336.56668-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210908130336.56668-1-jlayton@kernel.org>
References: <20210908130336.56668-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In some cases, we may want to return -ESTALE if it ends up that we're
dealing with an inode that no longer exists. Switch to using -EUCLEAN as
the "special" error return.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b89c23a0b440..f8307d70674b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2636,9 +2636,9 @@ void ceph_take_cap_refs(struct ceph_inode_info *ci, int got,
  *
  * Returns 0 if caps were not able to be acquired (yet), 1 if succeed,
  * or a negative error code. There are 3 speical error codes:
- *  -EAGAIN: need to sleep but non-blocking is specified
- *  -EFBIG:  ask caller to call check_max_size() and try again.
- *  -ESTALE: ask caller to call ceph_renew_caps() and try again.
+ *  -EAGAIN:  need to sleep but non-blocking is specified
+ *  -EFBIG:   ask caller to call check_max_size() and try again.
+ *  -EUCLEAN: ask caller to call ceph_renew_caps() and try again.
  */
 enum {
 	/* first 8 bits are reserved for CEPH_FILE_MODE_FOO */
@@ -2686,7 +2686,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 			dout("get_cap_refs %p endoff %llu > maxsize %llu\n",
 			     inode, endoff, ci->i_max_size);
 			if (endoff > ci->i_requested_max_size)
-				ret = ci->i_auth_cap ? -EFBIG : -ESTALE;
+				ret = ci->i_auth_cap ? -EFBIG : -EUCLEAN;
 			goto out_unlock;
 		}
 		/*
@@ -2766,7 +2766,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 			dout("get_cap_refs %p need %s > mds_wanted %s\n",
 			     inode, ceph_cap_string(need),
 			     ceph_cap_string(mds_wanted));
-			ret = -ESTALE;
+			ret = -EUCLEAN;
 			goto out_unlock;
 		}
 
@@ -2850,7 +2850,7 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
 
 	ret = try_get_cap_refs(inode, need, want, 0, flags, got);
 	/* three special error codes */
-	if (ret == -EAGAIN || ret == -EFBIG || ret == -ESTALE)
+	if (ret == -EAGAIN || ret == -EFBIG || ret == -EUCLEAN)
 		ret = 0;
 	return ret;
 }
@@ -2933,7 +2933,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 		}
 
 		if (ret < 0) {
-			if (ret == -EFBIG || ret == -ESTALE) {
+			if (ret == -EFBIG || ret == -EUCLEAN) {
 				int ret2 = ceph_wait_on_async_create(inode);
 				if (ret2 < 0)
 					return ret2;
@@ -2942,7 +2942,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 				check_max_size(inode, endoff);
 				continue;
 			}
-			if (ret == -ESTALE) {
+			if (ret == -EUCLEAN) {
 				/* session was killed, try renew caps */
 				ret = ceph_renew_caps(inode, flags);
 				if (ret == 0)
-- 
2.31.1

