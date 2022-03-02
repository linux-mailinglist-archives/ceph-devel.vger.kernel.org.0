Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBBC4CA933
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 16:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiCBPie (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 10:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiCBPid (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 10:38:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BEE4666B
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0052BB82035
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 15:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61872C004E1;
        Wed,  2 Mar 2022 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646235465;
        bh=75aV2bHavbZb0zvDFn5M11UWAQrfK4p8c/lq2voF5O0=;
        h=From:To:Cc:Subject:Date:From;
        b=BO/jdyLlKcihfJ1ZMkSnA855OExnwbgwcvRsHahtMDYfBD8T/rqNbL0FKun/1tklF
         Yr2pBqJwBva2UXgqETBhXm43RU+4Ievss5/EncHtxLtMPclNI1lb3Kem/g5CgHO/mE
         6ljgyhMOk3VzLUvUlSSpox5xY0x7DcwPJu7YgLifmreUeNFbWGHvJupTizK4eAGceo
         Ytdib0qdH1RRAkO9DdV0+hDN87xtmjmgbsJRZiNoN7nwop0gx+VIdjYyfX3ul/aDE/
         wOzv1ZRwv/cLCF0cULT66psP1CKApoAKTOnlHAaFi2q9aP5fYGysxSeLa+HJvUbDSp
         6lROIRtwojgig==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com
Subject: [PATCH] libceph: fix last_piece calculation in ceph_msg_data_pages_advance
Date:   Wed,  2 Mar 2022 10:37:44 -0500
Message-Id: <20220302153744.43541-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's possible we'll have less than a page's worth of residual data, that
is stradding the last two pages in the array. That will make it
incorrectly set the last_piece boolean when it shouldn't.

Account for a non-zero cursor->page_offset when advancing.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..3f8453773cc8 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -894,10 +894,9 @@ static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
 		return false;   /* no more data */
 
 	/* Move on to the next page; offset is already at 0 */
-
 	BUG_ON(cursor->page_index >= cursor->page_count);
 	cursor->page_index++;
-	cursor->last_piece = cursor->resid <= PAGE_SIZE;
+	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
 
 	return true;
 }
-- 
2.35.1

