Return-Path: <ceph-devel+bounces-82-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5EDC7E93FF
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Nov 2023 02:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 573D3280A85
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Nov 2023 01:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4BC522F;
	Mon, 13 Nov 2023 01:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jF/b18IJ"
X-Original-To: ceph-devel@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE81D5666
	for <ceph-devel@vger.kernel.org>; Mon, 13 Nov 2023 01:19:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E872107
	for <ceph-devel@vger.kernel.org>; Sun, 12 Nov 2023 17:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699838363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5UtU4zCp5YIi9PXxcMfEmKiCFi7KtUnPZJrinBbzOBU=;
	b=jF/b18IJp0fFywCv/18tZGshO8TMSfY4h33dYvtbdSdrTjBrRRzUkjEMux1HKQ4K+keFNB
	MjTEy+rpk9U9rtpuoNChPNouaRMXq8crYEHlXDqaVQZxxybd91/PBGOmyWZxAS5L3keego
	s8V56VGn7aSKp1OYFfUWg5xb2pwbxgY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-GrHyu1xFNrOS3SL7bDTLTQ-1; Sun, 12 Nov 2023 20:19:20 -0500
X-MC-Unique: GrHyu1xFNrOS3SL7bDTLTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A74F3811E7E;
	Mon, 13 Nov 2023 01:19:19 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD876C15881;
	Mon, 13 Nov 2023 01:19:16 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/5] ceph: add ceph_mds_check_access() helper support
Date: Mon, 13 Nov 2023 09:17:03 +0800
Message-ID: <20231113011706.542551-3-xiubli@redhat.com>
In-Reply-To: <20231113011706.542551-1-xiubli@redhat.com>
References: <20231113011706.542551-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

From: Xiubo Li <xiubli@redhat.com>

This will help check the mds auth access in client side. Always
insert the server path in front of the target path when matching
the paths.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 157 +++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h |   3 +
 2 files changed, 160 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3fb0b0104f6b..81040052eb4d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5604,6 +5604,163 @@ void send_flush_mdlog(struct ceph_mds_session *s)
 	mutex_unlock(&s->s_mutex);
 }
 
