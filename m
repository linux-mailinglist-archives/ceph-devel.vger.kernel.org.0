Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88882B03CD
	for <lists+ceph-devel@lfdr.de>; Thu, 12 Nov 2020 12:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgKLLZ0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 12 Nov 2020 06:25:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:58610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbgKLLZZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 06:25:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ADCCCAF69;
        Thu, 12 Nov 2020 11:25:23 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id daccff5f;
        Thu, 12 Nov 2020 11:25:32 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>, Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] ceph: downgrade warning from mdsmap decode to debug
Date:   Thu, 12 Nov 2020 11:25:32 +0000
Message-Id: <20201112112532.16824-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

While the MDS cluster is unstable and changing state the client may get
mdsmap updates that will trigger warnings:

  [144692.478400] ceph: mdsmap_decode got incorrect state(up:standby-replay)
  [144697.489552] ceph: mdsmap_decode got incorrect state(up:standby-replay)
  [144697.489580] ceph: mdsmap_decode got incorrect state(up:standby-replay)

This patch downgrades these warnings to debug, as they may flood the logs
if the cluster is unstable for a while.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Hi!

This patch follows from my other patch "ceph: fix race in concurrent
__ceph_remove_cap invocations", where I see a *lot* of warnings before the
NULL pointer.  Maybe this could be a pr_warn_once instead, but not sure
that would be useful.

Note that before commit 4d7ace02ba5c ("ceph: fix mdsmap cluster available
check based on laggy number") this was simply ignored without any pr_warn
or dout.

Cheers,
--
Luis

 fs/ceph/mdsmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index e4aba6c6d3b5..1096d1d3a84c 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -243,8 +243,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 		}
 
 		if (state <= 0) {
-			pr_warn("mdsmap_decode got incorrect state(%s)\n",
-				ceph_mds_state_name(state));
+			dout("mdsmap_decode got incorrect state(%s)\n",
+			     ceph_mds_state_name(state));
 			continue;
 		}
 
