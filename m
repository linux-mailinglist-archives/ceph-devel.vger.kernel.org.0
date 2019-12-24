Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46473129D36
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Dec 2019 05:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfLXEFi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Dec 2019 23:05:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48980 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726747AbfLXEFi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Dec 2019 23:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577160337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bvsOh3QEqoexaAJgVfTGKMtv2Y02aNfCOFM5VOGed7I=;
        b=INnajvwUB7qyzCGp1ecMOi4ISG3lRStIejEdSIFzGAKVm0CEukfUOiCrWTmd++2tmXmyID
        dy2PmPyMHhKLy5lAGUvNbs72UAmpE3XgEHHpbSFe6NYibOB9d0YGrfRLfO8nT/oGpfsfaB
        0LVFWnWUWSkXqd/kzl+Fy9eagS6a/eM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-pW7L4-RDPEO_ATbyclH5qA-1; Mon, 23 Dec 2019 23:05:35 -0500
X-MC-Unique: pW7L4-RDPEO_ATbyclH5qA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7A1E184B44F;
        Tue, 24 Dec 2019 04:05:34 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-64.pek2.redhat.com [10.72.12.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 021931000322;
        Tue, 24 Dec 2019 04:05:31 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/4] ceph: periodically send cap and dentry lease perf metrics to MDS
Date:   Mon, 23 Dec 2019 23:05:13 -0500
Message-Id: <20191224040514.26144-4-xiubli@redhat.com>
In-Reply-To: <20191224040514.26144-1-xiubli@redhat.com>
References: <20191224040514.26144-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Currently only the cap and dentry lease perf metrics are support,
and will send the metrics per 5 seconds.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         | 79 ++++++++++++++++++++++++++++++++++++
 include/linux/ceph/ceph_fs.h | 39 ++++++++++++++++++
 2 files changed, 118 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f58b74b2d1ec..5b74202ed68f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4086,6 +4086,79 @@ static void maybe_recover_session(struct ceph_mds_=
client *mdsc)
 	ceph_force_reconnect(fsc->sb);
 }
