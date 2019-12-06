Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2287D114B73
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Dec 2019 04:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfLFDgE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Dec 2019 22:36:04 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60219 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726097AbfLFDgE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Dec 2019 22:36:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575603363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NbjZmvuQHnJP5eEKKBwXyT8/CFgyTu6y7Qi9J0TeK74=;
        b=MTVyUzWfcsKrKlkIRhqDqSfHtz8Uqq6J+dCYbsKxRYi+tq42JZ+/o7Ym7rzLN8wbJcrNU8
        ha7x51j8MyHeOaGN5fZ6U9hcJhVuOG5rJ2VtxkfJVIpRKMoS22fmQN+/J42zRGwGTG7lS6
        mcwYokr1uGFMTpupaoh+8jt7jg1L5A4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288--MPHVQpNPQy86sWAIqerBw-1; Thu, 05 Dec 2019 22:36:01 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92845107AD25;
        Fri,  6 Dec 2019 03:36:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7177EA4B8F;
        Fri,  6 Dec 2019 03:35:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: keep the session state until it is released
Date:   Thu,  5 Dec 2019 22:35:51 -0500
Message-Id: <20191206033551.34802-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: -MPHVQpNPQy86sWAIqerBw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When reconnecting the session but if it is denied by the MDS due
to client was in blacklist or something else, kclient will receive
a session close reply, and we will never see the important log:

"ceph:  mds%d reconnect denied"

And with the confusing log:

"ceph:  handle_session mds0 close 0000000085804730 state ??? seq 0"

Let's keep the session state until its memories is released.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 ++-
 fs/ceph/mds_client.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 82dfc85b24ee..be1ac9f8e0e6 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -530,6 +530,7 @@ const char *ceph_session_state_name(int s)
 =09case CEPH_MDS_SESSION_OPEN: return "open";
 =09case CEPH_MDS_SESSION_HUNG: return "hung";
 =09case CEPH_MDS_SESSION_CLOSING: return "closing";
+=09case CEPH_MDS_SESSION_CLOSED: return "closed";
 =09case CEPH_MDS_SESSION_RESTARTING: return "restarting";
 =09case CEPH_MDS_SESSION_RECONNECTING: return "reconnecting";
 =09case CEPH_MDS_SESSION_REJECTED: return "rejected";
@@ -674,7 +675,6 @@ static void __unregister_session(struct ceph_mds_client=
 *mdsc,
 =09dout("__unregister_session mds%d %p\n", s->s_mds, s);
 =09BUG_ON(mdsc->sessions[s->s_mds] !=3D s);
 =09mdsc->sessions[s->s_mds] =3D NULL;
-=09s->s_state =3D 0;
 =09ceph_con_close(&s->s_con);
 =09ceph_put_mds_session(s);
 =09atomic_dec(&mdsc->num_sessions);
@@ -3159,6 +3159,7 @@ static void handle_session(struct ceph_mds_session *s=
ession,
 =09case CEPH_SESSION_CLOSE:
 =09=09if (session->s_state =3D=3D CEPH_MDS_SESSION_RECONNECTING)
 =09=09=09pr_info("mds%d reconnect denied\n", session->s_mds);
+=09=09session->s_state =3D CEPH_MDS_SESSION_CLOSED;
 =09=09cleanup_session_requests(mdsc, session);
 =09=09remove_session_caps(session);
 =09=09wake =3D 2; /* for good measure */
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 5cd131b41d84..9fb2063b0600 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -151,7 +151,8 @@ enum {
 =09CEPH_MDS_SESSION_RESTARTING =3D 5,
 =09CEPH_MDS_SESSION_RECONNECTING =3D 6,
 =09CEPH_MDS_SESSION_CLOSING =3D 7,
-=09CEPH_MDS_SESSION_REJECTED =3D 8,
+=09CEPH_MDS_SESSION_CLOSED =3D 8,
+=09CEPH_MDS_SESSION_REJECTED =3D 9,
 };
=20
 struct ceph_mds_session {
--=20
2.21.0

