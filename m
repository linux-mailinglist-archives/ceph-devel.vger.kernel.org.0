Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A17D72D915
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 07:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239982AbjFMF16 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 01:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbjFMF1y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 01:27:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64251B3
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 22:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686634027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mVOQL9SB2tFa6VMhveItlvKrFpHDiHCsFFoknzz6J8o=;
        b=IOfcjStmR8uSmF8G2CljcnguVGWTVu8I03kiTLB2j/8xBHFWv2CwuITV7Nc/KgNQ4F654D
        W4kIsnpLe20GiOO/uXpGupkYm0SVDtluI+amlMxRNHY4FirHQb//u/y4jAdE2uc7E4d6d7
        8leGa0MWEcab8FWAIqGog0zrybUBf/I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-cfOVNOBRN-qHSE72yWTSfw-1; Tue, 13 Jun 2023 01:27:05 -0400
X-MC-Unique: cfOVNOBRN-qHSE72yWTSfw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E1133814949;
        Tue, 13 Jun 2023 05:27:05 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-155.pek2.redhat.com [10.72.12.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C7D11121314;
        Tue, 13 Jun 2023 05:27:01 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, mchangir@redhat.com,
        lhenriques@suse.de, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH v20 06/71] libceph: add sparse read support to msgr1
Date:   Tue, 13 Jun 2023 13:23:19 +0800
Message-Id: <20230613052424.254540-7-xiubli@redhat.com>
In-Reply-To: <20230613052424.254540-1-xiubli@redhat.com>
References: <20230613052424.254540-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

Add 2 new fields to ceph_connection_v1_info to track the necessary info
in sparse reads. Skip initializing the cursor for a sparse read.

Break out read_partial_message_section into a wrapper around a new
read_partial_message_chunk function that doesn't zero out the crc first.

Add new helper functions to drive receiving into the destinations
provided by the sparse_read state machine.

Tested-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Luís Henriques <lhenriques@suse.de>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  4 ++
 net/ceph/messenger_v1.c        | 98 +++++++++++++++++++++++++++++++---
 2 files changed, 94 insertions(+), 8 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 8a6938fa324e..9fd7255172ad 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -336,6 +336,10 @@ struct ceph_connection_v1_info {
 
 	int in_base_pos;     /* bytes read */
 
+	/* sparse reads */
+	struct kvec in_sr_kvec; /* current location to receive into */
+	u64 in_sr_len;		/* amount of data in this extent */
+
 	/* message in temps */
 	u8 in_tag;           /* protocol control byte */
 	struct ceph_msg_header in_hdr;
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index d664cb1593a7..f13e96f7f4cc 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -157,9 +157,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
 
 static void prepare_message_data(struct ceph_msg *msg, u32 data_len)
 {
-	/* Initialize data cursor */
-
-	ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
+	/* Initialize data cursor if it's not a sparse read */
+	if (!msg->sparse_read)
+		ceph_msg_data_cursor_init(&msg->cursor, msg, data_len);
 }
 
 /*
@@ -964,9 +964,9 @@ static void process_ack(struct ceph_connection *con)
 	prepare_read_tag(con);
 }
 
-static int read_partial_message_section(struct ceph_connection *con,
-					struct kvec *section,
-					unsigned int sec_len, u32 *crc)
+static int read_partial_message_chunk(struct ceph_connection *con,
+				      struct kvec *section,
+				      unsigned int sec_len, u32 *crc)
 {
 	int ret, left;
 
@@ -982,11 +982,91 @@ static int read_partial_message_section(struct ceph_connection *con,
 		section->iov_len += ret;
 	}
 	if (section->iov_len == sec_len)
-		*crc = crc32c(0, section->iov_base, section->iov_len);
+		*crc = crc32c(*crc, section->iov_base, section->iov_len);
 
 	return 1;
 }
 
+static inline int read_partial_message_section(struct ceph_connection *con,
+					       struct kvec *section,
+					       unsigned int sec_len, u32 *crc)
+{
+	*crc = 0;
+	return read_partial_message_chunk(con, section, sec_len, crc);
+}
+
+static int read_sparse_msg_extent(struct ceph_connection *con, u32 *crc)
+{
+	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
+	bool do_bounce = ceph_test_opt(from_msgr(con->msgr), RXBOUNCE);
+
+	if (do_bounce && unlikely(!con->bounce_page)) {
+		con->bounce_page = alloc_page(GFP_NOIO);
+		if (!con->bounce_page) {
+			pr_err("failed to allocate bounce page\n");
+			return -ENOMEM;
+		}
+	}
+
+	while (cursor->sr_resid > 0) {
+		struct page *page, *rpage;
+		size_t off, len;
+		int ret;
+
+		page = ceph_msg_data_next(cursor, &off, &len);
+		rpage = do_bounce ? con->bounce_page : page;
+
+		/* clamp to what remains in extent */
+		len = min_t(int, len, cursor->sr_resid);
+		ret = ceph_tcp_recvpage(con->sock, rpage, (int)off, len);
+		if (ret <= 0)
+			return ret;
+		*crc = ceph_crc32c_page(*crc, rpage, off, ret);
+		ceph_msg_data_advance(cursor, (size_t)ret);
+		cursor->sr_resid -= ret;
+		if (do_bounce)
+			memcpy_page(page, off, rpage, off, ret);
+	}
+	return 1;
+}
+
+static int read_sparse_msg_data(struct ceph_connection *con)
+{
+	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
+	bool do_datacrc = !ceph_test_opt(from_msgr(con->msgr), NOCRC);
+	u32 crc = 0;
+	int ret = 1;
+
+	if (do_datacrc)
+		crc = con->in_data_crc;
+
+	do {
+		if (con->v1.in_sr_kvec.iov_base)
+			ret = read_partial_message_chunk(con,
+							 &con->v1.in_sr_kvec,
+							 con->v1.in_sr_len,
+							 &crc);
+		else if (cursor->sr_resid > 0)
+			ret = read_sparse_msg_extent(con, &crc);
+
+		if (ret <= 0) {
+			if (do_datacrc)
+				con->in_data_crc = crc;
+			return ret;
+		}
+
+		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
+		ret = con->ops->sparse_read(con, cursor,
+				(char **)&con->v1.in_sr_kvec.iov_base);
+		con->v1.in_sr_len = ret;
+	} while (ret > 0);
+
+	if (do_datacrc)
+		con->in_data_crc = crc;
+
+	return ret < 0 ? ret : 1;	/* must return > 0 to indicate success */
+}
+
 static int read_partial_msg_data(struct ceph_connection *con)
 {
 	struct ceph_msg_data_cursor *cursor = &con->in_msg->cursor;
@@ -1177,7 +1257,9 @@ static int read_partial_message(struct ceph_connection *con)
 		if (!m->num_data_items)
 			return -EIO;
 
-		if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
+		if (m->sparse_read)
+			ret = read_sparse_msg_data(con);
+		else if (ceph_test_opt(from_msgr(con->msgr), RXBOUNCE))
 			ret = read_partial_msg_data_bounce(con);
 		else
 			ret = read_partial_msg_data(con);
-- 
2.40.1

