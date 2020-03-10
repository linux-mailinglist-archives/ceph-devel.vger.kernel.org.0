Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37B3217F65B
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 12:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgCJLel (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 07:34:41 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57193 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726205AbgCJLek (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 07:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583840080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVk5a9TiK5PWniqGB7ZrjMQ0UJfZTlT7mK21+dvLRTs=;
        b=B4JTEmOAWKtLnCKnSmXcjOpxNZYfp6QICJfAm8ciypO1E499sepNKE715fso9QhAI/44jx
        Ry4AlpQc0y+/QCklBtRMq0Ll6M/ZiVKQMw+Uj3BkjUVFHX1FNgoinYbwBCYChl5BiL+r0C
        oqGLJKyeef/0hjaCNIGA9ellHo/eC5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-pV71SgLoMUKjp6lw6-O0Ug-1; Tue, 10 Mar 2020 07:34:38 -0400
X-MC-Unique: pV71SgLoMUKjp6lw6-O0Ug-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67138DBA3;
        Tue, 10 Mar 2020 11:34:37 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-165.pek2.redhat.com [10.72.12.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B61BE5D9C5;
        Tue, 10 Mar 2020 11:34:35 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 4/4] ceph: wait for async creating inode before requesting new max size
Date:   Tue, 10 Mar 2020 19:34:21 +0800
Message-Id: <20200310113421.174873-5-zyan@redhat.com>
In-Reply-To: <20200310113421.174873-1-zyan@redhat.com>
References: <20200310113421.174873-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

ceph_check_caps() can't request new max size for async creating inode.
This may make ceph_get_caps() loop busily until getting reply of the
async create.

This patch also waits for async creating inode before calling
ceph_renew_caps()

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f63db3cb9c4f..14bedf2c16cd 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2832,6 +2832,11 @@ int ceph_get_caps(struct file *filp, int need, int=
 want,
 		}
=20
 		if (ret < 0) {
+			if (ret =3D=3D -EFBIG || ret =3D=3D -ESTALE) {
+				int ret2 =3D ceph_wait_on_async_create(inode);
+				if (ret2 < 0)
+					return ret2;
+			}
 			if (ret =3D=3D -EFBIG) {
 				check_max_size(inode, endoff);
 				continue;
--=20
2.21.1

