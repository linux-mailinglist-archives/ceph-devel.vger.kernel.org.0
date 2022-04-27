Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F3C512251
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiD0TUA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiD0TTT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C26C3F8B7
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EAA7CE2758
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79750C385AA;
        Wed, 27 Apr 2022 19:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086820;
        bh=cDPy0xI578WfkDIktMt8wJvIbPGQCoBzzMq2Fpkpaf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4eN1w4g/6N7hWmhb24jm2FJmDGfWf2TnM9EgpMGdSvA4fTwJemKlJ9CuawaiiqfV
         ZsxVxRiJskU0O4O0dRL4xtyF38O9VjwE/q/xgmZsVMFf2XWlxckJCvERwcauKMjGyV
         CjeeVwrrGLCQDmsgObQ7mNL/c+E9UKoz1ihKx0/K+X0UFMWgPwhhZTGOFJJUtQ4knd
         D6UW2Ub0xiZqtPUzPxgJ5Vsw9xaMIF7xi+uwSHW4dZOJwsMYOBjVgEnr0ZnbsjQo/n
         7hinBm92W9tXzhBq1TXJHWur4GJa7kBd/Vha7vm+BfClyfC3X6HZGHPqu8f6l2NKrM
         KlHYpNGgrfAJg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 34/64] ceph: make ceph_get_name decrypt filenames
Date:   Wed, 27 Apr 2022 15:12:44 -0400
Message-Id: <20220427191314.222867-35-jlayton@kernel.org>
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

When we do a lookupino to the MDS, we get a filename in the trace.
ceph_get_name uses that name directly, so we must properly decrypt
it before copying it to the name buffer.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/export.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
index e0fa66ac8b9f..0ebf2bd93055 100644
--- a/fs/ceph/export.c
+++ b/fs/ceph/export.c
@@ -7,6 +7,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "crypto.h"
 
 /*
  * Basic fh
@@ -534,7 +535,9 @@ static int ceph_get_name(struct dentry *parent, char *name,
 {
 	struct ceph_mds_client *mdsc;
 	struct ceph_mds_request *req;
+	struct inode *dir = d_inode(parent);
 	struct inode *inode = d_inode(child);
+	struct ceph_mds_reply_info_parsed *rinfo;
 	int err;
 
 	if (ceph_snap(inode) != CEPH_NOSNAP)
@@ -546,30 +549,47 @@ static int ceph_get_name(struct dentry *parent, char *name,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	inode_lock(d_inode(parent));
-
+	inode_lock(dir);
 	req->r_inode = inode;
 	ihold(inode);
 	req->r_ino2 = ceph_vino(d_inode(parent));
-	req->r_parent = d_inode(parent);
-	ihold(req->r_parent);
+	req->r_parent = dir;
+	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_num_caps = 2;
 	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	inode_unlock(dir);
 
-	inode_unlock(d_inode(parent));
+	if (err)
+		goto out;
 
-	if (!err) {
-		struct ceph_mds_reply_info_parsed *rinfo = &req->r_reply_info;
+	rinfo = &req->r_reply_info;
+	if (!IS_ENCRYPTED(dir)) {
 		memcpy(name, rinfo->dname, rinfo->dname_len);
 		name[rinfo->dname_len] = 0;
-		dout("get_name %p ino %llx.%llx name %s\n",
-		     child, ceph_vinop(inode), name);
 	} else {
-		dout("get_name %p ino %llx.%llx err %d\n",
-		     child, ceph_vinop(inode), err);
-	}
+		struct fscrypt_str oname = FSTR_INIT(NULL, 0);
+		struct ceph_fname fname = { .dir	= dir,
+					    .name	= rinfo->dname,
+					    .ctext	= rinfo->altname,
+					    .name_len	= rinfo->dname_len,
+					    .ctext_len	= rinfo->altname_len };
+
+		err = ceph_fname_alloc_buffer(dir, &oname);
+		if (err < 0)
+			goto out;
 
+		err = ceph_fname_to_usr(&fname, NULL, &oname, NULL);
+		if (!err) {
+			memcpy(name, oname.name, oname.len);
+			name[oname.len] = 0;
+		}
+		ceph_fname_free_buffer(dir, &oname);
+	}
+out:
+	dout("get_name %p ino %llx.%llx err %d %s%s\n",
+		     child, ceph_vinop(inode), err,
+		     err ? "" : "name ", err ? "" : name);
 	ceph_mdsc_put_request(req);
 	return err;
 }
-- 
2.35.1

