Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF817A52B
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgCEMVd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:21:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35450 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725880AbgCEMVd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 07:21:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583410892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7M10/JWu4v02HEuGdDMNJD4tXi+mL0vNHysWqRLlEQ=;
        b=Oa+Bd1a3/CSjS06ypBDINtg8RMSzeXmWzhiHkPPbNfe2x8f0Gb3PaYqpj3HnZuQ2ff1SvU
        ufzuwuDTQXG8v9K6flG8Nln7T2AJrRQ32ePWkeEMMU2c+D1tHva1QxPgxLddU43Oqccc/b
        Rs0/QZQGX3qUHq8ZCGh92hL/h4ZMTxY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-V1UhJeUAM3mr_sqJwJ8rtg-1; Thu, 05 Mar 2020 07:21:30 -0500
X-MC-Unique: V1UhJeUAM3mr_sqJwJ8rtg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6F8F10CE781;
        Thu,  5 Mar 2020 12:21:29 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79BEA8D551;
        Thu,  5 Mar 2020 12:21:25 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v5 6/7] ceph: check all mds' caps after page writeback
Date:   Thu,  5 Mar 2020 20:21:04 +0800
Message-Id: <20200305122105.69184-7-zyan@redhat.com>
In-Reply-To: <20200305122105.69184-1-zyan@redhat.com>
References: <20200305122105.69184-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If an inode has caps from multiple mds's, the following can happen:

- non-auth mds revokes Fsc. Fcb is used, so page writeback is queued.
- when writeback finishes, ceph_check_caps() is called with auth only
  flag. ceph_check_caps() invalidates pagecache, but skips checking any
  non-auth caps.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 418e6329da73..622568cd6d8a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3048,7 +3048,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_i=
nfo *ci, int nr,
 	spin_unlock(&ci->i_ceph_lock);
=20
 	if (last) {
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
+		ceph_check_caps(ci, 0, NULL);
 	} else if (flush_snaps) {
 		ceph_flush_snaps(ci, NULL);
 	}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index c7ff9f7067f6..ee40ba7e0e77 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1984,7 +1984,7 @@ void __ceph_do_pending_vmtruncate(struct inode *ino=
de)
 	mutex_unlock(&ci->i_truncate_mutex);
=20
 	if (wrbuffer_refs =3D=3D 0)
-		ceph_check_caps(ci, CHECK_CAPS_AUTHONLY, NULL);
+		ceph_check_caps(ci, 0, NULL);
=20
 	wake_up_all(&ci->i_cap_wq);
 }
--=20
2.21.1

