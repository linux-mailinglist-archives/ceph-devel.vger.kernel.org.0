Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918F850E9CB
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Apr 2022 21:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiDYT5o (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Apr 2022 15:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiDYT5o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Apr 2022 15:57:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C98612C6B9
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 12:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3449CB81A4F
        for <ceph-devel@vger.kernel.org>; Mon, 25 Apr 2022 19:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F76C385A4;
        Mon, 25 Apr 2022 19:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650916477;
        bh=OkWskaHKlGoroQDog+8XFaLg++edPiTJ5EWG5zbV8zM=;
        h=From:To:Cc:Subject:Date:From;
        b=Cr4ZEC+wehqqxoiqXuZH0nXlkMgKInjjtwrHeMxqBQa+vJRy2ZravG81id+r+xEs8
         l1Ah+m+wBSRYMmHxQjyaMUeuTwTZFRx4pydYS5k/58305ZMg+lQJ1hx6XHpTqTZ7SD
         i5YFBjWS7ZstTlIQO+/nGG+QMfDR5ejMPWsfvmdH1I6x2iefn7nMBkfalDGbTGKaEk
         cJa/s6K8BTsTdPV3/fOINTZ9u0Aoc+LgOkKqK7wRgW1zgiHkv09be8pvkMKqzEFwdL
         /19muYUSna8As7olwx9V5oGjGfivo9RvElPsSt8YtuHRn9etG9VdFltQSTsc1hWqY4
         9o5ZFeDiIDhGA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        John Fortin <fortinj66@gmail.com>,
        Sri Ramanujam <sri@ramanujam.io>
Subject: [PATCH] ceph: fix setting of xattrs on async created inodes
Date:   Mon, 25 Apr 2022 15:54:27 -0400
Message-Id: <20220425195427.60738-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently when we create a file, we spin up an xattr buffer to send
along with the create request. If we end up doing an async create
however, then we currently pass down a zero-length xattr buffer.

Fix the code to send down the xattr buffer in req->r_pagelist. If the
xattrs span more than a page, however give up and don't try to do an
async create.

Fixes: 9a8d03ca2e2c ("ceph: attempt to do async create when possible")
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2063929
Reported-by: John Fortin <fortinj66@gmail.com>
Reported-by: Sri Ramanujam <sri@ramanujam.io>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6c9e837aa1d3..8c8226c0feac 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -629,9 +629,15 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	iinfo.change_attr = 1;
 	ceph_encode_timespec64(&iinfo.btime, &now);
 
-	iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
-	iinfo.xattr_data = xattr_buf;
-	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
+	if (req->r_pagelist) {
+		iinfo.xattr_len = req->r_pagelist->length;
+		iinfo.xattr_data = req->r_pagelist->mapped_tail;
+	} else {
+		/* fake it */
+		iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
+		iinfo.xattr_data = xattr_buf;
+		memset(iinfo.xattr_data, 0, iinfo.xattr_len);
+	}
 
 	in.ino = cpu_to_le64(vino.ino);
 	in.snapid = cpu_to_le64(CEPH_NOSNAP);
@@ -743,6 +749,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+		/* Async create can't handle more than a page of xattrs */
+		if (as_ctx.pagelist &&
+		    !list_is_singular(&as_ctx.pagelist->head))
+			try_async = false;
 	} else if (!d_in_lookup(dentry)) {
 		/* If it's not being looked up, it's negative */
 		return -ENOENT;
-- 
2.35.1

