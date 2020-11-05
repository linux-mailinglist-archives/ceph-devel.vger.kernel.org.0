Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658012A7595
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Nov 2020 03:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgKEChQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Nov 2020 21:37:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgKEChQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Nov 2020 21:37:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604543835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=1dSGZzxQu3kNzQMnPsPJADY/Or7m2Kdz7OejkdDIHAc=;
        b=hZQIMIy1pkK4PfP88j7eoAmqxdYSzJPpYvZZDZCPj6cbFDP5iyj/QQbAtgZgv5Fip7+ZgW
        r63Mjwg9Lv0yk/iW+iNs6n83GdvlnvomzzkExniDaDqAXO9uRrJgb0pfVFVsGNeI4Y6XvK
        WShsMRKfGBOz64cjRWtdDfZo058bAAY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-wYaiYFr8PBK3snlmJPqP_g-1; Wed, 04 Nov 2020 21:37:12 -0500
X-MC-Unique: wYaiYFr8PBK3snlmJPqP_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDDCA809DE5;
        Thu,  5 Nov 2020 02:37:10 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (vm37-120.gsslab.pek2.redhat.com [10.72.37.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C75D15D994;
        Thu,  5 Nov 2020 02:37:08 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: add status debug file support
Date:   Wed,  4 Nov 2020 21:37:02 -0500
Message-Id: <20201105023703.735882-2-xiubli@redhat.com>
In-Reply-To: <20201105023703.735882-1-xiubli@redhat.com>
References: <20201105023703.735882-1-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will help list some useful client side info, like the client
entity address/name and bloclisted status, etc.

URL: https://tracker.ceph.com/issues/48057
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c | 22 ++++++++++++++++++++++
 fs/ceph/super.h   |  1 +
 2 files changed, 23 insertions(+)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 7a8fbe3e4751..8b6db73c94ad 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -14,6 +14,7 @@
 #include <linux/ceph/mon_client.h>
 #include <linux/ceph/auth.h>
 #include <linux/ceph/debugfs.h>
+#include <linux/ceph/messenger.h>
 
 #include "super.h"
 
@@ -127,6 +128,20 @@ static int mdsc_show(struct seq_file *s, void *p)
 	return 0;
 }
 
+static int status_show(struct seq_file *s, void *p)
+{
+	struct ceph_fs_client *fsc = s->private;
+	struct ceph_messenger *msgr = &fsc->client->msgr;
+	struct ceph_entity_inst *inst = &msgr->inst;
+
+	seq_printf(s, "status:\n\n"),
+	seq_printf(s, "\tinst_str:\t%s.%lld  %s/%u\n", ENTITY_NAME(inst->name),
+		   ceph_pr_addr(&inst->addr), le32_to_cpu(inst->addr.nonce));
+	seq_printf(s, "\tblocklisted:\t%s\n", fsc->blocklisted ? "true" : "false");
+
+	return 0;
+}
+
 #define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {		\
 	s64 _total, _avg, _min, _max, _sq, _st;				\
 	_avg = ktime_to_us(avg);					\
@@ -309,6 +324,7 @@ DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
 DEFINE_SHOW_ATTRIBUTE(metric);
+DEFINE_SHOW_ATTRIBUTE(status);
 
 
 /*
@@ -394,6 +410,12 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
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
2.18.4

