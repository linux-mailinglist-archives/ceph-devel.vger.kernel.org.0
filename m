Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F00613D81B
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 11:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAPKjX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 05:39:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726329AbgAPKjX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Jan 2020 05:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579171162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=boZj/moecJetSh6WoJlePYnf/p3w7NaAG3nA86TMRNQ=;
        b=gGCW/x1ZgTiJL20gXy+0QdBWW3m+M49Pg01vSnhbkJj0xG9sVzvak7RCOCvzfycMQBBh3m
        XQ+R/hPtzt8w0+H3plFdWFeH2VKD0uGadPp6alp9o/P0cNfksCWbr6UChslEF6Kkt7c61q
        nrWqb8ZW6gS4HfHRpbtL0M1lZwImVss=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-LtTThKyVNvi1tiqiNGJmZQ-1; Thu, 16 Jan 2020 05:39:20 -0500
X-MC-Unique: LtTThKyVNvi1tiqiNGJmZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CEFC1800D48;
        Thu, 16 Jan 2020 10:39:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A02360FC1;
        Thu, 16 Jan 2020 10:39:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 8/8] ceph: send client provided metric flags in client metadata
Date:   Thu, 16 Jan 2020 05:38:30 -0500
Message-Id: <20200116103830.13591-9-xiubli@redhat.com>
In-Reply-To: <20200116103830.13591-1-xiubli@redhat.com>
References: <20200116103830.13591-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 fs/ceph/mds_client.h | 14 +++++++++++++
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3fc2bdb1153a..6b9c7fc5824d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1096,6 +1096,41 @@ static void encode_supported_features(void **p, vo=
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
@@ -1135,6 +1170,13 @@ static struct ceph_msg *create_session_open_msg(st=
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
@@ -1153,9 +1195,9 @@ static struct ceph_msg *create_session_open_msg(str=
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
@@ -1178,6 +1220,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	}
=20
 	encode_supported_features(&p, end);
+	encode_metric_spec(&p, end);
 	msg->front.iov_len =3D p - msg->front.iov_base;
 	msg->hdr.front_len =3D cpu_to_le32(msg->front.iov_len);
=20
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 153ca6aa6d2c..1a668d318501 100644
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

