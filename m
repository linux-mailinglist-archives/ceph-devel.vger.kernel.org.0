Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C319156EE0
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 06:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgBJFey (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 00:34:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49472 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726170AbgBJFey (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Feb 2020 00:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581312893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AsUnR1nSUxGphjs7anF7u72jy5JMtgaU06bKrVNzm0E=;
        b=Z46KprCridXD3n6Sy9kFqPLmtXZgr2yQ7W38MAdP9SVlBPiIp52/fF6kUxDUooNij6QrC2
        +2Q27mGiEdzfV1kAJmpwG9/aYlFCkDHtR4nBVSPTpnkvLbi3LCtWoJouyCQcoWJ2HbA8P+
        YWyBK7lKap2PzrcdQAEz7CYa7yqcgwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-x6fmbf09PHGLg8yTw84p-w-1; Mon, 10 Feb 2020 00:34:49 -0500
X-MC-Unique: x6fmbf09PHGLg8yTw84p-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C4401084432;
        Mon, 10 Feb 2020 05:34:48 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F1A510027A3;
        Mon, 10 Feb 2020 05:34:45 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v6 8/9] ceph: add reset metrics support
Date:   Mon, 10 Feb 2020 00:34:06 -0500
Message-Id: <20200210053407.37237-9-xiubli@redhat.com>
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

Sometimes we need to discard the old perf metrics and start to get
new ones. And this will reset the most metric counters, except the
total numbers for caps and dentries.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 60f3e307fca1..6e595a37af5d 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -179,6 +179,43 @@ static int metric_show(struct seq_file *s, void *p)
 	return 0;
 }
=20
+static ssize_t metric_store(struct file *file, const char __user *user_b=
uf,
+			    size_t count, loff_t *ppos)
+{
+	struct seq_file *s =3D file->private_data;
+	struct ceph_fs_client *fsc =3D s->private;
+	struct ceph_mds_client *mdsc =3D fsc->mdsc;
+	struct ceph_client_metric *metric =3D &mdsc->metric;
+	char buf[8];
+
+	if (copy_from_user(buf, user_buf, 8))
+		return -EFAULT;
+
+	if (strncmp(buf, "reset", strlen("reset"))) {
+		pr_err("Invalid set value '%s', only 'reset' is valid\n", buf);
+		return -EINVAL;
+	}
+
+	percpu_counter_set(&metric->d_lease_hit, 0);
+	percpu_counter_set(&metric->d_lease_mis, 0);
+
+	percpu_counter_set(&metric->i_caps_hit, 0);
+	percpu_counter_set(&metric->i_caps_mis, 0);
+
+	percpu_counter_set(&metric->read_latency_sum, 0);
+	percpu_counter_set(&metric->total_reads, 0);
+
+	percpu_counter_set(&metric->write_latency_sum, 0);
+	percpu_counter_set(&metric->total_writes, 0);
+
+	percpu_counter_set(&metric->metadata_latency_sum, 0);
+	percpu_counter_set(&metric->total_metadatas, 0);
+
+	return count;
+}
+
+CEPH_DEFINE_RW_FUNC(metric);
+
 static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void =
*p)
 {
 	struct seq_file *s =3D p;
@@ -277,7 +314,6 @@ DEFINE_SHOW_ATTRIBUTE(mdsmap);
 DEFINE_SHOW_ATTRIBUTE(mdsc);
 DEFINE_SHOW_ATTRIBUTE(caps);
 DEFINE_SHOW_ATTRIBUTE(mds_sessions);
-DEFINE_SHOW_ATTRIBUTE(metric);
=20
=20
 /*
--=20
2.21.0

