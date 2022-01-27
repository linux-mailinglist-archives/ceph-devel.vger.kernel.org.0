Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF3349DC88
	for <lists+ceph-devel@lfdr.de>; Thu, 27 Jan 2022 09:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbiA0I0s (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 27 Jan 2022 03:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiA0I0o (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 27 Jan 2022 03:26:44 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94F4C061714
        for <ceph-devel@vger.kernel.org>; Thu, 27 Jan 2022 00:26:43 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id b12so2187030qvz.5
        for <ceph-devel@vger.kernel.org>; Thu, 27 Jan 2022 00:26:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vkYZxkaAHZFPc7EFpfZ3h+ns7I9q9fNGHAYn3OCZilU=;
        b=Cy11lU2FVVj10AHeUpX2NjhIQ/fDRczi3hFs5/9TV0AkTGV7tz1o/3PFtWoSVpMkKo
         0mV684cjDrLEoyPPxHs/OSsy9xUIRWf/ycgOoNOEnys+bDImXSYwBQgfXXBiUb0MW38b
         4RjkdQZ3A+9NvH/lOLo3NOvxsc+mVGcmuFPxXEZagDt99LXQxj0WbztRocc3tl8FFCpt
         awN/9pRsvGNMt29/x3BZvmGK+TLaTgBEC/+D8X29XFbmTbkuSN4nm/4w6wMPq3EhIG4X
         mhd9mIAAH0zXUNek8pzUC6W/pJVzFps3I/v4xx7T1GrLQzpjaQLW9MYW+F1GQ0O1Oedp
         MLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vkYZxkaAHZFPc7EFpfZ3h+ns7I9q9fNGHAYn3OCZilU=;
        b=0aXDqBoMnvKb7xZZXeeRy9Bdz8xGYBJJyFzMFebNChKdvvKG/qxLzL1/6iQjtO6nUb
         zTTFiJnYVGwk7grVcJKwZWsLMYIFDsEW/WpcBJFZ84pFf0BZiWnlMxfjxcDAgyG0/+Xv
         QdF3ThCmnJi6tslbRpuI5PJ3tr4fheNNG7mPIhhQBcb43Gq8yWpkzgWRM7gFcFvn1Jmf
         eiQc101bDzKgOYyLA3cR/woJI3/qwWHMJy7dxCk4oDA/ZMHnzuZyGzgoanJ+WIvzS3Fk
         2D0XXNd+695HGkuP/ij++zInjaXcujxpNBzoK86/HJvYlg4ztcdRt6dENV3PHLFu3S3e
         vRbg==
X-Gm-Message-State: AOAM533kICjaWWq9MiRHLRyF2qcMsQVH6slRC6c0BfcS4/9JIbQu8N2z
        dedPJ4GQS3JZMD4zuaf1Ck4=
X-Google-Smtp-Source: ABdhPJxObCESLcCtCdAfb53L5sbeMSOzntJKIGFLvLXrmkjR85aDCMOeHZ8jK3vS/Y/GXRbbYeVeGw==
X-Received: by 2002:ad4:5ca4:: with SMTP id q4mr2209543qvh.64.1643272003043;
        Thu, 27 Jan 2022 00:26:43 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id g1sm952953qtk.21.2022.01.27.00.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 00:26:42 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v6 1/1] ceph: add getvxattr op
Date:   Thu, 27 Jan 2022 08:26:19 +0000
Message-Id: <20220127082619.85379-2-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127082619.85379-1-mchangir@redhat.com>
References: <20220127082619.85379-1-mchangir@redhat.com>
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
 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 17 ++++++++++++
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index e3322fcb2e8d..efdce049b7f0 100644
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
index fcf7dfdecf96..9a4fbe48963f 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -924,6 +924,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_inode_xattr *xattr;
 	struct ceph_vxattr *vxattr = NULL;
+	struct ceph_mds_session *session = NULL;
 	int req_mask;
 	ssize_t err;
 
@@ -945,6 +946,22 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 				err = -ERANGE;
 		}
 		return err;
+	} else {
+		err = -ENODATA;
+		spin_lock(&ci->i_ceph_lock);
+		if (strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN))
+			goto out;
+		/* check if the auth mds supports the getvxattr feature */
+		session = ci->i_auth_cap->session;
+		if (!session)
+			goto out;
+
+		if (test_bit(CEPHFS_FEATURE_GETVXATTR, &session->s_features)) {
+			spin_unlock(&ci->i_ceph_lock);
+			err = ceph_do_getvxattr(inode, name, value, size);
+			spin_lock(&ci->i_ceph_lock);
+		}
+		goto out;
 	}
 
 	req_mask = __get_request_mask(inode);
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

