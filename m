Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 048DA277C1
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 10:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbfEWIN5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 04:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728109AbfEWIN4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 May 2019 04:13:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 33ED480F91
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 08:13:56 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-163.pek2.redhat.com [10.72.12.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 207A960C44;
        Thu, 23 May 2019 08:13:53 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 3/8] ceph: avoid iput_final() while holding mutex or in dispatch thread
Date:   Thu, 23 May 2019 16:13:40 +0800
Message-Id: <20190523081345.20410-3-zyan@redhat.com>
In-Reply-To: <20190523081345.20410-1-zyan@redhat.com>
References: <20190523081345.20410-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 23 May 2019 08:13:56 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

iput_final() may wait for reahahead pages. The wait can cause deadlock.
For example:

Workqueue: ceph-msgr ceph_con_workfn [libceph]
  Call Trace:
   schedule+0x36/0x80
   io_schedule+0x16/0x40
   __lock_page+0x101/0x140
   truncate_inode_pages_range+0x556/0x9f0
   truncate_inode_pages_final+0x4d/0x60
   evict+0x182/0x1a0
   iput+0x1d2/0x220
   iterate_session_caps+0x82/0x230 [ceph]
   dispatch+0x678/0xa80 [ceph]
   ceph_con_workfn+0x95b/0x1560 [libceph]
   process_one_work+0x14d/0x410
   worker_thread+0x4b/0x460
   kthread+0x105/0x140
   ret_from_fork+0x22/0x40

Workqueue: ceph-msgr ceph_con_workfn [libceph]
  Call Trace:
   __schedule+0x3d6/0x8b0
   schedule+0x36/0x80
   schedule_preempt_disabled+0xe/0x10
   mutex_lock+0x2f/0x40
   ceph_check_caps+0x505/0xa80 [ceph]
   ceph_put_wrbuffer_cap_refs+0x1e5/0x2c0 [ceph]
   writepages_finish+0x2d3/0x410 [ceph]
   __complete_request+0x26/0x60 [libceph]
   handle_reply+0x6c8/0xa10 [libceph]
   dispatch+0x29a/0xbb0 [libceph]
   ceph_con_workfn+0x95b/0x1560 [libceph]
   process_one_work+0x14d/0x410
   worker_thread+0x4b/0x460
   kthread+0x105/0x140
   ret_from_fork+0x22/0x40

In above example, truncate_inode_pages_range() waits for readahead pages
while holding s_mutex. ceph_check_caps() waits for s_mutex and blocks
OSD dispatch thread. Later OSD replies (for readahead) can't be handled.

ceph_check_caps() also may lock snap_rwsem for read. So similar deadlock
can happen if iput_final() is called while holding snap_rwsem.

In general, it's not good to call iput_final() inside MDS/OSD threads or
while holding any mutex.

The fix is introducing ceph_async_iput(), which calls iput_final() in
workqueue.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c       | 12 ++++++++----
 fs/ceph/inode.c      | 31 +++++++++++++++++++++++++++----
 fs/ceph/mds_client.c | 28 ++++++++++++++++++----------
 fs/ceph/quota.c      |  9 ++++++---
 fs/ceph/snap.c       | 16 +++++++++++-----
 fs/ceph/super.h      |  2 +-
 6 files changed, 71 insertions(+), 27 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 079d0df9650c..0176241eaea7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2992,8 +2992,10 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 	}
 	if (complete_capsnap)
 		wake_up_all(&ci->i_cap_wq);
-	while (put-- > 0)
-		iput(inode);
+	while (put-- > 0) {
+		/* avoid calling iput_final() in osd dispatch threads */
+		ceph_async_iput(inode);
+	}
 }
 
 /*
@@ -3964,8 +3966,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 done:
 	mutex_unlock(&session->s_mutex);
 done_unlocked:
-	iput(inode);
 	ceph_put_string(extra_info.pool_ns);
+	/* avoid calling iput_final() in mds dispatch threads */
+	ceph_async_iput(inode);
 	return;
 
 flush_cap_releases:
@@ -4011,7 +4014,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		if (inode) {
 			dout("check_delayed_caps on %p\n", inode);
 			ceph_check_caps(ci, flags, NULL);
-			iput(inode);
+			/* avoid calling iput_final() in tick thread */
+			ceph_async_iput(inode);
 		}
 	}
 	spin_unlock(&mdsc->cap_delay_lock);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d9ff349821f0..8cfece240ffe 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1480,7 +1480,8 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
 			pr_err("fill_inode badness on %p got %d\n", in, rc);
 			err = rc;
 		}
