Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AF174E08
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 14:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404579AbfGYMSG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 08:18:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387473AbfGYMSG (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 08:18:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54EE37DCC4
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:18:05 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F31F35B6A5;
        Thu, 25 Jul 2019 12:17:37 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v3 9/9] ceph: auto reconnect after blacklisted
Date:   Thu, 25 Jul 2019 20:16:47 +0800
Message-Id: <20190725121647.17093-10-zyan@redhat.com>
In-Reply-To: <20190725121647.17093-1-zyan@redhat.com>
References: <20190725121647.17093-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 25 Jul 2019 12:18:05 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Make client use osd reply and session message to infer if itself is
blacklisted. Client reconnect to cluster using new entity addr if it
is blacklisted. Auto reconnect is limited to once every 30 minutes.

Auto reconnect is disabled by default. It can be enabled/disabled by
recover_session=<no|clean> mount option. In 'clean' mode, client drops
any dirty data/metadata, invalidates page caches and invalidates all
writable file handles. After reconnect, file locks become stale because
MDS loses track of them. If an inode contains any stale file locks,
read/write on the indoe are not allowed until applications release all
stale file locks.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 Documentation/filesystems/ceph.txt | 14 ++++++++++++
 fs/ceph/addr.c                     | 22 ++++++++++++++-----
 fs/ceph/file.c                     |  8 ++++++-
 fs/ceph/mds_client.c               | 34 ++++++++++++++++++++++++++++--
 fs/ceph/super.c                    | 19 +++++++++++++++++
 fs/ceph/super.h                    |  4 ++++
 6 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/ceph.txt b/Documentation/filesystems/ceph.txt
index d2c6a5ccf0f5..b19b6a03f91c 100644
--- a/Documentation/filesystems/ceph.txt
+++ b/Documentation/filesystems/ceph.txt
@@ -158,6 +158,20 @@ Mount Options
         copies.  Currently, it's only used in copy_file_range, which will revert
         to the default VFS implementation if this option is used.
 
