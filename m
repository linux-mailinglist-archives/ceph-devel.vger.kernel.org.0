Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4375412BD
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 21:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356801AbiFGTyP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 15:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358756AbiFGTxJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 15:53:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324841B607C
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 11:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1B9DB82340
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 18:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF772C34115;
        Tue,  7 Jun 2022 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654626140;
        bh=XJteR8Qgd8BEsQHViSmZb5hDHj6antr299hLmBauua4=;
        h=From:To:Cc:Subject:Date:From;
        b=dLqtmnaONeI+0U3l1YUCuMA4zrhQ2SGmPYtGK0W5rYSZS6TQ7QNFkJ9DQQHUlKgsD
         y54N0qeJiQwyclD0hxZlZNO54fzoQ2SBUpTzWROmG9dVIZoOb1FIFTtO/38ovybzGm
         qz/fj/bciGI12BPLmBjIIOx3EbL3HJ21ffhwgzIbGiB6rOwUf687ixRX4y2KW0LjkR
         oLjdbGnZDhFn3bnAeddahoCWFscz+JxEhWEOl/xIEgngik+q9SrfMS4pJ+oe1ebjBn
         RJLAud73KEa84bwBqmX3w9fuBv3VUZSlzkWtJavjj9x10naa4sJniYsDWstNPVwVUc
         v1j3nt2Uv4QVA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] ceph: call netfs_subreq_terminated with was_async == false
Date:   Tue,  7 Jun 2022 14:22:18 -0400
Message-Id: <20220607182218.234138-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

"was_async" is a bit misleadingly named. It's supposed to indicate
whether it's safe to call blocking operations from the context you're
calling it from, but it sounds like it's asking whether this was done
via async operation. For ceph, this it's always called from kernel
thread context so it should be safe to set this to false.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3489444c55b9..39e2c64d008f 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -241,7 +241,7 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	if (err >= 0 && err < subreq->len)
 		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 
-	netfs_subreq_terminated(subreq, err, true);
+	netfs_subreq_terminated(subreq, err, false);
 
 	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
 	ceph_put_page_vector(osd_data->pages, num_pages, false);
-- 
2.36.1

