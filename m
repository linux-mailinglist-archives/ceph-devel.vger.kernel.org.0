Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3381156EDF
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 06:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgBJFet (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 00:34:49 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgBJFet (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 00:34:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581312888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnsZHArC7QlHqcbQQzVRu+wBIhLBpzC1Vvl/Uri5Egs=;
        b=gtqgYqhZcR0hqXBoNOPymJe5RJrQJu/IDQBBY2VtRQ4FxaXTP/5hstpvPs+gyVueU7xr28
        o+PCgrbR8SE9lCO3IIJLWRwhOyeMrbZgUTax+4bKqSMAX/ugSeJL+IA2Yj2L/+9xvR834H
        OZXPOl4R8OAcI6AXr2w9oAiSJf2FIJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-zBDYPthvMYqdumXPNGCIow-1; Mon, 10 Feb 2020 00:34:46 -0500
X-MC-Unique: zBDYPthvMYqdumXPNGCIow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F8CD13EA;
        Mon, 10 Feb 2020 05:34:45 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5061210027A3;
        Mon, 10 Feb 2020 05:34:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 7/9] ceph: add CEPH_DEFINE_RW_FUNC helper support
Date:   Mon, 10 Feb 2020 00:34:05 -0500
Message-Id: <20200210053407.37237-8-xiubli@redhat.com>
In-Reply-To: <20200210053407.37237-1-xiubli@redhat.com>
References: <20200210053407.37237-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

This will support the string store.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/debugfs.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/ceph/debugfs.h b/include/linux/ceph/debugfs.h
index 8b3a1a7a953a..b9100712f87f 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -4,6 +4,20 @@
=20
 #include <linux/ceph/types.h>
=20
+#define CEPH_DEFINE_RW_FUNC(name)					\
+static int name##_open(struct inode *inode, struct file *file)		\
+{									\
+	return single_open(file, name##_show, inode->i_private);	\
+}									\
+									\
+static const struct file_operations name##_fops =3D {			\
+	.open		=3D name##_open,					\
+	.read		=3D seq_read,					\
+	.write		=3D name##_store,					\
+	.llseek		=3D seq_lseek,					\
+	.release	=3D single_release,				\
+}
+
 /* debugfs.c */
 extern void ceph_debugfs_init(void);
 extern void ceph_debugfs_cleanup(void);
--=20
2.21.0

