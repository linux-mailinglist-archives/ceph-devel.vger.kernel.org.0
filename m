Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C8558F9CC
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Aug 2022 11:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiHKJMt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Aug 2022 05:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiHKJMs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 Aug 2022 05:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9979712771
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 02:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660209166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uSZOC4oR6MV0AJUoTsXZrPkIoaQqRnwdg0HDIc/gl8Y=;
        b=aqHrrHYNd2x/POo8dDU63lwwfogW4lN+Ypr+ECZjUEFLzA/4CxqQBITUQDbQw/7l8IopHZ
        A+7HMrDSt1XuCGAP/G4gdJvU2rfuLOJNl1CoUl5rV99A2mLqNNPDrN3apaQUG2VFpwpdey
        6uPhx1GHxv3TbkNxs0j73jvU6QfKqIE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-_PORQFkmPgejxFDAJy3lIg-1; Thu, 11 Aug 2022 05:12:45 -0400
X-MC-Unique: _PORQFkmPgejxFDAJy3lIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10C0F1C01B49
        for <ceph-devel@vger.kernel.org>; Thu, 11 Aug 2022 09:12:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD2B440CF8E7;
        Thu, 11 Aug 2022 09:12:43 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: no need to wait for transition RDCACHE|RD -> RD
Date:   Thu, 11 Aug 2022 17:12:41 +0800
Message-Id: <20220811091241.12251-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For write when trying to get the Fwb caps we need to keep waiting
on transition from WRBUFFER|WR -> WR to avoid a new WR sync write
from going before a prior buffered writeback happens.

Whild for read there is not need to wait on transition from
RDCACHE|RD -> RD, and we can just exclude the revoking caps and
force to sync read.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 139d21b8fb49..d5fc9b1be7c3 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2811,13 +2811,17 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 		 * on transition from wanted -> needed caps.  This is needed
 		 * for WRBUFFER|WR -> WR to avoid a new WR sync write from
 		 * going before a prior buffered writeback happens.
+		 *
+		 * For RDCACHE|RD -> RD, there is not need to wait and we can
+		 * just exclude the revoking caps and force to sync read.
 		 */
 		int not = want & ~(have & need);
 		int revoking = implemented & ~have;
+		int exclude = revoking & not;
 		dout("get_cap_refs %p have %s but not %s (revoking %s)\n",
 		     inode, ceph_cap_string(have), ceph_cap_string(not),
 		     ceph_cap_string(revoking));
-		if ((revoking & not) == 0) {
+		if (!exclude || !(exclude & CEPH_CAP_FILE_BUFFER)) {
 			if (!snap_rwsem_locked &&
 			    !ci->i_head_snapc &&
 			    (need & CEPH_CAP_FILE_WR)) {
@@ -2839,7 +2843,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
 				snap_rwsem_locked = true;
 			}
 			if ((have & want) == want)
-				*got = need | want;
+				*got = need | (want & ~exclude);
 			else
 				*got = need;
 			ceph_take_cap_refs(ci, *got, true);
-- 
2.36.0.rc1

