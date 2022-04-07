Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7CB4F7E87
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiDGMEb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 08:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiDGME3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 08:04:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478AA6E2AE
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 05:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E95EFB8272A
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5A7C385A8;
        Thu,  7 Apr 2022 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649332947;
        bh=IeQVMOtimVfHvfj7snNyZbLzYVRMMEd3hffcCETApJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=epHt4bh3dbz0aBAsUkqAmRNVIy58dhs08u3QNOgcnTBgYSeWHK0f9HCRrGBNcDhk3
         YxoLEHtyXJFFFAbnO4878pZ6F5Gw0idYev8ntt2+Gx7nlhI+78vTLtZSZAV3fpGPUq
         FMBph2vo3LuWX/Y1/6nF3E+oZSSmLeGe5R5PHCP5wp9GPmg7z+5V/ViNyNr87/UTKx
         DJj/60fNNFKQX2HnSG+uibNe5njNY86qngnjtZ0MReilYP+aMzsWIv7ZnmYjRIT8q5
         ZYMIsXkSzvdebZnlAdnvL3GLkCDY0u7G0aelmvT1ibvG8m3qoLs79j0W9pThIkfkRR
         O36BRer5brf8A==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, dhowells@redhat.com
Cc:     idryomov@gmail.com, xiubli@redhat.com, linux-cachefs@redhat.com
Subject: [RFC PATCH 1/5] netfs: don't error out on short DIO reads
Date:   Thu,  7 Apr 2022 08:02:20 -0400
Message-Id: <20220407120224.76156-2-jlayton@kernel.org>
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

There's no reason that userland can't request to read beyond the EOF. A
short read is expected in that situation.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/netfs/io.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/netfs/io.c b/fs/netfs/io.c
index aaaafc3e1601..b94f2d27127e 100644
--- a/fs/netfs/io.c
+++ b/fs/netfs/io.c
@@ -728,11 +728,6 @@ ssize_t netfs_begin_read(struct netfs_io_request *rreq, bool sync)
 		}
 
 		ret = rreq->error;
-		if (ret == 0 && rreq->submitted < rreq->len &&
-		    rreq->origin == NETFS_DIO_READ) {
-			trace_netfs_failure(rreq, NULL, ret, netfs_fail_short_read);
-			ret = -EIO;
-		}
 		if (ret == 0)
 			ret = netfs_dio_copy_to_dest(rreq);
 		if (ret == 0) {
-- 
2.35.1

