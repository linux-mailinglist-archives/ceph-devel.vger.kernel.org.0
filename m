Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381C232E57B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Mar 2021 11:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEJ7k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Mar 2021 04:59:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhCEJ70 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 04:59:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 517A964F45;
        Fri,  5 Mar 2021 09:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614938365;
        bh=emDI/1RQXBejLu9OYnG7vDtnknUDsp2UkW/18vItiiY=;
        h=Date:From:To:Cc:Subject:From;
        b=C11v9M4MBztdBId0GpOi6/W/Snrypozm8LJGzrr1SJD4XpcPY1wRF2gn2scKxWMcV
         i0gc7kMeWf58NEJEAEv4ygDlbbuxMYsMsGiw6i2CiDPLST05M3T8MGusKlKDlonSV5
         +JzuIhlydUWv8N6aFji+Ec+DUgMRn02AevlqTwR78r6RRR/kqT2ZPVpQozRTV5tjuM
         MLq6eqtgX6ISnKQWc3UjgonJltNlkihxp5hlTC6qilooJO4BfuNrUS2VsgPrZlQpfG
         HiEDVWtX7ttLlj+qAl8WMfKLMlXuZsQxYQnaxggdsRJhwNDJFGlyi1D9TjDFQj3Khp
         zLkwD8PLWDHhA==
Date:   Fri, 5 Mar 2021 03:59:23 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] ceph: Fix fall-through warnings for Clang
Message-ID: <20210305095923.GA142236@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
of warnings by explicitly adding a break and a goto statements instead
of just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/ceph/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 83d9358854fb..3e575656713e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -631,10 +631,12 @@ static loff_t ceph_dir_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_CUR:
 		offset += file->f_pos;
+		break;
 	case SEEK_SET:
 		break;
 	case SEEK_END:
 		retval = -EOPNOTSUPP;
+		goto out;
 	default:
 		goto out;
 	}
-- 
2.27.0

