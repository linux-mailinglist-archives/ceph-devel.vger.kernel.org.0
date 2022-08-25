Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062DC5A123C
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiHYNbm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbiHYNbj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D40CAE9F7
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE75761D09
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B9FC433B5;
        Thu, 25 Aug 2022 13:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434297;
        bh=vKzkfT404WHJg0OkfSlmbbucJYpZloA5zbYvCmu60Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cqezHLbur3Lf+YhejesrctBjBHHhbhdUdLbcZfK1PZOFq1iWdVlSG3ICRz0DgKq4s
         V/UCbSLVDomI7M9CVegfnUc3Q9CiTTWJmC9LOHFlzFIfKUCa7dBCWAp5fE7NRspujh
         +RBC850EkpKajRyG7SR1cNMha+LVakKhVL5PvJr44B22/pLq7CM8QWT+bpbxdBzlpd
         g7uHnqjXDNrCk8lNnUdJRnhM9EFuZOBd83pVLRsdJr3+LHBzo7KPf9uI/w0PBFBEPT
         ZLa+sLvq+HizjWGBUHbWlw4M/tUYioajwR99Hu/QR2eRzG4bmHAPtliCec+dpqvQGD
         WkNERRpskMzFQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 04/29] ceph: fscrypt_file field handling in MClientRequest messages
Date:   Thu, 25 Aug 2022 09:31:07 -0400
Message-Id: <20220825133132.153657-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For encrypted inodes, transmit a rounded-up size to the MDS as the
normal file size and send the real inode size in fscrypt_file field.

Also, fix up creates and truncates to also transmit fscrypt_file.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c        |  3 +++
 fs/ceph/file.c       |  1 +
 fs/ceph/inode.c      | 18 ++++++++++++++++--
 fs/ceph/mds_client.c |  9 ++++++++-
 fs/ceph/mds_client.h |  2 ++
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index b136fb923b7a..59df878a4df7 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -914,6 +914,9 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 		goto out_req;
 	}
 
+	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
+		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+
 	req->r_dentry = dget(dentry);
 	req->r_num_caps = 2;
 	req->r_parent = dir;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 86265713a743..0dba7ec67449 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -785,6 +785,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	req->r_parent = dir;
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
+		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
 		if (!fscrypt_has_encryption_key(dir)) {
 			spin_lock(&dentry->d_lock);
 			dentry->d_flags |= DCACHE_NOKEY_NAME;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 4db4394912e7..67a2421ed092 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2390,11 +2390,25 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 			}
 		} else if ((issued & CEPH_CAP_FILE_SHARED) == 0 ||
 			   attr->ia_size != isize) {
-			req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
-			req->r_args.setattr.old_size = cpu_to_le64(isize);
 			mask |= CEPH_SETATTR_SIZE;
 			release |= CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL |
 				   CEPH_CAP_FILE_RD | CEPH_CAP_FILE_WR;
+			if (IS_ENCRYPTED(inode) && attr->ia_size) {
+				set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
+				mask |= CEPH_SETATTR_FSCRYPT_FILE;
+				req->r_args.setattr.size =
+					cpu_to_le64(round_up(attr->ia_size,
+							     CEPH_FSCRYPT_BLOCK_SIZE));
+				req->r_args.setattr.old_size =
+					cpu_to_le64(round_up(isize,
+							     CEPH_FSCRYPT_BLOCK_SIZE));
+				req->r_fscrypt_file = attr->ia_size;
+				/* FIXME: client must zero out any partial blocks! */
+			} else {
+				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
+				req->r_args.setattr.old_size = cpu_to_le64(isize);
+				req->r_fscrypt_file = 0;
+			}
 		}
 	}
 	if (ia_valid & ATTR_MTIME) {
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e3683305445c..9518ac8e407d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2830,7 +2830,12 @@ static void encode_mclientrequest_tail(void **p, const struct ceph_mds_request *
 	} else {
 		ceph_encode_32(p, 0);
 	}
-	ceph_encode_32(p, 0); // fscrypt_file for now
+	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags)) {
+		ceph_encode_32(p, sizeof(__le64));
+		ceph_encode_64(p, req->r_fscrypt_file);
+	} else {
+		ceph_encode_32(p, 0);
+	}
 }
 
 /*
@@ -2916,6 +2921,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 
 	/* fscrypt_file */
 	len += sizeof(u32);
+	if (test_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags))
+		len += sizeof(__le64);
 
 	msg = ceph_msg_new2(CEPH_MSG_CLIENT_REQUEST, len, 1, GFP_NOFS, false);
 	if (!msg) {
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 728b7d72bf76..81a1f9a4ac3b 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -282,6 +282,7 @@ struct ceph_mds_request {
 #define CEPH_MDS_R_DID_PREPOPULATE	(6) /* prepopulated readdir */
 #define CEPH_MDS_R_PARENT_LOCKED	(7) /* is r_parent->i_rwsem wlocked? */
 #define CEPH_MDS_R_ASYNC		(8) /* async request */
+#define CEPH_MDS_R_FSCRYPT_FILE		(9) /* must marshal fscrypt_file field */
 	unsigned long	r_req_flags;
 
 	struct mutex r_fill_mutex;
@@ -289,6 +290,7 @@ struct ceph_mds_request {
 	union ceph_mds_request_args r_args;
 
 	struct ceph_fscrypt_auth *r_fscrypt_auth;
+	u64	r_fscrypt_file;
 
 	u8 *r_altname;		    /* fscrypt binary crypttext for long filenames */
 	u32 r_altname_len;	    /* length of r_altname */
-- 
2.37.2

