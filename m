Return-Path: <ceph-devel+bounces-3731-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C974B9ECBF
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 12:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F0411B210F1
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Sep 2025 10:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D07BA2FCBEB;
	Thu, 25 Sep 2025 10:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="VccY/d3g"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B982FB995
	for <ceph-devel@vger.kernel.org>; Thu, 25 Sep 2025 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758796985; cv=none; b=sHh2pODyzdU3EW7QOlXTMJWpJFPSDvb0O2gRlW/F8XLjclDgHKs+/ynZKzXGLOiE7+twTPx7yGYyXmCKWNS0gYbl6EtCgucn8TOMzik39P9lNXSHYfx27CTQvsvIQcDa2MzQUx/G1kgMGzL4WR9/5DmK6k1xdOOih8/jolaM+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758796985; c=relaxed/simple;
	bh=LaD4jZFBhp/yxWrnNtoHs6FmRusLLJLrpcrkJgLOjak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fBI81dt5mWQbBv7kiXiOo8CMdhiUUwQR86y5Iy/vGxsBaX/7MyAnUcBjm5s4ns0usMe5vhMsUghxIpud5vCL8YmKlXRKiL6RguEkpYNA0lqIiNlulBWZGhvXyh8usRGAmkzhE+l9hruhZbWoB0HkNT5MW6eFZpVVs3kjFwDQdio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=VccY/d3g; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
From: ethanwu <ethanwu@synology.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1758796982; bh=LaD4jZFBhp/yxWrnNtoHs6FmRusLLJLrpcrkJgLOjak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VccY/d3gmgZnpcR1L+4a/6jsImGfPBzU/rQmQJIkN3LSq3s3jKjwd2sgcIqMaJN0+
	 TI50WRHFUpcIWdqKFOgPlWw7AAb8hDFuciULcRCCBsYOnV1s4KvUXYVQLhMI9lXUwa
	 uMSdGiLnTWZ9RB6F83IoJnpinrx51U1Eh7iYGf4A=
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	idryomov@gmail.com,
	Slava.Dubeyko@ibm.com,
	Pavan.Rallabhandi@ibm.com,
	ethanwu@synology.com
Subject: [PATCH 2/2] ceph: fix snapshot context missing in ceph_uninline_data
Date: Thu, 25 Sep 2025 18:42:06 +0800
Message-ID: <20250925104228.95018-3-ethanwu@synology.com>
In-Reply-To: <20250925104228.95018-1-ethanwu@synology.com>
References: <20250925104228.95018-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no
X-Synology-MCP-Status: no
Content-Type: text/plain

The ceph_uninline_data function was missing proper snapshot context
handling for its OSD write operations. Both CEPH_OSD_OP_CREATE and
CEPH_OSD_OP_WRITE requests were passing NULL instead of the appropriate
snapshot context, which could lead to unnecessary object clone.

Reproducer:
../src/vstart.sh --new -x --localhost --bluestore
// turn on cephfs inline data
./bin/ceph fs set a inline_data true --yes-i-really-really-mean-it
// allow fs_a client to take snapshot
./bin/ceph auth caps client.fs_a mds 'allow rwps fsname=a' mon 'allow r fsname=a' osd 'allow rw tag cephfs data=a'
// mount cephfs with fuse, since kernel cephfs doesn't support inline write
ceph-fuse --id fs_a -m 127.0.0.1:40318 --conf ceph.conf -d /mnt/mycephfs/
// bump snapshot seq
mkdir /mnt/mycephfs/.snap/snap1
echo "foo" > /mnt/mycephfs/test
// umount and mount it again using kernel cephfs client
umount /mnt/mycephfs
mount -t ceph fs_a@.a=/ /mnt/mycephfs/ -o conf=./ceph.conf
echo "bar" >> /mnt/mycephfs/test
./bin/rados listsnaps -p cephfs.a.data $(printf "%x\n" $(stat -c %i /mnt/mycephfs/test)).00000000

will see this object does unnecessary clone
1000000000a.00000000 (seq:2):
cloneid snaps   size    overlap
2       2       4       []
head    -       8

but it's expected to see
10000000000.00000000 (seq:2):
cloneid snaps   size    overlap
head    -       8

since there's no snapshot between these 2 writes

clone happened because the first osd request CEPH_OSD_OP_CREATE doesn't
pass snap context so object is created with snap seq 0, but later data
writeback is equipped with snapshot context.
snap.seq(1) > object snap seq(0), so osd does object clone.

This fix properly acquiring the snapshot context before performing
write operations.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 fs/ceph/addr.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b202d789e93..0e87a3e8fd2c 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2202,6 +2202,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_osd_request *req = NULL;
 	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
+	struct ceph_snap_context *snapc = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
 	int err = 0;
@@ -2229,6 +2230,24 @@ int ceph_uninline_data(struct file *file)
 	if (inline_version == 1) /* initial version, no data */
 		goto out_uninline;
 
+	down_read(&fsc->mdsc->snap_rwsem);
+	spin_lock(&ci->i_ceph_lock);
+	if (__ceph_have_pending_cap_snap(ci)) {
+		struct ceph_cap_snap *capsnap =
+				list_last_entry(&ci->i_cap_snaps,
+						struct ceph_cap_snap,
+						ci_item);
+		snapc = ceph_get_snap_context(capsnap->context);
+	} else {
+		if (!ci->i_head_snapc) {
+			ci->i_head_snapc = ceph_get_snap_context(
+				ci->i_snap_realm->cached_context);
+		}
+		snapc = ceph_get_snap_context(ci->i_head_snapc);
+	}
+	spin_unlock(&ci->i_ceph_lock);
+	up_read(&fsc->mdsc->snap_rwsem);
+
 	folio = read_mapping_folio(inode->i_mapping, 0, file);
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
@@ -2244,7 +2263,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 0, 1,
 				    CEPH_OSD_OP_CREATE, CEPH_OSD_FLAG_WRITE,
-				    NULL, 0, 0, false);
+				    snapc, 0, 0, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -2260,7 +2279,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 1, 3,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
-				    NULL, ci->i_truncate_seq,
+				    snapc, ci->i_truncate_seq,
 				    ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -2323,6 +2342,7 @@ int ceph_uninline_data(struct file *file)
 		folio_put(folio);
 	}
 out:
+	ceph_put_snap_context(snapc);
 	ceph_free_cap_flush(prealloc_cf);
 	doutc(cl, "%llx.%llx inline_version %llu = %d\n",
 	      ceph_vinop(inode), inline_version, err);
-- 
2.43.0


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.

