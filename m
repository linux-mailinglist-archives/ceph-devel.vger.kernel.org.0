Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4130044616B
	for <lists+ceph-devel@lfdr.de>; Fri,  5 Nov 2021 10:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhKEJiV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 Nov 2021 05:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbhKEJiV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 Nov 2021 05:38:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636104941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FTxzFlM0DdwF5+F8WAb8Y6r0aXyJEZUZnsvqgAAdtB8=;
        b=EOqdWpm4FdLD23WTiwnAFmmo4K1n2RBHtYoO7erj13CYJyxyGAGpQpR9EjlrK8QAsplHk8
        XMPc6+3FjeM7GL+fY186kbUY53Ut9z3MavgT8PGfFfs+z7Ibh9fS30SxvEnNvF5Q9kJ6gS
        C1I7WgFY/wyQgBCKURICNMGmLfSGQEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-Nihqy4A5Nq-yZ2zm_U5-_g-1; Fri, 05 Nov 2021 05:35:35 -0400
X-MC-Unique: Nihqy4A5Nq-yZ2zm_U5-_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3A58100D68F;
        Fri,  5 Nov 2021 09:35:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99F567944B;
        Fri,  5 Nov 2021 09:34:29 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, vshankar@redhat.com, pdonnell@redhat.com,
        khiremat@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix incorrectly decoding the mdsmap bug
Date:   Fri,  5 Nov 2021 17:34:18 +0800
Message-Id: <20211105093418.261469-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When decreasing the 'max_mds' in the cephfs cluster, when the extra
MDS or MDSes are not removed yet, the mdsmap may only decreased the
'max_mds' but still having the that or those MDSes 'in' or in the
export targets list.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mdsmap.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 61d67cbcb367..30387733765d 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -263,10 +263,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end, bool msgr2)
 				goto nomem;
 			for (j = 0; j < num_export_targets; j++) {
 				target = ceph_decode_32(&pexport_targets);
-				if (target >= m->possible_max_rank) {
-					err = -EIO;
-					goto corrupt;
-				}
 				info->export_targets[j] = target;
 			}
 		} else {
-- 
2.31.1

