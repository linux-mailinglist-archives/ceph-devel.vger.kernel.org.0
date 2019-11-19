Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B148102524
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2019 14:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfKSNEz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Nov 2019 08:04:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24500 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725280AbfKSNEz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Nov 2019 08:04:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574168694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S7XqyXz8gZO+J7dZZNEjU7c637BUHhGfSdEebB72zqQ=;
        b=HJhxWFwxLOgyj7CQb1aGCAsdhbYTE27LW70QMrRZj62flxgzBIF3r87wHmGFaOYCuhiqtt
        XZMUSU6Ph/lrBp/GRk7s3fxRx3MhajmoBPprgtSwhoBocpKrThwzMnZZ1kkWkIDxlKVNfm
        2dQrPW6dZfN7GXMmCBwrHgQxLdwe24U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-JcnCsYicMketrbaKM-SHfw-1; Tue, 19 Nov 2019 08:04:53 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E60EB10957B2;
        Tue, 19 Nov 2019 13:04:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A713C5DF2B;
        Tue, 19 Nov 2019 13:04:46 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, zyan@redhat.com, pdonnell@redhat.com,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: check availability of mds cluster on mount after wait timeout
Date:   Tue, 19 Nov 2019 08:04:40 -0500
Message-Id: <20191119130440.19384-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: JcnCsYicMketrbaKM-SHfw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

If all the MDS daemons are down for some reasons, and immediately
just before the kclient getting the new mdsmap the mount request is
fired out, it will be the request wait will timeout with -EIO.

After this just check the mds cluster availability to give a friendly
hint to let the users check the MDS cluster status.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a5163296d9d9..82a929084671 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2712,6 +2712,9 @@ static int ceph_mdsc_wait_request(struct ceph_mds_cli=
ent *mdsc,
 =09if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
 =09=09err =3D le32_to_cpu(req->r_reply_info.head->result);
 =09} else if (err < 0) {
+=09=09if (!ceph_mdsmap_is_cluster_available(mdsc->mdsmap))
+=09=09=09pr_info("probably no mds server is up\n");
+
 =09=09dout("aborted request %lld with %d\n", req->r_tid, err);
=20
 =09=09/*
--=20
2.21.0

