Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD710AF86
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 13:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfK0MZy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 07:25:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27365 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726383AbfK0MZx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Nov 2019 07:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574857552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=i+fR2QmvgcA90nbdf39PxebDagZK9bY+zK1EmUnVwt4=;
        b=ClHHchu6GEJNgPC2qUWDNy8aIYl1dOiuhaO8W/nb1jiD0jgt07a3w0Xi7ghKMwpLUFncy5
        7OcNu7E6PGo7my/r8RAHeiMZMANi77mjFD2mFezubyVCXnp3Ai6DymLgXwbe+cilFIOt+h
        7ntjUYLF1VwrTU8zBfi9mnTtORU7icY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-Cic0Z4MROYKLreIDmArm9w-1; Wed, 27 Nov 2019 07:25:51 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28D4E1005516;
        Wed, 27 Nov 2019 12:25:50 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7BDD600CA;
        Wed, 27 Nov 2019 12:25:44 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: remove unused code in ceph_check_caps
Date:   Wed, 27 Nov 2019 07:25:38 -0500
Message-Id: <20191127122538.33832-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Cic0Z4MROYKLreIDmArm9w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f5a38910a82b..c62e88da4fee 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1828,7 +1828,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int =
flags,
 =09int mds =3D -1;   /* keep track of how far we've gone through i_caps li=
st
 =09=09=09   to avoid an infinite loop on retry */
 =09struct rb_node *p;
-=09int delayed =3D 0, sent =3D 0;
+=09int delayed =3D 0;
 =09bool no_delay =3D flags & CHECK_CAPS_NODELAY;
 =09bool queue_invalidate =3D false;
 =09bool tried_invalidate =3D false;
@@ -2058,7 +2058,6 @@ void ceph_check_caps(struct ceph_inode_info *ci, int =
flags,
 =09=09}
=20
 =09=09mds =3D cap->mds;  /* remember mds, so we don't repeat */
-=09=09sent++;
=20
 =09=09/* __send_cap drops i_ceph_lock */
 =09=09delayed +=3D __send_cap(mdsc, cap, CEPH_CAP_OP_UPDATE, 0,
--=20
2.21.0

