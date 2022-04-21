Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533A550988C
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 09:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385525AbiDUHGJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 03:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242436AbiDUHGF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 03:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C81E140BE
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 00:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650524595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sDz8PPwEanUm41iQ1KOjhctQANit6asnn9KfttoOvZw=;
        b=QbaPYZbbM7JgmBq531HBmMyKyXVO8Bej+PMoA6swZYFzCs8xCTa2LTM6iiYV82S01QQrY0
        FwE3oIREnJbvJXHy36mpOubHt3UNmvl72hrMZUtoP7W52ILFYsTavIObvW2W0nLYlxnQiE
        bB1/B61QJoX/PhHIW7WASvT+yTBRHOg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-_NCOjJMuOcCgp1TzV3c9xg-1; Thu, 21 Apr 2022 03:03:09 -0400
X-MC-Unique: _NCOjJMuOcCgp1TzV3c9xg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E450485A5A8;
        Thu, 21 Apr 2022 07:03:08 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AA7540D016A;
        Thu, 21 Apr 2022 07:03:07 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: try to choose the auth MDS if possible for getattr
Date:   Thu, 21 Apr 2022 15:03:05 +0800
Message-Id: <20220421070305.140107-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If any 'x' caps is issued we can just choose the auth MDS instead
of the random replica MDSes. Because only when the Locker is in
LOCK_EXEC state will the loner client could get the 'x' caps. And
if we send the getattr requests to any replica MDS it must auth pin
and tries to rdlock from the auth MDS, and then the auth MDS need
to do the Locker state transition to LOCK_SYNC. And after that the
lock state will change back.

This cost much when doing the Locker state transition and usually
will need to revoke caps from clients.

URL: https://tracker.ceph.com/issues/55240
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  |  4 +++-
 fs/ceph/inode.c | 26 +++++++++++++++++++++++++-
 fs/ceph/super.h |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 02722ac86d73..261bc8bb2ab8 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -256,6 +256,7 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 	struct iov_iter iter;
 	ssize_t err = 0;
 	size_t len;
+	int mode;
 
 	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 	__clear_bit(NETFS_SREQ_COPY_TO_CACHE, &subreq->flags);
@@ -264,7 +265,8 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 		goto out;
 
 	/* We need to fetch the inline data. */
-	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
+	mode = ceph_try_to_choose_auth_mds(inode, CEPH_STAT_CAP_INLINE_DATA);
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out;
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b45f321910af..d05b91391f17 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2260,6 +2260,30 @@ int ceph_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
 	return err;
 }
 
+int ceph_try_to_choose_auth_mds(struct inode *inode, int mask)
+{
+	int issued = ceph_caps_issued(ceph_inode(inode));
+
+	/*
+	 * If any 'x' caps is issued we can just choose the auth MDS
+	 * instead of the random replica MDSes. Because only when the
+	 * Locker is in LOCK_EXEC state will the loner client could
+	 * get the 'x' caps. And if we send the getattr requests to
+	 * any replica MDS it must auth pin and tries to rdlock from
+	 * the auth MDS, and then the auth MDS need to do the Locker
+	 * state transition to LOCK_SYNC. And after that the lock state
+	 * will change back.
+	 *
+	 * This cost much when doing the Locker state transition and
+	 * usually will need to revoke caps from clients.
+	 */
+	if (((mask & CEPH_CAP_ANY_SHARED) && (issued & CEPH_CAP_ANY_EXCL))
+	    || (mask & CEPH_STAT_RSTAT))
+		return USE_AUTH_MDS;
+	else
+		return USE_ANY_MDS;
+}
+
 /*
  * Verify that we have a lease on the given mask.  If not,
  * do a getattr against an mds.
@@ -2283,7 +2307,7 @@ int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 	if (!force && ceph_caps_issued_mask_metric(ceph_inode(inode), mask, 1))
 			return 0;
 
-	mode = (mask & CEPH_STAT_RSTAT) ? USE_AUTH_MDS : USE_ANY_MDS;
+	mode = ceph_try_to_choose_auth_mds(inode, mask);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, mode);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 73db7f6021f3..669036ebef1e 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -1024,6 +1024,7 @@ static inline void ceph_queue_flush_snaps(struct inode *inode)
 	ceph_queue_inode_work(inode, CEPH_I_WORK_FLUSH_SNAPS);
 }
 
+extern int ceph_try_to_choose_auth_mds(struct inode *inode, int mask);
 extern int __ceph_do_getattr(struct inode *inode, struct page *locked_page,
 			     int mask, bool force);
 static inline int ceph_do_getattr(struct inode *inode, int mask, bool force)
-- 
2.36.0.rc1

