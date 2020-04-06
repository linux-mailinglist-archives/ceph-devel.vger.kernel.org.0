Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C869519FE38
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Apr 2020 21:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgDFTme (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Apr 2020 15:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgDFTmd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Apr 2020 15:42:33 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7FDF2072F;
        Mon,  6 Apr 2020 19:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586202153;
        bh=DB7ERq3gcBP6oAgM162tZH8MJ3rdIDU6KowwHoIxSgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZITM8QSI5gIsqrNMvK6eo9g3u+LCseIK+WzVMRZVWOToDj+Hdh1+aQup1q3jmfuq
         SvCWD/xL3r0gO+TtrjZn+fLnCMl07CQC6XUKYCKy2HW3v7VTM+PKGepuCl2KX5UukX
         pBQI+EpBPpckeaKb2wIClcCgwJuZP8n0f/EIdDes=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com,
        jfajerski@suse.com, lhenriques@suse.com, gfarnum@redhat.com
Subject: [PATCH v3 2/2] ceph: request expedited service on session's last cap flush
Date:   Mon,  6 Apr 2020 15:42:28 -0400
Message-Id: <20200406194228.52418-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406194228.52418-1-jlayton@kernel.org>
References: <20200406194228.52418-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When flushing a lot of caps to the MDS's at once (e.g. for syncfs),
we can end up waiting a substantial amount of time for MDS replies, due
to the fact that it may delay some of them so that it can batch them up
together in a single journal transaction. This can lead to stalls when
calling sync or syncfs.

What we'd really like to do is request expedited service on the _last_
cap we're flushing back to the server. If the CHECK_CAPS_FLUSH flag is
set on the request and the current inode was the last one on the
session->s_cap_dirty list, then mark the request with
CEPH_CLIENT_CAPS_SYNC.

Note that this heuristic is not perfect. New inodes can race onto the
list after we've started flushing, but it does seem to fix some common
use cases.

URL: https://tracker.ceph.com/issues/44744
Reported-by: Jan Fajerski <jfajerski@suse.com>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b27bca0e9651..8ba7d78029f0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1998,6 +1998,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 	}
 
 	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
+		int mflags = 0;
 		struct cap_msg_args arg;
 
 		cap = rb_entry(p, struct ceph_cap, ci_node);
@@ -2129,6 +2130,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 			flushing = ci->i_dirty_caps;
 			flush_tid = __mark_caps_flushing(inode, session, false,
 							 &oldest_flush_tid);
+			if (flags & CHECK_CAPS_FLUSH &&
+			    list_empty(&session->s_cap_dirty))
+				mflags |= CEPH_CLIENT_CAPS_SYNC;
 		} else {
 			flushing = 0;
 			flush_tid = 0;
@@ -2139,8 +2143,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
 
 		mds = cap->mds;  /* remember mds, so we don't repeat */
 
-		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
-			   retain, flushing, flush_tid, oldest_flush_tid);
+		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, mflags, cap_used,
+			   want, retain, flushing, flush_tid, oldest_flush_tid);
 		spin_unlock(&ci->i_ceph_lock);
 
 		__send_cap(mdsc, &arg, ci);
-- 
2.25.1

