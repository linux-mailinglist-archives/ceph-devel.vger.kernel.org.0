Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5948E14B4A0
	for <lists+ceph-devel@lfdr.de>; Tue, 28 Jan 2020 14:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgA1NDp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 28 Jan 2020 08:03:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40408 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726007AbgA1NDp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 28 Jan 2020 08:03:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580216624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CA1BOrINbemf/bjV6vz25R4YawJkALrPImty+Lbmlko=;
        b=I1K2DQvF1w6Ax7mDnUcHrJyClXDm28Wlcqo8pZOZSVonBcOJVgr3noPB/DGh8Oksoi6yEl
        5iF5xWDgeHkY+/7KirR/zqRewwaovZrIRwu+23HeAJh76XejM5RoW82t08L/IhHDTnmum3
        7h5yryG0VDrEad+qDVoKXRx3YOdl53c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-U4Z6GEQyNJWMjPwrclqG8Q-1; Tue, 28 Jan 2020 08:03:41 -0500
X-MC-Unique: U4Z6GEQyNJWMjPwrclqG8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C01B818A6EC7;
        Tue, 28 Jan 2020 13:03:40 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79318863D3;
        Tue, 28 Jan 2020 13:03:32 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v5 08/10] ceph: add CEPH_DEFINE_RW_FUNC helper support
Date:   Tue, 28 Jan 2020 08:02:46 -0500
Message-Id: <20200128130248.4266-9-xiubli@redhat.com>
In-Reply-To: <20200128130248.4266-1-xiubli@redhat.com>
References: <20200128130248.4266-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

