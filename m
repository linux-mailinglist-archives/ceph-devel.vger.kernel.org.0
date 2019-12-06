Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA14114AA0
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2019 02:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfLFBuf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Dec 2019 20:50:35 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725988AbfLFBuf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Dec 2019 20:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575597033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bxumC1nxv85LWjRRBAVATKhFR9Ndy6C1YHqBpY+ltRw=;
        b=hz1GfzyawHX05/xAq8oAHvTspnIIlHLHjjTfT3X8K4/4g3nu185ZYNQePqGIA435lvIoan
        BsFbH+iT/pQ6GrjvO28ktkHOuR+qS+15lt+cJMaBQwYRSE2kwXXCDzVppj7IKZ35BSh8XO
        gHaBFwJ6acHx+AgkQ19ERAK/HA5i9XM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-4GX_6LVRMdaZCXjIuwOnrQ-1; Thu, 05 Dec 2019 20:50:32 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F29E8017DF;
        Fri,  6 Dec 2019 01:50:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26B2260C87;
        Fri,  6 Dec 2019 01:50:25 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: add __send_request helper
Date:   Thu,  5 Dec 2019 20:50:21 -0500
Message-Id: <20191206015021.31611-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 4GX_6LVRMdaZCXjIuwOnrQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 47 +++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e47341da5a71..82dfc85b24ee 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2514,6 +2514,26 @@ static int __prepare_send_request(struct ceph_mds_cl=
ient *mdsc,
 =09return 0;
 }
=20
+/*
+ * called under mdsc->mutex
+ */
+static int __send_request(struct ceph_mds_client *mdsc,
+=09=09=09  struct ceph_mds_session *session,
+=09=09=09  struct ceph_mds_request *req,
+=09=09=09  bool drop_cap_releases)
+{
+=09int err;
+
+=09err =3D __prepare_send_request(mdsc, req, session->s_mds,
+=09=09=09=09     drop_cap_releases);
+=09if (!err) {
+=09=09ceph_msg_get(req->r_request);
+=09=09ceph_con_send(&session->s_con, req->r_request);
+=09}
+
+=09return err;
+}
+
 /*
  * send request, or put it on the appropriate wait list.
  */
@@ -2603,11 +2623,7 @@ static void __do_request(struct ceph_mds_client *mds=
c,
 =09if (req->r_request_started =3D=3D 0)   /* note request start time */
 =09=09req->r_request_started =3D jiffies;
=20
-=09err =3D __prepare_send_request(mdsc, req, mds, false);
-=09if (!err) {
-=09=09ceph_msg_get(req->r_request);
-=09=09ceph_con_send(&session->s_con, req->r_request);
-=09}
+=09err =3D __send_request(mdsc, session, req, false);
=20
 out_session:
 =09ceph_put_mds_session(session);
@@ -3210,7 +3226,6 @@ static void handle_session(struct ceph_mds_session *s=
ession,
 =09return;
 }
=20
-
 /*
  * called under session->mutex.
  */
@@ -3219,18 +3234,12 @@ static void replay_unsafe_requests(struct ceph_mds_=
client *mdsc,
 {
 =09struct ceph_mds_request *req, *nreq;
 =09struct rb_node *p;
-=09int err;
=20
 =09dout("replay_unsafe_requests mds%d\n", session->s_mds);
=20
 =09mutex_lock(&mdsc->mutex);
-=09list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item) =
{
-=09=09err =3D __prepare_send_request(mdsc, req, session->s_mds, true);
-=09=09if (!err) {
-=09=09=09ceph_msg_get(req->r_request);
-=09=09=09ceph_con_send(&session->s_con, req->r_request);
-=09=09}
-=09}
+=09list_for_each_entry_safe(req, nreq, &session->s_unsafe, r_unsafe_item)
+=09=09__send_request(mdsc, session, req, true);
=20
 =09/*
 =09 * also re-send old requests when MDS enters reconnect stage. So that M=
DS
@@ -3245,14 +3254,8 @@ static void replay_unsafe_requests(struct ceph_mds_c=
lient *mdsc,
 =09=09if (req->r_attempts =3D=3D 0)
 =09=09=09continue; /* only old requests */
 =09=09if (req->r_session &&
-=09=09    req->r_session->s_mds =3D=3D session->s_mds) {
-=09=09=09err =3D __prepare_send_request(mdsc, req,
-=09=09=09=09=09=09     session->s_mds, true);
-=09=09=09if (!err) {
-=09=09=09=09ceph_msg_get(req->r_request);
-=09=09=09=09ceph_con_send(&session->s_con, req->r_request);
-=09=09=09}
-=09=09}
+=09=09    req->r_session->s_mds =3D=3D session->s_mds)
+=09=09=09__send_request(mdsc, session, req, true);
 =09}
 =09mutex_unlock(&mdsc->mutex);
 }
--=20
2.21.0

