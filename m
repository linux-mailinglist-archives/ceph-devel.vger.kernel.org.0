Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AC12D3904
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Dec 2020 03:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgLICxz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Dec 2020 21:53:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33684 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726931AbgLICxz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Dec 2020 21:53:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607482349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DLfjBxaYu+0tzlcDsQQxd946NpNX6YQVuplK1/zu2F4=;
        b=Xyh4C2IFXwsLVRvQn934GJJut844TlDCpaNlbMaOK2yR5wJzGyhXSgNp+m0pzL8oBZMS9S
        AifR9f406YOoXcb0/JdqO8I6eqsqcqDCQWECYLntXxh6/fRhdzGxVpJaCoHwvIdElo7RpN
        yncclU3meO7fHPiXBCw+zJMxHcIRh50=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-_bvVci44Pz-xBnF-6hk4LQ-1; Tue, 08 Dec 2020 21:52:26 -0500
X-MC-Unique: _bvVci44Pz-xBnF-6hk4LQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE60C1005504;
        Wed,  9 Dec 2020 02:52:24 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCB4D6E406;
        Wed,  9 Dec 2020 02:52:22 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: set osdmap epoch for setxattr.
Date:   Wed,  9 Dec 2020 10:52:20 +0800
Message-Id: <20201209025220.2563698-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When setting the file/dir layout, it may need data pool info. So
in mds server, it needs to check the osdmap. At present, if mds
doesn't find the data pool specified, it will try to get the latest
osdmap. Now if pass the osd epoch for setxattr, the mds server can
only check this epoch of osdmap.

URL: https://tracker.ceph.com/issues/48504
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/mds_client.c         | 2 +-
 fs/ceph/xattr.c              | 3 +++
 include/linux/ceph/ceph_fs.h | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 4fab37d858ce..9b5e3975b3ad 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2533,7 +2533,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
 		goto out_free2;
 	}
 
-	msg->hdr.version = cpu_to_le16(2);
+	msg->hdr.version = cpu_to_le16(3);
 	msg->hdr.tid = cpu_to_le64(req->r_tid);
 
 	head = msg->front.iov_base;
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index e89750a1f039..a8597cae0ed7 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -995,6 +995,7 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req;
 	struct ceph_mds_client *mdsc = fsc->mdsc;
+	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_pagelist *pagelist = NULL;
 	int op = CEPH_MDS_OP_SETXATTR;
 	int err;
@@ -1033,6 +1034,8 @@ static int ceph_sync_setxattr(struct inode *inode, const char *name,
 
 	if (op == CEPH_MDS_OP_SETXATTR) {
 		req->r_args.setxattr.flags = cpu_to_le32(flags);
+		req->r_args.setxattr.osdmap_epoch =
+			cpu_to_le32(osdc->osdmap->epoch);
 		req->r_pagelist = pagelist;
 		pagelist = NULL;
 	}
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 455e9b9e2adf..c0f1b921ec69 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -424,6 +424,7 @@ union ceph_mds_request_args {
 	} __attribute__ ((packed)) open;
 	struct {
 		__le32 flags;
+		__le32 osdmap_epoch; /* used for setting file/dir layouts */
 	} __attribute__ ((packed)) setxattr;
 	struct {
 		struct ceph_file_layout_legacy layout;
-- 
2.27.0

