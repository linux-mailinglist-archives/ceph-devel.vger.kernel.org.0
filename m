Return-Path: <ceph-devel+bounces-1142-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 045658C7F23
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2024 02:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68EB8B20EFB
	for <lists+ceph-devel@lfdr.de>; Fri, 17 May 2024 00:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA16038B;
	Fri, 17 May 2024 00:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lzy6DT4J"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36416384
	for <ceph-devel@vger.kernel.org>; Fri, 17 May 2024 00:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715905270; cv=none; b=aQ9kUd7qTQRk97HHwuWXbwSMcU29gS6O/gG9mAYrCVlCIl2/eHG2LrG46xA+I2PQZft6fy9eBgCHTJl4OCTFtXsy1EZ6k17UPE0r1QKn23spShwHBdORTexOzB8+BxQzP6KT2Isdzzr4BVHTE1jyTfKtu5Kj2QJOccQ6ZrxjWgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715905270; c=relaxed/simple;
	bh=fdQepyKEb+ye3+NE2uj9C5z+tzKGS066eESLJ2ENmZk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pgrkg3jEpy264Wu77mVDshZJHlJGQvEbEkR6dZBoAvRxrfFbGkY2mi9ZQB6sRgFRuZfOAjWOceSqf2HfWy5yxRy+Q/u/hbMIFUuwMqph0STXbOc5tkGvfLghOwOjI52XkVp4lbtLw5suUCS+11hdzHhkwiTUYCka3LddJMr3bxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lzy6DT4J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715905267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fx4z0mRnVWbAFutMTB1vUals5nTyM1ZQak7npzAX9OE=;
	b=Lzy6DT4JVMHOrzJKjDLaXAvcWGGBdX6T1KXVFjZ8zxB61if6ruHTdLyn5g+7c25rfc6Uuz
	2y8lBy6ygAqHOv5vPYvYt6nMMmkvY7Rx6zExjsyYNAH0AMjcbvFxvNiTogdS8NfFdTQdM7
	3Bp9+2k7vFi1YKHIXKqnUtjQ0SBlyUA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-JdsQI5DgM86cRdct9mPK3w-1; Thu, 16 May 2024 20:21:03 -0400
X-MC-Unique: JdsQI5DgM86cRdct9mPK3w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92CFC185A780;
	Fri, 17 May 2024 00:21:03 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.87])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D86B9400057;
	Fri, 17 May 2024 00:21:00 +0000 (UTC)
From: xiubli@redhat.com
To: idryomov@gmail.com,
	ceph-devel@vger.kernel.org
Cc: vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: cleanup the sessions when peer reset
Date: Fri, 17 May 2024 08:20:55 +0800
Message-ID: <20240517002055.407084-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

From: Xiubo Li <xiubli@redhat.com>

The reconnect feature never been supported by MDS in mds non-RECONNECT
state. This reconnect requests will incorrectly close the just reopened
sessions when the MDS kills them during the "mds_session_blocklist_on_evict"
option is disabled.

Fixes: 7e70f0ed9f3e ("ceph: attempt mds reconnect if mds closes our session")
URL: https://tracker.ceph.com/issues/65647
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Try to cleanup the sessions and retry the requests.



 fs/ceph/mds_client.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index f5b25d178118..50c06a03b5fe 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -6241,9 +6241,40 @@ static void mds_peer_reset(struct ceph_connection *con)
 
 	pr_warn_client(mdsc->fsc->client, "mds%d closed our session\n",
 		       s->s_mds);
-	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO &&
-	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) >= CEPH_MDS_STATE_RECONNECT)
+
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO ||
+	    ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) < CEPH_MDS_STATE_RECONNECT)
+		return;
+
+	if (ceph_mdsmap_get_state(mdsc->mdsmap, s->s_mds) == CEPH_MDS_STATE_RECONNECT) {
 		send_mds_reconnect(mdsc, s);
+		return;
+	}
+
+	mutex_lock(&s->s_mutex);
+	switch (s->s_state) {
+	case CEPH_MDS_SESSION_CLOSING:
+	case CEPH_MDS_SESSION_OPEN:
+	case CEPH_MDS_SESSION_OPENING:
+		mutex_lock(&mdsc->mutex);
+		ceph_get_mds_session(s);
+		__unregister_session(mdsc, s);
+		mutex_unlock(&mdsc->mutex);
+
+		s->s_state = CEPH_MDS_SESSION_CLOSED;
+		cleanup_session_requests(mdsc, s);
+		remove_session_caps(s);
+		wake_up_all(&mdsc->session_close_wq);
+
+		mutex_lock(&mdsc->mutex);
+		__wake_requests(mdsc, &s->s_waiting);
+		kick_requests(mdsc, s->s_mds);
+		mutex_unlock(&mdsc->mutex);
+
+		ceph_put_mds_session(s);
+		break;
+	}
+	mutex_unlock(&s->s_mutex);
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
-- 
2.44.0