-		iput(in);
+		/* avoid calling iput_final() in mds dispatch threads */
+		ceph_async_iput(in);
 	}
 
 	return err;
@@ -1678,8 +1679,11 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 				 &req->r_caps_reservation);
 		if (ret < 0) {
 			pr_err("fill_inode badness on %p\n", in);
-			if (d_really_is_negative(dn))
-				iput(in);
+			if (d_really_is_negative(dn)) {
+				/* avoid calling iput_final() in mds
+				 * dispatch threads */
+				ceph_async_iput(in);
+			}
 			d_drop(dn);
 			err = ret;
 			goto next_item;
@@ -1689,7 +1693,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
 			if (ceph_security_xattr_deadlock(in)) {
 				dout(" skip splicing dn %p to inode %p"
 				     " (security xattr deadlock)\n", dn, in);
-				iput(in);
+				ceph_async_iput(in);
 				skipped++;
 				goto next_item;
 			}
@@ -1740,6 +1744,25 @@ bool ceph_inode_set_size(struct inode *inode, loff_t size)
 	return ret;
 }
 
+/*
+ * Put reference to inode, but avoid calling iput_final() in current thread.
+ * iput_final() may wait for reahahead pages. The wait can cause deadlock in
+ * some contexts.
+ */
+void ceph_async_iput(struct inode *inode)
+{
+	if (!inode)
+		return;
+	for (;;) {
+		if (atomic_add_unless(&inode->i_count, -1, 1))
+			break;
+		if (queue_work(ceph_inode_to_client(inode)->inode_wq,
+			       &ceph_inode(inode)->i_work))
+			break;
+		/* queue work failed, i_count must be at least 2 */
+	}
+}
+
 /*
  * Write back inode data in a worker thread.  (This can't be done
  * in the message handler context.)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e979d1d543e4..60e8ddbdfdc5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -700,11 +700,12 @@ void ceph_mdsc_release_request(struct kref *kref)
 		ceph_msg_put(req->r_reply);
 	if (req->r_inode) {
 		ceph_put_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
-		iput(req->r_inode);
+		/* avoid calling iput_final() in mds dispatch threads */
+		ceph_async_iput(req->r_inode);
 	}
 	if (req->r_parent)
 		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
-	iput(req->r_target_inode);
+	ceph_async_iput(req->r_target_inode);
 	if (req->r_dentry)
 		dput(req->r_dentry);
 	if (req->r_old_dentry)
@@ -718,7 +719,7 @@ void ceph_mdsc_release_request(struct kref *kref)
 		 */
 		ceph_put_cap_refs(ceph_inode(req->r_old_dentry_dir),
 				  CEPH_CAP_PIN);
-		iput(req->r_old_dentry_dir);
+		ceph_async_iput(req->r_old_dentry_dir);
 	}
 	kfree(req->r_path1);
 	kfree(req->r_path2);
@@ -828,7 +829,8 @@ static void __unregister_request(struct ceph_mds_client *mdsc,
 	}
 
 	if (req->r_unsafe_dir) {
-		iput(req->r_unsafe_dir);
+		/* avoid calling iput_final() in mds dispatch threads */
+		ceph_async_iput(req->r_unsafe_dir);
 		req->r_unsafe_dir = NULL;
 	}
 
@@ -993,7 +995,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 		cap = rb_entry(rb_first(&ci->i_caps), struct ceph_cap, ci_node);
 	if (!cap) {
 		spin_unlock(&ci->i_ceph_lock);
-		iput(inode);
+		ceph_async_iput(inode);
 		goto random;
 	}
 	mds = cap->session->s_mds;
@@ -1002,7 +1004,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 	     cap == ci->i_auth_cap ? "auth " : "", cap);
 	spin_unlock(&ci->i_ceph_lock);
 out:
-	iput(inode);
+	/* avoid calling iput_final() while holding mdsc->mutex or
+	 * in mds dispatch threads */
+	ceph_async_iput(inode);
 	return mds;
 
 random:
