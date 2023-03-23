Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231096C6050
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 08:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbjCWHBw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 03:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjCWHBf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 03:01:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7994C13
        for <ceph-devel@vger.kernel.org>; Thu, 23 Mar 2023 00:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G94oRvHjL3Co0cHnwuIxM5CwftRB1MWIBEmdKPLLu6U=;
        b=W+bmmQGCaQ4vHtVkLEUPGcQhBi+7i0VmNc0zwcsJLjY6Rsrh4BzEpEr15374zx1ZVUGwOF
        YR/6QFtmqGDLEJS1kkIwoH/H1KTg3qzzE96kShyqaJpTnUkbOguZhd781WadEW7X+e4szH
        kthMOJdm+FEHVkpD5n8XOByDLLHrlPE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-1yMOJPgiNW-MffpLFzg0hg-1; Thu, 23 Mar 2023 02:59:21 -0400
X-MC-Unique: 1yMOJPgiNW-MffpLFzg0hg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A55993C0F19A;
        Thu, 23 Mar 2023 06:59:20 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D785A492B01;
        Thu, 23 Mar 2023 06:59:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 64/71] ceph: update documentation regarding snapshot naming limitations
Date:   Thu, 23 Mar 2023 14:55:18 +0800
Message-Id: <20230323065525.201322-65-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Luís Henriques <lhenriques@suse.de>

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
2.31.1

