Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFCE37B953
	for <lists+ceph-devel@lfdr.de>; Wed, 12 May 2021 11:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhELJgJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 May 2021 05:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhELJgI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 May 2021 05:36:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620812100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GM3x0YY3BxINgBlq4k9NODouAuWgCcGnj6SsGSzOBpw=;
        b=LvzI9JI1BUiWZPgtkadUJsGSSsnOaUg1U0jgs9RE88Gkwt5zD8F6VYx0MBqVkDeIQlViMF
        QkAPHAstQCTVqJi0EfFRnU2KjwZQtRz1+pv5HV82CA/f6BuDy00FNzkm91HGEy9SSIF1nt
        jrWHQP7brhP01K6s3fa32nmwCElWSys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-cqQm6pIHPdy9tBub1Xqs4Q-1; Wed, 12 May 2021 05:34:56 -0400
X-MC-Unique: cqQm6pIHPdy9tBub1Xqs4Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5196800D62;
        Wed, 12 May 2021 09:34:50 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F3BD35C232;
        Wed, 12 May 2021 09:34:48 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 1/2] ceph: send the read/write io size metrics to mds
Date:   Wed, 12 May 2021 17:34:42 +0800
Message-Id: <20210512093443.35128-2-xiubli@redhat.com>
In-Reply-To: <20210512093443.35128-1-xiubli@redhat.com>
References: <20210512093443.35128-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

URL: https://tracker.ceph.com/issues/49913
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/metric.c | 25 ++++++++++++++++++++++++-
 fs/ceph/metric.h | 30 +++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index fbeb8f2fe5ad..d6c76f1667ed 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -20,6 +20,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	struct ceph_opened_files *files;
 	struct ceph_pinned_icaps *icaps;
 	struct ceph_opened_inodes *inodes;
+	struct ceph_read_io_size *rsize;
+	struct ceph_write_io_size *wsize;
 	struct ceph_client_metric *m = &mdsc->metric;
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	struct ceph_msg *msg;
@@ -30,7 +32,8 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 
 	len = sizeof(*head) + sizeof(*cap) + sizeof(*read) + sizeof(*write)
 	      + sizeof(*meta) + sizeof(*dlease) + sizeof(*files)
-	      + sizeof(*icaps) + sizeof(*inodes);
+	      + sizeof(*icaps) + sizeof(*inodes) + sizeof(*rsize)
+	      + sizeof(*wsize);
 
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
 	if (!msg) {
@@ -131,6 +134,26 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	inodes->total = cpu_to_le64(sum);
 	items++;
 
+	/* encode the read io size metric */
+	rsize = (struct ceph_read_io_size *)(inodes + 1);
+	rsize->type = cpu_to_le32(CLIENT_METRIC_TYPE_READ_IO_SIZES);
+	rsize->ver = 1;
+	rsize->compat = 1;
+	rsize->data_len = cpu_to_le32(sizeof(*rsize) - 10);
+	rsize->total_ops = cpu_to_le64(m->total_reads);
+	rsize->total_size = cpu_to_le64(m->read_size_sum);
+	items++;
+
+	/* encode the write io size metric */
+	wsize = (struct ceph_write_io_size *)(rsize + 1);
+	wsize->type = cpu_to_le32(CLIENT_METRIC_TYPE_WRITE_IO_SIZES);
+	wsize->ver = 1;
+	wsize->compat = 1;
+	wsize->data_len = cpu_to_le32(sizeof(*wsize) - 10);
+	wsize->total_ops = cpu_to_le64(m->total_writes);
+	wsize->total_size = cpu_to_le64(m->write_size_sum);
+	items++;
+
 	put_unaligned_le32(items, &head->num);
 	msg->front.iov_len = len;
 	msg->hdr.version = cpu_to_le16(1);
diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
index 4bd92689bf12..44b0f478b84b 100644
--- a/fs/ceph/metric.h
+++ b/fs/ceph/metric.h
@@ -17,8 +17,10 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_OPENED_FILES,
 	CLIENT_METRIC_TYPE_PINNED_ICAPS,
 	CLIENT_METRIC_TYPE_OPENED_INODES,
+	CLIENT_METRIC_TYPE_READ_IO_SIZES,
+	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
 
-	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_OPENED_INODES,
+	CLIENT_METRIC_TYPE_MAX = CLIENT_METRIC_TYPE_WRITE_IO_SIZES,
 };
 
 /*
@@ -34,6 +36,8 @@ enum ceph_metric_type {
 	CLIENT_METRIC_TYPE_OPENED_FILES,	\
 	CLIENT_METRIC_TYPE_PINNED_ICAPS,	\
 	CLIENT_METRIC_TYPE_OPENED_INODES,	\
+	CLIENT_METRIC_TYPE_READ_IO_SIZES,	\
+	CLIENT_METRIC_TYPE_WRITE_IO_SIZES,	\
 						\
 	CLIENT_METRIC_TYPE_MAX,			\
 }
@@ -136,6 +140,30 @@ struct ceph_opened_inodes {
 	__le64 total;
 } __packed;
 
+/* metric read io size header */
+struct ceph_read_io_size {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(opened_inodes + total) */
+	__le64 total_ops;
+	__le64 total_size;
+} __packed;
+
+/* metric write io size header */
+struct ceph_write_io_size {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  compat;
+
+	__le32 data_len; /* length of sizeof(opened_inodes + total) */
+	__le64 total_ops;
+	__le64 total_size;
+} __packed;
+
 struct ceph_metric_head {
 	__le32 num;	/* the number of metrics that will be sent */
 } __packed;
-- 
2.27.0

