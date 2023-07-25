Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6337608CD
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jul 2023 06:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjGYEnq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jul 2023 00:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjGYEnp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jul 2023 00:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D972E9
        for <ceph-devel@vger.kernel.org>; Mon, 24 Jul 2023 21:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690260179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XTBHP/GYhAsfXVVRoICnnXRMH68zJxdz1aVWfi6j2LI=;
        b=hih2pXGfhbPI0XIEeqexUprhVIJBHeVf3ffbCL6oTmlLgOcY/8Qp6fjRuFFBWqgbFSobif
        B0Gz+DJ02wUAZW3zJ21SaH/OsmFClbuYTsfhmhqNkQam9EL4OX0ZxNJLKBCL1e9+wiqdDU
        WV7AXYPQqjKpPw60hacxtqFBGKDeTxI=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-OrOgDdtyPUyGPy7V5866dg-1; Tue, 25 Jul 2023 00:42:56 -0400
X-MC-Unique: OrOgDdtyPUyGPy7V5866dg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D7D9380673D;
        Tue, 25 Jul 2023 04:42:56 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-127.pek2.redhat.com [10.72.12.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58E7D2014F88;
        Tue, 25 Jul 2023 04:42:53 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: make the members in struct ceph_mds_request_args_ext an union
Date:   Tue, 25 Jul 2023 12:40:24 +0800
Message-Id: <20230725044024.365152-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In ceph mainline it will allow to set the btime in the setattr request
and just add a 'btime' member in the union 'ceph_mds_request_args' and
then bump up the header version to 4. That means the total size of union
'ceph_mds_request_args' will increase sizeof(struct ceph_timespec) bytes,
but in kclient it will increase the sizeof(setattr_ext) bytes for each
request.

Since the MDS will always depend on the header's vesion and front_len
members to decode the 'ceph_mds_request_head' struct, at the same time
kclient hasn't supported the 'btime' feature yet in setattr request,
so it's safe to do this change here.

This will save 48 bytes memories for each request.

Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head structure")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/ceph_fs.h | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index ce6064b3e28f..04f769368605 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -462,17 +462,19 @@ union ceph_mds_request_args {
 } __attribute__ ((packed));
 
 union ceph_mds_request_args_ext {
-	union ceph_mds_request_args old;
-	struct {
-		__le32 mode;
-		__le32 uid;
-		__le32 gid;
-		struct ceph_timespec mtime;
-		struct ceph_timespec atime;
-		__le64 size, old_size;       /* old_size needed by truncate */
-		__le32 mask;                 /* CEPH_SETATTR_* */
-		struct ceph_timespec btime;
-	} __attribute__ ((packed)) setattr_ext;
+	union {
+		union ceph_mds_request_args old;
+		struct {
+			__le32 mode;
+			__le32 uid;
+			__le32 gid;
+			struct ceph_timespec mtime;
+			struct ceph_timespec atime;
+			__le64 size, old_size;       /* old_size needed by truncate */
+			__le32 mask;                 /* CEPH_SETATTR_* */
+			struct ceph_timespec btime;
+		} __attribute__ ((packed)) setattr_ext;
+	};
 };
 
 #define CEPH_MDS_FLAG_REPLAY		1 /* this is a replayed op */
-- 
2.40.1

