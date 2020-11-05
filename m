Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A3D2A7596
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Nov 2020 03:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732745AbgKEChS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Nov 2020 21:37:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732449AbgKEChS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Nov 2020 21:37:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604543837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=vxLaAOiS9OMcKUlvUrWLAonff1LD/4DpDeLWNSE+F1w=;
        b=Aka7GGCljnsDNvDwKbBol9PGoZTihZj1pU2L4dcDmvcL7YGGjcCR1zIEj89Ry7XJd6G6ZA
        0gULPA0nOfijLg0RSeXx5ZXsPjbDYSt4psKZBR0Ang7nzoBO/LNs7N3qQK36CSljWEizAn
        I+WpvBlRH4xUdssKFHmK3tVYa2a0thE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-r8sVILSkNHC3BsWSvIEwfw-1; Wed, 04 Nov 2020 21:37:14 -0500
X-MC-Unique: r8sVILSkNHC3BsWSvIEwfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77BF41842146;
        Thu,  5 Nov 2020 02:37:13 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-120.gsslab.pek2.redhat.com [10.72.37.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 633675DA71;
        Thu,  5 Nov 2020 02:37:11 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: add CEPH_IOC_GET_FS_CLIENT_IDS ioctl cmd support
Date:   Wed,  4 Nov 2020 21:37:03 -0500
Message-Id: <20201105023703.735882-3-xiubli@redhat.com>
In-Reply-To: <20201105023703.735882-1-xiubli@redhat.com>
References: <20201105023703.735882-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This ioctl will return the dedicated fs and client IDs back to
userspace. With this we can easily know which mountpoint the file
blongs to and also they can help locate the debugfs path quickly.

URL: https://tracker.ceph.com/issues/48124
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/ioctl.c | 22 ++++++++++++++++++++++
 fs/ceph/ioctl.h | 15 +++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 6e061bf62ad4..2498a1df132e 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -268,6 +268,25 @@ static long ceph_ioctl_syncio(struct file *file)
 	return 0;
 }
 
+static long ceph_ioctl_get_client_id(struct file *file, void __user *arg)
+{
+	struct inode *inode = file_inode(file);
+	struct ceph_fs_client *fsc = ceph_sb_to_client(inode->i_sb);
+	struct fs_client_ids ids;
+	char fsid[40];
+
+	snprintf(fsid, sizeof(fsid), "%pU", &fsc->client->fsid);
+	memcpy(ids.fsid, fsid, sizeof(fsid));
+
+	ids.global_id = fsc->client->monc.auth->global_id;
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
@@ -289,6 +308,9 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case CEPH_IOC_SYNCIO:
 		return ceph_ioctl_syncio(file);
+
+	case CEPH_IOC_GET_FS_CLIENT_IDS:
+		return ceph_ioctl_get_client_id(file, (void __user *)arg);
 	}
 
 	return -ENOTTY;
diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
index 51f7f1d39a94..59c7479e77b2 100644
--- a/fs/ceph/ioctl.h
+++ b/fs/ceph/ioctl.h
@@ -98,4 +98,19 @@ struct ceph_ioctl_dataloc {
  */
 #define CEPH_IOC_SYNCIO _IO(CEPH_IOCTL_MAGIC, 5)
 
+/*
+ * CEPH_IOC_GET_FS_CLIENT_IDS - get the fs and client ids
+ *
+ * This ioctl will return the dedicated fs and client IDs back to
+ * userspace. With this we can easily know which mountpoint the file
+ * blongs to and also they can help locate the debugfs path quickly.
+ */
+
+struct fs_client_ids {
+	char fsid[40];
+	__u64 global_id;
+};
+#define CEPH_IOC_GET_FS_CLIENT_IDS _IOR(CEPH_IOCTL_MAGIC, 6, \
+					struct fs_client_ids)
+
 #endif
-- 
2.18.4

