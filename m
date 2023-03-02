Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228546A7A07
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 04:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCBD1x (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Mar 2023 22:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCBD1w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Mar 2023 22:27:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06BB515C5
        for <ceph-devel@vger.kernel.org>; Wed,  1 Mar 2023 19:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677727619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wyM/JBIMf5j7rF8jtUtiVrN2kum7a02pbbyHHtD9fwY=;
        b=b5HCRdD9v46Ss8NmuNjATMRaC33XbZpHH1sE+ZKkE/vc3ms24z6RLTdQGMWKSDeHxf8T9x
        UqY8QEpbKjaG1ikrqj8fPD/oU8pTaihRAE20S4D24ZY5cY8iFfRiJZwFm3Q1Y6PspRTr0r
        1nTesjbTQ/g0SpNuULJNDsity14njp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-cdczwY77ODWCo16MtCEk1A-1; Wed, 01 Mar 2023 22:26:55 -0500
X-MC-Unique: cdczwY77ODWCo16MtCEk1A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83AD7185A78B;
        Thu,  2 Mar 2023 03:26:55 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B7A002026D4B;
        Thu,  2 Mar 2023 03:26:52 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: do not print the whole xattr value if it's too long
Date:   Thu,  2 Mar 2023 11:26:49 +0800
Message-Id: <20230302032649.407500-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If the xattr's value size is long enough the kernel will warn and
then will fail the xfstests test case.

Just print part of the value string if it's too long.

URL: https://tracker.ceph.com/issues/58404
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- s/MAX_XATTR_VAL/MAX_XATTR_VAL_PRINT_LEN/g
- removed the CCing stable mail list


 fs/ceph/xattr.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index b10d459c2326..25a585e63a2d 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -561,6 +561,8 @@ static struct ceph_vxattr *ceph_match_vxattr(struct inode *inode,
 	return NULL;
 }
 
+#define MAX_XATTR_VAL_PRINT_LEN 256
+
 static int __set_xattr(struct ceph_inode_info *ci,
 			   const char *name, int name_len,
 			   const char *val, int val_len,
@@ -654,8 +656,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		dout("__set_xattr_val p=%p\n", p);
 	}
 
-	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s\n",
-	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val);
+	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s%s\n",
+	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
+	     min(val_len, MAX_XATTR_VAL_PRINT_LEN), val,
+	     val_len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
 
 	return 0;
 }
@@ -681,8 +685,11 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
 		else if (c > 0)
 			p = &(*p)->rb_right;
 		else {
-			dout("__get_xattr %s: found %.*s\n", name,
-			     xattr->val_len, xattr->val);
+			int len = xattr->val_len;
+
+			dout("__get_xattr %s: found %.*s%s\n", name,
+			     min(len, MAX_XATTR_VAL_PRINT_LEN), xattr->val,
+			     len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
 			return xattr;
 		}
 	}
-- 
2.31.1

