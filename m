Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813F73FB5C7
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 14:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236600AbhH3MLl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 08:11:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237494AbhH3MLk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 08:11:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9288960FC3;
        Mon, 30 Aug 2021 12:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630325447;
        bh=PFpK9vtn8/8fsI0B1rv4xB0GtoTAwrD7rNRGzWchUKM=;
        h=From:To:Cc:Subject:Date:From;
        b=EW6CiCBA1+4G2Xpf1Zfpl3ofuxgU5pKbGTJEmNqBeDiHEhl8H7G/oVUw7P9OiG/Mn
         0aWyDNWebWNy07GVHwiW9KWAN7hn6fIz5mbHWoc3j/RA33A4A7q5GTvgWhSjAA2P0W
         AWfmpaTw8ap0NieLWEHdwyuuHathjA2FYBnqLE8RJO0QnRs5T4JHqAIwOj8JU8Mjsc
         LaurMxnGS1SCvgY/mAi93ZVcyemFRw94CP31/U/Y4TKC3wuy8uTWmuhxJDwDllL3Mm
         giuMfJU/w+CRqfNPmAwhA3ZQebDvSp1gfIO5n7G8TnCbhjnlTA8wdUwDhNdG4OoImV
         pmKpyn4qsGYyw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, idryomov@gmail.com, xiubli@redhat.com
Subject: [PATCH] ceph: ensure we return an error when parsing corrupt mdsmap
Date:   Mon, 30 Aug 2021 08:10:45 -0400
Message-Id: <20210830121045.13994-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Commit ba5e57de7b20 (ceph: reconnect to the export targets on new
mdsmaps) changed ceph_mdsmap_decode to "goto corrupt" when given a
bogus mds rank in the export targets. It did not set the err variable
however, which caused that function to return a NULL pointer instead of
a proper ERR_PTR value for the error.

Fix this by setting err before doing the "goto corrupt".

URL: https://tracker.ceph.com/issues/52436
Fixes: ba5e57de7b20 ("ceph: reconnect to the export targets on new mdsmaps")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mdsmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

I'll plan to fold this change into the original patch since it hasn't
been merged yet. Let me know if you have objections.

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index d995cb02d30c..61d67cbcb367 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -263,8 +263,10 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 				goto nomem;
 			for (j = 0; j < num_export_targets; j++) {
 				target = ceph_decode_32(&pexport_targets);
-				if (target >= m->possible_max_rank)
+				if (target >= m->possible_max_rank) {
+					err = -EIO;
 					goto corrupt;
+				}
 				info->export_targets[j] = target;
 			}
 		} else {
-- 
2.31.1

