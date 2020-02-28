Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 191B91736B1
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 12:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgB1L4L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 06:56:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60336 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbgB1L4L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Feb 2020 06:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582890970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kSBBIPCcG3gcPSjDC3HoCJJNenmweyDywJ/zw+y6cwY=;
        b=dYN+Yj3kxI3ITCB10Yu5/BMt5Qtpqai1uCA2B/mI7YRCaRchUDTqxtesQ/8lYfpVKC40h6
        vA7eqP8WjxrdxM1L0e+ujODDVD1TRdw5XruvcZ5DvgeIyqmoO7QUPKiYXhteQnu5J2CX4M
        IZuwvp7ivFFEy9GtygtFtFWaiJjkd0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-323-Sm3-Wk2IOxKs2eCebOU4Og-1; Fri, 28 Feb 2020 06:56:08 -0500
X-MC-Unique: Sm3-Wk2IOxKs2eCebOU4Og-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77ACC801E67;
        Fri, 28 Feb 2020 11:56:07 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0C9C5C54A;
        Fri, 28 Feb 2020 11:56:05 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v3 5/6] ceph: update i_requested_max_size only when sending cap msg to auth mds
Date:   Fri, 28 Feb 2020 19:55:49 +0800
Message-Id: <20200228115550.6904-6-zyan@redhat.com>
In-Reply-To: <20200228115550.6904-1-zyan@redhat.com>
References: <20200228115550.6904-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

because non-auth mds can't do anything to 'update max' cap message.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 29f39058aca7..49f773247044 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1339,7 +1339,8 @@ static int __send_cap(struct ceph_mds_client *mdsc,=
 struct ceph_cap *cap,
 	arg.size =3D inode->i_size;
 	ci->i_reported_size =3D arg.size;
 	arg.max_size =3D ci->i_wanted_max_size;
-	ci->i_requested_max_size =3D arg.max_size;
+	if (cap =3D=3D ci->i_auth_cap)
+		ci->i_requested_max_size =3D arg.max_size;
=20
 	if (flushing & CEPH_CAP_XATTR_EXCL) {
 		old_blob =3D __ceph_build_xattrs_blob(ci);
--=20
2.21.1

