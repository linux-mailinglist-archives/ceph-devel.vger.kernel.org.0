Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BA212F321
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Jan 2020 04:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbgACDAI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Jan 2020 22:00:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727304AbgACDAH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Jan 2020 22:00:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578020406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FO2eLXawl5MxGy8dO1RmlyO6owcKBB/ZFQvIFiD6ZCI=;
        b=KYPktpjaC40XHoyVPxM7TMkKbmufOGoE7d1QkdZXIgcHNp1FuUGqXqle1aEhPTupVkIssP
        JbjotT5jYesAY3EkQFNyxTOZS4KnyKI8VmHm9GOs83F0GDi44A5sZC1u/qtNGH36/E1dPF
        ozMY+738aIJ97fYIw7Ompzu9SCleQ8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-h34vPoVJNeG3wVK4gquuAA-1; Thu, 02 Jan 2020 22:00:01 -0500
X-MC-Unique: h34vPoVJNeG3wVK4gquuAA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B77E5DB20;
        Fri,  3 Jan 2020 03:00:00 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9CA364452;
        Fri,  3 Jan 2020 02:59:55 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: allocate the accurate extra bytes for the session features
Date:   Thu,  2 Jan 2020 21:59:50 -0500
Message-Id: <20200103025950.27659-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The totally bytes maybe potentially larger than 8.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index ad9573b7e115..aa49e8557599 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1067,20 +1067,20 @@ static struct ceph_msg *create_session_msg(u32 op=
, u64 seq)
 	return msg;
 }
=20
+static const unsigned char feature_bits[] =3D CEPHFS_FEATURES_CLIENT_SUP=
PORTED;
 static void encode_supported_features(void **p, void *end)
 {
-	static const unsigned char bits[] =3D CEPHFS_FEATURES_CLIENT_SUPPORTED;
-	static const size_t count =3D ARRAY_SIZE(bits);
+	static const size_t count =3D ARRAY_SIZE(feature_bits);
=20
 	if (count > 0) {
 		size_t i;
-		size_t size =3D ((size_t)bits[count - 1] + 64) / 64 * 8;
+		size_t size =3D ((size_t)feature_bits[count - 1] + 64) / 64 * 8;
=20
 		BUG_ON(*p + 4 + size > end);
 		ceph_encode_32(p, size);
 		memset(*p, 0, size);
 		for (i =3D 0; i < count; i++)
-			((unsigned char*)(*p))[i / 8] |=3D 1 << (bits[i] % 8);
+			((unsigned char*)(*p))[i / 8] |=3D 1 << (feature_bits[i] % 8);
 		*p +=3D size;
 	} else {
 		BUG_ON(*p + 4 > end);
@@ -1101,6 +1101,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	int metadata_key_count =3D 0;
 	struct ceph_options *opt =3D mdsc->fsc->client->options;
 	struct ceph_mount_options *fsopt =3D mdsc->fsc->mount_options;
+	size_t size, count;
 	void *p, *end;
=20
 	const char* metadata[][2] =3D {
@@ -1118,8 +1119,13 @@ static struct ceph_msg *create_session_open_msg(st=
ruct ceph_mds_client *mdsc, u6
 			strlen(metadata[i][1]);
 		metadata_key_count++;
 	}
+
 	/* supported feature */
-	extra_bytes +=3D 4 + 8;
+	size =3D 0;
+	count =3D ARRAY_SIZE(feature_bits);
+	if (count > 0)
+		size =3D ((size_t)feature_bits[count - 1] + 64) / 64 * 8;
+	extra_bytes +=3D 4 + size;
=20
 	/* Allocate the message */
 	msg =3D ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
@@ -1139,7 +1145,7 @@ static struct ceph_msg *create_session_open_msg(str=
uct ceph_mds_client *mdsc, u6
 	 * Serialize client metadata into waiting buffer space, using
 	 * the format that userspace expects for map<string, string>
 	 *
-	 * ClientSession messages with metadata are v2
+	 * ClientSession messages with metadata are v3
 	 */
 	msg->hdr.version =3D cpu_to_le16(3);
 	msg->hdr.compat_version =3D cpu_to_le16(1);
--=20
2.21.0

