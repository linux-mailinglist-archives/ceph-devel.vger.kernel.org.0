Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C094B0A8F
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 11:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbiBJKaD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Feb 2022 05:30:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiBJKaC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Feb 2022 05:30:02 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC442C5
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 02:30:03 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id c14so4437062qvl.12
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 02:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uDA7fnxCOYpdO9m0IEYIik1mDqNgcbm0xaW3xv6xi4E=;
        b=JEgy782Vkn+yDcjnn5puCRuSg+MHIrIlaGuPzYMmM0+B8y36nsLbuyPiJOi4vxkjNb
         jOSuNibkpN0grJUILlwrL08IMCQyiUT8V8Kc6WozXn6QsMlPh882jVEsAwf/OEon26fF
         E7RIytK0h+4Pj5cx9u9QIWI+WUqEAciDWK8Rj8b+8lAJ0e4zvo9CAlT75NHTEF3HdBSc
         Q7BAy4CjlLhu0G6j+guYXztx1OcuMf1ntSw5vqTTj1TDIvFbZjThQ5fugrJYv36dp9kW
         imEh/0vZcNh4aTNWCz246fUm4UeTJLXIwBEmMC6wvzbuzZ7KIeUdNf1NOKXGqUfkWAJC
         9cnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uDA7fnxCOYpdO9m0IEYIik1mDqNgcbm0xaW3xv6xi4E=;
        b=YnJAtKuImHiyvx+nTgmTa7RQ6e5ii6UlVh/Sl1BPwjr+uoyPRuNf+rIECiRDFasw21
         Nzfr+OHReUTZd73u4Zh2Ofw349UdRJWxSubOYtsN69pSsqAG6TU2woSEf2YioiVMdqVC
         3CrnKyPFbuX1B7aQ3FJDQxWcteEeEDiS9JUL/Lttcog5F257IwQd4RIU+ZipUY9PDWKc
         wl+JRQrPsRr5t7geMmxaKbHqZqCRMpMAlePn3FlkqBEVAXOPLLks6HttOUhRhQ3AjT//
         z1j77g74NrLdXeI1KX89iD9I1TjHuzs8IUdmfvxwbi5vCcZJcVjb8jwjFab78WTV+cwE
         whfA==
X-Gm-Message-State: AOAM531McdH71B+QvqJ4sY0EzWVF1V/7yGmdQBnvcTNjCfCpOWW1mXLy
        X0mDGR352rUKs9WMXwMm2XBsQaaWr/QdzPvz
X-Google-Smtp-Source: ABdhPJz+3KDc8Ad4YGgFYAcKvFE1N2TnC+lmLksEAk/fNTBHT394OZ+mwt2FQqn/TgKoPOZ2s3nZ2Q==
X-Received: by 2002:a05:6214:2aa5:: with SMTP id js5mr4489043qvb.113.1644489002432;
        Thu, 10 Feb 2022 02:30:02 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id m22sm9963693qkn.35.2022.02.10.02.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 02:30:02 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v8 1/1] ceph: add getvxattr op
Date:   Thu, 10 Feb 2022 10:29:39 +0000
Message-Id: <20220210102939.159059-2-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220210102939.159059-1-mchangir@redhat.com>
References: <20220210102939.159059-1-mchangir@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
To handle upgrade scenario, the mds session is vetted to prioritize
auth-mds. If no auth-mds is found, random mds with getvxattr support
is chosen to handle the op. In no mds with getvxattr support is found,
an "Operation not supported" error is returned.

As a temporary measure, setting a vxattr can also be done in the old
format. The old format will be deprecated in the future.

URL: https://tracker.ceph.com/issues/51062
Signed-off-by: Milind Changire <mchangir@redhat.com>
---
 fs/ceph/inode.c              | 104 +++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         |  32 +++++++++++
 fs/ceph/mds_client.h         |  24 +++++++-
 fs/ceph/strings.c            |   1 +
 fs/ceph/super.h              |   1 +
 fs/ceph/xattr.c              |  15 ++++-
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 175 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e3322fcb2e8d..e039fed41767 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2291,6 +2291,110 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	return err;
 }
 
