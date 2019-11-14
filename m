Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1CFC4D3
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 11:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfKNK5o (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 05:57:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:33384 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726992AbfKNK5n (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 05:57:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A2FBEAE5E;
        Thu, 14 Nov 2019 10:57:41 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH v2 4/4] ceph: add support for sending truncate_{seq,size} in 'copy-from' Op
Date:   Thu, 14 Nov 2019 10:57:36 +0000
Message-Id: <20191114105736.8636-5-lhenriques@suse.com>
In-Reply-To: <20191114105736.8636-1-lhenriques@suse.com>
References: <20191114105736.8636-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Doing an object copy in Ceph will result in not only the data being
copied but also the truncate_seq value.  This may make sense in generic
RADOS object copies, but for the specific case of performing a file copy
will result in data corruption in the destination file.

In order to fix this, the 'copy-from' operation had to be modified so
that it could receive the two extra parameters for the destination
object truncate_seq and truncate_size.  This patch adds support for
these extra parameters to the kernel client.  Unfortunately, this
operation modification is available in Ceph Octopus only, so it is
necessary to ensure that the OSD doing the copy does indeed support this
feature.

Link: https://tracker.ceph.com/issues/37378
Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c                  | 10 +++++++++-
 include/linux/ceph/osd_client.h |  1 +
 include/linux/ceph/rados.h      |  1 +
 net/ceph/osd_client.c           |  7 ++++++-
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index bd77adb64bfd..f45bb3837a31 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1928,6 +1928,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
 	struct ceph_object_locator src_oloc, dst_oloc;
 	struct ceph_object_id src_oid, dst_oid;
+	struct ceph_osdmap *map = src_fsc->client->osdc.osdmap;
 	loff_t endoff = 0, size;
 	ssize_t ret = -EIO;
 	u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
@@ -1958,6 +1959,11 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 
 	if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
 		return -EOPNOTSUPP;
+	if (map->require_osd_release < CEPH_RELEASE_OCTOPUS) {
+		pr_warn_once("copy_file_range not supported in '%s' release\n",
+			     ceph_release_name(map->require_osd_release));
+		return -EOPNOTSUPP;
+	}
 
 	/*
 	 * Striped file layouts require that we copy partial objects, but the
@@ -2086,7 +2092,9 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
 			&dst_oid, &dst_oloc,
 			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
+			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
+			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
+			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
 		if (err) {
 			dout("ceph_osdc_copy_from returned %d\n", err);
 			if (!ret)
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index eaffbdddf89a..5a62dbd3f4c2 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -534,6 +534,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_id *dst_oid,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
+			u32 truncate_seq, u64 truncate_size,
 			u8 copy_from_flags);
 
 /* watch/notify */
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 68bc65f971b4..318da211bb79 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -468,6 +468,7 @@ enum {
 	CEPH_OSD_COPY_FROM_FLAG_MAP_SNAP_CLONE = 8, /* map snap direct to
 						     * cloneid */
 	CEPH_OSD_COPY_FROM_FLAG_RWORDERED = 16,     /* order with write */
+	CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ = 32,  /* send truncate_{seq,size} */
 };
 
 enum {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ba45b074a362..02abf2790e99 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5315,6 +5315,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 				     struct ceph_object_locator *src_oloc,
 				     u32 src_fadvise_flags,
 				     u32 dst_fadvise_flags,
+				     u32 truncate_seq, u64 truncate_size,
 				     u8 copy_from_flags)
 {
 	struct ceph_osd_req_op *op;
@@ -5335,6 +5336,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 	end = p + PAGE_SIZE;
 	ceph_encode_string(&p, end, src_oid->name, src_oid->name_len);
 	encode_oloc(&p, end, src_oloc);
+	ceph_encode_32(&p, truncate_seq);
+	ceph_encode_64(&p, truncate_size);
 	op->indata_len = PAGE_SIZE - (end - p);
 
 	ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
@@ -5350,6 +5353,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_id *dst_oid,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
+			u32 truncate_seq, u64 truncate_size,
 			u8 copy_from_flags)
 {
 	struct ceph_osd_request *req;
@@ -5366,7 +5370,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 
 	ret = osd_req_op_copy_from_init(req, src_snapid, src_version, src_oid,
 					src_oloc, src_fadvise_flags,
-					dst_fadvise_flags, copy_from_flags);
+					dst_fadvise_flags, truncate_seq,
+					truncate_size, copy_from_flags);
 	if (ret)
 		goto out;
 