@@ -1312,7 +1316,9 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 		spin_unlock(&session->s_cap_lock);
 
 		if (last_inode) {
-			iput(last_inode);
+			/* avoid calling iput_final() while holding
+			 * s_mutex or in mds dispatch threads */
+			ceph_async_iput(last_inode);
 			last_inode = NULL;
 		}
 		if (old_cap) {
@@ -1345,7 +1351,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	session->s_cap_iterator = NULL;
 	spin_unlock(&session->s_cap_lock);
 
-	iput(last_inode);
+	ceph_async_iput(last_inode);
 	if (old_cap)
 		ceph_put_cap(session->s_mdsc, old_cap);
 
@@ -1481,7 +1487,8 @@ static void remove_session_caps(struct ceph_mds_session *session)
 			spin_unlock(&session->s_cap_lock);
 
 			inode = ceph_find_inode(sb, vino);
-			iput(inode);
+			 /* avoid calling iput_final() while holding s_mutex */
+			ceph_async_iput(inode);
 
 			spin_lock(&session->s_cap_lock);
 		}
@@ -3923,8 +3930,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	ceph_con_send(&session->s_con, msg);
 
 out:
-	iput(inode);
 	mutex_unlock(&session->s_mutex);
+	/* avoid calling iput_final() in mds dispatch threads */
+	ceph_async_iput(inode);
 	return;
 
 bad:
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index c4522212872c..d629fc857450 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -74,7 +74,8 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 		            le64_to_cpu(h->max_files));
 	spin_unlock(&ci->i_ceph_lock);
 
-	iput(inode);
+	/* avoid calling iput_final() in dispatch thread */
+	ceph_async_iput(inode);
 }
 
 static struct ceph_quotarealm_inode *
@@ -235,7 +236,8 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 
 		ci = ceph_inode(in);
 		has_quota = __ceph_has_any_quota(ci);
-		iput(in);
+		/* avoid calling iput_final() while holding mdsc->snap_rwsem */
+		ceph_async_iput(in);
 
 		next = realm->parent;
 		if (has_quota || !next)
@@ -372,7 +374,8 @@ static bool check_quota_exceeded(struct inode *inode, enum quota_check_op op,
 			pr_warn("Invalid quota check op (%d)\n", op);
 			exceeded = true; /* Just break the loop */
 		}
-		iput(in);
+		/* avoid calling iput_final() while holding mdsc->snap_rwsem */
+		ceph_async_iput(in);
 
 		next = realm->parent;
 		if (exceeded || !next)
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b26e12cd8ec3..72c6c022f02b 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -648,13 +648,15 @@ static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
 		if (!inode)
 			continue;
 		spin_unlock(&realm->inodes_with_caps_lock);
-		iput(lastinode);
+		/* avoid calling iput_final() while holding
+		 * mdsc->snap_rwsem or in mds dispatch threads */
+		ceph_async_iput(lastinode);
 		lastinode = inode;
 		ceph_queue_cap_snap(ci);
 		spin_lock(&realm->inodes_with_caps_lock);
 	}
 	spin_unlock(&realm->inodes_with_caps_lock);
-	iput(lastinode);
+	ceph_async_iput(lastinode);
 
 	dout("queue_realm_cap_snaps %p %llx done\n", realm, realm->ino);
 }
@@ -806,7 +808,9 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
 		ihold(inode);
 		spin_unlock(&mdsc->snap_flush_lock);
 		ceph_flush_snaps(ci, &session);
-		iput(inode);
+		/* avoid calling iput_final() while holding
+		 * session->s_mutex or in mds dispatch threads */
+		ceph_async_iput(inode);
 		spin_lock(&mdsc->snap_flush_lock);
 	}
 	spin_unlock(&mdsc->snap_flush_lock);
@@ -950,12 +954,14 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 			ceph_get_snap_realm(mdsc, realm);
 			ceph_put_snap_realm(mdsc, oldrealm);
 
-			iput(inode);
+			/* avoid calling iput_final() while holding
+			 * mdsc->snap_rwsem or mds in dispatch threads */
+			ceph_async_iput(inode);
 			continue;
 
 skip_inode:
 			spin_unlock(&ci->i_ceph_lock);
-			iput(inode);
+			ceph_async_iput(inode);
 		}
 
 		/* we may have taken some of the old realm's children. */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 234610ce4155..11aeb540b0cf 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -904,9 +904,9 @@ extern int ceph_inode_holds_cap(struct inode *inode, int mask);
 extern bool ceph_inode_set_size(struct inode *inode, loff_t size);
 extern void __ceph_do_pending_vmtruncate(struct inode *inode);
 extern void ceph_queue_vmtruncate(struct inode *inode);
-
 extern void ceph_queue_invalidate(struct inode *inode);
 extern void ceph_queue_writeback(struct inode *inode);
+extern void ceph_async_iput(struct inode *inode);
 
 extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 			     int mask, bool force);
-- 
2.17.2

