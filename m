Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2482CEB88E
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Oct 2019 21:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbfJaUrj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Oct 2019 16:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfJaUrj (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 16:47:39 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D192086D;
        Thu, 31 Oct 2019 20:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572554859;
        bh=jRn9WiP1eKTYv9UoYEtDMvs0cbElsns6t2N8n/fIp5U=;
        h=From:To:Cc:Subject:Date:From;
        b=xbAhdaeF4Kc+YGs5lwMnfFKps4uQDf11av5LQnrtUbvmZUJaOXSumdXMtqyilom4v
         5O54wJlPhEMLg4cj8qccxuiU1Wj+/GOD0FpFSlRR9Hu8f7lT2HzfeJMngN5VzwsuGg
         V73mJdeFl2z5xtBFKLrkkOmX+6h/2QsjCvGrVPO8=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk
Subject: [PATCH v2] ceph: don't try to handle hashed dentries in non-O_CREAT atomic_open
Date:   Thu, 31 Oct 2019 16:47:37 -0400
Message-Id: <20191031204737.20310-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If ceph_atomic_open is handed a !d_in_lookup dentry, then that means
that it already passed d_revalidate so we *know* that it's negative (or
at least was very recently). Just return -ENOENT in that case.

This also addresses a subtle bug in dentry handling. Non-O_CREAT opens
call atomic_open with the parent's i_rwsem shared, but calling
d_splice_alias on a hashed dentry requires the exclusive lock.

If ceph_atomic_open receives a hashed, negative dentry on a non-O_CREAT
open, and another client were to race in and create the file before we
issue our OPEN, ceph_fill_trace could end up calling d_splice_alias on
the dentry with the new inode with insufficient locks.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e9689e7bea08..bd77adb64bfd 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -462,6 +462,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+	} else if (!d_in_lookup(dentry)) {
+		/* If it's not being looked up, it's negative */
+		return -ENOENT;
 	}
 
 	/* do the open */
-- 
2.21.0

