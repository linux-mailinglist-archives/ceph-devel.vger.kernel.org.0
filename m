Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00ED04D6004
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 11:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243130AbiCKKrP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 05:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbiCKKrO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 05:47:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFE2C1BD987
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 02:46:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646995570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Bv0MHokepvuwf3i9WJNJmdx1ynX3g0jScii7nv+yMA=;
        b=V6MJ4PQzHsjYj8ofcGrYaF2zHhmT5p7X83teIhsOU6Q/+BmuWPekd0NVpCfSNL9h9CURHa
        C5bmmsGqR+4gv+gieHPrbL7ruyxlHQwVU7NY572eRCwFHEvVmNAuLNcPJbpFTDMkUVo0J7
        gcT5/jRuBX7k7kGR1I8JaJUmKPbNfPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-QRu3QYkCPOWwVu-OmUTOQw-1; Fri, 11 Mar 2022 05:46:07 -0500
X-MC-Unique: QRu3QYkCPOWwVu-OmUTOQw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02AE6180FD72;
        Fri, 11 Mar 2022 10:46:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 004C51057FD5;
        Fri, 11 Mar 2022 10:46:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/4] ceph: pass the request to parse_reply_info_readdir()
Date:   Fri, 11 Mar 2022 18:45:55 +0800
Message-Id: <20220311104558.157283-2-xiubli@redhat.com>
In-Reply-To: <20220311104558.157283-1-xiubli@redhat.com>
References: <20220311104558.157283-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8d704ddd7291..c7113ce655a6 100644
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
@@ -3426,14 +3428,14 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
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
 		struct inode *in;
 		struct ceph_vino tvino = {
-- 
2.27.0

