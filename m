Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAD4C08E6
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Sep 2019 17:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbfI0Psb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Sep 2019 11:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0Psb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 27 Sep 2019 11:48:31 -0400
Received: from tleilax.poochiereds.net.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40B8205F4;
        Fri, 27 Sep 2019 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569599310;
        bh=u5266vdHriBnW1I4v4FlTkLugyi+gbGXvPAHhQ4/i+w=;
        h=From:To:Cc:Subject:Date:From;
        b=F2cXMN0QVTiEIM/PUmrYkAAn8S9dPZC88PuQAVVLGn2ONrqCxjbhBopDppIryNEZi
         sZfLIJCS64EYTB8wbEfwtDfJwyhTeOSX3tovQjKvJLyDruUgBKw9h+Po8pqY9UduuF
         ZLOKuaDmp+xZdCuqBlQwF1jnRlSfJCXUY4Yw7dEg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com
Subject: [PATCH] ceph: just skip unrecognized info in ceph_reply_info_extra
Date:   Fri, 27 Sep 2019 11:48:28 -0400
Message-Id: <20190927154828.13708-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In the future, we're going to want to extend the ceph_reply_info_extra
for create replies. Currently though, the kernel code doesn't accept an
extra blob that is larger than the expected data.

Change the code to skip over any unrecognized fields at the end of the
extra blob, rather than returning -EIO.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index da882217d04d..54a4e480c16b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -384,8 +384,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 	}
 
 done:
-	if (*p != end)
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p = end;
 	return 0;
 
 bad:
@@ -406,12 +406,10 @@ static int parse_reply_info_filelock(void **p, void *end,
 		goto bad;
 
 	info->filelock_reply = *p;
-	*p += sizeof(*info->filelock_reply);
 
-	if (unlikely(*p != end))
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p = end;
 	return 0;
-
 bad:
 	return -EIO;
 }
@@ -425,18 +423,21 @@ static int parse_reply_info_create(void **p, void *end,
 {
 	if (features == (u64)-1 ||
 	    (features & CEPH_FEATURE_REPLY_CREATE_INODE)) {
+		/* Malformed reply? */
 		if (*p == end) {
 			info->has_create_ino = false;
 		} else {
 			info->has_create_ino = true;
-			info->ino = ceph_decode_64(p);
+			ceph_decode_64_safe(p, end, info->ino, bad);
 		}
+	} else {
+		if (*p != end)
+			goto bad;
 	}
 
-	if (unlikely(*p != end))
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p = end;
 	return 0;
-
 bad:
 	return -EIO;
 }
-- 
2.21.0

