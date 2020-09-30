Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B6D27E841
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Sep 2020 14:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbgI3MKc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Sep 2020 08:10:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729694AbgI3MKb (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 08:10:31 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6257E20888;
        Wed, 30 Sep 2020 12:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601467830;
        bh=kQAieOBdVefugdqS+miJvqEsr4z50qJgszv5HtSnfsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LH9YbzpI7e8koeIcT3hsqMetygtPJjCL6xCSSFs+5cvsDcrCCKL4Y6Qr0D9zCItfG
         VbhYgRB5LZzDg9GgZv8zJh4iyrQM63OcwAMqS0/Ird5CN/NVKYSV6ypANgtatyCt06
         FiQjVC9IWe29QRtZqcr3tM/z3bQ6Lz9ippDYcRTc=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com
Subject: [RFC PATCH v2 4/4] ceph: queue MDS requests to REJECTED sessions when CLEANRECOVER is set
Date:   Wed, 30 Sep 2020 08:10:25 -0400
Message-Id: <20200930121025.9257-5-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200930121025.9257-1-jlayton@kernel.org>
References: <20200925140851.320673-1-jlayton@kernel.org>
 <20200930121025.9257-1-jlayton@kernel.org>
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
which will be awoken after tearing down the old session. We can only
do this for sync requests though, so check for async ones first and
just let the callers redrive a sync request.

URL: https://tracker.ceph.com/issues/47385
Reported-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index fd16db6ecb0a..2e1b3313f69b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2818,10 +2818,6 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	     ceph_session_state_name(session->s_state));
 	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
 	    session->s_state != CEPH_MDS_SESSION_HUNG) {
-		if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
-			err = -EACCES;
-			goto out_session;
-		}
 		/*
 		 * We cannot queue async requests since the caps and delegated
 		 * inodes are bound to the session. Just return -EJUKEBOX and
@@ -2831,6 +2827,20 @@ static void __do_request(struct ceph_mds_client *mdsc,
 			err = -EJUKEBOX;
 			goto out_session;
 		}
+
+		/*
+		 * If the session has been REJECTED, then return a hard error,
+		 * unless it's a CLEANRECOVER mount, in which case we'll queue
+		 * it to the mdsc queue.
+		 */
+		if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
+			if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER))
+				list_add(&req->r_wait, &mdsc->waiting_for_map);
+			else
+				err = -EACCES;
+			goto out_session;
+		}
+
 		if (session->s_state == CEPH_MDS_SESSION_NEW ||
 		    session->s_state == CEPH_MDS_SESSION_CLOSING) {
 			err = __open_session(mdsc, session);
-- 
2.26.2

