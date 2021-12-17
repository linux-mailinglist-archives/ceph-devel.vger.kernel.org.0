Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B7547954B
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Dec 2021 21:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbhLQUNO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 17 Dec 2021 15:13:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51454 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232947AbhLQUNN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 15:13:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639771992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gX+kh1O+BW3fiFznz3bOXND1mMhp26Ig2EgX/aw02R4=;
        b=PpDwLV3WB4aQTMVLGFVQuwywC16Lm+EyWXFjvJrfzp0x2QAw9oQAhe1l2LoT2wOQa94wLd
        eY6Tv4IZfEN9TjaPZmkOdLOmql8zTzIAr8J26i6y/YG0wlBT+suSaOv7o+jnWMkDqXofGz
        tXThG6du53z0sluS9AaIdh4ULLeve/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-m-HIckpqP4KC7wLMLnlKmg-1; Fri, 17 Dec 2021 15:13:09 -0500
X-MC-Unique: m-HIckpqP4KC7wLMLnlKmg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A0D4100C610;
        Fri, 17 Dec 2021 20:13:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 264A35C1A1;
        Fri, 17 Dec 2021 20:13:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] ceph: Make ceph_netfs_issue_op() handle inlined data
 (untested)
From:   David Howells <dhowells@redhat.com>
To:     jlayton@kernel.org
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        dhowells@redhat.com, linux-fsdevel@vger.kernel.org
Date:   Fri, 17 Dec 2021 20:13:06 +0000
Message-ID: <163977198611.2082978.4748242515627648240.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Here's a first stab at making ceph_netfs_issue_op() handle inlined data on
page 0.  The code that's upstream *ought* to be doing this in
ceph_readpage() as the page isn't pinned and could get discarded under
memory pressure from what I can see.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: ceph-devel@vger.kernel.org
---

 fs/ceph/addr.c |   79 ++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 62 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 553e2b5653f3..b72f77fe32f2 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -244,6 +244,61 @@ static void finish_netfs_read(struct ceph_osd_request *req)
 	iput(req->r_inode);
 }
 
+static bool ceph_netfs_issue_op_inline(struct netfs_read_subrequest *subreq)
+{
+	struct netfs_read_request *rreq = subreq->rreq;
+	struct inode *inode = rreq->inode;
+	struct ceph_mds_reply_info_parsed *rinfo;
+	struct ceph_mds_reply_info_in *iinfo;
+	struct ceph_mds_request *req;
+	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct iov_iter iter;
+	ssize_t err = 0;
+	size_t len;
+
+	__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
+	__clear_bit(NETFS_SREQ_WRITE_TO_CACHE, &subreq->flags);
+
+	if (subreq->start >= inode->i_size || subreq->start >= 4096)
+		goto out;
+
+	/* We need to fetch the inline data. */
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR, USE_ANY_MDS);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out;
+	}
+	req->r_ino1 = ci->i_vino;
+	req->r_args.getattr.mask = cpu_to_le32(CEPH_STAT_CAP_INLINE_DATA);
+	req->r_num_caps = 2;
+
+	err = ceph_mdsc_do_request(mdsc, NULL, req);
+	if (err < 0)
+		goto out;
+
+	rinfo = &req->r_reply_info;
+	iinfo = &rinfo->targeti;
+	if (iinfo->inline_version == CEPH_INLINE_NONE) {
+		/* The data got uninlined */
+		ceph_mdsc_put_request(req);
+		return false;
+	}
+
+	len = min_t(size_t, 4096 - subreq->start, iinfo->inline_len);
+	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
+
+	err = copy_to_iter(iinfo->inline_data, len, &iter);
+	if (err == 0)
+		err = -EFAULT;
+
+	ceph_mdsc_put_request(req);
+
+out:
+	netfs_subreq_terminated(subreq, err, false);
+	return true;
+}
+
 static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 {
 	struct netfs_read_request *rreq = subreq->rreq;
@@ -258,6 +313,10 @@ static void ceph_netfs_issue_op(struct netfs_read_subrequest *subreq)
 	int err = 0;
 	u64 len = subreq->len;
 
+	if (ci->i_inline_version != CEPH_INLINE_NONE &&
+	    ceph_netfs_issue_op_inline(subreq))
+		return;
+
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout, vino, subreq->start, &len,
 			0, 1, CEPH_OSD_OP_READ,
 			CEPH_OSD_FLAG_READ | fsc->client->osdc.client->options->read_from_replica,
@@ -331,23 +390,9 @@ static int ceph_readpage(struct file *file, struct page *subpage)
 	size_t len = folio_size(folio);
 	u64 off = folio_file_pos(folio);
 
-	if (ci->i_inline_version != CEPH_INLINE_NONE) {
-		/*
-		 * Uptodate inline data should have been added
-		 * into page cache while getting Fcr caps.
-		 */
-		if (off == 0) {
-			folio_unlock(folio);
-			return -EINVAL;
-		}
-		zero_user_segment(&folio->page, 0, folio_size(folio));
-		folio_mark_uptodate(folio);
-		folio_unlock(folio);
-		return 0;
-	}
-
-	dout("readpage ino %llx.%llx file %p off %llu len %zu folio %p index %lu\n",
-	     vino.ino, vino.snap, file, off, len, folio, folio_index(folio));
+	if (ci->i_inline_version == CEPH_INLINE_NONE)
+		dout("readpage ino %llx.%llx file %p off %llu len %zu folio %p index %lu\n",
+		     vino.ino, vino.snap, file, off, len, folio, folio_index(folio));
 
 	return netfs_readpage(file, folio, &ceph_netfs_read_ops, NULL);
 }


