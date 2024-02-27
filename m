Return-Path: <ceph-devel+bounces-916-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 322138689E7
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 08:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC8C528845F
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Feb 2024 07:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9C354F87;
	Tue, 27 Feb 2024 07:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bpbjzzm2"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5344954BC4
	for <ceph-devel@vger.kernel.org>; Tue, 27 Feb 2024 07:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709019304; cv=none; b=EHcBkl/Nb8yyzG3WwD7wxW7RISBUK/tT57sBNCrqW+b6mKgZOcxLSKCLRJCwlEjZeP9m/YRZDh1d8jYoO9btsfpGPpXfDJ/dfKOe81plkSRs1ce4kT6Rw9BrEYj2jpD3cKfVTk6K0VSW9Th+DL6fQNbqg8MJN331X7OAdP9hmNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709019304; c=relaxed/simple;
	bh=e8IijoIt4u5lsNxfwvv6PXQ/O8nGiaeI2M4VnwJQVxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nP9c02dhc/yo6eLj9x/nXHCDt/uFzNBeEbDQEBVnoRiHoSv4NmhoFyK3lYdHFcwk95U/0mG38AEkG4PFDgcs7cgzQPCTkIQ934yEgFpuY9tZlNfDx15qETgTfUAt9paJcgb829KhhaMGyuAUQx3qZyAYJWpBNnnMrUA4tbk6Sy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bpbjzzm2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709019301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3N3HxCq2o2s4Qf8fNMRz6oScYoLXVycFtzR1aKrwcdc=;
	b=Bpbjzzm2IuJj0HwHpgfCl0BtDdKqdKvT1L5lr+iAF2OQ74OI1ZsqO4+A3hgJF2hwWo//cj
	Aus7VAI1ahR6XxifN8MGiHJCO8M/0VmyI09d0zhbfB9C3jFFfAedSqg/KofV6L2VxKdvYU
	N0htLyVglP+f6FD8Gr6BAcFbLNcF21k=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-207-4I1ppKYFOkOMJaf6Xu7YeA-1; Tue,
 27 Feb 2024 02:34:59 -0500
X-MC-Unique: 4I1ppKYFOkOMJaf6Xu7YeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAFE31C29EA0;
	Tue, 27 Feb 2024 07:34:58 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.214])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F21E02166B32;
	Tue, 27 Feb 2024 07:34:55 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 2/6] ceph: add ceph_mds_check_access() helper support
Date: Tue, 27 Feb 2024 15:27:01 +0800
Message-ID: <20240227072705.593676-3-xiubli@redhat.com>
In-Reply-To: <20240227072705.593676-1-xiubli@redhat.com>
References: <20240227072705.593676-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

From: Xiubo Li <xiubli@redhat.com>

This will help check the mds auth access in client side. Always
insert the server path in front of the target path when matching
the paths.

URL: https://tracker.ceph.com/issues/61333
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 162 +++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.h |   3 +
 2 files changed, 165 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b715ccfff419..ee330f355958 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5634,6 +5634,168 @@ void send_flush_mdlog(struct ceph_mds_session *s)
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
+	const char *spath = mdsc->fsc->mount_options->server_path;
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
+			      spath, tpath, auth->match.path);
+			if (spath && (m = strlen(spath)) != 1) {
+				/* mount path + '/' + tpath + an extra space */
+				n = m + 1 + tlen + 1;
+				_tpath = kmalloc(n, GFP_NOFS);
+				if (!_tpath)
+					return -ENOMEM;
+				/* remove the leading '/' */
+				snprintf(_tpath, n, "%s/%s", spath + 1, tpath);
+				free_tpath = true;
+				tlen = strlen(_tpath);
+			}
+
+			/*
+			 * Please note the tailing '/' for match.path has already
+			 * been removed when parsing.
+			 *
+			 * Remove the tailing '/' for the target path.
+			 */
+			while (tlen && _tpath[tlen - 1] == '/') {
+				_tpath[tlen - 1] = '\0';
+				tlen -= 1;
+			}
+			doutc(cl, "_tpath %s\n", _tpath);
+
+			/* In case first == _tpath && tlen == len:
+			 *  match.path=/foo  --> /foo _path=/foo     --> match
+			 *  match.path=/foo/ --> /foo _path=/foo     --> match
+			 *
+			 * In case first == _tmatch.path && tlen > len:
+			 *  match.path=/foo/ --> /foo _path=/foo/    --> match
+			 *  match.path=/foo  --> /foo _path=/foo/    --> match
+			 *  match.path=/foo/ --> /foo _path=/foo/d   --> match
+			 *  match.path=/foo  --> /foo _path=/food    --> mismatch
+			 *
+			 * All the other cases                       --> mismatch
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
index b98aadac480e..3d9107f72553 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -603,6 +603,9 @@ extern void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc);
 extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
 				     int (*cb)(struct inode *, int mds, void *),
 				     void *arg);
+extern int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath,
+				 int mask);
+
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
 static inline void ceph_mdsc_free_path(char *path, int len)
-- 
2.43.0


