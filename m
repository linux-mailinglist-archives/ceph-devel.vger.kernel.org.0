Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4720ABDA85
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Sep 2019 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbfIYJJG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 25 Sep 2019 05:09:06 -0400
Received: from m97138.mail.qiye.163.com ([220.181.97.138]:21021 "EHLO
        m97138.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728260AbfIYJI0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 25 Sep 2019 05:08:26 -0400
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by smtp9 (Coremail) with SMTP id u+CowAD3dl9YLotdHDhSAg--.166S5;
        Wed, 25 Sep 2019 17:07:37 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     idryomov@gmail.com, jdillama@redhat.com
Cc:     ceph-devel@vger.kernel.org,
        Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH v4 03/12] libceph: support op append
Date:   Wed, 25 Sep 2019 09:07:25 +0000
Message-Id: <1569402454-4736-4-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
References: <1569402454-4736-1-git-send-email-dongsheng.yang@easystack.cn>
X-CM-TRANSID: u+CowAD3dl9YLotdHDhSAg--.166S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXF47XF45GrWrtry5Kr4kZwb_yoWrJFWkpF
        ZrA3yjyFW3Ja4xZFs7WFZ5t3yrJ3yvyF42qrWDKrs3Can3Jry8Z3Z8Xr9Fgr1UZF4Fg348
        CF1Y9r90qw1SvrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0J1b1CLUUUUU=
X-Originating-IP: [218.94.118.90]
X-CM-SenderInfo: 5grqw2pkhqwhp1dqwq5hdv52pwdfyhdfq/1tbifhk7elrpOTHH-AAAsm
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

we need to send append operation when we want to support journaling in kernel client.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 net/ceph/osd_client.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 62d2f54..336e1c3 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -378,6 +378,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
+	case CEPH_OSD_OP_APPEND:
 		ceph_osd_data_release(&op->extent.osd_data);
 		break;
 	case CEPH_OSD_OP_CALL:
@@ -694,6 +695,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
 		/* request */
 		case CEPH_OSD_OP_WRITE:
 		case CEPH_OSD_OP_WRITEFULL:
+		case CEPH_OSD_OP_APPEND:
 		case CEPH_OSD_OP_SETXATTR:
 		case CEPH_OSD_OP_CMPXATTR:
 		case CEPH_OSD_OP_NOTIFY_ACK:
@@ -779,13 +781,14 @@ void osd_req_op_extent_init(struct ceph_osd_request *osd_req,
 
 	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
 	       opcode != CEPH_OSD_OP_WRITEFULL && opcode != CEPH_OSD_OP_ZERO &&
-	       opcode != CEPH_OSD_OP_TRUNCATE);
+	       opcode != CEPH_OSD_OP_TRUNCATE && opcode != CEPH_OSD_OP_APPEND);
 
 	op->extent.offset = offset;
 	op->extent.length = length;
 	op->extent.truncate_size = truncate_size;
 	op->extent.truncate_seq = truncate_seq;
-	if (opcode == CEPH_OSD_OP_WRITE || opcode == CEPH_OSD_OP_WRITEFULL)
+	if (opcode == CEPH_OSD_OP_WRITE || opcode == CEPH_OSD_OP_WRITEFULL ||
+	    opcode == CEPH_OSD_OP_APPEND)
 		payload_len += length;
 
 	op->indata_len = payload_len;
@@ -807,7 +810,8 @@ void osd_req_op_extent_update(struct ceph_osd_request *osd_req,
 	BUG_ON(length > previous);
 
 	op->extent.length = length;
-	if (op->op == CEPH_OSD_OP_WRITE || op->op == CEPH_OSD_OP_WRITEFULL)
+	if (op->op == CEPH_OSD_OP_WRITE || op->op == CEPH_OSD_OP_WRITEFULL ||
+	    op->op == CEPH_OSD_OP_APPEND)
 		op->indata_len -= previous - length;
 }
 EXPORT_SYMBOL(osd_req_op_extent_update);
@@ -829,7 +833,8 @@ void osd_req_op_extent_dup_last(struct ceph_osd_request *osd_req,
 	op->extent.offset += offset_inc;
 	op->extent.length -= offset_inc;
 
-	if (op->op == CEPH_OSD_OP_WRITE || op->op == CEPH_OSD_OP_WRITEFULL)
+	if (op->op == CEPH_OSD_OP_WRITE || op->op == CEPH_OSD_OP_WRITEFULL ||
+	    op->op == CEPH_OSD_OP_APPEND)
 		op->indata_len -= offset_inc;
 }
 EXPORT_SYMBOL(osd_req_op_extent_dup_last);
@@ -969,6 +974,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
 	case CEPH_OSD_OP_READ:
 	case CEPH_OSD_OP_WRITE:
 	case CEPH_OSD_OP_WRITEFULL:
+	case CEPH_OSD_OP_APPEND:
 	case CEPH_OSD_OP_ZERO:
 	case CEPH_OSD_OP_TRUNCATE:
 		dst->extent.offset = cpu_to_le64(src->extent.offset);
@@ -1062,7 +1068,8 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
 
 	BUG_ON(opcode != CEPH_OSD_OP_READ && opcode != CEPH_OSD_OP_WRITE &&
 	       opcode != CEPH_OSD_OP_ZERO && opcode != CEPH_OSD_OP_TRUNCATE &&
-	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE);
+	       opcode != CEPH_OSD_OP_CREATE && opcode != CEPH_OSD_OP_DELETE &&
+	       opcode != CEPH_OSD_OP_APPEND);
 
 	req = ceph_osdc_alloc_request(osdc, snapc, num_ops, use_mempool,
 					GFP_NOFS);
@@ -1936,6 +1943,7 @@ static void setup_request_data(struct ceph_osd_request *req)
 		/* request */
 		case CEPH_OSD_OP_WRITE:
 		case CEPH_OSD_OP_WRITEFULL:
+		case CEPH_OSD_OP_APPEND:
 			WARN_ON(op->indata_len != op->extent.length);
 			ceph_osdc_msg_data_add(request_msg,
 					       &op->extent.osd_data);
-- 
1.8.3.1


