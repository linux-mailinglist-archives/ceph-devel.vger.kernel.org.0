Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696363B6DB1
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 06:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhF2Ep1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 00:45:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230416AbhF2EpY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 00:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624941777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjTp3SqeZLzVNTfWTv2ZJZ8pFh7Wb4ShbTqkja49wTs=;
        b=XkdVWRys9iEm+WCZbikSkhE83PLq33vxHqtL6jZCjY0TOjscb58jDBqqPZvG2g6gGhlR2v
        tQrOzoZ/ZUZP52PRNbIjwAjKecS424ocJvtsu3FTKMPuX4gY7AhrmImIWU3fTGUn7Wes5j
        tEJ6m/Wt1vjU3pqr9meoA8ADkkEQNSQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-5pN_5luzPO-tLPggCJjIzA-1; Tue, 29 Jun 2021 00:42:55 -0400
X-MC-Unique: 5pN_5luzPO-tLPggCJjIzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F076E804140;
        Tue, 29 Jun 2021 04:42:53 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AF155D9DC;
        Tue, 29 Jun 2021 04:42:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/5] ceph: flush mdlog before umounting
Date:   Tue, 29 Jun 2021 12:42:39 +0800
Message-Id: <20210629044241.30359-4-xiubli@redhat.com>
In-Reply-To: <20210629044241.30359-1-xiubli@redhat.com>
References: <20210629044241.30359-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         | 29 +++++++++++++++++++++++++++++
 fs/ceph/mds_client.h         |  1 +
 include/linux/ceph/ceph_fs.h |  1 +
 3 files changed, 31 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 96bef289f58f..2db87a5c68d4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4689,6 +4689,34 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 	dout("wait_requests done\n");
 }
 
+static void send_flush_mdlog(struct ceph_mds_session *s)
+{
+	u64 seq = s->s_seq;
+	struct ceph_msg *msg;
+
+	/*
+	 * For the MDS daemons lower than Luminous will crash when it
+	 * saw this unknown session request.
+	 */
+	if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
+		return;
+
+	dout("send_flush_mdlog to mds%d (%s)s seq %lld\n",
+	     s->s_mds, ceph_session_state_name(s->s_state), seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG, seq);
+	if (!msg) {
+		pr_err("failed to send_flush_mdlog to mds%d (%s)s seq %lld\n",
+		       s->s_mds, ceph_session_state_name(s->s_state), seq);
+	} else {
+		ceph_con_send(&s->s_con, msg);
+	}
+}
+
+void flush_mdlog(struct ceph_mds_client *mdsc)
+{
+	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
+}
+
 /*
  * called before mount is ro, and before dentries are torn down.
  * (hmm, does this still race with new lookups?)
@@ -4698,6 +4726,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	dout("pre_umount\n");
 	mdsc->stopping = 1;
 
+	flush_mdlog(mdsc);
 	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
 	ceph_flush_dirty_caps(mdsc);
 	wait_requests(mdsc);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index fca2cf427eaf..79d5b8ed62bf 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -537,6 +537,7 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
 				     int (*cb)(struct inode *,
 					       struct ceph_cap *, void *),
 				     void *arg);
+extern void flush_mdlog(struct ceph_mds_client *mdsc);
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
 static inline void ceph_mdsc_free_path(char *path, int len)
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 57e5bd63fb7a..ae60696fe40b 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -300,6 +300,7 @@ enum {
 	CEPH_SESSION_FLUSHMSG_ACK,
 	CEPH_SESSION_FORCE_RO,
 	CEPH_SESSION_REJECT,
+	CEPH_SESSION_REQUEST_FLUSH_MDLOG,
 };
 
 extern const char *ceph_session_op_name(int op);
-- 
2.27.0

