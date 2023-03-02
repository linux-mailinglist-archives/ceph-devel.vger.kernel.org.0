Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F64F6A821C
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 13:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjCBM0y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Mar 2023 07:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBM0x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Mar 2023 07:26:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CF4460A2
        for <ceph-devel@vger.kernel.org>; Thu,  2 Mar 2023 04:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677759969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NdWrTGUE0dYYL5qoUB64us4PLNh0UpOzxT5ebA7srjI=;
        b=d1GLDcefzl1t8N9zBJJATQENXGkj9MUTpvfYCmy/TpekSaik1ADF7h1CP2Zp+dro66l2AU
        vBrRA01uO1M08Q8nDS0oKAPEcXTk+kP/2ukmTZvLjH7RDDrirmnljXVzF5DTCPJ0otel0X
        8iAOkHVx2QnWNfIsdaOe/a+r9m3uxC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-6hLRDCfmOyiI1nZUX9LC9w-1; Thu, 02 Mar 2023 07:26:08 -0500
X-MC-Unique: 6hLRDCfmOyiI1nZUX9LC9w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C47A3811E9C;
        Thu,  2 Mar 2023 12:26:07 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 04CAB1121315;
        Thu,  2 Mar 2023 12:26:04 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4] ceph: do not print the whole xattr value if it's too long
Date:   Thu,  2 Mar 2023 20:25:59 +0800
Message-Id: <20230302122559.501627-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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

At the same time fix the function name issue in the debug logs.

URL: https://tracker.ceph.com/issues/58404
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V4:
- fix the function name issue in the debug logs
- make the logs to be more compact.

 fs/ceph/xattr.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index b10d459c2326..5ab4aed2eecc 100644
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
@@ -623,7 +625,7 @@ static int __set_xattr(struct ceph_inode_info *ci,
 		xattr->should_free_name = update_xattr;
 
 		ci->i_xattrs.count++;
-		dout("__set_xattr count=%d\n", ci->i_xattrs.count);
+		dout("%s count=%d\n", __func__, ci->i_xattrs.count);
 	} else {
 		kfree(*newxattr);
 		*newxattr = NULL;
@@ -651,11 +653,13 @@ static int __set_xattr(struct ceph_inode_info *ci,
 	if (new) {
 		rb_link_node(&xattr->node, parent, p);
 		rb_insert_color(&xattr->node, &ci->i_xattrs.index);
-		dout("__set_xattr_val p=%p\n", p);
+		dout("%s p=%p\n", __func__, p);
 	}
 
-	dout("__set_xattr_val added %llx.%llx xattr %p %.*s=%.*s\n",
-	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len, val);
+	dout("%s added %llx.%llx xattr %p %.*s=%.*s%s\n", __func__,
+	     ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
+	     min(val_len, MAX_XATTR_VAL_PRINT_LEN), val,
+	     val_len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
 
 	return 0;
 }
@@ -681,13 +685,15 @@ static struct ceph_inode_xattr *__get_xattr(struct ceph_inode_info *ci,
 		else if (c > 0)
 			p = &(*p)->rb_right;
 		else {
-			dout("__get_xattr %s: found %.*s\n", name,
-			     xattr->val_len, xattr->val);
+			int len = min(xattr->val_len, MAX_XATTR_VAL_PRINT_LEN);
+
+			dout("%s %s: found %.*s%s\n", __func__, name, len,
+			     xattr->val, xattr->val_len > len ? "..." : "");
 			return xattr;
 		}
 	}
 
-	dout("__get_xattr %s: not found\n", name);
+	dout("%s %s: not found\n", __func__, name);
 
 	return NULL;
 }
-- 
2.31.1

