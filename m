Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B9E127284
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Dec 2019 01:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfLTAoZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 19:44:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23268 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726952AbfLTAoY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 19 Dec 2019 19:44:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576802663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xKUIOGV6c3ck9p+92F4amkWZBgpU6mBBT7YsrOeTs4g=;
        b=fS0MMwo4jWP6Nx8qL5POwm3MF5UwaBdqWRext8LLKqBoEtq0rNSEsfekJMon3GVeCh/ir7
        ou2BjrBw092yjGwy0QbLB+HKzNqt+DOsAG0KDLwPaSNjgyXRt0UyLjKkaD6slyT71pNALI
        8ZAy11zoBElTWS43FVmvaZOz0UiOHW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-WTaURx4nOxmEhwD8XK9nfA-1; Thu, 19 Dec 2019 19:44:19 -0500
X-MC-Unique: WTaURx4nOxmEhwD8XK9nfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AABCC1085956;
        Fri, 20 Dec 2019 00:44:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DBC85C1B0;
        Fri, 20 Dec 2019 00:44:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: rename get_session and switch to use ceph_get_mds_session
Date:   Thu, 19 Dec 2019 19:44:09 -0500
Message-Id: <20191220004409.12793-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Changed in V3:
- Clean all the local commit and pull it and rebased again, it is based
  the following commit:

  commit 3a1deab1d5c1bb693c268cc9b717c69554c3ca5e
  Author: Xiubo Li <xiubli@redhat.com>
  Date:   Wed Dec 4 06:57:39 2019 -0500

      ceph: add possible_max_rank and make the code more readable
       =20


 fs/ceph/mds_client.c | 16 ++++++++--------
 fs/ceph/mds_client.h |  9 ++-------
 2 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4080067d1672..d6c3d8d854e0 100644
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
@@ -1977,7 +1977,7 @@ void ceph_flush_cap_releases(struct ceph_mds_client=
 *mdsc,
 	if (mdsc->stopping)
 		return;
=20
-	get_session(session);
+	ceph_get_mds_session(session);
 	if (queue_work(mdsc->fsc->cap_wq,
 		       &session->s_cap_release_work)) {
 		dout("cap release work queued\n");
@@ -2613,7 +2613,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
 			goto finish;
 		}
 	}
-	req->r_session =3D get_session(session);
+	req->r_session =3D ceph_get_mds_session(session);
=20
 	dout("do_request mds%d session %p state %s\n", mds, session,
 	     ceph_session_state_name(session->s_state));
@@ -3135,7 +3135,7 @@ static void handle_session(struct ceph_mds_session =
*session,
=20
 	mutex_lock(&mdsc->mutex);
 	if (op =3D=3D CEPH_SESSION_CLOSE) {
-		get_session(session);
+		ceph_get_mds_session(session);
 		__unregister_session(mdsc, session);
 	}
 	/* FIXME: this ttl calculation is generous */
@@ -3797,7 +3797,7 @@ static void check_new_map(struct ceph_mds_client *m=
dsc,
=20
 		if (i >=3D newmap->possible_max_rank) {
 			/* force close session for stopped mds */
-			get_session(s);
+			ceph_get_mds_session(s);
 			__unregister_session(mdsc, s);
 			__wake_requests(mdsc, &s->s_waiting);
 			mutex_unlock(&mdsc->mutex);
@@ -4398,7 +4398,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_clien=
t *mdsc)
 	mutex_lock(&mdsc->mutex);
 	for (i =3D 0; i < mdsc->max_sessions; i++) {
 		if (mdsc->sessions[i]) {
-			session =3D get_session(mdsc->sessions[i]);
+			session =3D ceph_get_mds_session(mdsc->sessions[i]);
 			__unregister_session(mdsc, session);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&session->s_mutex);
@@ -4626,7 +4626,7 @@ static struct ceph_connection *con_get(struct ceph_=
connection *con)
 {
 	struct ceph_mds_session *s =3D con->private;
=20
-	if (get_session(s))
+	if (ceph_get_mds_session(s))
 		return con;
 	return NULL;
 }
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index fe085e06adf5..c021df5f50ce 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -452,15 +452,10 @@ extern const char *ceph_mds_op_name(int op);
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

