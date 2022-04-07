Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3E54F820D
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 16:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243244AbiDGOno (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 10:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344099AbiDGOnn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 10:43:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41549C337B
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 07:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649342502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sblOgIOgFZ7F6n4az2asMsTfu3upLhoD+A05zvWNRSY=;
        b=QjPTHXDxSz950OP9HL5BnBGLm8nEeCof+hk72UYNnAseMHMGoWPnkDoZbn6ORH4RmxeBwE
        jB1QllBYWzIcTR7/sFTo37G8U40ljmxiMJuVNYdUIeQRqLckxu1Gdy9WI0aMh8/3r9ec2C
        XwtAQS8V++1nU7t4hQQtpJEsj8D8aFA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-dQYvE42VMhCuDVwTT4kf4w-1; Thu, 07 Apr 2022 10:41:36 -0400
X-MC-Unique: dQYvE42VMhCuDVwTT4kf4w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B9E585A5BE;
        Thu,  7 Apr 2022 14:41:36 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D722F40314D;
        Thu,  7 Apr 2022 14:41:33 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: fix coherency issue when truncating file size for fscrypt
Date:   Thu,  7 Apr 2022 22:41:12 +0800
Message-Id: <20220407144112.8455-3-xiubli@redhat.com>
In-Reply-To: <20220407144112.8455-1-xiubli@redhat.com>
References: <20220407144112.8455-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When truncating the file size the MDS will help update the last
encrypted block, and during this we need to make sure the client
won't fill the pagecaches.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index f4059d73edd5..cc1829ab497d 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -2647,9 +2647,12 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		req->r_num_caps = 1;
 		req->r_stamp = attr->ia_ctime;
 		if (fill_fscrypt) {
+			filemap_invalidate_lock(inode->i_mapping);
 			err = fill_fscrypt_truncate(inode, req, attr);
-			if (err)
+			if (err) {
+				filemap_invalidate_unlock(inode->i_mapping);
 				goto out;
+			}
 		}
 
 		/*
@@ -2660,6 +2663,8 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 		 * it.
 		 */
 		err = ceph_mdsc_do_request(mdsc, NULL, req);
+		if (fill_fscrypt)
+			filemap_invalidate_unlock(inode->i_mapping);
 		if (err == -EAGAIN && truncate_retry--) {
 			dout("setattr %p result=%d (%s locally, %d remote), retry it!\n",
 			     inode, err, ceph_cap_string(dirtied), mask);
-- 
2.27.0

