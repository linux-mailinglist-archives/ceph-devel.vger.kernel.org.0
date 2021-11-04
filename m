Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D652445311
	for <lists+ceph-devel@lfdr.de>; Thu,  4 Nov 2021 13:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhKDMee (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 4 Nov 2021 08:34:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46888 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhKDMea (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 4 Nov 2021 08:34:30 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CA0F7212BD;
        Thu,  4 Nov 2021 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636029110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bzi5lrKWLTZ2s/iu9Qv0yZXjo6nPC6JKeYKOQNLtlDY=;
        b=TxZVOtm7V1ek1n9gVG3NguzHb3Sk4keKlhOV4ycLfvQ1Wsq/eWcXMk699cRGHdZnjB8GVN
        pxibuj42pnzUAXZWqyy6/GX/o8Zx+94qnIs1GO8Ws6s8XRtrcNY/RI9B1cZLx5oq8qkPLX
        BtYdxVL1Qu5DyQm8hSZBVDPwv76BB9s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636029110;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bzi5lrKWLTZ2s/iu9Qv0yZXjo6nPC6JKeYKOQNLtlDY=;
        b=uV93JpCo8W2To6nacGTGC4Xl1IWCeVdbhwKj1VehNn0M8m4jRiNls/2O3ZYWz+3zTEHhJM
        9GRzHdOqZoMUOXAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A33213EB1;
        Thu,  4 Nov 2021 12:31:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aLBME7bSg2HLDQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 04 Nov 2021 12:31:50 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id a1072740;
        Thu, 4 Nov 2021 12:31:49 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 1/2] ceph: libceph: move ceph_osdc_copy_from() into cephfs code
Date:   Thu,  4 Nov 2021 12:31:46 +0000
Message-Id: <20211104123147.1632-2-lhenriques@suse.de>
In-Reply-To: <20211104123147.1632-1-lhenriques@suse.de>
References: <20211104123147.1632-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patch moves ceph_osdc_copy_from() function out of libceph code into
cephfs.  There are no other users for this function, and there is the need
(in another patch) to access internal ceph_osd_request struct members.
Thus, instead of changing ceph_osdc_copy_from() to return the request,
simply move it where it is needed.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/file.c                  | 74 ++++++++++++++++++++++++++++-----
 include/linux/ceph/osd_client.h | 19 ++++-----
 net/ceph/osd_client.c           | 60 ++++----------------------
 3 files changed, 80 insertions(+), 73 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6005b430f6f7..6c77f203e7b5 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2211,6 +2211,54 @@ static int is_file_size_ok(struct inode *src_inode, struct inode *dst_inode,
 	return 0;
 }
 
+static struct ceph_osd_request *
+ceph_alloc_copyfrom_request(struct ceph_osd_client *osdc,
+			    u64 src_snapid,
+			    struct ceph_object_id *src_oid,
+			    struct ceph_object_locator *src_oloc,
+			    struct ceph_object_id *dst_oid,
+			    struct ceph_object_locator *dst_oloc,
+			    u32 truncate_seq, u64 truncate_size)
+{
+	struct ceph_osd_request *req;
+	int ret;
+	u32 src_fadvise_flags =
+		CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
+		CEPH_OSD_OP_FLAG_FADVISE_NOCACHE;
+	u32 dst_fadvise_flags =
+		CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
+		CEPH_OSD_OP_FLAG_FADVISE_DONTNEED;
+
+	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	req->r_flags = CEPH_OSD_FLAG_WRITE;
+
+	ceph_oloc_copy(&req->r_t.base_oloc, dst_oloc);
+	ceph_oid_copy(&req->r_t.base_oid, dst_oid);
+
+	ret = osd_req_op_copy_from_init(req, src_snapid, 0,
+					src_oid, src_oloc,
+					src_fadvise_flags,
+					dst_fadvise_flags,
+					truncate_seq,
+					truncate_size,
+					CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
+	if (ret)
+		goto out;
+
+	ret = ceph_osdc_alloc_messages(req, GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	return req;
+
+out:
+	ceph_osdc_put_request(req);
+	return ERR_PTR(ret);
+}
+
 static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off,
 				    struct ceph_inode_info *dst_ci, u64 *dst_off,
 				    struct ceph_fs_client *fsc,
@@ -2218,6 +2266,8 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 {
 	struct ceph_object_locator src_oloc, dst_oloc;
 	struct ceph_object_id src_oid, dst_oid;
+	struct ceph_osd_client *osdc;
+	struct ceph_osd_request *req;
 	size_t bytes = 0;
 	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
 	u32 src_objlen, dst_objlen;
@@ -2228,6 +2278,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 	src_oloc.pool_ns = ceph_try_get_string(src_ci->i_layout.pool_ns);
 	dst_oloc.pool = dst_ci->i_layout.pool_id;
 	dst_oloc.pool_ns = ceph_try_get_string(dst_ci->i_layout.pool_ns);
+	osdc = &fsc->client->osdc;
 
 	while (len >= object_size) {
 		ceph_calc_file_object_mapping(&src_ci->i_layout, *src_off,
@@ -2243,17 +2294,18 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 		ceph_oid_printf(&dst_oid, "%llx.%08llx",
 				dst_ci->i_vino.ino, dst_objnum);
 		/* Do an object remote copy */
-		ret = ceph_osdc_copy_from(&fsc->client->osdc,
-					  src_ci->i_vino.snap, 0,
-					  &src_oid, &src_oloc,
-					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-					  CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
-					  &dst_oid, &dst_oloc,
-					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-					  CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
-					  dst_ci->i_truncate_seq,
-					  dst_ci->i_truncate_size,
-					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
+		req = ceph_alloc_copyfrom_request(osdc, src_ci->i_vino.snap,
+						  &src_oid, &src_oloc,
+						  &dst_oid, &dst_oloc,
+						  dst_ci->i_truncate_seq,
+						  dst_ci->i_truncate_size);
+		if (IS_ERR(req))
+			ret = PTR_ERR(req);
+		else {
+			ceph_osdc_start_request(osdc, req, false);
+			ret = ceph_osdc_wait_request(osdc, req);
+			ceph_osdc_put_request(req);
+		}
 		if (ret) {
 			if (ret == -EOPNOTSUPP) {
 				fsc->have_copy_from2 = false;
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 83fa08a06507..3431011f364d 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -475,6 +475,14 @@ extern void osd_req_op_alloc_hint_init(struct ceph_osd_request *osd_req,
 				       u64 expected_object_size,
 				       u64 expected_write_size,
 				       u32 flags);
+extern int osd_req_op_copy_from_init(struct ceph_osd_request *req,
+				     u64 src_snapid, u64 src_version,
+				     struct ceph_object_id *src_oid,
+				     struct ceph_object_locator *src_oloc,
+				     u32 src_fadvise_flags,
+				     u32 dst_fadvise_flags,
+				     u32 truncate_seq, u64 truncate_size,
+				     u8 copy_from_flags);
 
 extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
 					       struct ceph_snap_context *snapc,
@@ -515,17 +523,6 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
 		   struct page *req_page, size_t req_len,
 		   struct page **resp_pages, size_t *resp_len);
 
-int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
-			u64 src_snapid, u64 src_version,
-			struct ceph_object_id *src_oid,
-			struct ceph_object_locator *src_oloc,
-			u32 src_fadvise_flags,
-			struct ceph_object_id *dst_oid,
-			struct ceph_object_locator *dst_oloc,
-			u32 dst_fadvise_flags,
-			u32 truncate_seq, u64 truncate_size,
-			u8 copy_from_flags);
-
 /* watch/notify */
 struct ceph_osd_linger_request *
 ceph_osdc_watch(struct ceph_osd_client *osdc,
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a7c964..1c5815530e0d 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5310,14 +5310,14 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 	ceph_msgpool_destroy(&osdc->msgpool_op_reply);
 }
 
-static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
-				     u64 src_snapid, u64 src_version,
-				     struct ceph_object_id *src_oid,
-				     struct ceph_object_locator *src_oloc,
-				     u32 src_fadvise_flags,
-				     u32 dst_fadvise_flags,
-				     u32 truncate_seq, u64 truncate_size,
-				     u8 copy_from_flags)
+int osd_req_op_copy_from_init(struct ceph_osd_request *req,
+			      u64 src_snapid, u64 src_version,
+			      struct ceph_object_id *src_oid,
+			      struct ceph_object_locator *src_oloc,
+			      u32 src_fadvise_flags,
+			      u32 dst_fadvise_flags,
+			      u32 truncate_seq, u64 truncate_size,
+			      u8 copy_from_flags)
 {
 	struct ceph_osd_req_op *op;
 	struct page **pages;
@@ -5346,49 +5346,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 				 op->indata_len, 0, false, true);
 	return 0;
 }
-
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
-{
-	struct ceph_osd_request *req;
-	int ret;
-
-	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
-
-	req->r_flags = CEPH_OSD_FLAG_WRITE;
-
-	ceph_oloc_copy(&req->r_t.base_oloc, dst_oloc);
-	ceph_oid_copy(&req->r_t.base_oid, dst_oid);
-
-	ret = osd_req_op_copy_from_init(req, src_snapid, src_version, src_oid,
-					src_oloc, src_fadvise_flags,
-					dst_fadvise_flags, truncate_seq,
-					truncate_size, copy_from_flags);
-	if (ret)
-		goto out;
-
-	ret = ceph_osdc_alloc_messages(req, GFP_KERNEL);
-	if (ret)
-		goto out;
-
-	ceph_osdc_start_request(osdc, req, false);
-	ret = ceph_osdc_wait_request(osdc, req);
-
-out:
-	ceph_osdc_put_request(req);
-	return ret;
-}
-EXPORT_SYMBOL(ceph_osdc_copy_from);
+EXPORT_SYMBOL(osd_req_op_copy_from_init);
 
 int __init ceph_osdc_setup(void)
 {
