Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76AC16F5CF
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Feb 2020 03:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730172AbgBZCve (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Feb 2020 21:51:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36043 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730170AbgBZCvd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Feb 2020 21:51:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582685492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pgn4ofpE9wLIFk9/mHDza87x5AQbyQlFBwDVgRmiFXQ=;
        b=HoifNaCvhxj9Iug2Z30lMZmNARET/4YkeJBGrG0T3ExPnwA5o9LZVmpR+rIhNatqWljpJG
        9k1IHPPsQqcSFG2W2aLf+3bcd3JDUMiVaJNm/kutbbRT8wsZBIs+h2sQ7fdkCKb/L6hyJX
        xa6NsRiEVmjGJ80DNRCWcaTUYThD3UY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-gtku5HK-NKSC4klajntH3g-1; Tue, 25 Feb 2020 21:51:26 -0500
X-MC-Unique: gtku5HK-NKSC4klajntH3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 786CB107ACCA;
        Wed, 26 Feb 2020 02:51:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-186.pek2.redhat.com [10.72.13.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C58599079D;
        Wed, 26 Feb 2020 02:51:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v3] ceph: show more detail logs during mount
Date:   Tue, 25 Feb 2020 21:51:12 -0500
Message-Id: <20200226025112.3839-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Print the logs in error level to give a helpful hint to make it
more user-friendly to do debug.

URL: https://tracker.ceph.com/issues/44215
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index c7f150686a53..0768e1bbd22e 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -905,8 +905,11 @@ static struct dentry *ceph_real_mount(struct ceph_fs=
_client *fsc,
 				     fsc->mount_options->server_path + 1 : "";
=20
 		err =3D __ceph_open_session(fsc->client, started);
-		if (err < 0)
+		if (err < 0) {
+			errorfc(fc, "mount joining the ceph cluster fail %d",
+				err);
 			goto out;
+		}
=20
 		/* setup fscache */
 		if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
@@ -922,6 +925,8 @@ static struct dentry *ceph_real_mount(struct ceph_fs_=
client *fsc,
 		root =3D open_root_dentry(fsc, path, started);
 		if (IS_ERR(root)) {
 			err =3D PTR_ERR(root);
+			errorfc(fc, "mount opening the root directory fail %d",
+				err);
 			goto out;
 		}
 		fsc->sb->s_root =3D dget(root);
@@ -1079,7 +1084,7 @@ static int ceph_get_tree(struct fs_context *fc)
=20
 out_splat:
 	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
-		pr_info("No mds server is up or the cluster is laggy\n");
+		errorfc(fc, "No mds server is up or the cluster is laggy");
 		err =3D -EHOSTUNREACH;
 	}
=20
--=20
2.21.0

