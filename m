Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B312411694B
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 10:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfLIJ2q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 04:28:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58450 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727144AbfLIJ2q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Dec 2019 04:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575883724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3pTBDLl0BWbJPd5nPsQpBfReTw+s4WliLhpqo/bH5Mo=;
        b=WVjJtBb4IoWzeGuhXC5GpAt5WUQBHhdxbnFK2mOOFV869ON0SwuKH/4+HpRPiDrrlHeTwK
        uL70Bn/gmJhuhbaMYvwh78jM0jf+rZKYrO59CYgIqETNiO01fUhTqa14rnNYTH7otxufgl
        YkxmA4n+BqTXcWNMtZyLUXxGa2lRjvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-L4OqxVT0NNigwAy_qzq_NQ-1; Mon, 09 Dec 2019 04:28:43 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EC1C1005512;
        Mon,  9 Dec 2019 09:28:42 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24BF85C545;
        Mon,  9 Dec 2019 09:28:35 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: clean the dirty page when session is closed or rejected
Date:   Mon,  9 Dec 2019 04:28:30 -0500
Message-Id: <20191209092830.22157-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: L4OqxVT0NNigwAy_qzq_NQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Try to queue writeback and invalidate the dirty pages when sessions
are closed, rejected or reconnect denied.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index be1ac9f8e0e6..68f3b5ed6ac8 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1385,9 +1385,11 @@ static int remove_session_caps_cb(struct inode *inod=
e, struct ceph_cap *cap,
 {
 =09struct ceph_fs_client *fsc =3D (struct ceph_fs_client *)arg;
 =09struct ceph_inode_info *ci =3D ceph_inode(inode);
+=09struct ceph_mds_session *session =3D cap->session;
 =09LIST_HEAD(to_remove);
 =09bool dirty_dropped =3D false;
 =09bool invalidate =3D false;
+=09bool writeback =3D false;
=20
 =09dout("removing cap %p, ci is %p, inode is %p\n",
 =09     cap, ci, &ci->vfs_inode);
@@ -1398,12 +1400,21 @@ static int remove_session_caps_cb(struct inode *ino=
de, struct ceph_cap *cap,
 =09if (!ci->i_auth_cap) {
 =09=09struct ceph_cap_flush *cf;
 =09=09struct ceph_mds_client *mdsc =3D fsc->mdsc;
+=09=09int s_state =3D session->s_state;
=20
 =09=09if (READ_ONCE(fsc->mount_state) =3D=3D CEPH_MOUNT_SHUTDOWN) {
 =09=09=09if (inode->i_data.nrpages > 0)
 =09=09=09=09invalidate =3D true;
 =09=09=09if (ci->i_wrbuffer_ref > 0)
 =09=09=09=09mapping_set_error(&inode->i_data, -EIO);
+=09=09} else if (s_state =3D=3D CEPH_MDS_SESSION_CLOSED ||
+=09=09=09   s_state =3D=3D CEPH_MDS_SESSION_REJECTED) {
+=09=09=09/* reconnect denied or rejected */
+=09=09=09if (!__ceph_is_any_real_caps(ci) &&
+=09=09=09    inode->i_data.nrpages > 0)
+=09=09=09=09invalidate =3D true;
+=09=09=09if (ci->i_wrbuffer_ref > 0)
+=09=09=09=09writeback =3D true;
 =09=09}
=20
 =09=09while (!list_empty(&ci->i_cap_flush_list)) {
@@ -1472,6 +1483,8 @@ static int remove_session_caps_cb(struct inode *inode=
, struct ceph_cap *cap,
 =09}
=20
 =09wake_up_all(&ci->i_cap_wq);
+=09if (writeback)
+=09=09ceph_queue_writeback(inode);
 =09if (invalidate)
 =09=09ceph_queue_invalidate(inode);
 =09if (dirty_dropped)
--=20
2.21.0

