Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A479544AA58
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 10:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244895AbhKIJOv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 04:14:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56615 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244973AbhKIJOW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Nov 2021 04:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636449096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HoUK2vTxIByIReSkuhQoZEVaLcAYcWoJFgfd6Ih+vQ=;
        b=g/XJb1mOwPAF3Moi9GlRqpqJUHktjpkETzuPsx2qFY/I6tw6K68UKQZHi4YKoU5HND5Bdb
        m9LAIZjYXkQm8s6VF0WBme3xKwLD3V/HuKm08rBKt7CgRDM/teyykueBaQVqcdjknwMSD2
        L56JXW6L/sD1e1dAs6aoul6Bt/c0OHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-0_czMQBfM_mnJGftRbDuHQ-1; Tue, 09 Nov 2021 04:11:33 -0500
X-MC-Unique: 0_czMQBfM_mnJGftRbDuHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3F9056FDE;
        Tue,  9 Nov 2021 09:11:17 +0000 (UTC)
Received: from kotresh-T490s.redhat.com (unknown [10.67.24.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF30119C59;
        Tue,  9 Nov 2021 09:11:15 +0000 (UTC)
From:   khiremat@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        xiubli@redhat.com, ceph-devel@vger.kernel.org,
        Kotresh HR <khiremat@redhat.com>
Subject: [PATCH v1 1/1] ceph: Fix incorrect statfs report for small quota
Date:   Tue,  9 Nov 2021 14:40:41 +0530
Message-Id: <20211109091041.121750-2-khiremat@redhat.com>
In-Reply-To: <20211109091041.121750-1-khiremat@redhat.com>
References: <20211109091041.121750-1-khiremat@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Kotresh HR <khiremat@redhat.com>

Problem:
The statfs reports incorrect free/available space
for quota less then CEPH_BLOCK size (4M).

Solution:
For quotas less than CEPH_BLOCK size, it is
decided to go with binary use/free of full block.
For quota size less than CEPH_BLOCK size, report
the total=used=CEPH_BLOCK,free=0 when quota is
full and total=free=CEPH_BLOCK, used=0 otherwise.

Signed-off-by: Kotresh HR <khiremat@redhat.com>
---
 fs/ceph/quota.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index 620c691af40e..d49ba82d08bf 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -505,6 +505,22 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 			buf->f_bfree = free;
 			buf->f_bavail = free;
 			is_updated = true;
+		} else if (ci->i_max_bytes) {
+			/* For quota size less than CEPH_BLOCK size, report
+			 * the total=used=CEPH_BLOCK,free=0 when quota is full and
+			 * total=free=CEPH_BLOCK, used=0 otherwise  */
+			total = ci->i_max_bytes;
+			used = ci->i_rbytes;
+
+			buf->f_blocks = 1;
+			if (total > used) {
+				buf->f_bfree = 1;
+				buf->f_bavail = 1;
+			} else {
+				buf->f_bfree = 0;
+				buf->f_bavail = 0;
+			}
+			is_updated = true;
 		}
 		iput(in);
 	}
-- 
2.31.1

