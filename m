Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A736651224F
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbiD0TTz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbiD0TTS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3544E38D9D
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA6D4B8294E
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F96DC385AE;
        Wed, 27 Apr 2022 19:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086821;
        bh=lVmRbo/Yqwtaeh9CAL98bk9QWDa/T4bzwxEXkoS7RR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pExlNmvJ4XJyDcxz525ZrBiNDAUBxXh/kJBvmkfVevdWGS9U0EJQaA0dOmbBmrLAc
         OYEukGvurjsXSmjOBdyWeK6Qx3Wxk9RiRR7ihj8zZpptNooAiug1pIlf7UrMH0Aqju
         HXaxqgHzBdzdgptK7eSBoLVzlJ0JZgKX1euSO72C8Lk6+pcPA5QG2EsrmthmWmxrP8
         PD9iWvjB/D/qc+tsCzmJ5xn2T4oM8isTuh6V1noGYg5qiDGE25k6Pe9SHMcJxPwH4m
         J1KCTcOL0CGVG+UDW2DExE6p6VyWbzckBkGErSW860Pa7X2mQZlNxhKC9gWE5c/6ND
         HqgF1aUJDCYng==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 35/64] ceph: add a new ceph.fscrypt.auth vxattr
Date:   Wed, 27 Apr 2022 15:12:45 -0400
Message-Id: <20220427191314.222867-36-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Give the client a way to get at the xattr from userland, mostly for
future debugging purposes.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/xattr.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 58628cef4207..e080116608b2 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -352,6 +352,23 @@ static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
 	return ret;
 }
 
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static bool ceph_vxattrcb_fscrypt_auth_exists(struct ceph_inode_info *ci)
+{
+	return ci->fscrypt_auth_len;
+}
+
+static ssize_t ceph_vxattrcb_fscrypt_auth(struct ceph_inode_info *ci, char *val, size_t size)
+{
+	if (size) {
+		if (size < ci->fscrypt_auth_len)
+			return -ERANGE;
+		memcpy(val, ci->fscrypt_auth, ci->fscrypt_auth_len);
+	}
+	return ci->fscrypt_auth_len;
+}
+#endif /* CONFIG_FS_ENCRYPTION */
+
 #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
 #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
 	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
@@ -500,6 +517,15 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
 		.exists_cb = NULL,
 		.flags = VXATTR_FLAG_READONLY,
 	},
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+	{
+		.name = "ceph.fscrypt.auth",
+		.name_size = sizeof("ceph.fscrypt.auth"),
+		.getxattr_cb = ceph_vxattrcb_fscrypt_auth,
+		.exists_cb = ceph_vxattrcb_fscrypt_auth_exists,
+		.flags = VXATTR_FLAG_READONLY,
+	},
+#endif /* CONFIG_FS_ENCRYPTION */
 	{ .name = NULL, 0 }	/* Required table terminator */
 };
 
-- 
2.35.1

