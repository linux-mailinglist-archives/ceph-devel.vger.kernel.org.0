Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FF23436C
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 11:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfFDJjW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 05:39:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58286 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfFDJjW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 05:39:22 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01B763086225
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jun 2019 09:39:22 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-98.pek2.redhat.com [10.72.12.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEB8860C91;
        Tue,  4 Jun 2019 09:39:15 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com, jlayton@redhat.com,
        "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/4] libceph: add function that clears osd client's abort_err
Date:   Tue,  4 Jun 2019 17:39:06 +0800
Message-Id: <20190604093908.30491-2-zyan@redhat.com>
In-Reply-To: <20190604093908.30491-1-zyan@redhat.com>
References: <20190604093908.30491-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 04 Jun 2019 09:39:22 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 include/linux/ceph/osd_client.h | 1 +
 net/ceph/osd_client.c           | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index a12b7fc9cfd6..71ddb0a89f4d 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -389,6 +389,7 @@ extern void ceph_osdc_handle_map(struct ceph_osd_client *osdc,
 				 struct ceph_msg *msg);
 void ceph_osdc_update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb);
 void ceph_osdc_abort_requests(struct ceph_osd_client *osdc, int err);
+void ceph_osdc_clear_abort_err(struct ceph_osd_client *osdc);
 
 extern void osd_req_op_init(struct ceph_osd_request *osd_req,
 			    unsigned int which, u16 opcode, u32 flags);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 67e9466f27fd..9a46ae296424 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2485,6 +2485,14 @@ void ceph_osdc_abort_requests(struct ceph_osd_client *osdc, int err)
 }
 EXPORT_SYMBOL(ceph_osdc_abort_requests);
 
+void ceph_osdc_clear_abort_err(struct ceph_osd_client *osdc)
+{
+	down_write(&osdc->lock);
+	osdc->abort_err = 0;
+	up_write(&osdc->lock);
+}
+EXPORT_SYMBOL(ceph_osdc_clear_abort_err);
+
 static void update_epoch_barrier(struct ceph_osd_client *osdc, u32 eb)
 {
 	if (likely(eb > osdc->epoch_barrier)) {
-- 
2.17.2

