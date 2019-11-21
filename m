Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B49B51050D8
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 11:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKUKpy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 05:45:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726014AbfKUKpw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 21 Nov 2019 05:45:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574333152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vlU61pp1Orpjae2//kfkniEc4rKiPIz8h3zGQWgv5wY=;
        b=EzUcm0XQLmE0ss8z2/Is4WBHH1UhwUM5y/ClGAOH19G7t4h2WJQQJB5lpoyyRIUkHYdSOl
        7RJ2qeFf9xBweKpNsq+KhbVG839j+DX9OVaOrt+/AoGCc+tuv7X2ziOa2SAsP7fdjftrU3
        f7KWZolG+VVuSADol7mNwKxVv9elD9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-peqehZ5PN8O-KwQQvTH5kg-1; Thu, 21 Nov 2019 05:45:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 814688024DA;
        Thu, 21 Nov 2019 10:45:47 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6678967E4D;
        Thu, 21 Nov 2019 10:45:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove redundant request session put code
Date:   Thu, 21 Nov 2019 05:45:37 -0500
Message-Id: <20191121104537.22630-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: peqehZ5PN8O-KwQQvTH5kg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Since the _do_request() will do it anyway again, so this here makes
no sense. This will keep the same with kick_requests() from commit
dc69e2e9fcd.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a4e7026aaec9..8ceea0c62fda 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3025,7 +3025,6 @@ static void handle_forward(struct ceph_mds_client *md=
sc,
 =09=09req->r_attempts =3D 0;
 =09=09req->r_num_fwd =3D fwd_seq;
 =09=09req->r_resend_mds =3D next_mds;
-=09=09put_request_session(req);
 =09=09__do_request(mdsc, req);
 =09}
 =09ceph_mdsc_put_request(req);
--=20
2.21.0

