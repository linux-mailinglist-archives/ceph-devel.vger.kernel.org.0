Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962D248AD8E
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jan 2022 13:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239860AbiAKMY7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Jan 2022 07:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbiAKMY7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Jan 2022 07:24:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC52C06173F
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 04:24:58 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso5561294pjb.1
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 04:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g6axWHkc3mZBh7rBa2iNX0jXaMUTywHgStVdFeAUtqY=;
        b=YnGyzhYpmjW9VkWbkZv8FRjk5gqXrNJy7QfiMkhV8mn0lcq80Zba3aRi4gbPW/Cinl
         XVsr/WRG0WiU99fPkz4mn4FSiPdW58UWHHXpkB+AWuw30xyvUpp7dNIq++oONV6Eof2M
         0M8gGFgKN8Etl5kQmjiHW8CyfQQtiCHi+emj1N6EvU7RZs4og+IY+qx9DkXqSKktyo02
         +vy/U2s/AZ2r5629xy2JmgNTw2BnEIbL0eT4F6iA79mqEeVanHwYS4+NPlsd2nAGzQYr
         8yEO/5NVvH3OoRSWrrvJE+FA2tJbC/wuOYijRHY++SWAuHmDpyGACOLrAO/mjIEODkif
         nz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g6axWHkc3mZBh7rBa2iNX0jXaMUTywHgStVdFeAUtqY=;
        b=eDg0p3NOnlfqmlckTPnNGH3GriiuTRfllZqsNfM/G36FHqis28xJPc2Al/k+Ts/mcV
         rXtNDjte7yKkiXhwoaF2GrKNdG/+Oexy3bK7/iwf+xv2hdSkOBghluegv4ufb4xNZryp
         UHPubb/zusMWGJ+bMkYNh1rYSaxSkXT3ctZOwFitpcQHqZRwSU6fl9CXpL7rC4cm/igL
         xEQrUo0WUaZBB+VtpQgPaBVrTQoCr6gTZjCQ6NmNm37wWjCswuKhR50APj7bpdvvced/
         PVZ4EUXgdCuOJoH70exKNpfCU+dlErCYD8o8FGgJec0+qq5GawR6TEbn3M/JBsUJruId
         ZxAQ==
X-Gm-Message-State: AOAM530tu6mp1WIdkAMwQQe9gdWqmteAAdUnflXyrF/FVrgx7qlAeeFF
        snfJiPynAj8qFrgBe1orOd9auHR/LYo=
X-Google-Smtp-Source: ABdhPJziCsim3r9hVsHLECzgOLyFKqfbtGZKf9c0L7O/AJr1H/c0Mnxxqb6fXX/GK2hGeNB6cjKJAg==
X-Received: by 2002:a17:902:c950:b0:14a:59cd:b0bf with SMTP id i16-20020a170902c95000b0014a59cdb0bfmr1360170pla.103.1641903898288;
        Tue, 11 Jan 2022 04:24:58 -0800 (PST)
Received: from indraprastha.. ([49.207.223.193])
        by smtp.gmail.com with ESMTPSA id d8sm6292081pfu.141.2022.01.11.04.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:24:57 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH 1/1] ceph: add getvxattr op
Date:   Tue, 11 Jan 2022 17:54:31 +0530
Message-Id: <20220111122431.93683-2-mchangir@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111122431.93683-1-mchangir@redhat.com>
References: <20220111122431.93683-1-mchangir@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Problem:
Directory vxattrs like ceph.dir.pin* and ceph.dir.layout* may not be
propagated to the client as frequently to keep them updated. This
creates vxattr availability problems.

Solution:
Adds new getvxattr op to fetch ceph.dir.pin*, ceph.dir.layout* and
ceph.file.layout* vxattrs.
If the entire layout for a dir or a file is being set, then it is
expected that the layout be set in standard JSON format. Individual
field value retrieval is not wrapped in JSON. The JSON format also
applies while setting the vxattr if the entire layout is being set in
one go.
As a temporary measure, setting a vxattr can also be done in the old
format. The old format will be deprecated in the future.

URL: https://tracker.ceph.com/issues/51062
Signed-off-by: Milind Changire <mchangir@redhat.com>
---
 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 65 ++++++++++++++++++++++++++++++++++++
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e3322fcb2e8d..f29d59b63c52 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2291,6 +2291,57 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	return err;
 }
 
