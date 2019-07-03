Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E64E5E432
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfGCMp3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:45:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMp2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:45:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC39F87629
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 12:45:28 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F9918F6D2;
        Wed,  3 Jul 2019 12:45:22 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 9/9] ceph: auto reconnect after blacklisted
Date:   Wed,  3 Jul 2019 20:44:42 +0800
Message-Id: <20190703124442.6614-10-zyan@redhat.com>
In-Reply-To: <20190703124442.6614-1-zyan@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 03 Jul 2019 12:45:28 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Make client use osd reply and session message to infer if itself is
blacklisted. Client reconnect to cluster using new entity addr if it
is blacklisted.

Auto reconnect is controlled by recover_session=<clean|no> mount option.
Clean mode is enabled by default. In this mode, client drops dirty date
and dirty metadata, All writable file handles are invalidated. Read-only
file handles continue to work and caches are dropped if necessary.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/addr.c       | 15 +++++++++++----
 fs/ceph/file.c       |  8 +++++++-
 fs/ceph/mds_client.c | 37 +++++++++++++++++++++++++++++++++++--
 fs/ceph/super.c      | 29 +++++++++++++++++++++++++++++
 fs/ceph/super.h      |  8 +++++++-
 5 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 9f357c5ce84d..e3b77aa6b5f1 100644
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
+			fsc->blacklisted = 1;
 		goto out;
 	}
 	if (err < PAGE_SIZE)
@@ -266,6 +267,8 @@ static void finish_read(struct ceph_osd_request *req)
 	int i;
 
 	dout("finish_read %p req %p rc %d bytes %d\n", inode, req, rc, bytes);
+	if (rc == -EBLACKLISTED)
+		ceph_inode_to_client(inode)->blacklisted = 1;
 
 	/* unlock all pages, zeroing any data we didn't read */
 	osd_data = osd_req_op_extent_osd_data(req, 0);
@@ -641,6 +644,8 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 			end_page_writeback(page);
 			return err;
 		}
+		if (err == -EBLACKLISTED)
+			fsc->blacklisted = 1;
 		dout("writepage setting page/mapping error %d %p\n",
 		     err, page);
 		SetPageError(page);
@@ -721,6 +726,8 @@ static void writepages_finish(struct ceph_osd_request *req)
 	if (rc < 0) {
 		mapping_set_error(mapping, rc);
 		ceph_set_error_write(ci);
+		if (rc == -EBLACKLISTED)
+			fsc->blacklisted = 1;
 	} else {
 		ceph_clear_error_write(ci);
 	}
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 77d3ef903cce..fcfae03bf9cf 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -698,7 +698,13 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			ceph_release_page_vector(pages, num_pages);
 		}
 
-		if (ret <= 0 || off >= i_size || !more)
+		if (ret < 0) {
+			if (ret == -EBLACKLISTED)
+				fsc->blacklisted = 1;
+			break;
+		}
+
+		if (off >= i_size || !more)
 			break;
 	}
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 59172e63a61f..ba8909691ef8 100644
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
+			mdsc->fsc->blacklisted = 1;
 		wake = 2; /* for good measure */
 		break;
 
@@ -4015,7 +4023,30 @@ static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
 	mutex_unlock(&mdsc->mutex);
 }
 
+void maybe_recover_session(struct ceph_mds_client *mdsc)
+{
+	struct ceph_fs_client *fsc = mdsc->fsc;
+	char option[32] = "force_reconnect";
+
+	if (!ceph_test_mount_opt(fsc, CLEANRECOVER) &&
+	    !ceph_test_mount_opt(fsc, BRUTERECOVER))
+		return;
+
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
+		return;
 
+	if (!READ_ONCE(fsc->blacklisted))
+		return;
+
+	if (fsc->last_force_reconnect &&
+	    time_before(jiffies, fsc->last_force_reconnect + HZ * 60 * 30))
+		return;
+
+	pr_info("auto reconnect after blacklisted\n");
+	fsc->last_force_reconnect = jiffies;
+	fsc->sb->s_op->remount_fs(fsc->sb, NULL, option);
+	fsc->blacklisted = 0;
+}
 
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
@@ -4089,6 +4120,8 @@ static void delayed_work(struct work_struct *work)
 
 	ceph_trim_snapid_map(mdsc);
 
