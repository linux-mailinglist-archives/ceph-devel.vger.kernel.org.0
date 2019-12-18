Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D353D12465E
	for <lists+ceph-devel@lfdr.de>; Wed, 18 Dec 2019 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLRMBD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 Dec 2019 07:01:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22586 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbfLRMBD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 07:01:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576670461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1dzWcx5nLfpa1h9jxyqJk6GADRRqMc7NtES1VMmbYHg=;
        b=MaQRsJj2RqPvJDTQRBlc8hfhshyfObZ1sHtoIuWFmFrYobc0H21JxFruB9RMDW2xInt3OU
        fQl2Ru3TB1S+KISqhtfEUfpvLdMPmko8HsfVjRJi5DTMKwtG4bPPb4OHE4/sLPRpopO3N5
        YmDdDyWXmZbP3X03+0vW55t6xs5FmdQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-Seex4yhkPqaMzhPwNnebeQ-1; Wed, 18 Dec 2019 07:00:57 -0500
X-MC-Unique: Seex4yhkPqaMzhPwNnebeQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B596C8017DF;
        Wed, 18 Dec 2019 12:00:56 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F1D21A8E3;
        Wed, 18 Dec 2019 12:00:50 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: rename get_session and switch to use ceph_get_mds_session
Date:   Wed, 18 Dec 2019 07:00:41 -0500
Message-Id: <20191218120041.8263-1-xiubli@redhat.com>
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
 fs/ceph/caps.c       |  4 ++--
 fs/ceph/mds_client.c | 16 ++++++++--------
 fs/ceph/mds_client.h |  9 ++-------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 5c89a915409b..5a828298456a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info *ci, in=
t *implemented, int mask)
 		     &ci->vfs_inode, cap, ceph_cap_string(cap->issued));
=20
 		if (mask >=3D 0) {
-			s =3D get_session(cap->session);
+			s =3D ceph_get_mds_session(cap->session);
 			if (cap =3D=3D ci->i_auth_cap)
 				r =3D revoking;
 			if (mask & (cap->issued & ~r))
@@ -907,7 +907,7 @@ int __ceph_caps_issued_mask(struct ceph_inode_info *c=
i, int mask, int touch,
 		if (!__cap_is_valid(cap))
 			continue;
=20
-		s =3D get_session(cap->session);
+		s =3D ceph_get_mds_session(cap->session);
 		if ((cap->issued & mask) =3D=3D mask) {
 			dout("__ceph_caps_issued_mask ino 0x%lx cap %p issued %s"
 			     " (mask %s)\n", ci->vfs_inode.i_ino, cap,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 99de89a3a0d3..619b08cba677 100644
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
@@ -571,7 +571,7 @@ struct ceph_mds_session *__ceph_lookup_mds_session(st=
ruct ceph_mds_client *mdsc,
 {
 	if (mds >=3D mdsc->max_sessions || !mdsc->sessions[mds])
 		return NULL;
-	return get_session(mdsc->sessions[mds]);
+	return ceph_get_mds_session(mdsc->sessions[mds]);
 }
=20
 static bool __have_session(struct ceph_mds_client *mdsc, int mds)
@@ -2004,7 +2004,7 @@ void ceph_flush_cap_releases(struct ceph_mds_client=
 *mdsc,
 	if (mdsc->stopping)
 		return;
=20
-	get_session(session);
+	ceph_get_mds_session(session);
 	if (queue_work(mdsc->fsc->cap_wq,
 		       &session->s_cap_release_work)) {
 		dout("cap release work queued\n");
@@ -2619,7 +2619,7 @@ static void __do_request(struct ceph_mds_client *md=
sc,
 			goto finish;
 		}
 	}
-	req->r_session =3D get_session(session);
+	req->r_session =3D ceph_get_mds_session(session);
=20
 	dout("do_request mds%d session %p state %s\n", mds, session,
 	     ceph_session_state_name(session->s_state));
@@ -3143,7 +3143,7 @@ static void handle_session(struct ceph_mds_session =
*session,
=20
 	mutex_lock(&mdsc->mutex);
 	if (op =3D=3D CEPH_SESSION_CLOSE) {
-		get_session(session);
+		ceph_get_mds_session(session);
 		__unregister_session(mdsc, session);
 	}
 	/* FIXME: this ttl calculation is generous */
@@ -3818,7 +3818,7 @@ static void check_new_map(struct ceph_mds_client *m=
dsc,
=20
 		if (i >=3D newmap->m_num_mds) {
 			/* force close session for stopped mds */
-			get_session(s);
+			ceph_get_mds_session(s);
 			__unregister_session(mdsc, s);
 			__wake_requests(mdsc, &s->s_waiting);
 			mutex_unlock(&mdsc->mutex);
@@ -4460,7 +4460,7 @@ void ceph_mdsc_close_sessions(struct ceph_mds_clien=
t *mdsc)
 	mutex_lock(&mdsc->mutex);
 	for (i =3D 0; i < mdsc->max_sessions; i++) {
 		if (mdsc->sessions[i]) {
-			session =3D get_session(mdsc->sessions[i]);
+			session =3D ceph_get_mds_session(mdsc->sessions[i]);
 			__unregister_session(mdsc, session);
 			mutex_unlock(&mdsc->mutex);
 			mutex_lock(&session->s_mutex);
@@ -4693,7 +4693,7 @@ static struct ceph_connection *con_get(struct ceph_=
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
index 40676c2392cf..37e8798e7408 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -457,15 +457,10 @@ extern const char *ceph_mds_op_name(int op);
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

