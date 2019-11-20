Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8761035F9
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 09:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfKTI3X (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 03:29:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55227 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726038AbfKTI3W (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Nov 2019 03:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574238561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dyxk4x5q2SY+ocukli6qC9/tLSscgKWf/oX8Rxgu6x4=;
        b=iJFnLXBBjAjZpSKWX7bSeCr2pzoGnA9L4xryjNJeTIiKM7JK4dNzVs0OqqlySMEvMxocK8
        OuROrogQYPy4I0jI14LfMng/8IdKIaezJINqgNUsJMKg8MyEw9pJf2yqgAYK34Eydwb3k1
        +AQ3SivW8oPPIkfVNAjAqa1L6l2/4aM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-K5HvO55MPkKvodHE_88qhw-1; Wed, 20 Nov 2019 03:29:19 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 541E4107ACC4;
        Wed, 20 Nov 2019 08:29:18 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1BAF67E52;
        Wed, 20 Nov 2019 08:29:15 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH 2/3] mdsmap: fix mdsmap cluster available check based on laggy number
Date:   Wed, 20 Nov 2019 03:29:01 -0500
Message-Id: <20191120082902.38666-3-xiubli@redhat.com>
In-Reply-To: <20191120082902.38666-1-xiubli@redhat.com>
References: <20191120082902.38666-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: K5HvO55MPkKvodHE_88qhw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

In case the max_mds > 1 in MDS cluster and there is no any standby
MDS and all the max_mds MDSs are in up:active state, if one of the
up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
Then the mount will fail without considering other healthy MDSs.

Only when all the MDSs in the cluster are laggy will treat the
cluster as not be available.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mdsmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 471bac335fae..8b4f93e5b468 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -396,7 +396,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsma=
p *m)
 =09=09return false;
 =09if (m->m_damaged)
 =09=09return false;
-=09if (m->m_num_laggy > 0)
+=09if (m->m_num_laggy =3D=3D m->m_num_mds)
 =09=09return false;
 =09for (i =3D 0; i < m->m_num_mds; i++) {
 =09=09if (m->m_info[i].state =3D=3D CEPH_MDS_STATE_ACTIVE)
--=20
2.21.0

