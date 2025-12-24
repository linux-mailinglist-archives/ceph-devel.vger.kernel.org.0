Return-Path: <ceph-devel+bounces-4228-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 81FBECDB32E
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 03:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 532213018D75
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Dec 2025 02:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AA59222565;
	Wed, 24 Dec 2025 02:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IK+NYFQ4"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF591DD0D4
	for <ceph-devel@vger.kernel.org>; Wed, 24 Dec 2025 02:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766544624; cv=none; b=hP2CwtaeOYuUvXcH9nrZvqS7Z/mb6A37hdfF5PDPyCmOrqS3VlPHxCMZ04vnhm7CwF4HTANx6o9eHSt357KB2PV9AO9qXuvfIaljuDGwjWuGNGCom/H3ygmITgPeB+MGizKI6URBS0D8yH5tUW0SfP2ggQlUWOoPQe37q2YhQLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766544624; c=relaxed/simple;
	bh=01/ahfyNSrt2NNVKRhCj0aFyBCV4s/s4KFaGMHzCj3A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=HGDvcC6JiDRpyRPl7+35vGwqM0xETr2lwVozw/GRCTXf2LthEZdPnQ8hPxQbmkWik2rmMt4ATNDn44t1ElEgDXrO/aCHT55tEYO27vYRda0rZlCeLvet2Lzcv+kWFVcik9VnTGNLSPqsrX5ed1wTerDdBGrCelO/xdNqFv4jaxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IK+NYFQ4; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251224025003epoutp01e0f0e2d06c78773bcb90221138fcebb9~EBvUbVLtl0517905179epoutp01j
	for <ceph-devel@vger.kernel.org>; Wed, 24 Dec 2025 02:50:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251224025003epoutp01e0f0e2d06c78773bcb90221138fcebb9~EBvUbVLtl0517905179epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766544603;
	bh=d01jCXkXeH+vDNZtxB4ro8RQ2V1Wr9TtYfVxtRtf66g=;
	h=From:To:Cc:Subject:Date:References:From;
	b=IK+NYFQ4p2fu+XsErjztqH3BDe+zYF1tgERsduGtIxPbFKCoqzGgFtOby+3ZDXM7Z
	 DnVPn02eYQiu7qSUq5MvW1ru1Gtzi2xNIrAoKyglbttZe4PVYiyibzAWZi1qay27dq
	 ZLH/blP3cqYEq+rXBtoMB+YT4VXepLjIJUEzg0rA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251224025003epcas5p140a6e80448d3c226171e8860348fbb6b~EBvUHcYFs1672316723epcas5p1F;
	Wed, 24 Dec 2025 02:50:03 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dbbvZ4KVKz6B9m6; Wed, 24 Dec
	2025 02:50:02 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251224023403epcas5p16c061413b711b019c9cd63441bae985f~EBhWR8I5z1764317643epcas5p1z;
	Wed, 24 Dec 2025 02:34:03 +0000 (GMT)
