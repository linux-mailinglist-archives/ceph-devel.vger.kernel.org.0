Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263B43A45C3
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Jun 2021 17:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFKP5J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Jun 2021 11:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229942AbhFKP5J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 11:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C866961004;
        Fri, 11 Jun 2021 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623426911;
        bh=C3SMpx32N/1n9ojCxsUUzvTL6rBxqqFnEAyecSSKDVU=;
        h=From:To:Cc:Subject:Date:From;
        b=dKPkditxews7pXloJNNth9SdXrnOgUOhbLnPgBbeGXHtJEG7iURJI9cKaGlE0ooMi
         kpxTHxB39P6FZXA3SpxPQaLKnXq6Rp+oSvjfw3SbzK+QGGCWxHVWFIWuJHb45IpbeM
         ArBaz6XVXaTXk+vWXg4jGzTSVOL5WNPPO/QGwgxSLHpi236t/e/35tLWdONYZJTaNC
         NjhgNHL+DgUpoa/udXydeVn3DAPTdUX2hVosk9XIQAz3cT2o37vv2gNALzehjJvi/z
         +aFQOMoEkhOdCdw3nW3bXQpipRzRBeSt5ZtObd1jxgUW+t0z0N+cBP+ahgo/TcpODj
         dld2JSCvnOcIg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-cachefs@redhat.com, pfmeec@rit.edu, willy@infradead.org,
        dhowells@redhat.com, Andrew W Elble <aweits@rit.edu>
Subject: [RFC PATCH] ceph: fix write_begin optimization when write is beyond EOF
Date:   Fri, 11 Jun 2021 11:55:09 -0400
Message-Id: <20210611155509.76691-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It's not sufficient to skip reading when the pos is beyond the EOF.
There may be data at the head of the page that we need to fill in
before the write. Only elide the read if the pos is beyond the last page
in the file.

Reported-by: Andrew W Elble <aweits@rit.edu>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

I've not tested this at all yet, but I think this is probably what we'll
want for stable series v5.10.z - v5.12.z.

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 35c83f65475b..9f60f541b423 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1353,11 +1353,11 @@ static int ceph_write_begin(struct file *file, struct address_space *mapping,
 		/*
 		 * In some cases we don't need to read at all:
 		 * - full page write
-		 * - write that lies completely beyond EOF
+		 * - write that lies in a page that is completely beyond EOF
 		 * - write that covers the the page from start to EOF or beyond it
 		 */
 		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
-		    (pos >= i_size_read(inode)) ||
+		    (index >= (i_size_read(inode) << PAGE_SHIFT)) ||
 		    (pos_in_page == 0 && (pos + len) >= i_size_read(inode))) {
 			zero_user_segments(page, 0, pos_in_page,
 					   pos_in_page + len, PAGE_SIZE);
-- 
2.31.1

