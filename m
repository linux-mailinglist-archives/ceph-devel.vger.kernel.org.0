Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7A4EF8A1
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 19:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349472AbiDARHa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 13:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347873AbiDARH2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 13:07:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB266176655
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 10:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C8C561D02
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 17:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E45C340EE;
        Fri,  1 Apr 2022 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648832737;
        bh=34zVsBc2kIOaWFGV4yEyYojgcbQkIe2ki6ZyTRUz99o=;
        h=From:To:Cc:Subject:Date:From;
        b=qXzb0z1B6EGMTK8nrgzKPX4GJhYVj46RQ3iQpyKvjq/NMtD0BwmtMQSorkVZ5H4H6
         5fXb6SQllPtQtpH6//CQ++ZGuH4U9UqhkjhJaFcCDB0ypzpQQdUWx7PYrQN6Bx5zK5
         KRJ+6666kYVvG1wYFDcArNsMGlXfcDXfsxYf4/WGDNy+B7xbm8gMf1ayzrjdDKecn8
         y0uuv8Fn/CUthOL2YZCDUv/3Mbnx6DhgUqucKjTjOWyZ7KZYsa53WnH5B+a6nabyaA
         BaUtq/NIebjRFaJfkYhGOkjtykkiTuLE5LWRxv56+5uX9VK2k4nFBz9CRGAqm+e1u4
         YC+1oqFpYUh/w==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        dongsheng.yang@easystack.cn
Cc:     xiubli@redhat.com
Subject: [RFC PATCH] rbd: add support for sparse reads
Date:   Fri,  1 Apr 2022 13:05:35 -0400
Message-Id: <20220401170535.57853-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
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

Add a "sparseread" krbd option that makes it use sparse reads instead of
normal reads. It's not clear whether this adds any performance benefit
on its own, but it may help with large, sparse devices.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 drivers/block/rbd.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

This obviously relies on the sparse read infrastructure that's in the
testing branch.

I'm testing this now and it seems to work.  I tested this with a patch
that forced sparse reads on, though.  I couldn't really test the
"sparseread" option as that required support in the userland rbd utility
and I was too lazy to want to build and install it for testing.

No idea whether this is useful for anything, but since we have sparse
read support in libceph we might as well allow rbd to use it.

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 349038071ccd..47f9d7284a15 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -791,6 +791,7 @@ enum {
 	Opt_lock_on_read,
 	Opt_exclusive,
 	Opt_notrim,
+	Opt_sparseread,
 };
 
 enum {
@@ -820,6 +821,7 @@ static const struct fs_parameter_spec rbd_parameters[] = {
 	fsparam_flag	("read_write",			Opt_read_write),
 	fsparam_flag	("ro",				Opt_read_only),
 	fsparam_flag	("rw",				Opt_read_write),
+	fsparam_flag	("sparseread",			Opt_sparseread),
 	{}
 };
 
@@ -831,6 +833,7 @@ struct rbd_options {
 	bool	lock_on_read;
 	bool	exclusive;
 	bool	trim;
+	bool	sparseread;
 
 	u32 alloc_hint_flags;  /* CEPH_OSD_OP_ALLOC_HINT_FLAG_* */
 };
@@ -842,6 +845,7 @@ struct rbd_options {
 #define RBD_LOCK_ON_READ_DEFAULT false
 #define RBD_EXCLUSIVE_DEFAULT	false
 #define RBD_TRIM_DEFAULT	true
+#define RBD_SPARSEREAD_DEFAULT	false
 
 struct rbd_parse_opts_ctx {
 	struct rbd_spec		*spec;
@@ -1379,6 +1383,8 @@ static void rbd_osd_req_callback(struct ceph_osd_request *osd_req)
 	 */
 	if (osd_req->r_result > 0 && rbd_img_is_write(obj_req->img_request))
 		result = 0;
+	else if (osd_req->r_result > 0 && osd_req->r_reply->sparse_read)
+		result = ceph_sparse_ext_map_end(&osd_req->r_ops[0]);
 	else
 		result = osd_req->r_result;
 
@@ -2753,14 +2759,23 @@ static bool rbd_obj_may_exist(struct rbd_obj_request *obj_req)
 static int rbd_obj_read_object(struct rbd_obj_request *obj_req)
 {
 	struct ceph_osd_request *osd_req;
+	bool sparse = obj_req->img_request->rbd_dev->opts->sparseread;
 	int ret;
 
 	osd_req = __rbd_obj_add_osd_request(obj_req, NULL, 1);
 	if (IS_ERR(osd_req))
 		return PTR_ERR(osd_req);
 
-	osd_req_op_extent_init(osd_req, 0, CEPH_OSD_OP_READ,
+	osd_req_op_extent_init(osd_req, 0,
+			       sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
 			       obj_req->ex.oe_off, obj_req->ex.oe_len, 0, 0);
+
+	if (sparse) {
+		ret = ceph_alloc_sparse_ext_map(&osd_req->r_ops[0]);
+		if (ret)
+			return ret;
+	}
+
 	rbd_osd_setup_data(osd_req, 0);
 	rbd_osd_format_read(osd_req);
 
@@ -4743,6 +4758,7 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
 	struct ceph_osd_request *req;
 	struct page **pages;
+	bool sparse = rbd_dev->opts->sparseread;
 	int num_pages = calc_pages_for(0, buf_len);
 	int ret;
 
@@ -4760,10 +4776,18 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
 		goto out_req;
 	}
 
-	osd_req_op_extent_init(req, 0, CEPH_OSD_OP_READ, 0, buf_len, 0, 0);
+	osd_req_op_extent_init(req, 0,
+			       sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ,
+			       0, buf_len, 0, 0);
 	osd_req_op_extent_osd_data_pages(req, 0, pages, buf_len, 0, false,
 					 true);
 
+	if (sparse) {
+		ret = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
+		if (ret)
+			goto out_req;
+	}
+
 	ret = ceph_osdc_alloc_messages(req, GFP_KERNEL);
 	if (ret)
 		goto out_req;
@@ -6312,6 +6336,9 @@ static int rbd_parse_param(struct fs_parameter *param,
 	case Opt_notrim:
 		opt->trim = false;
 		break;
+	case Opt_sparseread:
+		opt->sparseread = true;
+		break;
 	default:
 		BUG();
 	}
@@ -6493,6 +6520,7 @@ static int rbd_add_parse_args(const char *buf,
 	pctx.opts->lock_on_read = RBD_LOCK_ON_READ_DEFAULT;
 	pctx.opts->exclusive = RBD_EXCLUSIVE_DEFAULT;
 	pctx.opts->trim = RBD_TRIM_DEFAULT;
+	pctx.opts->sparseread = RBD_SPARSEREAD_DEFAULT;
 
 	ret = ceph_parse_mon_ips(mon_addrs, mon_addrs_size, pctx.copts, NULL,
 				 ',');
-- 
2.35.1

