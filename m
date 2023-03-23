Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88D86C6017
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Mar 2023 07:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCWG5G (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Mar 2023 02:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjCWG5D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 Mar 2023 02:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58952D162
        for <ceph-devel@vger.kernel.org>; Wed, 22 Mar 2023 23:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679554576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q8ZpcKnNEwiTc0SeBz/lGWkevQhDgzTjZTdRUeiFtrY=;
        b=CtUxEF6xgrbnkVE6ZJBEL0OIRkmRcemwsW18u+jzqu5zTqcrqLDiFpsmRQWBRmECeS5o/p
        UL21fiyUiIZeFMK1+S6A2AyThvAxocFEL+4ynz2mmMjnM3cSwY2xbQAkn8Q65QuWTIYsee
        XJkDASnISe4HvtHoFTZ9OFL3BFTX5l0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-304-Ft_j9sSsN2ui8wFRE4_49Q-1; Thu, 23 Mar 2023 02:56:14 -0400
X-MC-Unique: Ft_j9sSsN2ui8wFRE4_49Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D7BC8028AD;
        Thu, 23 Mar 2023 06:56:14 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6ACF492B01;
        Thu, 23 Mar 2023 06:56:10 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v17 10/71] libceph: add new iov_iter-based ceph_msg_data_type and ceph_osd_data_type
Date:   Thu, 23 Mar 2023 14:54:24 +0800
Message-Id: <20230323065525.201322-11-xiubli@redhat.com>
In-Reply-To: <20230323065525.201322-1-xiubli@redhat.com>
References: <20230323065525.201322-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Add an iov_iter to the unions in ceph_msg_data and ceph_msg_data_cursor.
Instead of requiring a list of pages or bvecs, we can just use an
iov_iter directly, and avoid extra allocations.

We assume that the pages represented by the iter are pinned such that
they shouldn't incur page faults, which is the case for the iov_iters
created by netfs.

While working on this, Al Viro informed me that he was going to change
iov_iter_get_pages to auto-advance the iterator as that pattern is more
or less required for ITER_PIPE anyway. We emulate that here for now by
advancing in the _next op and tracking that amount in the "lastlen"
field.

In the event that _next is called twice without an intervening
_advance, we revert the iov_iter by the remaining lastlen before
calling iov_iter_get_pages.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 include/linux/ceph/messenger.h  |  8 ++++
 include/linux/ceph/osd_client.h |  4 ++
 net/ceph/messenger.c            | 78 +++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c           | 27 ++++++++++++
 4 files changed, 117 insertions(+)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 9fd7255172ad..2eaaabbe98cb 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -123,6 +123,7 @@ enum ceph_msg_data_type {
 	CEPH_MSG_DATA_BIO,	/* data source/destination is a bio list */
 #endif /* CONFIG_BLOCK */
 	CEPH_MSG_DATA_BVECS,	/* data source/destination is a bio_vec array */
+	CEPH_MSG_DATA_ITER,	/* data source/destination is an iov_iter */
 };
 
 #ifdef CONFIG_BLOCK
@@ -224,6 +225,7 @@ struct ceph_msg_data {
 			bool		own_pages;
 		};
 		struct ceph_pagelist	*pagelist;
+		struct iov_iter		iter;
 	};
 };
 
@@ -248,6 +250,10 @@ struct ceph_msg_data_cursor {
 			struct page	*page;		/* page from list */
 			size_t		offset;		/* bytes from list */
 		};
+		struct {
+			struct iov_iter		iov_iter;
+			unsigned int		lastlen;
+		};
 	};
 };
 
@@ -605,6 +611,8 @@ void ceph_msg_data_add_bio(struct ceph_msg *msg, struct ceph_bio_iter *bio_pos,
 #endif /* CONFIG_BLOCK */
 void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
 			     struct ceph_bvec_iter *bvec_pos);
