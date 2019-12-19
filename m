Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEEF125912
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 02:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLSBHc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Dec 2019 20:07:32 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35693 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726518AbfLSBHc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 20:07:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576717650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I5HjXBSQeVQOpa1Aec9mnzUBwiIgCvFCnkG3Dk514LU=;
        b=Yjh0NPxu6bgAdHJ9Dos5EH1UYntZiJSNJFHYVBD46XhQyBWvCTeSI4Zq8IHcRnCLlFYioH
        7siguKL1hRSH09oEj6Aau7i4AY7joHqvKpKmOD0vZL85QRgI5YMV0rIYMNs+rMmIXP0F8R
        xV92hHu+LnxG/tg+dCY3tx0TRC/Fjws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-cjcvB-4BMXqio1LYD911AA-1; Wed, 18 Dec 2019 20:07:28 -0500
X-MC-Unique: cjcvB-4BMXqio1LYD911AA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D13D801E6C;
        Thu, 19 Dec 2019 01:07:27 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8257326DF4;
        Thu, 19 Dec 2019 01:07:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: rename get_session and switch to use ceph_get_mds_session
Date:   Wed, 18 Dec 2019 20:07:16 -0500
Message-Id: <20191219010716.60987-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Just in case the session's refcount reach 0 and is releasing, and
if we get the session without checking it, we may encounter kernel
crash.

Rename get_session to ceph_get_mds_session and make it global.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V2:
- there has some conflict and rebase to upstream code.


 fs/ceph/mds_client.c | 16 ++++++++--------
 fs/ceph/mds_client.h |  9 ++-------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index d8bb3eebfaeb..a64f9ccdc2ff 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -538,7 +538,7 @@ const char *ceph_session_state_name(int s)
 	}
 }
=20
-static struct ceph_mds_session *get_session(struct ceph_mds_session *s)
+struct ceph_mds_session *ceph_get_mds_session(struct ceph_mds_session *s=
)
 {
 	if (refcount_inc_not_zero(&s->s_ref)) {
 		dout("mdsc get_session %p %d -> %d\n", s,
@@ -569,7 +569,7 @@ struct ceph_mds_session *__ceph_lookup_mds_session(st=
ruct ceph_mds_client *mdsc,
 {
 	if (mds >=3D mdsc->max_sessions || !mdsc->sessions[mds])
 		return NULL;
-	return get_session(mdsc->sessions[mds]);
+	return ceph_get_mds_session(mdsc->sessions[mds]);
 }
=20
 static bool __have_session(struct ceph_mds_client *mdsc, int mds)
@@ -1990,7 +1990,7 @@ void ceph_flush_cap_releases(struct ceph_mds_client=
 *mdsc,
 	if (mdsc->stopping)
 		return;
=20
-	get_session(session);
+	ceph_get_mds_session(session);
 	if (queue_work(mdsc->fsc->cap_wq,
 		       &session->s_cap_release_work)) {
 		dout("cap release work queued\n");
@@ -2605,7 +2605,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
 			goto finish;
 		}
 	}
-	req->r_session =3D get_session(session);
+	req->r_session =3D ceph_get_mds_session(session);
=20
 	dout("do_request mds%d session %p state %s\n", mds, session,
 	     ceph_session_state_name(session->s_state));
@@ -3129,7 +3129,7 @@ static void handle_session(struct ceph_mds_session =
*session,
=20
 	mutex_lock(&mdsc->mutex);
 	if (op =3D=3D CEPH_SESSION_CLOSE) {
-		get_session(session);
+		ceph_get_mds_session(session);
 		__unregister_session(mdsc, session);
 	}
 	/* FIXME: this ttl calculation is generous */
@@ -3804,7 +3804,7 @@ static void check_new_map(struct ceph_mds_client *m=
dsc,
=20
 		if (i >=3D newmap->m_num_mds) {
 			/* force close session for stopped mds */
-			get_session(s);
+			ceph_get_mds_session(s);
 			__unregister_session(mdsc, s);
 			__wake_requests(mdsc, &s->s_waiting);
 			mutex_unlock(&mdsc->mutex);
@@ -4404,7 +4404,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_clien=
t *mdsc)
 	mutex_lock(&mdsc->mutex);
 	for (i =3D 0; i < mdsc->max_sessions; i++) {
 		if (mdsc->sessions[i]) {
-			session =3D get_session(mdsc->sessions[i]);
+			session =3D ceph_get_mds_session(mdsc->sessions[i]);
 			__unregister_session(mdsc, session);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&session->s_mutex);
@@ -4632,7 +4632,7 @@ static struct ceph_connection *con_get(struct ceph_=
connection *con)
 {
 	struct ceph_mds_session *s =3D con->private;
=20
-	if (get_session(s)) {
+	if (ceph_get_mds_session(s)) {
 		dout("mdsc con_get %p ok (%d)\n", s, refcount_read(&s->s_ref));
 		return con;
 	}
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 9fb2063b0600..a7a94cf57150 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -443,15 +443,10 @@ extern const char *ceph_mds_op_name(int op);
 extern struct ceph_mds_session *
 __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
=20
-static inline struct ceph_mds_session *
-ceph_get_mds_session(struct ceph_mds_session *s)
-{
-	refcount_inc(&s->s_ref);
-	return s;
-}
-
 extern const char *ceph_session_state_name(int s);
=20
+extern struct ceph_mds_session *
+ceph_get_mds_session(struct ceph_mds_session *s);
 extern void ceph_put_mds_session(struct ceph_mds_session *s);
=20
 extern int ceph_send_msg_mds(struct ceph_mds_client *mdsc,
--=20
2.21.0

