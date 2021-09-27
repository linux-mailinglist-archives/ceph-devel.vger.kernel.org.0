Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D61419571
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Sep 2021 15:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbhI0Nyi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Sep 2021 09:54:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234589AbhI0Nyg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Sep 2021 09:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632750777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h8v+9N72BgHIgD6ApORDfXJFDysTcPhEtC+RC4wj6LQ=;
        b=VNGsQ9I+x0U5SLA0AbOuFuKPuzllNZIs7ijPqXIqfoJacZ/CWJJqCzjm4BuvdBlGe3I/8G
        TQoW24Feluh/2p3IGSdZSfdgci8EthxccFzcmirUsV2kjHj7Pgm9s1KdZRQ+QvWDtECYlx
        qfPD5oZ2jMOxkKHZ1/IMAcXTMOUF9F0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-a-dISFo4M3qpptUD_MvWBw-1; Mon, 27 Sep 2021 09:52:56 -0400
X-MC-Unique: a-dISFo4M3qpptUD_MvWBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 502AB18125C2;
        Mon, 27 Sep 2021 13:52:55 +0000 (UTC)
Received: from kotresh-T490s.redhat.com (unknown [10.67.24.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 960CD1000358;
        Mon, 27 Sep 2021 13:52:48 +0000 (UTC)
From:   khiremat@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v1] ceph: don't rely on error_string to validate blocklisted session.
Date:   Mon, 27 Sep 2021 19:22:27 +0530
Message-Id: <20210927135227.290145-1-khiremat@redhat.com>
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
 fs/ceph/mds_client.c         | 24 +++++++++++++++++++++---
 include/linux/ceph/ceph_fs.h |  2 ++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 44bc780b2b0e..cc1137468b29 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3396,9 +3396,15 @@ static void handle_session(struct ceph_mds_session *session,
 
 	if (msg_version >= 3) {
 		u32 len;
-		/* version >= 2, metadata */
-		if (__decode_session_metadata(&p, end, &blocklisted) < 0)
-			goto bad;
+		/* version >= 2 and < 5, decode metadata, skip otherwise
+		 * as it's handled via flags.
+		 */
+		if (msg_version >= 5) {
+			ceph_decode_skip_map(&p, end, string, string, bad);
+		} else {
+			if (__decode_session_metadata(&p, end, &blocklisted) < 0)
+				goto bad;
+		}
 		/* version >= 3, feature bits */
 		ceph_decode_32_safe(&p, end, len, bad);
 		if (len) {
@@ -3407,6 +3413,18 @@ static void handle_session(struct ceph_mds_session *session,
 		}
 	}
 
+	if (msg_version >= 5) {
+		u32 flags;
+		/* version >= 4, struct_v, struct_cv, len, metric_spec */
+	        ceph_decode_skip_n(&p, end, 2 + sizeof(u32) * 2, bad);
+		/* version >= 5, flags   */
+                ceph_decode_32_safe(&p, end, flags, bad);
+		if (flags & CEPH_SESSION_BLOCKLISTED) {
+		        pr_warn("mds%d session blocklisted\n", session->s_mds);
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

