Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB69158B8D
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 09:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgBKI7K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 03:59:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54080 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727608AbgBKI7K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 03:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581411549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OpYLi/SKvpTFGnb6x+Unzb5oJB6614lgbLk6nYwF4jI=;
        b=XJOwbV3SdovLsdQC5zTu8oJH9UCYAaqaDpeziM6XRjW7Q2qft1CJnWuXbx5GcwH67QI4Ii
        zYn433HtoNSm5f1bGNi4g1rk/Wd+nkmsvL8YWfVCo+HFpsIaCuE4cf7Th2gHtvqg7FM3yP
        nGOM1lC672YoXoI7UIjzQwWJjZnw4fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-rVaUnRCPNyGTXIRerrQR4Q-1; Tue, 11 Feb 2020 03:59:05 -0500
X-MC-Unique: rVaUnRCPNyGTXIRerrQR4Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6D4A1922961;
        Tue, 11 Feb 2020 08:59:04 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-13-118.pek2.redhat.com [10.72.13.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 117185D9CA;
        Tue, 11 Feb 2020 08:59:02 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     jlayton@kernel.org, ceph-devel@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] ceph: check if file lock exists before sending unlock request
Date:   Tue, 11 Feb 2020 16:59:01 +0800
Message-Id: <20200211085901.16256-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When a process exits, kernel closes its files. locks_remove_file()
is called to remove file locks on these files. locks_remove_file()
tries unlocking files locks even there is no file locks.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/locks.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 544e9e85b120..78be861259eb 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -255,9 +255,21 @@ int ceph_lock(struct file *file, int cmd, struct fil=
e_lock *fl)
 	else
 		lock_cmd =3D CEPH_LOCK_UNLOCK;
=20
+	if (op =3D=3D CEPH_MDS_OP_SETFILELOCK && F_UNLCK =3D=3D fl->fl_type) {
+		unsigned int orig_flags =3D fl->fl_flags;
+		fl->fl_flags |=3D FL_EXISTS;
+		err =3D posix_lock_file(file, fl, NULL);
+		fl->fl_flags =3D orig_flags;
+		if (err =3D=3D -ENOENT) {
+			if (!(orig_flags & FL_EXISTS))
+				err =3D 0;
+			return err;
+		}
+	}
+
 	err =3D ceph_lock_message(CEPH_LOCK_FCNTL, op, inode, lock_cmd, wait, f=
l);
 	if (!err) {
-		if (op =3D=3D CEPH_MDS_OP_SETFILELOCK) {
+		if (op =3D=3D CEPH_MDS_OP_SETFILELOCK && F_UNLCK !=3D fl->fl_type) {
 			dout("mds locked, locking locally\n");
 			err =3D posix_lock_file(file, fl, NULL);
 			if (err) {
@@ -311,9 +323,21 @@ int ceph_flock(struct file *file, int cmd, struct fi=
le_lock *fl)
 	else
 		lock_cmd =3D CEPH_LOCK_UNLOCK;
=20
+	if (F_UNLCK =3D=3D fl->fl_type) {
+		unsigned int orig_flags =3D fl->fl_flags;
+		fl->fl_flags |=3D FL_EXISTS;
+		err =3D locks_lock_file_wait(file, fl);
+		fl->fl_flags =3D orig_flags;
+		if (err =3D=3D -ENOENT) {
+			if (!(orig_flags & FL_EXISTS))
+				err =3D 0;
+			return err;
+		}
+	}
+
 	err =3D ceph_lock_message(CEPH_LOCK_FLOCK, CEPH_MDS_OP_SETFILELOCK,
 				inode, lock_cmd, wait, fl);
-	if (!err) {
+	if (!err && F_UNLCK !=3D fl->fl_type) {
 		err =3D locks_lock_file_wait(file, fl);
 		if (err) {
 			ceph_lock_message(CEPH_LOCK_FLOCK,
--=20
2.21.1

