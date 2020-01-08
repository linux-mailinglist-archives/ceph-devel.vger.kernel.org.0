Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E594B133F7E
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jan 2020 11:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgAHKmo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jan 2020 05:42:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49048 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727889AbgAHKmn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jan 2020 05:42:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578480163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FygXwqiXEwobfJD2VqWDis4Hpi+A+xvTF+dh5f0peDg=;
        b=Op41vZ8gUOepE/P8LQ1dszZYfjXT1IQiwAj38MYakqe4kJCx/mkSKs0IBKXmRK3B8qH8Wv
        GIuSEpnDJFLu+Dn8cA6Ro8Vg0LubT9CmeDTG8wZsItg8RB4t6J+H2r8YVd3tDrICp+KxQS
        3+X1z0oW9WeOw/FoOjsIhXrStbo2V7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-ELc9O7KwOBaaMYRiHkz88Q-1; Wed, 08 Jan 2020 05:42:39 -0500
X-MC-Unique: ELc9O7KwOBaaMYRiHkz88Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44E7EDB60;
        Wed,  8 Jan 2020 10:42:38 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-70.pek2.redhat.com [10.72.12.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94DF7272CB;
        Wed,  8 Jan 2020 10:42:35 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 8/8] ceph: send client provided metric flags in client metadata
Date:   Wed,  8 Jan 2020 05:41:52 -0500
Message-Id: <20200108104152.28468-9-xiubli@redhat.com>
In-Reply-To: <20200108104152.28468-1-xiubli@redhat.com>
References: <20200108104152.28468-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Will send the cap info and dentry lease metric flags to MDS.

Fixes: https://tracker.ceph.com/issues/43435
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 47 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/mds_client.h | 14 +++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a0693ed6f54f..949743eacbfc 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1090,6 +1090,41 @@ static void encode_supported_features(void **p, vo=
id *end)
 	}
 }
=20
+static const unsigned char metric_bits[] =3D CEPHFS_METRIC_SPEC_CLIENT_S=
UPPORTED;
+#define METRIC_BYTES(cnt) (DIV_ROUND_UP((size_t)metric_bits[cnt - 1] + 1=
, 64) * 8)
+static void encode_metric_spec(void **p, void *end)
+{
+	static const size_t count =3D ARRAY_SIZE(metric_bits);
+
+	/* header */
+	BUG_ON(*p + 2 > end);
+	ceph_encode_8(p, 1); /* version */
+	ceph_encode_8(p, 1); /* compat */
+
+	if (count > 0) {
+		size_t i;
+		size_t size =3D METRIC_BYTES(count);
+
+		BUG_ON(*p + 4 + 4 + size > end);
+
+		/* metric spec info length */
+		ceph_encode_32(p, 4 + size);
+
+		/* metric spec */
+		ceph_encode_32(p, size);
+		memset(*p, 0, size);
+		for (i =3D 0; i < count; i++)
+			((unsigned char*)(*p))[i / 8] |=3D BIT(metric_bits[i] % 8);
+		*p +=3D size;
+	} else {
+		BUG_ON(*p + 4 + 4 > end);
+		/* metric spec info length */
+		ceph_encode_32(p, 4);
+		/* metric spec */
+		ceph_encode_32(p, 0);
+	}
+}
+
 /*
  * session message, specialization for CEPH_SESSION_REQUEST_OPEN
  * to include additional client metadata fields.
@@ -1129,6 +1164,13 @@ static struct ceph_msg *create_session_open_msg(st=
ruct ceph_mds_client *mdsc, u6
 		size =3D FEATURE_BYTES(count);
 	extra_bytes +=3D 4 + size;
=20
+	/* metric spec */
+	size =3D 0;
+	count =3D ARRAY_SIZE(metric_bits);
+	if (count > 0)
+		size =3D METRIC_BYTES(count);
+	extra_bytes +=3D 2 + 4 + 4 + size;
+
 	/* Allocate the message */
 	msg =3D ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
 			   GFP_NOFS, false);
@@ -1147,9 +1189,9 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	 * Serialize client metadata into waiting buffer space, using
 	 * the format that userspace expects for map<string, string>
 	 *
-	 * ClientSession messages with metadata are v3
+	 * ClientSession messages with metadata are v4
 	 */
-	msg->hdr.version =3D cpu_to_le16(3);
+	msg->hdr.version =3D cpu_to_le16(4);
 	msg->hdr.compat_version =3D cpu_to_le16(1);
=20
 	/* The write pointer, following the session_head structure */
@@ -1172,6 +1214,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	}
=20
 	encode_supported_features(&p, end);
+	encode_metric_spec(&p, end);
 	msg->front.iov_len =3D p - msg->front.iov_base;
 	msg->hdr.front_len =3D cpu_to_le32(msg->front.iov_len);
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5bffa4e6ba5d..3b168a59ab74 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -42,6 +42,20 @@ enum ceph_feature_type {
 }
 #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
=20
+/*
+ * This will always have the highest metric bit value
+ * as the last element of the array.
+ */
+#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	\
+	CLIENT_METRIC_TYPE_CAP_INFO,		\
+	CLIENT_METRIC_TYPE_READ_LATENCY,	\
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,	\
+						\
+	CLIENT_METRIC_TYPE_MAX,			\
+}
+
 /*
  * Some lock dependencies:
  *
--=20
2.21.0

