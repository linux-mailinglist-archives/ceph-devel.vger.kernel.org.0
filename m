Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFEF3EE7E6
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Aug 2021 09:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhHQH7F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Aug 2021 03:59:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234446AbhHQH7E (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 03:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629187111;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pbKxhl6/ojHPSMX0HWCs/vU9QervyHzgVkY/5y6gCiI=;
        b=U98asmb9qdmRRuKKIZqljCVOFFDYblRd9CXHRg1T7PjM3EkRZRxzuywbv6s4TuVfbur8RN
        sMUHf4jWo36HERVEQWcXOIaCylCVH2GzRCmyokt48Nwo0r0OkFgtSwlvgeqOOgyfRDr8aY
        rv4hmtARtyTBf8dpvWJnuynJY5ccaf0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-MaIwknPqOBKlfo2c41YHbQ-1; Tue, 17 Aug 2021 03:58:29 -0400
X-MC-Unique: MaIwknPqOBKlfo2c41YHbQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C071192CC4B;
        Tue, 17 Aug 2021 07:58:28 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4AD25D6AD;
        Tue, 17 Aug 2021 07:58:26 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: correctly release memory from capsnap
Date:   Tue, 17 Aug 2021 15:58:16 +0800
Message-Id: <20210817075816.190025-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When force umounting, it will try to remove all the session caps.
If there has any capsnap is in the flushing list, the remove session
caps callback will try to release the capsnap->flush_cap memory to
"ceph_cap_flush_cachep" slab cache, while which is allocated from
kmalloc-256 slab cache.

URL: https://tracker.ceph.com/issues/52283
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 00b3b0a0beb8..cb517753bb17 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1264,10 +1264,18 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	spin_unlock(&ci->i_ceph_lock);
 	while (!list_empty(&to_remove)) {
 		struct ceph_cap_flush *cf;
+		struct ceph_cap_snap *capsnap;
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
 		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		if (cf->caps) {
+			ceph_free_cap_flush(cf);
+		} else if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
+			capsnap = container_of(cf, struct ceph_cap_snap, cap_flush);
+			list_del(&capsnap->ci_item);
+			ceph_put_snap_context(capsnap->context);
+			ceph_put_cap_snap(capsnap);
+		}
 	}
 
 	wake_up_all(&ci->i_cap_wq);
-- 
2.27.0

