Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C13C63D2CC
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Nov 2022 11:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbiK3KIP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Nov 2022 05:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbiK3KIL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Nov 2022 05:08:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D1F2E69C
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 02:08:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E803B81AA4
        for <ceph-devel@vger.kernel.org>; Wed, 30 Nov 2022 10:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC5AC433D6;
        Wed, 30 Nov 2022 10:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669802887;
        bh=QmffNLfb4svYBgfWB9kQFFA1DNMYL1EBfFIhGDyKjM4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t9wuBBAgCDTV2x3WmwDZF/prlgf3qOkOTFULS4qyK7bLqtTe2blUtvGLf+fQWbaF4
         WV5lGhFJWUeDCtEEQVYzFhB7oTgrwMPRP/pMaf6EPv7R4eAVskjqOn57MLKI6cSzyp
         lkvjEdhmmApyD1yVafkGkCIg8zNDioGnXLSxuxkoICSOMV2wZcq0XbH4lcz48OfAhQ
         CB7V8HnEtgzVnoxJAK8U2v7pFGJnvzmd8zAYfB74n9IRY+HPd6byGe5z46WK7vsntZ
         xzrOaA1VnRdNI+DEbJiF6WgQ4jYw0gsA5MQ7r6Dp20fY4kOAcl0crGimPwssKiJw5Q
         E+6FQ5XCXzsNw==
Message-ID: <4c83e1e6adfcef00c0640b43c3cdfb98d7b599d8.camel@kernel.org>
Subject: Re: [ceph-client:testing 2/4] fs/ceph/caps.c:2967:21: error:
 implicit declaration of function 'vfs_inode_has_locks'
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, kernel test robot <lkp@intel.com>
Cc:     oe-kbuild-all@lists.linux.dev, ceph-devel@vger.kernel.org
Date:   Wed, 30 Nov 2022 05:08:05 -0500
In-Reply-To: <87c8b139-37a3-1d65-5e79-fabe9c69bf34@redhat.com>
References: <202211301452.QQa0D5Kd-lkp@intel.com>
         <87c8b139-37a3-1d65-5e79-fabe9c69bf34@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1 (3.46.1-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-11-30 at 14:58 +0800, Xiubo Li wrote:
> Hi Jeff,
>=20
> Could you fix this in your vfs_inode_has_locks patch ?
>=20
> We should add one dummy inline func in :
>=20
> #else /* !CONFIG_FILE_LOCKING */
>=20
> #endif
>=20
> Currently I just added your filelock patch as one [DO NOT MERGE] in ceph=
=20
> tree for testing.
>=20
> Thanks!
>=20
> - Xiubo

Yes, good catch. Revised patch follows:

----------------8<----------------

[PATCH] filelock: new helper: vfs_inode_has_locks

Ceph has a need to know whether a particular inode has any locks set on
it. It's currently tracking that by a num_locks field in its
filp->private_data, but that's problematic as it tries to decrement this
field when releasing locks and that can race with the file being torn
down.

Add a new vfs_inode_has_locks helper that just returns whether any locks
are currently held on the inode.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/locks.c         | 23 +++++++++++++++++++++++
 include/linux/fs.h |  6 ++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 5876c8ff0edc..9ccf89b6c95d 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2672,6 +2672,29 @@ int vfs_cancel_lock(struct file *filp, struct file_l=
ock *fl)
 }
 EXPORT_SYMBOL_GPL(vfs_cancel_lock);
=20
+/**
+ * vfs_inode_has_locks - are any file locks held on @inode?
+ * @inode: inode to check for locks
+ *
+ * Return true if there are any FL_POSIX or FL_FLOCK locks currently
+ * set on @inode.
+ */
+bool vfs_inode_has_locks(struct inode *inode)
+{
+	struct file_lock_context *ctx;
+	bool ret;
+
+	ctx =3D smp_load_acquire(&inode->i_flctx);
+	if (!ctx)
+		return false;
+
+	spin_lock(&ctx->flc_lock);
+	ret =3D !list_empty(&ctx->flc_posix) || !list_empty(&ctx->flc_flock);
+	spin_unlock(&ctx->flc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfs_inode_has_locks);
+
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e654435f1651..6165c6245347 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1170,6 +1170,7 @@ extern int locks_delete_block(struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, =
struct file_lock *);
 extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
+bool vfs_inode_has_locks(struct inode *inode);
 extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl=
);
 extern int __break_lease(struct inode *inode, unsigned int flags, unsigned=
 int type);
 extern void lease_get_mtime(struct inode *, struct timespec64 *time);
@@ -1284,6 +1285,11 @@ static inline int vfs_cancel_lock(struct file *filp,=
 struct file_lock *fl)
 	return 0;
 }
=20
+static inline bool vfs_inode_has_locks(struct inode *inode)
+{
+	return false;
+}
+
 static inline int locks_lock_inode_wait(struct inode *inode, struct file_l=
ock *fl)
 {
 	return -ENOLCK;
--=20
2.38.1


