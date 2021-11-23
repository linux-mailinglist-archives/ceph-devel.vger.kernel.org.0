Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E5845A2B3
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 13:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbhKWMht (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Nov 2021 07:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235366AbhKWMhs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 07:37:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7137460231;
        Tue, 23 Nov 2021 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670880;
        bh=DphOyrr0XLW8jJr/EpOJ5NXC0PpXMxxJP556lGbiYGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=KWrlxZ29z4aZoL0/O6XINLc8pfMVBP61aEVdZ5xRB8Jij36rBow5fU/gcWXexsMdJ
         tzezRF6fGvzHNQhhUxQIV08T+VY1VlMlh78i1zsKN4vk5t48tmS6DMLct5eWOic0Ru
         Nm6ep+Moc7wXO5G/Lo0JggdO9Yas1D6NyvpJs1hZ1NTGlrmJxKE9qHMMeh8h3BrEAk
         SW03akr8mPvmz4oeH0uJ92fjxbHDLZ60MCPzvFvLDw58iWI3DAXGeZTs8QnPOnS3Tq
         /2OrMhSccaSQWh+kKXonupj5T12fap5HxyawBqxJ4ZT7DVEpLnNTK1PSCYxmDFkYxm
         GNeaRIXomRHwg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: initialize i_size variable in ceph_sync_read
Date:   Tue, 23 Nov 2021 07:34:39 -0500
Message-Id: <20211123123439.70644-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Newer compilers seem to determine that this variable being uninitialized
isn't a problem, but older compilers (from the RHEL8 era) seem to choke
on it and complain that it could be used uninitialized.

Go ahead and initialize the variable at declaration time to silence
potential compiler warnings.

Fixes: c3d8e0b5de48 ("ceph: return the real size read when it hits EOF")
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 220a41831b46..69ea42392f51 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -847,7 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	ssize_t ret;
 	u64 off = iocb->ki_pos;
 	u64 len = iov_iter_count(to);
-	u64 i_size;
+	u64 i_size = i_size_read(inode);
 
 	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
-- 
2.33.1

