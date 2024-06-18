Return-Path: <ceph-devel+bounces-1464-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E2790CF52
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Jun 2024 15:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 309E42816C5
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Jun 2024 13:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC2A15D5C9;
	Tue, 18 Jun 2024 12:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDgArh80"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F311513A245;
	Tue, 18 Jun 2024 12:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714823; cv=none; b=IwjN3xG2ywuCJY3nWyMNlX/nHfB5hieSb6IUJNJBprxeImS7xletPGjV6ktbYoyovP7R5xg5KVxJhKu9/55LugAhwV0i7zPQOhUS++mTonhqIKOYjow+Zmel4hV/jIIEM5jwzPsLiwUfGi/lb4IK6hQu0+NFwW8p9F3r4Grmabs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714823; c=relaxed/simple;
	bh=klNGKAkmhe/JCXNsPNubvBRwf78uvbcGYIiuZ3PUJag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6H/zdmFmeNrBaNOpzALvqaxsniCB3d9sKpEbJN0/m7RN44lxb22Lfbr4xUHIVb4UvtY1MvGnojaMI5VxFlMyQTk80bWzOML/x4RqRMgAiKqd7GZ7aAft4hHbvICRSS1rqjc+T7wB9gBBjZbzkF0/rLp5/ib2tqNcij9nJfTfnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDgArh80; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C0C3277B;
	Tue, 18 Jun 2024 12:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714822;
	bh=klNGKAkmhe/JCXNsPNubvBRwf78uvbcGYIiuZ3PUJag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDgArh80/Rhp4kks88YPtG6UF1+b2qKAkzQympTNd2HPe4yxR3VmBOl3F8sGXV3Zp
	 lFRhUxadLdkLWiTAeWyzzOKToj5+10OyApnXE3KvTYt/ummEaiP6bxhx+WfsqPP8+q
	 ppIbh40/m6xfhhOM4vVchQ2lNqKGtCiXBL30hnzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HPDD-discuss@lists.01.org,
	ceph-devel@vger.kernel.org,
	cluster-devel@redhat.com,
	fuse-devel@lists.sourceforge.net,
	ocfs2-devel@oss.oracle.com,
	Jeff Layton <jeff.layton@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/770] nfsd: add a new EXPORT_OP_NOWCC flag to struct export_operations
Date: Tue, 18 Jun 2024 14:29:12 +0200
Message-ID: <20240618123411.092963862@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jeff.layton@primarydata.com>

[ Upstream commit daab110e47f8d7aa6da66923e3ac1a8dbd2b2a72 ]

With NFSv3 nfsd will always attempt to send along WCC data to the
client. This generally involves saving off the in-core inode information
prior to doing the operation on the given filehandle, and then issuing a
vfs_getattr to it after the op.

Some filesystems (particularly clustered or networked ones) have an
expensive ->getattr inode operation. Atomicity is also often difficult
or impossible to guarantee on such filesystems. For those, we're best
off not trying to provide WCC information to the client at all, and to
simply allow it to poll for that information as needed with a GETATTR
RPC.

This patch adds a new flags field to struct export_operations, and
defines a new EXPORT_OP_NOWCC flag that filesystems can use to indicate
that nfsd should not attempt to provide WCC info in NFSv3 replies. It
also adds a blurb about the new flags field and flag to the exporting
documentation.

The server will also now skip collecting this information for NFSv2 as
well, since that info is never used there anyway.

Note that this patch does not add this flag to any filesystem
export_operations structures. This was originally developed to allow
reexporting nfs via nfsd.

Other filesystems may want to consider enabling this flag too. It's hard
to tell however which ones have export operations to enable export via
knfsd and which ones mostly rely on them for open-by-filehandle support,
so I'm leaving that up to the individual maintainers to decide. I am
cc'ing the relevant lists for those filesystems that I think may want to
consider adding this though.

Cc: HPDD-discuss@lists.01.org
Cc: ceph-devel@vger.kernel.org
Cc: cluster-devel@redhat.com
Cc: fuse-devel@lists.sourceforge.net
Cc: ocfs2-devel@oss.oracle.com
Signed-off-by: Jeff Layton <jeff.layton@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/nfs/exporting.rst | 27 +++++++++++++++++++++
 fs/nfs/export.c                             |  1 +
 fs/nfsd/nfs3xdr.c                           |  7 ++++--
 fs/nfsd/nfsfh.c                             | 14 +++++++++++
 fs/nfsd/nfsfh.h                             |  2 +-
 include/linux/exportfs.h                    |  2 ++
 6 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index 33d588a01ace1..cbe542ad52333 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -154,6 +154,11 @@ struct which has the following members:
     to find potential names, and matches inode numbers to find the correct
     match.
 
+  flags
+    Some filesystems may need to be handled differently than others. The
+    export_operations struct also includes a flags field that allows the
+    filesystem to communicate such information to nfsd. See the Export
+    Operations Flags section below for more explanation.
 
 A filehandle fragment consists of an array of 1 or more 4byte words,
 together with a one byte "type".
@@ -163,3 +168,25 @@ generated by encode_fh, in which case it will have been padded with
 nuls.  Rather, the encode_fh routine should choose a "type" which
 indicates the decode_fh how much of the filehandle is valid, and how
 it should be interpreted.
