Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E2F3D7EEE
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jul 2021 22:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhG0UMd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 16:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231204AbhG0UMc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 16:12:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8408660462;
        Tue, 27 Jul 2021 20:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627416751;
        bh=I4jrpZJEHAuTKdC8/FD5tSmpM64HCvBVzXHfTBMgmw8=;
        h=From:To:Cc:Subject:Date:From;
        b=qMfS7JDjwSErSfJe47ymZoKljfd38vHUBP0zQlWom8SBSsJX5NYTGX6wOjCAC7Dly
         g3YVJqNXEF3q4ZnKJ8O9YDtEeLZALBoZTZge3wcJDL7E+ui5iKuYbsTT08KhkwHasF
         BMwNRPM+aaVFWHfPMmwMCiEDi2yRzCjNd/IAHXVhtxhu4RwIxCbCtfS/bDtEOCVyKu
         6B2ngZfyIEaJHNvkKH10QIDhDLyKudiFxTJ3OCHHyBIMKDYEDLHvQxRk8ro+rLwgae
         Pt2P+cHq4/rrvjGdFzsmysbT1cV3t8yScaVIaNKVAifFsCq6v5ZaoH4qlD6SJXhXRd
         7ATXwyjbV+pQA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: cancel delayed work instead of flushing on mdsc teardown
Date:   Tue, 27 Jul 2021 16:12:30 -0400
Message-Id: <20210727201230.178286-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The first thing metric_delayed_work does is check mdsc->stopping,
and then return immediately if it's set...which is good since we would
have already torn down the metric structures at this point, otherwise.

Worse yet, it's possible that the ceph_metric_destroy call could race
with the delayed_work, in which case we could end up a end up accessing
destroyed percpu variables.

At this point in the mdsc teardown, the "stopping" flag has already been
set, so there's no benefit to flushing the work. Just cancel it instead,
and do so before we tear down the metrics structures.

Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c43091a30ba8..d3f2baf3c352 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4977,9 +4977,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
 
 	ceph_mdsc_stop(mdsc);
 
+	cancel_delayed_work_sync(&mdsc->metric.delayed_work);
 	ceph_metric_destroy(&mdsc->metric);
 
-	flush_delayed_work(&mdsc->metric.delayed_work);
 	fsc->mdsc = NULL;
 	kfree(mdsc);
 	dout("mdsc_destroy %p done\n", mdsc);
-- 
2.31.1

