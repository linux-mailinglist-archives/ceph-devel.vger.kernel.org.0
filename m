Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EAC3FFBAA
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Sep 2021 10:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348205AbhICIRq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 04:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20357 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348203AbhICIRp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 04:17:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630657005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=77G9yWjI8G6BIox5hs2kjNza8Je8mZzrSPYqMnEgt5U=;
        b=ixP9H8we0YZ6NjdSBY1LyNqRzezbl/OnkiyRhGTBdLlTMoh2CjuUWNvHR055koVaiq0PX0
        0i/dWVb7/cv58L/Q3JuFcBbBznPnD8KOksl9cR7rRCnz04JK0M3+1jCZJhIhhg5otVw+Ve
        4kbSsvnRPHdXcCZfixZgrLVTtcJ3Qzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-mwSOEBWcOfmHsLmE0jzoWA-1; Fri, 03 Sep 2021 04:16:44 -0400
X-MC-Unique: mwSOEBWcOfmHsLmE0jzoWA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB1191854E2A;
        Fri,  3 Sep 2021 08:16:42 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3DE6A8F8;
        Fri,  3 Sep 2021 08:16:40 +0000 (UTC)
From:   xiubli@redhat.com
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH RFC 2/2] ceph: truncate the file contents when needed when file scrypted
Date:   Fri,  3 Sep 2021 16:15:10 +0800
Message-Id: <20210903081510.982827-3-xiubli@redhat.com>
In-Reply-To: <20210903081510.982827-1-xiubli@redhat.com>
References: <20210903081510.982827-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When truncating the file, it will leave the MDS to handle that,
but the MDS won't update the file contents. So when the fscrypt
is enabled, if the truncate size is not aligned to the block size,
the kclient will round up the truancate size to the block size and
leave the the last block untouched.

The opaque fscrypt_file field will be used to tricker whether the
last block need to do the rmw to truncate the a specified block's
contents, we can get which block needs to do the rmw by round down
the fscrypt_file.

In kclient side, there is not need to do the rmw immediately after
the file is truncated. We can defer doing that whenever the kclient
will update that block in late future. And before that any kclient
will check the fscrypt_file field when reading that block, if the
fscrypt_file field is none zero that means the related block needs
to be zeroed in range of [fscrypt_file, round_up(fscrypt_file + PAGE_SIZE))
in pagecache or readed data buffer.

Once the that block contents are updated and writeback to ceph, the
kclient will reset the fscrypt_file field in MDS side, then 0 means
no need to care about the truncate stuff any more.

There has one special case and that is when there have 2 ftruncates
are called:

1) If the second's size equals to the first one, do nothing about
   the fscrypt_file.
2) If the second's size is smaller than the first one, then we need
   to update the fscrypt_file with new size.
3) If the second's size is larger than the first one, then we must
   leave what the fscrypt_file is. Because we always need to truncate
   more.

Add one CEPH_CLIENT_CAPS_RESET_FSCRYPT_FILE flag in the cap reqeust
to tell the MDS to reset the scrypt_file field once the specified
block has been updated, so there still need to adapt to this in the
MDS PR.

And also this patch just assume that all the buffer and none buffer
read/write related enscrypt/descrypt work has been done.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c  | 19 ++++++++++++++-
 fs/ceph/caps.c  | 24 +++++++++++++++++++
 fs/ceph/file.c  | 62 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ceph/inode.c | 27 ++++++++++++++++++---
 fs/ceph/super.h | 12 ++++++++--
 5 files changed, 135 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6d3f74d46e5b..9f1dd2fc427d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -212,6 +212,7 @@ static bool ceph_netfs_clamp_length(struct netfs_read_subrequest *subreq)
 static void finish_netfs_read(struct ceph_osd_request *req)
 {
 	struct ceph_fs_client *fsc = ceph_inode_to_client(req->r_inode);
+	struct ceph_inode_info *ci = ceph_inode(req->r_inode);
 	struct ceph_osd_data *osd_data = osd_req_op_extent_osd_data(req, 0);
 	struct netfs_read_subrequest *subreq = req->r_priv;
 	int num_pages;
@@ -234,8 +235,15 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 
 	netfs_subreq_terminated(subreq, err, true);
 
+	/* FIXME: This should be done after descryped */
+	if (req->r_result > 0)
+		ceph_try_to_zero_truncate_block_off(ci, osd_data->alignment,
+						    osd_data->length,
+						    osd_data->pages);
+
 	num_pages = calc_pages_for(osd_data->alignment, osd_data->length);
 	ceph_put_page_vector(osd_data->pages, num_pages, false);
+
 	iput(req->r_inode);
 }
 
@@ -555,8 +563,10 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 				  req->r_end_latency, len, err);
 
 	ceph_osdc_put_request(req);
