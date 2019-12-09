Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE73116D4B
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 13:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfLIMrl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 07:47:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727200AbfLIMrl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Dec 2019 07:47:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575895660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pynJpYKKhU9Kh/nMigdg1TL0CnPnt8Dp/pY3GtJ/yuo=;
        b=HHgViUlm0/PxRXoQaW5X3sdGZjPZBqxL3VXg50xR0u4Cgkesvh89v8XzNnOrN+/FILf3pi
        0o35NJcZJoeVLnR3vhnI+Wo5JksL0UEd6CDxglYOVkAe4E0zTwo5ynV//OrddN1UGZqwkO
        GjRr+CfF6zj7WDjcIpFvVD2mMsJOvVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-q3el2a_LPbGdBagnLTjqlw-1; Mon, 09 Dec 2019 07:47:28 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 768AF801E78;
        Mon,  9 Dec 2019 12:47:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AC9A5C21B;
        Mon,  9 Dec 2019 12:47:21 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: retry the same mds later after the new session is opened
Date:   Mon,  9 Dec 2019 07:47:15 -0500
Message-Id: <20191209124715.2255-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: q3el2a_LPbGdBagnLTjqlw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

With max_mds > 1 and for a request which are choosing a random
mds rank and if the relating session is not opened yet, the request
will wait the session been opened and resend again. While every
time the request is beening __do_request, it will release the
req->session first and choose a random one again, so this time it
may choose another random mds rank. The worst case is that it will
open all the mds sessions one by one just before it can be
successfully sent out out.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 68f3b5ed6ac8..d747e9baf9c9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -876,7 +876,8 @@ static struct inode *get_nonsnap_parent(struct dentry *=
dentry)
  * Called under mdsc->mutex.
  */
 static int __choose_mds(struct ceph_mds_client *mdsc,
-=09=09=09struct ceph_mds_request *req)
+=09=09=09struct ceph_mds_request *req,
+=09=09=09bool *random)
 {
 =09struct inode *inode;
 =09struct ceph_inode_info *ci;
@@ -886,6 +887,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 =09u32 hash =3D req->r_direct_hash;
 =09bool is_hash =3D test_bit(CEPH_MDS_R_DIRECT_IS_HASH, &req->r_req_flags)=
;
=20
+=09if (random)
+=09=09*random =3D false;
+
 =09/*
 =09 * is there a specific mds we should try?  ignore hint if we have
 =09 * no session and the mds is not up (active or recovering).
@@ -1021,6 +1025,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 =09return mds;
=20
 random:
+=09if (random)
+=09=09*random =3D true;
+
 =09mds =3D ceph_mdsmap_get_random_mds(mdsc->mdsmap);
 =09dout("choose_mds chose random mds%d\n", mds);
 =09return mds;
@@ -2556,6 +2563,7 @@ static void __do_request(struct ceph_mds_client *mdsc=
,
 =09struct ceph_mds_session *session =3D NULL;
 =09int mds =3D -1;
 =09int err =3D 0;
+=09bool random;
=20
 =09if (req->r_err || test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
 =09=09if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags))
@@ -2596,7 +2604,7 @@ static void __do_request(struct ceph_mds_client *mdsc=
,
=20
 =09put_request_session(req);
=20
-=09mds =3D __choose_mds(mdsc, req);
+=09mds =3D __choose_mds(mdsc, req, &random);
 =09if (mds < 0 ||
 =09    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
 =09=09dout("do_request no mds or not active, waiting for map\n");
@@ -2624,8 +2632,12 @@ static void __do_request(struct ceph_mds_client *mds=
c,
 =09=09=09goto out_session;
 =09=09}
 =09=09if (session->s_state =3D=3D CEPH_MDS_SESSION_NEW ||
-=09=09    session->s_state =3D=3D CEPH_MDS_SESSION_CLOSING)
+=09=09    session->s_state =3D=3D CEPH_MDS_SESSION_CLOSING) {
 =09=09=09__open_session(mdsc, session);
+=09=09=09/* retry the same mds later */
+=09=09=09if (random)
+=09=09=09=09req->r_resend_mds =3D mds;
+=09=09}
 =09=09list_add(&req->r_wait, &session->s_waiting);
 =09=09goto out_session;
 =09}
@@ -2890,7 +2902,7 @@ static void handle_reply(struct ceph_mds_session *ses=
sion, struct ceph_msg *msg)
 =09=09=09mutex_unlock(&mdsc->mutex);
 =09=09=09goto out;
 =09=09} else  {
-=09=09=09int mds =3D __choose_mds(mdsc, req);
+=09=09=09int mds =3D __choose_mds(mdsc, req, NULL);
 =09=09=09if (mds >=3D 0 && mds !=3D req->r_session->s_mds) {
 =09=09=09=09dout("but auth changed, so resending\n");
 =09=09=09=09__do_request(mdsc, req);
--=20
2.21.0

