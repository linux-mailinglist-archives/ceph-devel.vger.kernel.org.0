Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A731FAA44
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Jun 2020 09:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgFPHot (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 16 Jun 2020 03:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgFPHos (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 16 Jun 2020 03:44:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1E2C03E96A
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id y6so8247908edi.3
        for <ceph-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZbM1RYndbIseJODt2duRRRs16tKrRP5ZgVNKGiZJAV0=;
        b=U7vmVd9saIpqvVJY7ya3F1goaOX6pdQg0sREJfndexeZAilitffFHEBtcpK18F6UVj
         M/jLmBcaMsPEbCcFGZG8kg84yCijeZHLqfT4gZoF3l/zjFTx3ke1HtnWFVAUHTSJ0Doy
         TP+gRYxtgcyyLEfj2mqGxMUb1jBFm4WL9ya0VMK/CwevpSZG2VyGGR7QObCjVPQdwCLc
         nNLmixEQoZS/8KaSKI87SSEg/WofNU3T051b2nVQ0Kba0vFIlqjtcQrJC/cfNG68O+7s
         aIc3CWxlKDTgHk7oLRoDIPmYpXzkHsAh4LgWf+ia2QA5YRdRQTjiyDqSsEQuB+Y9NE4+
         bXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZbM1RYndbIseJODt2duRRRs16tKrRP5ZgVNKGiZJAV0=;
        b=pvqEWTPKgSP9y2AzFFLyk22H2Vxb8kgeUUuiws6cHUuHtdKCR0f5uvfaBl0KneF+4a
         IKGdzU/Lvk7qNLE1d9fZZ4kFkQ2hCargCgxTFfTuOchmuqjr/zdc4CvLrT1XJRKf9ZZh
         LvSnDgyMhJlEJcVsrQ1aePiVQgkPFlHDg2crdEMp+feAVixkvsPyT8A+zAU0P4/Wsg2X
         /Swk8yHSxd39rNSnYpxdNvBPvXfVceLgynZDL79rcJkq9flV+gfjJXzrsOa5090Pinam
         v9JufD0z8gfbhQL5Y0YqU34S2pZS2mObdikISVfMe7VFhL7wA8p1M3c6Q510HEmyib/h
         Cj3Q==
X-Gm-Message-State: AOAM531eAWcf1dXc2aDWM273Lyk32cYdLq9XJs3GzzrIusEvibyBKNhj
        DLz7QOX5sCCp4Q7BYpYsrh1GWuf2Gic=
X-Google-Smtp-Source: ABdhPJyjr8Qymw7tvDb5XyETBT0X3ctql5uj1nTyGW/ImAobNd/cVcfD30K7AcmlF+UubVfiAczerw==
X-Received: by 2002:a05:6402:6c6:: with SMTP id n6mr1322242edy.277.1592293484896;
        Tue, 16 Jun 2020 00:44:44 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id j2sm9684562edn.30.2020.06.16.00.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 00:44:44 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 3/3] libceph: use target_copy() in send_linger()
Date:   Tue, 16 Jun 2020 09:44:15 +0200
Message-Id: <20200616074415.9989-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200616074415.9989-1-idryomov@gmail.com>
References: <20200616074415.9989-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Instead of copying just oloc, oid and flags, copy the entire
linger target.  This is more for consistency than anything else,
as send_linger() -> submit_request() -> __submit_request() sends
the request regardless of what calc_target() says (i.e. both on
CALC_TARGET_NO_ACTION and CALC_TARGET_NEED_RESEND).

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 2db8b44e70c2..db6abb5a5511 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -3076,9 +3076,7 @@ static void send_linger(struct ceph_osd_linger_request *lreq)
 		cancel_linger_request(req);
 
 	request_reinit(req);
-	ceph_oid_copy(&req->r_base_oid, &lreq->t.base_oid);
-	ceph_oloc_copy(&req->r_base_oloc, &lreq->t.base_oloc);
-	req->r_flags = lreq->t.flags;
+	target_copy(&req->r_t, &lreq->t);
 	req->r_mtime = lreq->mtime;
 
 	mutex_lock(&lreq->lock);
-- 
2.19.2

