Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B1A513501
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Apr 2022 15:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346967AbiD1N1I (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347035AbiD1N1H (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 09:27:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C2FAAC93B
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 06:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4GzTt7pRZzJr4xCpAljCLdcIr8IfOyRlL6fggBN7Wx8=;
        b=Ps2P10ld12xyMI6GJAirEpGM9N8EK4j1adQsAzbky+1VZQtNCQU9VofElRl+Ah/3wFkpWc
        0aumY33SNtlQfe2eKzgYXGuw4l5xEUUDHoh4eCCGKd4sjI8jLIf7RjvA5/fz/6HA0S9V4R
        KqIzJ5vnQUS0KmcDlZIQ2So2NXMOdjA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-241-wrdXvaKiN-OIztn-UFb9_w-1; Thu, 28 Apr 2022 09:23:50 -0400
X-MC-Unique: wrdXvaKiN-OIztn-UFb9_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFAC9802819;
        Thu, 28 Apr 2022 13:23:49 +0000 (UTC)
Received: from localhost (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 123A3407DEC3;
        Thu, 28 Apr 2022 13:23:48 +0000 (UTC)
From:   Xiubo Li <xiubli@redhat.com>
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: don't retain the caps if they're being revoked and not used
Date:   Thu, 28 Apr 2022 21:23:44 +0800
Message-Id: <20220428132344.94413-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For example if the Frwcb caps are being revoked, but only the Fr
caps is still being used then the kclient will skip releasing them
all. But in next turn if the Fr caps is ready to be released the
Fw caps maybe just being used again. So in corner case, such as
heavy load IOs, the revocation maybe stuck for a long time.

URL: https://tracker.ceph.com/issues/46904
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 22dae29be64d..bf9243795f3b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1978,6 +1978,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 		}
 	}
 
+	/*
+	 * Do not retain the capabilities if they are being revoked
+	 * but not used, this could help speed up the revoking.
+	 */
+	retain &= ~(revoking & ~used);
+
 	dout("check_caps %llx.%llx file_want %s used %s dirty %s flushing %s"
 	     " issued %s revoking %s retain %s %s%s\n", ceph_vinop(inode),
 	     ceph_cap_string(file_wanted),
-- 
2.36.0.rc1

