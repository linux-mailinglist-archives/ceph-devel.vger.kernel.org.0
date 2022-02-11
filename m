Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0ECB4B2558
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Feb 2022 13:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346409AbiBKMMi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Feb 2022 07:12:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349885AbiBKMMi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Feb 2022 07:12:38 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01812F59
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 04:12:37 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id a19so8333226qvm.4
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 04:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4nDGzNGUzKX86VNUcSPOA66Vhn+d6Tk8K7S8BHWHYLM=;
        b=CrnVC57c32RdG4qpUge0KuVXqK5k+Y3UYuzj9dQn9RtQJu+HYTeKXwBaR0k6VfzC7F
         0oRjGyl60dYgUT6CLuP5d/o015YI2kvLNuP80TtyFj57Fvsl+ajq9WVgjjeevPpCvhxU
         DDEQYwvzJIFpjGdmZz/CBIwp93qXmkvyDzFGLr0kgtEEOSop8lbOEuSWIDS6BGoasPfm
         JnQuP8cdYGphcRfdrM5Yu9zO66Y/43WQ8eH/uqddQARuDNIAs5f+IjDV0M70pGGJScym
         nWyknHsGcDuxUH4lkPjtGq45tgo93GCRW71o4kb2rFBAo5QKpYhDFaOyZBPQIjgOwWUE
         DznA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4nDGzNGUzKX86VNUcSPOA66Vhn+d6Tk8K7S8BHWHYLM=;
        b=hCtsVvKgksfsL9432brZd5Kg8VMflN2ZBIVC898AyA+pJ01WSqNRnum+d1EK5jqVS5
         czod6Dl9zAKdvg/4dNZpdkr8NG+0d7gIRllOs2IthKA9FweyhCpGz3K0b42M04VGgOmn
         TbfXbE/tqnj6wqn2IjLcwL/6PQqGp9TYm64FptptzFat+GErrXlxwiU6XY+RWR6Bt6Nd
         wsk2VTKexiC8FZbY98Ey5IVNkn7ZUy/57L9BmJuvg1LDDtFhtd+q042WNEZqENTd2gYN
         bYaS7rz+53bxZum6UWS9+C3rXHV8ZQJ5zV8UpyqbCX+/ffFcZYqI/7eND3v5Z1B0y1CR
         Ulhg==
X-Gm-Message-State: AOAM533f7se8TYdxMRqaTxNfAR28kGscK3j4WAyCIZWTnh41+lYWGiQA
        6J42JrSUBzDmQ1XtT5WBNBE=
X-Google-Smtp-Source: ABdhPJzs27sekHs+FxoFPC/4u0fydLif1ggwlIvsj+ieArXLHNZhYSugyJyalXFK34DLErpzaiK1ig==
X-Received: by 2002:ad4:5a11:: with SMTP id ei17mr769727qvb.36.1644581556135;
        Fri, 11 Feb 2022 04:12:36 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id w10sm13389270qtj.73.2022.02.11.04.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:12:35 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v9 1/1] ceph: add getvxattr op
Date:   Fri, 11 Feb 2022 12:12:17 +0000
Message-Id: <20220211121217.166680-2-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220211121217.166680-1-mchangir@redhat.com>
References: <20220211121217.166680-1-mchangir@redhat.com>
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

As a temporary measure, setting a vxattr can also be done in the old
format. The old format will be deprecated in the future.

URL: https://tracker.ceph.com/issues/51062
Signed-off-by: Milind Changire <mchangir@redhat.com>
---
 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 25 ++++++++++++++++++
 fs/ceph/mds_client.h         |  6 +++++
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              |  9 +++++--
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 92 insertions(+), 2 deletions(-)

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
index c30eefc0ac19..467817cb7309 100644
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
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 97c7f7bfa55f..4282963e4064 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -100,6 +100,11 @@ struct ceph_mds_reply_dir_entry {
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
@@ -115,6 +120,7 @@ struct ceph_mds_reply_info_parsed {
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
index fcf7dfdecf96..4860f1660b82 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -923,10 +923,13 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_inode_xattr *xattr;
-	struct ceph_vxattr *vxattr = NULL;
+	struct ceph_vxattr *vxattr;
 	int req_mask;
 	ssize_t err;
 
+	if (strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN))
+		goto handle_non_vxattrs;
+
 	/* let's see if a virtual xattr was requested */
 	vxattr = ceph_match_vxattr(inode, name);
 	if (vxattr) {
@@ -945,8 +948,10 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
 				err = -ERANGE;
 		}
 		return err;
+	} else {
+		return ceph_do_getvxattr(inode, name, value, size);
 	}
-
+handle_non_vxattrs:
 	req_mask = __get_request_mask(inode);
 
 	spin_lock(&ci->i_ceph_lock);
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

