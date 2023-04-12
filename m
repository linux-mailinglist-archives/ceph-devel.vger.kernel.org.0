Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BED416DF2FB
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDLLRZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDLLRO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD32172A8
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zpyrtxc50S84feY2qqgq6AjYWH+7xLd91XiywEtGGcA=;
        b=E/jqPhC5hzR7sO/GTpm9i9k+Gleu1cdLeXpxVz8JQOS5TUp7z86tlJg7g9hTcrvwT4QnGk
        3fKPRF2GGLwz2+dcYxIH16GR9Fi0rTT62++IZ6DEymBzkAHOMV6m5IFkJHyoAmnElXuVaC
        YsiCL43Xu7FRC1+UnTU0REJbIgwMlsk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-WhqRQa2BNiWq-PYaRqEoCQ-1; Wed, 12 Apr 2023 07:15:08 -0400
X-MC-Unique: WhqRQa2BNiWq-PYaRqEoCQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 379E888646E;
        Wed, 12 Apr 2023 11:15:08 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97E60C15E69;
        Wed, 12 Apr 2023 11:15:04 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 66/71] ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
Date:   Wed, 12 Apr 2023 19:09:25 +0800
Message-Id: <20230412110930.176835-67-xiubli@redhat.com>
In-Reply-To: <20230412110930.176835-1-xiubli@redhat.com>
References: <20230412110930.176835-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
2.39.2

