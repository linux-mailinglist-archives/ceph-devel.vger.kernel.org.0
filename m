Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380F748779
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 17:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfFQPiJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 11:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbfFQPiH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 11:38:07 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C32121874;
        Mon, 17 Jun 2019 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560785887;
        bh=nCI+trzxrFKwTns0PpodIDfNcWni7xvuSwh6FPR5BOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8noh3bzQ4bAnr7wnMVY/VzSX1jdOVGYAV6XSPtst6F8VMFO/rgTxSLSoysf+NzPH
         kGzktiSoUUsu8nhO28Okh7ezhHt/XeYSZLJxocWWXu1xUHiW4CN1NkctnNjdeS5Y1f
         qdeA0P6DvLLL7jFkQ6v71zy+hSvLT9AoCTI/MYS0=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Subject: [PATCH v2 15/18] iversion: add a routine to update a raw value with a larger one
Date:   Mon, 17 Jun 2019 11:37:50 -0400
Message-Id: <20190617153753.3611-16-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617153753.3611-1-jlayton@kernel.org>
References: <20190617153753.3611-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Under ceph, clients can be independently updating iversion themselves,
while working under comprehensive sets of caps on an inode. In that
situation we always want to prefer the largest value of a change
attribute. Add a new function that will update a raw value with a larger
one, but otherwise leave it alone.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/iversion.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/iversion.h b/include/linux/iversion.h
index be50ef7cedab..2917ef990d43 100644
--- a/include/linux/iversion.h
+++ b/include/linux/iversion.h
@@ -112,6 +112,30 @@ inode_peek_iversion_raw(const struct inode *inode)
 	return atomic64_read(&inode->i_version);
 }
 
+/**
+ * inode_set_max_iversion_raw - update i_version new value is larger
+ * @inode: inode to set
+ * @val: new i_version to set
+ *
+ * Some self-managed filesystems (e.g Ceph) will only update the i_version
+ * value if the new value is larger than the one we already have.
+ */
+static inline void
+inode_set_max_iversion_raw(struct inode *inode, u64 val)
+{
+	u64 cur, old;
+
+	cur = inode_peek_iversion_raw(inode);
+	for (;;) {
+		if (cur > val)
+			break;
+		old = atomic64_cmpxchg(&inode->i_version, cur, val);
+		if (likely(old == cur))
+			break;
+		cur = old;
+	}
+}
+
 /**
  * inode_set_iversion - set i_version to a particular value
  * @inode: inode to set
-- 
2.21.0

