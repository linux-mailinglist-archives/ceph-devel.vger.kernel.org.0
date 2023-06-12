Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26B272C379
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jun 2023 13:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjFLLwW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 07:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbjFLLwA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 07:52:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F72107
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 04:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686570389;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dk/5jdqprOhclGBOGlBCUFVwzHpOKrSJGYH7w3jzL48=;
        b=eCiFQ1ftkvY+iJOWPg0irPea+LDqKFO4clJT9LvuT1nx+EJNAROk3ShPAc49g+M6xwxgFt
        9yBuzyr24//y17Yt/VM7bHflgClH1asKFtL8gixwmROW2Mf21FhI0igS55LVjqUQZYfoIw
        /oYmc7xrrfNgAZrWKh3z39SMltnzCjI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-u4-BTf_pP5uib67L7ESGYA-1; Mon, 12 Jun 2023 07:46:28 -0400
X-MC-Unique: u4-BTf_pP5uib67L7ESGYA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A81578028B1;
        Mon, 12 Jun 2023 11:46:27 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0ADF1121314;
        Mon, 12 Jun 2023 11:46:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, khiremat@redhat.com,
        mchangir@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/6] ceph: pass the mdsc to several helpers
Date:   Mon, 12 Jun 2023 19:43:55 +0800
Message-Id: <20230612114359.220895-3-xiubli@redhat.com>
In-Reply-To: <20230612114359.220895-1-xiubli@redhat.com>
References: <20230612114359.220895-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We will use the 'mdsc' to get the global_id in the following commits.

URL: https://tracker.ceph.com/issues/61590
Cc: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c              | 15 +++++++++------
 fs/ceph/debugfs.c           |  4 ++--
 fs/ceph/dir.c               |  2 +-
 fs/ceph/file.c              |  2 +-
 fs/ceph/mds_client.c        | 37 +++++++++++++++++++++----------------
 fs/ceph/mds_client.h        |  3 ++-
 fs/ceph/mdsmap.c            |  3 ++-
 fs/ceph/snap.c              |  8 +++++---
 fs/ceph/super.h             |  3 ++-
 include/linux/ceph/mdsmap.h |  5 ++++-
 10 files changed, 49 insertions(+), 33 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5498bc36c1e7..c6a65a961e2e 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1178,7 +1178,8 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
 	}
 }
 
-void ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
+void ceph_remove_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
+		     bool queue_release)
 {
 	struct ceph_inode_info *ci = cap->ci;
 	struct ceph_fs_client *fsc;
@@ -1341,6 +1342,8 @@ static void encode_cap_msg(struct ceph_msg *msg, struct cap_msg_args *arg)
  */
 void __ceph_remove_caps(struct ceph_inode_info *ci)
 {
+	struct inode *inode = &ci->netfs.inode;
+	struct ceph_mds_client *mdsc = ceph_inode_to_client(inode)->mdsc;
 	struct rb_node *p;
 
 	/* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
@@ -1350,7 +1353,7 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
 	while (p) {
 		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
 		p = rb_next(p);
-		ceph_remove_cap(cap, true);
+		ceph_remove_cap(mdsc, cap, true);
 	}
 	spin_unlock(&ci->i_ceph_lock);
 }
@@ -3991,7 +3994,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		goto out_unlock;
 
 	if (target < 0) {
-		ceph_remove_cap(cap, false);
+		ceph_remove_cap(mdsc, cap, false);
 		goto out_unlock;
 	}
 
@@ -4026,7 +4029,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 				change_auth_cap_ses(ci, tcap->session);
 			}
 		}
-		ceph_remove_cap(cap, false);
+		ceph_remove_cap(mdsc, cap, false);
 		goto out_unlock;
 	} else if (tsession) {
 		/* add placeholder for the export tagert */
@@ -4043,7 +4046,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 			spin_unlock(&mdsc->cap_dirty_lock);
 		}
 
-		ceph_remove_cap(cap, false);
+		ceph_remove_cap(mdsc, cap, false);
 		goto out_unlock;
 	}
 
@@ -4156,7 +4159,7 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 					ocap->mseq, mds, le32_to_cpu(ph->seq),
 					le32_to_cpu(ph->mseq));
 		}