+  recover_session=<no|clean>
+	Set auto reconnect mode in the case where the client is blacklisted. The
+	available modes are "no" and "clean". The default is "no".
+
+	* no: never attempt to reconnect when client detects that it has been
+	blacklisted. Operations will generally fail after being blacklisted.
+
+	* clean: client reconnects to the ceph cluster automatically when it
+	detects that it has been blacklisted. During reconnect, client drops
+	dirty data/metadata, invalidates page caches and writable file handles.
+	After reconnect, file locks become stale because the MDS loses track
+	of them. If an inode contains any stale file locks, read/write on the
+	inode is not allowed until applications release all stale file locks.
+
 More Information
 ================
 
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c71c026770e1..00720201c032 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -189,8 +189,7 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 {
 	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct ceph_osd_client *osdc =
-		&ceph_inode_to_client(inode)->client->osdc;
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	int err = 0;
 	u64 off = page_offset(page);
 	u64 len = PAGE_SIZE;
@@ -219,8 +218,8 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 
 	dout("readpage inode %p file %p page %p index %lu\n",
 	     inode, filp, page, page->index);
-	err = ceph_osdc_readpages(osdc, ceph_vino(inode), &ci->i_layout,
-				  off, &len,
+	err = ceph_osdc_readpages(&fsc->client->osdc, ceph_vino(inode),
+				  &ci->i_layout, off, &len,
 				  ci->i_truncate_seq, ci->i_truncate_size,
 				  &page, 1, 0);
 	if (err == -ENOENT)
@@ -228,6 +227,8 @@ static int ceph_do_readpage(struct file *filp, struct page *page)
 	if (err < 0) {
 		SetPageError(page);
 		ceph_fscache_readpage_cancel(inode, page);
+		if (err == -EBLACKLISTED)
+			fsc->blacklisted = true;
 		goto out;
 	}
 	if (err < PAGE_SIZE)
@@ -266,6 +267,8 @@ static void finish_read(struct ceph_osd_request *req)
 	int i;
 
 	dout("finish_read %p req %p rc %d bytes %d\n", inode, req, rc, bytes);
+	if (rc == -EBLACKLISTED)
+		ceph_inode_to_client(inode)->blacklisted = true;
 
 	/* unlock all pages, zeroing any data we didn't read */
 	osd_data = osd_req_op_extent_osd_data(req, 0);
@@ -641,6 +644,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 			end_page_writeback(page);
 			return err;
 		}
+		if (err == -EBLACKLISTED)
+			fsc->blacklisted = true;
 		dout("writepage setting page/mapping error %d %p\n",
 		     err, page);
 		SetPageError(page);
@@ -721,6 +726,8 @@ static void writepages_finish(struct ceph_osd_request *req)
 	if (rc < 0) {
 		mapping_set_error(mapping, rc);
 		ceph_set_error_write(ci);
+		if (rc == -EBLACKLISTED)
+			fsc->blacklisted = true;
 	} else {
 		ceph_clear_error_write(ci);
 	}
@@ -1948,12 +1955,17 @@ static int __ceph_pool_perm_get(struct ceph_inode_info *ci,
 
 	if (err >= 0 || err == -ENOENT)
 		have |= POOL_READ;
-	else if (err != -EPERM)
+	else if (err != -EPERM) {
+		if (err == -EBLACKLISTED)
+			fsc->blacklisted = true;
 		goto out_unlock;
+	}
 
 	if (err2 == 0 || err2 == -EEXIST)
 		have |= POOL_WRITE;
 	else if (err2 != -EPERM) {
+		if (err2 == -EBLACKLISTED)
+			fsc->blacklisted = true;
 		err = err2;
 		goto out_unlock;
 	}
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c6ae8c719cba..3c0b5247818f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -698,7 +698,13 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			ceph_release_page_vector(pages, num_pages);
 		}
 
-		if (ret <= 0 || off >= i_size || !more)
+		if (ret < 0) {
+			if (ret == -EBLACKLISTED)
+				fsc->blacklisted = true;
+			break;
+		}
+
+		if (off >= i_size || !more)
 			break;
 	}
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c49009965369..6b17a4395e70 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3032,18 +3032,23 @@ static void handle_forward(struct ceph_mds_client *mdsc,
 	pr_err("mdsc_handle_forward decode error err=%d\n", err);
 }
 