+int ceph_vet_session(struct ceph_mds_client *mdsc,
+		     struct ceph_mds_request *req,
+		     bool *random)
+{
+	struct ceph_inode_info *ci = ceph_inode(req->r_inode);
+	struct ceph_mds_session *session;
+	int mds_with_getvxattr_support = 0;
+	int idx = MDS_RANK_UNAVAILABLE;
+	int rnd;
+	int i;
+
+	if (req->r_op == CEPH_MDS_OP_GETVXATTR) {
+		if (random)
+			*random = false;
+
+		session = ci->i_auth_cap ? ci->i_auth_cap->session : NULL;
+		/* check if the auth mds supports the getvxattr feature */
+		if (session &&
+		    test_bit(CEPHFS_FEATURE_GETVXATTR, &session->s_features)) {
+			return session->s_mds;
+		} else {
+			for (i = 0; i < mdsc->max_sessions; i++) {
+				if (mdsc->sessions[i] &&
+				    test_bit(CEPHFS_FEATURE_GETVXATTR,
+					     &mdsc->sessions[i]->s_features))
+					mds_with_getvxattr_support++;
+			}
+			if (!mds_with_getvxattr_support)
+				goto out;
+
+			/* choose a random mds with getvxattr support */
+			rnd = prandom_u32() % mds_with_getvxattr_support;
+			for (i = 0; i < mdsc->max_sessions; i++) {
+				if (mdsc->sessions[i] &&
+				    test_bit(CEPHFS_FEATURE_GETVXATTR,
+					     &mdsc->sessions[i]->s_features)) {
+					if (rnd)
+						rnd--;
+					if (!rnd) {
+						idx = mdsc->sessions[i]->s_mds;
+						break;
+					}
+				}
+			}
+			if (idx != MDS_RANK_UNAVAILABLE && random)
+				*random = true;
+		}
+	}
+out:
+	return idx;
+}
+
+int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
+		      size_t size)
+{
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_mds_request *req;
+	int mode = USE_VETTED_MDS;
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
+	req->r_vet_session = ceph_vet_session;
+	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	if (err < 0)
+		goto put;
+
+	xattr_value = req->r_reply_info.xattr_info.xattr_value;
+	xattr_value_len = req->r_reply_info.xattr_info.xattr_value_len;
+
+	dout("do_getvxattr xattr_value_len:%zu, size:%zu\n", xattr_value_len, size);
+
+	err = (int)xattr_value_len;
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
index c30eefc0ac19..87df4ef6880b 100644
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
+	  info->xattr_info.xattr_value_len = value_len;
+	  *p = end;
+	  return value_len;
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
@@ -1041,6 +1066,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 	if (mode == USE_RANDOM_MDS)
 		goto random;
 
+	if (mode == USE_VETTED_MDS)
+		return req->r_vet_session(mdsc, req, random);
+
 	inode = NULL;
 	if (req->r_inode) {
 		if (ceph_snap(req->r_inode) != CEPH_SNAPDIR) {
@@ -2770,6 +2798,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	put_request_session(req);
 
 	mds = __choose_mds(mdsc, req, &random);
+	if (mds == MDS_RANK_UNAVAILABLE) {
+		err = -EOPNOTSUPP;
+		goto finish;
+	}
 	if (mds < 0 ||
 	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
 		if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags)) {
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 97c7f7bfa55f..94230fae9e71 100644
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
@@ -222,6 +232,14 @@ enum {
 	USE_ANY_MDS,
 	USE_RANDOM_MDS,
 	USE_AUTH_MDS,   /* prefer authoritative mds for this metadata item */
+	USE_VETTED_MDS  /* eg. use an mds supporting particular feature */
+};
+
+/*
+ * special mds rank
+ */
+enum {
+	MDS_RANK_UNAVAILABLE = (int)0x80000000 /* INT_MIN */
 };
 
 struct ceph_mds_request;
@@ -337,6 +355,10 @@ struct ceph_mds_request {
 	int		  r_readdir_cache_idx;
 
 	struct ceph_cap_reservation r_caps_reservation;
+	/* return mds rank to send request to */
+	int (*r_vet_session)(struct ceph_mds_client *mdsc,
+			     struct ceph_mds_request *req,
+			     bool *random);
 };
 
 struct ceph_pool_perm {
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
index fcf7dfdecf96..557749882aa2 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -923,9 +923,12 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_inode_xattr *xattr;
-	struct ceph_vxattr *vxattr = NULL;
+	struct ceph_vxattr *vxattr;
 	int req_mask;
-	ssize_t err;
+	ssize_t err = -ENODATA;
+
+	if (strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN))
+		goto out_nounlock;
 
 	/* let's see if a virtual xattr was requested */
 	vxattr = ceph_match_vxattr(inode, name);
@@ -945,6 +948,13 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 				err = -ERANGE;
 		}
 		return err;
+	} else {
+		err = -ENODATA;
+		spin_unlock(&ci->i_ceph_lock);
+		err = ceph_do_getvxattr(inode, name, value, size);
+		spin_lock(&ci->i_ceph_lock);
+
+		goto out;
 	}
 
 	req_mask = __get_request_mask(inode);
@@ -997,6 +1007,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 		ci->i_ceph_flags |= CEPH_I_SEC_INITED;
 out:
 	spin_unlock(&ci->i_ceph_lock);
+out_nounlock:
 	return err;
 }
 
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
2.31.1

