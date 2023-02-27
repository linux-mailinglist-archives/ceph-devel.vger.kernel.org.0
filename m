Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECF56A398D
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Feb 2023 04:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbjB0DaT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 26 Feb 2023 22:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjB0DaP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 26 Feb 2023 22:30:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4E61B311
        for <ceph-devel@vger.kernel.org>; Sun, 26 Feb 2023 19:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677468565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pnsjUs0HoBdwDuRrwM+CHIrxsyRB0AWr2AENjnaWOI=;
        b=Hge25d3feM1ukmCzs7CTXv+7SBniL26vesRaIrEpaAhW/jxTQBRGoNN9AYmLBBtdA9KKo3
        uD+CHW4CcXHRr9vk9XWySTKn5cuJtKCOleSwOwthy0Lp4QmS4r9t7t0hOoTnTnCWGfpccH
        9flvbpsKGAO7SwckiqUXEdzEsZbuZoI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-ZkxOArZQNim5hD8GV8_nJg-1; Sun, 26 Feb 2023 22:29:21 -0500
X-MC-Unique: ZkxOArZQNim5hD8GV8_nJg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A1C61C051A1;
        Mon, 27 Feb 2023 03:29:21 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 965EF35454;
        Mon, 27 Feb 2023 03:29:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v16 17/68] ceph: add fscrypt ioctls
Date:   Mon, 27 Feb 2023 11:27:22 +0800
Message-Id: <20230227032813.337906-18-xiubli@redhat.com>
In-Reply-To: <20230227032813.337906-1-xiubli@redhat.com>
References: <20230227032813.337906-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

We gate most of the ioctls on MDS feature support. The exception is the
key removal and status functions that we still want to work if the MDS's
were to (inexplicably) lose the feature.

For the set_policy ioctl, we take Fs caps to ensure that nothing can
create files in the directory while the ioctl is running. That should
be enough to ensure that the "empty_dir" check is reliable.

Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/ioctl.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index deac817647eb..2a5c48107026 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -6,6 +6,7 @@
 #include "mds_client.h"
 #include "ioctl.h"
 #include <linux/ceph/striper.h>
+#include <linux/fscrypt.h>
 
 /*
  * ioctls
@@ -268,8 +269,54 @@ static long ceph_ioctl_syncio(struct file *file)
 	return 0;
 }
 
+static int vet_mds_for_fscrypt(struct file *file)
+{
+	int i, ret = -EOPNOTSUPP;
+	struct ceph_mds_client	*mdsc = ceph_sb_to_mdsc(file_inode(file)->i_sb);
+
+	mutex_lock(&mdsc->mutex);
+	for (i = 0; i < mdsc->max_sessions; i++) {
+		struct ceph_mds_session *s = mdsc->sessions[i];
+
+		if (!s)
+			continue;
+		if (test_bit(CEPHFS_FEATURE_ALTERNATE_NAME, &s->s_features))
+			ret = 0;
+		break;
+	}
+	mutex_unlock(&mdsc->mutex);
+	return ret;
+}
+
+static long ceph_set_encryption_policy(struct file *file, unsigned long arg)
+{
+	int ret, got = 0;
+	struct inode *inode = file_inode(file);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+
+	ret = vet_mds_for_fscrypt(file);
+	if (ret)
+		return ret;
+
+	/*
+	 * Ensure we hold these caps so that we _know_ that the rstats check
+	 * in the empty_dir check is reliable.
+	 */
+	ret = ceph_get_caps(file, CEPH_CAP_FILE_SHARED, 0, -1, &got);
+	if (ret)
+		return ret;
+
+	ret = fscrypt_ioctl_set_policy(file, (const void __user *)arg);
+	if (got)
+		ceph_put_cap_refs(ci, got);
+
+	return ret;
+}
+
 long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	int ret;
+
 	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
 	switch (cmd) {
 	case CEPH_IOC_GET_LAYOUT:
@@ -289,6 +336,42 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case CEPH_IOC_SYNCIO:
 		return ceph_ioctl_syncio(file);
+
+	case FS_IOC_SET_ENCRYPTION_POLICY:
+		return ceph_set_encryption_policy(file, arg);
+
+	case FS_IOC_GET_ENCRYPTION_POLICY:
+		ret = vet_mds_for_fscrypt(file);
+		if (ret)
+			return ret;
+		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		ret = vet_mds_for_fscrypt(file);
+		if (ret)
+			return ret;
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		ret = vet_mds_for_fscrypt(file);
+		if (ret)
+			return ret;
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+		return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_NONCE:
+		ret = vet_mds_for_fscrypt(file);
+		if (ret)
+			return ret;
+		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
 	}
 
 	return -ENOTTY;
-- 
2.31.1

