Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678D623125B
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jul 2020 21:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbgG1TSk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jul 2020 15:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728751AbgG1TSk (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 15:18:40 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AEBE207F5
        for <ceph-devel@vger.kernel.org>; Tue, 28 Jul 2020 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595963919;
        bh=jTAxIWI7G3qcN7LvslC25U0Kvze3WNjrX7T2ftjfo7Q=;
        h=From:To:Subject:Date:From;
        b=Y8KRCvH/M2EZK86mX2G/abrMhzZvahwaFb64KWCQcP52o1W6RvOuE1aI++3F71LOq
         /OlfeAhrc/VKFzdY0Q92a/JFqS/GYcXE17ucdezhyc2d8CWFR54hz+N5kGOiEuMuOh
         30ql+eT+EPc5fps4we3fCGWO8TRnYNr3Y5K+saS4=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: set sec_context xattr on symlink creation
Date:   Tue, 28 Jul 2020 15:18:38 -0400
Message-Id: <20200728191838.315530-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Symlink inodes should have the security context set in their xattrs on
creation. We already set the context on creation, but we don't attach
the pagelist. Make it do so.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 39f5311404b0..060bdcc5ce32 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -930,6 +930,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 	req->r_num_caps = 2;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
+	if (as_ctx.pagelist) {
+		req->r_pagelist = as_ctx.pagelist;
+		as_ctx.pagelist = NULL;
+	}
 	err = ceph_mdsc_do_request(mdsc, dir, req);
 	if (!err && !req->r_reply_info.head->is_dentry)
 		err = ceph_handle_notrace_create(dir, dentry);
-- 
2.26.2

