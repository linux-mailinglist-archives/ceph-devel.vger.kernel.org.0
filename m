Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 528E81500D7
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 05:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBCECJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 2 Feb 2020 23:02:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22668 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727228AbgBCECI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 2 Feb 2020 23:02:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580702527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pX+W7fqBp3ROG0xkh6pl8eCCjYE3oxEKFUFebc2Qmvw=;
        b=RvfTD1WOz+jQ1dJSwSqF53B9w5DZgvINXhabpUtNtSoXs9/AituOd/vtrKWBhi9HQ0UDaf
        d3fqREFbWuVRG0ZqFnb7T6W2TuRu/ZHh39O0Uhuxr9DEhnE0YQfu7Hdog45M1GNukn05oQ
        Jbn3lNuwBBO6WCTnc4+OXmBB+9juGak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-_jOR8hhJPfmwJirYqa76fw-1; Sun, 02 Feb 2020 23:02:05 -0500
X-MC-Unique: _jOR8hhJPfmwJirYqa76fw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03F181800D41;
        Mon,  3 Feb 2020 04:02:04 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C739784BCD;
        Mon,  3 Feb 2020 04:01:58 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: fix the debug message for calc_layout
Date:   Sun,  2 Feb 2020 23:01:33 -0500
Message-Id: <20200203040133.39319-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 net/ceph/osd_client.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 108c9457d629..6afe36ffc1ba 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -113,10 +113,11 @@ static int calc_layout(struct ceph_file_layout *lay=
out, u64 off, u64 *plen,
 	if (*objlen < orig_len) {
 		*plen =3D *objlen;
 		dout(" skipping last %llu, final file extent %llu~%llu\n",
-		     orig_len - *plen, off, *plen);
+		     orig_len - *plen, off, off + *plen);
 	}
=20
-	dout("calc_layout objnum=3D%llx %llu~%llu\n", *objnum, *objoff, *objlen=
);
+	dout("calc_layout objnum=3D%llx, object extent %llu~%llu\n", *objnum,
+	     *objoff, *objoff + *objlen);
 	return 0;
 }
=20
--=20
2.21.0

