Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFD074CC2
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 13:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403941AbfGYLR4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 07:17:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403946AbfGYLRw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:17:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16CD82238C
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 11:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564053472;
        bh=WavyI7EGdjqmkY/cx+cIE/qI/5lKy+/G0B3rjfu4wUM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=oiPFycNyYyGeJwfcVX8mfGi5kfgxODPC2llpua/Si11XIIt3VW/yfU7jEjiuIoQSX
         G4ERUmZLREETMHlvXAcdXnS9GVh41NDRyrk5efbW0w11/xpmxpSh8rMDINqQHQvosm
         Up/o0qENOTV3mu5AGdJ44rpcM+DLyqwTueN3ZAug=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Subject: [PATCH 8/8] ceph: remove incorrect comment above __send_cap
Date:   Thu, 25 Jul 2019 07:17:46 -0400
Message-Id: <20190725111746.10393-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190725111746.10393-1-jlayton@kernel.org>
References: <20190725111746.10393-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

It doesn't do anything to invalidate the cache when dropping RD caps.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b1c80d837d0d..d3b9c9d5c1bd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1260,10 +1260,6 @@ void __ceph_remove_caps(struct ceph_inode_info *ci)
  * Make note of max_size reported/requested from mds, revoked caps
  * that have now been implemented.
  *
- * Make half-hearted attempt ot to invalidate page cache if we are
- * dropping RDCACHE.  Note that this will leave behind locked pages
- * that we'll then need to deal with elsewhere.
- *
  * Return non-zero if delayed release, or we experienced an error
  * such that the caller should requeue + retry later.
  *
-- 
2.21.0

