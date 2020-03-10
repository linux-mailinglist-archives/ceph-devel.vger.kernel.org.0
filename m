Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C11C17F65A
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Mar 2020 12:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgCJLei (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Mar 2020 07:34:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52799 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726283AbgCJLei (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Mar 2020 07:34:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583840077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cQGRXGNVhL/4lQE6KaDr+NPkR47gBgs+0PVmahX+COg=;
        b=fI04R4j5K/s7Z/P8P7B6c7F5gaflECPqeNfBGQ38giDXr3HzfLzRwQTYDX3pm7fmC/cZUV
        vUQ69aHToBUGe9USAQDh16E5kJK92x4PTT9u4qjnawoceGnDYjKF3qMSXRhnwnFPokWy1e
        judt1QQCG6sGYt+pZuAoeHydD3GI5b0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-FbqLOOlAPuaDYBBH51WOuQ-1; Tue, 10 Mar 2020 07:34:35 -0400
X-MC-Unique: FbqLOOlAPuaDYBBH51WOuQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E63AADBA3;
        Tue, 10 Mar 2020 11:34:34 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-165.pek2.redhat.com [10.72.12.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 46A495D9C5;
        Tue, 10 Mar 2020 11:34:32 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH 3/4] ceph: don't skip updating wanted caps when cap is stale
Date:   Tue, 10 Mar 2020 19:34:20 +0800
Message-Id: <20200310113421.174873-4-zyan@redhat.com>
In-Reply-To: <20200310113421.174873-1-zyan@redhat.com>
References: <20200310113421.174873-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

1. try_get_cap_refs() fails to get caps and finds that mds_wanted
   does not include what it wants. It return -ESTALE.
2. ceph_get_caps() calls ceph_renew_caps(). ceph_renew_caps() finds
   that inode has cap, so it calls ceph_check_caps().
3. ceph_check_caps() finds that issued caps (without checking if it's
   stale) already includes caps wanted by open file, so it skips
   updating wanted caps.

Above events can cause infinite loop inside ceph_get_caps()

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 295b61201d85..f63db3cb9c4f 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2008,8 +2008,12 @@ void ceph_check_caps(struct ceph_inode_info *ci, i=
nt flags,
 		}
=20
 		/* want more caps from mds? */
-		if (want & ~(cap->mds_wanted | cap->issued))
-			goto ack;
+		if (want & ~cap->mds_wanted) {
+			if (want & ~(cap->mds_wanted | cap->issued))
+				goto ack;
+			if (!__cap_is_valid(cap))
+				goto ack;
+		}
=20
 		/* things we might delay */
 		if ((cap->issued & ~retain) =3D=3D 0)
--=20
2.21.1

