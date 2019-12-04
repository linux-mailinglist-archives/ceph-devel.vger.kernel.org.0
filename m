Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9BAB112ACD
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 12:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfLDL54 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 06:57:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26669 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727472AbfLDL5z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 06:57:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575460673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CDlVplWLSFnQDDSc9AXD+3k1YxbDi0l2iKcaqngKJeM=;
        b=ah8jG/VXWXgO3+wJBIOblM7ikwbgZfGhLnUB32/EtuwAG79ZMWJ48UUMdSCTuTbsvXU6L7
        hnsqqpV+stxbTeIp5Y6zybgIzxauTOkfBTXcQgDPZve02gvZmdhFfJhmRgIsP9kCJujKUE
        nu3X/NP+gLOTws0HGJontJsykHK+IWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217--lZkTaJHPhyUrdmDfQXLng-1; Wed, 04 Dec 2019 06:57:52 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98D36801E70;
        Wed,  4 Dec 2019 11:57:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD8E11001920;
        Wed,  4 Dec 2019 11:57:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add possible_max_rank and make the code more readable
Date:   Wed,  4 Dec 2019 06:57:39 -0500
Message-Id: <20191204115739.53303-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: -lZkTaJHPhyUrdmDfQXLng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The m_num_mds here is actually the number for MDSs which are in
up:active status, and it will be duplicated to m_num_active_mds,
so remove it.

Add possible_max_rank to the mdsmap struct and this will be
the correctly possible largest rank boundary.

Remove the special case for one mds in __mdsmap_get_random_mds(),
because the validate mds rank may not always be 0.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c           |  2 +-
 fs/ceph/mds_client.c        | 10 ++++----
 fs/ceph/mdsmap.c            | 49 +++++++++++++++----------------------
 include/linux/ceph/mdsmap.h | 10 ++++----
 4 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index facb387c2735..0b1591e76077 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -33,7 +33,7 @@ static int mdsmap_show(struct seq_file *s, void *p)
 =09seq_printf(s, "max_mds %d\n", mdsmap->m_max_mds);
 =09seq_printf(s, "session_timeout %d\n", mdsmap->m_session_timeout);
 =09seq_printf(s, "session_autoclose %d\n", mdsmap->m_session_autoclose);