+static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
+			       struct ceph_mds_cap_auth *auth,
+			       char *tpath)
+{
+	const struct cred *cred = get_current_cred();
+	uint32_t caller_uid = from_kuid(&init_user_ns, cred->fsuid);
+	uint32_t caller_gid = from_kgid(&init_user_ns, cred->fsgid);
+	struct ceph_client *cl = mdsc->fsc->client;
+	const char *path = mdsc->fsc->mount_options->server_path;
+	bool gid_matched = false;
+	uint32_t gid, tlen, len;
+	int i, j;
+
+	doutc(cl, "match.uid %lld\n", auth->match.uid);
+	if (auth->match.uid != MDS_AUTH_UID_ANY) {
+		if (auth->match.uid != caller_uid)
+			return 0;
+		if (auth->match.num_gids) {
+			for (i = 0; i < auth->match.num_gids; i++) {
+				if (caller_gid == auth->match.gids[i])
+					gid_matched = true;
+			}
+			if (!gid_matched && cred->group_info->ngroups) {
+				for (i = 0; i < cred->group_info->ngroups; i++) {
+					gid = from_kgid(&init_user_ns, cred->group_info->gid[i]);
+					for (j = 0; j < auth->match.num_gids; j++) {
+						if (gid == auth->match.gids[j]) {
+							gid_matched = true;
+							break;
+						}
+					}
+					if (gid_matched)
+						break;
+				}
+			}
+			if (!gid_matched)
+				return 0;
+		}
+	}
+
+	/* path match */
+	if (auth->match.path) {
+		if (!tpath)
+			return 0;
+
+		tlen = strlen(tpath);
+		len = strlen(auth->match.path);
+		if (len) {
+			char *_tpath = tpath;
+			bool free_tpath = false;
+			int m, n;
+
+			doutc(cl, "server path %s, tpath %s, match.path %s\n",
+			      path, tpath, auth->match.path);
+			if (path && (m = strlen(path)) != 1) {
+				/* mount path + '/' + tpath + an extra space */
+				n = m + 1 + tlen + 1;
+				_tpath = kmalloc(n, GFP_NOFS);
+				if (!_tpath)
+					return -ENOMEM;
+				/* remove the leading '/' */
+				snprintf(_tpath, n, "%s/%s", path + 1, tpath);
+				free_tpath = true;
+				tlen = strlen(_tpath);
+			}
+
+			/* Remove the tailing '/' */
+			while (tlen && _tpath[tlen - 1] == '/') {
+				_tpath[tlen - 1] = '\0';
+				tlen -= 1;
+			}
+			doutc(cl, "_tpath %s\n", _tpath);
+
+			/* In case first == _tpath && tlen == len:
+			 *  path=/foo  --> /foo target_path=/foo     --> match
+			 *  path=/foo/ --> /foo target_path=/foo     --> match
+			 *
+			 * In case first == _tpath && tlen > len:
+			 *  path=/foo/ --> /foo target_path=/foo/    --> match
+			 *  path=/foo  --> /foo target_path=/foo/    --> match
+			 *  path=/foo/ --> /foo target_path=/foo/d   --> match
+			 *  path=/foo  --> /foo target_path=/food    --> mismatch
+			 *
+			 * All the other cases                        --> mismatch
+			 */
+			char *first = strstr(_tpath, auth->match.path);
+			if (first != _tpath) {
+				if (free_tpath)
+					kfree(_tpath);
+				return 0;
+			}
+
+			if (tlen > len && _tpath[len] != '/') {
+				if (free_tpath)
+					kfree(_tpath);
+				return 0;
+			}
+		}
+	}
+
+	doutc(cl, "matched\n");
+	return 1;
+}
+
+int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
+{
+	const struct cred *cred = get_current_cred();
+	uint32_t caller_uid = from_kuid(&init_user_ns, cred->fsuid);
+	uint32_t caller_gid = from_kgid(&init_user_ns, cred->fsgid);
+	struct ceph_mds_cap_auth *rw_perms_s = NULL;
+	struct ceph_client *cl = mdsc->fsc->client;
+	bool root_squash_perms = true;
+	int i, err;
+
+	doutc(cl, "tpath '%s', mask %d, caller_uid %d, caller_gid %d\n",
+	      tpath, mask, caller_uid, caller_gid);
+
+	for (i = 0; i < mdsc->s_cap_auths_num; i++) {
+		struct ceph_mds_cap_auth *s = &mdsc->s_cap_auths[i];
+
+		err = ceph_mds_auth_match(mdsc, s, tpath);
+		if (err < 0) {
+			return err;
+		} else if (err > 0) {
+			// always follow the last auth caps' permision
+			root_squash_perms = true;
+			rw_perms_s = NULL;
+			if ((mask & MAY_WRITE) && s->writeable &&
+			    s->match.root_squash && (!caller_uid || !caller_gid))
+				root_squash_perms = false;
+
+			if (((mask & MAY_WRITE) && !s->writeable) ||
+			    ((mask & MAY_READ) && !s->readable))
+				rw_perms_s = s;
+		}
+	}
+
+	doutc(cl, "root_squash_perms %d, rw_perms_s %p\n", root_squash_perms,
+	      rw_perms_s);
+	if (root_squash_perms && rw_perms_s == NULL) {
+		doutc(cl, "access allowed\n");
+		return 0;
+	}
+
+	if (!root_squash_perms) {
+		doutc(cl, "root_squash is enabled and user(%d %d) isn't allowed to write",
+		      caller_uid, caller_gid);
+	}
+	if (rw_perms_s) {
+		doutc(cl, "mds auth caps readable/writeable %d/%d while request r/w %d/%d",
+		      rw_perms_s->readable, rw_perms_s->writeable, !!(mask & MAY_READ),
+		      !!(mask & MAY_WRITE));
+	}
+	doutc(cl, "access denied\n");
+	return -EACCES;
+}
+
 /*
  * called before mount is ro, and before dentries are torn down.
  * (hmm, does this still race with new lookups?)
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 71f4d1ff663f..8be57267c253 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -602,6 +602,9 @@ extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
 extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
 				     int (*cb)(struct inode *, int mds, void *),
 				     void *arg);
+extern int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath,
+				 int mask);
+
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
 static inline void ceph_mdsc_free_path(char *path, int len)
-- 
2.41.0