-	if (err == 0)
+	if (err == 0) {
+		ceph_reset_truncate_block_off(ci, page_off, len);
 		err = len;
+	}
 
 	if (err < 0) {
 		struct writeback_control tmp_wbc;
@@ -661,10 +671,17 @@ static void writepages_finish(struct ceph_osd_request *req)
 					   (u64)osd_data->length);
 		total_pages += num_pages;
 		for (j = 0; j < num_pages; j++) {
+			u64 page_off;
+
 			page = osd_data->pages[j];
 			BUG_ON(!page);
 			WARN_ON(!PageUptodate(page));
 
+			page_off = osd_data->alignment + j * PAGE_SIZE;
+			if (rc >= 0)
+			    ceph_reset_truncate_block_off(ci, page_off,
+							  page_off + PAGE_SIZE);
+
 			if (atomic_long_dec_return(&fsc->writeback_count) <
 			     CONGESTION_OFF_THRESH(
 					fsc->mount_options->congestion_kb))
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index d628dcdbf869..a211ab4c3f7a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1425,6 +1425,9 @@ static void __prep_cap(struct cap_msg_args *arg, struct ceph_cap *cap,
 			}
 		}
 	}
+	if (ci->i_truncate_block_off < 0)
+		flags |= CEPH_CLIENT_CAPS_RESET_FSCRYPT_FILE;
+
 	arg->flags = flags;
 	arg->encrypted = IS_ENCRYPTED(inode);
 	if (ci->fscrypt_auth_len &&
@@ -3155,6 +3158,27 @@ void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
 	__ceph_put_cap_refs(ci, had, PUT_CAP_REFS_NO_CHECK);
 }
 
