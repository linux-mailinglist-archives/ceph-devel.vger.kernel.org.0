Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D994509ACB
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Apr 2022 10:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386718AbiDUIjT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Apr 2022 04:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386742AbiDUIjS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Apr 2022 04:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9BFE5F98
        for <ceph-devel@vger.kernel.org>; Thu, 21 Apr 2022 01:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650530187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jI0AGa+1HVcSYFW6RIX92GLfB0obVIb3RG5rEcsShHA=;
        b=YpLFuIlf2/LnksJq8XkHyzxjYdJsQhzT+k8KoZ/HFcZrYrXICvbYNJSogcg0C/o57BHQGi
        XIwB5nqLFkFKrDb6CPkXCyAqyEI+D41PHvESfnQ01zf65p3p0180eMfIMpc3dtcu5ClSJu
        CTuTuPqEVWZ91tQXGygw4o+nVS/qBk4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-xslRNN8rOi2JOGJXlHAD2w-1; Thu, 21 Apr 2022 04:36:24 -0400
X-MC-Unique: xslRNN8rOi2JOGJXlHAD2w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E0C7802C16;
        Thu, 21 Apr 2022 08:36:24 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8FB3404D2DB;
        Thu, 21 Apr 2022 08:36:23 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: skip reading from Rados if pos exceeds i_size
Date:   Thu, 21 Apr 2022 16:36:19 +0800
Message-Id: <20220421083619.161391-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Since we have held the Fr capibility it's safe to skip reading from
Rados if the ki_pos is larger than or euqals to the file size.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/file.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6c9e837aa1d3..330e42b3afec 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1614,7 +1614,9 @@ static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return ret;
 	}
 
-	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
+	if (unlikely(iocb->ki_pos >= i_size_read(inode))) {
+		ret = 0;
+	} else if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_flags & IOCB_DIRECT) ||
 	    (fi->flags & CEPH_F_SYNC)) {
 
-- 
2.36.0.rc1

