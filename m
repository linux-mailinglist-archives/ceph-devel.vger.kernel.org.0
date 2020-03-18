Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2729618956E
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Mar 2020 06:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCRFqN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Mar 2020 01:46:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49835 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726478AbgCRFqM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 01:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584510371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=wlN4mzW8FjNx28pUhqZdUAlhAL2ic5ZDrL/OgayrLCU=;
        b=eUk2urvohMFG4irxk5Aw7fA2QRkO2A41gxVz7MZ8eM8xmLPkh7g8SaGJmVvYW6qECkN995
        eIlbhusiWieFFwN2qiyXFwUVXFkbw0bdBWRc1JkUEZ82yKrzJG/uoMhmbQjAmEdJsUSzKF
        WhaosubhnPOqlWd0nFOyXxHpnQrPQoA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-itwHq0goMSSRZ8G9z6GQQw-1; Wed, 18 Mar 2020 01:46:09 -0400
X-MC-Unique: itwHq0goMSSRZ8G9z6GQQw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54E4A189D6C0;
        Wed, 18 Mar 2020 05:46:08 +0000 (UTC)
Received: from lxbceph0.gsslab.pek2.redhat.com (vm36-245.gsslab.pek2.redhat.com [10.72.36.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD7848D553;
        Wed, 18 Mar 2020 05:46:05 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v4 1/4] ceph: switch to DIV64_U64_ROUND_CLOSEST to support 32-bit arches
Date:   Wed, 18 Mar 2020 01:45:52 -0400
Message-Id: <1584510355-6936-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
References: <1584510355-6936-1-git-send-email-xiubli@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

fs/ceph/debugfs.c:140: undefined reference to `__divdi3'
Use math64 helpers to avoid 64-bit div on 32-bit arches.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 60f3e307..95e8693 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -137,19 +137,19 @@ static int metric_show(struct seq_file *s, void *p)
 	total = percpu_counter_sum(&mdsc->metric.total_reads);
 	sum = percpu_counter_sum(&mdsc->metric.read_latency_sum);
 	sum = jiffies_to_usecs(sum);
-	avg = total ? sum / total : 0;
+	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read", total, sum, avg);
 
 	total = percpu_counter_sum(&mdsc->metric.total_writes);
 	sum = percpu_counter_sum(&mdsc->metric.write_latency_sum);
 	sum = jiffies_to_usecs(sum);
-	avg = total ? sum / total : 0;
+	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write", total, sum, avg);
 
 	total = percpu_counter_sum(&mdsc->metric.total_metadatas);
 	sum = percpu_counter_sum(&mdsc->metric.metadata_latency_sum);
 	sum = jiffies_to_usecs(sum);
-	avg = total ? sum / total : 0;
+	avg = total ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0;
 	seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "metadata", total, sum, avg);
 
 	seq_printf(s, "\n");
-- 
1.8.3.1

