Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D921A4F7E8B
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbiDGMEe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 08:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238189AbiDGMEc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 08:04:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E264BFE9
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 05:02:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A570ACE276A
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9311FC385A7;
        Thu,  7 Apr 2022 12:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649332949;
        bh=C9LKzvGddxGURnHej3cwZzuDZ5l9V5SoaPFXKTUgG20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHRq6zzeiWx2R7pnc2Cp2KwWur+JtdwKw9Hws8lMbg8w5HwxCxpRIOShlcDftHW//
         HY4pn4OWP2USzSPO5sQTB9mbng82iz2jjuuUjxaTECxX9+T+BZn3emHEdpnl+tN5Jc
         Z/s++FKSgoBnkUmQUvnqIFPpROmz4XUDTqDadqW0sJ5xv63SnGPpVOpvz0XprbLSSv
         x03Y0pBCOF7D4OXiNUIr18+v9rjhfxRBG3s+T8S+lrbVP5m1I7f/vHcPjrF0T/FHZa
         jI31st5WWocysw6cz6w8oVG4ICQUms2hxWedu7eUch5dUc3UFvIJNjQfNpmnFnkIES
         CueVltFCQMLhg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, dhowells@redhat.com
Cc:     idryomov@gmail.com, xiubli@redhat.com, linux-cachefs@redhat.com
Subject: [RFC PATCH 3/5] ceph: Use the provided iterator in ceph_netfs_issue_op()
Date:   Thu,  7 Apr 2022 08:02:22 -0400
Message-Id: <20220407120224.76156-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407120224.76156-1-jlayton@kernel.org>
References: <20220407120224.76156-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

The netfs_read_subrequest struct now contains a persistent iterator
representing the destination buffer for a read that the network filesystem
should use.  Make ceph use this.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/addr.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index f0af362f8756..e7a7b5d29c7d 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -233,7 +233,6 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 	struct ceph_mds_request *req;
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(inode->i_sb);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	struct iov_iter iter;
 	ssize_t err = 0;
 	size_t len;
 
@@ -266,8 +265,7 @@ static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subreq)
 	}
 
 	len = min_t(size_t, iinfo->inline_len - subreq->start, subreq->len);
-	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
-	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &iter);
+	err = copy_to_iter(iinfo->inline_data + subreq->start, len, &subreq->iter);
 	if (err == 0)
 		err = -EFAULT;
 
@@ -285,7 +283,6 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req;
 	struct ceph_vino vino = ceph_vino(inode);
-	struct iov_iter iter;
 	struct page **pages;
 	size_t page_off;
 	int err = 0;
@@ -306,15 +303,14 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	dout("%s: pos=%llu orig_len=%zu len=%llu\n", __func__, subreq->start, subreq->len, len);
-	iov_iter_xarray(&iter, READ, &rreq->mapping->i_pages, subreq->start, len);
-	err = iov_iter_get_pages_alloc(&iter, &pages, len, &page_off);
+
+	err = iov_iter_get_pages_alloc(&subreq->iter, &pages, len, &page_off);
 	if (err < 0) {
 		dout("%s: iov_ter_get_pages_alloc returned %d\n", __func__, err);
 		goto out;
 	}
 
-	/* should always give us a page-aligned read */
-	WARN_ON_ONCE(page_off);
+	/* FIXME: adjust the len in req downward if necessary */
 	len = err;
 
 	osd_req_op_extent_osd_data_pages(req, 0, pages, len, 0, false, false);
-- 
2.35.1