+/*
+ * Clear the i_truncate_block_off and fscrypt_file
+ * if old last encrypted block has been updated.
+ */
+void __ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
+				      u64 start_pos, u64 end_pos)
+{
+	if (ci->i_truncate_block_off > 0 &&
+	    ci->i_truncate_block_off >= start_pos &&
+	    ci->i_truncate_block_off < end_pos)
+		ci->i_truncate_block_off = 0;
+}
+
+void ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
+				    u64 start_pos, u64 end_pos)
+{
+	spin_lock(&ci->i_ceph_lock);
+	__ceph_reset_truncate_block_off(ci, start_pos, end_pos);
+	spin_unlock(&ci->i_ceph_lock);
+}
+
 /*
  * Release @nr WRBUFFER refs on dirty pages for the given @snapc snap
  * context.  Adjust per-snap dirty page accounting as appropriate.
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6e677b40410e..cfa4cbe08c10 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -885,10 +885,34 @@ static void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64 *len)
 	}
 }
 
+void ceph_try_to_zero_truncate_block_off(struct ceph_inode_info *ci,
+					 u64 start_pos, u64 end_pos,
+					 struct page **pages)
+{
+	u64 zoff, zlen;
+
+	spin_lock(&ci->i_ceph_lock);
+	if (ci->i_truncate_block_off >= start_pos &&
+			ci->i_truncate_block_off < end_pos) {
+		zoff = ci->i_truncate_block_off - start_pos;
+		zlen = round_up(ci->i_truncate_block_off, PAGE_SIZE) - ci->i_truncate_block_off;
+
+		spin_unlock(&ci->i_ceph_lock);
+		ceph_zero_page_vector_range(zoff, zlen, pages);
+		spin_lock(&ci->i_ceph_lock);
+	}
+	spin_unlock(&ci->i_ceph_lock);
+}
 #else
 static inline void fscrypt_adjust_off_and_len(struct inode *inode, u64 *off, u64 *len)
 {
 }
+
+void ceph_try_to_zero_truncate_block_off(struct ceph_inode_info *ci,
+					 u64 start_pos, u64 end_pos,
+					 struct page **pages)
+{
+}
 #endif
 
 /*
@@ -1030,6 +1054,13 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 			ret += zlen;
 		}
 
+		/*
+		 * If the inode is ENCRYPTED the read_off is aligned to PAGE_SIZE
+		 */
+		ceph_try_to_zero_truncate_block_off(ci, read_off,
+						    read_off + read_len,
+						    pages);
+
 		idx = 0;
 		left = ret > 0 ? ret : 0;
 		while (left > 0) {
@@ -1413,12 +1444,34 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 
 		size = i_size_read(inode);
 		if (!write) {
+			struct iov_iter i;
+			size_t boff;
+			int zlen;
+
 			if (ret == -ENOENT)
 				ret = 0;
+
+			/* Zero the truncate block off */
+			spin_lock(&ci->i_ceph_lock);
+			boff = ci->i_truncate_block_off;
+			if (IS_ENCRYPTED(inode) && ret > 0 && boff > 0 &&
+			    boff >= (iocb->ki_pos & PAGE_MASK) &&
+			    boff < round_up(ret, PAGE_SIZE)) {
+				int advance = 0;
+
+				zlen = round_up(boff, PAGE_SIZE) - boff;
+				if (ci->i_truncate_block_off >= iocb->ki_pos)
+					advance = boff - iocb->ki_pos;
+
+				iov_iter_bvec(&i, READ, bvecs, num_pages, len);
+				iov_iter_advance(&i, advance);
+				iov_iter_zero(zlen, &i);
+			}
+			spin_unlock(&ci->i_ceph_lock);
+
 			if (ret >= 0 && ret < len && pos + ret < size) {
-				struct iov_iter i;
-				int zlen = min_t(size_t, len - ret,
-						 size - pos - ret);
+				zlen = min_t(size_t, len - ret,
+					     size - pos - ret);
 
 				iov_iter_bvec(&i, READ, bvecs, num_pages, len);
 				iov_iter_advance(&i, ret);
@@ -1967,6 +2020,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_client *osdc = &fsc->client->osdc;
 	struct ceph_cap_flush *prealloc_cf;
+	u64 start_pos = iocb->ki_pos;
 	ssize_t count, written = 0;
 	int err, want, got;
 	bool direct_lock = false;
@@ -2110,6 +2164,8 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		int dirty;
 
 		spin_lock(&ci->i_ceph_lock);
+		__ceph_reset_truncate_block_off(ci, start_pos, iocb->ki_pos);
+
 		ci->i_inline_version = CEPH_INLINE_NONE;
 		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
 					       &prealloc_cf);
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1a4c9bc485fc..c48c77c1bcf4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -625,6 +625,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
 	ci->fscrypt_auth = NULL;
 	ci->fscrypt_auth_len = 0;
 #endif
+	ci->i_truncate_block_off = 0;
 
 	return &ci->vfs_inode;
 }
@@ -1033,11 +1034,24 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 
 		pool_ns = old_ns;
 
+		/* the fscrypt_file is 0 means the file content truncate has been done */
 		if (IS_ENCRYPTED(inode) && size &&
-		    (iinfo->fscrypt_file_len == sizeof(__le64))) {
+		    iinfo->fscrypt_file_len == sizeof(__le64) &&
+		    __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file) > 0) {
 			size = __le64_to_cpu(*(__le64 *)iinfo->fscrypt_file);
 			if (info->size != round_up(size, CEPH_FSCRYPT_BLOCK_SIZE))
 				pr_warn("size=%llu fscrypt_file=%llu\n", info->size, size);
+
+			/*
+			 * If the second truncate come just after the first
+			 * truncate, and if the second has a larger size there
+			 * is no need to update the i_truncate_block_off.
+			 * Only when the second one has a smaller size, that
+			 * means we need to truncate more.
+			 */
+			if (ci->i_truncate_block_off > 0 &&
+			    size < ci->i_truncate_block_off)
+				ci->i_truncate_block_off = size;
 		}
 
 		queue_trunc = ceph_fill_file_size(inode, issued,
@@ -2390,8 +2404,15 @@ int __ceph_setattr(struct inode *inode, struct iattr *attr, struct ceph_iattr *c
 				req->r_args.setattr.old_size =
 					cpu_to_le64(round_up(isize,
 							     CEPH_FSCRYPT_BLOCK_SIZE));
-				req->r_fscrypt_file = attr->ia_size;
-				/* FIXME: client must zero out any partial blocks! */
+				if (attr->ia_size < isize) {
+					if(IS_ALIGNED(attr->ia_size, CEPH_FSCRYPT_BLOCK_SIZE))
+						req->r_fscrypt_file = 0;
+					else
+						req->r_fscrypt_file = attr->ia_size;
+					/* FIXME: client must zero out any partial blocks! */
+				} else if (attr->ia_size > isize) {
+					req->r_fscrypt_file = attr->ia_size;
+				}
 			} else {
 				req->r_args.setattr.size = cpu_to_le64(attr->ia_size);
 				req->r_args.setattr.old_size = cpu_to_le64(isize);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 7f3976b3319d..856caeb25fb6 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -443,9 +443,9 @@ struct ceph_inode_info {
 	struct fscache_cookie *fscache;
 #endif
 	u32 fscrypt_auth_len;
-	u32 fscrypt_file_len;
 	u8 *fscrypt_auth;
-	u8 *fscrypt_file;
+	/* need to zero the last block when decrypting the content to pagecache */
+	size_t i_truncate_block_off;
 
 	errseq_t i_meta_err;
 
@@ -1192,6 +1192,10 @@ extern void ceph_put_cap_refs(struct ceph_inode_info *ci, int had);
 extern void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had);
 extern void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci,
 					    int had);
+extern void __ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
+					    u64 start_pos, u64 end_pos);
+extern void ceph_reset_truncate_block_off(struct ceph_inode_info *ci,
+					  u64 start_pos, u64 end_pos);
 extern void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
 				       struct ceph_snap_context *snapc);
 extern void ceph_flush_snaps(struct ceph_inode_info *ci,
@@ -1282,6 +1286,10 @@ extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
 extern void ceph_fs_debugfs_init(struct ceph_fs_client *client);
 extern void ceph_fs_debugfs_cleanup(struct ceph_fs_client *client);
 
+extern void ceph_try_to_zero_truncate_block_off(struct ceph_inode_info *ci,
+						u64 start_pos, u64 end_pos,
+						struct page **pages);
+
 /* quota.c */
 static inline bool __ceph_has_any_quota(struct ceph_inode_info *ci)
 {
-- 
2.27.0

