Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 474F114D068
	for <lists+ceph-devel@lfdr.de>; Wed, 29 Jan 2020 19:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgA2SXD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 Jan 2020 13:23:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:45072 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgA2SXD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 13:23:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 861DFB2B2;
        Wed, 29 Jan 2020 18:23:01 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH] rbd: optimize barrier usage for Rmw atomic bitops
Date:   Wed, 29 Jan 2020 10:12:53 -0800
Message-Id: <20200129181253.24999-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

For both set and clear_bit, we can avoid the unnecessary barrier
on non LL/SC architectures, such as x86. Instead, use the
smp_mb__{before,after}_atomic() calls.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 drivers/block/rbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 2b184563cd32..7bc79b2b8f65 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1371,13 +1371,13 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
 static void img_request_layered_set(struct rbd_img_request *img_request)
 {
 	set_bit(IMG_REQ_LAYERED, &img_request->flags);
-	smp_mb();
+	smp_mb__after_atomic();
 }
 
 static void img_request_layered_clear(struct rbd_img_request *img_request)
 {
 	clear_bit(IMG_REQ_LAYERED, &img_request->flags);
-	smp_mb();
+	smp_mb__after_atomic();
 }
 
 static bool img_request_layered_test(struct rbd_img_request *img_request)
-- 
2.16.4

