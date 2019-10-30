Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC31EA1F3
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Oct 2019 17:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfJ3Qni (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Oct 2019 12:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbfJ3Qni (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 12:43:38 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA74A208E3;
        Wed, 30 Oct 2019 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572453817;
        bh=9+IwFa77m0OMZ6NuFQVKSjCR88D5biN6+0LXIS8/nUk=;
        h=From:To:Cc:Subject:Date:From;
        b=LqvyQTxCMMr98mVJp8iBq40rAsI4IAMfukvPM0cwkomdrWmAXiXIzG9PydokRlv9B
         zFyL12nmd4PCdZiEXZQwb5jzxNmGllgFGsZOvBWwQh6ebvy/FWDKGkAajETyjTyJrI
         A0GmFXNh8xJthFaSKCJSpPRqkFrcCYJanUlxYmzc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk
Subject: [PATCH] ceph: don't try to handle hashed dentries in non-O_CREAT atomic_open
Date:   Wed, 30 Oct 2019 12:43:36 -0400
Message-Id: <20191030164336.11163-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If ceph_atomic_open is handed a !d_in_lookup dentry, then that means
that it already passed d_revalidate so we *know* what the state of the
thing was just recently. Just bail out at that point and let the caller
handle that case.

This also addresses a subtle bug in dentry handling. Non-O_CREAT opens
call atomic_open with the parent's i_rwsem shared, but calling
d_splice_alias on a hashed dentry requires the exclusive lock.

ceph_atomic_open could receive a hashed, negative dentry on a
non-O_CREAT open. If another client were to race in and create the file
before we issue our OPEN, ceph_fill_trace could end up calling
d_splice_alias on the dentry with the new inode.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d277f71abe0b..691b7b1a6075 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -462,6 +462,8 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+	} else if (!d_in_lookup(dentry)) {
+		return finish_no_open(file, dentry);
 	}
 
 	/* do the open */
-- 
2.21.0

