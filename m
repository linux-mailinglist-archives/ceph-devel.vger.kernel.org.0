Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6333ACD81
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Jun 2021 16:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhFROac (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Jun 2021 10:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhFROa3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Jun 2021 10:30:29 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E276C061767;
        Fri, 18 Jun 2021 07:28:19 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n12so7932310pgs.13;
        Fri, 18 Jun 2021 07:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tm11RJe8XH3mdKITm6gC95oTddXOFvmbaLmxC4TGSiw=;
        b=SLa8kVghAr94SqXyOijxmRMN7A0I60AyztWLpKL9hNi7i4MzClExVb2jrdmURI8DeC
         7xwKnu9uJ+j9423xu73s90wi8ZDsVYVBimQyflBz3JCgAWZaIUVgQJLIc3hVfvdIypb4
         4tuYpWv+nCElzJ6oA0R5W7RCTxv4QCmrgmtQU+G8fGfW4u34ZRIoz2kdtR04hos9LI0f
         /Jd7XP6iSGilnHTMEWbslYUufw3u0xx1R0jYElQymvNRxqfwsX6i4Orfr+3prZwCS754
         UaNqUb35qfiGUSeDQ1qwEM7bcOTwJeK+vW3Zh0bMzqj8CcyZVTa50wFAeZHS/7sQKk5G
         BOxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tm11RJe8XH3mdKITm6gC95oTddXOFvmbaLmxC4TGSiw=;
        b=UQi382Jw6/5e/xYfYvyPreFFYoJ8abe1ZfkI1mKSkl/o9WxSnhKItztBlGLjVHLh9q
         T+9gStmyYfEzLE+9GAtjvVUle2GWVyFjQCqFO0iVzrtpWi36Bzce8Sr48OoUxF8mTnsB
         WsvFaCEVyGBFXY+F3A7KwYywmtemFHNkiYlG9DPURz80v2GJbOapQAEIlcR54CGi3LSn
         JV5DN0vVnXyTaloy0yunVh4IGsR5Z6GUlaitsmXikoritFDrb7A7CBuxWeTMGFJzSOqP
         WTcxyK8rW28+YmiSd5hJj5n/PIxsvFnx9zrdDjc44bsjfBtYbcnTd3zk93MyTai+YhT2
         unbw==
X-Gm-Message-State: AOAM530BCr/EdOmVL0D1loqV4LojjUIjRDKrmDvzwdswt/2pAicWZN+h
        UOWDcJoR3R3M3XYxqwesxWpNMrD1ABAudDIq
X-Google-Smtp-Source: ABdhPJwV07b5cexacO+EgdFjbtQ8wII+ncZYecQ78YQE8X1FZmJNS+3LBSpHUst4wQLbcTknCW43fg==
X-Received: by 2002:a63:b645:: with SMTP id v5mr10351740pgt.15.1624026499001;
        Fri, 18 Jun 2021 07:28:19 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id v4sm4658167pjh.54.2021.06.18.07.28.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Jun 2021 07:28:18 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     idryomov@gmail.com, jlayton@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yejune Deng <yejune.deng@gmail.com>
Subject: [PATCH] net: ceph: Use CLOCK_MONOTONIC ktime_get_ts64()
Date:   Fri, 18 Jun 2021 22:27:40 +0800
Message-Id: <20210618142740.3345-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The Documentation/core-api/timekeeping.rst recommend that we should use
monotonic time ktime_get_ts64(), to avoid glitches with a concurrent
settimeofday().

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ceph/messenger.c    | 2 +-
 net/ceph/messenger_v1.c | 2 +-
 net/ceph/messenger_v2.c | 2 +-
 net/ceph/osd_client.c   | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 57d043b..2d07ab5 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1809,7 +1809,7 @@ bool ceph_con_keepalive_expired(struct ceph_connection *con,
 	    (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2)) {
 		struct timespec64 now;
 		struct timespec64 ts;
-		ktime_get_real_ts64(&now);
+		ktime_get_ts64(&now);
 		jiffies_to_timespec64(interval, &ts);
 		ts = timespec64_add(con->last_keepalive_ack, ts);
 		return timespec64_compare(&now, &ts) >= 0;
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 2cb5ffd..2ec7b1d 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -310,7 +310,7 @@ static void prepare_write_keepalive(struct ceph_connection *con)
 	if (con->peer_features & CEPH_FEATURE_MSGR_KEEPALIVE2) {
 		struct timespec64 now;
 
-		ktime_get_real_ts64(&now);
+		ktime_get_ts64(&now);
 		con_out_kvec_add(con, sizeof(tag_keepalive2), &tag_keepalive2);
 		ceph_encode_timespec64(&con->v1.out_temp_keepalive2, &now);
 		con_out_kvec_add(con, sizeof(con->v1.out_temp_keepalive2),
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index cc40ce4..2125e77 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1439,7 +1439,7 @@ static int prepare_keepalive2(struct ceph_connection *con)
 	struct ceph_timespec *ts = CTRL_BODY(con->v2.out_buf);
 	struct timespec64 now;
 
-	ktime_get_real_ts64(&now);
+	ktime_get_ts64(&now);
 	dout("%s con %p timestamp %lld.%09ld\n", __func__, con, now.tv_sec,
 	     now.tv_nsec);
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a..5192a8a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4717,7 +4717,7 @@ ceph_osdc_watch(struct ceph_osd_client *osdc,
 	ceph_oid_copy(&lreq->t.base_oid, oid);
 	ceph_oloc_copy(&lreq->t.base_oloc, oloc);
 	lreq->t.flags = CEPH_OSD_FLAG_WRITE;
-	ktime_get_real_ts64(&lreq->mtime);
+	ktime_get_ts64(&lreq->mtime);
 
 	lreq->reg_req = alloc_watch_request(lreq, CEPH_OSD_WATCH_OP_WATCH);
 	if (!lreq->reg_req) {
@@ -4767,7 +4767,7 @@ int ceph_osdc_unwatch(struct ceph_osd_client *osdc,
 	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
 	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
-	ktime_get_real_ts64(&req->r_mtime);
+	ktime_get_ts64(&req->r_mtime);
 	osd_req_op_watch_init(req, 0, lreq->linger_id,
 			      CEPH_OSD_WATCH_OP_UNWATCH);
 
-- 
2.7.4

