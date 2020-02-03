Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CBB150E29
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Feb 2020 17:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbgBCQvf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Feb 2020 11:51:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:50034 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727319AbgBCQve (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 11:51:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 462E6AD14;
        Mon,  3 Feb 2020 16:51:31 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [PATCH v3 1/1] ceph: parallelize all copy-from requests in copy_file_range
Date:   Mon,  3 Feb 2020 16:51:17 +0000
Message-Id: <20200203165117.5701-2-lhenriques@suse.com>
In-Reply-To: <20200203165117.5701-1-lhenriques@suse.com>
References: <20200203165117.5701-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Right now the copy_file_range syscall serializes all the OSDs 'copy-from'
operations, waiting for each request to complete before sending the next
one.  This patch modifies copy_file_range so that all the 'copy-from'
operations are sent in bulk and waits for its completion at the end.  This
will allow significant speed-ups, specially when sending requests for
different target OSDs.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c                  | 45 +++++++++++++++++++++-----
 include/linux/ceph/osd_client.h |  6 +++-
 net/ceph/osd_client.c           | 56 +++++++++++++++++++++++++--------
 3 files changed, 85 insertions(+), 22 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 1e6cdf2dfe90..b9d8ffafb8c5 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1943,12 +1943,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 	struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
 	struct ceph_object_locator src_oloc, dst_oloc;
 	struct ceph_object_id src_oid, dst_oid;
+	struct ceph_osd_request *req;
 	loff_t endoff = 0, size;
 	ssize_t ret = -EIO;
 	u64 src_objnum, dst_objnum, src_objoff, dst_objoff;
 	u32 src_objlen, dst_objlen, object_size;
 	int src_got = 0, dst_got = 0, err, dirty;
+	unsigned int max_copies, copy_count, reqs_complete = 0;
 	bool do_final_copy = false;
+	LIST_HEAD(osd_reqs);
 
 	if (src_inode->i_sb != dst_inode->i_sb) {
 		struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
@@ -2083,6 +2086,13 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			goto out_caps;
 	}
 	object_size = src_ci->i_layout.object_size;
+
+	/*
+	 * Throttle the object copies: max_copies holds the number of allowed
+	 * in-flight 'copy-from' requests before waiting for their completion
+	 */
+	max_copies = (src_fsc->mount_options->wsize / object_size) * 4;
+	copy_count = max_copies;
 	while (len >= object_size) {
 		ceph_calc_file_object_mapping(&src_ci->i_layout, src_off,
 					      object_size, &src_objnum,
@@ -2097,7 +2107,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		ceph_oid_printf(&dst_oid, "%llx.%08llx",
 				dst_ci->i_vino.ino, dst_objnum);
 		/* Do an object remote copy */
-		err = ceph_osdc_copy_from(
+		req = ceph_osdc_copy_from(
 			&src_fsc->client->osdc,
 			src_ci->i_vino.snap, 0,
 			&src_oid, &src_oloc,
@@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
 			dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
 			CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
-		if (err) {
-			if (err == -EOPNOTSUPP) {
-				src_fsc->have_copy_from2 = false;
-				pr_notice("OSDs don't support 'copy-from2'; "
-					  "disabling copy_file_range\n");
-			}
+		if (IS_ERR(req)) {
+			err = PTR_ERR(req);
 			dout("ceph_osdc_copy_from returned %d\n", err);
+
+			/* wait for all queued requests */
+			ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
+			ret += reqs_complete * object_size; /* Update copied bytes */
 			if (!ret)
 				ret = err;
 			goto out_caps;
 		}
+		list_add(&req->r_private_item, &osd_reqs);
 		len -= object_size;
 		src_off += object_size;
 		dst_off += object_size;
-		ret += object_size;
+		/*
+		 * Wait requests if we've reached the maximum requests allowed
+		 * or if this was the last copy
+		 */
+		if ((--copy_count == 0) || (len < object_size)) {
+			err = ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
+			ret += reqs_complete * object_size; /* Update copied bytes */
+			if (err) {
+				if (err == -EOPNOTSUPP) {
+					src_fsc->have_copy_from2 = false;
+					pr_notice("OSDs don't support 'copy-from2'; "
+						  "disabling copy_file_range\n");
+				}
+				if (!ret)
+					ret = err;
+				goto out_caps;
+			}
+			copy_count = max_copies;
+		}
 	}
 
 	if (len)
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 5a62dbd3f4c2..0121767cd65e 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -496,6 +496,9 @@ extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
 extern void ceph_osdc_cancel_request(struct ceph_osd_request *req);
 extern int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
 				  struct ceph_osd_request *req);
+extern int ceph_osdc_wait_requests(struct list_head *osd_reqs,
+				   unsigned int *reqs_complete);
+
 extern void ceph_osdc_sync(struct ceph_osd_client *osdc);
 
 extern void ceph_osdc_flush_notifies(struct ceph_osd_client *osdc);
@@ -526,7 +529,8 @@ extern int ceph_osdc_writepages(struct ceph_osd_client *osdc,
 				struct timespec64 *mtime,
 				struct page **pages, int nr_pages);
 
-int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
+struct ceph_osd_request *ceph_osdc_copy_from(
+			struct ceph_osd_client *osdc,
 			u64 src_snapid, u64 src_version,
 			struct ceph_object_id *src_oid,
 			struct ceph_object_locator *src_oloc,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b68b376d8c2f..df9f342f860a 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4531,6 +4531,35 @@ int ceph_osdc_wait_request(struct ceph_osd_client *osdc,
 }
 EXPORT_SYMBOL(ceph_osdc_wait_request);
 
+/*
+ * wait for all requests to complete in list @osd_reqs, returning the number of
+ * successful completions in @reqs_complete
+ */
+int ceph_osdc_wait_requests(struct list_head *osd_reqs,
+			    unsigned int *reqs_complete)
+{
+	struct ceph_osd_request *req;
+	int ret = 0, err;
+	unsigned int counter = 0;
+
+	while (!list_empty(osd_reqs)) {
+		req = list_first_entry(osd_reqs,
+				       struct ceph_osd_request,
+				       r_private_item);
+		list_del_init(&req->r_private_item);
+		err = ceph_osdc_wait_request(req->r_osdc, req);
+		if (!err)
+			counter++;
+		else if (!ret)
+			ret = err;
+		ceph_osdc_put_request(req);
+	}
+	*reqs_complete = counter;
+
+	return ret;
+}
+EXPORT_SYMBOL(ceph_osdc_wait_requests);
+
 /*
  * sync - wait for all in-flight requests to flush.  avoid starvation.
  */
@@ -5346,23 +5375,24 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 	return 0;
 }
 
-int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
-			u64 src_snapid, u64 src_version,
-			struct ceph_object_id *src_oid,
-			struct ceph_object_locator *src_oloc,
-			u32 src_fadvise_flags,
-			struct ceph_object_id *dst_oid,
-			struct ceph_object_locator *dst_oloc,
-			u32 dst_fadvise_flags,
-			u32 truncate_seq, u64 truncate_size,
-			u8 copy_from_flags)
+struct ceph_osd_request *ceph_osdc_copy_from(
+		struct ceph_osd_client *osdc,
+		u64 src_snapid, u64 src_version,
+		struct ceph_object_id *src_oid,
+		struct ceph_object_locator *src_oloc,
+		u32 src_fadvise_flags,
+		struct ceph_object_id *dst_oid,
+		struct ceph_object_locator *dst_oloc,
+		u32 dst_fadvise_flags,
+		u32 truncate_seq, u64 truncate_size,
+		u8 copy_from_flags)
 {
 	struct ceph_osd_request *req;
 	int ret;
 
 	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
 	if (!req)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
 
@@ -5381,11 +5411,11 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 		goto out;
 
 	ceph_osdc_start_request(osdc, req, false);
-	ret = ceph_osdc_wait_request(osdc, req);
+	return req;
 
 out:
 	ceph_osdc_put_request(req);
-	return ret;
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ceph_osdc_copy_from);
 
