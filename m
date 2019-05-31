Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87A730E18
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 14:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfEaM2R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 08:28:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfEaM2R (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 May 2019 08:28:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 808DBC0578FA;
        Fri, 31 May 2019 12:28:16 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC75A17598;
        Fri, 31 May 2019 12:28:10 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com, lhenriques@suse.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/3] ceph: add method that forces client to reconnect using new entity addr
Date:   Fri, 31 May 2019 20:28:01 +0800
Message-Id: <20190531122802.12814-2-zyan@redhat.com>
In-Reply-To: <20190531122802.12814-1-zyan@redhat.com>
References: <20190531122802.12814-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 31 May 2019 12:28:16 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

echo force_reconnect > /sys/kernel/debug/ceph/xxx/control

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/debugfs.c    | 34 +++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 fs/ceph/mds_client.h |  1 +
 fs/ceph/super.h      |  1 +
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index a14d64664878..d65da57406bd 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -210,6 +210,31 @@ CEPH_DEFINE_SHOW_FUNC(mdsc_show)
 CEPH_DEFINE_SHOW_FUNC(caps_show)
 CEPH_DEFINE_SHOW_FUNC(mds_sessions_show)
 
+static ssize_t control_file_write(struct file *file,
+				  const char __user *ubuf,
+				  size_t count, loff_t *ppos)
+{
+	struct ceph_fs_client *fsc = file_inode(file)->i_private;
+	char buf[16];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, ubuf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (!strcmp(buf, "force_reconnect")) {
+		ceph_mdsc_force_reconnect(fsc->mdsc);
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static const struct file_operations control_file_fops = {
+	.write = control_file_write,
+};
 
 /*
  * debugfs
@@ -233,7 +258,6 @@ static int congestion_kb_get(void *data, u64 *val)
 DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
 			congestion_kb_set, "%llu\n");
 
-
 void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 {
 	dout("ceph_fs_debugfs_cleanup\n");
@@ -243,6 +267,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
 	debugfs_remove(fsc->debugfs_mds_sessions);
 	debugfs_remove(fsc->debugfs_caps);
 	debugfs_remove(fsc->debugfs_mdsc);
+	debugfs_remove(fsc->debugfs_control);
 }
 
 int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
@@ -302,6 +327,13 @@ int ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 	if (!fsc->debugfs_caps)
 		goto out;
 
+	fsc->debugfs_control = debugfs_create_file("control",
+						   0200,
+						   fsc->client->debugfs_dir,
+						   fsc,
+						   &control_file_fops);
+	if (!fsc->debugfs_control)
+		goto out;
 	return 0;
 
 out:
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f5c3499fdec6..95ee893205c5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2631,7 +2631,7 @@ static void kick_requests(struct ceph_mds_client *mdsc, int mds)
 		if (req->r_attempts > 0)
 			continue; /* only new requests */
 		if (req->r_session &&
-		    req->r_session->s_mds == mds) {
+		    (mds == -1 || req->r_session->s_mds == mds)) {
 			dout(" kicking tid %llu\n", req->r_tid);
 			list_del_init(&req->r_wait);
 			__do_request(mdsc, req);
@@ -4371,6 +4371,45 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
 	mutex_unlock(&mdsc->mutex);
 }
 
+void ceph_mdsc_force_reconnect(struct ceph_mds_client *mdsc)
+{
+	struct ceph_mds_session *session;
+	int mds;
+	LIST_HEAD(to_wake);
+
+	pr_info("force reconnect\n");
+
+	/* this also reset add mon/osd conntions */
+	ceph_reset_client_addr(mdsc->fsc->client);
+
+	mutex_lock(&mdsc->mutex);
+
+	/* reset mds connections */
+	for (mds = 0; mds < mdsc->max_sessions; mds++) {
+		session = __ceph_lookup_mds_session(mdsc, mds);
+		if (!session)
+			continue;
+
+		__unregister_session(mdsc, session);
+		list_splice_init(&session->s_waiting, &to_wake);
+		mutex_unlock(&mdsc->mutex);
+
+		mutex_lock(&session->s_mutex);
+		cleanup_session_requests(mdsc, session);
+		remove_session_caps(session);
+		mutex_unlock(&session->s_mutex);
+
+		ceph_put_mds_session(session);
+		mutex_lock(&mdsc->mutex);
+	}
+
+	list_splice_init(&mdsc->waiting_for_map, &to_wake);
+	__wake_requests(mdsc, &to_wake);
+	kick_requests(mdsc, -1);
+
+	mutex_unlock(&mdsc->mutex);
+}
+
 static void ceph_mdsc_stop(struct ceph_mds_client *mdsc)
 {
 	dout("stop\n");
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 330769ecb601..125e26895f14 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -457,6 +457,7 @@ extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,
 extern int ceph_mdsc_init(struct ceph_fs_client *fsc);
 extern void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc);
 extern void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc);
+extern void ceph_mdsc_force_reconnect(struct ceph_mds_client *mdsc);
 extern void ceph_mdsc_destroy(struct ceph_fs_client *fsc);
 
 extern void ceph_mdsc_sync(struct ceph_mds_client *mdsc);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 9c82d213a5ab..9ccb6e031988 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -118,6 +118,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
 	struct dentry *debugfs_mds_sessions;
+	struct dentry *debugfs_control;
 #endif
 
 #ifdef CONFIG_CEPH_FSCACHE
-- 
2.17.2

