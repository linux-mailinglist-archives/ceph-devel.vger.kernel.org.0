Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB6139A277
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Jun 2021 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhFCNuA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Jun 2021 09:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhFCNt6 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 09:49:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3D30613AA;
        Thu,  3 Jun 2021 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622728094;
        bh=CFPdCThF8nJQUj/n7qr9pQST0idPXWo8bX2YL2ecFR8=;
        h=From:To:Subject:Date:From;
        b=OJTqU2RLSAfQWs68HmVYr8WTTPrZsElt51AZX0eWq3D40KPcV7KdGIb1k22hKa3Vr
         hOVxMgK8iXRK6myU70NWybl5y7T61oZRgdMz76zfAiTLLLNeNgblGwWeJ+wXytHbwR
         6Mg7xSl9ZwlKEb1tsyV3ntSVOnJaD1LzfDKwaAxTmd9Cw6COCYLZppdKLpla9Wg7Rg
         aq0y25ZqplhqRitXwPPtENfTfwI5Fo/GTth4lHKaGv23m18s/N7ONo+sZ8+Oq09h1/
         LQ8vZeR4KaI0v3abz5gAaADYq4sV/njUarkEfRrZ4lREpUT5Izf5aOuQOtxgCwtrq6
         sRXiCNGHwUOiQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH] ceph: ensure we flush delayed caps when unmounting
Date:   Thu,  3 Jun 2021 09:48:12 -0400
Message-Id: <20210603134812.80276-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

I've seen some warnings when testing recently that indicate that there
are caps still delayed on the delayed list even after we've started
unmounting.

When checking delayed caps, process the whole list if we're unmounting,
and check for delayed caps after setting the stopping var and flushing
dirty caps.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c       | 3 ++-
 fs/ceph/mds_client.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index a5e93b185515..68b4c6dfe4db 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4236,7 +4236,8 @@ void ceph_check_delayed_caps(struct ceph_mds_client *mdsc)
 		ci = list_first_entry(&mdsc->cap_delay_list,
 				      struct ceph_inode_info,
 				      i_cap_delay_list);
-		if ((ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
+		if (!mdsc->stopping &&
+		    (ci->i_ceph_flags & CEPH_I_FLUSH) == 0 &&
 		    time_before(jiffies, ci->i_hold_caps_max))
 			break;
 		list_del_init(&ci->i_cap_delay_list);
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e5af591d3bd4..916af5497829 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4691,6 +4691,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 
 	lock_unlock_sessions(mdsc);
 	ceph_flush_dirty_caps(mdsc);
+	ceph_check_delayed_caps(mdsc);
 	wait_requests(mdsc);
 
 	/*
-- 
2.31.1

