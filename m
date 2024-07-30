Return-Path: <ceph-devel+bounces-1610-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 341E09407B3
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 07:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37E551C21526
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Jul 2024 05:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B8F61684AE;
	Tue, 30 Jul 2024 05:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DoGTjZ6B"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC1616848B
	for <ceph-devel@vger.kernel.org>; Tue, 30 Jul 2024 05:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722318116; cv=none; b=FMLRIcpHrb3YLWcfGN1TKmgMN031CD092t63DFAi8lCfuef47gRV+OMtMyN9jOK+hGvIQZVWCzSJshZ4iYJzNNiwFEqWVsVAv5K433O1ZP3z7BD/JL+CtLWGThOdPOZWE9GRVcEQnpGOcH9gS8/fILPWq/wHcgrxC8fs3KUjoBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722318116; c=relaxed/simple;
	bh=j6iGSDDXspkdbyuDhzChst+ps1b3VPoiTGtYcaQGBh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gE3MkoCaPyr9evf5n2XluHRS7+qabz2V52ftvm/zL6Cw61RWnBM58DQTseN4t2safWqZS0KhCIZZ3cuIaZdYtVS1mkbT3p107wGRBLExpwb0jXVmoBrc0dlfUtK8Lv7v9OuMLEXc/+ge9UpQeXPFuMbdw+I8ZGr1aHlPSkIojww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DoGTjZ6B; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722318113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a0DH4zz7YHwQBQpJd+MnY67aRAwF7OXrdYHAF+R4Fzk=;
	b=DoGTjZ6B/kZOVodlkujeJtwNELHMRVehvOuCUs9rEmdAvl5UIFkNJcpgLNeN9p6hU++qat
	clcdD33Gfyhbuk7Zu5lLfFR3tWlGPjFvzZdtdUAZTYcxj1NyqC7xn4W9o7h/lBX6eDp+9V
	NwkBP5e5m7Iq98NYCOIpusOtqBMIYdU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-6K6Cm5loMOKj-q0IYnaNNQ-1; Tue,
 30 Jul 2024 01:41:50 -0400
X-MC-Unique: 6K6Cm5loMOKj-q0IYnaNNQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F2E219560B0;
	Tue, 30 Jul 2024 05:41:49 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.72.116.98])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 96A5019560AE;
	Tue, 30 Jul 2024 05:41:46 +0000 (UTC)
From: xiubli@redhat.com
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	vshankar@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/2] ceph: rename ceph_flush_cap_releases to ceph_flush_session_cap_releases
Date: Tue, 30 Jul 2024 13:41:34 +0800
Message-ID: <20240730054135.640396-2-xiubli@redhat.com>
In-Reply-To: <20240730054135.640396-1-xiubli@redhat.com>
References: <20240730054135.640396-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: Xiubo Li <xiubli@redhat.com>

Prepare for adding a helper to flush the cap releases for all
sessions.

URL: https://tracker.ceph.com/issues/67221
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c       |  2 +-
 fs/ceph/mds_client.c | 10 +++++-----
 fs/ceph/mds_client.h |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 28ab4d42fde8..c09add6d6516 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4630,7 +4630,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		__ceph_queue_cap_release(session, cap);
 		spin_unlock(&session->s_cap_lock);
 	}
-	ceph_flush_cap_releases(mdsc, session);
+	ceph_flush_session_cap_releases(mdsc, session);
 	goto done;
 
 bad:
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b7fcaa6e28b4..86d0148819b0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2266,7 +2266,7 @@ int ceph_trim_caps(struct ceph_mds_client *mdsc,
 		      trim_caps - remaining);
 	}
 
-	ceph_flush_cap_releases(mdsc, session);
+	ceph_flush_session_cap_releases(mdsc, session);
 	return 0;
 }
 
@@ -2448,7 +2448,7 @@ static void ceph_cap_release_work(struct work_struct *work)
 	ceph_put_mds_session(session);
 }
 
-void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
+void ceph_flush_session_cap_releases(struct ceph_mds_client *mdsc,
 		             struct ceph_mds_session *session)
 {
 	struct ceph_client *cl = mdsc->fsc->client;
@@ -2475,7 +2475,7 @@ void __ceph_queue_cap_release(struct ceph_mds_session *session,
 	session->s_num_cap_releases++;
 
 	if (!(session->s_num_cap_releases % CEPH_CAPS_PER_RELEASE))
-		ceph_flush_cap_releases(session->s_mdsc, session);
+		ceph_flush_session_cap_releases(session->s_mdsc, session);
 }
 
 static void ceph_cap_reclaim_work(struct work_struct *work)
@@ -4368,7 +4368,7 @@ static void handle_session(struct ceph_mds_session *session,
 		/* flush cap releases */
 		spin_lock(&session->s_cap_lock);
 		if (session->s_num_cap_releases)
-			ceph_flush_cap_releases(mdsc, session);
+			ceph_flush_session_cap_releases(mdsc, session);
 		spin_unlock(&session->s_cap_lock);
 
 		send_flushmsg_ack(mdsc, session, seq);
@@ -5474,7 +5474,7 @@ static void delayed_work(struct work_struct *work)
 		}
 		mutex_unlock(&mdsc->mutex);
 
-		ceph_flush_cap_releases(mdsc, s);
+		ceph_flush_session_cap_releases(mdsc, s);
 
 		mutex_lock(&s->s_mutex);
 		if (renew_caps)
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 9bcc7f181bfe..6bff2661b202 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -602,8 +602,8 @@ extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
 extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
 extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
 				    struct ceph_cap *cap);
-extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
-				    struct ceph_mds_session *session);
+extern void ceph_flush_session_cap_releases(struct ceph_mds_client *mdsc,
+					    struct ceph_mds_session *session);
 extern void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc);
 extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
 extern void ceph_queue_cap_unlink_work(struct ceph_mds_client *mdsc);
-- 
2.43.0


