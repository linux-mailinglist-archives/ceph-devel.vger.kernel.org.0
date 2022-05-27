Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1C8535889
	for <lists+ceph-devel@lfdr.de>; Fri, 27 May 2022 06:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbiE0Elg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 May 2022 00:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiE0Elf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 May 2022 00:41:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 684F4EC3D5
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 21:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653626493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9ji+pgbVJrEcRBIRpMqH8VAq+Id3izssyfBq2MpTDSY=;
        b=dAkbjwj/UhpetW20W/k5C5hyi1N2B7h8COa3FII08lcw+TN8BxQ5n83C+5Kdvp0bvT9LkC
        xhLO35YpuiDVw82XmExQLuQ8RMwDkObMCAPo3o07D+0RVL7PnGswQFepaIWDKTWICxLn2k
        2LNEXuvl3cXiuN1OVFJL5Nz50/cXDdU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-_h7dYTSGPFCzhd2cWT4SsQ-1; Fri, 27 May 2022 00:41:30 -0400
X-MC-Unique: _h7dYTSGPFCzhd2cWT4SsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67B7E811E83;
        Fri, 27 May 2022 04:41:30 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD2DC1121315;
        Fri, 27 May 2022 04:41:29 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: choose auth MDS for getxattr with the Xs caps
Date:   Fri, 27 May 2022 12:41:13 +0800
Message-Id: <20220527044113.953721-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

And for the 'Xs' caps for getxattr we will also choose the auth MDS,
because the MDS side code is buggy due to setxattr won't notify the
replica MDSes when the values changed and the replica MDS will return
the old values. Though we will fix it in MDS code, but this still
makes sense for old ceph.

URL: https://tracker.ceph.com/issues/55331
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 9d1add59bc17..09665b82330e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2276,9 +2276,15 @@ int ceph_try_to_choose_auth_mds(struct inode *inode, int mask)
 	 *
 	 * This cost much when doing the Locker state transition and
 	 * usually will need to revoke caps from clients.
+	 *
+	 * And for the 'Xs' caps for getxattr we will also choose the
+	 * auth MDS, because the MDS side code is buggy due to setxattr
+	 * won't notify the replica MDSes when the values changed and
+	 * the replica MDS will return the old values. Though we will
+	 * fix it in MDS code, but this still makes sense for old ceph.
 	 */
 	if (((mask & CEPH_CAP_ANY_SHARED) && (issued & CEPH_CAP_ANY_EXCL))
-	    || (mask & CEPH_STAT_RSTAT))
+	    || (mask & (CEPH_STAT_RSTAT | CEPH_STAT_CAP_XATTR)))
 		return USE_AUTH_MDS;
 	else
 		return USE_ANY_MDS;
-- 
2.36.0.rc1

