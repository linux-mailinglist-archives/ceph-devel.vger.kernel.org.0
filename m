Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C575C123BB7
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2019 01:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfLRAkZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 19:40:25 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22492 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725946AbfLRAkY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 19:40:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576629622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IZ6/wfszrQ+oQ12M6WASQ6diM6Bw30mbiPFa/qNLyLs=;
        b=U9wbYB7TlapHd0N4eTjOKGDR7LCkPZ0cCPRkMgX4dn3pqkD5BwtL5S8ctcWRljgDlMVYMw
        Xuhfp6trXMaautLBItn7VOIj/MpmIB5CvcR4NSWkr436vZ0QIZo2jbA8rAJAzBJDlsuzi0
        CWntoKogHZ2ieIZIH5KZeUCqb0kG06U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-5QvjeA-wNWGPtUW2swSo5g-1; Tue, 17 Dec 2019 19:40:19 -0500
X-MC-Unique: 5QvjeA-wNWGPtUW2swSo5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 977451856A60;
        Wed, 18 Dec 2019 00:40:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97D431A7E3;
        Wed, 18 Dec 2019 00:40:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: remove the extra slashes in the server path
Date:   Tue, 17 Dec 2019 19:40:09 -0500
Message-Id: <20191218004009.3781-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When mounting if the server path has more than one slash continuously,
such as:

'mount.ceph 192.168.195.165:40176:/// /mnt/cephfs/'

In the MDS server side the extra slashes of the server path will be
treated as snap dir, and then we can get the following debug logs:

<7>[  ...] ceph:  mount opening path //
<7>[  ...] ceph:  open_root_inode opening '//'
<7>[  ...] ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
<7>[  ...] ceph:  alloc_inode 00000000dc4ca00b
<7>[  ...] ceph:  get_inode created new inode 00000000dc4ca00b 1.ffffffff=
ffffffff ino 1
<7>[  ...] ceph:  get_inode on 1=3D1.ffffffffffffffff got 00000000dc4ca00=
b

And then when creating any new file or directory under the mount
point, we can get the following crash core dump:

<4>[  ...] ------------[ cut here ]------------
<2>[  ...] kernel BUG at fs/ceph/inode.c:1347!
<4>[  ...] invalid opcode: 0000 [#1] SMP PTI
<4>[  ...] CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G            E     5.=
4.0-rc5+ #1
<4>[  ...] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desk=
top Reference Platform, BIOS 6.00 05/19/2017
<4>[  ...] Workqueue: ceph-msgr ceph_con_workfn [libceph]
<4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
<4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 4d [...]
<4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
<4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 0000000000000=
006
<4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec17=
900
<4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 0000000000000=
885
<4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347e=
000
<4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0c=
900
<4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:00=
00000000000000
<4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 0000000000360=
6f0
<4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000=
000
<4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000=
400
<4>[  ...] Call Trace:
<4>[  ...]  dispatch+0x2ac/0x12b0 [ceph]
<4>[  ...]  ceph_con_workfn+0xd40/0x27c0 [libceph]
<4>[  ...]  process_one_work+0x1b0/0x350
<4>[  ...]  worker_thread+0x50/0x3b0
<4>[  ...]  kthread+0xfb/0x130
<4>[  ...]  ? process_one_work+0x350/0x350
<4>[  ...]  ? kthread_park+0x90/0x90
<4>[  ...]  ret_from_fork+0x35/0x40
<4>[  ...] Modules linked in: ceph(E) libceph fscache [...]
<4>[  ...] ---[ end trace ba883d8ccf9afcb0 ]---
<4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
<4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 [...]
<4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
<4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 0000000000000=
006
<4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec17=
900
<4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 0000000000000=
885
<4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347e=
000
<4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0c=
900
<4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:00=
00000000000000
<4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 0000000000360=
6f0
<4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000=
000
<4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000=
400

And we should ignore the extra slashes in the server path when mount
opening in case users have added them by mistake.

This will also help us to get an existing superblock if all the
other options are the same, such as all the following server paths
are treated as the same:

1) "//mydir1///mydir//"
2) "/mydir1/mydir"
3) "/mydir1/mydir/"

The mount_options->server_path will always save the original string
including the leading '/'.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V3:
- switch strchr instead.

Changed in V2:
- rebase to new mount API.


 fs/ceph/super.c | 118 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 98 insertions(+), 20 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 6f33a265ccf1..9c9af183ad45 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -107,7 +107,6 @@ static int ceph_statfs(struct dentry *dentry, struct =
kstatfs *buf)
 	return 0;
 }
=20
-
 static int ceph_sync_fs(struct super_block *sb, int wait)
 {
 	struct ceph_fs_client *fsc =3D ceph_sb_to_client(sb);
@@ -211,7 +210,6 @@ struct ceph_parse_opts_ctx {
=20
 /*
  * Parse the source parameter.  Distinguish the server list from the pat=
h.
- * Internally we do not include the leading '/' in the path.
  *
  * The source will look like:
  *     <server_spec>[,<server_spec>...]:[<path>]
@@ -232,12 +230,15 @@ static int ceph_parse_source(struct fs_parameter *p=
aram, struct fs_context *fc)
=20
 	dev_name_end =3D strchr(dev_name, '/');
 	if (dev_name_end) {
-		if (strlen(dev_name_end) > 1) {
-			kfree(fsopt->server_path);
-			fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
-			if (!fsopt->server_path)
-				return -ENOMEM;
-		}
+		kfree(fsopt->server_path);
+
+		/*
+		 * The server_path will include the whole chars from userland
+		 * including the leading '/'.
+		 */
+		fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
+		if (!fsopt->server_path)
+			return -ENOMEM;
 	} else {
 		dev_name_end =3D dev_name + strlen(dev_name);
 	}
@@ -459,6 +460,69 @@ static int strcmp_null(const char *s1, const char *s=
2)
 	return strcmp(s1, s2);
 }
