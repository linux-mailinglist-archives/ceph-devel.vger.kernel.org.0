Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729DA11A07D
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Dec 2019 02:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfLKBaG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Dec 2019 20:30:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726364AbfLKBaG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 20:30:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576027805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jc7FR+BWkNp0UgrwKmVEXQdjRYmNiW65RMGYnoOUtVk=;
        b=FTcpGFRuWXoBhVxWru+PCTv5bFNkILsqAv1MgTkdxuoFN6lUGd3tS0c6s6X9ULKIu+0yeK
        +1MhlYS7ApfooICZ9ZIluP09FceJ1hwHirc1UcdeBjMyY7S5L7yiXviFa5DKXKkn5NWAOY
        mr82PcG5vm2J/AxTEiPFh5x5ZTZC0+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-6JesZOBhO6u60C1GN96jdw-1; Tue, 10 Dec 2019 20:30:02 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDE15100550E;
        Wed, 11 Dec 2019 01:30:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C278C60638;
        Wed, 11 Dec 2019 01:29:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: check availability of mds cluster on mount after wait timeout
Date:   Tue, 10 Dec 2019 20:29:40 -0500
Message-Id: <20191211012940.18128-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 6JesZOBhO6u60C1GN96jdw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If all the MDS daemons are down for some reasons and for the first
time to do the mount, it will fail with IO error after the mount
request timed out.

Or if the cluster becomes laggy suddenly, and just before the kclient
getting the new mdsmap and the mount request is fired off, it also
will fail with IO error.

This will add some useful hint message by checking the cluster state
before the fail the mount operation.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V3:
- Rebase to the new mount API version.

 fs/ceph/mds_client.c | 3 +--
 fs/ceph/super.c      | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 7d3ec051f179..bf507120659e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2576,8 +2576,7 @@ static void __do_request(struct ceph_mds_client *mdsc=
,
 =09=09if (!(mdsc->fsc->mount_options->flags &
 =09=09      CEPH_MOUNT_OPT_MOUNTWAIT) &&
 =09=09    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
-=09=09=09err =3D -ENOENT;
-=09=09=09pr_info("probably no mds server is up\n");
+=09=09=09err =3D -EHOSTUNREACH;
 =09=09=09goto finish;
 =09=09}
 =09}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9c9a7c68eea3..6f33a265ccf1 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1068,6 +1068,11 @@ static int ceph_get_tree(struct fs_context *fc)
 =09return 0;
=20
 out_splat:
+=09if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
+=09=09pr_info("No mds server is up or the cluster is laggy\n");
+=09=09err =3D -EHOSTUNREACH;
+=09}
+
 =09ceph_mdsc_close_sessions(fsc->mdsc);
 =09deactivate_locked_super(sb);
 =09goto out_final;
--=20
2.21.0

