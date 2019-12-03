Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5528111001F
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 15:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLCOaG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 09:30:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25205 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725848AbfLCOaG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Dec 2019 09:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575383405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8Oqw5MPrcX2s7z8kAtDRSSdOIYVP/3Z6GDVI1Fg3Zv8=;
        b=eu/uJQNnzgkWPqtcLEo6KxBKiGWSxoIETKpSNXdbZILatuFPvYgb3vQDZBKWJNWSLcIvHf
        PA7FiuBfGzJONSIqLhD5tcnQ3rcKZtHGI/bpObLHOGp7HKAA6qNknYTLogT1c7iehCOuMz
        sAGBOdwDftGlrM0+OsgUTCpDtaxjH0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-n7G63CXfPRiRDWbqcj11Nw-1; Tue, 03 Dec 2019 09:30:00 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC9DA107B7D8;
        Tue,  3 Dec 2019 14:29:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69EDF5D6AE;
        Tue,  3 Dec 2019 14:29:54 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix mdsmap_decode got incorrect mds(X)
Date:   Tue,  3 Dec 2019 09:29:49 -0500
Message-Id: <20191203142949.34910-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: n7G63CXfPRiRDWbqcj11Nw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The possible max rank, it maybe larger than the m->m_num_mds,
for example if the mds_max =3D=3D 2 in the cluster, when the MDS(0)
was laggy and being replaced by a new MDS, we will temporarily
receive a new mds map with n_num_mds =3D=3D 1 and the active MDS(1),
and the mds rank >=3D m->m_num_mds.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mdsmap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 284d68646c40..a77e0ecb9a6b 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -129,6 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09int err;
 =09u8 mdsmap_v, mdsmap_cv;
 =09u16 mdsmap_ev;
+=09u32 possible_max_rank;
=20
 =09m =3D kzalloc(sizeof(*m), GFP_NOFS);
 =09if (!m)
@@ -164,6 +165,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void =
*end)
 =09m->m_num_mds =3D n =3D ceph_decode_32(p);
 =09m->m_num_active_mds =3D m->m_num_mds;
=20
+=09/*
+=09 * the possible max rank, it maybe larger than the m->m_num_mds,
+=09 * for example if the mds_max =3D=3D 2 in the cluster, when the MDS(0)
+=09 * was laggy and being replaced by a new MDS, we will temporarily
+=09 * receive a new mds map with n_num_mds =3D=3D 1 and the active MDS(1),
+=09 * and the mds rank >=3D m->m_num_mds.
+=09 */
+=09possible_max_rank =3D max((u32)m->m_num_mds, m->m_max_mds);
+
 =09m->m_info =3D kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
 =09if (!m->m_info)
 =09=09goto nomem;
@@ -238,7 +248,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09     ceph_mds_state_name(state),
 =09=09     laggy ? "(laggy)" : "");
=20
-=09=09if (mds < 0 || mds >=3D m->m_num_mds) {
+=09=09if (mds < 0 || mds >=3D possible_max_rank) {
 =09=09=09pr_warn("mdsmap_decode got incorrect mds(%d)\n", mds);
 =09=09=09continue;
 =09=09}
--=20
2.21.0

