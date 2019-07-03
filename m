Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E585E845
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfGCP71 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 11:59:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:38968 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbfGCP70 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 11:59:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2B5BAEF5
        for <ceph-devel@vger.kernel.org>; Wed,  3 Jul 2019 15:59:25 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     ceph-devel@vger.kernel.org
Cc:     David Disseldorp <ddiss@suse.de>
Subject: [PATCH] libceph: handle OSD op ceph_pagelist_append() errors
Date:   Wed,  3 Jul 2019 17:59:20 +0200
Message-Id: <20190703155920.2809-1-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

osd_req_op_cls_init() and osd_req_op_xattr_init() currently propagate
ceph_pagelist_alloc() ENOMEM errors but ignore ceph_pagelist_append()
memory allocation failures. Add these checks and cleanup on error.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 net/ceph/osd_client.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 9a8eca5eda65..83a7382bbe86 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -849,6 +849,7 @@ int osd_req_op_cls_init(struct ceph_osd_request *osd_req, unsigned int which,
 	struct ceph_pagelist *pagelist;
 	size_t payload_len = 0;
 	size_t size;
+	int ret;
 
 	op = _osd_req_op_init(osd_req, which, CEPH_OSD_OP_CALL, 0);
 
@@ -860,20 +861,28 @@ int osd_req_op_cls_init(struct ceph_osd_request *osd_req, unsigned int which,
 	size = strlen(class);
 	BUG_ON(size > (size_t) U8_MAX);
 	op->cls.class_len = size;
-	ceph_pagelist_append(pagelist, class, size);
+	ret = ceph_pagelist_append(pagelist, class, size);
+	if (ret)
+		goto err_pagelist_free;
 	payload_len += size;
 
 	op->cls.method_name = method;
 	size = strlen(method);
 	BUG_ON(size > (size_t) U8_MAX);
 	op->cls.method_len = size;
-	ceph_pagelist_append(pagelist, method, size);
+	ret = ceph_pagelist_append(pagelist, method, size);
+	if (ret)
+		goto err_pagelist_free;
 	payload_len += size;
 
 	osd_req_op_cls_request_info_pagelist(osd_req, which, pagelist);
 
 	op->indata_len = payload_len;
 	return 0;
+
+err_pagelist_free:
+	ceph_pagelist_release(pagelist);
+	return ret;
 }
 EXPORT_SYMBOL(osd_req_op_cls_init);
 
@@ -885,6 +894,7 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
 						      opcode, 0);
 	struct ceph_pagelist *pagelist;
 	size_t payload_len;
+	int ret;
 
 	BUG_ON(opcode != CEPH_OSD_OP_SETXATTR && opcode != CEPH_OSD_OP_CMPXATTR);
 
@@ -894,10 +904,14 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
 
 	payload_len = strlen(name);
 	op->xattr.name_len = payload_len;
-	ceph_pagelist_append(pagelist, name, payload_len);
+	ret = ceph_pagelist_append(pagelist, name, payload_len);
+	if (ret)
+		goto err_pagelist_free;
 
 	op->xattr.value_len = size;
-	ceph_pagelist_append(pagelist, value, size);
+	ret = ceph_pagelist_append(pagelist, value, size);
+	if (ret)
+		goto err_pagelist_free;
 	payload_len += size;
 
 	op->xattr.cmp_op = cmp_op;
@@ -906,6 +920,10 @@ int osd_req_op_xattr_init(struct ceph_osd_request *osd_req, unsigned int which,
 	ceph_osd_data_pagelist_init(&op->xattr.osd_data, pagelist);
 	op->indata_len = payload_len;
 	return 0;
+
+err_pagelist_free:
+	ceph_pagelist_release(pagelist);
+	return ret;
 }
 EXPORT_SYMBOL(osd_req_op_xattr_init);
 
-- 
2.16.4

