Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735D6109E03
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Nov 2019 13:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfKZMcs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Nov 2019 07:32:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35051 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727408AbfKZMcs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Nov 2019 07:32:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574771567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/kxWsW3I6KZWYv+2CbmMDgEXO45aQkMpEFUD3vyg480=;
        b=ffGpo63YafO5n9ap4/gbXKOcKukuKU97pnIe4lzy1ZVExXtA050fBtN/gUe9f1CXK55nuS
        oN9EaGDumRSI7dVUhrwnVtAQEQxJKysJKVCIaycIM+gHyKZ3X2qV+/bxdV2iKKqCjCcONs
        nrFNlWTZs5kLptM7PsdjEM0fVC544bU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-Ziy-exaGObSzHGF28VyPFg-1; Tue, 26 Nov 2019 07:32:45 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFEE180183C;
        Tue, 26 Nov 2019 12:32:44 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-66.pek2.redhat.com [10.72.12.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D406A5D6C3;
        Tue, 26 Nov 2019 12:32:38 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, zyan@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v2] ceph: trigger the reclaim work once there has enough pending caps
Date:   Tue, 26 Nov 2019 07:32:22 -0500
Message-Id: <20191126123222.29510-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: Ziy-exaGObSzHGF28VyPFg-1
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

V2:
- use a more graceful test.

 fs/ceph/mds_client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2c92a1452876..109ec7e2ee7b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *mds=
c, int nr)
 =09if (!nr)
 =09=09return;
 =09val =3D atomic_add_return(nr, &mdsc->cap_reclaim_pending);
-=09if (!(val % CEPH_CAPS_PER_RELEASE)) {
+=09if ((val % CEPH_CAPS_PER_RELEASE) < nr) {
 =09=09atomic_set(&mdsc->cap_reclaim_pending, 0);
 =09=09ceph_queue_cap_reclaim_work(mdsc);
 =09}
--=20
2.21.0

