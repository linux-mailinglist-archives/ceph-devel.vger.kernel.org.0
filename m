Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4AE72D955
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240196AbjFMFgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240181AbjFMFf0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:35:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C652F294F
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yOQ5pbAqsLoYpGVWafq0V3DWcaZiJqTd568F6upLExY=;
        b=CdOY6NwQNuutEDY/zLQGe6qZmxn9sqUaxJpkXdlaJrxutzSIqfBvmznknG+fEzpbMD/enC
        gPOXGrb1juVNQ73rs1/MNafy54zyhEaZ7Zo7OM9opHsoI6o+rYRZ1Tt7KbhnwRpo2Ckgr6
        Sl/6Iuz986WIthZSb5vz6RyZHpKYb7U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-alXPV3UmN-uGzaEM_JGJ_w-1; Tue, 13 Jun 2023 01:31:22 -0400
X-MC-Unique: alXPV3UmN-uGzaEM_JGJ_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85C5080120A;
        Tue, 13 Jun 2023 05:31:22 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 197851121315;
        Tue, 13 Jun 2023 05:31:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 64/71] ceph: update documentation regarding snapshot naming limitations
Date:   Tue, 13 Jun 2023 13:24:17 +0800
Message-Id: <20230613052424.254540-65-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 Documentation/filesystems/ceph.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
index 76ce938e7024..085f309ece60 100644
--- a/Documentation/filesystems/ceph.rst
+++ b/Documentation/filesystems/ceph.rst
@@ -57,6 +57,16 @@ a snapshot on any subdirectory (and its nested contents) in the
 system.  Snapshot creation and deletion are as simple as 'mkdir
 .snap/foo' and 'rmdir .snap/foo'.
 
+Snapshot names have two limitations:
+
+* They can not start with an underscore ('_'), as these names are reserved
+  for internal usage by the MDS.
+* They can not exceed 240 characters in size.  This is because the MDS makes
+  use of long snapshot names internally, which follow the format:
+  `_<SNAPSHOT-NAME>_<INODE-NUMBER>`.  Since filenames in general can't have
+  more than 255 characters, and `<node-id>` takes 13 characters, the long
+  snapshot names can take as much as 255 - 1 - 1 - 13 = 240.
+
 Ceph also provides some recursive accounting on directories for nested
 files and bytes.  That is, a 'getfattr -d foo' on any directory in the
 system will reveal the total number of nested regular files and
-- 
2.40.1

