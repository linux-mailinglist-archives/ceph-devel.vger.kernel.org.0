Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6187E540217
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244982AbiFGPF4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 11:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343845AbiFGPFz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 11:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44443F68B0
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 08:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03F16B820C0
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 15:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CF8C385A5;
        Tue,  7 Jun 2022 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654614351;
        bh=R39JnPbaq99/3qI5et3y8kdZ/iEDKB2XtRlk56mHlCA=;
        h=From:To:Cc:Subject:Date:From;
        b=hdWJpKA2pcXhBxjHRhnAFWbJoc77c3J/ZEchCRkVsitWOPC8VE0916dIYSCr1AVK9
         LfoEmcH+/T3yf27/55oFO7SA9frtF15HTWcryOOLLo8qCFQknKBBiOOET+bl6KRPZO
         EzSwwq1ANCs1x4KDkGz9h3S4Js9ztFTnmrE7Uo34VBwXfq4y9vGcJ1zf/5dODxg7AQ
         RcBeoL/+7YeybETsd0f2Dv4SeFz0BURt2M3l5kOBsHWrCev7Fk3t/g9g4ydSHIxd2k
         Txi3FOglW/qZdt/vw/UImJf88AfHn4wmSI7QmUf8TXziSPGYdawwkzaG65zYHgmR9h
         dWmQmFJEEZGXA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: convert to generic_file_llseek
Date:   Tue,  7 Jun 2022 11:05:49 -0400
Message-Id: <20220607150549.217390-1-jlayton@kernel.org>
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

With that gone, ceph_llseek is functionally equivalent to
generic_file_llseek, so just call that after getting the size.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/file.c | 52 +++++---------------------------------------------
 1 file changed, 5 insertions(+), 47 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 0c13a3f23c99..0e82a1c383ca 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1989,57 +1989,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
  */
 static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *inode = file->f_mapping->host;
-	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	loff_t i_size;
-	loff_t ret;
-
-	inode_lock(inode);
-
 	if (whence == SEEK_END || whence == SEEK_DATA || whence == SEEK_HOLE) {
+		struct inode *inode = file_inode(file);
+		int ret;
+
 		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
 		if (ret < 0)
-			goto out;
-	}
-
-	i_size = i_size_read(inode);
-	switch (whence) {
-	case SEEK_END:
-		offset += i_size;
-		break;
-	case SEEK_CUR:
-		/*
-		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
-		 * position-querying operation.  Avoid rewriting the "same"
-		 * f_pos value back to the file because a concurrent read(),
-		 * write() or lseek() might have altered it
-		 */
-		if (offset == 0) {
-			ret = file->f_pos;
-			goto out;
-		}
-		offset += file->f_pos;
-		break;
-	case SEEK_DATA:
-		if (offset < 0 || offset >= i_size) {
-			ret = -ENXIO;
-			goto out;
-		}
-		break;
-	case SEEK_HOLE:
-		if (offset < 0 || offset >= i_size) {
-			ret = -ENXIO;
-			goto out;
-		}
-		offset = i_size;
-		break;
+			return ret;
 	}
-
-	ret = vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
-
-out:
-	inode_unlock(inode);
-	return ret;
+	return generic_file_llseek(file, offset, whence);
 }
 
 static inline void ceph_zero_partial_page(
-- 
2.36.1

