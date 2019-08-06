Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1382983853
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Aug 2019 20:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732026AbfHFSAW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 14:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfHFSAW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 14:00:22 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C688220B1F;
        Tue,  6 Aug 2019 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565114421;
        bh=OSee/fyrailuGPg1F2j2fX0PnEQzn7pakZTig5gC3EM=;
        h=From:To:Cc:Subject:Date:From;
        b=YuHxZtAen+dqIbWLRWdVkro5MC55RZoBjMSVQqtIbP/ZeoUQJLplVzDu1xhzTv4tg
         nVnhMFJZeNGTR+m4iXFKtuo1zTx18zz8/63wHpPQEtPJA+8YdiF5eWOu7TJiBSKSIJ
         vcXllCVwXmLBEkqu2JmtO/yYvmzIf+CTaB1G58LI=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 1/2] ceph: only set CEPH_I_SEC_INITED if we got a MAC label
Date:   Tue,  6 Aug 2019 14:00:18 -0400
Message-Id: <20190806180019.6213-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

__ceph_getxattr will set the CEPH_I_SEC_INITED flag whenever it gets
any xattr that starts with "security.". We only want to set that flag
when fetching the MAC label for the currently-active LSM, however.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 5c608caf0190..410eaf1ba211 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -892,7 +892,8 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	memcpy(value, xattr->val, xattr->val_len);
 
 	if (current->journal_info &&
-	    !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN))
+	    !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
+	    security_ismaclabel(name + XATTR_SECURITY_PREFIX_LEN))
 		ci->i_ceph_flags |= CEPH_I_SEC_INITED;
 out:
 	spin_unlock(&ci->i_ceph_lock);
-- 
2.21.0

