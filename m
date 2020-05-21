Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F1B1DC7C9
	for <lists+ceph-devel@lfdr.de>; Thu, 21 May 2020 09:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbgEUHga (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 May 2020 03:36:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40752 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728053AbgEUHg3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 May 2020 03:36:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590046587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=NLmZ1+kgN0fg3iDgBLAvbgSBWZ56RHkgaZXpxHvpKFk=;
        b=f+pzREw1TA2kzx5Ru2FQAvmRRhLUJm7Zzqps9s6CW5bXwOIJ3dPhCYvqJysZM8pOyLGmp9
        h5k5u+pexvwltfi+IcR53a5st3vPQZXh5c1+VG+TG80wAyQCgKgvHYXGFJ+xP/V0cPg0Us
        rDAKzvT8cP0tOKTg65Zh4Xx5mmcjJRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-Db3D0-LkP1iBJakw6MO6bA-1; Thu, 21 May 2020 03:36:23 -0400
X-MC-Unique: Db3D0-LkP1iBJakw6MO6bA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2BD068005AA;
        Thu, 21 May 2020 07:36:22 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BD0A5C1B0;
        Thu, 21 May 2020 07:36:19 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add ceph_async_check_caps() to avoid double lock and deadlock
Date:   Thu, 21 May 2020 03:36:16 -0400
Message-Id: <1590046576-1262-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In the ceph_check_caps() it may call the session lock/unlock stuff.

There have some deadlock cases, like:
handle_forward()
...
mutex_lock(&mdsc->mutex)
...
ceph_mdsc_put_request()
  --> ceph_mdsc_release_request()
    --> ceph_put_cap_request()
      --> ceph_put_cap_refs()
        --> ceph_check_caps()
...
mutex_unlock(&mdsc->mutex)

And also there maybe has some double session lock cases, like:

send_mds_reconnect()
...
mutex_lock(&session->s_mutex);
...
  --> replay_unsafe_requests()
    --> ceph_mdsc_release_dir_caps()
      --> ceph_put_cap_refs()
        --> ceph_check_caps()
...
mutex_unlock(&session->s_mutex);

URL: https://tracker.ceph.com/issues/45635
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  |  2 +-
 fs/ceph/inode.c | 10 ++++++++++
 fs/ceph/super.h | 12 ++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 27c2e60..08194c4 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3073,7 +3073,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
 	     last ? " last" : "", put ? " put" : "");
 
 	if (last)
-		ceph_check_caps(ci, 0, NULL);
+		ceph_async_check_caps(ci);
 	else if (flushsnaps)
 		ceph_flush_snaps(ci, NULL);
 	if (wake)
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 357c937..84a61d4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -35,6 +35,7 @@
 static const struct inode_operations ceph_symlink_iops;
 
 static void ceph_inode_work(struct work_struct *work);
+static void ceph_check_caps_work(struct work_struct *work);
 
 /*
  * find or create an inode, given the ceph ino number
@@ -518,6 +519,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	INIT_LIST_HEAD(&ci->i_snap_flush_item);
 
 	INIT_WORK(&ci->i_work, ceph_inode_work);
+	INIT_WORK(&ci->check_caps_work, ceph_check_caps_work);
 	ci->i_work_mask = 0;
 	memset(&ci->i_btime, '\0', sizeof(ci->i_btime));
 
@@ -2012,6 +2014,14 @@ static void ceph_inode_work(struct work_struct *work)
 	iput(inode);
 }
 
+static void ceph_check_caps_work(struct work_struct *work)
+{
+	struct ceph_inode_info *ci = container_of(work, struct ceph_inode_info,
+						  check_caps_work);
+
+	ceph_check_caps(ci, 0, NULL);
+}
+
 /*
  * symlinks
  */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 226f19c..96d0e41 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -421,6 +421,8 @@ struct ceph_inode_info {
 	struct timespec64 i_btime;
 	struct timespec64 i_snap_btime;
 
+	struct work_struct check_caps_work;
+
 	struct work_struct i_work;
 	unsigned long  i_work_mask;
 
@@ -1102,6 +1104,16 @@ extern void ceph_flush_snaps(struct ceph_inode_info *ci,
 extern bool __ceph_should_report_size(struct ceph_inode_info *ci);
 extern void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			    struct ceph_mds_session *session);
+static void inline
+ceph_async_check_caps(struct ceph_inode_info *ci)
+{
+	struct inode *inode = &ci->vfs_inode;
+
+	/* It's okay if queue_work fails */
+	queue_work(ceph_inode_to_client(inode)->inode_wq,
+		   &ceph_inode(inode)->check_caps_work);
+}
+
 extern void ceph_check_delayed_caps(struct ceph_mds_client *mdsc);
 extern void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc);
 extern int  ceph_drop_caps_for_unlink(struct inode *inode);
-- 
1.8.3.1

