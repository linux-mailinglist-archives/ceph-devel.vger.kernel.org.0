Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10076563162
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Jul 2022 12:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234227AbiGAKaT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Jul 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbiGAKaS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Jul 2022 06:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452C176942
        for <ceph-devel@vger.kernel.org>; Fri,  1 Jul 2022 03:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5FAD623C4
        for <ceph-devel@vger.kernel.org>; Fri,  1 Jul 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7CBC341C6;
        Fri,  1 Jul 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656671416;
        bh=WZWPLyGyUal5XVm6zDG5dPm1+IzUkBxHYeFgZIWYF5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYuxYmoYx4eDZ59bMuy7FZgX2cQeEY5U7C6y8q/IHRJ7Bs8XVPkhFuLow0TDPDuQT
         fz0ounaI1/mou/j0vukSLi2/eCFF2aOJZPahNUd/metSeNTGUpBDuGADrrfF3wq6mR
         fHOuDtgO4BJnlFRFGJSWebe8HqBGPKf2YPl29m5CIY+xoPsjSJNP7mInX0YfqPBnyE
         mrAgtqVQxTI7g1ViD+DyLhUUxTkw5zW0ivNbcQ7jGDAj7OJJ5iuTRB7Tb/YcOE4AIf
         3nOikynC1L5esJkJfICNvNhBdxFdjWJBtRVUXNJbuQrfnlJzCqSc0Fz2JB1HT0Yfe6
         blwXvE2c1pdJg==
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v3 1/2] libceph: add new iov_iter-based ceph_msg_data_type and ceph_osd_data_type
Date:   Fri,  1 Jul 2022 06:30:12 -0400
Message-Id: <20220701103013.12902-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701103013.12902-1-jlayton@kernel.org>
References: <20220701103013.12902-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

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
---
 include/linux/ceph/messenger.h  |  8 ++++
 include/linux/ceph/osd_client.h |  4 ++
 net/ceph/messenger.c            | 84 +++++++++++++++++++++++++++++++++
 net/ceph/osd_client.c           | 27 +++++++++++
 4 files changed, 123 insertions(+)

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
index 8cfa650def2c..007c26630e5b 100644
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
index 6056c8f7dd4c..945f6d1a9efa 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -964,6 +964,69 @@ static bool ceph_msg_data_pagelist_advance(struct ceph_msg_data_cursor *cursor,
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
+	len = iov_iter_get_pages(&cursor->iov_iter, &page, PAGE_SIZE,
+				 1, page_offset);
+	BUG_ON(len < 0);
+
+	cursor->lastlen = len;
+
+	/*
+	 * FIXME: Al Viro says that he will soon change iov_iter_get_pages
+	 * to auto-advance the iterator. Emulate that here for now.
+	 */
+	iov_iter_advance(&cursor->iov_iter, len);
+
+	/*
+	 * FIXME: The assumption is that the pages represented by the iov_iter
+	 * 	  are pinned, with the references held by the upper-level
+	 * 	  callers, or by virtue of being under writeback. Eventually,
+	 * 	  we'll get an iov_iter_get_pages variant that doesn't take page
+	 * 	  refs. Until then, just put the page ref.
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
@@ -991,6 +1054,9 @@ static void __ceph_msg_data_cursor_init(struct ceph_msg_data_cursor *cursor)
 	case CEPH_MSG_DATA_BVECS:
 		ceph_msg_data_bvecs_cursor_init(cursor, length);
 		break;
+	case CEPH_MSG_DATA_ITER:
+		ceph_msg_data_iter_cursor_init(cursor, length);
+		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
 		/* BUG(); */
@@ -1038,6 +1104,9 @@ struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
 	case CEPH_MSG_DATA_BVECS:
 		page = ceph_msg_data_bvecs_next(cursor, page_offset, length);
 		break;
+	case CEPH_MSG_DATA_ITER:
+		page = ceph_msg_data_iter_next(cursor, page_offset, length);
+		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
 		page = NULL;
@@ -1076,6 +1145,9 @@ void ceph_msg_data_advance(struct ceph_msg_data_cursor *cursor, size_t bytes)
 	case CEPH_MSG_DATA_BVECS:
 		new_piece = ceph_msg_data_bvecs_advance(cursor, bytes);
 		break;
+	case CEPH_MSG_DATA_ITER:
+		new_piece = ceph_msg_data_iter_advance(cursor, bytes);
+		break;
 	case CEPH_MSG_DATA_NONE:
 	default:
 		BUG();
@@ -1874,6 +1946,18 @@ void ceph_msg_data_add_bvecs(struct ceph_msg *msg,
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
index fe674c4e943f..0e816977eccb 100644
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
2.36.1

