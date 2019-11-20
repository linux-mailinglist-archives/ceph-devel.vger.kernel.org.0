Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627501035FA
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 09:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfKTI3Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 03:29:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34852 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726038AbfKTI3Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Nov 2019 03:29:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574238563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJEPnd+ByM4bOAId6/vd9Lxq6m1pDU3luZ/aPT7Lp80=;
        b=LGdutJvRZV5zz8uDwmW4L8Y2dNh/A1KR/Qi0PAGJvGSy7WNHO8IrjYv+/VgY0dJHP06SRW
        kn2zOR4DTJ9ZyabPF4aaCaXzmdsd17+qnnBDzLs84tl6JgRmc63DyZcrrtJNk++M3jBLJX
        GVc4bt2lrWnzkaL9Uryw0R09JYURugU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-Z6k2klcpMtKed3GAkX85CA-1; Wed, 20 Nov 2019 03:29:22 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D24D1005512;
        Wed, 20 Nov 2019 08:29:21 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D914367E45;
        Wed, 20 Nov 2019 08:29:18 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 3/3] mdsmap: only choose one MDS who is in up:active state without laggy
Date:   Wed, 20 Nov 2019 03:29:02 -0500
Message-Id: <20191120082902.38666-4-xiubli@redhat.com>
In-Reply-To: <20191120082902.38666-1-xiubli@redhat.com>
References: <20191120082902.38666-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: Z6k2klcpMtKed3GAkX85CA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Even the MDS is in up:active state, but it also maybe laggy. Here
will skip the laggy MDSs.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c |  6 ++++--
 fs/ceph/mdsmap.c     | 13 +++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 82a929084671..a4e7026aaec9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -972,7 +972,8 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 =09=09=09=09     frag.frag, mds,
 =09=09=09=09     (int)r, frag.ndist);
 =09=09=09=09if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
-=09=09=09=09    CEPH_MDS_STATE_ACTIVE)
+=09=09=09=09    CEPH_MDS_STATE_ACTIVE &&
+=09=09=09=09    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
 =09=09=09=09=09goto out;
 =09=09=09}
=20
@@ -987,7 +988,8 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 =09=09=09=09     "frag %u mds%d (auth)\n",
 =09=09=09=09     inode, ceph_vinop(inode), frag.frag, mds);
 =09=09=09=09if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
-=09=09=09=09    CEPH_MDS_STATE_ACTIVE)
+=09=09=09=09    CEPH_MDS_STATE_ACTIVE &&
+=09=09=09=09    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
 =09=09=09=09=09goto out;
 =09=09=09}
 =09=09}
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 8b4f93e5b468..098669e6f1e4 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -13,6 +13,7 @@
=20
 #include "super.h"
=20
+#define CEPH_MDS_IS_READY(i) (m->m_info[i].state > 0 && !m->m_info[i].lagg=
y)
=20
 /*
  * choose a random mds that is "up" (i.e. has a state > 0), or -1.
@@ -23,12 +24,16 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
 =09int i, j;
=20
 =09/* special case for one mds */
-=09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0)
-=09=09return 0;
+=09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0) {
+=09=09if (m->m_info[0].laggy)
+=09=09=09return -1;
+=09=09else
+=09=09=09return 0;
+=09}
=20
 =09/* count */
 =09for (i =3D 0; i < m->m_num_mds; i++)
-=09=09if (m->m_info[i].state > 0)
+=09=09if (CEPH_MDS_IS_READY(i))
 =09=09=09n++;
 =09if (n =3D=3D 0)
 =09=09return -1;
@@ -36,7 +41,7 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
 =09/* pick */
 =09n =3D prandom_u32() % n;
 =09for (j =3D 0, i =3D 0; i < m->m_num_mds; i++) {
-=09=09if (m->m_info[i].state > 0)
+=09=09if (CEPH_MDS_IS_READY(i))
 =09=09=09j++;
 =09=09if (j > n)
 =09=09=09break;
--=20
2.21.0

