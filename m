Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD88456A510
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Jul 2022 16:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbiGGOIS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Jul 2022 10:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiGGOIR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Jul 2022 10:08:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A70E220E4
        for <ceph-devel@vger.kernel.org>; Thu,  7 Jul 2022 07:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C1E9B82228
        for <ceph-devel@vger.kernel.org>; Thu,  7 Jul 2022 14:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480FBC341C6;
        Thu,  7 Jul 2022 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657202893;
        bh=Y0w1lv9ZggvqyIAv84RejAyHJ3LePUqABz2FRqR6RxM=;
        h=From:To:Cc:Subject:Date:From;
        b=uoq+4rNKGBIspdK5D8bdLZknp6hkagvV9qKg431XidTO3sOri5R83UXkD87xAdTbS
         E2TS94Pa41PAN30KGNoHcTLHtF+bhMok2ShPCFIdKdPk8wYHStjftmCKafFdEEsw/D
         DJe/22pzajlvJH0wiuTSHCYmFIRZzNe73aem7YUL1ILqm+qCgNj9i/3LXoMIvDHc2Y
         NSrHUzyoK7UmAxj9Q9faG24SLCHhwFxB0QmHkyIl59ATKrbli5uK7ujFstcQ+I8LUQ
         QOHrixr1VVpnk7Lp+mv+p37TUIzk5VLFficLXxn5+qkxh+Pev9tQu8Jgrpln7OF3NO
         FJHuEnHGN4EyA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     dhowells@redhat.com, ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH wip-fscrypt] ceph: reset "err = 0" after iov_get_pages_alloc in ceph_netfs_issue_read
Date:   Thu,  7 Jul 2022 10:08:11 -0400
Message-Id: <20220707140811.35155-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Currently, when we call ceph_netfs_issue_read for an encrypted inode,
we'll call iov_iter_get_pages_alloc and assign its result to "err".
Later we'll end up inappropriately calling netfs_subreq_terminated with
that value after submitting the request. Ensure we reset "err = 0;"
after calling iov_iter_get_pages_alloc.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 1 +
 1 file changed, 1 insertion(+)

Probably this should get squashed into the patch that adds fscrypt
support to buffered reads.

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index c713b5491012..64facef79883 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -376,6 +376,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		/* should always give us a page-aligned read */
 		WARN_ON_ONCE(page_off);
 		len = err;
+		err = 0;
 
 		osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
 	} else {
-- 
2.36.1