=20
+/**
+ * path_remove_extra_slash - Remove the extra slashes in the server path
+ * @server_path: the server path and could be NULL
+ *
+ * Return NULL if the path is NULL or only consists of "/", or a string
+ * without any extra slashes including the leading slash(es) and the
+ * slash(es) at the end of the server path, such as:
+ * "//dir1////dir2///" --> "dir1/dir2"
+ */
+static char *path_remove_extra_slash(const char *server_path)
+{
+	const char *path =3D server_path;
+	const char *cur, *end;
+	char *buf, *p;
+	int len;
+
+	/* if the server path is omitted */
+	if (!path)
+		return NULL;
+
+	/* remove all the leading slashes */
+	while (*path =3D=3D '/')
+		path++;
+
+	/* if the server path only consists of slashes */
+	if (*path =3D=3D '\0')
+		return NULL;
+
+	len =3D strlen(path);
+
+	buf =3D kmalloc(len + 1, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	end =3D path + len;
+	p =3D buf;
+	do {
+		cur =3D strchr(path, '/');
+		if (!cur)
+			cur =3D end;
+
+		/* including the last '/' */
+		len =3D cur - path + 1;
+		memcpy(p, path, len);
+		p +=3D len;
+
+		while (*cur =3D=3D '/')
+			cur++;
+		path =3D cur;
+	} while (path < end);
+
+	*p =3D '\0';
+
+	/*
+	 * remove the last slash if there has and just to make sure that
+	 * we will get something like "dir1/dir2"
+	 */
+	if (*(--p) =3D=3D '/')
+		*p =3D '\0';
+
+	return buf;
+}
+
 static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 				 struct ceph_options *new_opt,
 				 struct ceph_fs_client *fsc)
@@ -466,6 +530,7 @@ static int compare_mount_options(struct ceph_mount_op=
tions *new_fsopt,
 	struct ceph_mount_options *fsopt1 =3D new_fsopt;
 	struct ceph_mount_options *fsopt2 =3D fsc->mount_options;
 	int ofs =3D offsetof(struct ceph_mount_options, snapdir_name);
+	char *p1, *p2;
 	int ret;
=20
 	ret =3D memcmp(fsopt1, fsopt2, ofs);
@@ -478,9 +543,21 @@ static int compare_mount_options(struct ceph_mount_o=
ptions *new_fsopt,
 	ret =3D strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
 	if (ret)
 		return ret;
-	ret =3D strcmp_null(fsopt1->server_path, fsopt2->server_path);
+
+	p1 =3D path_remove_extra_slash(fsopt1->server_path);
+	if (IS_ERR(p1))
+		return PTR_ERR(p1);
+	p2 =3D path_remove_extra_slash(fsopt2->server_path);
+	if (IS_ERR(p2)) {
+		kfree(p1);
+		return PTR_ERR(p2);
+	}
+	ret =3D strcmp_null(p1, p2);
+	kfree(p1);
+	kfree(p2);
 	if (ret)
 		return ret;
+
 	ret =3D strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
 	if (ret)
 		return ret;
@@ -786,7 +863,6 @@ static void destroy_caches(void)
 	ceph_fscache_unregister();
 }
=20
-
 /*
  * ceph_umount_begin - initiate forced umount.  Tear down down the
  * mount, skipping steps that may hang while waiting for server(s).
@@ -866,9 +942,6 @@ static struct dentry *open_root_dentry(struct ceph_fs=
_client *fsc,
 	return root;
 }
=20
-
-
-
 /*
  * mount: join the ceph cluster, and open root directory.
  */
@@ -883,7 +956,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_=
client *fsc,
 	mutex_lock(&fsc->client->mount_mutex);
=20
 	if (!fsc->sb->s_root) {
-		const char *path;
+		const char *path, *p;
 		err =3D __ceph_open_session(fsc->client, started);
 		if (err < 0)
 			goto out;
@@ -895,17 +968,22 @@ static struct dentry *ceph_real_mount(struct ceph_f=
s_client *fsc,
 				goto out;
 		}
=20
-		if (!fsc->mount_options->server_path) {
-			path =3D "";
-			dout("mount opening path \\t\n");
-		} else {
-			path =3D fsc->mount_options->server_path + 1;
-			dout("mount opening path %s\n", path);
+		p =3D path_remove_extra_slash(fsc->mount_options->server_path);
+		if (IS_ERR(p)) {
+			err =3D PTR_ERR(p);
+			goto out;
 		}
+		/* if the server path is omitted or just consists of '/' */
+		if (!p)
+			path =3D "";
+		else
+			path =3D p;
+		dout("mount opening path '%s'\n", path);
=20
 		ceph_fs_debugfs_init(fsc);
=20
 		root =3D open_root_dentry(fsc, path, started);
+		kfree(p);
 		if (IS_ERR(root)) {
 			err =3D PTR_ERR(root);
 			goto out;
--=20
2.21.0

