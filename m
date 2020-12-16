Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452CD2DC868
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 22:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLPVjA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 16:39:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgLPVi7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Dec 2020 16:38:59 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A533C061794
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 13:38:19 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id c7so26455457edv.6
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 13:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VKvLB3ePf5GtEqWTVPJztO++oHStyG0J0IlP5bH/gIM=;
        b=n4VJ6TE2eVo9eW0lbYHoPNlq5ig9HPoozCshWdTirHbUDUg36fmxdqD1QJR+/JWPpH
         cCXSojh82vzhURVCOvMtBKHfoRiU/HL9Q1B8aGNf6lPEpbCSGiqulatocGCnzlIz+5Xl
         xxoZ1kWED4pphsd3YpVsTnMUtDW3BAR1bZ40sM5wf9k+cHFitVNyQryMOrJEnkcX1y3K
         8s5FX7zsMZCpzek6EnaKXGSmnkxNh4gycgJlXQfxt0/JpZ+Ye2czFZ8Mqqi/4Xfi2IfT
         CcRk1jOG2soBOG6g2J2CefUm/mW9z7LnFTt3AXW7wR+IwuJhkXRi6ZMF9/i0Vn32Wtcr
         56jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VKvLB3ePf5GtEqWTVPJztO++oHStyG0J0IlP5bH/gIM=;
        b=ow0m69pX7bPBb3/dlwcs30c95Aoc3sHXWe4eZtfYlioZbswAaszc2nnuqnyT6gwt2J
         +bZ6OKeGxA0BGNH2jqLDBPUA4VwLZ1rSzlEe1sTVeviLtn6TJG6a5b30Mixg72GNOMty
         Y2DJ6rRmGR7DQ4tcsO9ZTelpFDQqeJSrIGKiTd1jg7wW3kP1XteMD/ytA/LMZL5Wp7YZ
         frntdZZdTnSbvFm5FOuR5uE0+g5wjenLJKtSiKiNdfE51tC4P9HdbjfCM2TTf0IXpxX5
         CWfwH+MwBJplGC+OeunArouNqJV/04rqQ8AX7eTAEICbi1CwYfkSmYgss1EMFy0QVA+h
         /bxQ==
X-Gm-Message-State: AOAM5328nSD7q1QfpFEixJT6H0ZVDxIncPZ8iW18yGrM5ovwozfbKS4K
        OwkAhrMdDnaWP7QscfS+gX5D4naDjQw=
X-Google-Smtp-Source: ABdhPJxfsaVJdxXS6iqmGKf+MA1hS43WawzKXLDqNW8XIKogLJGqXBliBPbbA/MhEjZ14rDdfUHxeQ==
X-Received: by 2002:a50:9354:: with SMTP id n20mr36400406eda.231.1608154698073;
        Wed, 16 Dec 2020 13:38:18 -0800 (PST)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id k21sm23026427edq.26.2020.12.16.13.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 13:38:17 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] ceph: reencode gid_list when reconnecting
Date:   Wed, 16 Dec 2020 22:38:04 +0100
Message-Id: <20201216213804.30419-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On reconnect, cap and dentry releases are dropped and the fields
that follow must be reencoded into the freed space.  Currently these
are timestamp and gid_list, but gid_list isn't reencoded.  This
results in

  failed to decode message of type 24 v4: End of buffer

errors on the MDS.

While at it, make a change to encode gid_list unconditionally,
without regard to what head/which version was used as a result
of checking whether CEPH_FEATURE_FS_BTIME is supported or not.

URL: https://tracker.ceph.com/issues/48618
Fixes: 4f1ddb1ea874 ("ceph: implement updated ceph_mds_request_head structure")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/ceph/mds_client.c | 53 ++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 98c15ff2e599..840587037b59 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2475,6 +2475,22 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
 	return r;
 }
 
+static void encode_timestamp_and_gids(void **p,
+				      const struct ceph_mds_request *req)
+{
+	struct ceph_timespec ts;
+	int i;
+
+	ceph_encode_timespec64(&ts, &req->r_stamp);
+	ceph_encode_copy(p, &ts, sizeof(ts));
+
+	/* gid_list */
+	ceph_encode_32(p, req->r_cred->group_info->ngroups);
+	for (i = 0; i < req->r_cred->group_info->ngroups; i++)
+		ceph_encode_64(p, from_kgid(&init_user_ns,
+					    req->r_cred->group_info->gid[i]));
+}
+
 /*
  * called under mdsc->mutex
  */
@@ -2491,7 +2507,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	u64 ino1 = 0, ino2 = 0;
 	int pathlen1 = 0, pathlen2 = 0;
 	bool freepath1 = false, freepath2 = false;
-	int len, i;
+	int len;
 	u16 releases;
 	void *p, *end;
 	int ret;
@@ -2517,17 +2533,10 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 		goto out_free1;
 	}
 
-	if (legacy) {
-		/* Old style */
-		len = sizeof(*head);
-	} else {
-		/* New style: add gid_list and any later fields */
-		len = sizeof(struct ceph_mds_request_head) + sizeof(u32) +
-		      (sizeof(u64) * req->r_cred->group_info->ngroups);
-	}
-
+	len = legacy ? sizeof(*head) : sizeof(struct ceph_mds_request_head);
 	len += pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
 		sizeof(struct ceph_timespec);
+	len += sizeof(u32) + (sizeof(u64) * req->r_cred->group_info->ngroups);
 
 	/* calculate (max) length for cap releases */
 	len += sizeof(struct ceph_mds_request_release) *
@@ -2548,7 +2557,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 	msg->hdr.tid = cpu_to_le64(req->r_tid);
 
 	/*
-	 * The old ceph_mds_request_header didn't contain a version field, and
+	 * The old ceph_mds_request_head didn't contain a version field, and
 	 * one was added when we moved the message version from 3->4.
 	 */
 	if (legacy) {
@@ -2609,20 +2618,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
 
 	head->num_releases = cpu_to_le16(releases);
 
-	/* time stamp */
-	{
-		struct ceph_timespec ts;
-		ceph_encode_timespec64(&ts, &req->r_stamp);
-		ceph_encode_copy(&p, &ts, sizeof(ts));
-	}
-
-	/* gid list */
-	if (!legacy) {
-		ceph_encode_32(&p, req->r_cred->group_info->ngroups);
-		for (i = 0; i < req->r_cred->group_info->ngroups; i++)
-			ceph_encode_64(&p, from_kgid(&init_user_ns,
-				       req->r_cred->group_info->gid[i]));
-	}
+	encode_timestamp_and_gids(&p, req);
 
 	if (WARN_ON_ONCE(p > end)) {
 		ceph_msg_put(msg);
@@ -2730,13 +2726,8 @@ static int __prepare_send_request(struct ceph_mds_session *session,
 		/* remove cap/dentry releases from message */
 		rhead->num_releases = 0;
 
-		/* time stamp */
 		p = msg->front.iov_base + req->r_request_release_offset;
-		{
-			struct ceph_timespec ts;
-			ceph_encode_timespec64(&ts, &req->r_stamp);
-			ceph_encode_copy(&p, &ts, sizeof(ts));
-		}
+		encode_timestamp_and_gids(&p, req);
 
 		msg->front.iov_len = p - msg->front.iov_base;
 		msg->hdr.front_len = cpu_to_le32(msg->front.iov_len);
-- 
2.19.2

