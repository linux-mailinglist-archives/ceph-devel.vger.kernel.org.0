Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44ECE6E3E1B
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjDQDbF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjDQDah (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351E82D4C
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FLSxsnB9ROAn+aUxRN2sI4N+gWcFP4okjMNN0Za2hO8=;
        b=HUWXBXKMe7P7S0Ta3bQu5C3FqV1nG7Pz1XFpTw0CmmkgTmQ4feV0F0Z5u9S/64+kkUjaTy
        jbFVWp2rRlNtc5HLWufH9PP+P6gc/0NyUDJ/fTv0dYZpb1ZCa1c2DB3goWeoczZefyi5H9
        +P1/CVhlCZ6+O1VpDkhrtG8oxjlSZes=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-yg_ku5b5NLWgpakAveeMrA-1; Sun, 16 Apr 2023 23:29:38 -0400
X-MC-Unique: yg_ku5b5NLWgpakAveeMrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A351D1C07581;
        Mon, 17 Apr 2023 03:29:37 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E18B92027062;
        Mon, 17 Apr 2023 03:29:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 28/70] ceph: add fscrypt support to ceph_fill_trace
Date:   Mon, 17 Apr 2023 11:26:12 +0800
Message-Id: <20230417032654.32352-29-xiubli@redhat.com>
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

From: Jeff Layton <jlayton@kernel.org>

When we get a dentry in a trace, decrypt the name so we can properly
instantiate the dentry.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 8b6b12a5a5e2..9a1d8ad9bf86 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1405,8 +1405,15 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		if (dir && req->r_op == CEPH_MDS_OP_LOOKUPNAME &&
 		    test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
 		    !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
+			bool is_nokey = false;
 			struct qstr dname;
 			struct dentry *dn, *parent;
+			struct fscrypt_str oname = FSTR_INIT(NULL, 0);
+			struct ceph_fname fname = { .dir	= dir,
+						    .name	= rinfo->dname,
+						    .ctext	= rinfo->altname,
+						    .name_len	= rinfo->dname_len,
+						    .ctext_len	= rinfo->altname_len };
 
 			BUG_ON(!rinfo->head->is_target);
 			BUG_ON(req->r_dentry);
@@ -1414,8 +1421,20 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			parent = d_find_any_alias(dir);
 			BUG_ON(!parent);
 
-			dname.name = rinfo->dname;
-			dname.len = rinfo->dname_len;
+			err = ceph_fname_alloc_buffer(dir, &oname);
+			if (err < 0) {
+				dput(parent);
+				goto done;
+			}
+
+			err = ceph_fname_to_usr(&fname, NULL, &oname, &is_nokey);
+			if (err < 0) {
+				dput(parent);
+				ceph_fname_free_buffer(dir, &oname);
+				goto done;
+			}
+			dname.name = oname.name;
+			dname.len = oname.len;
 			dname.hash = full_name_hash(parent, dname.name, dname.len);
 			tvino.ino = le64_to_cpu(rinfo->targeti.in->ino);
 			tvino.snap = le64_to_cpu(rinfo->targeti.in->snapid);
@@ -1430,9 +1449,15 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				     dname.len, dname.name, dn);
 				if (!dn) {
 					dput(parent);
+					ceph_fname_free_buffer(dir, &oname);
 					err = -ENOMEM;
 					goto done;
 				}
+				if (is_nokey) {
+					spin_lock(&dn->d_lock);
+					dn->d_flags |= DCACHE_NOKEY_NAME;
+					spin_unlock(&dn->d_lock);
+				}
 				err = 0;
 			} else if (d_really_is_positive(dn) &&
 				   (ceph_ino(d_inode(dn)) != tvino.ino ||
@@ -1444,6 +1469,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 				dput(dn);
 				goto retry_lookup;
 			}
+			ceph_fname_free_buffer(dir, &oname);
 
 			req->r_dentry = dn;
 			dput(parent);
-- 
2.39.1

