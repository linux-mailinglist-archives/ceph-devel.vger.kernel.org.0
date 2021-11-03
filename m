Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048FA444087
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 12:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhKCL0q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 07:26:46 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41298 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhKCL0p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 07:26:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 529F61FD4C;
        Wed,  3 Nov 2021 11:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635938648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5AjT56p9WNY85grFsex7X6u+OrrmGyvo0mAAlM+lE4=;
        b=pwENhj3cOsVsChFIbP4GCN9HWRmkF9Pd39wOD1DPFXGrkmkbrNzaETMWvPFL402+Dj25dr
        odckUUyCPx2r5zzG2yQizXEQqYqVUj3tfQwI/UYRnt9hty7Sxwj9s2aIw18txsXdmOoGcu
        QoviQYtoA1CbIP/EaIVL+TvHJxAkCLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635938648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5AjT56p9WNY85grFsex7X6u+OrrmGyvo0mAAlM+lE4=;
        b=CtMs3PxP8uWr7D8O27H9i/iLg3IR2b5aOMyv52LqDJ4YeCsuxOqyLlX2I7sby6UegzCtpS
        2+eJPwNcUP+N58Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CE4AF13DC1;
        Wed,  3 Nov 2021 11:24:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id MLOmL1dxgmHyMQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 03 Nov 2021 11:24:07 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 09cb5d08;
        Wed, 3 Nov 2021 11:24:06 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 1/2] libceph: have ceph_osdc_copy_from() return the osd request
Date:   Wed,  3 Nov 2021 11:24:04 +0000
Message-Id: <20211103112405.8733-2-lhenriques@suse.de>
In-Reply-To: <20211103112405.8733-1-lhenriques@suse.de>
References: <20211103112405.8733-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patch modifies the behaviour of ceph_osdc_copy_from() function so
that it will create the osd request and send it but won't block waiting
for the result.  It is now the responsibility of the callers (currently
only ceph_do_objects_copy()) to do the wait and release the request.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/file.c                  |  9 ++++++++-
 include/linux/ceph/osd_client.h | 21 +++++++++++----------
 net/ceph/osd_client.c           | 27 ++++++++++++++-------------
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6005b430f6f7..a39703b8ef99 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2218,6 +2218,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 {
 	struct ceph_object_locator src_oloc, dst_oloc;
 	struct ceph_object_id src_oid, dst_oid;
+	struct ceph_osd_request *req;
 	size_t bytes = 0;
 	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
 	u32 src_objlen, dst_objlen;
@@ -2243,7 +2244,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 		ceph_oid_printf(&dst_oid, "%llx.%08llx",
 				dst_ci->i_vino.ino, dst_objnum);
 		/* Do an object remote copy */
-		ret = ceph_osdc_copy_from(&fsc->client->osdc,
+		req = ceph_osdc_copy_from(&fsc->client->osdc,
 					  src_ci->i_vino.snap, 0,
 					  &src_oid, &src_oloc,
 					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
@@ -2254,6 +2255,12 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
 					  dst_ci->i_truncate_seq,
 					  dst_ci->i_truncate_size,
 					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
+		if (IS_ERR(req))
+			ret = PTR_ERR(req);
+		else {
+			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
+			ceph_osdc_put_request(req);
+		}
 		if (ret) {
 			if (ret == -EOPNOTSUPP) {
 				fsc->have_copy_from2 = false;
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 83fa08a06507..74d590cd29c9 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -515,16 +515,17 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
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
+struct ceph_osd_request *
+ceph_osdc_copy_from(struct ceph_osd_client *osdc,
+		    u64 src_snapid, u64 src_version,
+		    struct ceph_object_id *src_oid,
+		    struct ceph_object_locator *src_oloc,
+		    u32 src_fadvise_flags,
+		    struct ceph_object_id *dst_oid,
+		    struct ceph_object_locator *dst_oloc,
+		    u32 dst_fadvise_flags,
+		    u32 truncate_seq, u64 truncate_size,
+		    u8 copy_from_flags);
 
 /* watch/notify */
 struct ceph_osd_linger_request *
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a7c964..78384b431748 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5347,23 +5347,24 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
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
+struct ceph_osd_request *
+ceph_osdc_copy_from(struct ceph_osd_client *osdc,
+		    u64 src_snapid, u64 src_version,
+		    struct ceph_object_id *src_oid,
+		    struct ceph_object_locator *src_oloc,
+		    u32 src_fadvise_flags,
+		    struct ceph_object_id *dst_oid,
+		    struct ceph_object_locator *dst_oloc,
+		    u32 dst_fadvise_flags,
+		    u32 truncate_seq, u64 truncate_size,
+		    u8 copy_from_flags)
 {
 	struct ceph_osd_request *req;
 	int ret;
 
 	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
 	if (!req)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	req->r_flags = CEPH_OSD_FLAG_WRITE;
 
@@ -5382,11 +5383,11 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
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
 
