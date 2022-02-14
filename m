Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5FC4B4EBF
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Feb 2022 12:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351900AbiBNLe5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Feb 2022 06:34:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351877AbiBNLed (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Feb 2022 06:34:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DCEB41
        for <ceph-devel@vger.kernel.org>; Mon, 14 Feb 2022 03:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4344C60FFC
        for <ceph-devel@vger.kernel.org>; Mon, 14 Feb 2022 11:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8CDC340EF;
        Mon, 14 Feb 2022 11:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644837742;
        bh=Jw0sYcKD2EqMf2Fi1m2CiwHH3mrsEKIAPgHqridxhzo=;
        h=From:To:Cc:Subject:Date:From;
        b=qYx/l8kn/gz0NkTAOXb3eON1bpFRhHoZLarPWvE/pFiy6dSpfJ9XUVKuMQyiwHzyh
         QFgiE+OecO4sVBa5aNeyMvRkIjh4sSmnlet5hoxtsZfa39xDg014qKhK3h3YW2Luxu
         4hLGfHMFkyfWTRHwF1ALRmHdFstxt8q/NdNarI5iIdGEc+WDZ4C0EC9Xd8z/34eRZY
         cMP/6m8f+j5qiuj0eczDpXjtO1aQf5j6OPBkPH9uVSSsdFSjtJRHwe4NGXmBSWedV+
         DuWfpzSAlMtUgzDm53UuEpgZJMfBMwXwr34QAw0WgBqLmL10rOTIJeQDER+j6zQJpf
         T5qeibUmwQ9cw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [PATCH] libceph: drop else branches in prepare_read_data{,_cont}
Date:   Mon, 14 Feb 2022 06:22:21 -0500
Message-Id: <20220214112221.8562-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Just call set_in_bvec in the non-conditional part.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger_v2.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c81379f93ad5..c6e5bfc717d5 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1773,10 +1773,8 @@ static int prepare_read_data(struct ceph_connection *con)
 
 		bv.bv_page = con->bounce_page;
 		bv.bv_offset = 0;
-		set_in_bvec(con, &bv);
-	} else {
-		set_in_bvec(con, &bv);
 	}
+	set_in_bvec(con, &bv);
 	con->v2.in_state = IN_S_PREPARE_READ_DATA_CONT;
 	return 0;
 }
@@ -1807,10 +1805,8 @@ static void prepare_read_data_cont(struct ceph_connection *con)
 		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE)) {
 			bv.bv_page = con->bounce_page;
 			bv.bv_offset = 0;
-			set_in_bvec(con, &bv);
-		} else {
-			set_in_bvec(con, &bv);
 		}
+		set_in_bvec(con, &bv);
 		WARN_ON(con->v2.in_state != IN_S_PREPARE_READ_DATA_CONT);
 		return;
 	}
-- 
2.34.1

