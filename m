Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70136DF2BF
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Apr 2023 13:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjDLLMz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Apr 2023 07:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjDLLMy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Apr 2023 07:12:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10AC7EC1
        for <ceph-devel@vger.kernel.org>; Wed, 12 Apr 2023 04:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681297872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V+2eMWyrtN5UzMycRrfA7OT0wxrT9+zFhCg6iiisbG0=;
        b=Qjn48fFdmWwzX/OvXC0MRAu6NXx9tMUXLEbIh4vjFSI4A3TVM0YPuJsYsztMi0o5wu/2ui
        DbgKaSp4h4rA0bLLVxWoMldDvbshyYLWeEvBFxgeRSznYywy6aMXJwxA829f+EDBxnhGJ5
        vURMR3hzehXOm0GvcORorMWvC5/egg4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-VKXseXAZM467nqJrS18saA-1; Wed, 12 Apr 2023 07:11:10 -0400
X-MC-Unique: VKXseXAZM467nqJrS18saA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19DBB28237C4;
        Wed, 12 Apr 2023 11:11:10 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-131.pek2.redhat.com [10.72.12.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B4D7C15BB8;
        Wed, 12 Apr 2023 11:11:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v18 17/71] ceph: add fscrypt ioctls
Date:   Wed, 12 Apr 2023 19:08:36 +0800
Message-Id: <20230412110930.176835-18-xiubli@redhat.com>
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

From: Jeff Layton <jlayton@kernel.org>

We gate most of the ioctls on MDS feature support. The exception is the
key removal and status functions that we still want to work if the MDS's
were to (inexplicably) lose the feature.

For the set_policy ioctl, we take Fs caps to ensure that nothing can
create files in the directory while the ioctl is running. That should
be enough to ensure that the "empty_dir" check is reliable.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
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
2.39.2

