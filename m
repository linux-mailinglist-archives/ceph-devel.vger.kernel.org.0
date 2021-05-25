Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789763902C9
	for <lists+ceph-devel@lfdr.de>; Tue, 25 May 2021 15:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhEYNwd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 May 2021 09:52:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:42390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233155AbhEYNwd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 25 May 2021 09:52:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1621950661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lk7KBT5ZiYvhccuNilA5BAF8HpqJCTgi83U7AEOzoXI=;
        b=q5jkwTxGdqeaGaDaqiqLIMLCpp5ptFXuGCcr1hJS/3Ipux9vO7RWjhItyRVSvv9CvGzf1V
        xLOTzWVgELW+6kBZRNOrt0um7pb3yGoABY1Je9rN0EfiEAsNiovwR/0bdvjxIp1OD3KuwB
        RdwlPMFCD29Qro9mh1HywNZCokn9tpw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1621950661;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lk7KBT5ZiYvhccuNilA5BAF8HpqJCTgi83U7AEOzoXI=;
        b=45NGqsBKUkiz2pmlZQ15hMWjdOMZh/W+62lRh1LP7ZIk+ibFNNxLmmMKvXMknkPqn2A7bv
        OKqIdEAkUaTkJWAA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AD081AE99;
        Tue, 25 May 2021 13:51:01 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 16FE91F2CAB; Tue, 25 May 2021 15:51:00 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, ceph-devel@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        linux-cifs@vger.kernel.org, <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, <linux-mm@kvack.org>,
        <linux-xfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        Steve French <sfrench@samba.org>, Ted Tso <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 02/13] documentation: Sync file_operations members with reality
Date:   Tue, 25 May 2021 15:50:39 +0200
Message-Id: <20210525135100.11221-2-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210525125652.20457-1-jack@suse.cz>
References: <20210525125652.20457-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sync listing of struct file_operations members with the real one in
fs.h.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/locking.rst | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 1e894480115b..4ed2b22bd0a8 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -506,6 +506,7 @@ prototypes::
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
 	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
+	int (*iopoll) (struct kiocb *kiocb, bool spin);
 	int (*iterate) (struct file *, struct dir_context *);
 	int (*iterate_shared) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
@@ -518,12 +519,6 @@ prototypes::
 	int (*fsync) (struct file *, loff_t start, loff_t end, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long,
-			loff_t *);
-	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long,
-			loff_t *);
-	ssize_t (*sendfile) (struct file *, loff_t *, size_t, read_actor_t,
-			void __user *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t,
 			loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long,
@@ -536,6 +531,14 @@ prototypes::
 			size_t, unsigned int);
 	int (*setlease)(struct file *, long, struct file_lock **, void **);
 	long (*fallocate)(struct file *, int, loff_t, loff_t);
+	void (*show_fdinfo)(struct seq_file *m, struct file *f);
+	unsigned (*mmap_capabilities)(struct file *);
+	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *,
+			loff_t, size_t, unsigned int);
+	loff_t (*remap_file_range)(struct file *file_in, loff_t pos_in,
+			struct file *file_out, loff_t pos_out,
+			loff_t len, unsigned int remap_flags);
+	int (*fadvise)(struct file *, loff_t, loff_t, int);
 
 locking rules:
 	All may block.
-- 
2.26.2

