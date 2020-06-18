Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FFB1FF118
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Jun 2020 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgFRMBF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Jun 2020 08:01:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33024 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725944AbgFRMBE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 08:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592481662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Edo2pNvStDueLzHmdjkYJ98uJ+oPPlJWVo6KSmaEw2Q=;
        b=fu283frB9R04F6Jt6kkVbl/nMRB/3nb0HxFba4nktbKQpvUiG1ZRL5rOofDQVZwtDKZkhW
        r6DQKRabbl/SBjkjS+Ho8VwbCO+7IasHMqcwMf13sTZ4iqRd8tc97BdIkRDClyDt3Hl1Kz
        thJSV2CSecXBVxcHJClQeSjWwPRxmB4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-TswW-1NpNYOOJK7aVMqhTw-1; Thu, 18 Jun 2020 08:01:00 -0400
X-MC-Unique: TswW-1NpNYOOJK7aVMqhTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D8C68005AD;
        Thu, 18 Jun 2020 12:00:59 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm37-55.gsslab.pek2.redhat.com [10.72.37.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 479FD6ED96;
        Thu, 18 Jun 2020 12:00:57 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/5] ceph: check the METRIC_COLLECT feature before sending metrics
Date:   Thu, 18 Jun 2020 07:59:57 -0400
Message-Id: <1592481599-7851-4-git-send-email-xiubli@redhat.com>
In-Reply-To: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
References: <1592481599-7851-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Skip the MDS sessions if they don't support the metric collection,
or the MDSs will close the socket connections directly when it get
an unknown type message.

URL: https://tracker.ceph.com/issues/43215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.h | 4 +++-
 fs/ceph/metric.c     | 8 ++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index bcb3892..3c65ac1 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -28,8 +28,9 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,
 	CEPHFS_FEATURE_MULTI_RECONNECT,
 	CEPHFS_FEATURE_DELEG_INO,
+	CEPHFS_FEATURE_METRIC_COLLECT,
 
-	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
+	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
 };
 
 /*
@@ -43,6 +44,7 @@ enum ceph_feature_type {
 	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
 	CEPHFS_FEATURE_MULTI_RECONNECT,		\
 	CEPHFS_FEATURE_DELEG_INO,		\
+	CEPHFS_FEATURE_METRIC_COLLECT,		\
 						\
 	CEPHFS_FEATURE_MAX,			\
 }
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 27cb541..4267b46 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -127,6 +127,14 @@ static void metric_delayed_work(struct work_struct *work)
 			continue;
 		}
 
+		/*
+		 * Skip it if MDS doesn't support the metric collection,
+		 * or the MDS will close the session's socket connection
+		 * directly when it get this message.
+		 */
+		if (!test_bit(CEPHFS_FEATURE_METRIC_COLLECT, &s->s_features))
+			continue;
+
 		/* Only send the metric once in any available session */
 		ret = ceph_mdsc_send_metrics(mdsc, s, nr_caps);
 		ceph_put_mds_session(s);
-- 
1.8.3.1