-=09for (i =3D 0; i < mdsmap->m_num_mds; i++) {
+=09for (i =3D 0; i < mdsmap->possible_max_rank; i++) {
 =09=09struct ceph_entity_addr *addr =3D &mdsmap->m_info[i].addr;
 =09=09int state =3D mdsmap->m_info[i].state;
 =09=09seq_printf(s, "\tmds%d\t%s\t(%s)\n", i,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 39f4d8501df5..036d388ddb10 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -597,7 +597,7 @@ static struct ceph_mds_session *register_session(struct=
 ceph_mds_client *mdsc,
 {
 =09struct ceph_mds_session *s;
=20
-=09if (mds >=3D mdsc->mdsmap->m_num_mds)
+=09if (mds >=3D mdsc->mdsmap->possible_max_rank)
 =09=09return ERR_PTR(-EINVAL);
=20
 =09s =3D kzalloc(sizeof(*s), GFP_NOFS);
@@ -1222,7 +1222,7 @@ static void __open_export_target_sessions(struct ceph=
_mds_client *mdsc,
 =09struct ceph_mds_session *ts;
 =09int i, mds =3D session->s_mds;
=20
-=09if (mds >=3D mdsc->mdsmap->m_num_mds)
+=09if (mds >=3D mdsc->mdsmap->possible_max_rank)
 =09=09return;
=20
 =09mi =3D &mdsc->mdsmap->m_info[mds];
@@ -3762,7 +3762,7 @@ static void check_new_map(struct ceph_mds_client *mds=
c,
 =09dout("check_new_map new %u old %u\n",
 =09     newmap->m_epoch, oldmap->m_epoch);
=20
-=09for (i =3D 0; i < oldmap->m_num_mds && i < mdsc->max_sessions; i++) {
+=09for (i =3D 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; =
i++) {
 =09=09if (!mdsc->sessions[i])
 =09=09=09continue;
 =09=09s =3D mdsc->sessions[i];
@@ -3776,7 +3776,7 @@ static void check_new_map(struct ceph_mds_client *mds=
c,
 =09=09     ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
 =09=09     ceph_session_state_name(s->s_state));
=20
-=09=09if (i >=3D newmap->m_num_mds) {
+=09=09if (i >=3D newmap->possible_max_rank) {
 =09=09=09/* force close session for stopped mds */
 =09=09=09get_session(s);
 =09=09=09__unregister_session(mdsc, s);
@@ -3833,7 +3833,7 @@ static void check_new_map(struct ceph_mds_client *mds=
c,
 =09=09}
 =09}
=20
-=09for (i =3D 0; i < newmap->m_num_mds && i < mdsc->max_sessions; i++) {
+=09for (i =3D 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; =
i++) {
 =09=09s =3D mdsc->sessions[i];
 =09=09if (!s)
 =09=09=09continue;
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index a77e0ecb9a6b..889627817e52 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -14,22 +14,15 @@
 #include "super.h"
=20
 #define CEPH_MDS_IS_READY(i, ignore_laggy) \
-=09(m->m_info[i].state > 0 && (ignore_laggy ? true : !m->m_info[i].laggy))
+=09(m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].laggy)
=20
 static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_lagg=
y)
 {
 =09int n =3D 0;
 =09int i, j;
=20
-=09/*
-=09 * special case for one mds, no matter it is laggy or
-=09 * not we have no choice
-=09 */
-=09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0)
-=09=09return 0;
-
 =09/* count */
-=09for (i =3D 0; i < m->m_num_mds; i++)
+=09for (i =3D 0; i < m->possible_max_rank; i++)
 =09=09if (CEPH_MDS_IS_READY(i, ignore_laggy))
 =09=09=09n++;
 =09if (n =3D=3D 0)
@@ -37,7 +30,7 @@ static int __mdsmap_get_random_mds(struct ceph_mdsmap *m,=
 bool ignore_laggy)
=20
 =09/* pick */
 =09n =3D prandom_u32() % n;
-=09for (j =3D 0, i =3D 0; i < m->m_num_mds; i++) {
+=09for (j =3D 0, i =3D 0; i < m->possible_max_rank; i++) {
 =09=09if (CEPH_MDS_IS_READY(i, ignore_laggy))
 =09=09=09j++;
 =09=09if (j > n)
@@ -55,10 +48,10 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
 =09int mds;
=20
 =09mds =3D __mdsmap_get_random_mds(m, false);
-=09if (mds =3D=3D m->m_num_mds || mds =3D=3D -1)
+=09if (mds =3D=3D m->possible_max_rank || mds =3D=3D -1)
 =09=09mds =3D __mdsmap_get_random_mds(m, true);
=20
-=09return mds =3D=3D m->m_num_mds ? -1 : mds;
+=09return mds =3D=3D m->possible_max_rank ? -1 : mds;
 }
=20
 #define __decode_and_drop_type(p, end, type, bad)=09=09\
@@ -129,7 +122,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09int err;
 =09u8 mdsmap_v, mdsmap_cv;
 =09u16 mdsmap_ev;
-=09u32 possible_max_rank;
=20
 =09m =3D kzalloc(sizeof(*m), GFP_NOFS);
 =09if (!m)
@@ -157,24 +149,23 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
 =09m->m_max_mds =3D ceph_decode_32(p);
=20
 =09/*
-=09 * pick out the active nodes as the m_num_mds, the m_num_mds
-=09 * maybe larger than m_max_mds when decreasing the max_mds in
-=09 * cluster side, in other case it should less than or equal
-=09 * to m_max_mds.
+=09 * pick out the active nodes as the m_num_active_mds, the
+=09 * m_num_active_mds maybe larger than m_max_mds when decreasing
+=09 * the max_mds in cluster side, in other case it should less
+=09 * than or equal to m_max_mds.
 =09 */
-=09m->m_num_mds =3D n =3D ceph_decode_32(p);
-=09m->m_num_active_mds =3D m->m_num_mds;
+=09m->m_num_active_mds =3D n =3D ceph_decode_32(p);
=20
 =09/*
-=09 * the possible max rank, it maybe larger than the m->m_num_mds,
+=09 * the possible max rank, it maybe larger than the m_num_active_mds,
 =09 * for example if the mds_max =3D=3D 2 in the cluster, when the MDS(0)
 =09 * was laggy and being replaced by a new MDS, we will temporarily
 =09 * receive a new mds map with n_num_mds =3D=3D 1 and the active MDS(1),
-=09 * and the mds rank >=3D m->m_num_mds.
+=09 * and the mds rank >=3D m_num_active_mds.
 =09 */
-=09possible_max_rank =3D max((u32)m->m_num_mds, m->m_max_mds);
+=09m->possible_max_rank =3D max(m->m_num_active_mds, m->m_max_mds);
=20
-=09m->m_info =3D kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
+=09m->m_info =3D kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOF=
S);
 =09if (!m->m_info)
 =09=09goto nomem;
=20
@@ -248,7 +239,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09     ceph_mds_state_name(state),
 =09=09     laggy ? "(laggy)" : "");
=20
-=09=09if (mds < 0 || mds >=3D possible_max_rank) {
+=09=09if (mds < 0 || mds >=3D m->possible_max_rank) {
 =09=09=09pr_warn("mdsmap_decode got incorrect mds(%d)\n", mds);
 =09=09=09continue;
 =09=09}
@@ -318,14 +309,14 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
=20
 =09=09for (i =3D 0; i < n; i++) {
 =09=09=09s32 mds =3D ceph_decode_32(p);
-=09=09=09if (mds >=3D 0 && mds < m->m_num_mds) {
+=09=09=09if (mds >=3D 0 && mds < m->possible_max_rank) {
 =09=09=09=09if (m->m_info[mds].laggy)
 =09=09=09=09=09num_laggy++;
 =09=09=09}
 =09=09}
 =09=09m->m_num_laggy =3D num_laggy;
=20
-=09=09if (n > m->m_num_mds) {
+=09=09if (n > m->possible_max_rank) {
 =09=09=09void *new_m_info =3D krealloc(m->m_info,
 =09=09=09=09=09=09    n * sizeof(*m->m_info),
 =09=09=09=09=09=09    GFP_NOFS | __GFP_ZERO);
@@ -333,7 +324,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09=09=09goto nomem;
 =09=09=09m->m_info =3D new_m_info;
 =09=09}
-=09=09m->m_num_mds =3D n;
+=09=09m->possible_max_rank =3D n;
 =09}
=20
 =09/* inc */
@@ -404,7 +395,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
 {
 =09int i;
=20
-=09for (i =3D 0; i < m->m_num_mds; i++)
+=09for (i =3D 0; i < m->possible_max_rank; i++)
 =09=09kfree(m->m_info[i].export_targets);
 =09kfree(m->m_info);
 =09kfree(m->m_data_pg_pools);
@@ -420,7 +411,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsma=
p *m)
 =09=09return false;
 =09if (m->m_num_laggy =3D=3D m->m_num_active_mds)
 =09=09return false;
-=09for (i =3D 0; i < m->m_num_mds; i++) {
+=09for (i =3D 0; i < m->possible_max_rank; i++) {
 =09=09if (m->m_info[i].state =3D=3D CEPH_MDS_STATE_ACTIVE)
 =09=09=09nr_active++;
 =09}
diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
index 3a66f4f926ce..35d385296fbb 100644
--- a/include/linux/ceph/mdsmap.h
+++ b/include/linux/ceph/mdsmap.h
@@ -26,8 +26,8 @@ struct ceph_mdsmap {
 =09u32 m_session_autoclose;        /* seconds */
 =09u64 m_max_file_size;
 =09u32 m_max_mds;=09=09=09/* expected up:active mds number */
-=09int m_num_active_mds;=09=09/* actual up:active mds number */
-=09int m_num_mds;                  /* size of m_info array */
+=09u32 m_num_active_mds;=09=09/* actual up:active mds number */
+=09u32 possible_max_rank;=09=09/* possible max rank index */
 =09struct ceph_mds_info *m_info;
=20
 =09/* which object pools file data can be stored in */
@@ -43,7 +43,7 @@ struct ceph_mdsmap {
 static inline struct ceph_entity_addr *
 ceph_mdsmap_get_addr(struct ceph_mdsmap *m, int w)
 {
-=09if (w >=3D m->m_num_mds)
+=09if (w >=3D m->possible_max_rank)
 =09=09return NULL;
 =09return &m->m_info[w].addr;
 }
@@ -51,14 +51,14 @@ ceph_mdsmap_get_addr(struct ceph_mdsmap *m, int w)
 static inline int ceph_mdsmap_get_state(struct ceph_mdsmap *m, int w)
 {
 =09BUG_ON(w < 0);
-=09if (w >=3D m->m_num_mds)
+=09if (w >=3D m->possible_max_rank)
 =09=09return CEPH_MDS_STATE_DNE;
 =09return m->m_info[w].state;
 }
=20
 static inline bool ceph_mdsmap_is_laggy(struct ceph_mdsmap *m, int w)
 {
-=09if (w >=3D 0 && w < m->m_num_mds)
+=09if (w >=3D 0 && w < m->possible_max_rank)
 =09=09return m->m_info[w].laggy;
 =09return false;
 }
--=20
2.21.0