+int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
+		      size_t size)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_request *req;
+	int mode = USE_AUTH_MDS;
+	int err;
+	char *xattr_value;
+	size_t xattr_value_len;
+
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETVXATTR, mode);
+	if (IS_ERR(req)) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	req->r_path2 = kstrdup(name, GFP_NOFS);
+	if (!req->r_path2) {
+		err = -ENOMEM;
+		goto put;
+	}
+
+	ihold(inode);
+	req->r_inode = inode;
+	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	if (err < 0)
+		goto put;
+
+	xattr_value = req->r_reply_info.xattr_info.xattr_value;
+	xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
+
+	dout("do_getvxattr xattr_value_len:%lu, size:%lu\n", xattr_value_len, size);
+
+	err = xattr_value_len;
+	if (size == 0)
+		goto put;
+
+	if (xattr_value_len > size) {
+		err = -ERANGE;
+		goto put;
+	}
+
+	memcpy(value, xattr_value, xattr_value_len);
+put:
+	ceph_mdsc_put_request(req);
+out:
+	dout("do_getvxattr result=%d\n", err);
+	return err;
+}
+
 
 /*
  * Check inode permissions.  We verify we have a valid value for
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c30eefc0ac19..a5eafc71d976 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -555,6 +555,29 @@ static int parse_reply_info_create(void **p, void *end,
 	return -EIO;
 }
 
+static int parse_reply_info_getvxattr(void **p, void *end,
+				      struct ceph_mds_reply_info_parsed *info,
+				      u64 features)
+{
+	u8 struct_v, struct_compat;
+	u32 struct_len;
+	u32 value_len;
+
+	ceph_decode_8_safe(p, end, struct_v, bad);
+	ceph_decode_8_safe(p, end, struct_compat, bad);
+	ceph_decode_32_safe(p, end, struct_len, bad);
+	ceph_decode_32_safe(p, end, value_len, bad);
+
+	if (value_len == end - *p) {
+	  info->xattr_info.xattr_value = *p;
+	  info->xattr_info.xattr_value_len = end - *p;
+	  *p = end;
+	  return info->xattr_info.xattr_value_len;
+	}
+bad:
+	return -EIO;
+}
+
 /*
  * parse extra results
  */
@@ -570,6 +593,8 @@ static int parse_reply_info_extra(void **p, void *end,
 		return parse_reply_info_readdir(p, end, info, features);
 	else if (op == CEPH_MDS_OP_CREATE)
 		return parse_reply_info_create(p, end, info, features, s);
+	else if (op == CEPH_MDS_OP_GETVXATTR)
+		return parse_reply_info_getvxattr(p, end, info, features);
 	else
 		return -EIO;
 }
@@ -615,7 +640,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 
 	if (p != end)
 		goto bad;
-	return 0;
+	return err;
 
 bad:
 	err = -EIO;
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 97c7f7bfa55f..f2a8e5af3c2e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -29,8 +29,10 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,
 	CEPHFS_FEATURE_DELEG_INO,
 	CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_ALTERNATE_NAME,
