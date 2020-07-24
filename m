Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B8822CED9
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Jul 2020 21:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgGXTpg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jul 2020 15:45:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgGXTpg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Jul 2020 15:45:36 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2232070B;
        Fri, 24 Jul 2020 19:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595619936;
        bh=dEjStON1ewA5HcIR9ecoUTf7ME6m+NuMUxLXp9POcKk=;
        h=From:To:Cc:Subject:Date:From;
        b=Ac7LSNKQReTHc5619gaiS6XhbukjxajY+HifDy3yHxEDv33AFRXcViJConBGBwslO
         ArAv2NRtbZ54PhQ9e0gWc9DIWHDgLqVqs6Efm8CmGDnAlDVkmtM5bRFSxgOxS7pmfN
         A7K6ZbME5XOTwWZY+vnR8oZiwqNCbIiyC0smhvqk=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Subject: [PATCH] ceph: eliminate unused "total" variable in ceph_mdsc_send_metrics
Date:   Fri, 24 Jul 2020 15:45:34 -0400
Message-Id: <20200724194534.61016-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Cc: Xiubo Li <xiubli@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/metric.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 252d6a3f75d2..2466b261fba2 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -20,7 +20,7 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	u64 nr_caps = atomic64_read(&m->total_caps);
 	struct ceph_msg *msg;
 	struct timespec64 ts;
-	s64 sum, total;
+	s64 sum;
 	s32 items = 0;
 	s32 len;
 
@@ -53,7 +53,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	read->ver = 1;
 	read->compat = 1;
 	read->data_len = cpu_to_le32(sizeof(*read) - 10);
-	total = m->total_reads;
 	sum = m->read_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	read->sec = cpu_to_le32(ts.tv_sec);
@@ -66,7 +65,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	write->ver = 1;
 	write->compat = 1;
 	write->data_len = cpu_to_le32(sizeof(*write) - 10);
-	total = m->total_writes;
 	sum = m->write_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	write->sec = cpu_to_le32(ts.tv_sec);
@@ -79,7 +77,6 @@ static bool ceph_mdsc_send_metrics(struct ceph_mds_client *mdsc,
 	meta->ver = 1;
 	meta->compat = 1;
 	meta->data_len = cpu_to_le32(sizeof(*meta) - 10);
-	total = m->total_metadatas;
 	sum = m->metadata_latency_sum;
 	jiffies_to_timespec64(sum, &ts);
 	meta->sec = cpu_to_le32(ts.tv_sec);
-- 
2.26.2

