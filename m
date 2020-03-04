Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 747201796C5
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Mar 2020 18:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgCDRdS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 4 Mar 2020 12:33:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23822 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729892AbgCDRdS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Mar 2020 12:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583343197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yeBsV8LJtSSIt+RFy8QtLiVUUyK75XKJJQnKstonn14=;
        b=Pa5nbe8vM2w61e+1uEJiHKasA+lGlWmEuMmWPKk7E3WAQI+ip3/e+PXwPIDsolibvFQn0p
        tLi1UNIdfsYSZlfJzP6O7sWuYKFkt7X6IKVSMGfG7IlGFlgKz7ICZ7gNPLsKtrsI59IBwZ
        T+0uUJ1PqK5YqKHWaxyAj88aWTEZwYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-T7lkLKeSM-C-FrCZKyjwNw-1; Wed, 04 Mar 2020 12:33:15 -0500
X-MC-Unique: T7lkLKeSM-C-FrCZKyjwNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14E6D184C83E;
        Wed,  4 Mar 2020 17:33:15 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-198.pek2.redhat.com [10.72.12.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33A105C1D4;
        Wed,  4 Mar 2020 17:33:12 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v4 5/6] ceph: update i_requested_max_size only when sending cap msg to auth mds
Date:   Thu,  5 Mar 2020 01:32:57 +0800
Message-Id: <20200304173258.48377-6-zyan@redhat.com>
In-Reply-To: <20200304173258.48377-1-zyan@redhat.com>
References: <20200304173258.48377-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Non-auth mds can't do anything to 'update max' cap message.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1b6e6fd98169..0408749ced2d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1359,7 +1359,8 @@ static int __send_cap(struct ceph_mds_client *mdsc,=
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