-static int __decode_and_drop_session_metadata(void **p, void *end)
+static int __decode_session_metadata(void **p, void *end,
+				     bool *blacklisted)
 {
 	/* map<string,string> */
 	u32 n;
+	bool err_str;
 	ceph_decode_32_safe(p, end, n, bad);
 	while (n-- > 0) {
 		u32 len;
 		ceph_decode_32_safe(p, end, len, bad);
 		ceph_decode_need(p, end, len, bad);
+		err_str = !strncmp(*p, "error_string", len);
 		*p += len;
 		ceph_decode_32_safe(p, end, len, bad);
 		ceph_decode_need(p, end, len, bad);
+		if (err_str && strnstr(*p, "blacklisted", len))
+			*blacklisted = true;
 		*p += len;
 	}
 	return 0;
@@ -3067,6 +3072,7 @@ static void handle_session(struct ceph_mds_session *session,
 	u64 seq;
 	unsigned long features = 0;
 	int wake = 0;
+	bool blacklisted = false;
 
 	/* decode */
 	ceph_decode_need(&p, end, sizeof(*h), bad);
@@ -3079,7 +3085,7 @@ static void handle_session(struct ceph_mds_session *session,
 	if (msg_version >= 3) {
 		u32 len;
 		/* version >= 2, metadata */
-		if (__decode_and_drop_session_metadata(&p, end) < 0)
+		if (__decode_session_metadata(&p, end, &blacklisted) < 0)
 			goto bad;
 		/* version >= 3, feature bits */
 		ceph_decode_32_safe(&p, end, len, bad);
@@ -3166,6 +3172,8 @@ static void handle_session(struct ceph_mds_session *session,
 		session->s_state = CEPH_MDS_SESSION_REJECTED;
 		cleanup_session_requests(mdsc, session);
 		remove_session_caps(session);
+		if (blacklisted)
+			mdsc->fsc->blacklisted = true;
 		wake = 2; /* for good measure */
 		break;
 
@@ -4015,7 +4023,27 @@ static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
 	mutex_unlock(&mdsc->mutex);
 }
 
+static void maybe_recover_session(struct ceph_mds_client *mdsc)
+{
+	struct ceph_fs_client *fsc = mdsc->fsc;
+
+	if (!ceph_test_mount_opt(fsc, CLEANRECOVER))
+		return;
+
+	if (READ_ONCE(fsc->mount_state) != CEPH_MOUNT_MOUNTED)
+		return;
 
+	if (!READ_ONCE(fsc->blacklisted))
+		return;
+
+	if (fsc->last_auto_reconnect &&
+	    time_before(jiffies, fsc->last_auto_reconnect + HZ * 60 * 30))
+		return;
+
+	pr_info("auto reconnect after blacklisted\n");
+	fsc->last_auto_reconnect = jiffies;
+	ceph_force_reconnect(fsc->sb);
+}
 
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
@@ -4089,6 +4117,8 @@ static void delayed_work(struct work_struct *work)
 
 	ceph_trim_snapid_map(mdsc);
 
+	maybe_recover_session(mdsc);
+
 	schedule_delayed(mdsc);
 }
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 10bc8f4ce354..127825244bcc 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -143,6 +143,7 @@ enum {
 	Opt_snapdirname,
 	Opt_mds_namespace,
 	Opt_fscache_uniq,
+	Opt_recover_session,
 	Opt_last_string,
 	/* string args above */
 	Opt_dirstat,
@@ -184,6 +185,7 @@ static match_table_t fsopt_tokens = {
 	/* int args above */
 	{Opt_snapdirname, "snapdirname=%s"},
 	{Opt_mds_namespace, "mds_namespace=%s"},
+	{Opt_recover_session, "recover_session=%s"},
 	{Opt_fscache_uniq, "fsc=%s"},
 	/* string args above */
 	{Opt_dirstat, "dirstat"},
@@ -254,6 +256,17 @@ static int parse_fsopt_token(char *c, void *private)
 		if (!fsopt->mds_namespace)
 			return -ENOMEM;
 		break;
+	case Opt_recover_session:
+		if (!strncmp(argstr[0].from, "no",
+			     argstr[0].to - argstr[0].from)) {
+			fsopt->flags &= ~CEPH_MOUNT_OPT_CLEANRECOVER;
+		} else if (!strncmp(argstr[0].from, "clean",
+				    argstr[0].to - argstr[0].from)) {
+			fsopt->flags |= CEPH_MOUNT_OPT_CLEANRECOVER;
+		} else {
+			return -EINVAL;
+		}
+		break;
 	case Opt_fscache_uniq:
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = kstrndup(argstr[0].from,
@@ -576,6 +589,10 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 
 	if (fsopt->mds_namespace)
 		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
+
+	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
+		seq_show_option(m, "recover_session", "clean");
+
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%d", fsopt->wsize);
 	if (fsopt->rsize != CEPH_MAX_READ_SIZE)
@@ -1171,6 +1188,8 @@ int ceph_force_reconnect(struct super_block *sb)
 	ceph_reset_client_addr(fsc->client);
 
 	ceph_osdc_clear_abort_err(&fsc->client->osdc);
+
+	fsc->blacklisted = false;
 	fsc->mount_state = CEPH_MOUNT_MOUNTED;
 
 	if (sb->s_root) {
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f64a5271cb1a..c29dfd065283 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -31,6 +31,7 @@
 #define CEPH_BLOCK_SHIFT   22  /* 4 MB */
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
+#define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1) /* auto reonnect (clean mode) after blacklisted */
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
 #define CEPH_MOUNT_OPT_RBYTES          (1<<5) /* dir st_bytes = rbytes */
 #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
@@ -102,6 +103,9 @@ struct ceph_fs_client {
 
 	unsigned long mount_state;
 
+	unsigned long last_auto_reconnect;
+	bool blacklisted;
+
 	u32 filp_gen;
 	loff_t max_file_size;
 
-- 
2.20.1

