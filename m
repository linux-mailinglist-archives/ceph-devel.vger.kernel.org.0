Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C464F7E89
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 14:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238308AbiDGMEc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 08:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiDGMEa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 08:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D264BF52D
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 05:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C5161EE9
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEB8C385A4;
        Thu,  7 Apr 2022 12:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649332949;
        bh=CPa5JPmMCr2as2BhwpEOLP8cez+M0rhvf4j7pKVjsMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTuebCXLPwv12472hf9b9c+j5UxzczO0hACqxTvomMIJJ+nO0gDErfd3c+dEVxmqh
         nOirJvXAKW6paF3KIEUq1Hc9l2KYzg6j+9iKil8O4nnWU1rO+4A9U65K2WM6NF9wZ8
         GDHVJImB20B0v1AFYgSB28y5a9gFEaJABCssTCmawKHnOksz0z8rWQWc/Y5bUTVb6l
         dqqWy8uOk/g+oUt5z5mQaDDxF62KU2LUZjHF36q4S10i24rrTQN99k9LXX+aXA5u+r
         6WKWLI6w2hiKL+jr+myRsTayO3WS8GF2gybZdLI0lM1naZI1rlu7ad+eBZxBWlbSwr
         IRnwgBIGGrLvQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, dhowells@redhat.com
Cc:     idryomov@gmail.com, xiubli@redhat.com, linux-cachefs@redhat.com
Subject: [RFC PATCH 4/5] ceph: enhance dout messages in issue_read codepaths
Date:   Thu,  7 Apr 2022 08:02:23 -0400
Message-Id: <20220407120224.76156-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407120224.76156-1-jlayton@kernel.org>
References: <20220407120224.76156-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e7a7b5d29c7d..0726494a0981 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -190,6 +190,8 @@ static bool ceph_netfs_clamp_length(struct netfs_io_subrequest *subreq)
 	/* Truncate the extent at the end of the current block */
 	ceph_calc_file_object_mapping(&ci->i_layout, subreq->start, subreq->len,
 				      &objno, &objoff, &xlen);
+	dout("%s: subreq->len=0x%zx xlen=0x%x rsize=0x%x",
+		__func__, subreq->len, xlen, fsc->mount_options->rsize);
 	subreq->len = min(xlen, fsc->mount_options->rsize);
 	return true;
 }
@@ -302,7 +304,9 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 		goto out;
 	}
 
-	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
+	dout("%s: pos=%llu orig_len=%zu len=%llu debug_id=%x debug_idx=%hx iter->count=%zx\n",
+		__func__, subreq->start, subreq->len, len, rreq->debug_id,
+		subreq->debug_index, iov_iter_count(&subreq->iter));
 
 	err = iov_iter_get_pages_alloc(&subreq->iter, &pages, len, &page_off);
 	if (err < 0) {
-- 
2.35.1

