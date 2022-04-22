Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD1650BEC7
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Apr 2022 19:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiDVRiV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Apr 2022 13:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232862AbiDVRhj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 22 Apr 2022 13:37:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA41EFDD38
        for <ceph-devel@vger.kernel.org>; Fri, 22 Apr 2022 10:34:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96134B82C14
        for <ceph-devel@vger.kernel.org>; Fri, 22 Apr 2022 17:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1730FC385A0;
        Fri, 22 Apr 2022 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650648553;
        bh=tPpXJiRjwrPxAkGu0ob8DNf13uFiuh1Mq68Yyue0KLc=;
        h=From:To:Cc:Subject:Date:From;
        b=kWEr7/FJogNDKRrMC+Wv5dGnSMZKhn4xGzAHS2omlr3tDf3Bn0EGwIRcDxt1gHe9A
         ryPlCmKg9LtBxmsa/e3mzr4nhn1TTCI3He/9ez8eLR64RS7gLea/dLhc3BTEjmJOCL
         EzUshx0cWVpi36xD4OY8AX5f74dLt5qG7jLFGTVLwhcgjwr2EgeAdvKq9HS0ckaQMk
         voHcRxzmEV8N6qux8GJUIdRSzyQZHpjyTUXF3Sp56QktivGim/YLr+fymaIew3WzvR
         6p3MPtVEwq3up/EFG3ObFrsvH6Fs3mON9uz6j8l1JCZ4PPB7Mlh7uCei7GvXIQFCpU
         p04U89ygQHMyA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH] ceph: fix request refcount leak when session can't be acquired
Date:   Fri, 22 Apr 2022 13:29:11 -0400
Message-Id: <20220422172911.94861-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

...in flush_mdlog_and_wait_mdsc_unsafe_requests.

URL: https://tracker.ceph.com/issues/55411
Fixes: 86bc9a732b7f ("ceph: flush the mdlog for filesystem sync")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Xiubo, feel free to fold this into the original patch so we can avoid
the regression.

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2f17ca3c10b1..1e7df3b2dffd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4790,18 +4790,16 @@ static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *md
 			nextreq = NULL;
 		if (req->r_op != CEPH_MDS_OP_SETFILELOCK &&
 		    (req->r_op & CEPH_MDS_OP_WRITE)) {
-			struct ceph_mds_session *s;
+			struct ceph_mds_session *s = req->r_session;
 
-			/* write op */
-			ceph_mdsc_get_request(req);
-			if (nextreq)
-				ceph_mdsc_get_request(nextreq);
-
-			s = req->r_session;
 			if (!s) {
 				req = nextreq;
 				continue;
 			}
+
+			ceph_mdsc_get_request(req);
+			if (nextreq)
+				ceph_mdsc_get_request(nextreq);
 			s = ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
 
-- 
2.35.1

