Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27422224D8
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jul 2020 16:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgGPOHE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jul 2020 10:07:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727044AbgGPOHE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 16 Jul 2020 10:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594908422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k3Pl3nim7d7yStxn/8i+M5i8QW7CiLkNopSTGCDDFI4=;
        b=UIsRE+nflNzHaXMPDq39zRHRv+/LGH776PcwyyZzF92Odk7tsp88A+rriDbkKFWK4uEcXw
        QylPxe5ObOr1ls3cdXUHB49BU9Of4+i7+n4Pz2JB6awFnqqu2/Dc8V29LgAfx1Rq3tK2bZ
        xQT1fKzrVo3FRyXdaFO61O86pK7zL34=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-FOWn2pxNPpKCwrTsaa28ZA-1; Thu, 16 Jul 2020 10:06:34 -0400
X-MC-Unique: FOWn2pxNPpKCwrTsaa28ZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 160821008302;
        Thu, 16 Jul 2020 14:06:33 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBED35C1D4;
        Thu, 16 Jul 2020 14:06:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, zyan@redhat.com,
        pdonnell@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 2/2] ceph: send client provided metric flags in client metadata
Date:   Thu, 16 Jul 2020 10:05:58 -0400
Message-Id: <20200716140558.5185-3-xiubli@redhat.com>
In-Reply-To: <20200716140558.5185-1-xiubli@redhat.com>
References: <20200716140558.5185-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Will send the metric flags to MDS, currently it supports the cap,
read latency, write latency and metadata latency.

URL: https://tracker.ceph.com/issues/43435
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 60 ++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/metric.h     | 13 ++++++++++
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index cf4c2ba2311f..929778625ea5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1194,6 +1194,48 @@ static int encode_supported_features(void **p, void *end)
 	return 0;
 }
 
+static const unsigned char metric_bits[] = CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED;
+#define METRIC_BYTES(cnt) (DIV_ROUND_UP((size_t)metric_bits[cnt - 1] + 1, 64) * 8)
+static int encode_metric_spec(void **p, void *end)
+{
+	static const size_t count = ARRAY_SIZE(metric_bits);
+
+	/* header */
+	if (WARN_ON_ONCE(*p + 2 > end))
+		return -ERANGE;
+
+	ceph_encode_8(p, 1); /* version */
+	ceph_encode_8(p, 1); /* compat */
+
+	if (count > 0) {
+		size_t i;
+		size_t size = METRIC_BYTES(count);
+
+		if (WARN_ON_ONCE(*p + 4 + 4 + size > end))
+			return -ERANGE;
+
+		/* metric spec info length */
+		ceph_encode_32(p, 4 + size);
+
+		/* metric spec */
+		ceph_encode_32(p, size);
+		memset(*p, 0, size);
+		for (i = 0; i < count; i++)
+			((unsigned char *)(*p))[i / 8] |= BIT(metric_bits[i] % 8);
+		*p += size;
+	} else {
+		if (WARN_ON_ONCE(*p + 4 + 4 > end))
+			return -ERANGE;
+
+		/* metric spec info length */
+		ceph_encode_32(p, 4);
+		/* metric spec */
+		ceph_encode_32(p, 0);
+	}
+
+	return 0;
+}
+
 /*
  * session message, specialization for CEPH_SESSION_REQUEST_OPEN
  * to include additional client metadata fields.
@@ -1234,6 +1276,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 		size = FEATURE_BYTES(count);
 	extra_bytes += 4 + size;
 
+	/* metric spec */
+	size = 0;
+	count = ARRAY_SIZE(metric_bits);
+	if (count > 0)
+		size = METRIC_BYTES(count);
+	extra_bytes += 2 + 4 + 4 + size;
+
 	/* Allocate the message */
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
 			   GFP_NOFS, false);
@@ -1252,9 +1301,9 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	 * Serialize client metadata into waiting buffer space, using
 	 * the format that userspace expects for map<string, string>
 	 *
-	 * ClientSession messages with metadata are v3
+	 * ClientSession messages with metadata are v4
 	 */
-	msg->hdr.version = cpu_to_le16(3);
+	msg->hdr.version = cpu_to_le16(4);
 	msg->hdr.compat_version = cpu_to_le16(1);
 
 	/* The write pointer, following the session_head structure */
@@ -1283,6 +1332,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 		return ERR_PTR(ret);
 	}
 
+	ret = encode_metric_spec(&p, end);
+	if (ret) {
+		pr_err("encode_metric_spec failed!\n");
+		ceph_msg_put(msg);
+		return ERR_PTR(ret);
+	}
+
 	msg->front.iov_len = p - msg->front.iov_base;
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index fe5d07d2e63a..1d0959d669d7 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -18,6 +18,19 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_DENTRY_LEASE,
 };
 
+/*
+ * This will always have the highest metric bit value
+ * as the last element of the array.
+ */
+#define CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED {	\
+	CLIENT_METRIC_TYPE_CAP_INFO,		\
+	CLIENT_METRIC_TYPE_READ_LATENCY,	\
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,	\
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,	\
+						\
+	CLIENT_METRIC_TYPE_MAX,			\
+}
+
 /* metric caps header */
 struct ceph_metric_cap {
 	__le32 type;     /* ceph metric type */
-- 
2.27.0.221.ga08a83d.dirty

