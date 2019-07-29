Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6807788AB
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Jul 2019 11:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfG2Jna (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Jul 2019 05:43:30 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:22507 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfG2Jna (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 29 Jul 2019 05:43:30 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowADHYpWjvz5djxunAA--.901S6;
        Mon, 29 Jul 2019 17:43:00 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v3 04/15] libceph: add prefix and suffix in ceph_osd_req_op.extent
Date:   Mon, 29 Jul 2019 09:42:46 +0000
Message-Id: <1564393377-28949-5-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowADHYpWjvz5djxunAA--.901S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxWw13Wr48JFWDGFy8Wr4Uurg_yoWrCw17pF
        ZrCa1Yy3yDJ34xW392qayrur9Igr18AFW2gry7G3WfGan3JFW0vF1DtF9aqr17WF4xWFyq
        yF4jgFW5W3W2vrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0J1Uq2NUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbiRAUBelbdG2rKywAAsB
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

When we are going to support rbd journaling, we need a
prefix and suffix of ceph_osd_req_op.extent for append
op.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 include/linux/ceph/osd_client.h | 17 +++++++++++++++++
 net/ceph/osd_client.c           | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 9a4533a..873b3d8 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -97,7 +97,13 @@ struct ceph_osd_req_op {
 			u64 offset, length;
 			u64 truncate_size;
 			u32 truncate_seq;
+			// In common case, extent only need
+			// one ceph_osd_data, extent.osd_data.
+			// But in journaling, we need a prefix
+			// and suffix in append op,
+			struct ceph_osd_data prefix;
 			struct ceph_osd_data osd_data;
+			struct ceph_osd_data suffix;
 		} extent;
 		struct {
 			u32 name_len;
@@ -442,6 +448,17 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
 					 unsigned int which,
 					 struct ceph_bvec_iter *bvec_pos);
 
+
+extern void osd_req_op_extent_prefix_pages(struct ceph_osd_request *,
+					unsigned int which,
+					struct page **pages, u64 length,
+					u32 alignment, bool pages_from_pool,
+					bool own_pages);
+extern void osd_req_op_extent_suffix_pages(struct ceph_osd_request *,
+					unsigned int which,
+					struct page **pages, u64 length,
+					u32 alignment, bool pages_from_pool,
+					bool own_pages);
 extern void osd_req_op_cls_request_data_pagelist(struct ceph_osd_request *,
 					unsigned int which,
 					struct ceph_pagelist *pagelist);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 336e1c3..3d762b2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -264,6 +264,32 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_bvec_pos);
 
+void osd_req_op_extent_prefix_pages(struct ceph_osd_request *osd_req,
+			unsigned int which, struct page **pages,
+			u64 length, u32 alignment,
+			bool pages_from_pool, bool own_pages)
+{
+	struct ceph_osd_data *prefix;
+
+	prefix = osd_req_op_data(osd_req, which, extent, prefix);
+	ceph_osd_data_pages_init(prefix, pages, length, alignment,
+				pages_from_pool, own_pages);
+}
+EXPORT_SYMBOL(osd_req_op_extent_prefix_pages);
+
+void osd_req_op_extent_suffix_pages(struct ceph_osd_request *osd_req,
+			unsigned int which, struct page **pages,
+			u64 length, u32 alignment,
+			bool pages_from_pool, bool own_pages)
+{
+	struct ceph_osd_data *suffix;
+
+	suffix = osd_req_op_data(osd_req, which, extent, suffix);
+	ceph_osd_data_pages_init(suffix, pages, length, alignment,
+				pages_from_pool, own_pages);
+}
+EXPORT_SYMBOL(osd_req_op_extent_suffix_pages);
+
 static void osd_req_op_cls_request_info_pagelist(
 			struct ceph_osd_request *osd_req,
 			unsigned int which, struct ceph_pagelist *pagelist)
@@ -379,7 +405,9 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
 	case CEPH_OSD_OP_APPEND:
+		ceph_osd_data_release(&op->extent.prefix);
 		ceph_osd_data_release(&op->extent.osd_data);
+		ceph_osd_data_release(&op->extent.suffix);
 		break;
 	case CEPH_OSD_OP_CALL:
 		ceph_osd_data_release(&op->cls.request_info);
@@ -696,6 +724,8 @@ static void get_num_data_items(struct ceph_osd_request *req,
 		case CEPH_OSD_OP_WRITE:
 		case CEPH_OSD_OP_WRITEFULL:
 		case CEPH_OSD_OP_APPEND:
+			*num_request_data_items += 3;
+			break;
 		case CEPH_OSD_OP_SETXATTR:
 		case CEPH_OSD_OP_CMPXATTR:
 		case CEPH_OSD_OP_NOTIFY_ACK:
@@ -1945,8 +1975,13 @@ static void setup_request_data(struct ceph_osd_request *req)
 		case CEPH_OSD_OP_WRITEFULL:
 		case CEPH_OSD_OP_APPEND:
 			WARN_ON(op->indata_len != op->extent.length);
+			// op->extent.prefix and op->extent.suffix can be NONE
+			ceph_osdc_msg_data_add(request_msg,
+					       &op->extent.prefix);
 			ceph_osdc_msg_data_add(request_msg,
 					       &op->extent.osd_data);
+			ceph_osdc_msg_data_add(request_msg,
+					       &op->extent.suffix);
 			break;
 		case CEPH_OSD_OP_SETXATTR:
 		case CEPH_OSD_OP_CMPXATTR:
-- 
1.8.3.1


