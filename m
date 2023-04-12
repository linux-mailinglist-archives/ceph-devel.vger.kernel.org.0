Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FFB6DF2DA
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjDLLPd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjDLLPb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AC9868B
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nr1aAWtciEvh5lMfBblUcJ9h3PvSN5dvkPx3t7UgDlA=;
        b=MVRpXKYQedvxdDGBw/i4zhMpCA9WOKiUZlCTk/Z9b67iD1Kij1JcUEgIaoGdV7t0+vegMD
        mrX60QvQCMoR9VbqYO9mpUMRYeuGi/eWNyz2RRZyu2C6QBFIOWm7e4nrKM8BTcGn+aHwX5
        dyHzXGXV0lf6CtyWVm8Bq3DmdAnUFwk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-_TIvBB4DP_KjFdI_DOJ6dQ-1; Wed, 12 Apr 2023 07:13:28 -0400
X-MC-Unique: _TIvBB4DP_KjFdI_DOJ6dQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D42EA185A794;
        Wed, 12 Apr 2023 11:13:27 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49096C15BB8;
        Wed, 12 Apr 2023 11:13:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 45/71] ceph: add __ceph_get_caps helper support
Date:   Wed, 12 Apr 2023 19:09:04 +0800
Message-Id: <20230412110930.176835-46-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Break out the guts of ceph_get_caps into a helper that takes an inode
and ceph_file_info instead of a file pointer.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 17 ++++++++++++-----
 fs/ceph/super.h |  2 ++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 10e69857f692..6379c0070492 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2952,10 +2952,9 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
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
@@ -2964,7 +2963,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 	if (ret < 0)
 		return ret;
 
-	if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+	if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
 	    fi->filp_gen != READ_ONCE(fsc->filp_gen))
 		return -EBADF;
 
@@ -3017,7 +3016,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 				continue;
 		}
 
-		if ((fi->fmode & CEPH_FILE_MODE_WR) &&
+		if (fi && (fi->fmode & CEPH_FILE_MODE_WR) &&
 		    fi->filp_gen != READ_ONCE(fsc->filp_gen)) {
 			if (ret >= 0 && _got)
 				ceph_put_cap_refs(ci, _got);
@@ -3080,6 +3079,14 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
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
index 355701a1ac70..844b6bed616d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1249,6 +1249,8 @@ extern int ceph_encode_dentry_release(void **p, struct dentry *dn,
 				      struct inode *dir,
 				      int mds, int drop, int unless);
 
+extern int __ceph_get_caps(struct inode *inode, struct ceph_file_info *fi,
+			   int need, int want, loff_t endoff, int *got);
 extern int ceph_get_caps(struct file *filp, int need, int want,
 			 loff_t endoff, int *got);
 extern int ceph_try_get_caps(struct inode *inode,
-- 
2.39.2

