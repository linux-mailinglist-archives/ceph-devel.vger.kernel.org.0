Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C94512249
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbiD0TTg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiD0TTO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0918887AF
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFB1CB8294F
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA923C385AE;
        Wed, 27 Apr 2022 19:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086808;
        bh=vz1Ry5ReZlY5z2VcDwbDw4IuIMhPeeWZ/YVqbVdimQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppsLt54385xjtEtMtEvB78rpuso55NtZsaI4476lWHvSeUqw31Jj+hqy+bfr2FfMq
         xCurN+C6yIzCbBzj0IOm1Vj+6u+e3dOpkdmyEfEIPmqm12jLgzkAz2v1zYl7FA0s85
         lJ3MpO5JfPSivL12Em3QsENTycY65A3fvQkcaqHpk+UbR1KaTpuimS2Tkcm2aYZt5t
         nIqVARq413TMPTZrCtAcW36oCXXxq4JQZViijApMFv+M6z5PIBSEDjhOdyYhxXNQAp
         ds532g0sCkqJEC5yKZuR6RTyvu+nEcSjgWICCortfRBI+iabnxlfOiGMG+fnARzER7
         zH1Gs+se9hVsw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 16/64] ceph: decode alternate_name in lease info
Date:   Wed, 27 Apr 2022 15:12:26 -0400
Message-Id: <20220427191314.222867-17-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ceph is a bit different from local filesystems, in that we don't want
to store filenames as raw binary data, since we may also be dealing
with clients that don't support fscrypt.

We could just base64-encode the encrypted filenames, but that could
leave us with filenames longer than NAME_MAX. It turns out that the
MDS doesn't care much about filename length, but the clients do.

To manage this, we've added a new "alternate name" field that can be
optionally added to any dentry that we'll use to store the binary
crypttext of the filename if its base64-encoded value will be longer
than NAME_MAX. When a dentry has one of these names attached, the MDS
will send it along in the lease info, which we can then store for
later usage.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 43 +++++++++++++++++++++++++++++++++----------
 fs/ceph/mds_client.h | 11 +++++++----
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 38de82c2cb5a..68f25292a26a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -308,27 +308,47 @@ static int parse_reply_info_dir(void **p, void *end,
 
 static int parse_reply_info_lease(void **p, void *end,
 				  struct ceph_mds_reply_lease **lease,
-				  u64 features)
+				  u64 features, u32 *altname_len, u8 **altname)
 {
+	u8 struct_v;
+	u32 struct_len;
+	void *lend;
+
 	if (features == (u64)-1) {
-		u8 struct_v, struct_compat;
-		u32 struct_len;
+		u8 struct_compat;
+
 		ceph_decode_8_safe(p, end, struct_v, bad);
 		ceph_decode_8_safe(p, end, struct_compat, bad);
+
 		/* struct_v is expected to be >= 1. we only understand
 		 * encoding whose struct_compat == 1. */
 		if (!struct_v || struct_compat != 1)
 			goto bad;
+
 		ceph_decode_32_safe(p, end, struct_len, bad);
-		ceph_decode_need(p, end, struct_len, bad);
-		end = *p + struct_len;
+	} else {
+		struct_len = sizeof(**lease);
+		*altname_len = 0;
+		*altname = NULL;
 	}
 
-	ceph_decode_need(p, end, sizeof(**lease), bad);
+	lend = *p + struct_len;
+	ceph_decode_need(p, end, struct_len, bad);
 	*lease = *p;
 	*p += sizeof(**lease);
-	if (features == (u64)-1)
-		*p = end;
+
+	if (features == (u64)-1) {
+		if (struct_v >= 2) {
+			ceph_decode_32_safe(p, end, *altname_len, bad);
+			ceph_decode_need(p, end, *altname_len, bad);
+			*altname = *p;
+			*p += *altname_len;
+		} else {
+			*altname = NULL;
+			*altname_len = 0;
+		}
+	}
+	*p = lend;
 	return 0;
 bad:
 	return -EIO;
@@ -358,7 +378,8 @@ static int parse_reply_info_trace(void **p, void *end,
 		info->dname = *p;
 		*p += info->dname_len;
 
-		err = parse_reply_info_lease(p, end, &info->dlease, features);
+		err = parse_reply_info_lease(p, end, &info->dlease, features,
+					     &info->altname_len, &info->altname);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -425,9 +446,11 @@ static int parse_reply_info_readdir(void **p, void *end,
 		dout("parsed dir dname '%.*s'\n", rde->name_len, rde->name);
 
 		/* dentry lease */
-		err = parse_reply_info_lease(p, end, &rde->lease, features);
+		err = parse_reply_info_lease(p, end, &rde->lease, features,
+					     &rde->altname_len, &rde->altname);
 		if (err)
 			goto out_bad;
+
 		/* inode */
 		err = parse_reply_info_in(p, end, &rde->inode, features);
 		if (err < 0)
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index aab3ab284fce..2cc75f9ae7c7 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -29,8 +29,8 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,
 	CEPHFS_FEATURE_DELEG_INO,
 	CEPHFS_FEATURE_METRIC_COLLECT,
-
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
+	CEPHFS_FEATURE_ALTERNATE_NAME,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_ALTERNATE_NAME,
 };
 
 /*
@@ -45,8 +45,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
-						\
-	CEPHFS_FEATURE_MAX,			\
+	CEPHFS_FEATURE_ALTERNATE_NAME,		\
 }
 #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
 
@@ -98,7 +97,9 @@ struct ceph_mds_reply_info_in {
 
 struct ceph_mds_reply_dir_entry {
 	char                          *name;
+	u8			      *altname;
 	u32                           name_len;
+	u32			      altname_len;
 	struct ceph_mds_reply_lease   *lease;
 	struct ceph_mds_reply_info_in inode;
 	loff_t			      offset;
@@ -122,7 +123,9 @@ struct ceph_mds_reply_info_parsed {
 	struct ceph_mds_reply_info_in diri, targeti;
 	struct ceph_mds_reply_dirfrag *dirfrag;
 	char                          *dname;
+	u8			      *altname;
 	u32                           dname_len;
+	u32                           altname_len;
 	struct ceph_mds_reply_lease   *dlease;
 	struct ceph_mds_reply_xattr   xattr_info;
 
-- 
2.35.1

