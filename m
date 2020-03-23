Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D539018F951
	for <lists+ceph-devel@lfdr.de>; Mon, 23 Mar 2020 17:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727609AbgCWQHQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 23 Mar 2020 12:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727594AbgCWQHP (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 12:07:15 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E4D2072D;
        Mon, 23 Mar 2020 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584979635;
        bh=5+j2drKZa+CQfEsajNfhjZNzFm4sp+fulTVSSukQduM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlWlE2lrT1YX8heEWyLDXaiyW5YE6mwD09HocuIj1Cz+oLK0mDGcYHc97AwPAJO06
         KscuXXsP6jt8SoV+B/BURnH4tw0fxkpriYFg/GRaCKWS5d3mrGVB6LFOVXUCSopHN4
         fhtkhhJ1v0p/90I7cgoM/vrVp7tZ49kKieVdF4no=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Subject: [PATCH 7/8] ceph: fix potential race in ceph_check_caps
Date:   Mon, 23 Mar 2020 12:07:07 -0400
Message-Id: <20200323160708.104152-8-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323160708.104152-1-jlayton@kernel.org>
References: <20200323160708.104152-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Nothing ensures that session will still be valid by the time we
dereference the pointer. Take and put a reference.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 3eab905ba74b..061e52912991 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2051,12 +2051,14 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			if (mutex_trylock(&session->s_mutex) == 0) {
 				dout("inverting session/ino locks on %p\n",
 				     session);
+				session = ceph_get_mds_session(session);
 				spin_unlock(&ci->i_ceph_lock);
 				if (took_snap_rwsem) {
 					up_read(&mdsc->snap_rwsem);
 					took_snap_rwsem = 0;
 				}
 				mutex_lock(&session->s_mutex);
+				ceph_put_mds_session(session);
 				goto retry;
 			}
 		}
-- 
2.25.1

