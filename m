Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB6D10F95F
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 09:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfLCIBF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 03:01:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727491AbfLCIBF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Dec 2019 03:01:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575360063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zpdrG/gVlOUI7Tj9PCzbzOCrhNW+/oOCHLJdbmCTX08=;
        b=ZThBHU/q29iUhP5CxQJ2+vyTOwQxz+kzLIYAgs1Lsp70VvMgE0LoH9cETGUZkNCAJVfXxr
        VP92TuZpVE7pFAhMjnqDWLJcqBGXS+0w2GqRLiwb1m5uSqPSTexCg9hHVqGm5eer7wUiqG
        Yjexd2YklUC2ZHrnzGnfAHfOiTtwnNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-_ITDq-AoP9OfkkN0_DoJPw-1; Tue, 03 Dec 2019 03:01:02 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EEA2DB62;
        Tue,  3 Dec 2019 08:01:01 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3289608E2;
        Tue,  3 Dec 2019 08:00:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: switch to global cap helper
Date:   Tue,  3 Dec 2019 03:00:51 -0500
Message-Id: <20191203080051.13240-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: _ITDq-AoP9OfkkN0_DoJPw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

__ceph_is_any_caps is a duplicate helper.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c62e88da4fee..fafb84a2d8f5 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1011,18 +1011,13 @@ static int __ceph_is_single_caps(struct ceph_inode_=
info *ci)
 =09return rb_first(&ci->i_caps) =3D=3D rb_last(&ci->i_caps);
 }
=20
-static int __ceph_is_any_caps(struct ceph_inode_info *ci)
-{
-=09return !RB_EMPTY_ROOT(&ci->i_caps);
-}
-
 int ceph_is_any_caps(struct inode *inode)
 {
 =09struct ceph_inode_info *ci =3D ceph_inode(inode);
 =09int ret;
=20
 =09spin_lock(&ci->i_ceph_lock);
-=09ret =3D __ceph_is_any_caps(ci);
+=09ret =3D __ceph_is_any_real_caps(ci);
 =09spin_unlock(&ci->i_ceph_lock);
=20
 =09return ret;
@@ -1099,15 +1094,16 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool q=
ueue_release)
 =09if (removed)
 =09=09ceph_put_cap(mdsc, cap);
=20
-=09/* when reconnect denied, we remove session caps forcibly,
-=09 * i_wr_ref can be non-zero. If there are ongoing write,
-=09 * keep i_snap_realm.
-=09 */
-=09if (!__ceph_is_any_caps(ci) && ci->i_wr_ref =3D=3D 0 && ci->i_snap_real=
m)
-=09=09drop_inode_snap_realm(ci);
+=09if (!__ceph_is_any_real_caps(ci)) {
+=09=09/* when reconnect denied, we remove session caps forcibly,
+=09=09 * i_wr_ref can be non-zero. If there are ongoing write,
+=09=09 * keep i_snap_realm.
+=09=09 */
+=09=09if (ci->i_wr_ref =3D=3D 0 && ci->i_snap_realm)
+=09=09=09drop_inode_snap_realm(ci);
=20
-=09if (!__ceph_is_any_real_caps(ci))
 =09=09__cap_delay_cancel(mdsc, ci);
+=09}
 }
=20
 struct cap_msg_args {
@@ -2927,7 +2923,7 @@ void ceph_put_cap_refs(struct ceph_inode_info *ci, in=
t had)
 =09=09=09=09ci->i_head_snapc =3D NULL;
 =09=09=09}
 =09=09=09/* see comment in __ceph_remove_cap() */
-=09=09=09if (!__ceph_is_any_caps(ci) && ci->i_snap_realm)
+=09=09=09if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
 =09=09=09=09drop_inode_snap_realm(ci);
 =09=09}
 =09spin_unlock(&ci->i_ceph_lock);
--=20
2.21.0

