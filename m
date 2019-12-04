Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE2431122E2
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 07:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbfLDG1h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Dec 2019 01:27:37 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41177 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725791AbfLDG1h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Dec 2019 01:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575440855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KL/hHotGhDfBgXSOZht7JmiGm/YfJXcCgUd/v9YkU4E=;
        b=HXOxrsjf5WTWWeajmcLWw0nZQ4c5aQUOC/MwY/0AjbO8WgCuSGT3P3IIf5jNbs87PQa//e
        sKHxocdCuR7f+e67Jd9qQqao60ziBTKb1vAsK38yhtalzi4p3TBSdfkcExnWmPyyIzN0u1
        1tW+6arpF7VI9+kFdb7Mu+gsxCrJhKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-gqWZVB6WNemd3T4LVTutNw-1; Wed, 04 Dec 2019 01:27:34 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56DF4183B700;
        Wed,  4 Dec 2019 06:27:33 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65044600C8;
        Wed,  4 Dec 2019 06:27:28 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: fix possible long time wait during umount
Date:   Wed,  4 Dec 2019 01:27:18 -0500
Message-Id: <20191204062718.56105-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: gqWZVB6WNemd3T4LVTutNw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

During umount, if there has no any unsafe request in the mdsc and
some requests still in-flight and not got reply yet, and if the
rest requets are all safe ones, after that even all of them in mdsc
are unregistered, the umount must wait until after mount_timeout
seconds anyway.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 163b470f3000..39f4d8501df5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2877,6 +2877,10 @@ static void handle_reply(struct ceph_mds_session *se=
ssion, struct ceph_msg *msg)
 =09=09set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
 =09=09__unregister_request(mdsc, req);
=20
+=09=09/* last request during umount? */
+=09=09if (mdsc->stopping && !__get_oldest_req(mdsc))
+=09=09=09complete_all(&mdsc->safe_umount_waiters);
+
 =09=09if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
 =09=09=09/*
 =09=09=09 * We already handled the unsafe response, now do the
@@ -2887,9 +2891,6 @@ static void handle_reply(struct ceph_mds_session *ses=
sion, struct ceph_msg *msg)
 =09=09=09 */
 =09=09=09dout("got safe reply %llu, mds%d\n", tid, mds);
=20
-=09=09=09/* last unsafe request during umount? */
-=09=09=09if (mdsc->stopping && !__get_oldest_req(mdsc))
-=09=09=09=09complete_all(&mdsc->safe_umount_waiters);
 =09=09=09mutex_unlock(&mdsc->mutex);
 =09=09=09goto out;
 =09=09}
--=20
2.21.0

