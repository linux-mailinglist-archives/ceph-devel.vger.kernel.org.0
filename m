Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34F815A32C
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 09:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgBLIZA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 03:25:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45680 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728353AbgBLIY7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 03:24:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581495898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yQB5ap0T0kWWOwjE2CHwGoDjK3quhTLYWZMl95ywvmw=;
        b=VwBZwYVKmHWmmD73QSJ2t/GqMk4shOICYDGeHos7P5UxVJoKEl9oh1YVOqI9o8HkbOxfsO
        NAWOsntFWjZUhaxfhAl+7C3A7BOdKMUxixYVdauihv4a0GgOw0Osn3IwcT667ZCNOXvsE1
        yaLSyqMxBZKvHV2TkPvBoEq95uthLmw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-s44_o7tPOTaIQtAf5mxeKw-1; Wed, 12 Feb 2020 03:24:54 -0500
X-MC-Unique: s44_o7tPOTaIQtAf5mxeKw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 157EBDB64;
        Wed, 12 Feb 2020 08:24:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-209.pek2.redhat.com [10.72.12.209])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3523101D483;
        Wed, 12 Feb 2020 08:24:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove CEPH_MOUNT_OPT_FSCACHE flag
Date:   Wed, 12 Feb 2020 03:24:35 -0500
Message-Id: <20200212082435.18118-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Since we can figure out whether the fscache is enabled or not by
using the fscache_uniq and this flag is redundant.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 9 +++------
 fs/ceph/super.h | 9 ++++-----
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 48f86eb82b9b..8df506dd9039 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -383,10 +383,7 @@ static int ceph_parse_mount_param(struct fs_context =
*fc,
 #ifdef CONFIG_CEPH_FSCACHE
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq =3D NULL;
-		if (result.negated) {
-			fsopt->flags &=3D ~CEPH_MOUNT_OPT_FSCACHE;
-		} else {
-			fsopt->flags |=3D CEPH_MOUNT_OPT_FSCACHE;
+		if (!result.negated) {
 			fsopt->fscache_uniq =3D param->string;
 			param->string =3D NULL;
 		}
@@ -605,7 +602,7 @@ static int ceph_show_options(struct seq_file *m, stru=
ct dentry *root)
 		seq_puts(m, ",nodcache");
 	if (fsopt->flags & CEPH_MOUNT_OPT_INO32)
 		seq_puts(m, ",ino32");
-	if (fsopt->flags & CEPH_MOUNT_OPT_FSCACHE) {
+	if (fsopt->fscache_uniq) {
 		seq_show_option(m, "fsc", fsopt->fscache_uniq);
 	}
 	if (fsopt->flags & CEPH_MOUNT_OPT_NOPOOLPERM)
@@ -969,7 +966,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_=
client *fsc,
 			goto out;
=20
 		/* setup fscache */
-		if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
+		if (fsc->mount_options->fscache_uniq) {
 			err =3D ceph_fscache_register_fs(fsc, fc);
 			if (err < 0)
 				goto out;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ebc25072b19b..ad44b98f3c3b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -38,11 +38,10 @@
 #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
 #define CEPH_MOUNT_OPT_INO32           (1<<8) /* 32 bit inos */
 #define CEPH_MOUNT_OPT_DCACHE          (1<<9) /* use dcache for readdir =
etc */
-#define CEPH_MOUNT_OPT_FSCACHE         (1<<10) /* use fscache */
-#define CEPH_MOUNT_OPT_NOPOOLPERM      (1<<11) /* no pool permission che=
ck */
-#define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds =
is up */
-#define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in s=
tatfs */
-#define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-=
from' op */
+#define CEPH_MOUNT_OPT_NOPOOLPERM      (1<<10) /* no pool permission che=
ck */
+#define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<11) /* mount waits if no mds =
is up */
+#define CEPH_MOUNT_OPT_NOQUOTADF       (1<<12) /* no root dir quota in s=
tatfs */
+#define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<13) /* don't use RADOS 'copy-=
from' op */
=20
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
--=20
2.21.0

