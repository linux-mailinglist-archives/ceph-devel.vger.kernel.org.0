Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C645A1242
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiHYNby (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242720AbiHYNbo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5674B14F0
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E5ECB829C5
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1953C433D7;
        Thu, 25 Aug 2022 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434300;
        bh=vCpOnZ9e8raW3HovG7F65eskTaRzQ5MunHLAS1y/nhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmfsHLkN03JbrX6Vqq4u/0PiEhsfJouugy7ASjkMh2+yvqMlnpfpdJhdYC0zCBMLt
         50zNBQQSnvDIx4t6k72NZT1jxvpRaEl1hWaW9xg99O1xAzPxtRyWUDRQixjG4rHywW
         5kZNFZqayBm83ksPbKeM4E8VSKkMeL1e5E5ruTNSuV4VRNTnIyeqZcOQ37d/IoMn8/
         skBxNBbRHpq6xLXOIAUK/pvZmQphWfI9F4H/+nhNoIH1kJAavaI5YSleEr3AjW0EmT
         bQGrw8vrPAuCFAH8zFYWiMCBD1Z6jOD3jtzKHLzW+JXgC7n7H7n6uPmN85xc24ohOy
         3qkd09tvywSpQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 08/29] ceph: add __ceph_get_caps helper support
Date:   Thu, 25 Aug 2022 09:31:11 -0400
Message-Id: <20220825133132.153657-9-jlayton@kernel.org>
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

From: Xiubo Li <xiubli@redhat.com>

Break out the guts of ceph_get_caps into a helper that takes an inode
and ceph_file_info instead of a file pointer.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 19 +++++++++++++------
 fs/ceph/super.h |  2 ++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index e09bc49809cf..443fce066d42 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2977,10 +2977,9 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
  * due to a small max_size, make sure we check_max_size (and possibly
  * ask the mds) so we don't get hung up indefinitely.
  */
-int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
+int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi, int need,
+		    int want, loff_t endoff, int *got)
 {
-	struct ceph_file_info *fi = filp->private_data;
-	struct inode *inode = file_inode(filp);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	int ret, _got, flags;
@@ -2989,7 +2988,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 	if (ret < 0)
 		return ret;
 
-	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+	if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
 	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
 		return -EBADF;
 
@@ -2997,7 +2996,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 
 	while (true) {
 		flags &= CEPH_FILE_MODE_MASK;
-		if (atomic_read(&fi->num_locks))
+		if (fi && atomic_read(&fi->num_locks))
 			flags |= CHECK_FILELOCK;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
@@ -3042,7 +3041,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 				continue;
 		}
 
-		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+		if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
 		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
 			if (ret >= 0 && _got)
 				ceph_put_cap_refs(ci, _got);
@@ -3105,6 +3104,14 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 	return 0;
 }
 
+int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got)
+{
+	struct ceph_file_info *fi = filp->private_data;
+	struct inode *inode = file_inode(filp);
+
+	return __ceph_get_caps(inode, fi, need, want, endoff, got);
+}
+
 /*
  * Take cap refs.  Caller must already know we hold at least one ref
  * on the caps in question or we don't know this is safe.
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b15b455f7d1c..52a99e0aa796 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1239,6 +1239,8 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
 				      struct inode *dir,
 				      int mds, int drop, int unless);
 
+extern int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi,
+			   int need, int want, loff_t endoff, int *got);
 extern int ceph_get_caps(struct file *filp, int need, int want,
 			 loff_t endoff, int *got);
 extern int ceph_try_get_caps(struct inode *inode,
-- 
2.37.2

