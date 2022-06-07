Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFFB53FD76
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242872AbiFGL1W (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 07:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241694AbiFGL1S (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 07:27:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB1D116D
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 04:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0864D61692
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 11:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D0CC34115;
        Tue,  7 Jun 2022 11:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654601234;
        bh=YdbnFCt6Z4j3YFX6QMC0YzN0RIeMJG87B+23hC//WOk=;
        h=From:To:Cc:Subject:Date:From;
        b=SU4Gub8WExlvQTWBjrb+c1BrMeaDwTh19yNOGJnFcvy9Krr38SIGmjYWwesZDTleF
         C0Bk+HC9u0u/TxDiYOKo1ZGEGmiVKUCEOrFR++P9cDozB2yZEQdh4fRTSF4M6UVZGY
         nPdc9oFRapeOlOUvOmmz+iC+G1i+9IxFSViuKDn1N3Kd0ZrZFkn1cUPSOjLFS1FC6B
         0o+dFjzH9Kfwv3OvmER5yr/1NzvXv+1g24eRoXi3+HPmU/q+pQP7ITRmjAYNZuyuHB
         TLXM56isDXCS7JVSeJ0J4dOVKHJ6Lu+TuQaEfuYcvVCTpX6VXGr2r9OkGTBB+V1fMy
         TBUkIBCDOnGtw==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: don't take inode lock in llseek
Date:   Tue,  7 Jun 2022 07:27:12 -0400
Message-Id: <20220607112712.18023-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

There's no reason we need to lock the inode for write in order to handle
an llseek. I suspect this should have been dropped in 2013 when we
stopped doing vmtruncate in llseek.

Fixes: b0d7c2231015 (ceph: introduce i_truncate_mutex)
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0c13a3f23c99..7d2e9615614d 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1994,8 +1994,6 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
 	loff_t i_size;
 	loff_t ret;
 
-	inode_lock(inode);
-
 	if (whence == SEEK_END || whence == SEEK_DATA || whence == SEEK_HOLE) {
 		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
 		if (ret < 0)
@@ -2038,7 +2036,6 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
 	ret = vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
 
 out:
-	inode_unlock(inode);
 	return ret;
 }
 
-- 
2.36.1

