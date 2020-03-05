Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6642217A52A
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCEMV2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:21:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40127 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725880AbgCEMV1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 07:21:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583410887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+CR70fzTF1bNFXcEXr/l2Q3GG7LD9ah6N/C+s762M1c=;
        b=MkbTvpVWKGW0xKeP479XNMCTs0V3bpTwDRvpqLmLSRaeeUb2qtcMEi6XiGeuW+rcTzPEZc
        CI+Air1OHqUuvQ5GmNhd2BH96h7TN/qoXKTNpBVaAb/gjCs2ncgirGQ0+/jyzf+Onde3zp
        TpZ/pZtcIDlYqfPDwv8e5vAk0Px8zSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-RzD7L95wOLmBsXNrhS2XEw-1; Thu, 05 Mar 2020 07:21:25 -0500
X-MC-Unique: RzD7L95wOLmBsXNrhS2XEw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB93718A6ED1;
        Thu,  5 Mar 2020 12:21:24 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F3828D551;
        Thu,  5 Mar 2020 12:21:22 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v5 5/7] ceph: update i_requested_max_size only when sending cap msg to auth mds
Date:   Thu,  5 Mar 2020 20:21:03 +0800
Message-Id: <20200305122105.69184-6-zyan@redhat.com>
In-Reply-To: <20200305122105.69184-1-zyan@redhat.com>
References: <20200305122105.69184-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index a94d2807f1f3..418e6329da73 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1355,7 +1355,8 @@ static int __send_cap(struct ceph_mds_client *mdsc,=
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