+	CEPHFS_FEATURE_GETVXATTR,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_GETVXATTR,
 };
 
 /*
@@ -45,6 +47,8 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
+	CEPHFS_FEATURE_ALTERNATE_NAME,		\
+	CEPHFS_FEATURE_GETVXATTR,		\
 						\
 	CEPHFS_FEATURE_MAX,			\
 }
@@ -100,6 +104,11 @@ struct ceph_mds_reply_dir_entry {
 	loff_t			      offset;
 };
 
+struct ceph_mds_reply_xattr {
+	char *xattr_value;
+	size_t xattr_value_len;
+};
+
 /*
  * parsed info about an mds reply, including information about
  * either: 1) the target inode and/or its parent directory and dentry,
@@ -115,6 +124,7 @@ struct ceph_mds_reply_info_parsed {
 	char                          *dname;
 	u32                           dname_len;
 	struct ceph_mds_reply_lease   *dlease;
+	struct ceph_mds_reply_xattr   xattr_info;
 
 	/* extra */
 	union {
diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
index 573bb9556fb5..e36e8948e728 100644
--- a/fs/ceph/strings.c
+++ b/fs/ceph/strings.c
@@ -60,6 +60,7 @@ const char *ceph_mds_op_name(int op)
 	case CEPH_MDS_OP_LOOKUPINO:  return "lookupino";
 	case CEPH_MDS_OP_LOOKUPNAME:  return "lookupname";
 	case CEPH_MDS_OP_GETATTR:  return "getattr";
+	case CEPH_MDS_OP_GETVXATTR:  return "getvxattr";
 	case CEPH_MDS_OP_SETXATTR: return "setxattr";
 	case CEPH_MDS_OP_SETATTR: return "setattr";
 	case CEPH_MDS_OP_RMXATTR: return "rmxattr";
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ac331aa07cfa..a627fa69668e 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1043,6 +1043,7 @@ static inline bool ceph_inode_is_shutdown(struct inode *inode)
 
 /* xattr.c */
 int __ceph_setxattr(struct inode *, const char *, const void *, size_t, int);
+int ceph_do_getvxattr(struct inode *inode, const char *name, void *value, size_t size);
 ssize_t __ceph_getxattr(struct inode *, const char *, void *, size_t);
 extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
 extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index fcf7dfdecf96..fdde8ffa71bb 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -918,6 +918,64 @@ static inline int __get_request_mask(struct inode *in) {
 	return mask;
 }
 
+static inline bool ceph_is_passthrough_vxattr(const char *name)
+{
+	const char *vxattr_list[] = {
+		"ceph.dir.pin",
+		"ceph.dir.pin.random",
+		"ceph.dir.pin.distributed",
+		"ceph.dir.layout",
+		"ceph.dir.layout.object_size",
+		"ceph.dir.layout.stripe_count",
+		"ceph.dir.layout.stripe_unit",
+		"ceph.dir.layout.pool",
+		"ceph.dir.layout.pool_name",
+		"ceph.dir.layout.pool_id",
+		"ceph.dir.layout.pool_namespace",
+		"ceph.file.layout",
+		"ceph.file.layout.object_size",
+		"ceph.file.layout.stripe_count",
+		"ceph.file.layout.stripe_unit",
+		"ceph.file.layout.pool",
+		"ceph.file.layout.pool_name",
+		"ceph.file.layout.pool_id",
+		"ceph.file.layout.pool_namespace",
+	};
+	int i = 0;
+	int n = sizeof(vxattr_list)/sizeof(vxattr_list[0]);
+
+	while (i < n) {
+		if (!strcmp(name, vxattr_list[i]))
+			return true;
+		i++;
+	}
+	return false;
+}
+
+/* check if the entire cluster supports the given feature */
+static inline bool ceph_cluster_has_feature(struct inode *inode, int feature_bit)
+{
+	int64_t i;
+	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
+	struct ceph_mds_session **sessions = fsc->mdsc->sessions;
+	int64_t num_sessions = atomic_read(&fsc->mdsc->num_sessions);
+
+	if (fsc->mdsc->stopping)
+		return false;
+
+	if (!sessions)
+		return false;
+
+	for (i = 0; i < num_sessions; i++) {
+		struct ceph_mds_session *session = sessions[i];
+		if (!session)
+			return false;
+		if (!test_bit(feature_bit, &session->s_features))
+			return false;
+	}
+	return true;
+}
+
 ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		      size_t size)
 {
@@ -927,6 +985,13 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	int req_mask;
 	ssize_t err;
 
+	if (ceph_is_passthrough_vxattr(name) &&
+	    ceph_cluster_has_feature(inode, CEPHFS_FEATURE_GETVXATTR)) {
+		err = ceph_do_getvxattr(inode, name, value, size);
+		return err;
+	}
+	dout("vxattr is not passthrough or kclient doesn't support GETVXATTR\n");
+
 	/* let's see if a virtual xattr was requested */
 	vxattr = ceph_match_vxattr(inode, name);
 	if (vxattr) {
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 7ad6c3d0db7d..66db21ac5f0c 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -328,6 +328,7 @@ enum {
 	CEPH_MDS_OP_LOOKUPPARENT = 0x00103,
 	CEPH_MDS_OP_LOOKUPINO  = 0x00104,
 	CEPH_MDS_OP_LOOKUPNAME = 0x00105,
+	CEPH_MDS_OP_GETVXATTR  = 0x00106,
 
 	CEPH_MDS_OP_SETXATTR   = 0x01105,
 	CEPH_MDS_OP_RMXATTR    = 0x01106,
-- 
2.34.1

