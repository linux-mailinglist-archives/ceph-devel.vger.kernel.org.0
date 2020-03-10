Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3C317F659
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 12:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgCJLeg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 07:34:36 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:25800 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726211AbgCJLef (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Mar 2020 07:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583840075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80phVWs2HK+HrFyyvtT2NcltG906Tx1yse0pWekepwg=;
        b=YHQuOiOvzunvEnx5EJED9UhMupOZagNuLWGR/UJP/F7Vkan03LIYf95LxEMLi3/k7vlFvM
        jaKm6GuW5RQgJiZoddn6+OYbm6Rb5gEtXK0t6E2LmOZdWDwLXGViZWqEjwd45QO9mSk38E
        odr6jGwOTHMIemyNgYQsVjrYYAbWUpA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-230-VRVz7-tIPhSlG3_nEC6zdg-1; Tue, 10 Mar 2020 07:34:33 -0400
X-MC-Unique: VRVz7-tIPhSlG3_nEC6zdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79077DBA5;
        Tue, 10 Mar 2020 11:34:32 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-165.pek2.redhat.com [10.72.12.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6686B5D9C5;
        Tue, 10 Mar 2020 11:34:30 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 2/4] ceph: request new max size only when there is auth cap
Date:   Tue, 10 Mar 2020 19:34:19 +0800
Message-Id: <20200310113421.174873-3-zyan@redhat.com>
In-Reply-To: <20200310113421.174873-1-zyan@redhat.com>
References: <20200310113421.174873-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When there is no auth cap, check_max_size() can't do anything, may
cause infinite loop inside ceph_get_caps().

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 804f4c65251a..295b61201d85 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2582,7 +2582,7 @@ static int try_get_cap_refs(struct inode *inode, in=
t need, int want,
 			dout("get_cap_refs %p endoff %llu > maxsize %llu\n",
 			     inode, endoff, ci->i_max_size);
 			if (endoff > ci->i_requested_max_size)
-				ret =3D -EFBIG;
+				ret =3D ci->i_auth_cap ? -EFBIG : -ESTALE;
 			goto out_unlock;
 		}
 		/*
--=20
2.21.1

