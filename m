Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFEE108CA7
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 12:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfKYLJY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 06:09:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54713 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727495AbfKYLJY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Nov 2019 06:09:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574680162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myFxpDrAzanEG01Ae41+b1PiW1Sqeoj4x/3weLu2EX8=;
        b=UCMC37QJy7Q1zXPLysxIKEz2upwY5y6Ga7A9DReRavKa5le04oAiDaqagaSdehLzVmtMll
        M0EVnMvveqFKH/4U1MeBxEfRT5Uwc34Y7pBnTi3LTG6/0KXa31/D+eiJycSQL/utMEDVOL
        iHy7slaXvsgS9sneIy5ZQWPNIPnw2Kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-UCeHMbNJOL-aRMxoHyd-nQ-1; Mon, 25 Nov 2019 06:09:18 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67E46DB65;
        Mon, 25 Nov 2019 11:09:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11FC55D9CA;
        Mon, 25 Nov 2019 11:09:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 2/3] mdsmap: fix mdsmap cluster available check based on laggy number
Date:   Mon, 25 Nov 2019 06:08:26 -0500
Message-Id: <20191125110827.12827-3-xiubli@redhat.com>
In-Reply-To: <20191125110827.12827-1-xiubli@redhat.com>
References: <20191125110827.12827-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: UCeHMbNJOL-aRMxoHyd-nQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In case the max_mds > 1 in MDS cluster and there is no any standby
MDS and all the max_mds MDSs are in up:active state, if one of the
up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
Then the mount will fail without considering other healthy MDSs.

There manybe some MDSs still "in" the cluster but not in up:active
state, we will ignore them. Only when all the up:active MDSs in
the cluster are laggy will treat the cluster as not be available.

In case decreasing the max_mds, the cluster will not stop the extra
up:active MDSs immediately and there will be a latency. During it
the up:active MDS number will be larger than the max_mds, so later
the m_info memories will 100% be reallocated.

Here will pick out the up:active MDSs as the m_num_mds and allocate
the needed memories once.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mdsmap.c            | 32 ++++++++++----------------------
 include/linux/ceph/mdsmap.h |  5 +++--
 2 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 471bac335fae..cc9ec959fe46 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -138,14 +138,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
 =09m->m_session_autoclose =3D ceph_decode_32(p);
 =09m->m_max_file_size =3D ceph_decode_64(p);
 =09m->m_max_mds =3D ceph_decode_32(p);
-=09m->m_num_mds =3D m->m_max_mds;
+
+=09/*
+=09 * pick out the active nodes as the m_num_mds, the m_num_mds
+=09 * maybe larger than m_max_mds when decreasing the max_mds in
+=09 * cluster side, in other case it should less than or equal
+=09 * to m_max_mds.
+=09 */
+=09m->m_num_mds =3D n =3D ceph_decode_32(p);
+=09m->m_num_active_mds =3D m->m_num_mds;
=20
 =09m->m_info =3D kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
 =09if (!m->m_info)
 =09=09goto nomem;
=20
 =09/* pick out active nodes from mds_info (state > 0) */
-=09n =3D ceph_decode_32(p);
 =09for (i =3D 0; i < n; i++) {
 =09=09u64 global_id;
 =09=09u32 namelen;
@@ -218,17 +225,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void =
*end)
 =09=09if (mds < 0 || state <=3D 0)
 =09=09=09continue;
=20
-=09=09if (mds >=3D m->m_num_mds) {
-=09=09=09int new_num =3D max(mds + 1, m->m_num_mds * 2);
-=09=09=09void *new_m_info =3D krealloc(m->m_info,
-=09=09=09=09=09=09new_num * sizeof(*m->m_info),
-=09=09=09=09=09=09GFP_NOFS | __GFP_ZERO);
-=09=09=09if (!new_m_info)
-=09=09=09=09goto nomem;
-=09=09=09m->m_info =3D new_m_info;
-=09=09=09m->m_num_mds =3D new_num;
-=09=09}
-
 =09=09info =3D &m->m_info[mds];
 =09=09info->global_id =3D global_id;
 =09=09info->state =3D state;
@@ -247,14 +243,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void =
*end)
 =09=09=09info->export_targets =3D NULL;
 =09=09}
 =09}
-=09if (m->m_num_mds > m->m_max_mds) {
-=09=09/* find max up mds */
-=09=09for (i =3D m->m_num_mds; i >=3D m->m_max_mds; i--) {
-=09=09=09if (i =3D=3D 0 || m->m_info[i-1].state > 0)
-=09=09=09=09break;
-=09=09}
-=09=09m->m_num_mds =3D i;
-=09}
=20
 =09/* pg_pools */
 =09ceph_decode_32_safe(p, end, n, bad);
@@ -396,7 +384,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsma=
p *m)
 =09=09return false;
 =09if (m->m_damaged)
 =09=09return false;
-=09if (m->m_num_laggy > 0)
+=09if (m->m_num_laggy =3D=3D m->m_num_active_mds)
 =09=09return false;
 =09for (i =3D 0; i < m->m_num_mds; i++) {
 =09=09if (m->m_info[i].state =3D=3D CEPH_MDS_STATE_ACTIVE)
diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
index 0067d767c9ae..3a66f4f926ce 100644
--- a/include/linux/ceph/mdsmap.h
+++ b/include/linux/ceph/mdsmap.h
@@ -25,8 +25,9 @@ struct ceph_mdsmap {
 =09u32 m_session_timeout;          /* seconds */
 =09u32 m_session_autoclose;        /* seconds */
 =09u64 m_max_file_size;
-=09u32 m_max_mds;                  /* size of m_addr, m_state arrays */
-=09int m_num_mds;
+=09u32 m_max_mds;=09=09=09/* expected up:active mds number */
+=09int m_num_active_mds;=09=09/* actual up:active mds number */
+=09int m_num_mds;                  /* size of m_info array */
 =09struct ceph_mds_info *m_info;
=20
 =09/* which object pools file data can be stored in */
--=20
2.21.0

