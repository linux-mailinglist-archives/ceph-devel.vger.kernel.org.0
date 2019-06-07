Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B71E638F43
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Jun 2019 17:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730023AbfFGPid (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 7 Jun 2019 11:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730014AbfFGPia (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 7 Jun 2019 11:38:30 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4125A2146F;
        Fri,  7 Jun 2019 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559921909;
        bh=bJqBKrU1xU4JBewZYge6NyaZkN7WJPp+cyyIAKfk++8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iHmmH8duJ5yJwT36TfvK5PqE0yv3kLTbdnDpO5gGwfY9+2L9rJuiYEZzX3iPRTPwp
         DZJ58MyYQv96dzuFX+vJGijuKH6x/2N8cLC8x9Z4mL1jPFGwQ3/Zkcj/wapLjIeYx0
         HkFh7+83amk33JhMAsKMh6BCwjHppglC342+Y+3w=
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@redhat.com, zyan@redhat.com, sage@redhat.com
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: [PATCH 13/16] iversion: add a routine to update a raw value with a larger one
Date:   Fri,  7 Jun 2019 11:38:13 -0400
Message-Id: <20190607153816.12918-14-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153816.12918-1-jlayton@kernel.org>
References: <20190607153816.12918-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Machines can be independently updating iversion themselves, while
working under comprehensive sets of caps on an inode. Add a new
function that will update a raw value with a larger one.

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

