Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B443910AE0D
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 11:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK0KqI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 05:46:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37014 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726383AbfK0KqI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Nov 2019 05:46:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574851567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=THpQwzy5mr+gnfT3Zs9Av0sttMPn2RjvxGrvFix2bps=;
        b=CxOvuWfNxFLRE7ikXnjsGzjJrNDQmY/dBNG8xzluhoSlSF+MaEpp2TbshJwFd4QE0NiPfe
        vTH4uK+TO0U/gf/ipdvBH3moWhyYiWCK4ULUSXDiDmRTc2T8z7DWzuNaBmrjLu57f/+DjN
        HQA7vDg5A4igsS7y136g6aTUGSqCmRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-PJC-dV5FO1eoE4_myx-g9Q-1; Wed, 27 Nov 2019 05:46:01 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12FDD108BD1E;
        Wed, 27 Nov 2019 10:46:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 928DF1001DE1;
        Wed, 27 Nov 2019 10:45:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [RFC PATCH] ceph: fix cap revoke race
Date:   Wed, 27 Nov 2019 05:45:49 -0500
Message-Id: <20191127104549.33305-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: PJC-dV5FO1eoE4_myx-g9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The cap->implemented is one subset of the cap->issued, the logic
here want to exclude the revoking caps, but the following code
will be (~cap->implemented | cap->issued) =3D=3D 0xFFFF, so it will
make no sense when we doing the "have &=3D 0xFFFF".

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c62e88da4fee..a9335402c2a5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, int =
*implemented)
 =09 */
 =09if (ci->i_auth_cap) {
 =09=09cap =3D ci->i_auth_cap;
-=09=09have &=3D ~cap->implemented | cap->issued;
+=09=09have &=3D ~(cap->implemented & ~cap->issued);
 =09}
 =09return have;
 }
--=20
2.21.0

