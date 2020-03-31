Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139D9199414
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Mar 2020 12:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgCaKw0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 31 Mar 2020 06:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730481AbgCaKwZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 06:52:25 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D49208E0;
        Tue, 31 Mar 2020 10:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585651945;
        bh=wOEj+MKR8HtopOJRBzK4OD8STRoIQ1UwPYEhoChBwlw=;
        h=From:To:Cc:Subject:Date:From;
        b=RrXdv/35lPvCXsUWQo/+0hjBYyNWJ48TCcFXqWJwrMTAcdsKVB9uGjnJd4i/vD5Re
         e5/fo1LMPT3CGYYEzJNgYiU7gVVMZgl+lMJguKQ4+5zmy4Dkj4Ar32BdGXvZdhQFA0
         hZa19kNDWYvzqEnl9h+LC343fANnVKO09Ov2sA+U=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        jfajerski@suse.com
Subject: [PATCH] ceph: request expedited service when flushing caps
Date:   Tue, 31 Mar 2020 06:52:23 -0400
Message-Id: <20200331105223.9610-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jan noticed some long stalls when flushing caps using sync() after
doing small file creates. For instance, running this:

    $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done

Could take more than 90s in some cases. The sync() will flush out caps,
but doesn't tell the MDS that it's waiting synchronously on the
replies.

When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
into that fact and it can then expedite the reply.

URL: https://tracker.ceph.com/issues/44744
Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 61808793e0c0..6403178f2376 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 
 		mds = cap->mds;  /* remember mds, so we don't repeat */
 
-		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
-			   retain, flushing, flush_tid, oldest_flush_tid);
+		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
+			   (flags & CHECK_CAPS_FLUSH) ?
+			    CEPH_CLIENT_CAPS_SYNC : 0,
+			   cap_used, want, retain, flushing, flush_tid,
+			   oldest_flush_tid);
 		spin_unlock(&ci->i_ceph_lock);
 
 		__send_cap(mdsc, &arg, ci);
-- 
2.25.1