=20
+/*
+ * called under s_mutex
+ */
+static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
+				   struct ceph_mds_session *s,
+				   bool skip_global)
+{
+	struct ceph_metric_head *head;
+	struct ceph_metric_cap *cap;
+	struct ceph_metric_dentry_lease *lease;
+	struct ceph_msg *msg;
+	s32 len =3D sizeof(*head) + sizeof(*cap);
+	s32 items =3D 0;
+
+	if (!mdsc || !s)
+		return false;
+
+	if (!skip_global)
+		len +=3D sizeof(*lease);
+
+	msg =3D ceph_msg_new(CEPH_MSG_CLIENT_METRICS, len, GFP_NOFS, true);
+	if (!msg) {
+		pr_err("send metrics to mds%d, failed to allocate message\n",
+		       s->s_mds);
+		return false;
+	}
+
+	head =3D msg->front.iov_base;
+
+	/* encode the cap metric */
+	cap =3D (struct ceph_metric_cap *)(head + 1);
+	cap->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_CAP_INFO);
+	cap->ver =3D 1;
+	cap->campat =3D 1;
+	cap->data_len =3D cpu_to_le32(sizeof(*cap) - 6);
+	cap->hit =3D cpu_to_le64(percpu_counter_sum(&s->i_caps_hit));
+	cap->mis =3D cpu_to_le64(percpu_counter_sum(&s->i_caps_mis));
+	cap->total =3D cpu_to_le64(s->s_nr_caps);
+	items++;
+
+	dout("cap metric type %d, hit %lld, mis %lld, total %lld",
+	     cap->type, cap->hit, cap->mis, cap->total);
+
+	/* only send the global once */
+	if (skip_global)
+		goto skip_global;
+
+	/* encode the dentry lease metric */
+	lease =3D (struct ceph_metric_dentry_lease *)(cap + 1);
+	lease->type =3D cpu_to_le32(CLIENT_METRIC_TYPE_DENTRY_LEASE);
+	lease->ver =3D 1;
+	lease->campat =3D 1;
+	lease->data_len =3D cpu_to_le32(sizeof(*cap) - 6);
+	lease->hit =3D cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_hit=
));
+	lease->mis =3D cpu_to_le64(percpu_counter_sum(&mdsc->metric.d_lease_mis=
));
+	lease->total =3D cpu_to_le64(atomic64_read(&mdsc->metric.total_dentries=
));
+	items++;
+
+	dout("dentry lease metric type %d, hit %lld, mis %lld, total %lld",
+	     lease->type, lease->hit, lease->mis, lease->total);
+
+skip_global:
+	put_unaligned_le32(items, &head->num);
+	msg->front.iov_len =3D cpu_to_le32(len);
+	msg->hdr.version =3D cpu_to_le16(1);
+	msg->hdr.compat_version =3D cpu_to_le16(1);
+	msg->hdr.front_len =3D cpu_to_le32(msg->front.iov_len);
+	dout("send metrics to mds%d %p\n", s->s_mds, msg);
+	ceph_con_send(&s->s_con, msg);
+
+	return true;
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
@@ -4115,6 +4188,8 @@ static void delayed_work(struct work_struct *work)
=20
 	for (i =3D 0; i < mdsc->max_sessions; i++) {
 		struct ceph_mds_session *s =3D __ceph_lookup_mds_session(mdsc, i);
+		bool g_skip =3D false;
+
 		if (!s)
 			continue;
 		if (s->s_state =3D=3D CEPH_MDS_SESSION_CLOSING) {
@@ -4140,6 +4215,9 @@ static void delayed_work(struct work_struct *work)
 		mutex_unlock(&mdsc->mutex);
=20
 		mutex_lock(&s->s_mutex);
+
+		g_skip =3D ceph_mdsc_send_metrics(mdsc, s, g_skip);
+
 		if (renew_caps)
 			send_renew_caps(mdsc, s);
 		else
@@ -4147,6 +4225,7 @@ static void delayed_work(struct work_struct *work)
 		if (s->s_state =3D=3D CEPH_MDS_SESSION_OPEN ||
 		    s->s_state =3D=3D CEPH_MDS_SESSION_HUNG)
 			ceph_send_cap_releases(mdsc, s);
+
 		mutex_unlock(&s->s_mutex);
 		ceph_put_mds_session(s);
=20
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index cb21c5cf12c3..32758f9a2f1d 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -130,6 +130,7 @@ struct ceph_dir_layout {
 #define CEPH_MSG_CLIENT_REQUEST         24
 #define CEPH_MSG_CLIENT_REQUEST_FORWARD 25
 #define CEPH_MSG_CLIENT_REPLY           26
+#define CEPH_MSG_CLIENT_METRICS         29
 #define CEPH_MSG_CLIENT_CAPS            0x310
 #define CEPH_MSG_CLIENT_LEASE           0x311
 #define CEPH_MSG_CLIENT_SNAP            0x312
@@ -752,6 +753,44 @@ struct ceph_mds_lease {
 } __attribute__ ((packed));
 /* followed by a __le32+string for dname */
=20
+enum ceph_metric_type {
+	CLIENT_METRIC_TYPE_CAP_INFO,
+	CLIENT_METRIC_TYPE_READ_LATENCY,
+	CLIENT_METRIC_TYPE_WRITE_LATENCY,
+	CLIENT_METRIC_TYPE_METADATA_LATENCY,
+	CLIENT_METRIC_TYPE_DENTRY_LEASE,
+};
+
+/* metric caps header */
+struct ceph_metric_cap {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  campat;
+
+	__le32 data_len; /* length of sizeof(hit + mis + total) */
+	__le64 hit;
+	__le64 mis;
+	__le64 total;
+} __attribute__ ((packed));
+
+/* metric caps header */
+struct ceph_metric_dentry_lease {
+	__le32 type;     /* ceph metric type */
+
+	__u8  ver;
+	__u8  campat;
+
+	__le32 data_len; /* length of sizeof(hit + mis + total) */
+	__le64 hit;
+	__le64 mis;
+	__le64 total;
+} __attribute__ ((packed));
+
+struct ceph_metric_head {
+	__le32 num;	/* the number of metrics will be sent */
+} __attribute__ ((packed));
+
 /* client reconnect */
 struct ceph_mds_cap_reconnect {
 	__le64 cap_id;
--=20
2.21.0

