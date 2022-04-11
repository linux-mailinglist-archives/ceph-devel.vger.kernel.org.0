Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F46C4FB1A1
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Apr 2022 04:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbiDKCOp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 10 Apr 2022 22:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233115AbiDKCOo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 10 Apr 2022 22:14:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 260F1B865
        for <ceph-devel@vger.kernel.org>; Sun, 10 Apr 2022 19:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649643150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YN2uRqvQ/9yLxLK9sIHcX4BfDJK5WbAqCEhaOuQiXvE=;
        b=d1B8w+Gm9ds4l3GOwxpZD55nyV0AE/z727X0aY7WVIuMa2AQ/EU50H7LaI4Gj8NhsZNR47
        sr6jlsrxA4ykNYVpnSwdWSZOnBNouRL4F4LtwyOxh+zWHQ18u/mu5KHkfe2W9Oq0DmpJHc
        kCjaFQqx3XnFKDm8iTjE82udBpy0ADQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-HXE3loZAPrGlKYrH4LR7nw-1; Sun, 10 Apr 2022 22:12:26 -0400
X-MC-Unique: HXE3loZAPrGlKYrH4LR7nw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97A1F1C04B6E;
        Mon, 11 Apr 2022 02:12:26 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F02A40C1438;
        Mon, 11 Apr 2022 02:12:23 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs AT_STATX_FORCE_SYNC check
Date:   Mon, 11 Apr 2022 10:12:07 +0800
Message-Id: <20220411021207.268351-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

From the posix and the initial statx supporting commit comments,
the AT_STATX_DONT_SYNC is a lightweight stat flag and the
AT_STATX_FORCE_SYNC is a heaverweight one. And also checked all
the other current usage about these two flags they are all doing
the same, that is only when the AT_STATX_FORCE_SYNC is not set
and the AT_STATX_DONT_SYNC is set will they skip sync retriving
the attributes from storage.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6788a1f88eb6..1ee6685def83 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2887,7 +2887,7 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		return -ESTALE;
 
 	/* Skip the getattr altogether if we're asked not to sync */
-	if (!(flags & AT_STATX_DONT_SYNC)) {
+	if ((flags & AT_STATX_SYNC_TYPE) != AT_STATX_DONT_SYNC) {
 		err = ceph_do_getattr(inode,
 				statx_to_caps(request_mask, inode->i_mode),
 				flags & AT_STATX_FORCE_SYNC);
-- 
2.27.0

