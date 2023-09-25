Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E83C7ACF81
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Sep 2023 07:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbjIYFbn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Sep 2023 01:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbjIYFbm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Sep 2023 01:31:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563EBE8
        for <ceph-devel@vger.kernel.org>; Sun, 24 Sep 2023 22:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695619848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+uGUxfHp02RCcRe6BcbF819hU3YIlzLr1cT6smnWaA=;
        b=g6VE8ldAGbEMyVYXZtgyNbOREoOMt2bUlfh+X9pn3v55Z33IyPR/LBqf1P3zNgbuJiTGTc
        Q2fD2+R44ZVZeJT2U2ncYFAdYFvjxNDvr6uybC2mW4eyJ+cENYehxUiO3ZQ098JXU4RsSs
        GR1WHqMcAMankU91Cc7XNRDLHOXDmME=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-bGoeUqeQPSmND2aeMV_qLA-1; Mon, 25 Sep 2023 01:30:46 -0400
X-MC-Unique: bGoeUqeQPSmND2aeMV_qLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BB611C060C4;
        Mon, 25 Sep 2023 05:30:46 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.123])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD54F51E3;
        Mon, 25 Sep 2023 05:30:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, jlayton@kernel.org, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/3] ceph: always queue a writeback when revoking the Fb caps
Date:   Mon, 25 Sep 2023 13:28:09 +0800
Message-ID: <20230925052810.21914-3-xiubli@redhat.com>
In-Reply-To: <20230925052810.21914-1-xiubli@redhat.com>
References: <20230925052810.21914-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In case there is 'Fw' dirty caps and 'CHECK_CAPS_FLUSH' is set we
will always ignore queue a writeback. Queue a writeback is very
important because it will block kclient flushing the snapcaps to
MDS and which will block MDS waiting for revoking the 'Fb' caps.

URL: https://tracker.ceph.com/issues/50223
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index efa036e7619f..7ce275838007 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2156,6 +2156,30 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 		      ceph_cap_string(cap->implemented),
 		      ceph_cap_string(revoking));
 
+		/* completed revocation? going down and there are no caps? */
+		if (revoking) {
+			if ((revoking & cap_used) == 0) {
+				doutc(cl, "completed revocation of %s\n",
+				      ceph_cap_string(cap->implemented & ~cap->issued));
+				goto ack;
+			}
+
+			/*
+			 * If the "i_wrbuffer_ref" was increased by mmap or generic
+			 * cache write just before the ceph_check_caps() is called,
+			 * the Fb capability revoking will fail this time. Then we
+			 * must wait for the BDI's delayed work to flush the dirty
+			 * pages and to release the "i_wrbuffer_ref", which will cost
+			 * at most 5 seconds. That means the MDS needs to wait at
+			 * most 5 seconds to finished the Fb capability's revocation.
+			 *
+			 * Let's queue a writeback for it.
+			 */
+			if (S_ISREG(inode->i_mode) && ci->i_wrbuffer_ref &&
+			    (revoking & CEPH_CAP_FILE_BUFFER))
+				queue_writeback = true;
+		}
+
 		if (cap == ci->i_auth_cap &&
 		    (cap->issued & CEPH_CAP_FILE_WR)) {
 			/* request larger max_size from MDS? */
@@ -2183,30 +2207,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags)
 			}
 		}
 
-		/* completed revocation? going down and there are no caps? */
-		if (revoking) {
-			if ((revoking & cap_used) == 0) {
-				doutc(cl, "completed revocation of %s\n",
-				      ceph_cap_string(cap->implemented & ~cap->issued));
-				goto ack;
-			}
-
-			/*
-			 * If the "i_wrbuffer_ref" was increased by mmap or generic
-			 * cache write just before the ceph_check_caps() is called,
-			 * the Fb capability revoking will fail this time. Then we
-			 * must wait for the BDI's delayed work to flush the dirty
-			 * pages and to release the "i_wrbuffer_ref", which will cost
-			 * at most 5 seconds. That means the MDS needs to wait at
-			 * most 5 seconds to finished the Fb capability's revocation.
-			 *
-			 * Let's queue a writeback for it.
-			 */
-			if (S_ISREG(inode->i_mode) && ci->i_wrbuffer_ref &&
-			    (revoking & CEPH_CAP_FILE_BUFFER))
-				queue_writeback = true;
-		}
-
 		/* want more caps from mds? */
 		if (want & ~cap->mds_wanted) {
 			if (want & ~(cap->mds_wanted | cap->issued))
-- 
2.39.1

