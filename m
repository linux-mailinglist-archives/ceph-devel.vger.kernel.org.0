Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24032AE5D6
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Nov 2020 02:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbgKKB34 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 20:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727275AbgKKB34 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 20:29:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605058195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QbIQmj2ddK9VatUsW1opBLid9g43jhvbe3LrjlDe7AI=;
        b=JVSBVq8/bmUkAP+Cl13QLhQODPxOVYz31PHrR3Rj3LXKxyIC7rSq3tMBNac9CgNBHHB52x
        jRvLg2rLq+A1BhCd9h0IaOSw/tDaRN4jjHt3PViPLe9G9vwAuLVRxXVS1mCO/yo35EMNz5
        XrdtccphC6YOMD5JBVzDkClrYweAPsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-M_YCVXcXMySD2GodKSpvcQ-1; Tue, 10 Nov 2020 20:29:51 -0500
X-MC-Unique: M_YCVXcXMySD2GodKSpvcQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 017DD1882FA0;
        Wed, 11 Nov 2020 01:29:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E60B07512B;
        Wed, 11 Nov 2020 01:29:47 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 1/2] ceph: add status debug file support
Date:   Wed, 11 Nov 2020 09:29:39 +0800
Message-Id: <20201111012940.468289-2-xiubli@redhat.com>
In-Reply-To: <20201111012940.468289-1-xiubli@redhat.com>
References: <20201111012940.468289-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will help list some useful client side info, like the client
entity address/name and blocklisted status, etc.

URL: https://tracker.ceph.com/issues/48057
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c | 20 ++++++++++++++++++++
 fs/ceph/super.h   |  1 +
 2 files changed, 21 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 7a8fbe3e4751..66989c880adb 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -304,11 +304,25 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
 	return 0;
 }
 
+static int status_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_entity_inst *inst = &fsc->client->msgr.inst;
+	struct ceph_entity_addr *client_addr = ceph_client_addr(fsc->client);
+
+	seq_printf(s, "instance: %s.%lld %s/%u\n", ENTITY_NAME(inst->name),
+		   ceph_pr_addr(client_addr), le32_to_cpu(client_addr->nonce));
+	seq_printf(s, "blocklisted: %s\n", fsc->blocklisted ? "true" : "false");
+
+	return 0;
+}
+
 DEFINE_SHOW_ATTRIBUTE(mdsmap);
 DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
 DEFINE_SHOW_ATTRIBUTE(metric);
+DEFINE_SHOW_ATTRIBUTE(status);
 
 
 /*
@@ -394,6 +408,12 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
 						fsc->client->debugfs_dir,
 						fsc,
 						&caps_fops);
+
+	fsc->debugfs_status = debugfs_create_file("status",
+						  0400,
+						  fsc->client->debugfs_dir,
+						  fsc,
+						  &status_fops);
 }
 
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index f097237a5ad3..5138b75923f9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -128,6 +128,7 @@ struct ceph_fs_client {
 	struct dentry *debugfs_bdi;
 	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
 	struct dentry *debugfs_metric;
+	struct dentry *debugfs_status;
 	struct dentry *debugfs_mds_sessions;
 #endif
 
-- 
2.27.0

