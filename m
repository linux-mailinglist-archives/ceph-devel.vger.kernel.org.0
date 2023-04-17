Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEAC6E3E1C
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjDQDbJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbjDQDap (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:30:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D093B3C25
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZCnhckYUKu1bV+L64dWQGmtWMwMw3wFHWAbqiAeQ3mw=;
        b=ThqHcEeS1fVCGZvW3sm7EEVSyFWgLJLAwBhcu8ScHZPUbcWacGpY3F4LPQJvYkN2vDsSj/
        c2ljvK6mGf8uyTAOqt2coWaABQ61orkRkRecGeNKCKy+XjIrummmb6f3slcRA0fWfQG5Q7
        OZDsY365Df/wKNS2OowuXP167g3NE3k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-L2Ykp4TRO6SnXT53gaKiKQ-1; Sun, 16 Apr 2023 23:29:43 -0400
X-MC-Unique: L2Ykp4TRO6SnXT53gaKiKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F02DC85530D;
        Mon, 17 Apr 2023 03:29:42 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B2492027044;
        Mon, 17 Apr 2023 03:29:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 29/70] ceph: pass the request to parse_reply_info_readdir()
Date:   Mon, 17 Apr 2023 11:26:13 +0800
Message-Id: <20230417032654.32352-30-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Instead of passing just the r_reply_info to the readdir reply parser,
pass the request pointer directly instead. This will facilitate
implementing readdir on fscrypted directories.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
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
2.39.1

