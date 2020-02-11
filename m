Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8165C159258
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Feb 2020 15:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbgBKOyw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Feb 2020 09:54:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25611 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729592AbgBKOyw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 11 Feb 2020 09:54:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581432890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0YUzZnkarEa6bwVMk3v8ZN2pEUoH6kCQ39AfUyygGq4=;
        b=i0hWQO7iU33yGmHWL9Trtt7jArD1o8/08V5i/7e7cTJOZ7/wXzJCGr9zCkuA8vOov2+H3k
        wpdJZD2/RW+EFKC6F7lsCB9dhXPVK0l4XSrTVDQk+ZXv5yG6eIMmIRDI8o4olQUqf48yN2
        a2dQgwaVN0LHQzU/ZKV2WN+46Ev6z+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-6kphe866PbShz_N96boOWg-1; Tue, 11 Feb 2020 09:54:49 -0500
X-MC-Unique: 6kphe866PbShz_N96boOWg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B85E477;
        Tue, 11 Feb 2020 14:54:48 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-13-118.pek2.redhat.com [10.72.13.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 569325C10D;
        Tue, 11 Feb 2020 14:54:45 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     jlayton@kernel.org, ceph-devel@vger.kernel.org
Cc:     "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v2] ceph: check if file lock exists before sending unlock request
Date:   Tue, 11 Feb 2020 22:54:43 +0800
Message-Id: <20200211145443.40988-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When a process exits, kernel closes its files. locks_remove_file()
is called to remove file locks on these files. locks_remove_file()
tries unlocking files even there is no file lock.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/locks.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index 544e9e85b120..d6b9166e71e4 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -210,6 +210,21 @@ static int ceph_lock_wait_for_completion(struct ceph=
_mds_client *mdsc,
 	return 0;
 }
=20
+static int try_unlock_file(struct file *file, struct file_lock *fl)
+{
+	int err;
+	unsigned int orig_flags =3D fl->fl_flags;
+	fl->fl_flags |=3D FL_EXISTS;
+	err =3D locks_lock_file_wait(file, fl);
+	fl->fl_flags =3D orig_flags;
+	if (err =3D=3D -ENOENT) {
+		if (!(orig_flags & FL_EXISTS))
+			err =3D 0;
+		return err;
+	}
+	return 1;
+}
+
 /**
  * Attempt to set an fcntl lock.
  * For now, this just goes away to the server. Later it may be more awes=
ome.
@@ -255,9 +270,15 @@ int ceph_lock(struct file *file, int cmd, struct fil=
e_lock *fl)
 	else
 		lock_cmd =3D CEPH_LOCK_UNLOCK;
=20
+	if (op =3D=3D CEPH_MDS_OP_SETFILELOCK && F_UNLCK =3D=3D fl->fl_type) {
+		err =3D try_unlock_file(file, fl);
+		if (err <=3D 0)
+			return err;
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
@@ -311,9 +332,15 @@ int ceph_flock(struct file *file, int cmd, struct fi=
le_lock *fl)
 	else
 		lock_cmd =3D CEPH_LOCK_UNLOCK;
=20
+	if (F_UNLCK =3D=3D fl->fl_type) {
+		err =3D try_unlock_file(file, fl);
+		if (err <=3D 0)
+			return err;
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

