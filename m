Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F9D11E8F
	for <lists+ceph-devel@lfdr.de>; Thu,  2 May 2019 17:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfEBPiG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 May 2019 11:38:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:57444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728928AbfEBPiA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 May 2019 11:38:00 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC152075E;
        Thu,  2 May 2019 15:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811480;
        bh=sPYJn4YN9Ra0AqDhB975cHz1o3cnK0a+61Dr9oBxIbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4a21cUvLrbUdEMJNqhEx+ga1ze1RWmQQHo0n0ixEGyKSKU4MD8/FE2O8UGmO5dh1
         HPlrj1sIry+2Q7rmceLHZxckxcL3TkbZ1RDWTAxBZuHLSqS9460Y308eCtWU2eH358
         IQYPczCTEj5+F+jajBLOidYPh1iJUlFcSlmEtw70=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH 2/3] ceph: fix unaligned access in ceph_send_cap_releases
Date:   Thu,  2 May 2019 11:37:56 -0400
Message-Id: <20190502153757.29038-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502153757.29038-1-jlayton@kernel.org>
References: <20190502153757.29038-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e09773a7a9cf..66eae336a68a 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1855,7 +1855,8 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
 		num_cap_releases--;
 
 		head = msg->front.iov_base;
-		le32_add_cpu(&head->num, 1);
+		put_unaligned_le32(get_unaligned_le32(&head->num) + 1,
+				   &head->num);
 		item = msg->front.iov_base + msg->front.iov_len;
 		item->ino = cpu_to_le64(cap->cap_ino);
 		item->cap_id = cpu_to_le64(cap->cap_id);
-- 
2.21.0

