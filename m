Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35B03DA341
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jul 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236976AbhG2Mi0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Jul 2021 08:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhG2MiZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 08:38:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32A7D60F12;
        Thu, 29 Jul 2021 12:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627562302;
        bh=vfuS3bxTIxzEpJezHgFBzDO0lgYY5VSG8HI2HfXHmoc=;
        h=From:To:Cc:Subject:Date:From;
        b=snkSsBf8HKOTb5d+Rj5uj7lRs7T5bBzz+QRPrqnaUIe5xgHntOzMDkDWsAhm4ft3J
         OF8HIGgGIdIZHRr0bFNXTbvvgD4MITf+o4h3kfAbo0jxgO+ZHnmA8yZT4UtnrDN00C
         ijFbn6+JYwJr34rRSvcNQYeBXX4ZUn4eP59w2q3jnk4qi9Iq1Es12JvkXyNzwe+nvb
         Eets4gw+0AJLjpIqYteIOKM86nifKigd9Cz/ymvE3+kmhK85nOtThUglun7lYUVGMN
         qyPlelLjo+TLgCxRpEQllCN8tUxYVZePmA9xr5bcYWqlFUQD5+orhOBzaBDIIGngIG
         lXhd8V9qpVyxQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: cancel delayed work instead of flushing on mdsc teardown
Date:   Thu, 29 Jul 2021 08:38:21 -0400
Message-Id: <20210729123821.100086-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The first thing metric_delayed_work does is check mdsc->stopping,
and then return immediately if it's set. That's good since we would
have already torn down the metric structures at this point, otherwise,
but there is no locking around mdsc->stopping.

It's possible that the ceph_metric_destroy call could race with the
delayed_work, in which case we could end up with the delayed_work
accessing destroyed percpu variables.

At this point in the mdsc teardown, the "stopping" flag has already been
set, so there's no benefit to flushing the work. Move the work
cancellation in ceph_metric_destroy ahead of the percpu variable
destruction, and eliminate the flush_delayed_work call in
ceph_mdsc_destroy.

Cc: Xiubo Li <xiubli@redhat.com>
Fixes: 18f473b384a6 ("ceph: periodically send perf metrics to MDSes")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 1 -
 fs/ceph/metric.c     | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

v2: just drop the flush call altogether and move the cancel before the
    percpu variables are destroyed (per Xiubo's suggestion).

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c43091a30ba8..34124fb1605e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4979,7 +4979,6 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_metric_destroy(&mdsc->metric);
 
-	flush_delayed_work(&mdsc->metric.delayed_work);
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index 5ac151eb0d49..04d5df29bbbf 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -302,6 +302,8 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	if (!m)
 		return;
 
+	cancel_delayed_work_sync(&m->delayed_work);
+
 	percpu_counter_destroy(&m->total_inodes);
 	percpu_counter_destroy(&m->opened_inodes);
 	percpu_counter_destroy(&m->i_caps_mis);
@@ -309,8 +311,6 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 	percpu_counter_destroy(&m->d_lease_mis);
 	percpu_counter_destroy(&m->d_lease_hit);
 
-	cancel_delayed_work_sync(&m->delayed_work);
-
 	ceph_put_mds_session(m->session);
 }
 
-- 
2.31.1