+	maybe_recover_session(mdsc);
+
 	schedule_delayed(mdsc);
 }
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index a00597602810..02c96dcfbf83 100644
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
@@ -185,6 +186,7 @@ static match_table_t fsopt_tokens = {
 	/* int args above */
 	{Opt_snapdirname, "snapdirname=%s"},
 	{Opt_mds_namespace, "mds_namespace=%s"},
+	{Opt_recover_session, "recover_session=%s"},
 	{Opt_fscache_uniq, "fsc=%s"},
 	/* string args above */
 	{Opt_dirstat, "dirstat"},
@@ -256,6 +258,25 @@ static int parse_fsopt_token(char *c, void *private)
 		if (!fsopt->mds_namespace)
 			return -ENOMEM;
 		break;
+	case Opt_recover_session:
+		if (!strncmp(argstr[0].from, "no",
+			     argstr[0].to-argstr[0].from)) {
+			fsopt->flags &= ~(CEPH_MOUNT_OPT_CLEANRECOVER |
+					  CEPH_MOUNT_OPT_BRUTERECOVER);
+		} else if (!strncmp(argstr[0].from, "clean",
+                           argstr[0].to-argstr[0].from)) {
+			fsopt->flags &= ~CEPH_MOUNT_OPT_BRUTERECOVER;
+			fsopt->flags |= CEPH_MOUNT_OPT_CLEANRECOVER;
+		/* not implemented yet
+		} else if (!strncmp(argstr[0].from, "brute",
+                           argstr[0].to-argstr[0].from)) {
+			fsopt->flags &= ~CEPH_MOUNT_OPT_CLEANRECOVER;
+			fsopt->flags |= CEPH_MOUNT_OPT_BRUTERECOVER;
+		*/
+		} else {
+			return -EINVAL;
+		}
+		break;
 	case Opt_fscache_uniq:
 		kfree(fsopt->fscache_uniq);
 		fsopt->fscache_uniq = kstrndup(argstr[0].from,
@@ -581,6 +602,14 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
 
 	if (fsopt->mds_namespace)
 		seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
+
+	if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
+		seq_show_option(m, "recover_session", "clean");
+	else if (fsopt->flags & CEPH_MOUNT_OPT_BRUTERECOVER)
+		seq_show_option(m, "recover_session", "brute");
+	else
+		seq_show_option(m, "recover_session", "no");
+
 	if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
 		seq_printf(m, ",wsize=%d", fsopt->wsize);
 	if (fsopt->rsize != CEPH_MAX_READ_SIZE)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 54039f7fb510..b2b21f32cb33 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -32,6 +32,8 @@
 #define CEPH_BLOCK         (1 << CEPH_BLOCK_SHIFT)
 
 #define CEPH_MOUNT_OPT_FORCERECONNCT   (1<<0) /* force reconnect, remount only */
+#define CEPH_MOUNT_OPT_CLEANRECOVER    (1<<1)
+#define CEPH_MOUNT_OPT_BRUTERECOVER    (1<<2)
 #define CEPH_MOUNT_OPT_DIRSTAT         (1<<4) /* `cat dirname` for stats */
 #define CEPH_MOUNT_OPT_RBYTES          (1<<5) /* dir st_bytes = rbytes */
 #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
@@ -45,7 +47,8 @@
 
 #define CEPH_MOUNT_OPT_DEFAULT			\
 	(CEPH_MOUNT_OPT_DCACHE |		\
-	 CEPH_MOUNT_OPT_NOCOPYFROM)
+	 CEPH_MOUNT_OPT_NOCOPYFROM |		\
+	 CEPH_MOUNT_OPT_CLEANRECOVER)
 
 #define ceph_set_mount_opt(fsc, opt) \
 	(fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt;
@@ -103,6 +106,9 @@ struct ceph_fs_client {
 
 	unsigned long mount_state;
 
+	unsigned long last_force_reconnect;
+	int blacklisted;
+
 	u32 filp_gen;
 	loff_t max_file_size;
 
-- 
2.20.1

