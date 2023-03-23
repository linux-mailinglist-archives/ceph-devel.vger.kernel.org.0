Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F436C602B
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjCWG6h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjCWG6f (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:58:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A059B303E1
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=85iwjUfqpjvIVUu6VuZ+OYYYs6kCremV377jqnYeR1Q=;
        b=XTeyOpUk387h3/Otdpn5y8+67ykNtqpWqIcN6bdF5w+NiRYxMtNZs6SwrIouS7c9SzNd11
        fmjBJHsiV0YVXghJ9/bMvmkMpD2z/N9Jc8/JTYtYaQ+ATesA3QkhVigdAZ3Ts6LP5xzp4k
        xOTHiBbYggEbt/4wgxR6dTR6gJXiqk8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-gu3aqJgVO4yt4vpycLrw6w-1; Thu, 23 Mar 2023 02:57:20 -0400
X-MC-Unique: gu3aqJgVO4yt4vpycLrw6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0403185A794;
        Thu, 23 Mar 2023 06:57:18 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 302F3492B01;
        Thu, 23 Mar 2023 06:57:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 29/71] ceph: pass the request to parse_reply_info_readdir()
Date:   Thu, 23 Mar 2023 14:54:43 +0800
Message-Id: <20230323065525.201322-30-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Instead of passing just the r_reply_info to the readdir reply parser,
pass the request pointer directly instead. This will facilitate
implementing readdir on fscrypted directories.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1296ee127f3c..37e183d383b1 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -406,9 +406,10 @@ static int parse_reply_info_trace(void **p, void *end,
  * parse readdir results
  */
 static int parse_reply_info_readdir(void **p, void *end,
-				struct ceph_mds_reply_info_parsed *info,
-				u64 features)
+				    struct ceph_mds_request *req,
+				    u64 features)
 {
+	struct ceph_mds_reply_info_parsed *info = &req->r_reply_info;
 	u32 num, i = 0;
 	int err;
 
@@ -650,15 +651,16 @@ static int parse_reply_info_getvxattr(void **p, void *end,
  * parse extra results
  */
 static int parse_reply_info_extra(void **p, void *end,
-				  struct ceph_mds_reply_info_parsed *info,
+				  struct ceph_mds_request *req,
 				  u64 features, struct ceph_mds_session *s)
 {
+	struct ceph_mds_reply_info_parsed *info = &req->r_reply_info;
 	u32 op = le32_to_cpu(info->head->op);
 
 	if (op == CEPH_MDS_OP_GETFILELOCK)
 		return parse_reply_info_filelock(p, end, info, features);
 	else if (op == CEPH_MDS_OP_READDIR || op == CEPH_MDS_OP_LSSNAP)
-		return parse_reply_info_readdir(p, end, info, features);
+		return parse_reply_info_readdir(p, end, req, features);
 	else if (op == CEPH_MDS_OP_CREATE)
 		return parse_reply_info_create(p, end, info, features, s);
 	else if (op == CEPH_MDS_OP_GETVXATTR)
@@ -671,9 +673,9 @@ static int parse_reply_info_extra(void **p, void *end,
  * parse entire mds reply
  */
 static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
-			    struct ceph_mds_reply_info_parsed *info,
-			    u64 features)
+			    struct ceph_mds_request *req, u64 features)
 {
+	struct ceph_mds_reply_info_parsed *info = &req->r_reply_info;
 	void *p, *end;
 	u32 len;
 	int err;
@@ -695,7 +697,7 @@ static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
 	ceph_decode_32_safe(&p, end, len, bad);
 	if (len > 0) {
 		ceph_decode_need(&p, end, len, bad);
-		err = parse_reply_info_extra(&p, p+len, info, features, s);
+		err = parse_reply_info_extra(&p, p+len, req, features, s);
 		if (err < 0)
 			goto out_bad;
 	}
@@ -3598,14 +3600,14 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	}
 
 	dout("handle_reply tid %lld result %d\n", tid, result);
-	rinfo = &req->r_reply_info;
 	if (test_bit(CEPHFS_FEATURE_REPLY_ENCODING, &session->s_features))
-		err = parse_reply_info(session, msg, rinfo, (u64)-1);
+		err = parse_reply_info(session, msg, req, (u64)-1);
 	else
-		err = parse_reply_info(session, msg, rinfo, session->s_con.peer_features);
+		err = parse_reply_info(session, msg, req, session->s_con.peer_features);
 	mutex_unlock(&mdsc->mutex);
 
 	/* Must find target inode outside of mutexes to avoid deadlocks */
+	rinfo = &req->r_reply_info;
 	if ((err >= 0) && rinfo->head->is_target) {
 		struct inode *in = xchg(&req->r_new_inode, NULL);
 		struct ceph_vino tvino = {
-- 
2.31.1

