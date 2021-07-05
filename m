Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A5C3BB4A1
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jul 2021 03:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGEBZt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Jul 2021 21:25:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229771AbhGEBZs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Jul 2021 21:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625448192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9IS4za+wo5C6JL073IOBW/9FVdDujPElcAtaeoeJr8=;
        b=ScqzNZl1uY1Wf5DaCGw/KVMj4ck/GQhks3USlIc/cXIGxsE6Tn1/0qfR1q0rHNo5bCqQgq
        dZac7leFPaQRCkgVLS1WHElhHy3b65EprGP1eeBtMDPEk5QkXMmL7RYfOzUW9oXxRgvMti
        tbJUxZeW9GfI0QjU0chmP8hUEhhkADo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-Rcvzb2JwPa2yTKVctrGigQ-1; Sun, 04 Jul 2021 21:23:10 -0400
X-MC-Unique: Rcvzb2JwPa2yTKVctrGigQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 728D01005E46;
        Mon,  5 Jul 2021 01:23:09 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86FE260875;
        Mon,  5 Jul 2021 01:23:07 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/4] ceph: flush mdlog before umounting
Date:   Mon,  5 Jul 2021 09:22:56 +0800
Message-Id: <20210705012257.182669-4-xiubli@redhat.com>
In-Reply-To: <20210705012257.182669-1-xiubli@redhat.com>
References: <20210705012257.182669-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         | 25 +++++++++++++++++++++++++
 fs/ceph/mds_client.h         |  1 +
 fs/ceph/strings.c            |  1 +
 include/linux/ceph/ceph_fs.h |  1 +
 4 files changed, 28 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 5c3ec7eb8141..79aa4ce3a388 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4690,6 +4690,30 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 	dout("wait_requests done\n");
 }
 
+void send_flush_mdlog(struct ceph_mds_session *s)
+{
+	struct ceph_msg *msg;
+
+	/*
+	 * Pre-luminous MDS crashes when it sees an unknown session request
+	 */
+	if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
+		return;
+
+	mutex_lock(&s->s_mutex);
+	dout("request mdlog flush to mds%d (%s)s seq %lld\n", s->s_mds,
+	     ceph_session_state_name(s->s_state), s->s_seq);
+	msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG,
+				      s->s_seq);
+	if (!msg) {
+		pr_err("failed to request mdlog flush to mds%d (%s) seq %lld\n",
+		       s->s_mds, ceph_session_state_name(s->s_state), s->s_seq);
+	} else {
+		ceph_con_send(&s->s_con, msg);
+	}
+	mutex_unlock(&s->s_mutex);
+}
+
 /*
  * called before mount is ro, and before dentries are torn down.
  * (hmm, does this still race with new lookups?)
@@ -4699,6 +4723,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	dout("pre_umount\n");
 	mdsc->stopping = 1;
 
+	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
 	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
 	ceph_flush_dirty_caps(mdsc);
 	wait_requests(mdsc);
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index fca2cf427eaf..a7af09257382 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -523,6 +523,7 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern void send_flush_mdlog(struct ceph_mds_session *s);
 extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
 				       void (*cb)(struct ceph_mds_session *),
 				       bool check_state);
diff --git a/fs/ceph/strings.c b/fs/ceph/strings.c
index 4a79f3632260..573bb9556fb5 100644
--- a/fs/ceph/strings.c
+++ b/fs/ceph/strings.c
@@ -46,6 +46,7 @@ const char *ceph_session_op_name(int op)
 	case CEPH_SESSION_FLUSHMSG_ACK: return "flushmsg_ack";
 	case CEPH_SESSION_FORCE_RO: return "force_ro";
 	case CEPH_SESSION_REJECT: return "reject";
+	case CEPH_SESSION_REQUEST_FLUSH_MDLOG: return "flush_mdlog";
 	}
 	return "???";
 }
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

