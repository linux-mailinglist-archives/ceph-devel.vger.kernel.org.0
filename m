Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BFB11FDD3
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Dec 2019 06:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfLPFNK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Dec 2019 00:13:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47984 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725789AbfLPFNJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Dec 2019 00:13:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576473188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L2qgkWPf4nVgTD46buXyNLnbgIPH4NOxTMxLr6x7w+Y=;
        b=jI1dWn9jX05U7yzGUBCg4AJFLkds28inc4T3yy44dUe6sagnHIjx67LB8D1kUGwRU0InPt
        3hKdsRFUKqoo7a/cZxPYjpD8fJr/MJFEBJ0r8el8NnY3/h+ohd+HzmrzyLB5IPlkh2l7n7
        I1ZAJKbh0x+HoeqxRgTryoVRNztnYgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-90ixDyi-MDKgKuFe2JDfjw-1; Mon, 16 Dec 2019 00:13:04 -0500
X-MC-Unique: 90ixDyi-MDKgKuFe2JDfjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6FA718A6EF2;
        Mon, 16 Dec 2019 05:13:03 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-99.pek2.redhat.com [10.72.12.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D78D1001901;
        Mon, 16 Dec 2019 05:12:58 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: only touch the caps which have the subset mask requested
Date:   Mon, 16 Dec 2019 00:12:07 -0500
Message-Id: <20191216051207.8667-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For the caps having no any subset mask requested we shouldn't touch
them.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1d7f66902b0a..b9e5960df183 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -908,7 +908,8 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *c=
i, int mask, int touch)
 						       ci_node);
 					if (!__cap_is_valid(cap))
 						continue;
-					__touch_cap(cap);
+					if (cap->issued & mask)
+						__touch_cap(cap);
 				}
 			}
 			return 1;
--=20
2.21.0

