Return-Path: <ceph-devel+bounces-3877-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B251FC0AB5A
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 15:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E34F83B3687
	for <lists+ceph-devel@lfdr.de>; Sun, 26 Oct 2025 14:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57962EA17A;
	Sun, 26 Oct 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtGgttAv"
X-Original-To: ceph-devel@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2EE2EA14D;
	Sun, 26 Oct 2025 14:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490256; cv=none; b=jCXuttz57zaIZ9Bwv37bE698q8u4BHmt14OdP7II1G36Lui8dxs0l4WrTxARhtnmMZUbnYS9rm7u4+/UfK10e5pPreDN+uMrU0QKBhrorNYDhxWFGKJTN4eOzEfThLdXQrazVgFJ8a+Xjleqk2QILP3ME187HmB6vLkVsdqgRjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490256; c=relaxed/simple;
	bh=mpf5qFwOiGAzShAaA25/0x0c7oVeSnXQxmTqcG1g7EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mw+hLIuoU5Y/bE4W1m3XYhwus7pDI2AzqJre7BSifwbKbDC/9nlwuQVVZ4grqfXoHemN89kKZk2ZUGymy0s5abf5svzHhMQyPOifbj1epV7ocP5kMqydpfUvmGd6GECaqI0HM7jAtcVGJzORNNhLfUL+/4Ue3pFnJlfoE+is43A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtGgttAv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF52C4CEF1;
	Sun, 26 Oct 2025 14:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490256;
	bh=mpf5qFwOiGAzShAaA25/0x0c7oVeSnXQxmTqcG1g7EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtGgttAvXAWATwzLu/F/VehzxFASKJrzBfrZoKKKLCU4EVJpFICCRgaNOZZA7gMad
	 8NLxMDQnliv4vgm1r2xAvxf2lhSLH+2xvhAuLVhC2wKYElfb5gTy9iyuar9E1xZQiM
	 OfCP8Pb3WvVO4J1+Sq3qtHxlhAf9TuZb7/kJHVuC797doQr0eXU+R43gsZk2GeTk9F
	 FhTOzzl4twadF1KSM5AEiri+SGrZbhib3YgChR/GXFgVEm4xpu5XgNQQtfwmgTbtbq
	 8SlSM3rleR1Ifw52cnTwL9focxs3C92f5vXoSQ0CiC17arhpeKQXuDB9bi4Qvk1+2s
	 3HWqNGJRREBzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kotresh HR <khiremat@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	xiubli@redhat.com,
	ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] ceph: fix multifs mds auth caps issue
Date: Sun, 26 Oct 2025 10:49:04 -0400
Message-ID: <20251026144958.26750-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kotresh HR <khiremat@redhat.com>

[ Upstream commit 22c73d52a6d05c5a2053385c0d6cd9984732799d ]

The mds auth caps check should also validate the
fsname along with the associated caps. Not doing
so would result in applying the mds auth caps of
one fs on to the other fs in a multifs ceph cluster.
The bug causes multiple issues w.r.t user
authentication, following is one such example.

Steps to Reproduce (on vstart cluster):
1. Create two file systems in a cluster, say 'fsname1' and 'fsname2'
2. Authorize read only permission to the user 'client.usr' on fs 'fsname1'
    $ceph fs authorize fsname1 client.usr / r
3. Authorize read and write permission to the same user 'client.usr' on fs 'fsname2'
    $ceph fs authorize fsname2 client.usr / rw
4. Update the keyring
    $ceph auth get client.usr >> ./keyring

With above permssions for the user 'client.usr', following is the
expectation.
  a. The 'client.usr' should be able to only read the contents
     and not allowed to create or delete files on file system 'fsname1'.
  b. The 'client.usr' should be able to read/write on file system 'fsname2'.

But, with this bug, the 'client.usr' is allowed to read/write on file
system 'fsname1'. See below.

5. Mount the file system 'fsname1' with the user 'client.usr'
     $sudo bin/mount.ceph usr@.fsname1=/ /kmnt_fsname1_usr/
6. Try creating a file on file system 'fsname1' with user 'client.usr'. This
   should fail but passes with this bug.
     $touch /kmnt_fsname1_usr/file1
7. Mount the file system 'fsname1' with the user 'client.admin' and create a
   file.
     $sudo bin/mount.ceph admin@.fsname1=/ /kmnt_fsname1_admin
     $echo "data" > /kmnt_fsname1_admin/admin_file1
8. Try removing an existing file on file system 'fsname1' with the user
   'client.usr'. This shoudn't succeed but succeeds with the bug.
     $rm -f /kmnt_fsname1_usr/admin_file1

For more information, please take a look at the corresponding mds/fuse patch
and tests added by looking into the tracker mentioned below.

v2: Fix a possible null dereference in doutc
v3: Don't store fsname from mdsmap, validate against
    ceph_mount_options's fsname and use it
v4: Code refactor, better warning message and
    fix possible compiler warning

[ Slava.Dubeyko: "fsname check failed" -> "fsname mismatch" ]

