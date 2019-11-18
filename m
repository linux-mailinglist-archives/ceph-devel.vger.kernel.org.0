Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7284B100559
	for <lists+ceph-devel@lfdr.de>; Mon, 18 Nov 2019 13:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKRMJq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 18 Nov 2019 07:09:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:43650 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726490AbfKRMJm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 07:09:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ACB0AB20F;
        Mon, 18 Nov 2019 12:09:39 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Gregory Farnum <gfarnum@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Henriques <lhenriques@suse.com>
Subject: [RFC PATCH] ceph: switch copy_file_range to 'copy-from-notrunc' operation
Date:   Mon, 18 Nov 2019 12:09:35 +0000
Message-Id: <20191118120935.7013-3-lhenriques@suse.com>
In-Reply-To: <20191118120935.7013-1-lhenriques@suse.com>
References: <20191118120935.7013-1-lhenriques@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Instead of using the 'copy-from' operation, switch copy_file_range to the
new 'copy-from-notrunc' operation, which allows to send the truncate_seq
and truncate_size parameters.

Signed-off-by: Luis Henriques <lhenriques@suse.com>
---
 fs/ceph/file.c                  |  3 ++-
 include/linux/ceph/osd_client.h |  1 +
 include/linux/ceph/rados.h      |  1 +
 net/ceph/osd_client.c           | 18 ++++++++++++------
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d277f71abe0b..4e0d70543d8b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2075,7 +2075,8 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 			CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
 			&dst_oid, &dst_oloc,
 			CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
-			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
+			CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
+			dst_ci->i_truncate_seq, dst_ci->i_truncate_size, 0);
 		if (err) {
 			dout("ceph_osdc_copy_from returned %d\n", err);
 			if (!ret)
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index eaffbdddf89a..5a62dbd3f4c2 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -534,6 +534,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_id *dst_oid,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
+			u32 truncate_seq, u64 truncate_size,
 			u8 copy_from_flags);
 
 /* watch/notify */
diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
index 3eb0e55665b4..54bc7648fd78 100644
--- a/include/linux/ceph/rados.h
+++ b/include/linux/ceph/rados.h
@@ -256,6 +256,7 @@ extern const char *ceph_osd_state_name(int s);
 									    \
 	/* tiering */							    \
 	f(COPY_FROM,	__CEPH_OSD_OP(WR, DATA, 26),	"copy-from")	    \
+	f(COPY_FROM_NOTRUNC, __CEPH_OSD_OP(WR, DATA, 45), "copy-from-notrunc")\
 	f(COPY_GET_CLASSIC, __CEPH_OSD_OP(RD, DATA, 27), "copy-get-classic") \
 	f(UNDIRTY,	__CEPH_OSD_OP(WR, DATA, 28),	"undirty")	    \
 	f(ISDIRTY,	__CEPH_OSD_OP(RD, DATA, 29),	"isdirty")	    \
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ba45b074a362..f43ec0f5865c 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -402,7 +402,7 @@ static void osd_req_op_data_release(struct ceph_osd_request *osd_req,
 	case CEPH_OSD_OP_LIST_WATCHERS:
 		ceph_osd_data_release(&op->list_watchers.response_data);
 		break;
-	case CEPH_OSD_OP_COPY_FROM:
+	case CEPH_OSD_OP_COPY_FROM_NOTRUNC:
 		ceph_osd_data_release(&op->copy_from.osd_data);
 		break;
 	default:
@@ -697,7 +697,7 @@ static void get_num_data_items(struct ceph_osd_request *req,
 		case CEPH_OSD_OP_SETXATTR:
 		case CEPH_OSD_OP_CMPXATTR:
 		case CEPH_OSD_OP_NOTIFY_ACK:
-		case CEPH_OSD_OP_COPY_FROM:
+		case CEPH_OSD_OP_COPY_FROM_NOTRUNC:
 			*num_request_data_items += 1;
 			break;
 
@@ -1029,7 +1029,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *dst,
 	case CEPH_OSD_OP_CREATE:
 	case CEPH_OSD_OP_DELETE:
 		break;
-	case CEPH_OSD_OP_COPY_FROM:
+	case CEPH_OSD_OP_COPY_FROM_NOTRUNC:
 		dst->copy_from.snapid = cpu_to_le64(src->copy_from.snapid);
 		dst->copy_from.src_version =
 			cpu_to_le64(src->copy_from.src_version);
@@ -1966,7 +1966,7 @@ static void setup_request_data(struct ceph_osd_request *req)
 			ceph_osdc_msg_data_add(request_msg,
 					       &op->notify_ack.request_data);
 			break;
-		case CEPH_OSD_OP_COPY_FROM:
+		case CEPH_OSD_OP_COPY_FROM_NOTRUNC:
 			ceph_osdc_msg_data_add(request_msg,
 					       &op->copy_from.osd_data);
 			break;
@@ -5315,6 +5315,7 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 				     struct ceph_object_locator *src_oloc,
 				     u32 src_fadvise_flags,
 				     u32 dst_fadvise_flags,
+				     u32 truncate_seq, u64 truncate_size,
 				     u8 copy_from_flags)
 {
 	struct ceph_osd_req_op *op;
@@ -5325,7 +5326,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
-	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM, dst_fadvise_flags);
+	op = _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM_NOTRUNC,
+			      dst_fadvise_flags);
 	op->copy_from.snapid = src_snapid;
 	op->copy_from.src_version = src_version;
 	op->copy_from.flags = copy_from_flags;
@@ -5335,6 +5337,8 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
 	end = p + PAGE_SIZE;
 	ceph_encode_string(&p, end, src_oid->name, src_oid->name_len);
 	encode_oloc(&p, end, src_oloc);
+	ceph_encode_32(&p, truncate_seq);
+	ceph_encode_64(&p, truncate_size);
 	op->indata_len = PAGE_SIZE - (end - p);
 
 	ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
@@ -5350,6 +5354,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 			struct ceph_object_id *dst_oid,
 			struct ceph_object_locator *dst_oloc,
 			u32 dst_fadvise_flags,
+			u32 truncate_seq, u64 truncate_size,
 			u8 copy_from_flags)
 {
 	struct ceph_osd_request *req;
@@ -5366,7 +5371,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
 
 	ret = osd_req_op_copy_from_init(req, src_snapid, src_version, src_oid,
 					src_oloc, src_fadvise_flags,
-					dst_fadvise_flags, copy_from_flags);
+					dst_fadvise_flags, truncate_seq,
+					truncate_size, copy_from_flags);
 	if (ret)
 		goto out;
 
