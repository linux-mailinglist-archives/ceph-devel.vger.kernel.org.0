Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4091736B2
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 12:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgB1L4Q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 06:56:16 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51869 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgB1L4Q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 06:56:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582890975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DPJvPIuYIol3U7Gd+gFzJM5jAe3kfjGmfYJSZVYcyZw=;
        b=ZIvjgzwbvDSnrPN1GgSwMtQPgHBqmnXRaAUHeG3CXzJpbRzoTFEL2F9JuuFg9p+sElSwTd
        Pc9scxLTrOLmdx3ElZOHawX3bDh8lraWg4sm5oA0GteYS0Zx6FsrxtGmgOrSMH4vQqRxhx
        BRuPnaOQpUOaiFveuc+1yitdpJ5kxIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-dtsZl6ACMaq1iKNho7FsIQ-1; Fri, 28 Feb 2020 06:56:11 -0500
X-MC-Unique: dtsZl6ACMaq1iKNho7FsIQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7936C13F6;
        Fri, 28 Feb 2020 11:56:10 +0000 (UTC)
Received: from zhyan-laptop.redhat.com (ovpn-12-212.pek2.redhat.com [10.72.12.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1857E5C54A;
        Fri, 28 Feb 2020 11:56:07 +0000 (UTC)
From:   "Yan, Zheng" <zyan@redhat.com>
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, "Yan, Zheng" <zyan@redhat.com>
Subject: [PATCH v3 6/6] ceph: check all mds' caps after page writeback
Date:   Fri, 28 Feb 2020 19:55:50 +0800
Message-Id: <20200228115550.6904-7-zyan@redhat.com>
In-Reply-To: <20200228115550.6904-1-zyan@redhat.com>
References: <20200228115550.6904-1-zyan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

If an inode has caps from multiple mds, following case can happen.

- non-auth mds revokes Fsc. Fcb is used, so page writeback is queued.
- when writeback finishes, ceph_check_caps() is called with auth only
  flag. ceph_check_caps() invalidates pagecache, but skip checking any
  non-auth caps.

Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
---
 fs/ceph/caps.c  | 2 +-
 fs/ceph/inode.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 49f773247044..9b3d5816c109 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3018,7 +3018,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_i=
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
index 5a8fa8a2d3cf..896d30820035 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1974,7 +1974,7 @@ void __ceph_do_pending_vmtruncate(struct inode *ino=
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

