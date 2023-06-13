Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4236372D920
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbjFMF31 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbjFMF3E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:29:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B41F10FC
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=048RSOzJG0p3RL+7540fd5I2Mayc34FiJD/HR/r2Xog=;
        b=bu4DgRpwqpZpohrg/8rJTTA532XLOg8sCjcSqjR6bh9bo3dgDuHQ5tWEKTw+baqHXzT6P7
        lvl8ntN3nUco6rIK/yAdc7wUR5FD7CfkdagV4cS1f0vVIHNBO/k3MpDtAJjZmTbB3vycCf
        NgSNRimKvHZ9bA5JFs40FO2EBwBfqng=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-322-qh51PwEjNcy10sM3kDHkDg-1; Tue, 13 Jun 2023 01:27:51 -0400
X-MC-Unique: qh51PwEjNcy10sM3kDHkDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB638811E86;
        Tue, 13 Jun 2023 05:27:50 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ACEF31121314;
        Tue, 13 Jun 2023 05:27:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 16/71] ceph: decode alternate_name in lease info
Date:   Tue, 13 Jun 2023 13:23:29 +0800
Message-Id: <20230613052424.254540-17-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

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

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 43 +++++++++++++++++++++++++++++++++----------
 fs/ceph/mds_client.h |  5 +++++
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d9752f2d7a72..84ca9ae8fa6a 100644
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
index ee64d5709f2b..5b338e591c46 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -44,6 +44,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
 	CEPHFS_FEATURE_METRIC_COLLECT,		\
+	CEPHFS_FEATURE_ALTERNATE_NAME,		\
 	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
 	CEPHFS_FEATURE_OP_GETVXATTR,		\
 }
@@ -96,7 +97,9 @@ struct ceph_mds_reply_info_in {
 
 struct ceph_mds_reply_dir_entry {
 	char                          *name;
+	u8			      *altname;
 	u32                           name_len;
+	u32			      altname_len;
 	struct ceph_mds_reply_lease   *lease;
 	struct ceph_mds_reply_info_in inode;
 	loff_t			      offset;
@@ -120,7 +123,9 @@ struct ceph_mds_reply_info_parsed {
 	struct ceph_mds_reply_info_in diri, targeti;
 	struct ceph_mds_reply_dirfrag *dirfrag;
 	char                          *dname;
+	u8			      *altname;
 	u32                           dname_len;
+	u32                           altname_len;
 	struct ceph_mds_reply_lease   *dlease;
 	struct ceph_mds_reply_xattr   xattr_info;
 
-- 
2.40.1

