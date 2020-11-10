Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67862AD437
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 11:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgKJK6R (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 05:58:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbgKJK6Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 05:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605005895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RT2wWlNOaYj8NxH2jzmDUY0CkPC8wxKE4ZJH66rdTqE=;
        b=RC0/Uafyv8sI92uuVyn/Gwy0r+iJQYKD0WsBw0a2gl6yp1Hi/f1NdXFmHc4TLzNDZpkj2r
        JPM2N601MhDVlVTxVbolenG7p3RHf82S72/E6Fp/Mr0tXtzm29ZHoP5AEMyUPV25C8DJAG
        RIQ5MPZoIlNTKsDIIQeuQzXh8SFmW8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-crbQAVQAMaOd4Sojxo4eEw-1; Tue, 10 Nov 2020 05:58:12 -0500
X-MC-Unique: crbQAVQAMaOd4Sojxo4eEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0D1C1074654;
        Tue, 10 Nov 2020 10:58:11 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A17B675121;
        Tue, 10 Nov 2020 10:58:09 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/2] ceph: add CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS ioctl cmd support
Date:   Tue, 10 Nov 2020 18:57:55 +0800
Message-Id: <20201110105755.340315-3-xiubli@redhat.com>
In-Reply-To: <20201110105755.340315-1-xiubli@redhat.com>
References: <20201110105755.340315-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This ioctl will return the cluster and client ids back to userspace.
With this we can easily know which mountpoint the file belongs to and
also they can help locate the debugfs path quickly.

URL: https://tracker.ceph.com/issues/48124
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/ioctl.c | 23 +++++++++++++++++++++++
 fs/ceph/ioctl.h | 15 +++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 6e061bf62ad4..a4b69c1026ce 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -268,6 +268,27 @@ static long ceph_ioctl_syncio(struct file *file)
 	return 0;
 }
 
+/*
+ * Return the cluster and client ids
+ */
+static long ceph_ioctl_get_fs_ids(struct file *file, void __user *arg)
+{
+	struct inode *inode = file_inode(file);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct cluster_client_ids ids;
+
+	snprintf(ids.cluster_id, sizeof(ids.cluster_id), "%pU",
+		 &fsc->client->fsid);
+	snprintf(ids.client_id, sizeof(ids.client_id), "client%lld",
+		 ceph_client_gid(fsc->client));
+
+	/* send result back to user */
+	if (copy_to_user(arg, &ids, sizeof(ids)))
+		return -EFAULT;
+
+	return 0;
+}
+
 long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
@@ -289,6 +310,8 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case CEPH_IOC_SYNCIO:
 		return ceph_ioctl_syncio(file);
+	case CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS:
+		return ceph_ioctl_get_fs_ids(file, (void __user *)arg);
 	}
 
 	return -ENOTTY;
diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
index 51f7f1d39a94..9879d58854fb 100644
--- a/fs/ceph/ioctl.h
+++ b/fs/ceph/ioctl.h
@@ -98,4 +98,19 @@ struct ceph_ioctl_dataloc {
  */
 #define CEPH_IOC_SYNCIO _IO(CEPH_IOCTL_MAGIC, 5)
 
+/*
+ * CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS - get the cluster and client ids
+ *
+ * This ioctl will return the cluster and client ids back to user space.
+ * With this we can easily know which mountpoint the file belongs to and
+ * also they can help locate the debugfs path quickly.
+ */
+
+struct cluster_client_ids {
+	char cluster_id[40];
+	char client_id[24];
+};
+#define CEPH_IOC_GET_CLUSTER_AND_CLIENT_IDS _IOR(CEPH_IOCTL_MAGIC, 6, \
+					struct cluster_client_ids)
+
 #endif
-- 
2.27.0

