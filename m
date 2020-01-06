Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0768E1314E4
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Jan 2020 16:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAFPfX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Jan 2020 10:35:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFPfX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 10:35:23 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B6D20848;
        Mon,  6 Jan 2020 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578324923;
        bh=weGd6uwVLhQeKuQ2RMOjCHg1lAs542omS1EeHKEbZu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4fUKcJPiUC6DSej0T7SPC7LwOnKQSK0Lan26/y7AA2ti+zjrvaJk483J+O/C12vP
         +ICfRHogGerS8CVvoCSBE7xF+kf5hZmfsCRdoUW50TgusIGGHlpjVPURHYzOh2RgaX
         ClC5NQDo1v6Ydg9owXD3E4vkrw5mupKReUdz8Oic=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com
Subject: [PATCH 1/6] ceph: close holes in struct ceph_mds_session
Date:   Mon,  6 Jan 2020 10:35:15 -0500
Message-Id: <20200106153520.307523-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106153520.307523-1-jlayton@kernel.org>
References: <20200106153520.307523-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Move s_ref up to plug a 4 byte hole, which plugs another.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index c021df5f50ce..8f2d3d68073e 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -175,6 +175,7 @@ struct ceph_mds_session {
 
 	/* protected by s_cap_lock */
 	spinlock_t        s_cap_lock;
+	refcount_t        s_ref;
 	struct list_head  s_caps;     /* all caps issued by this session */
 	struct ceph_cap  *s_cap_iterator;
 	int               s_nr_caps;
@@ -189,7 +190,6 @@ struct ceph_mds_session {
 	unsigned long     s_renew_requested; /* last time we sent a renew req */
 	u64               s_renew_seq;
 
-	refcount_t        s_ref;
 	struct list_head  s_waiting;  /* waiting requests */
 	struct list_head  s_unsafe;   /* unsafe requests */
 };
-- 
2.24.1

