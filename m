Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3272D35D92
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Jun 2019 15:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfFENLL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 09:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfFENLJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 09:11:09 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00BBE208C0;
        Wed,  5 Jun 2019 13:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559740269;
        bh=a4raB1j9zeZMXJgACb2Qxi7E0ANgGX6SjRdOV19rXTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFto/I5pTtQj5F6yx/DvnqYGpnznvr+hGmGubqIAkW3A/OTiwXvh2Quf7h2hqYAs4
         F34q5lQMEoIWmldV3rza2B7Rp5g9i0QZmgnmlRkPhrlBieAEs+AGXHnwIs/Yv88b4T
         GoqaVyH6H1n0oxt0aJs1pZb6A+4WWYpPHx+/GVgI=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Subject: [RFC PATCH 7/9] ceph: have MDS map decoding use entity_addr_t decoder
Date:   Wed,  5 Jun 2019 09:11:00 -0400
Message-Id: <20190605131102.13529-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605131102.13529-1-jlayton@kernel.org>
References: <20190605131102.13529-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mdsmap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 45a815c7975e..98814c3d18c9 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -107,7 +107,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 	struct ceph_mdsmap *m;
 	const void *start = *p;
 	int i, j, n;
-	int err = -EINVAL;
+	int err;
 	u8 mdsmap_v, mdsmap_cv;
 	u16 mdsmap_ev;
 
@@ -183,8 +183,9 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 		inc = ceph_decode_32(p);
 		state = ceph_decode_32(p);
 		state_seq = ceph_decode_64(p);
-		ceph_decode_copy(p, &addr, sizeof(addr));
-		ceph_decode_addr(&addr);
+		err = ceph_decode_entity_addr(p, end, &addr);
+		if (err)
+			goto corrupt;
 		ceph_decode_copy(p, &laggy_since, sizeof(laggy_since));
 		*p += sizeof(u32);
 		ceph_decode_32_safe(p, end, namelen, bad);
@@ -357,7 +358,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 nomem:
 	err = -ENOMEM;
 	goto out_err;
-bad:
+corrupt:
 	pr_err("corrupt mdsmap\n");
 	print_hex_dump(KERN_DEBUG, "mdsmap: ",
 		       DUMP_PREFIX_OFFSET, 16, 1,
@@ -365,6 +366,9 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 out_err:
 	ceph_mdsmap_destroy(m);
 	return ERR_PTR(err);
+bad:
+	err = -EINVAL;
+	goto corrupt;
 }
 
 void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
-- 
2.21.0

