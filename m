Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352F3169C9D
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 04:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgBXDXb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 23 Feb 2020 22:23:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727156AbgBXDXb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 23 Feb 2020 22:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582514610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uZZteyPJ9A+jWVvPYJ325y7aDWupzG3orfWV2jElQtk=;
        b=CY1JU3ebcXcPx+8FpYH/Gy+iuCiuOP2Of2HrGN8GSJb9MJdyDk4gjX8o92Womd9iXpOCAZ
        6x1vROG1TmX5+Y+Q4vJfyaxfLMqhquhbdZx7ROWjiS93zdAxow2pOuJo9YMqDaR1rMD7Vy
        Z4WgFzuOy7UjYIz38R1+Mnyoq7NnVwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-aVqPUf2YNVmzAh94Lm2aaQ-1; Sun, 23 Feb 2020 22:23:28 -0500
X-MC-Unique: aVqPUf2YNVmzAh94Lm2aaQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21D6613E2;
        Mon, 24 Feb 2020 03:23:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-139.pek2.redhat.com [10.72.12.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A58AB1CB;
        Mon, 24 Feb 2020 03:23:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: return ETIMEDOUT errno to userland when request timed out
Date:   Sun, 23 Feb 2020 22:23:11 -0500
Message-Id: <20200224032311.26107-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The ETIMEOUT errno will be cleaner and be more user-friendly.

URL: https://tracker.ceph.com/issues/44215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 3e792eca6af7..a1649eb3a3fd 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2578,7 +2578,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
 		dout("do_request timed out\n");
-		err =3D -EIO;
+		err =3D -ETIMEDOUT;
 		goto finish;
 	}
 	if (READ_ONCE(mdsc->fsc->mount_state) =3D=3D CEPH_MOUNT_SHUTDOWN) {
@@ -2752,7 +2752,7 @@ static int ceph_mdsc_wait_request(struct ceph_mds_c=
lient *mdsc,
 		if (timeleft > 0)
 			err =3D 0;
 		else if (!timeleft)
-			err =3D -EIO;  /* timed out */
+			err =3D -ETIMEDOUT;  /* timed out */
 		else
 			err =3D timeleft;  /* killed */
 	}
--=20
2.21.0

