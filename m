Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA08414C77F
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 09:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgA2I2X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 03:28:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34872 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726314AbgA2I2W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 03:28:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580286501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CA1BOrINbemf/bjV6vz25R4YawJkALrPImty+Lbmlko=;
        b=gAb6qPnxOOQAoU9wVo35DZYzCacKoPDHTV5B3eNN/TDkeEQaFOVGMHO9G6h33FjyV3Le0j
        4OGTfGjH2xJXYnjYpxgUa1z26B8601S93L89/8L/VG+B8sdS6V3vNqx8y1Etafok8WsEo3
        1QLS2OXBXu3gnQ3vyYF0R3thKFL/QZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-UIQ99q6MMyyV1TYvfludKg-1; Wed, 29 Jan 2020 03:28:17 -0500
X-MC-Unique: UIQ99q6MMyyV1TYvfludKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C00F1800D41;
        Wed, 29 Jan 2020 08:28:16 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8154A5C548;
        Wed, 29 Jan 2020 08:28:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH resend v5 09/11] ceph: add CEPH_DEFINE_RW_FUNC helper support
Date:   Wed, 29 Jan 2020 03:27:13 -0500
Message-Id: <20200129082715.5285-10-xiubli@redhat.com>
In-Reply-To: <20200129082715.5285-1-xiubli@redhat.com>
References: <20200129082715.5285-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index cf5e840eec71..b918fb1f6f54 100644
--- a/include/linux/ceph/debugfs.h
+++ b/include/linux/ceph/debugfs.h
@@ -18,6 +18,20 @@ static const struct file_operations name##_fops =3D {	=
		\
 	.release	=3D single_release,				\
 };
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
+};
+
 /* debugfs.c */
 extern void ceph_debugfs_init(void);
 extern void ceph_debugfs_cleanup(void);
--=20
2.21.0