Received: from node1.. (unknown [109.105.118.96]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251224023402epsmtip1374688bff6de4fecf36fb7b09d788b31~EBhVpFm312950529505epsmtip1_;
	Wed, 24 Dec 2025 02:34:02 +0000 (GMT)
From: Qian Li <qian01.li@samsung.com>
To: idryomov@gmail.com, xiubli@redhat.com, ceph-devel@vger.kernel.org
Cc: Qian Li <qian01.li@samsung.com>
Subject: [PATCH] ceph: add support for multi-stream SSDs(such as FDP SSDs)
Date: Wed, 24 Dec 2025 18:15:44 +0800
Message-Id: <20251224101544.3057791-1-qian01.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251224023403epcas5p16c061413b711b019c9cd63441bae985f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251224023403epcas5p16c061413b711b019c9cd63441bae985f
References: <CGME20251224023403epcas5p16c061413b711b019c9cd63441bae985f@epcas5p1.samsung.com>

The NVMe SSD (e.g. Flexible Data Placement SSD, TP4146) is
supporting to recognize data lifetime information on device. It
provides multiple streams to isolate different data lifetimes.
Write_hint support in fs and block layers has been available since
commit 449813515d3e ("block, fs: restore per-bio/request
data lifetime field").
This patch enables the Ceph kernel client to support
the data lifetime field and to transmit the write_hint
to the Ceph server over the network. By adding the write_hint to
Ceph and passing it to the device, we achieve lower write
amplification and better performance.
We have implemented a complete feature for multi-stream devices
such as FDP SSDs (client + server). The corresponding Ceph
server patch can be found in the pull request here:
https://github.com/ceph/ceph/pull/66716

Signed-off-by: Qian Li <qian01.li@samsung.com>
---
 fs/ceph/addr.c                  | 2 ++
 fs/ceph/file.c                  | 4 +++-
 include/linux/ceph/ceph_fs.h    | 1 +
 include/linux/ceph/osd_client.h | 2 +-
 net/ceph/osd_client.c           | 5 ++++-
 5 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 322ed268f14a..94a99e26f455 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -778,6 +778,7 @@ static int write_folio_nounlock(struct folio *folio,
 	    CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb))
 		fsc->write_congested = true;
 
+	ci->i_layout.write_hint = inode->i_write_hint;
 	req = ceph_osdc_new_request(osdc, &ci->i_layout, ceph_vino(inode),
 				    page_off, &wlen, 0, 1, CEPH_OSD_OP_WRITE,
 				    CEPH_OSD_FLAG_WRITE, snapc,
@@ -1427,6 +1428,7 @@ int ceph_submit_write(struct address_space *mapping,
 new_request:
 	offset = ceph_fscrypt_page_offset(ceph_wbc->pages[0]);
 	len = ceph_wbc->wsize;
+	ci->i_layout.write_hint = inode->i_write_hint;
 
 	req = ceph_osdc_new_request(&fsc->client->osdc,
 				    &ci->i_layout, vino,
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 99b30f784ee2..5063f9d9f30c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1518,6 +1518,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	} else {
 		flags = CEPH_OSD_FLAG_READ;
 	}
+	ci->i_layout.write_hint = inode->i_write_hint;
 
 	while (iov_iter_count(iter) > 0) {
 		u64 size = iov_iter_count(iter);
@@ -1675,6 +1676,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			req = list_first_entry(&osd_reqs,
 					       struct ceph_osd_request,
 					       r_private_item);
+			req->write_hint = inode->i_write_hint;
 			list_del_init(&req->r_private_item);
 			if (ret >= 0)
 				ceph_osdc_start_request(req->r_osdc, req);
@@ -1732,7 +1734,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 		return ret;
 
 	ceph_fscache_invalidate(inode, false);
-
+	ci->i_layout.write_hint = inode->i_write_hint;
 	while ((len = iov_iter_count(from)) > 0) {
 		size_t left;
 		int n;
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index c7f2c63b3bc3..61e175c21ca6 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -65,6 +65,7 @@ struct ceph_file_layout {
 	u32 object_size;   /* until objects are this big */
 	s64 pool_id;        /* rados pool id */
 	struct ceph_string __rcu *pool_ns; /* rados pool namespace */
+	int32_t  write_hint;
 };
 
 extern int ceph_file_layout_is_valid(const struct ceph_file_layout *layout);
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 50b14a5661c7..65db613339ef 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -278,7 +278,7 @@ struct ceph_osd_request {
 	ktime_t r_end_latency;                /* ktime_t */
 	int r_attempts;
 	u32 r_map_dne_bound;
-
+	int32_t  write_hint;
 	struct ceph_osd_req_op r_ops[] __counted_by(r_num_ops);
 };
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 3667319b949d..57cb3f9ada66 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -605,7 +605,7 @@ static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
 	msg_size += 8; /* snapid */
 	msg_size += 8; /* snap_seq */
 	msg_size += 4 + 8 * (req->r_snapc ? req->r_snapc->num_snaps : 0);
-	msg_size += 4 + 8; /* retry_attempt, features */
+	msg_size += 4 + 4 + 8; /* retry_attempt, write_hint, features */
 
 	if (req->r_mempool)
 		msg = ceph_msgpool_get(&osdc->msgpool_op, msg_size,
@@ -1081,6 +1081,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 		goto fail;
 	}
 
+	req->write_hint = layout->write_hint;
 	/* calculate max write size */
 	r = calc_layout(layout, off, plen, &objnum, &objoff, &objlen);
 	if (r)
@@ -2194,6 +2195,8 @@ static void encode_request_partial(struct ceph_osd_request *req,
 	}
 
 	ceph_encode_32(&p, req->r_attempts); /* retry_attempt */
+	ceph_encode_32(&p, req->write_hint);
+
 	BUG_ON(p > end - 8); /* space for features */
 
 	msg->hdr.version = cpu_to_le16(8); /* MOSDOp v8 */
-- 
2.34.1


