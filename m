Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9763117043E
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 17:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgBZQXD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Feb 2020 11:23:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39414 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726583AbgBZQXC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Feb 2020 11:23:02 -0500
Received: by mail-wm1-f65.google.com with SMTP id c84so3872373wme.4
        for <ceph-devel@vger.kernel.org>; Wed, 26 Feb 2020 08:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IU02G2SCH5E+ATDz9hd+zgG8PRvB3leghHbtZysVp0=;
        b=eCQfNf/zWH9Qhorueub5/eJQ81mZmvWHU1q1ZeG3FZSPI4GT1MvLziAnxr8MO790B3
         yhOeIqtXna4NxEiMIVjkaYZWuAK4k47/7cjkolULk6eFA1QofsjMp1hUAUqgbk2Y9CvY
         K0UpTxo0yTrJzwapX4K1lgIL7Q+gBBd61X4dgw0tNRibfm/xQfffFvgLZKz2ELc6/bWb
         c5aaAF24619pAw/PjQSRoO/eUdIWfNa8pW85Zgyoxx/+HMCEU/PRn4XtM+D65eB1jRI0
         uSwSgStlAIgdb9M/FkhsvmDUMCOpacKd6BXFdi4Y4ArPUoXWmuhYd8nEN0gYTrr//n3/
         /ZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IU02G2SCH5E+ATDz9hd+zgG8PRvB3leghHbtZysVp0=;
        b=SBix8Q8wv8DhmJHHU3/PtwPPsEDnisW1Q7YYCFetixl3JUfmzBxWNFFaiiWL+HQ0HI
         LIiTAx3UTeNn35+Pmc+rn3SV//1FXgJMDJ2O4Tq+5cJ+2UpTWJNdQECQU0j1zXNui35A
         PNvbe8A1jIvgFCNWyUgBINVY3xDLG+X1D1GTdlpWX9WWMDvMUiFzE2o5n+AhFLY+PLDQ
         vAWi2zRYyY/92mGDrMqUUPAxK8n5xa74tj9NjQ/YayUkvxTZY3OgnFxKmBfJjtspEBeK
         HVRQAq2NthclGYPForMrARfOXMY3YXgL1ZpYPkmx88kD/70hx+nKs1WVaaK5GeIoaIam
         rx/w==
X-Gm-Message-State: APjAAAXtD1FSE8HN0H6vF90neGdadK+taR2sSzyo2A98QMKa+LpHWvx8
        23VIVXdb1N50SdQFQ/QVAVFeUj9O4pM=
X-Google-Smtp-Source: APXvYqxsEOdI/TbviU+t1mY4ze8YjVAazSnJNErbC0plvZ8x7DPW2OqqiCoEdZvv/biHxUMFzeHnRQ==
X-Received: by 2002:a05:600c:2c4d:: with SMTP id r13mr5530014wmg.112.1582734181103;
        Wed, 26 Feb 2020 08:23:01 -0800 (PST)
Received: from kwango.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z133sm3588222wmb.7.2020.02.26.08.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:23:00 -0800 (PST)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] libceph: simplify ceph_monc_handle_map()
Date:   Wed, 26 Feb 2020 17:22:43 +0100
Message-Id: <20200226162243.12028-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_monc_handle_map() confuses static checkers which report a
false use-after-free on monc->monmap, missing that monc->monmap and
client->monc.monmap is the same pointer.

Use monc->monmap consistently and get rid of "old", which is redundant.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/mon_client.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 9d9e4e4ea600..3d8c8015e976 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -467,7 +467,7 @@ static void ceph_monc_handle_map(struct ceph_mon_client *monc,
 				 struct ceph_msg *msg)
 {
 	struct ceph_client *client = monc->client;
-	struct ceph_monmap *monmap = NULL, *old = monc->monmap;
+	struct ceph_monmap *monmap;
 	void *p, *end;
 
 	mutex_lock(&monc->mutex);
@@ -484,13 +484,13 @@ static void ceph_monc_handle_map(struct ceph_mon_client *monc,
 		goto out;
 	}
 
-	if (ceph_check_fsid(monc->client, &monmap->fsid) < 0) {
+	if (ceph_check_fsid(client, &monmap->fsid) < 0) {
 		kfree(monmap);
 		goto out;
 	}
 
-	client->monc.monmap = monmap;
-	kfree(old);
+	kfree(monc->monmap);
+	monc->monmap = monmap;
 
 	__ceph_monc_got_map(monc, CEPH_SUB_MONMAP, monc->monmap->epoch);
 	client->have_fsid = true;
-- 
2.19.2

