Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA46D4523D
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 04:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbfFNC7J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 22:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33516 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfFNC7J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 22:59:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B638307D868
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 02:59:09 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-143.pek2.redhat.com [10.72.12.143])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 999ED5ED44;
        Fri, 14 Jun 2019 02:59:06 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] ceph: remove request from waiting list before unregister
Date:   Fri, 14 Jun 2019 10:59:03 +0800
Message-Id: <20190614025903.21540-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 14 Jun 2019 02:59:09 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Link: https://tracker.ceph.com/issues/40339
Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/mds_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fda621bc8a29..776c47bd1155 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4162,6 +4162,7 @@ static void wait_requests(struct ceph_mds_client *mdsc)
 		while ((req = __get_oldest_req(mdsc))) {
 			dout("wait_requests timed out on tid %llu\n",
 			     req->r_tid);
+			list_del_init(&req->r_wait);
 			__unregister_request(mdsc, req);
 		}
 	}
-- 
2.17.2