+
+Export Operations Flags
+-----------------------
+In addition to the operation vector pointers, struct export_operations also
+contains a "flags" field that allows the filesystem to communicate to nfsd
+that it may want to do things differently when dealing with it. The
+following flags are defined:
+
+  EXPORT_OP_NOWCC - disable NFSv3 WCC attributes on this filesystem
+    RFC 1813 recommends that servers always send weak cache consistency
+    (WCC) data to the client after each operation. The server should
+    atomically collect attributes about the inode, do an operation on it,
+    and then collect the attributes afterward. This allows the client to
+    skip issuing GETATTRs in some situations but means that the server
+    is calling vfs_getattr for almost all RPCs. On some filesystems
+    (particularly those that are clustered or networked) this is expensive
+    and atomicity is difficult to guarantee. This flag indicates to nfsd
+    that it should skip providing WCC attributes to the client in NFSv3
+    replies when doing operations on this filesystem. Consider enabling
+    this on filesystems that have an expensive ->getattr inode operation,
+    or when atomicity between pre and post operation attribute collection
+    is impossible to guarantee.
diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index 3430d6891e89f..8f4c528865c57 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -171,4 +171,5 @@ const struct export_operations nfs_export_ops = {
 	.encode_fh = nfs_encode_fh,
 	.fh_to_dentry = nfs_fh_to_dentry,
 	.get_parent = nfs_get_parent,
+	.flags = EXPORT_OP_NOWCC,
 };
diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 7d44e10a5f5dd..34b880211e5ea 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -206,7 +206,7 @@ static __be32 *
 encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 {
 	struct dentry *dentry = fhp->fh_dentry;
-	if (dentry && d_really_is_positive(dentry)) {
+	if (!fhp->fh_no_wcc && dentry && d_really_is_positive(dentry)) {
 	        __be32 err;
 		struct kstat stat;
 
@@ -262,7 +262,7 @@ void fill_pre_wcc(struct svc_fh *fhp)
 	bool v4 = (fhp->fh_maxsize == NFS4_FHSIZE);
 	__be32 err;
 
-	if (fhp->fh_pre_saved)
+	if (fhp->fh_no_wcc || fhp->fh_pre_saved)
 		return;
 	inode = d_inode(fhp->fh_dentry);
 	err = fh_getattr(fhp, &stat);
@@ -290,6 +290,9 @@ void fill_post_wcc(struct svc_fh *fhp)
 	struct inode *inode = d_inode(fhp->fh_dentry);
 	__be32 err;
 
+	if (fhp->fh_no_wcc)
+		return;
+
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
index c81dbbad87920..9c29a523f4848 100644
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -291,6 +291,16 @@ static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 
 	fhp->fh_dentry = dentry;
 	fhp->fh_export = exp;
+
+	switch (rqstp->rq_vers) {
+	case 3:
+		if (dentry->d_sb->s_export_op->flags & EXPORT_OP_NOWCC)
+			fhp->fh_no_wcc = true;
+		break;
+	case 2:
+		fhp->fh_no_wcc = true;
+	}
+
 	return 0;
 out:
 	exp_put(exp);
@@ -559,6 +569,9 @@ fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
 	 */
 	set_version_and_fsid_type(fhp, exp, ref_fh);
 
+	/* If we have a ref_fh, then copy the fh_no_wcc setting from it. */
+	fhp->fh_no_wcc = ref_fh ? ref_fh->fh_no_wcc : false;
+
 	if (ref_fh == fhp)
 		fh_put(ref_fh);
 
@@ -662,6 +675,7 @@ fh_put(struct svc_fh *fhp)
 		exp_put(exp);
 		fhp->fh_export = NULL;
 	}
+	fhp->fh_no_wcc = false;
 	return;
 }
 
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 45bd776290d52..347d10aa62655 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -35,6 +35,7 @@ typedef struct svc_fh {
 
 	bool			fh_locked;	/* inode locked by us */
 	bool			fh_want_write;	/* remount protection taken */
+	bool			fh_no_wcc;	/* no wcc data needed */
 	int			fh_flags;	/* FH flags */
 #ifdef CONFIG_NFSD_V3
 	bool			fh_post_saved;	/* post-op attrs saved */
@@ -54,7 +55,6 @@ typedef struct svc_fh {
 	struct kstat		fh_post_attr;	/* full attrs after operation */
 	u64			fh_post_change; /* nfsv4 change; see above */
 #endif /* CONFIG_NFSD_V3 */
-
 } svc_fh;
 #define NFSD4_FH_FOREIGN (1<<0)
 #define SET_FH_FLAG(c, f) ((c)->fh_flags |= (f))
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 3ceb72b67a7aa..e7de0103a32e8 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -213,6 +213,8 @@ struct export_operations {
 			  bool write, u32 *device_generation);
 	int (*commit_blocks)(struct inode *inode, struct iomap *iomaps,
 			     int nr_iomaps, struct iattr *iattr);
+#define	EXPORT_OP_NOWCC		(0x1)	/* Don't collect wcc data for NFSv3 replies */
+	unsigned long	flags;
 };
 
 extern int exportfs_encode_inode_fh(struct inode *inode, struct fid *fid,
-- 
2.43.0