+void ceph_msg_data_add_iter(struct ceph_msg *msg,
+			    struct iov_iter *iter);
 
 struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
 			       gfp_t flags, bool can_fail);
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 460881c93f9a..680b4a70f6d4 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -108,6 +108,7 @@ enum ceph_osd_data_type {
 	CEPH_OSD_DATA_TYPE_BIO,
 #endif /* CONFIG_BLOCK */
 	CEPH_OSD_DATA_TYPE_BVECS,
+	CEPH_OSD_DATA_TYPE_ITER,
 };
 
 struct ceph_osd_data {
@@ -131,6 +132,7 @@ struct ceph_osd_data {
 			struct ceph_bvec_iter	bvec_pos;
 			u32			num_bvecs;
 		};
+		struct iov_iter		iter;
 	};
 };
 
@@ -501,6 +503,8 @@ void osd_req_op_extent_osd_data_bvecs(struct ceph_osd_request *osd_req,
 void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
 					 unsigned int which,
 					 struct ceph_bvec_iter *bvec_pos);
+void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
+				unsigned int which, struct iov_iter *iter);
 
 extern void osd_req_op_cls_request_data_pagelist(struct ceph_osd_request *,
 					unsigned int which,
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3bc3c72a6d4f..9dce65fac0bd 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -969,6 +969,63 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
 	return true;
 }
 
+static void ceph_msg_data_iter_cursor_init(struct ceph_msg_data_cursor *cursor,
+					size_t length)
+{
+	struct ceph_msg_data *data = cursor->data;
+
+	cursor->iov_iter = data->iter;
+	cursor->lastlen = 0;
+	iov_iter_truncate(&cursor->iov_iter, length);
+	cursor->resid = iov_iter_count(&cursor->iov_iter);
+}
+
+static struct page *ceph_msg_data_iter_next(struct ceph_msg_data_cursor *cursor,
+						size_t *page_offset,
+						size_t *length)
+{
+	struct page *page;
+	ssize_t len;
+
+	if (cursor->lastlen)
+		iov_iter_revert(&cursor->iov_iter, cursor->lastlen);
+
+	len = iov_iter_get_pages2(&cursor->iov_iter, &page, PAGE_SIZE,
+				  1, page_offset);
+	BUG_ON(len < 0);
+
+	cursor->lastlen = len;
+
+	/*
+	 * FIXME: The assumption is that the pages represented by the iov_iter
+	 *	  are pinned, with the references held by the upper-level
+	 *	  callers, or by virtue of being under writeback. Eventually,
+	 *	  we'll get an iov_iter_get_pages2 variant that doesn't take page
+	 *	  refs. Until then, just put the page ref.
+	 */
+	VM_BUG_ON_PAGE(!PageWriteback(page) && page_count(page) < 2, page);
+	put_page(page);
+
+	*length = min_t(size_t, len, cursor->resid);
+	return page;
+}
+
+static bool ceph_msg_data_iter_advance(struct ceph_msg_data_cursor *cursor,
+					size_t bytes)
+{
+	BUG_ON(bytes > cursor->resid);
+	cursor->resid -= bytes;
+
+	if (bytes < cursor->lastlen) {
+		cursor->lastlen -= bytes;
+	} else {
+		iov_iter_advance(&cursor->iov_iter, bytes - cursor->lastlen);
+		cursor->lastlen = 0;
+	}
+
+	return cursor->resid;
+}
+
 /*
  * Message data is handled (sent or received) in pieces, where each
  * piece resides on a single page.  The network layer might not
@@ -996,6 +1053,9 @@ static void __ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor)
 	case CEPH_MSG_DATA_BVECS:
 		ceph_msg_data_bvecs_cursor_init(cursor, length);
 		break;
+	case CEPH_MSG_DATA_ITER:
+		ceph_msg_data_iter_cursor_init(cursor, length);
+		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
 		/* BUG(); */
@@ -1043,6 +1103,9 @@ struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
 	case CEPH_MSG_DATA_BVECS:
 		page = ceph_msg_data_bvecs_next(cursor, page_offset, length);
 		break;
