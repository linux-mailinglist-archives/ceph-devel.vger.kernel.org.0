Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91497415FB5
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Sep 2021 15:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhIWN1r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Sep 2021 09:27:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231974AbhIWN1r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 09:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632403574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4K8Lblas37tRH19S6nKCuhg0S7vZVHdOR08y/HctyHI=;
        b=Gz+4RgvAolGngVtFolGA8L7ndH54+4N6ZRNeQXgbhMwAMn4ox0pBP2ZCYavcqJxIMg+GNv
        Qlr4s4mh/J3ilrduzhAkxGCupjxAT+NaYICeM87H2LBsGcuF8BRSsjO7QMjE6oS6LVFhxV
        BLSEwjpLXiv5a+P5v96MYF5gbgTnGgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-sn6sFlNXPyS_8J7tI0uXSA-1; Thu, 23 Sep 2021 09:26:13 -0400
X-MC-Unique: sn6sFlNXPyS_8J7tI0uXSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 246D91006AA4;
        Thu, 23 Sep 2021 13:26:12 +0000 (UTC)
Received: from kotresh-T490s.redhat.com (unknown [10.67.25.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D0DF1000358;
        Thu, 23 Sep 2021 13:26:09 +0000 (UTC)
From:   khiremat@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, Kotresh HR <khiremat@redhat.com>
Subject: [PATCH] ceph: don't rely on error_string to validate blocklisted session.
Date:   Thu, 23 Sep 2021 18:56:07 +0530
Message-Id: <20210923132607.81693-1-khiremat@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Kotresh HR <khiremat@redhat.com>

The "error_string" in the metadata of MClientSession is being
parsed by kclient to validate whether the session is blocklisted.
The "error_string" is for humans and shouldn't be relied on it.
Hence added the flag to MClientsession to indicate the session
is blocklisted.

URL: https://tracker.ceph.com/issues/47450
Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/mds_client.c         | 13 +++++++++++++
 include/linux/ceph/ceph_fs.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 44bc780b2b0e..f3c023c17963 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3407,6 +3407,19 @@ static void handle_session(struct ceph_mds_session *session,
 		}
 	}
 
+	if (msg_version >= 5) {
+		u32 len;
+		u32 flags;
+		/* version >= 4, metric_spec (struct_v, struct_cv, len, metric_flag) */
+	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
+		/* version >= 5, flags   */
+                ceph_decode_32_safe(&p, end, flags, bad);
+		if (flags & CEPH_SESSION_BLOCKLISTED) {
+		        pr_info("mds%d session blocklisted\n", session->s_mds);
+			blocklisted = true;
+		}
+	}
+
 	mutex_lock(&mdsc->mutex);
 	if (op == CEPH_SESSION_CLOSE) {
 		ceph_get_mds_session(session);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index bc2699feddbe..7ad6c3d0db7d 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -302,6 +302,8 @@ enum {
 	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
 };
 
+#define CEPH_SESSION_BLOCKLISTED	(1 << 0)  /* session blocklisted */
+
 extern const char *ceph_session_op_name(int op);
 
 struct ceph_mds_session_head {
-- 
2.25.1

