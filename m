Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85230108C9F
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 12:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfKYLJG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 06:09:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46880 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727278AbfKYLJG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Nov 2019 06:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574680145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0434QUXjPvIaHT1EaIkqlZLBAS2xooOlYe242h7NpmM=;
        b=A9ThN6Nwg6fntVodY2S2iKGWPikI9z7KbwYjgVwizps/fZA2GT90KIjPIA4oS6UFEtX9wx
        PFpnrCBE0itFdBJrtKDOs+uY7uXGzkLLXre1JzA0SytBeNc1RBx0THIGjwlekh1MnjRuQE
        +mkgjxaGnAdqAYdm0/VoPn02BCgQ89Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-uWMptwYgMDCjVoPJbc_g4A-1; Mon, 25 Nov 2019 06:09:03 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D51F800686;
        Mon, 25 Nov 2019 11:09:02 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53BB75D9CA;
        Mon, 25 Nov 2019 11:08:57 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2 1/3] mdsmap: add more debug info when decoding
Date:   Mon, 25 Nov 2019 06:08:25 -0500
Message-Id: <20191125110827.12827-2-xiubli@redhat.com>
In-Reply-To: <20191125110827.12827-1-xiubli@redhat.com>
References: <20191125110827.12827-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: uWMptwYgMDCjVoPJbc_g4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Show the laggy state.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mdsmap.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index aeec1d6e3769..471bac335fae 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -158,6 +158,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09void *pexport_targets =3D NULL;
 =09=09struct ceph_timespec laggy_since;
 =09=09struct ceph_mds_info *info;
+=09=09bool laggy;
=20
 =09=09ceph_decode_need(p, end, sizeof(u64) + 1, bad);
 =09=09global_id =3D ceph_decode_64(p);
@@ -190,6 +191,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09if (err)
 =09=09=09goto corrupt;
 =09=09ceph_decode_copy(p, &laggy_since, sizeof(laggy_since));
+=09=09laggy =3D laggy_since.tv_sec !=3D 0 || laggy_since.tv_nsec !=3D 0;
 =09=09*p +=3D sizeof(u32);
 =09=09ceph_decode_32_safe(p, end, namelen, bad);
 =09=09*p +=3D namelen;
@@ -207,10 +209,11 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void=
 *end)
 =09=09=09*p =3D info_end;
 =09=09}
=20
-=09=09dout("mdsmap_decode %d/%d %lld mds%d.%d %s %s\n",
+=09=09dout("mdsmap_decode %d/%d %lld mds%d.%d %s %s%s\n",
 =09=09     i+1, n, global_id, mds, inc,
 =09=09     ceph_pr_addr(&addr),
-=09=09     ceph_mds_state_name(state));
+=09=09     ceph_mds_state_name(state),
+=09=09     laggy ? "(laggy)" : "");
=20
 =09=09if (mds < 0 || state <=3D 0)
 =09=09=09continue;
@@ -230,8 +233,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09info->global_id =3D global_id;
 =09=09info->state =3D state;
 =09=09info->addr =3D addr;
-=09=09info->laggy =3D (laggy_since.tv_sec !=3D 0 ||
-=09=09=09       laggy_since.tv_nsec !=3D 0);
+=09=09info->laggy =3D laggy;
 =09=09info->num_export_targets =3D num_export_targets;
 =09=09if (num_export_targets) {
 =09=09=09info->export_targets =3D kcalloc(num_export_targets,
@@ -355,6 +357,8 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *=
end)
 =09=09m->m_damaged =3D false;
 =09}
 bad_ext:
+=09dout("mdsmap_decode m_enabled: %d, m_damaged: %d, m_num_laggy: %d\n",
+=09     !!m->m_enabled, !!m->m_damaged, m->m_num_laggy);
 =09*p =3D end;
 =09dout("mdsmap_decode success epoch %u\n", m->m_epoch);
 =09return m;
--=20
2.21.0

