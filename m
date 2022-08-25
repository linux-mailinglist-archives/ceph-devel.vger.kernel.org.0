Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5CB5A1249
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 15:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242708AbiHYNb7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 09:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242666AbiHYNbq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 09:31:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4D7B5159
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 06:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4626C61CFD
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 13:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA86C433C1;
        Thu, 25 Aug 2022 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661434303;
        bh=vYpcYlUbLf3+ggMDgN/Gh0P7OxwxcZS0IETVoOa0VIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4c7nyHkM7gQCHrrPlXXQRQPThkAL/kzMlZePq5vvMmvIkRe3zf2iVpMJ2xn93U46
         uv5yhIqqvBKpOkQGy8F7IpPpJC/oIWiuedYZL8DviRVnERIxXGmw2vcBG/NC6aue9T
         roFzooOC6b4bEcFrIlotPjjM8dQ6tUwWfu3DAhw2adV2U5/aWkL1KwENxn9vvDZL03
         g1/WLgZ8ASXLIvGVYsg05bMFkcIb1rD2AQjW7AijPj1yvJk7MuYQHOwQ2LSeafCGzT
         Ma+aJeYyep5NK2/i7Zn4VTSNDDCbyi2ioWyA1ssQssTXI+A48UKKrZXNx8KPO1U/IS
         FZIna3iCOVVOA==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
Subject: [PATCH v15 13/29] libceph: allow ceph_osdc_new_request to accept a multi-op read
Date:   Thu, 25 Aug 2022 09:31:16 -0400
Message-Id: <20220825133132.153657-14-jlayton@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
References: <20220825133132.153657-1-jlayton@kernel.org>
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

Currently we have some special-casing for multi-op writes, but in the
case of a read, we can't really handle it. All of the current multi-op
callers call it with CEPH_OSD_FLAG_WRITE set.

Have ceph_osdc_new_request check for CEPH_OSD_FLAG_READ and if it's set,
allocate multiple reply ops instead of multiple request ops. If neither
flag is set, return -EINVAL.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/osd_client.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 0a33987ae8e9..5b26e3a044ac 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1136,15 +1136,30 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 	if (flags & CEPH_OSD_FLAG_WRITE)
 		req->r_data_offset = off;
 
-	if (num_ops > 1)
+	if (num_ops > 1) {
+		int num_req_ops, num_rep_ops;
+
 		/*
-		 * This is a special case for ceph_writepages_start(), but it
-		 * also covers ceph_uninline_data().  If more multi-op request
-		 * use cases emerge, we will need a separate helper.
+		 * If this is a multi-op write request, assume that we'll need
+		 * request ops. If it's a multi-op read then assume we'll need
+		 * reply ops. Anything else and call it -EINVAL.
 		 */
-		r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_ops, 0);
-	else
+		if (flags & CEPH_OSD_FLAG_WRITE) {
+			num_req_ops = num_ops;
+			num_rep_ops = 0;
+		} else if (flags & CEPH_OSD_FLAG_READ) {
+			num_req_ops = 0;
+			num_rep_ops = num_ops;
+		} else {
+			r = -EINVAL;
+			goto fail;
+		}
+
+		r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_req_ops,
+					       num_rep_ops);
+	} else {
 		r = ceph_osdc_alloc_messages(req, GFP_NOFS);
+	}
 	if (r)
 		goto fail;
 
-- 
2.37.2

