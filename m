Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812543FB659
	for <lists+ceph-devel@lfdr.de>; Mon, 30 Aug 2021 14:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhH3MsF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Aug 2021 08:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230513AbhH3MsE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 08:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630327630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JD2kYNZ/gfqBkKiMeJVpvb2FtWDnQNHPdJbV4dng8sM=;
        b=VF/++EhhJriBJOKFplBX3+Qs9J8m4HIR0fI5jAbX4dYWiJe5+w1hwIAdlimkOh0zZxo3Ag
        88r3W9UzK/60GOOC53fCY94M4mJDGpYUtgzq3y/XrwODtZHYfAnocX9pWFhs+oie6CZhzh
        I0PWRVaJk7dA1J5VOiQm63Hdlv6FDYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-S6Fx_HDMPMOFQ1CvT1bRkg-1; Mon, 30 Aug 2021 08:47:08 -0400
X-MC-Unique: S6Fx_HDMPMOFQ1CvT1bRkg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABBA018C89D9;
        Mon, 30 Aug 2021 12:47:07 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65A6F60CA0;
        Mon, 30 Aug 2021 12:47:01 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: fix incorrectly counting the export targets
Date:   Mon, 30 Aug 2021 20:46:56 +0800
Message-Id: <20210830124656.493641-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- s/m_num_active_mds/possible_max_rank/


 fs/ceph/mds_client.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7ddc36c14b92..c6451c160887 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4434,7 +4434,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 			  struct ceph_mdsmap *newmap,
 			  struct ceph_mdsmap *oldmap)
 {
-	int i, err;
+	int i, j, err;
 	int oldstate, newstate;
 	struct ceph_mds_session *s;
 	unsigned long targets[DIV_ROUND_UP(CEPH_MAX_MDS, sizeof(unsigned long))] = {0};
@@ -4443,8 +4443,10 @@ static void check_new_map(struct ceph_mds_client *mdsc,
 	     newmap->m_epoch, oldmap->m_epoch);
 
 	if (newmap->m_info) {
-		for (i = 0; i < newmap->m_info->num_export_targets; i++)
-			set_bit(newmap->m_info->export_targets[i], targets);
+		for (i = 0; i < newmap->possible_max_rank; i++) {
+			for (j = 0; j < newmap->m_info[i].num_export_targets; j++)
+				set_bit(newmap->m_info[i].export_targets[j], targets);
+		}
 	}
 
 	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
-- 
2.27.0

