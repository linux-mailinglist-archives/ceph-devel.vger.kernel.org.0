Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55A3602343
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Oct 2022 06:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJREbV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Oct 2022 00:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJREbR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Oct 2022 00:31:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47BC9E68F
        for <ceph-devel@vger.kernel.org>; Mon, 17 Oct 2022 21:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666067473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fdS84d4qEHZZq58iK8XVRGrVGPr+9GJ/E8plC2pzTIY=;
        b=Z6v+LwVn/LRCHBPxLQq07bw5DyCALbKIiaak6ZHaoNSbatE0Y+gufZPX5kXQEKSHGHNCmb
        KQsCfB0FNT8MZkwLVUpry+wnq9gn3XiDIqysy5vlDOt5nKI1E9wFtssj5dPVf1CJkHneTn
        YZIeZOiUPVuyJSMY+XePk1XDxcJ4Dxw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-tEXjoNFKO8GiQkczLro6qw-1; Tue, 18 Oct 2022 00:31:09 -0400
X-MC-Unique: tEXjoNFKO8GiQkczLro6qw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91E15185A7A8;
        Tue, 18 Oct 2022 04:31:09 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CFF0492B0A;
        Tue, 18 Oct 2022 04:31:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: try to check caps immediately after async creating finishes
Date:   Tue, 18 Oct 2022 12:30:57 +0800
Message-Id: <20221018043057.24912-3-xiubli@redhat.com>
In-Reply-To: <20221018043057.24912-1-xiubli@redhat.com>
References: <20221018043057.24912-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

We should call the check_caps() again immediately after the async
creating finishes in case the MDS is waiting for caps revocation
to finish.

URL: https://tracker.ceph.com/issues/46904
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c  | 2 ++
 fs/ceph/file.c  | 9 +++++++++
 fs/ceph/super.h | 1 +
 3 files changed, 12 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5e5b0c696584..894adfb4a092 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1967,6 +1967,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
+		ci->i_ceph_flags |= CEPH_I_ASYNC_CHECK_CAPS;
+
 		/* Don't send messages until we get async create reply */
 		spin_unlock(&ci->i_ceph_lock);
 		return;
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index eb34da31600d..85afcbbb5648 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -539,14 +539,23 @@ static void wake_async_create_waiters(struct inode *inode,
 				      struct ceph_mds_session *session)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
+	bool check_cap = false;
 
 	spin_lock(&ci->i_ceph_lock);
 	if (ci->i_ceph_flags & CEPH_I_ASYNC_CREATE) {
 		ci->i_ceph_flags &= ~CEPH_I_ASYNC_CREATE;
 		wake_up_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT);
+
+		if (ci->i_ceph_flags & CEPH_I_ASYNC_CHECK_CAPS) {
+			ci->i_ceph_flags &= ~CEPH_I_ASYNC_CHECK_CAPS;
+			check_cap = true;
+		}
 	}
 	ceph_kick_flushing_inode_caps(session, ci);
 	spin_unlock(&ci->i_ceph_lock);
+
+	if (check_cap)
+		ceph_check_caps(ci, CHECK_CAPS_FLUSH);
 }
 
 static void ceph_async_create_cb(struct ceph_mds_client *mdsc,
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index cff419f63e51..7b75a84ba48d 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -607,6 +607,7 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 #define CEPH_ASYNC_CREATE_BIT	(12)	  /* async create in flight for this */
 #define CEPH_I_ASYNC_CREATE	(1 << CEPH_ASYNC_CREATE_BIT)
 #define CEPH_I_SHUTDOWN		(1 << 13) /* inode is no longer usable */
+#define CEPH_I_ASYNC_CHECK_CAPS	(1 << 14) /* check caps immediately after async creating finishes */
 
 /*
  * Masks of ceph inode work.
-- 
2.31.1

