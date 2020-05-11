Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D15CB1CD3C2
	for <lists+ceph-devel@lfdr.de>; Mon, 11 May 2020 10:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgEKIZW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 May 2020 04:25:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44780 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728556AbgEKIZW (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 11 May 2020 04:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589185521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8fk6CBxS3ygqOX9mJxDLcsRMKDbm71vhJXYycG1uW3o=;
        b=ON0AlGMGOQ7TYgQHGCxEjy9aN5E4zdQ5YwVxXeg9SFRWDJ4djTFV1Y/1jgxOzQ0ZG3H6XR
        E9B2Ws5YppEQWJazbqgRISaOBzjwd9s5H6ZadqCC3tnfQ4cbs7Q0LU09kp7kqEa8lyDZAF
        qJ3GIDMXsMolPzj7OUoEbflPwPm3sJM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-tzHaUwAxOiilL-HOaNBaqw-1; Mon, 11 May 2020 04:25:19 -0400
X-MC-Unique: tzHaUwAxOiilL-HOaNBaqw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56732107ACCD;
        Mon, 11 May 2020 08:25:17 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-194.pek2.redhat.com [10.72.12.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 456FB5D9DA;
        Mon, 11 May 2020 08:25:14 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH] ceph: properly wake up cap waiter after releasing revoked caps
Date:   Mon, 11 May 2020 16:25:12 +0800
Message-Id: <20200511082512.4375-1-zyan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

arg->wake can never be true. the bug was introduced by commit
0c4b255369bcf "ceph: reorganize __send_cap for less spinlock abuse"

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b3e65c89ba6e..a2a2cda117e0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1376,6 +1376,12 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 	ci->i_ceph_flags &= ~CEPH_I_FLUSH;
 
 	cap->issued &= retain;  /* drop bits we don't want */
+	/*
+	 * Wake up any waiters on wanted -> needed transition. This is due to
+	 * the weird transition from buffered to sync IO... we need to flush
+	 * dirty pages _before_ allowing sync writes to avoid reordering.
+	 */
+	arg->wake = cap->implemented & ~cap->issued;
 	cap->implemented &= cap->issued | used;
 	cap->mds_wanted = want;
 
@@ -1439,13 +1445,6 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 		}
 	}
 	arg->flags = flags;
-
-	/*
-	 * Wake up any waiters on wanted -> needed transition. This is due to
-	 * the weird transition from buffered to sync IO... we need to flush
-	 * dirty pages _before_ allowing sync writes to avoid reordering.
-	 */
-	arg->wake = cap->implemented & ~cap->issued;
 }
 
 /*
-- 
2.21.3

