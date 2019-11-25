Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B62108CA6
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 12:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKYLJY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 06:09:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35434 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727633AbfKYLJY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Nov 2019 06:09:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574680163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUB1SOEzee/uLv95tCGE3sqZ+srfP2ZV5gKnHlcz8MU=;
        b=XRcaXT2xBNpNvsweZsxDSjwEKvx22zKKNe2A/Oe4cpPD3Fxl/EwX26IhKd9YdZ7Mzt4nIl
        T0T5uwA3TPFzuam0O4VC1jLmA5oM7bdWna2Sb5pVY3d9y1Mz4QMaT9rOKtKmWcjxUXMSTH
        NQGKD2KTrqZ06IQq8xUDQCOpvcpgfEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-IZAEJYZwOD2FYEXJ6geodg-1; Mon, 25 Nov 2019 06:09:21 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9321800585;
        Mon, 25 Nov 2019 11:09:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F27E35D9CA;
        Mon, 25 Nov 2019 11:09:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 3/3] mdsmap: only choose one MDS who is in up:active state without laggy
Date:   Mon, 25 Nov 2019 06:08:27 -0500
Message-Id: <20191125110827.12827-4-xiubli@redhat.com>
In-Reply-To: <20191125110827.12827-1-xiubli@redhat.com>
References: <20191125110827.12827-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: IZAEJYZwOD2FYEXJ6geodg-1
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
 fs/ceph/mds_client.c | 13 +++++++++----
 fs/ceph/mdsmap.c     | 30 +++++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0444288fe87e..2c92a1452876 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -972,14 +972,14 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 =09=09=09=09     frag.frag, mds,
 =09=09=09=09     (int)r, frag.ndist);
 =09=09=09=09if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
-=09=09=09=09    CEPH_MDS_STATE_ACTIVE)
+=09=09=09=09    CEPH_MDS_STATE_ACTIVE &&
+=09=09=09=09    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
 =09=09=09=09=09goto out;
 =09=09=09}
=20
 =09=09=09/* since this file/dir wasn't known to be
 =09=09=09 * replicated, then we want to look for the
 =09=09=09 * authoritative mds. */
-=09=09=09mode =3D USE_AUTH_MDS;
 =09=09=09if (frag.mds >=3D 0) {
 =09=09=09=09/* choose auth mds */
 =09=09=09=09mds =3D frag.mds;
@@ -987,9 +987,14 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 =09=09=09=09     "frag %u mds%d (auth)\n",
 =09=09=09=09     inode, ceph_vinop(inode), frag.frag, mds);
 =09=09=09=09if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
-=09=09=09=09    CEPH_MDS_STATE_ACTIVE)
-=09=09=09=09=09goto out;
+=09=09=09=09    CEPH_MDS_STATE_ACTIVE) {
+=09=09=09=09=09if (mode =3D=3D USE_ANY_MDS &&
+=09=09=09=09=09    !ceph_mdsmap_is_laggy(mdsc->mdsmap,
+=09=09=09=09=09=09=09=09  mds))
+=09=09=09=09=09=09goto out;
+=09=09=09=09}
 =09=09=09}
+=09=09=09mode =3D USE_AUTH_MDS;
 =09=09}
 =09}
=20
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index cc9ec959fe46..1e32cf486825 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -13,22 +13,24 @@
=20
 #include "super.h"
=20
+#define CEPH_MDS_IS_READY(i, ignore_laggy) \
+=09(m->m_info[i].state > 0 && (ignore_laggy ? true : !m->m_info[i].laggy))
=20
-/*
- * choose a random mds that is "up" (i.e. has a state > 0), or -1.
- */
-int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
+static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_lagg=
y)
 {
 =09int n =3D 0;
 =09int i, j;
=20
-=09/* special case for one mds */
+=09/*
+=09 * special case for one mds, no matter it is laggy or
+=09 * not we have no choice
+=09 */
 =09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0)
 =09=09return 0;
=20
 =09/* count */
 =09for (i =3D 0; i < m->m_num_mds; i++)
-=09=09if (m->m_info[i].state > 0)
+=09=09if (CEPH_MDS_IS_READY(i, ignore_laggy))
 =09=09=09n++;
 =09if (n =3D=3D 0)
 =09=09return -1;
@@ -36,7 +38,7 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
 =09/* pick */
 =09n =3D prandom_u32() % n;
 =09for (j =3D 0, i =3D 0; i < m->m_num_mds; i++) {
-=09=09if (m->m_info[i].state > 0)
+=09=09if (CEPH_MDS_IS_READY(i, ignore_laggy))
 =09=09=09j++;
 =09=09if (j > n)
 =09=09=09break;
@@ -45,6 +47,20 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
 =09return i;
 }
=20
+/*
+ * choose a random mds that is "up" (i.e. has a state > 0), or -1.
+ */
+int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
+{
+=09int mds;
+
+=09mds =3D __mdsmap_get_random_mds(m, false);
+=09if (mds =3D=3D m->m_num_mds || mds =3D=3D -1)
+=09=09mds =3D __mdsmap_get_random_mds(m, true);
+
+=09return mds =3D=3D m->m_num_mds ? -1 : mds;
+}
+
 #define __decode_and_drop_type(p, end, type, bad)=09=09\
 =09do {=09=09=09=09=09=09=09\
 =09=09if (*p + sizeof(type) > end)=09=09=09\
--=20
2.21.0

