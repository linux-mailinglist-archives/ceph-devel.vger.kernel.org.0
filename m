Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508434B7071
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Feb 2022 17:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbiBOOwP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Feb 2022 09:52:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbiBOOvw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Feb 2022 09:51:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0934F104599
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 06:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E263B81A62
        for <ceph-devel@vger.kernel.org>; Tue, 15 Feb 2022 14:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FC9C340ED;
        Tue, 15 Feb 2022 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644936644;
        bh=9PuPWFxPL/26BXNez/CZyThqPn/tChtK2JXUV2NicIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hm5t6LAkds7oDF+tcWgqzQpVwK7zFYffgYRxQloYZ2CQ9WqNqUklGrfnVR6JOcGSP
         aZkYdBoPom4Fbe5zxRhDaPtm/pgJNxM2HCmqdaiSuzYd/sfPp2ILoLWxuHb44D0kPJ
         dKq141Ak1dbxM+/5tPfzvP0hD41iFLwrLRT1XtfGiz9t6iqYXIA7UDJJkY8c67SjzG
         xcUBSK8+DcwUB9gmUZ3GNtWfS3+zi4TDb24XCJDAfR+zsZxmjhquUwunW6xNDtDPpL
         LI5bD19YVFuW/ShQvaxEhSSvGqI/zPbjq+U20CfdClOCKGeaBogp1JHx4Im0nIQjeu
         RYj3pTxNrvBpA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Subject: [RFC PATCH 1/5] libceph: allow ceph_msg_data_advance to advance more than a page
Date:   Tue, 15 Feb 2022 09:50:37 -0500
Message-Id: <20220215145041.26065-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215145041.26065-1-jlayton@kernel.org>
References: <20220215145041.26065-1-jlayton@kernel.org>
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

In later patches, we're going to need to advance deeper into the data
buffer in order to set up for a sparse read. Rename the existing
routine, and add a wrapper around it that successively calls it until it
has advanced far enougb.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d3bb656308b4..005dd1a5aced 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1084,7 +1084,7 @@ struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
  * Returns true if the result moves the cursor on to the next piece
  * of the data item.
  */
-void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
+static void __ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
 {
 	bool new_piece;
 
@@ -1120,6 +1120,16 @@ void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
 	cursor->need_crc = new_piece;
 }
 
+void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
+{
+	while (bytes) {
+		size_t cur = min(bytes, PAGE_SIZE);
+
+		__ceph_msg_data_advance(cursor, cur);
+		bytes -= cur;
+	}
+}
+
 u32 ceph_crc32c_page(u32 crc, struct page *page, unsigned int page_offset,
 		     unsigned int length)
 {
-- 
2.34.1

