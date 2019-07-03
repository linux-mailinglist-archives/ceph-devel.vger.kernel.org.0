Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C3A5E42C
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 14:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGCMo6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 08:44:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMo6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:44:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1381030C31B8
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 12:44:58 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B23617B40;
        Wed,  3 Jul 2019 12:44:55 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 3/9] ceph: allow closing session in restarting/reconnect state
Date:   Wed,  3 Jul 2019 20:44:36 +0800
Message-Id: <20190703124442.6614-4-zyan@redhat.com>
In-Reply-To: <20190703124442.6614-1-zyan@redhat.com>
References: <20190703124442.6614-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 03 Jul 2019 12:44:58 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

CEPH_MDS_SESSION_{RESTARTING,RECONNECTING} are for for mds failover,
they are sub-states of CEPH_MDS_SESSION_OPEN. So __close_session()
should send close request for session in these two state.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index f7c8603484fe..810fd8689dff 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -148,9 +148,9 @@ enum {
 	CEPH_MDS_SESSION_OPENING = 2,
 	CEPH_MDS_SESSION_OPEN = 3,
 	CEPH_MDS_SESSION_HUNG = 4,
-	CEPH_MDS_SESSION_CLOSING = 5,
-	CEPH_MDS_SESSION_RESTARTING = 6,
-	CEPH_MDS_SESSION_RECONNECTING = 7,
+	CEPH_MDS_SESSION_RESTARTING = 5,
+	CEPH_MDS_SESSION_RECONNECTING = 6,
+	CEPH_MDS_SESSION_CLOSING = 7,
 	CEPH_MDS_SESSION_REJECTED = 8,
 };
 
-- 
2.20.1

