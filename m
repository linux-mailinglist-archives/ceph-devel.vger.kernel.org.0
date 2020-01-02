Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1433712E1D5
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Jan 2020 04:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgABDJy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jan 2020 22:09:54 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48538 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727509AbgABDJy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jan 2020 22:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577934591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pSNAUHUZOHDoHbfTTtdfOLn4BRJdtlHnNA8hXYAgQ8k=;
        b=LE9rD5eG74wTmwcAx9J2oO0phfn5CdQbx5jDD6QoExKnBsMG3Lpb5Z/szbb9n3T101uZX5
        mZGBgA+HkT1Guuh0690CiUidvix6L2wn6raGmmW2eTIQ8Ph6gwBcW+2i8DDfOqD4i47SH9
        iBvigt8jjhKWzFLLnIh2jE+efF/7My8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-F_DCVUKGPKa7RrBsgfd4iA-1; Wed, 01 Jan 2020 22:09:49 -0500
X-MC-Unique: F_DCVUKGPKa7RrBsgfd4iA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 01241477;
        Thu,  2 Jan 2020 03:09:48 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-30.pek2.redhat.com [10.72.12.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 539EB67673;
        Thu,  2 Jan 2020 03:09:42 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: dout switches to hex format for the 'hash'
Date:   Wed,  1 Jan 2020 22:09:37 -0500
Message-Id: <20200102030937.59546-1-xiubli@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

It's hard to read especially when it is:

ceph:  __choose_mds 00000000b7bc9c15 is_hash=3D1 (-271041095) mode 0

At the same time switch to __func__ to get rid of the check patch
warning.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index e209eb9f2efb..b2f3d62f6a78 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -911,7 +911,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 	if (req->r_resend_mds >=3D 0 &&
 	    (__have_session(mdsc, req->r_resend_mds) ||
 	     ceph_mdsmap_get_state(mdsc->mdsmap, req->r_resend_mds) > 0)) {
-		dout("choose_mds using resend_mds mds%d\n",
+		dout("%s using resend_mds mds%d\n", __func__,
 		     req->r_resend_mds);
 		return req->r_resend_mds;
 	}
@@ -929,7 +929,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 			rcu_read_lock();
 			inode =3D get_nonsnap_parent(req->r_dentry);
 			rcu_read_unlock();
-			dout("__choose_mds using snapdir's parent %p\n", inode);
+			dout("%s using snapdir's parent %p\n", __func__, inode);
 		}
 	} else if (req->r_dentry) {
 		/* ignore race with rename; old or new d_parent is okay */
@@ -949,7 +949,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 			/* direct snapped/virtual snapdir requests
 			 * based on parent dir inode */
 			inode =3D get_nonsnap_parent(parent);
-			dout("__choose_mds using nonsnap parent %p\n", inode);
+			dout("%s using nonsnap parent %p\n", __func__, inode);
 		} else {
 			/* dentry target */
 			inode =3D d_inode(req->r_dentry);
@@ -965,8 +965,8 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
 		rcu_read_unlock();
 	}
=20
-	dout("__choose_mds %p is_hash=3D%d (%d) mode %d\n", inode, (int)is_hash=
,
-	     (int)hash, mode);
+	dout("%s %p is_hash=3D%d (0x%x) mode %d\n", __func__, inode, (int)is_ha=
sh,
+	     hash, mode);
 	if (!inode)
 		goto random;
 	ci =3D ceph_inode(inode);
@@ -984,11 +984,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc=
,
 				get_random_bytes(&r, 1);
 				r %=3D frag.ndist;
 				mds =3D frag.dist[r];
-				dout("choose_mds %p %llx.%llx "
-				     "frag %u mds%d (%d/%d)\n",
-				     inode, ceph_vinop(inode),
-				     frag.frag, mds,
-				     (int)r, frag.ndist);
+				dout("%s %p %llx.%llx frag %u mds%d (%d/%d)\n",
+				     __func__, inode, ceph_vinop(inode),
+				     frag.frag, mds, (int)r, frag.ndist);
 				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
 				    CEPH_MDS_STATE_ACTIVE &&
 				    !ceph_mdsmap_is_laggy(mdsc->mdsmap, mds))
@@ -1001,9 +999,9 @@ static int __choose_mds(struct ceph_mds_client *mdsc=
,
 			if (frag.mds >=3D 0) {
 				/* choose auth mds */
 				mds =3D frag.mds;
-				dout("choose_mds %p %llx.%llx "
-				     "frag %u mds%d (auth)\n",
-				     inode, ceph_vinop(inode), frag.frag, mds);
+				dout("%s %p %llx.%llx frag %u mds%d (auth)\n",
+				     __func__, inode, ceph_vinop(inode),
+				     frag.frag, mds);
 				if (ceph_mdsmap_get_state(mdsc->mdsmap, mds) >=3D
 				    CEPH_MDS_STATE_ACTIVE) {
 					if (mode =3D=3D USE_ANY_MDS &&
@@ -1028,7 +1026,7 @@ static int __choose_mds(struct ceph_mds_client *mds=
c,
 		goto random;
 	}
 	mds =3D cap->session->s_mds;
-	dout("choose_mds %p %llx.%llx mds%d (%scap %p)\n",
+	dout("%s %p %llx.%llx mds%d (%scap %p)\n", __func__,
 	     inode, ceph_vinop(inode), mds,
 	     cap =3D=3D ci->i_auth_cap ? "auth " : "", cap);
 	spin_unlock(&ci->i_ceph_lock);
@@ -1043,7 +1041,7 @@ static int __choose_mds(struct ceph_mds_client *mds=
c,
 		*random =3D true;
=20
 	mds =3D ceph_mdsmap_get_random_mds(mdsc->mdsmap);
-	dout("choose_mds chose random mds%d\n", mds);
+	dout("%s chose random mds%d\n", __func__, mds);
 	return mds;
 }
=20
--=20
2.21.0

