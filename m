Return-Path: <ceph-devel+bounces-102-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 011B77EDBD4
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 08:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A98161F23BE0
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Nov 2023 07:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD7BDF56;
	Thu, 16 Nov 2023 07:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TAB/9b9Y"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA26C199
	for <ceph-devel@vger.kernel.org>; Wed, 15 Nov 2023 23:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700118954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jn+jeSb43oeou7KuihthY2acdrQcbYIXhnriasDatDg=;
	b=TAB/9b9Y5iWjPt44G91nbwR1Ex+GyuVRg+UNyriFZr7K3KxelXrTutVhoDxfHadBTDX3uL
	XWrbCrgZP9YtK3HzfL9vLkqgYtLPGeg/AQVYn3SvUd0wJAaRo4OJRdG6RhxONH8emZDxrs
	gF8UO4YAEmtgxJlVTuwiDDWn9lOFK24=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-dslEDXvAMdixkrNehKr_XA-1; Thu, 16 Nov 2023 02:15:51 -0500
X-MC-Unique: dslEDXvAMdixkrNehKr_XA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D97281B160;
	Thu, 16 Nov 2023 07:15:51 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.63])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C19DF492BFD;
	Thu, 16 Nov 2023 07:15:48 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: jlayton@kernel.org,
	idryomov@gmail.com,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/2] ceph: update the oldest_client_tid via the renew caps
Date: Thu, 16 Nov 2023 15:13:38 +0800
Message-ID: <20231116071338.678918-3-xiubli@redhat.com>
In-Reply-To: <20231116071338.678918-1-xiubli@redhat.com>
References: <20231116071338.678918-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

From: Xiubo Li <xiubli@redhat.com>

Update the oldest_client_tid via the session renew caps msg to
make sure that the MDSs won't pile up the completed request list
in a very large size.

URL: https://tracker.ceph.com/issues/63364
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fdfea11d9568..7d38b988273c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1579,6 +1579,9 @@ create_session_full_msg(struct ceph_mds_client *mdsc, int op, u64 seq)
 		size = METRIC_BYTES(count);
 	extra_bytes += 2 + 4 + 4 + size;
 
+	/* flags, mds auth caps and oldest_client_tid */
+	extra_bytes += 4 + 4 + 8;
+
 	/* Allocate the message */
 	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
 			   GFP_NOFS, false);
@@ -1597,9 +1600,9 @@ create_session_full_msg(struct ceph_mds_client *mdsc, int op, u64 seq)
 	 * Serialize client metadata into waiting buffer space, using
 	 * the format that userspace expects for map<string, string>
 	 *
-	 * ClientSession messages with metadata are v4
+	 * ClientSession messages with metadata are v7
 	 */
-	msg->hdr.version = cpu_to_le16(4);
+	msg->hdr.version = cpu_to_le16(7);
 	msg->hdr.compat_version = cpu_to_le16(1);
 
 	/* The write pointer, following the session_head structure */
@@ -1635,6 +1638,15 @@ create_session_full_msg(struct ceph_mds_client *mdsc, int op, u64 seq)
 		return ERR_PTR(ret);
 	}
 
+	/* version == 5, flags */
+	ceph_encode_32(&p, 0);
+
+	/* version == 6, mds auth caps */
+	ceph_encode_32(&p, 0);
+
+	/* version == 7, oldest_client_tid */
+	ceph_encode_64(&p, cpu_to_le64(mdsc->oldest_tid));
+
 	msg->front.iov_len = p - msg->front.iov_base;
 	msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
 
@@ -2030,10 +2042,12 @@ static int send_renew_caps(struct ceph_mds_client *mdsc,
 
 	doutc(cl, "to mds%d (%s)\n", session->s_mds,
 	      ceph_mds_state_name(state));
-	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_RENEWCAPS,
+
+	/* send connect message */
+	msg = create_session_full_msg(mdsc, CEPH_SESSION_REQUEST_RENEWCAPS,
 				      ++session->s_renew_seq);
-	if (!msg)
-		return -ENOMEM;
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 	ceph_con_send(&session->s_con, msg);
 	return 0;
 }
-- 
2.41.0