-		ceph_remove_cap(ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
+		ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
 	}
 
 	*old_issued = issued;
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 3904333fa6c3..2f1e7498cd74 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -81,7 +81,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 		if (req->r_inode) {
 			seq_printf(s, " #%llx", ceph_ino(req->r_inode));
 		} else if (req->r_dentry) {
-			path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
+			path = ceph_mdsc_build_path(mdsc, req->r_dentry, &pathlen,
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path = NULL;
@@ -100,7 +100,7 @@ static int mdsc_show(struct seq_file *s, void *p)
 		}
 
 		if (req->r_old_dentry) {
-			path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
+			path = ceph_mdsc_build_path(mdsc, req->r_old_dentry, &pathlen,
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path = NULL;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 1b46f2b998c3..5fbcd0d5e5ec 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1219,7 +1219,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
 	if (result) {
 		int pathlen = 0;
 		u64 base = 0;
-		char *path = ceph_mdsc_build_path(dentry, &pathlen,
+		char *path = ceph_mdsc_build_path(mdsc, dentry, &pathlen,
 						  &base, 0);
 
 		/* mark error on parent + clear complete */
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e878a462c7c3..04bc4cc8ad9b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -574,7 +574,7 @@ static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
 	if (result) {
 		int pathlen = 0;
 		u64 base = 0;
-		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
+		char *path = ceph_mdsc_build_path(mdsc, req->r_dentry, &pathlen,
 						  &base, 0);
 
 		pr_warn("async create failure path=(%llx)%s result=%d!\n",
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0a70a2438cb2..b9c7b6c60357 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2125,6 +2125,7 @@ static bool drop_negative_children(struct dentry *dentry)
  */
 static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	int *remaining = arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int used, wanted, oissued, mine;
@@ -2172,7 +2173,7 @@ static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 
 	if (oissued) {
 		/* we aren't the only cap.. just remove us */
-		ceph_remove_cap(cap, true);
+		ceph_remove_cap(mdsc, cap, true);
 		(*remaining)--;
 	} else {
 		struct dentry *dentry;
@@ -2633,7 +2634,8 @@ static u8 *get_fscrypt_altname(const struct ceph_mds_request *req, u32 *plen)
  * Encode hidden .snap dirs as a double /, i.e.
  *   foo/.snap/bar -> foo//bar
  */
-char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for_wire)
+char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
+			   int *plen, u64 *pbase, int for_wire)
 {
 	struct dentry *cur;
 	struct inode *inode;
@@ -2748,9 +2750,9 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for
 	return path + pos;
 }
 
-static int build_dentry_path(struct dentry *dentry, struct inode *dir,
-			     const char **ppath, int *ppathlen, u64 *pino,
-			     bool *pfreepath, bool parent_locked)
+static int build_dentry_path(struct ceph_mds_client *mdsc, struct dentry *dentry,
+			     struct inode *dir, const char **ppath, int *ppathlen,
+			     u64 *pino, bool *pfreepath, bool parent_locked)
 {
 	char *path;
 
@@ -2765,7 +2767,7 @@ static int build_dentry_path(struct dentry *dentry, struct inode *dir,
 		return 0;
 	}
 	rcu_read_unlock();
-	path = ceph_mdsc_build_path(dentry, ppathlen, pino, 1);
+	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
 	*ppath = path;
@@ -2777,6 +2779,7 @@ static int build_inode_path(struct inode *inode,
 			    const char **ppath, int *ppathlen, u64 *pino,
 			    bool *pfreepath)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct dentry *dentry;
 	char *path;
 
@@ -2786,7 +2789,7 @@ static int build_inode_path(struct inode *inode,
 		return 0;
 	}
 	dentry = d_find_alias(inode);
-	path = ceph_mdsc_build_path(dentry, ppathlen, pino, 1);
+	path = ceph_mdsc_build_path(mdsc, dentry, ppathlen, pino, 1);
 	dput(dentry);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
@@ -2799,10 +2802,11 @@ static int build_inode_path(struct inode *inode,
  * request arguments may be specified via an inode *, a dentry *, or
  * an explicit ino+path.
  */
-static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
-				  struct inode *rdiri, const char *rpath,
-				  u64 rino, const char **ppath, int *pathlen,
-				  u64 *ino, bool *freepath, bool parent_locked)
+static int set_request_path_attr(struct ceph_mds_client *mdsc, struct inode *rinode,
+				 struct dentry *rdentry, struct inode *rdiri,
+				 const char *rpath, u64 rino, const char **ppath,
+				 int *pathlen, u64 *ino, bool *freepath,
+				 bool parent_locked)
 {
 	int r = 0;
 
@@ -2811,7 +2815,7 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
 		dout(" inode %p %llx.%llx\n", rinode, ceph_ino(rinode),
 		     ceph_snap(rinode));
 	} else if (rdentry) {
-		r = build_dentry_path(rdentry, rdiri, ppath, pathlen, ino,
+		r = build_dentry_path(mdsc, rdentry, rdiri, ppath, pathlen, ino,
 					freepath, parent_locked);
 		dout(" dentry %p %llx/%.*s\n", rdentry, *ino, *pathlen,
 		     *ppath);
@@ -2883,7 +2887,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	int ret;
 	bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
 
-	ret = set_request_path_attr(req->r_inode, req->r_dentry,
+	ret = set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
 			      req->r_parent, req->r_path1, req->r_ino1.ino,
 			      &path1, &pathlen1, &ino1, &freepath1,
 			      test_bit(CEPH_MDS_R_PARENT_LOCKED,
@@ -2897,7 +2901,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	if (req->r_old_dentry &&
 	    !(req->r_old_dentry->d_flags & DCACHE_DISCONNECTED))
 		old_dentry = req->r_old_dentry;
-	ret = set_request_path_attr(NULL, old_dentry,
+	ret = set_request_path_attr(mdsc, NULL, old_dentry,
 			      req->r_old_dentry_dir,
 			      req->r_path2, req->r_ino2.ino,
 			      &path2, &pathlen2, &ino2, &freepath2, true);
@@ -4288,6 +4292,7 @@ static struct dentry* d_find_primary(struct inode *inode)
  */
 static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	union {
 		struct ceph_mds_cap_reconnect v2;
 		struct ceph_mds_cap_reconnect_v1 v1;
@@ -4305,7 +4310,7 @@ static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 	dentry = d_find_primary(inode);
 	if (dentry) {
 		/* set pathbase to parent dir when msg_version >= 2 */
-		path = ceph_mdsc_build_path(dentry, &pathlen, &pathbase,
+		path = ceph_mdsc_build_path(mdsc, dentry, &pathlen, &pathbase,
 					    recon_state->msg_version >= 2);
 		dput(dentry);
 		if (IS_ERR(path)) {
@@ -5660,7 +5665,7 @@ void ceph_mdsc_handle_mdsmap(struct ceph_mds_client *mdsc, struct ceph_msg *msg)
 		return;
 	}
 
-	newmap = ceph_mdsmap_decode(&p, end, ceph_msgr2(mdsc->fsc->client));
+	newmap = ceph_mdsmap_decode(mdsc, &p, end, ceph_msgr2(mdsc->fsc->client));
 	if (IS_ERR(newmap)) {
 		err = PTR_ERR(newmap);
 		goto bad_unlock;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 351d92f7fc4f..20bcf8d5322e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -578,7 +578,8 @@ static inline void ceph_mdsc_free_path(char *path, int len)
 		__putname(path - (PATH_MAX - 1 - len));
 }
 
-extern char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *base,
+extern char *ceph_mdsc_build_path(struct ceph_mds_client *mdsc,
+				  struct dentry *dentry, int *plen, u64 *base,
 				  int stop_on_nosnap);
 
 extern void __ceph_mdsc_drop_dentry_lease(struct dentry *dentry);
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 7dac21ee6ce7..6cbec7aed5a0 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -114,7 +114,8 @@ static int __decode_and_drop_compat_set(void **p, void* end)
  * Ignore any fields we don't care about (there are quite a few of
  * them).
  */
-struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
+struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
+				       void *end, bool msgr2)
 {
 	struct ceph_mdsmap *m;
 	const void *start = *p;
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index abd52f5b3b0a..5bd47829a005 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -451,7 +451,8 @@ static void rebuild_snap_realms(struct ceph_snap_realm *realm,
 			continue;
 		}
 
-		last = build_snap_context(_realm, &realm_queue, dirty_realms);
+		last = build_snap_context(mdsc, _realm, &realm_queue,
+					  dirty_realms);
 		dout("%s %llx %p, %s\n", __func__, _realm->ino, _realm,
 		     last > 0 ? "is deferred" : !last ? "succeeded" : "failed");
 
@@ -709,7 +710,8 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
  * Queue cap_snaps for snap writeback for this realm and its children.
  * Called under snap_rwsem, so realm topology won't change.
  */
-static void queue_realm_cap_snaps(struct ceph_snap_realm *realm)
+static void queue_realm_cap_snaps(struct ceph_mds_client *mdsc,
+				  struct ceph_snap_realm *realm)
 {
 	struct ceph_inode_info *ci;
 	struct inode *lastinode = NULL;
@@ -874,7 +876,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 		realm = list_first_entry(&dirty_realms, struct ceph_snap_realm,
 					 dirty_item);
 		list_del_init(&realm->dirty_item);
-		queue_realm_cap_snaps(realm);
+		queue_realm_cap_snaps(mdsc, realm);
 	}
 
 	if (realm_ret)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 107a9d16a4e8..ab5c0c703eae 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1223,7 +1223,8 @@ extern void ceph_add_cap(struct inode *inode,
 			 unsigned cap, unsigned seq, u64 realmino, int flags,
 			 struct ceph_cap **new_cap);
 extern void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
-extern void ceph_remove_cap(struct ceph_cap *cap, bool queue_release);
+extern void ceph_remove_cap(struct ceph_mds_client *mdsc, struct ceph_cap *cap,
+			    bool queue_release);
 extern void __ceph_remove_caps(struct ceph_inode_info *ci);
 extern void ceph_put_cap(struct ceph_mds_client *mdsc,
 			 struct ceph_cap *cap);
diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
index 4c3e0648dc27..89f1931f1ba6 100644
--- a/include/linux/ceph/mdsmap.h
+++ b/include/linux/ceph/mdsmap.h
@@ -5,6 +5,8 @@
 #include <linux/bug.h>
 #include <linux/ceph/types.h>
 
+struct ceph_mds_client;
+
 /*
  * mds map - describe servers in the mds cluster.
  *
@@ -65,7 +67,8 @@ static inline bool ceph_mdsmap_is_laggy(struct ceph_mdsmap *m, int w)
 }
 
 extern int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m);
-struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2);
+struct ceph_mdsmap *ceph_mdsmap_decode(struct ceph_mds_client *mdsc, void **p,
+				       void *end, bool msgr2);
 extern void ceph_mdsmap_destroy(struct ceph_mdsmap *m);
 extern bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m);
 
-- 
2.40.1

