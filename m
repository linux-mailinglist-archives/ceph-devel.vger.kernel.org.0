Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADB753D2E4
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Jun 2022 22:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346701AbiFCUkC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Jun 2022 16:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiFCUkB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Jun 2022 16:40:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51015590A9
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 13:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822DA61AFA
        for <ceph-devel@vger.kernel.org>; Fri,  3 Jun 2022 20:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7597FC385B8;
        Fri,  3 Jun 2022 20:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654288798;
        bh=ohpUMWwk8KWjJ4D9z8SpOYeYJT5A08PLUYG2doCBO3U=;
        h=From:To:Cc:Subject:Date:From;
        b=k+m0f94WfzVjnRJ/Z+7qcjOpdp4XxyixNsaLIUrHcuWap0YXe61+rORZCMs4kD6Ts
         rc0bSGQlq3m1D5FZMoetGQPxef1dHA+r2tY8GcQeckAXQYiU/ecqYuak9/iCYHZEtS
         55t4WWx/+BW3DKsppJYFb8+fgbNFnGAlSVKq2+h3mav6paZYaJQ4l/QyXokJlB5Hhi
         +PCpEKdI1GBL6WaZApIvLLLf1ucepcezkJxLx4ejSvEg/bvz/vWxzBv5/hwcmzZqLL
         22qRI+NWykNDa5rCX/HClEdbvkO37Zs7ZU1d1eIKZS2PzJo88S370uUDG9uXF/xtno
         fgH7vds0qW+wQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: don't leak snap_rwsem in handle_cap_grant
Date:   Fri,  3 Jun 2022 16:39:57 -0400
Message-Id: <20220603203957.55337-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When handle_cap_grant is called on an IMPORT op, then the snap_rwsem is
held and the function is expected to release it before returning. It
currently fails to do that in all cases which could lead to a deadlock.

URL: https://tracker.ceph.com/issues/55857
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 258093e9074d..0a48bf829671 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3579,24 +3579,23 @@ static void handle_cap_grant(struct inode *inode,
 			fill_inline = true;
 	}
 
-	if (ci->i_auth_cap == cap &&
-	    le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
-		if (newcaps & ~extra_info->issued)
-			wake = true;
+	if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
+		if (ci->i_auth_cap == cap) {
+			if (newcaps & ~extra_info->issued)
+				wake = true;
+
+			if (ci->i_requested_max_size > max_size ||
+			    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
+				/* re-request max_size if necessary */
+				ci->i_requested_max_size = 0;
+				wake = true;
+			}
 
-		if (ci->i_requested_max_size > max_size ||
-		    !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
-			/* re-request max_size if necessary */
-			ci->i_requested_max_size = 0;
-			wake = true;
+			ceph_kick_flushing_inode_caps(session, ci);
 		}
-
-		ceph_kick_flushing_inode_caps(session, ci);
-		spin_unlock(&ci->i_ceph_lock);
 		up_read(&session->s_mdsc->snap_rwsem);
-	} else {
-		spin_unlock(&ci->i_ceph_lock);
 	}
+	spin_unlock(&ci->i_ceph_lock);
 
 	if (fill_inline)
 		ceph_fill_inline_data(inode, NULL, extra_info->inline_data,
-- 
2.36.1