+	case CEPH_MSG_DATA_ITER:
+		page = ceph_msg_data_iter_next(cursor, page_offset, length);
+		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
 		page = NULL;
@@ -1081,6 +1144,9 @@ void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
 	case CEPH_MSG_DATA_BVECS:
 		new_piece = ceph_msg_data_bvecs_advance(cursor, bytes);
 		break;
+	case CEPH_MSG_DATA_ITER:
+		new_piece = ceph_msg_data_iter_advance(cursor, bytes);
+		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
 		BUG();
@@ -1879,6 +1945,18 @@ void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
 }
 EXPORT_SYMBOL(ceph_msg_data_add_bvecs);
 
+void ceph_msg_data_add_iter(struct ceph_msg *msg,
+			    struct iov_iter *iter)
+{
+	struct ceph_msg_data *data;
+
+	data = ceph_msg_data_add(msg);
+	data->type = CEPH_MSG_DATA_ITER;
+	data->iter = *iter;
+
+	msg->data_length += iov_iter_count(&data->iter);
+}
+
 /*
  * construct a new message with given type, size
  * the new msg has a ref count of 1.
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 8534ca9c39b9..9138abc07f45 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -171,6 +171,13 @@ static void ceph_osd_data_bvecs_init(struct ceph_osd_data *osd_data,
 	osd_data->num_bvecs = num_bvecs;
 }
 
+static void ceph_osd_iter_init(struct ceph_osd_data *osd_data,
+			       struct iov_iter *iter)
+{
+	osd_data->type = CEPH_OSD_DATA_TYPE_ITER;
+	osd_data->iter = *iter;
+}
+
 static struct ceph_osd_data *
 osd_req_op_raw_data_in(struct ceph_osd_request *osd_req, unsigned int which)
 {
@@ -264,6 +271,22 @@ void osd_req_op_extent_osd_data_bvec_pos(struct ceph_osd_request *osd_req,
 }
 EXPORT_SYMBOL(osd_req_op_extent_osd_data_bvec_pos);
 
+/**
+ * osd_req_op_extent_osd_iter - Set up an operation with an iterator buffer
+ * @osd_req: The request to set up
+ * @which: Index of the operation in which to set the iter
+ * @iter: The buffer iterator
+ */
+void osd_req_op_extent_osd_iter(struct ceph_osd_request *osd_req,
+				unsigned int which, struct iov_iter *iter)
+{
+	struct ceph_osd_data *osd_data;
+
+	osd_data = osd_req_op_data(osd_req, which, extent, osd_data);
+	ceph_osd_iter_init(osd_data, iter);
+}
+EXPORT_SYMBOL(osd_req_op_extent_osd_iter);
+
 static void osd_req_op_cls_request_info_pagelist(
 			struct ceph_osd_request *osd_req,
 			unsigned int which, struct ceph_pagelist *pagelist)
@@ -346,6 +369,8 @@ static u64 ceph_osd_data_length(struct ceph_osd_data *osd_data)
 #endif /* CONFIG_BLOCK */
 	case CEPH_OSD_DATA_TYPE_BVECS:
 		return osd_data->bvec_pos.iter.bi_size;
+	case CEPH_OSD_DATA_TYPE_ITER:
+		return iov_iter_count(&osd_data->iter);
 	default:
 		WARN(true, "unrecognized data type %d\n", (int)osd_data->type);
 		return 0;
@@ -954,6 +979,8 @@ static void ceph_osdc_msg_data_add(struct ceph_msg *msg,
 #endif
 	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_BVECS) {
 		ceph_msg_data_add_bvecs(msg, &osd_data->bvec_pos);
+	} else if (osd_data->type == CEPH_OSD_DATA_TYPE_ITER) {
+		ceph_msg_data_add_iter(msg, &osd_data->iter);
 	} else {
 		BUG_ON(osd_data->type != CEPH_OSD_DATA_TYPE_NONE);
 	}
-- 
2.31.1

