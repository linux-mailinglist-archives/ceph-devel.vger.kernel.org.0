Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED986DF333
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDLL0Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjDLL0X (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:26:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F2A10CF
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UAdvSFv8/gEyGlx7OzHcZCSbz8FqPjAyMJDJXSeTpbE=;
        b=GrD9gv8V7G62Po/V/Bvq4tZqDWq5yhBAu+jNhQ+9gzHS0hkT1aIVgfZmT942hF9z6ydzRG
        rbKFFUqLvn5PjSyddsMKH8wLLh3Br1GGzEkkUnLnNjXj55WAnRSVtgUu9Thd6cQA5oDFY4
        jwRQVEgplrq0Y6sdWO5NeY2bHQyeSgE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-FvgGp7G4ORChlALpuTsOPw-1; Wed, 12 Apr 2023 07:14:58 -0400
X-MC-Unique: FvgGp7G4ORChlALpuTsOPw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67D5F101A531;
        Wed, 12 Apr 2023 11:14:58 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A82F3C15BB8;
        Wed, 12 Apr 2023 11:14:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 64/71] ceph: update documentation regarding snapshot naming limitations
Date:   Wed, 12 Apr 2023 19:09:23 +0800
Message-Id: <20230412110930.176835-65-xiubli@redhat.com>
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
2.39.2

