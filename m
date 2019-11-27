Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2129B10ABE1
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Nov 2019 09:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbfK0IfX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Nov 2019 03:35:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57318 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbfK0IfX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Nov 2019 03:35:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574843722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OZh87OVjmy4fNKisbX7Exrrk3k6LM+pQFRRnXYVs83w=;
        b=Vx2yWA1Mv+NzizH0gh0sEaA7cy6nGtPhG8m5MSfNYerHh555FWyaADQFAOnfe3jLtLlf9t
        o5MDfCFi3466fwvWHBFng2Ec1tQpXWxsS9vcabWFqFrkcX89bOYutlu+BeqXOwN8IvduXM
        nSSGBDA6Sq21xDANqjE1C9KP8wNtaGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-TToIAhZfNSmcqN8gVKUyrg-1; Wed, 27 Nov 2019 03:35:20 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85B738017D9;
        Wed, 27 Nov 2019 08:35:19 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8D975DA70;
        Wed, 27 Nov 2019 08:35:13 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: check availability of mds cluster on mount after wait timeout
Date:   Wed, 27 Nov 2019 03:35:08 -0500
Message-Id: <20191127083508.12102-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: TToIAhZfNSmcqN8gVKUyrg-1
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
 fs/ceph/mds_client.c | 4 ++--
 fs/ceph/super.c      | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 109ec7e2ee7b..163b470f3000 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2556,7 +2556,7 @@ static void __do_request(struct ceph_mds_client *mdsc=
,
 =09=09      CEPH_MOUNT_OPT_MOUNTWAIT) &&
 =09=09    !ceph_mdsmap_is_cluster_available(mdsc->mdsmap)) {
 =09=09=09err =3D -ENOENT;
-=09=09=09pr_info("probably no mds server is up\n");
+=09=09=09pr_info("No mds server is up or the cluster is laggy\n");
 =09=09=09goto finish;
 =09=09}
 =09}
@@ -2706,7 +2706,7 @@ static int ceph_mdsc_wait_request(struct ceph_mds_cli=
ent *mdsc,
 =09=09if (timeleft > 0)
 =09=09=09err =3D 0;
 =09=09else if (!timeleft)
-=09=09=09err =3D -EIO;  /* timed out */
+=09=09=09err =3D -ETIMEDOUT;  /* timed out */
 =09=09else
 =09=09=09err =3D timeleft;  /* killed */
 =09}
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index af2754b80b7c..39810677e601 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1137,6 +1137,10 @@ static struct dentry *ceph_mount(struct file_system_=
type *fs_type,
 =09return res;
=20
 out_splat:
+=09if (PTR_ERR(res) =3D=3D -ETIMEDOUT &&
+=09    !ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap))
+=09=09pr_info("No mds server is up or the cluster is laggy\n");
+
 =09ceph_mdsc_close_sessions(fsc->mdsc);
 =09deactivate_locked_super(sb);
 =09goto out_final;
--=20
2.21.0

