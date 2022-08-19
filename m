Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EE6599509
	for <lists+ceph-devel@lfdr.de>; Fri, 19 Aug 2022 08:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243277AbiHSGFP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 19 Aug 2022 02:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241228AbiHSGFN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 19 Aug 2022 02:05:13 -0400
X-Greylist: delayed 1305 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Aug 2022 23:05:11 PDT
Received: from mx5.cs.washington.edu (mx5.cs.washington.edu [IPv6:2607:4000:200:11::6a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA89BA9CE
        for <ceph-devel@vger.kernel.org>; Thu, 18 Aug 2022 23:05:11 -0700 (PDT)
Received: from mx5.cs.washington.edu (localhost [IPv6:0:0:0:0:0:0:0:1])
        by mx5.cs.washington.edu (8.17.1/8.17.1/1.26) with ESMTP id 27J5hAdp955071;
        Thu, 18 Aug 2022 22:43:10 -0700
Received: from attu6.cs.washington.edu (attu6.cs.washington.edu [IPv6:2607:4000:200:10:0:0:0:87])
        (authenticated bits=128)
        by mx5.cs.washington.edu (8.17.1/8.17.1/1.26) with ESMTPSA id 27J5hAGC955067
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 18 Aug 2022 22:43:10 -0700
Received: from attu6.cs.washington.edu (localhost [127.0.0.1])
        by attu6.cs.washington.edu (8.15.2/8.15.2/1.23) with ESMTP id 27J5hApO2406723;
        Thu, 18 Aug 2022 22:43:10 -0700
Received: (from klee33@localhost)
        by attu6.cs.washington.edu (8.15.2/8.15.2/Submit/1.2) id 27J5hAcP2406722;
        Thu, 18 Aug 2022 22:43:10 -0700
From:   Kenneth Lee <klee33@uw.edu>
To:     xiubli@redhat.com, idryomov@gmail.com, jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, Kenneth Lee <klee33@uw.edu>
Subject: [PATCH] ceph: Use kcalloc for allocating multiple elements
Date:   Thu, 18 Aug 2022 22:42:55 -0700
Message-Id: <20220819054255.2406633-1-klee33@uw.edu>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Prefer using kcalloc(a, b) over kzalloc(a * b) as this improves
semantics since kcalloc is intended for allocating an array of memory.

Signed-off-by: Kenneth Lee <klee33@uw.edu>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 53cfe026b3ea..1eb2ff0f6bd8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2285,7 +2285,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 		struct ceph_mds_request *req;
 		int i;
 
-		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
 		if (!sessions) {
 			err = -ENOMEM;
 			goto out;
-- 
2.31.1

