Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA6CAFBDF7
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 03:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfKNCkb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 13 Nov 2019 21:40:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31296 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726393AbfKNCkb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 13 Nov 2019 21:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573699229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4cjqeF07tjmzjJyc5K1vjCr3tUwKfn8FyQnx7Gu7dOM=;
        b=VsSN9SvsUV7YC2/RH0+wqOs9/glRlf+ooo09yztMThUH4AvUc2Eq3ntINZolakA6LkuqEZ
        +Gj0ebCILbU6MGG30Un2VXmY6lQRDvg/mxnk2t88t2AKeoTOw7fGpC43d13mEbbECJ0Kls
        OHoMhavpgp0J/ByJF+PrdMpAV83DK+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-2XbvfuirPZmvPuNjO6DeVQ-1; Wed, 13 Nov 2019 21:40:28 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EB8C1005500;
        Thu, 14 Nov 2019 02:40:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-243.pek2.redhat.com [10.72.12.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E12110841A6;
        Thu, 14 Nov 2019 02:40:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, sage@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: remove the extra slashes in the server path
Date:   Wed, 13 Nov 2019 21:40:19 -0500
Message-Id: <20191114024019.25417-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 2XbvfuirPZmvPuNjO6DeVQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When mounting if the server path has more than one slash, such as:

'mount.ceph 192.168.195.165:40176:/// /mnt/cephfs/'

In the MDS server side the extra slash will be treated as snap dir,
and then we can get the following debug logs:

<7>[  ...] ceph:  mount opening path //
<7>[  ...] ceph:  open_root_inode opening '//'
<7>[  ...] ceph:  fill_trace 0000000059b8a3bc is_dentry 0 is_target 1
<7>[  ...] ceph:  alloc_inode 00000000dc4ca00b
<7>[  ...] ceph:  get_inode created new inode 00000000dc4ca00b 1.ffffffffff=
ffffff ino 1
<7>[  ...] ceph:  get_inode on 1=3D1.ffffffffffffffff got 00000000dc4ca00b

And then when creating any new file or directory under the mount
point, we can get the following crash core dump:

<4>[  ...] ------------[ cut here ]------------
<2>[  ...] kernel BUG at fs/ceph/inode.c:1347!
<4>[  ...] invalid opcode: 0000 [#1] SMP PTI
<4>[  ...] CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G            E     5.4.=
0-rc5+ #1
<4>[  ...] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Deskto=
p Reference Platform, BIOS 6.00 05/19/2017
<4>[  ...] Workqueue: ceph-msgr ceph_con_workfn [libceph]
<4>[  ...] RIP: 0010:ceph_fill_trace+0x992/0xb30 [ceph]
<4>[  ...] Code: ff 0f 0b 0f 0b 0f 0b 4c 89 fa 48 c7 c6 4d [...]
<4>[  ...] RSP: 0018:ffffa23d40067c70 EFLAGS: 00010297
<4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 000000000000000=
6
<4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec1790=
0
<4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 000000000000088=
5
<4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347e00=
0
<4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0c90=
0
<4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:0000=
000000000000
<4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 00000000003606f=
0
<4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000000=
0
<4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000000040=
0
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
<4>[  ...] RAX: fffffffffffffffe RBX: ffff8a229eb566c0 RCX: 000000000000000=
6
<4>[  ...] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff8a23aec1790=
0
<4>[  ...] RBP: ffff8a226bd91eb0 R08: 0000000000000001 R09: 000000000000088=
5
<4>[  ...] R10: 000000000002dfd8 R11: ffff8a226bd95b30 R12: ffff8a239347e00=
0
<4>[  ...] R13: 0000000000000000 R14: ffff8a22fabeb000 R15: ffff8a2338b0c90=
0
<4>[  ...] FS:  0000000000000000(0000) GS:ffff8a23aec00000(0000) knlGS:0000=
000000000000
<4>[  ...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  ...] CR2: 000055b479d92068 CR3: 00000003764f6004 CR4: 00000000003606f=
0
<4>[  ...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000000=
0
<4>[  ...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000000040=
0

And we should ignore the extra slashes in the server path when mount
opening in case users have added them by mistake:

"//mydir1///mydir//" --> "mydir1/mydir/"

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 71 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index b47f43fc2d68..91985c53e611 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -430,6 +430,39 @@ static int strcmp_null(const char *s1, const char *s2)
 =09return strcmp(s1, s2);
 }
=20
+static char *path_remove_extra_slash(const char *path)
+{
+=09bool last_is_slash;
+=09int i, j;
+=09int len;
+=09char *p;
+
+=09if (!path)
+=09=09return NULL;
+
+=09len =3D strlen(path);
+
+=09p =3D kmalloc(len, GFP_NOFS);
+=09if (!p)
+=09=09return ERR_PTR(-ENOMEM);
+
+=09last_is_slash =3D false;
+=09for (j =3D 0, i =3D 0; i < len; i++) {
+=09=09if (path[i] =3D=3D '/') {
+=09=09=09if (last_is_slash)
+=09=09=09=09continue;
+=09=09=09last_is_slash =3D true;
+=09=09} else {
+=09=09=09last_is_slash =3D false;
+=09=09}
+=09=09p[j++] =3D path[i];
+=09}
+
+=09p[j] =3D '\0';
+
+=09return p;
+}
+
 static int compare_mount_options(struct ceph_mount_options *new_fsopt,
 =09=09=09=09 struct ceph_options *new_opt,
 =09=09=09=09 struct ceph_fs_client *fsc)
@@ -437,6 +470,7 @@ static int compare_mount_options(struct ceph_mount_opti=
ons *new_fsopt,
 =09struct ceph_mount_options *fsopt1 =3D new_fsopt;
 =09struct ceph_mount_options *fsopt2 =3D fsc->mount_options;
 =09int ofs =3D offsetof(struct ceph_mount_options, snapdir_name);
+=09char *p1, *p2;
 =09int ret;
=20
 =09ret =3D memcmp(fsopt1, fsopt2, ofs);
@@ -449,9 +483,21 @@ static int compare_mount_options(struct ceph_mount_opt=
ions *new_fsopt,
 =09ret =3D strcmp_null(fsopt1->mds_namespace, fsopt2->mds_namespace);
 =09if (ret)
 =09=09return ret;
-=09ret =3D strcmp_null(fsopt1->server_path, fsopt2->server_path);
+
+=09p1 =3D path_remove_extra_slash(fsopt1->server_path);
+=09if (IS_ERR(p1))
+=09=09return PTR_ERR(p1);
+=09p2 =3D path_remove_extra_slash(fsopt2->server_path);
+=09if (IS_ERR(p2)) {
+=09=09kfree(p1);
+=09=09return PTR_ERR(p2);
+=09}
+=09ret =3D strcmp_null(p1, p2);
+=09kfree(p1);
+=09kfree(p2);
 =09if (ret)
 =09=09return ret;
+
 =09ret =3D strcmp_null(fsopt1->fscache_uniq, fsopt2->fscache_uniq);
 =09if (ret)
 =09=09return ret;
@@ -507,12 +553,10 @@ static int parse_mount_options(struct ceph_mount_opti=
ons **pfsopt,
 =09 */
 =09dev_name_end =3D strchr(dev_name, '/');
 =09if (dev_name_end) {
-=09=09if (strlen(dev_name_end) > 1) {
-=09=09=09fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
-=09=09=09if (!fsopt->server_path) {
-=09=09=09=09err =3D -ENOMEM;
-=09=09=09=09goto out;
-=09=09=09}
+=09=09fsopt->server_path =3D kstrdup(dev_name_end, GFP_KERNEL);
+=09=09if (!fsopt->server_path) {
+=09=09=09err =3D -ENOMEM;
+=09=09=09goto out;
 =09=09}
 =09} else {
 =09=09dev_name_end =3D dev_name + strlen(dev_name);
@@ -945,7 +989,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_cl=
ient *fsc)
 =09mutex_lock(&fsc->client->mount_mutex);
=20
 =09if (!fsc->sb->s_root) {
-=09=09const char *path;
+=09=09const char *path, *p;
 =09=09err =3D __ceph_open_session(fsc->client, started);
 =09=09if (err < 0)
 =09=09=09goto out;
@@ -957,17 +1001,24 @@ static struct dentry *ceph_real_mount(struct ceph_fs=
_client *fsc)
 =09=09=09=09goto out;
 =09=09}
=20
-=09=09if (!fsc->mount_options->server_path) {
+=09=09p =3D path_remove_extra_slash(fsc->mount_options->server_path);
+=09=09if (IS_ERR(p)) {
+=09=09=09err =3D PTR_ERR(p);
+=09=09=09goto out;
+=09=09}
+=09=09/* if the server path is omitted in the dev_name or just '/' */
+=09=09if (!p || (p && strlen(p) =3D=3D 1)) {
 =09=09=09path =3D "";
 =09=09=09dout("mount opening path \\t\n");
 =09=09} else {
-=09=09=09path =3D fsc->mount_options->server_path + 1;
+=09=09=09path =3D p + 1;
 =09=09=09dout("mount opening path %s\n", path);
 =09=09}
=20
 =09=09ceph_fs_debugfs_init(fsc);
=20
 =09=09root =3D open_root_dentry(fsc, path, started);
+=09=09kfree(p);
 =09=09if (IS_ERR(root)) {
 =09=09=09err =3D PTR_ERR(root);
 =09=09=09goto out;
--=20
2.21.0

