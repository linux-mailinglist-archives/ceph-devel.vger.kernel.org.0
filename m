Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41B370EE06
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 08:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239776AbjEXGir (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 02:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239715AbjEXGib (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 02:38:31 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA56518B;
        Tue, 23 May 2023 23:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eC4fKlJuAZk6Bs9zfH3GxbdW7XFrPuxkzUVDWdmQe5g=; b=U875Nf6B+VixmZn3RCK57UbTUU
        IFC0MeeaeIlbgfB/LVshuRLIofQrNBg07H6ArsN/S4kztKs2Gdx3sBck98mxzZ6RTXhCQBVXC7/u7
        i9xBhUMRbD7a1jKdA/JPzbaHfjiavwo4CIWKOoe1Yj8Z05UGrZF2AThxvYxwSQAyFfc87tXPIZ4vh
        V39JXltuaCnrdgxByGkJWT2mJPgbOnQgbZY/NGQM3agFFFH5l75VSVn8S/KTo2KbrkM03l+cEvvBf
        e/uITYC+j0JHWGaMUQ5DoVgNuR0TXMLu4m5OFU/iCDA+DzlVkPoKbiFDcpNMAlA0wT7qfVqH4Z4nE
        WHCJyCJw==;
Received: from [2001:4bb8:188:23b2:cbb8:fcea:a637:5089] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q1i8c-00CVf8-2h;
        Wed, 24 May 2023 06:38:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 03/11] filemap: update ki_pos in generic_perform_write
Date:   Wed, 24 May 2023 08:38:02 +0200
Message-Id: <20230524063810.1595778-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230524063810.1595778-1-hch@lst.de>
References: <20230524063810.1595778-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

All callers of generic_perform_write need to updated ki_pos, move it into
common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/ceph/file.c | 2 --
 fs/ext4/file.c | 9 +++------
 fs/f2fs/file.c | 1 -
 fs/nfs/file.c  | 1 -
 mm/filemap.c   | 8 ++++----
 5 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c8ef72f723badd..767f4dfe7def64 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1891,8 +1891,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		 * can not run at the same time
 		 */
 		written = generic_perform_write(iocb, from);
-		if (likely(written >= 0))
-			iocb->ki_pos = pos + written;
 		ceph_end_io_write(inode);
 	}
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index bc430270c23c19..ea0ada3985cba2 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -289,12 +289,9 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 
 out:
 	inode_unlock(inode);
-	if (likely(ret > 0)) {
-		iocb->ki_pos += ret;
-		ret = generic_write_sync(iocb, ret);
-	}
-
-	return ret;
+	if (unlikely(ret <= 0))
+		return ret;
+	return generic_write_sync(iocb, ret);
 }
 
 static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 4f423d367a44b9..7134fe8bd008cb 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4520,7 +4520,6 @@ static ssize_t f2fs_buffered_write_iter(struct kiocb *iocb,
 	ret = generic_perform_write(iocb, from);
 
 	if (ret > 0) {
-		iocb->ki_pos += ret;
 		f2fs_update_iostat(F2FS_I_SB(inode), inode,
 						APP_BUFFERED_IO, ret);
 	}
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 665ce3fc62eaf4..e8bb4c48a3210a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -655,7 +655,6 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 
 	written = result;
-	iocb->ki_pos += written;
 	nfs_add_stats(inode, NFSIOS_NORMALWRITTENBYTES, written);
 
 	if (mntflags & NFS_MOUNT_WRITE_EAGER) {
diff --git a/mm/filemap.c b/mm/filemap.c
index 33b54660ad2b39..15907af4a57ff5 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3957,7 +3957,10 @@ ssize_t generic_perform_write(struct kiocb *iocb, struct iov_iter *i)
 		balance_dirty_pages_ratelimited(mapping);
 	} while (iov_iter_count(i));
 
-	return written ? written : status;
+	if (!written)
+		return status;
+	iocb->ki_pos += written;
+	return written;
 }
 EXPORT_SYMBOL(generic_perform_write);
 
@@ -4034,7 +4037,6 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		endbyte = pos + status - 1;
 		err = filemap_write_and_wait_range(mapping, pos, endbyte);
 		if (err == 0) {
-			iocb->ki_pos = endbyte + 1;
 			written += status;
 			invalidate_mapping_pages(mapping,
 						 pos >> PAGE_SHIFT,
@@ -4047,8 +4049,6 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		}
 	} else {
 		written = generic_perform_write(iocb, from);
-		if (likely(written > 0))
-			iocb->ki_pos += written;
 	}
 out:
 	return written ? written : err;
-- 
2.39.2

