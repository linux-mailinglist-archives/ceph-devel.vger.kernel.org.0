Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA3C512246
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Apr 2022 21:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiD0TTX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Apr 2022 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232854AbiD0TTN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 27 Apr 2022 15:19:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C961CB12
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 12:13:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B41A5CE2759
        for <ceph-devel@vger.kernel.org>; Wed, 27 Apr 2022 19:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCCCC385A9;
        Wed, 27 Apr 2022 19:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651086801;
        bh=gFp0s2+yOcXsxdx+8FwxESNn106vn66cOvnAIMvKYsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnfwRbZNh4F9gux4nMgBO7fEyWvVVA8Nl1gubxT8EuNOtBNJaYYdKE8uKgOEUw1Lk
         rR+Fr/TsL+mwznmW1jsvNBi7MA/Zj5nPaJdUlbYQsKmA9G1KkDJCz+MyZ81MMdH0BN
         vCJyQFz2+OyIuoyr8KPsOPVVXg06fUtFIQ08xGMEEztXzRXxX1Oj2T/xxcXgST4Xhy
         M/haZys8DM8/SKU9Yj3yHJrA5cxFSk19omUZXzRruBxa4fjE3KU0r4pnJLUaJXlR/S
         YfQvRaH5orlBR7bOviZ1FV1sceiLAOsffm98WKs02JRxEgjU6cJ7XRSIu0K/nLfX99
         uz272JJ/37KVQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     xiubli@redhat.com, lhenriques@suse.de, idryomov@gmail.com
Subject: [PATCH v14 06/64] libceph: add sparse read support to msgr1
Date:   Wed, 27 Apr 2022 15:12:16 -0400
Message-Id: <20220427191314.222867-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
References: <20220427191314.222867-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add 2 new fields to ceph_connection_v1_info to track the necessary info
in sparse reads. Skip initializing the cursor for a sparse read.

Break out read_partial_message_section into a wrapper around a new
read_partial_message_chunk function that doesn't zero out the crc first.

Add new helper functions to drive receiving into the destinations
provided by the sparse_read state machine.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  4 ++
 net/ceph/messenger_v1.c        | 98 +++++++++++++++++++++++++++++++---
 2 files changed, 94 insertions(+), 8 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 7f09a4213834..f4adbfee56d5 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -337,6 +337,10 @@ struct ceph_connection_v1_info {
 
 	int in_base_pos;     /* bytes read */
 
+	/* sparse reads */
+	struct kvec in_sr_kvec; /* current location to receive into */
+	u64 in_sr_len;		/* amount of data in this extent */
+
 	/* message in temps */
 	u8 in_tag;           /* protocol control byte */
 	struct ceph_msg_header in_hdr;
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 6b014eca3a13..bf385e458a01 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -160,9 +160,9 @@ static size_t sizeof_footer(struct ceph_connection *con)
 
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
@@ -967,9 +967,9 @@ static void process_ack(struct ceph_connection *con)
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
 
@@ -985,11 +985,91 @@ static int read_partial_message_section(struct ceph_connection *con,
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
+		page = ceph_msg_data_next(cursor, &off, &len, NULL);
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
@@ -1180,7 +1260,9 @@ static int read_partial_message(struct ceph_connection *con)
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
2.35.1

