Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B454851224D
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbiD0TTx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiD0TTP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC5689333
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98AFFB8291D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF77C385AF;
        Wed, 27 Apr 2022 19:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086813;
        bh=4tZ05g/FJhXyVnjkVAE3L9bGcTJl59SqdTzNrr3EHzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpcO2lPmgStkMnDADQZbW94zvD3A1hgXf1+HOQiWLxEyqJSCiRi1lTZ8irk/yujub
         AA0ndrGPF1wyjtEi3N9Ak7+vDOGS18G5OxcfXgjmPihye2imM0cCZAqd1MkbFiHr33
         Jq8LSP7YotCTtvz04hwEa2+c6HVQ4ZVBqU7CqlMOd9XBWRs7O4eRKOZdlmXbOcXD4d
         KdF9KKJAB5PmuvjSpNMGM6qTjzo7h1LrBSLWqDHFBuOciJXil0VS0cBLAO73MTbBlk
         ikB/Axcp8zTxXsBLYHlkG+uXlm9r5hw8Hwb/Ioc4FNfg9KDjB7AADw0W7zSLpdGzUa
         CVIS2h39ldANw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 23/64] ceph: encode encrypted name in dentry release
Date:   Wed, 27 Apr 2022 15:12:33 -0400
Message-Id: <20220427191314.222867-24-jlayton@kernel.org>
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

Encode encrypted dentry names when sending a dentry release request.
Also add a more helpful comment over ceph_encode_dentry_release.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 32 ++++++++++++++++++++++++++++----
 fs/ceph/mds_client.c | 20 ++++++++++++++++----
 2 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c49053e36112..98230fd58b07 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4622,6 +4622,18 @@ int ceph_encode_inode_release(void **p, struct inode *inode,
 	return ret;
 }
 
+/**
+ * ceph_encode_dentry_release - encode a dentry release into an outgoing request
+ * @p: outgoing request buffer
+ * @dentry: dentry to release
+ * @dir: dir to release it from
+ * @mds: mds that we're speaking to
+ * @drop: caps being dropped
+ * @unless: unless we have these caps
+ *
+ * Encode a dentry release into an outgoing request buffer. Returns 1 if the
+ * thing was released, or a negative error code otherwise.
+ */
 int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 			       struct inode *dir,
 			       int mds, int drop, int unless)
@@ -4654,13 +4666,25 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	if (ret && di->lease_session && di->lease_session->s_mds == mds) {
 		dout("encode_dentry_release %p mds%d seq %d\n",
 		     dentry, mds, (int)di->lease_seq);
-		rel->dname_len = cpu_to_le32(dentry->d_name.len);
-		memcpy(*p, dentry->d_name.name, dentry->d_name.len);
-		*p += dentry->d_name.len;
 		rel->dname_seq = cpu_to_le32(di->lease_seq);
 		__ceph_mdsc_drop_dentry_lease(dentry);
+		spin_unlock(&dentry->d_lock);
+		if (IS_ENCRYPTED(dir) && fscrypt_has_encryption_key(dir)) {
+			int ret2 = ceph_encode_encrypted_fname(dir, dentry, *p);
+
+			if (ret2 < 0)
+				return ret2;
+
+			rel->dname_len = cpu_to_le32(ret2);
+			*p += ret2;
+		} else {
+			rel->dname_len = cpu_to_le32(dentry->d_name.len);
+			memcpy(*p, dentry->d_name.name, dentry->d_name.len);
+			*p += dentry->d_name.len;
+		}
+	} else {
+		spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&dentry->d_lock);
 	return ret;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index cc3c507c03eb..af54a6164bba 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2819,15 +2819,23 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		      req->r_inode ? req->r_inode : d_inode(req->r_dentry),
 		      mds, req->r_inode_drop, req->r_inode_unless,
 		      req->r_op == CEPH_MDS_OP_READDIR);
-	if (req->r_dentry_drop)
-		releases += ceph_encode_dentry_release(&p, req->r_dentry,
+	if (req->r_dentry_drop) {
+		ret = ceph_encode_dentry_release(&p, req->r_dentry,
 				req->r_parent, mds, req->r_dentry_drop,
 				req->r_dentry_unless);
-	if (req->r_old_dentry_drop)
-		releases += ceph_encode_dentry_release(&p, req->r_old_dentry,
+		if (ret < 0)
+			goto out_err;
+		releases += ret;
+	}
+	if (req->r_old_dentry_drop) {
+		ret = ceph_encode_dentry_release(&p, req->r_old_dentry,
 				req->r_old_dentry_dir, mds,
 				req->r_old_dentry_drop,
 				req->r_old_dentry_unless);
+		if (ret < 0)
+			goto out_err;
+		releases += ret;
+	}
 	if (req->r_old_inode_drop)
 		releases += ceph_encode_inode_release(&p,
 		      d_inode(req->r_old_dentry),
@@ -2869,6 +2877,10 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		ceph_mdsc_free_path((char *)path1, pathlen1);
 out:
 	return msg;
+out_err:
+	ceph_msg_put(msg);
+	msg = ERR_PTR(ret);
+	goto out_free2;
 }
 
 /*
-- 
2.35.1

