Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57070156EE1
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 06:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbgBJFfJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 00:35:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41807 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726170AbgBJFfI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 00:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581312908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oO9ra9hTWXvpM+Utnu1hviC2dRxTC1/EPgA+jJl4SjA=;
        b=O/JXllFLrF39LB19LP14F5yWZ2CYx00aSP1HEqjNwISWVG+8iLnGC9W/4gdLfBWdDmQ10P
        biLlL4i78okkIAGABjo9yGhAZ1phIWrHmmQCMwkFL67VQSRuIeB4GjZf82r9IofWVfYuH6
        hnbTyKMABGIlOBoommpjWGn+SKYNK24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-LmtwMw_UMxmbxV9MdHbP5A-1; Mon, 10 Feb 2020 00:34:52 -0500
X-MC-Unique: LmtwMw_UMxmbxV9MdHbP5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC1658014D0;
        Mon, 10 Feb 2020 05:34:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8C4810021B2;
        Mon, 10 Feb 2020 05:34:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 9/9] ceph: send client provided metric flags in client metadata
Date:   Mon, 10 Feb 2020 00:34:07 -0500
Message-Id: <20200210053407.37237-10-xiubli@redhat.com>
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

Will send the metric flags to MDS, currently it supports the cap,
dentry lease, read latency, write latency and metadata latency.

URL: https://tracker.ceph.com/issues/43435
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 47 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/metric.h     | 14 +++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f9a6f95c7941..376e7cf1685f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1082,6 +1082,41 @@ static void encode_supported_features(void **p, vo=
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
+			((unsigned char *)(*p))[i / 8] |=3D BIT(metric_bits[i] % 8);
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
@@ -1121,6 +1156,13 @@ static struct ceph_msg *create_session_open_msg(st=
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
@@ -1139,9 +1181,9 @@ static struct ceph_msg *create_session_open_msg(str=
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
@@ -1164,6 +1206,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	}
=20
 	encode_supported_features(&p, end);
+	encode_metric_spec(&p, end);
 	msg->front.iov_len =3D p - msg->front.iov_base;
 	msg->hdr.front_len =3D cpu_to_le32(msg->front.iov_len);
=20
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 224e92a70d88..c0149484e71d 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -14,6 +14,20 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_MAX =3D CLIENT_METRIC_TYPE_DENTRY_LEASE,
 };
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
 /* metric caps header */
 struct ceph_metric_cap {
 	__le32 type;     /* ceph metric type */
--=20
2.21.0

