Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B444C6C604E
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbjCWHBr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjCWHBZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:01:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE34768C
        for <ceph-devel@vger.kernel.org>; Thu, 23 Mar 2023 00:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LiujxA5yBG8deYes9+qkyCWWOyvmIOH0rKnGxKUari0=;
        b=RdHYa87GiIXsYvkTy9wJGhkQ7/QWcZrZs+H15J8+8Tola+srf/G7GXcdm640RjeFK8dC1a
        UO3efSeEg566O3PNQgJAxI4gTDig/xGN97Xob8pHoFn2hUSDk7F7Kdl9N4bNzCgNHJkMwM
        JJqBfi5n7k7MJsBBx+4Yliw1Lyfp+zw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-Ve9OIPoPMUmIA16jVETGQQ-1; Thu, 23 Mar 2023 02:59:27 -0400
X-MC-Unique: Ve9OIPoPMUmIA16jVETGQQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72E643C0F199;
        Thu, 23 Mar 2023 06:59:27 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A72F4492B01;
        Thu, 23 Mar 2023 06:59:24 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 66/71] ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
Date:   Thu, 23 Mar 2023 14:55:20 +0800
Message-Id: <20230323065525.201322-67-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index be3936b28f57..1cfcbc39f7c6 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -3012,8 +3012,12 @@ int ceph_getattr(struct mnt_idmap *idmap, const struct path *path,
 			stat->nlink = 1 + 1 + ci->i_subdirs;
 	}
 
-	stat->attributes_mask |= STATX_ATTR_CHANGE_MONOTONIC;
 	stat->attributes |= STATX_ATTR_CHANGE_MONOTONIC;
+	if (IS_ENCRYPTED(inode))
+		stat->attributes |= STATX_ATTR_ENCRYPTED;
+	stat->attributes_mask |= (STATX_ATTR_CHANGE_MONOTONIC |
+				  STATX_ATTR_ENCRYPTED);
+
 	stat->result_mask = request_mask & valid_mask;
 	return err;
 }
-- 
2.31.1

