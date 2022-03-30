Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727994EBA6E
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 07:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbiC3FwH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 01:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237762AbiC3FwF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 01:52:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A51BD193C9
        for <ceph-devel@vger.kernel.org>; Tue, 29 Mar 2022 22:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648619419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Gc4ZSDpgaRCPrQwfm+JdLa0Bj1/4pIFMUWLCFRmSGrE=;
        b=gapiJNJu+KnUGsCufobSif2TV+v1Q9w8RB9Q1e1C/9qesIejJEM+NyZQ6oP9cYWmkpjQb0
        iDE0gFszxitorOQLACTQu1E5SNgiSZSB4JQa5kdWs4ENURNpiLGsREfLfA6WQr3iCzlhcT
        nHxTJ3ZCNIYyD31aBXSpzu8g+Wncuyo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-227-r9bIrSgPNK-3iGBmu-_R6w-1; Wed, 30 Mar 2022 01:50:16 -0400
X-MC-Unique: r9bIrSgPNK-3iGBmu-_R6w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B494E3804079;
        Wed, 30 Mar 2022 05:50:15 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84A2B1121314;
        Wed, 30 Mar 2022 05:50:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: update the dlease for the hashed dentry when removing
Date:   Wed, 30 Mar 2022 13:49:56 +0800
Message-Id: <20220330054956.271022-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The MDS will always refresh the dentry lease when removing the files
or directories. And if the dentry is still hashed, we can update
the dentry lease and no need to do the lookup from the MDS later.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 64b341f5e7bc..8cf55e6e609e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1467,10 +1467,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			} else if (have_lease) {
 				if (d_unhashed(dn))
 					d_add(dn, NULL);
+			}
+
+			if (!d_unhashed(dn) && have_lease)
 				update_dentry_lease(dir, dn,
 						    rinfo->dlease, session,
 						    req->r_request_started);
-			}
 			goto done;
 		}
 
-- 
2.27.0