Link: https://tracker.ceph.com/issues/72167
Signed-off-by: Kotresh HR <khiremat@redhat.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this patch plugs a real permissions hole in CephFS multi-FS
deployments with a contained, low-risk change.

- `fs/ceph/mds_client.c:5658-5669` now refuses an auth-cap entry when
  its `match.fs_name` differs from the mounted namespace; without this
  guard the client can borrow read/write caps from another filesystem
  and escalate privileges exactly as shown in the repro.
- `fs/ceph/mdsmap.c:355-371` rejects an incoming MDS map whose `fs_name`
  does not match the selected namespace, preventing the client from ever
  switching to the wrong filesystem context before the cap check runs.
- `fs/ceph/super.h:107-118` just moves the existing `namespace_equals()`
  helper so it can be reused; there’s no behavioral change beyond
  sharing the check.

The fix is tightly scoped to the Ceph client, doesn’t introduce new
APIs, and gracefully falls back when older servers omit `fs_name` (the
compare is skipped). The only new failure mode is refusing to mount/use
the wrong filesystem, which is precisely what we want. This is a
security-relevant bug fix that meets the stable tree criteria;
backporting is advisable. Recommended follow-up after backport: run the
multi-filesystem auth-cap scenario from the tracker to confirm the
regression is gone.

 fs/ceph/mds_client.c |  8 ++++++++
 fs/ceph/mdsmap.c     | 14 +++++++++++++-
 fs/ceph/super.c      | 14 --------------
 fs/ceph/super.h      | 14 ++++++++++++++
 4 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3bc72b47fe4d4..3efbc11596e00 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5649,11 +5649,19 @@ static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
+	const char *fs_name = mdsc->fsc->mount_options->mds_namespace;
 	const char *spath = mdsc->fsc->mount_options->server_path;
 	bool gid_matched = false;
 	u32 gid, tlen, len;
 	int i, j;
 
+	doutc(cl, "fsname check fs_name=%s  match.fs_name=%s\n",
+	      fs_name, auth->match.fs_name ? auth->match.fs_name : "");
+	if (auth->match.fs_name && strcmp(auth->match.fs_name, fs_name)) {
+		/* fsname mismatch, try next one */
+		return 0;
+	}
+
 	doutc(cl, "match.uid %lld\n", auth->match.uid);
 	if (auth->match.uid != MDS_AUTH_UID_ANY) {
 		if (auth->match.uid != caller_uid)
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8109aba66e023..2c7b151a7c95c 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -353,10 +353,22 @@ struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
 		__decode_and_drop_type(p, end, u8, bad_ext);
 	}
 	if (mdsmap_ev >= 8) {
+		u32 fsname_len;
 		/* enabled */
 		ceph_decode_8_safe(p, end, m->m_enabled, bad_ext);
 		/* fs_name */
-		ceph_decode_skip_string(p, end, bad_ext);
+		ceph_decode_32_safe(p, end, fsname_len, bad_ext);
+
+		/* validate fsname against mds_namespace */
+		if (!namespace_equals(mdsc->fsc->mount_options, *p,
+				      fsname_len)) {
+			pr_warn_client(cl, "fsname %*pE doesn't match mds_namespace %s\n",
+				       (int)fsname_len, (char *)*p,
+				       mdsc->fsc->mount_options->mds_namespace);
+			goto bad;
+		}
+		/* skip fsname after validation */
+		ceph_decode_skip_n(p, end, fsname_len, bad);
 	}
 	/* damaged */
 	if (mdsmap_ev >= 9) {
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c3eb651862c55..ebef5244ae25a 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -246,20 +246,6 @@ static void canonicalize_path(char *path)
 	path[j] = '\0';
 }
 
-/*
- * Check if the mds namespace in ceph_mount_options matches
- * the passed in namespace string. First time match (when
- * ->mds_namespace is NULL) is treated specially, since
- * ->mds_namespace needs to be initialized by the caller.
- */
-static int namespace_equals(struct ceph_mount_options *fsopt,
-			    const char *namespace, size_t len)
-{
-	return !(fsopt->mds_namespace &&
-		 (strlen(fsopt->mds_namespace) != len ||
-		  strncmp(fsopt->mds_namespace, namespace, len)));
-}
-
 static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
 				 struct fs_context *fc)
 {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index cf176aab0f823..4ac6561285b18 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -104,6 +104,20 @@ struct ceph_mount_options {
 	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
+/*
+ * Check if the mds namespace in ceph_mount_options matches
+ * the passed in namespace string. First time match (when
+ * ->mds_namespace is NULL) is treated specially, since
+ * ->mds_namespace needs to be initialized by the caller.
+ */
+static inline int namespace_equals(struct ceph_mount_options *fsopt,
+				   const char *namespace, size_t len)
+{
+	return !(fsopt->mds_namespace &&
+		 (strlen(fsopt->mds_namespace) != len ||
+		  strncmp(fsopt->mds_namespace, namespace, len)));
+}
+
 /* mount state */
 enum {
 	CEPH_MOUNT_MOUNTING,
-- 
2.51.0


