Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E741133F14
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 11:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbgAHKRw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 05:17:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726368AbgAHKRw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 05:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578478671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gN7tbUfc5NVn2zcYn2AUvVENEHOlLV7p7XMP5jmyfl8=;
        b=ItJTHEB+Xs0yNq2WSDj1QPaVL2FHlGVUu3VX+5hGUYC6WfR1cNcyV1GupdBpLdHp3wR/sA
        uyzuRy+3OYoemR4ptdig57CO+ZWR+XN8DuXVeXQFgCvvbvPVM1dqfPrHrxo2ZfVds+6Sgh
        lBuInC509BPyVlOLG9kkTNVRHwSWh54=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-7_HPejgMMNik1oSgPQN7vw-1; Wed, 08 Jan 2020 05:17:42 -0500
X-MC-Unique: 7_HPejgMMNik1oSgPQN7vw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E42AEDB60;
        Wed,  8 Jan 2020 10:17:41 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C381A5D9E1;
        Wed,  8 Jan 2020 10:17:36 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: allocate the accurate extra bytes for the session features
Date:   Wed,  8 Jan 2020 05:17:31 -0500
Message-Id: <20200108101731.26652-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The totally bytes maybe potentially larger than 8.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 20 ++++++++++++++------
 fs/ceph/mds_client.h | 23 ++++++++++++++++-------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 94cce2ab92c4..d379f489ab63 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -9,6 +9,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/ratelimit.h>
+#include <linux/bits.h>
=20
 #include "super.h"
 #include "mds_client.h"
@@ -1053,20 +1054,21 @@ static struct ceph_msg *create_session_msg(u32 op=
, u64 seq)
 	return msg;
 }
=20
+static const unsigned char feature_bits[] =3D CEPHFS_FEATURES_CLIENT_SUP=
PORTED;
+#define FEATURE_BYTES(c) (DIV_ROUND_UP((size_t)feature_bits[c - 1] + 1, =
64) * 8)
 static void encode_supported_features(void **p, void *end)
 {
-	static const unsigned char bits[] =3D CEPHFS_FEATURES_CLIENT_SUPPORTED;
-	static const size_t count =3D ARRAY_SIZE(bits);
+	static const size_t count =3D ARRAY_SIZE(feature_bits);
=20
 	if (count > 0) {
 		size_t i;
-		size_t size =3D ((size_t)bits[count - 1] + 64) / 64 * 8;
+		size_t size =3D FEATURE_BYTES(count);
=20
 		BUG_ON(*p + 4 + size > end);
 		ceph_encode_32(p, size);
 		memset(*p, 0, size);
 		for (i =3D 0; i < count; i++)
-			((unsigned char*)(*p))[i / 8] |=3D 1 << (bits[i] % 8);
+			((unsigned char*)(*p))[i / 8] |=3D BIT(feature_bits[i] % 8);
 		*p +=3D size;
 	} else {
 		BUG_ON(*p + 4 > end);
@@ -1087,6 +1089,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	int metadata_key_count =3D 0;
 	struct ceph_options *opt =3D mdsc->fsc->client->options;
 	struct ceph_mount_options *fsopt =3D mdsc->fsc->mount_options;
+	size_t size, count;
 	void *p, *end;
=20
 	const char* metadata[][2] =3D {
@@ -1104,8 +1107,13 @@ static struct ceph_msg *create_session_open_msg(st=
ruct ceph_mds_client *mdsc, u6
 			strlen(metadata[i][1]);
 		metadata_key_count++;
 	}
+
 	/* supported feature */
-	extra_bytes +=3D 4 + 8;
+	size =3D 0;
+	count =3D ARRAY_SIZE(feature_bits);
+	if (count > 0)
+		size =3D FEATURE_BYTES(count);
+	extra_bytes +=3D 4 + size;
=20
 	/* Allocate the message */
 	msg =3D ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
@@ -1125,7 +1133,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	 * Serialize client metadata into waiting buffer space, using
 	 * the format that userspace expects for map<string, string>
 	 *
-	 * ClientSession messages with metadata are v2
+	 * ClientSession messages with metadata are v3
 	 */
 	msg->hdr.version =3D cpu_to_le16(3);
 	msg->hdr.compat_version =3D cpu_to_le16(1);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index c021df5f50ce..c950f8f88f58 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -17,22 +17,31 @@
 #include <linux/ceph/auth.h>
=20
 /* The first 8 bits are reserved for old ceph releases */
-#define CEPHFS_FEATURE_MIMIC		8
-#define CEPHFS_FEATURE_REPLY_ENCODING	9
-#define CEPHFS_FEATURE_RECLAIM_CLIENT	10
-#define CEPHFS_FEATURE_LAZY_CAP_WANTED	11
-#define CEPHFS_FEATURE_MULTI_RECONNECT  12
+enum ceph_feature_type {
+	CEPHFS_FEATURE_MIMIC =3D 8,
+	CEPHFS_FEATURE_REPLY_ENCODING,
+	CEPHFS_FEATURE_RECLAIM_CLIENT,
+	CEPHFS_FEATURE_LAZY_CAP_WANTED,
+	CEPHFS_FEATURE_MULTI_RECONNECT,
+
+	CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_MULTI_RECONNECT,
+};
=20
-#define CEPHFS_FEATURES_CLIENT_SUPPORTED { 	\
+/*
+ * This will always have the highest feature bit value
+ * as the last element of the array.
+ */
+#define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
 	0, 1, 2, 3, 4, 5, 6, 7,			\
 	CEPHFS_FEATURE_MIMIC,			\
 	CEPHFS_FEATURE_REPLY_ENCODING,		\
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
+						\
+	CEPHFS_FEATURE_MAX,			\
 }
 #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
=20
-
 /*
  * Some lock dependencies:
  *
--=20
2.21.0

