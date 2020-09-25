Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A736278A62
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Sep 2020 16:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgIYOI5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Sep 2020 10:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYOI4 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 10:08:56 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E156208A9;
        Fri, 25 Sep 2020 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601042936;
        bh=KUgtmP6lpdYZ/ucBdbs6bk0gFVklNnVN7BiU5JTNXvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=suq3GdFqJWPQTaXPv+vQLU3+pSjCgyySkvaLPKk6IbFSgmbxxirzue4weMLwhsxvq
         y2hu4fNjCUDJMx5WiSNHO8UAlgh1HiN7PeYl4i0o5LzxWbJWJileRNhnxqrj+RMMG1
         D8yU6xFvVibPg8ej/gJun2ARYFMu5hMmSqFAYY90=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [RFC PATCH 4/4] ceph: queue request when CLEANRECOVER is set
Date:   Fri, 25 Sep 2020 10:08:51 -0400
Message-Id: <20200925140851.320673-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925140851.320673-1-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Ilya noticed that the first access to a blacklisted mount would often
get back -EACCES, but then subsequent calls would be OK. The problem is
in __do_request. If the session is marked as REJECTED, a hard error is
returned instead of waiting for a new session to come into being.

When the session is REJECTED and the mount was done with
recover_session=clean, queue the request to the waiting_for_map queue,
which will be awoken after tearing down the old session.

URL: https://tracker.ceph.com/issues/47385
Reported-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fd16db6ecb0a..b07e7adf146f 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2819,7 +2819,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
 	    session->s_state != CEPH_MDS_SESSION_HUNG) {
 		if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
-			err = -EACCES;
+			if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER))
+				list_add(&req->r_wait, &mdsc->waiting_for_map);
+			else
+				err = -EACCES;
 			goto out_session;
 		}
 		/*
-- 
2.26.2

