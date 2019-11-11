Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC42F7369
	for <lists+ceph-devel@lfdr.de>; Mon, 11 Nov 2019 12:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfKKLvZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 11 Nov 2019 06:51:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726810AbfKKLvZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 11 Nov 2019 06:51:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573473084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GDNFoderkQrnYyZj4E6c9FtkV33mg0Gci6iSHwP+PZY=;
        b=Iy2ExHDzAUOnUEnXI8HhXP9z1qYbSMlydM471FSK4TjDWoJbR0xDCDaW4/Q0bEYgvSJR2Z
        letcHlcHkaD883YnaYK+/qADkOZzpgQZYhjdaWOfltM19LbmJJ/hsgq8E2xfT2Qe9XtzA5
        gUl/KclS2iX/24WE7oLwoFjNZLR7FTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-GamrE1PKOYuMs1fFZelrIw-1; Mon, 11 Nov 2019 06:51:21 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BCDEDB21;
        Mon, 11 Nov 2019 11:51:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-180.pek2.redhat.com [10.72.12.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB2EF608EB;
        Mon, 11 Nov 2019 11:51:14 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, sage@redhat.com, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix geting random mds from mdsmap
Date:   Mon, 11 Nov 2019 06:51:05 -0500
Message-Id: <20191111115105.58758-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: GamrE1PKOYuMs1fFZelrIw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

For example, if we have 5 mds in the mdsmap and the states are:
m_info[5] --> [-1, 1, -1, 1, 1]

If we get a ramdon number 1, then we should get the mds index 3 as
expected, but actually we will get index 2, which the state is -1.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mdsmap.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index ce2d00da5096..2011147f76bf 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -20,7 +20,7 @@
 int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
 {
 =09int n =3D 0;
-=09int i;
+=09int i, j;
=20
 =09/* special case for one mds */
 =09if (1 =3D=3D m->m_num_mds && m->m_info[0].state > 0)
@@ -35,9 +35,12 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
=20
 =09/* pick */
 =09n =3D prandom_u32() % n;
-=09for (i =3D 0; n > 0; i++, n--)
-=09=09while (m->m_info[i].state <=3D 0)
-=09=09=09i++;
+=09for (j =3D 0, i =3D 0; i < m->m_num_mds; i++) {
+=09=09if (m->m_info[0].state > 0)
+=09=09=09j++;
+=09=09if (j > n)
+=09=09=09break;
+=09}
=20
 =09return i;
 }
--=20
2.21.0

