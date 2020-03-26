Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D625193FAC
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Mar 2020 14:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgCZNZ3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Mar 2020 09:25:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbgCZNZ2 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 09:25:28 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 110C62073E;
        Thu, 26 Mar 2020 13:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585229128;
        bh=b5LIxenj/PIltw0oL1Ljqo8mSUoIROM9Ox2WyQWLVlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDD0zz5hmvrNpvjcfmr/M0E0V/0CHWDL1vTNpeCdhBAqq2N4+sEBoi0118pVUfem9
         L9dVGrSYAplvY3IUZQK5Ln97B185RnZQHYUprFVPIs+mG5aKYrvHdGW+OMIj8lnr8G
         CyTwdXhpNsWttAIkz0fwJjDX0IP7Xf6smtWhuP5U=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH v2] ceph: fix potential race in ceph_check_caps
Date:   Thu, 26 Mar 2020 09:25:26 -0400
Message-Id: <20200326132526.15639-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-8-jlayton@kernel.org>
References: <20200323160708.104152-8-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Nothing ensures that session will still be valid by the time we
dereference the pointer. Take and put a reference.

In principle, we should always be able to get a reference here, but
throw a warning if that's ever not the case.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 80bde0024615..f8b51d0c8184 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2045,12 +2045,24 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			if (mutex_trylock(&session->s_mutex) == 0) {
 				dout("inverting session/ino locks on %p\n",
 				     session);
+				session = ceph_get_mds_session(session);
 				spin_unlock(&ci->i_ceph_lock);
 				if (took_snap_rwsem) {
 					up_read(&mdsc->snap_rwsem);
 					took_snap_rwsem = 0;
 				}
-				mutex_lock(&session->s_mutex);
+				if (session) {
+					mutex_lock(&session->s_mutex);
+					ceph_put_mds_session(session);
+				} else {
+					/*
+					 * Because we take the reference while
+					 * holding the i_ceph_lock, it should
+					 * never be NULL. Throw a warning if it
+					 * ever is.
+					 */
+					WARN_ON_ONCE(true);
+				}
 				goto retry;
 			}
 		}
-- 
2.25.1

