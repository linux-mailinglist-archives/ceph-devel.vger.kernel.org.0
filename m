Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCF5109A8D
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 09:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfKZIwE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 03:52:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25214 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbfKZIwB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 03:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574758321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=C2wxLjpzfJQ4iUTfLEAlO+qnSI03eWvkFz6dCuTPSNw=;
        b=dTlLqA9ZpLpeE7eB0lQzW7LuKj90CgJzpopuRWrcRdQVoObtZwwfwpSyr37nisYG3fqEVk
        oph3kt3VwLH+5tHcXA2LsHXwQL7lh6X8bVdJQyqtPRAxSHOa6zCrVm8bXtGtvK9cI49j/q
        fLbozxClNG8rrP5YklERB9CrJUX7ykQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-rZ-Pat6YP2yHCJKXv_CzBA-1; Tue, 26 Nov 2019 03:51:58 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E2C72F2B;
        Tue, 26 Nov 2019 08:51:57 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB9F65D6BB;
        Tue, 26 Nov 2019 08:51:51 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: trigger the reclaim work once there has enough pending caps
Date:   Tue, 26 Nov 2019 03:51:14 -0500
Message-Id: <20191126085114.40326-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: rZ-Pat6YP2yHCJKXv_CzBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
so we may miss it and the reclaim work couldn't triggered as expected.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 08b70b5ee05e..547ffe16f91c 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mds=
c, int nr)
 =09if (!nr)
 =09=09return;
 =09val =3D atomic_add_return(nr, &mdsc->cap_reclaim_pending);
-=09if (!(val % CEPH_CAPS_PER_RELEASE)) {
+=09if (val / CEPH_CAPS_PER_RELEASE) {
 =09=09atomic_set(&mdsc->cap_reclaim_pending, 0);
 =09=09ceph_queue_cap_reclaim_work(mdsc);
 =09}
--=20
2.21.0

