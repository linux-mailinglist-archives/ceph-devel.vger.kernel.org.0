Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3D51FB12F
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 14:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgFPMw4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 08:52:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56386 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728154AbgFPMwz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 08:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592311974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=yRS0CTffC5qftBvNK0jovY6TVMjl2sUzN1in9QjnIds=;
        b=f0RRqipOfGr/o01KkEZ+EbHOsuB8cZxhDQ6ifdGh73+1N0E64A3RvtBN1WPuIsql+s+MxV
        DyTg8gFtpJi+WYQWji2oAP08tcbeorlBpeYBksmbKC2DF4+nGQxa2knSqK93DzR5/eZFaa
        fYdY9ZuFNlXhhEFcqCjLTt1ZxyzRsQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-zJ8-8qlBMGS1MDGJ8btcNA-1; Tue, 16 Jun 2020 08:52:49 -0400
X-MC-Unique: zJ8-8qlBMGS1MDGJ8btcNA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5B25DB72;
        Tue, 16 Jun 2020 12:52:48 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B06367890A;
        Tue, 16 Jun 2020 12:52:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: send client provided metric flags in client metadata
Date:   Tue, 16 Jun 2020 08:52:30 -0400
Message-Id: <1592311950-17623-3-git-send-email-xiubli@redhat.com>
In-Reply-To: <1592311950-17623-1-git-send-email-xiubli@redhat.com>
References: <1592311950-17623-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 fs/ceph/mds_client.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/ceph/metric.h     | 13 +++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f996363..8b7ff41 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1188,6 +1188,41 @@ static void encode_supported_features(void **p, void *end)
 	}
 }
 
+static const unsigned char metric_bits[] = CEPHFS_METRIC_SPEC_CLIENT_SUPPORTED;
+#define METRIC_BYTES(cnt) (DIV_ROUND_UP((size_t)metric_bits[cnt - 1] + 1, 64) * 8)
+static void encode_metric_spec(void **p, void *end)
+{
+	static const size_t count = ARRAY_SIZE(metric_bits);
+
+	/* header */
+	BUG_ON(*p + 2 > end);
+	ceph_encode_8(p, 1); /* version */
+	ceph_encode_8(p, 1); /* compat */
+
+	if (count > 0) {
+		size_t i;
+		size_t size = METRIC_BYTES(count);
+
+		BUG_ON(*p + 4 + 4 + size > end);
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
@@ -1227,6 +1262,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
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
@@ -1245,9 +1287,9 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
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
@@ -1270,6 +1312,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
 	}
 
 	encode_supported_features(&p, end);
+	encode_metric_spec(&p, end);
 	msg->front.iov_len = p - msg->front.iov_base;
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
 
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 2af9e0b..f34adf7 100644
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
1.8.3.1

