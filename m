Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558F66E3E43
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Apr 2023 05:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjDQDgQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Apr 2023 23:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjDQDfq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Apr 2023 23:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401BA4495
        for <ceph-devel@vger.kernel.org>; Sun, 16 Apr 2023 20:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681702376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m92KZpRjuDUyv1UwiwwDwWWnVAZKqW3UDqCDmWyI2aI=;
        b=YlLN+p5h22f4E6pZUbiGwFUSNXBLB62Tsi+Z8ZUo0DQLG7ijh7RrmeS2OEIPuPmK+6tEQI
        ob4898p4Iw3kHW0M2tr8yaByyijlfeikoTnrmdIBnsHFypEMgg0vljTTvDjMW+fY6bf3v3
        XaGdwXrjQ1eT0CiMNOskVGdt4rS6If0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-tnPCaNXsNkySX_TdnNUJqQ-1; Sun, 16 Apr 2023 23:32:53 -0400
X-MC-Unique: tnPCaNXsNkySX_TdnNUJqQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C1F40811E7C;
        Mon, 17 Apr 2023 03:32:52 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE75F2027044;
        Mon, 17 Apr 2023 03:32:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v19 66/70] ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
Date:   Mon, 17 Apr 2023 11:26:50 +0800
Message-Id: <20230417032654.32352-67-xiubli@redhat.com>
In-Reply-To: <20230417032654.32352-1-xiubli@redhat.com>
References: <20230417032654.32352-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
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
2.39.1

