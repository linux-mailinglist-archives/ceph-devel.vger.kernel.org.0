Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD44EF117
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Apr 2022 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347852AbiDAOgQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 1 Apr 2022 10:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347440AbiDAOcd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 1 Apr 2022 10:32:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEEB1EF5CC
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 07:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0025C61C3C
        for <ceph-devel@vger.kernel.org>; Fri,  1 Apr 2022 14:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB7EC340EE;
        Fri,  1 Apr 2022 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823351;
        bh=a8A5xd/f++1p86nUchc8FDcl/sWPsEes1UILPMpEUX0=;
        h=From:To:Cc:Subject:Date:From;
        b=iSpjOc9RO1K64slJVYnqy4I9K7+uM8CieYZ37awb/38gRfO9FHsMsNjFEtvv08Mx9
         qd1DS15ANJgprta6356AQPTuQdyO+tua79uLKi6FnQIVugB5CjAlB1xForJ1xi3HTf
         Gi9RzFvbDR5SqtMQp+dq9ZtzJpx59JLrA+1SR4vx2OISNnLaJmuUhb9wZ1oP79wOxU
         QYAz/whtd/dbcJz1tGzs6oPmvxzIPRh7QrGFbck0vhcE1SKf+23R5+oZsZDIjTmBTh
         EurlpB3qCNRpNsgdl0ECuwqs1rY++rSU58nEml1CfDRbrqYwLRcTmjzhqdhQ44ouG2
         WK84/wZkzQ/yQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com
Subject: [PATCH] libceph: rework sparse_read API
Date:   Fri,  1 Apr 2022 10:29:09 -0400
Message-Id: <20220401142909.21894-1-jlayton@kernel.org>
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

We can just return the length to be read instead of using a separate
length pointer. We'll never need more than INT_MAX anyway.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/ceph/messenger.h |  7 +++----
 net/ceph/messenger_v1.c        |  6 +++---
 net/ceph/messenger_v2.c        | 26 ++++++++++++--------------
 net/ceph/osd_client.c          | 24 ++++++++++++++++--------
 4 files changed, 34 insertions(+), 29 deletions(-)

This is an update to the sparse read series that simplifies the new
operation. I'll probably just fold this into the patch that's sitting
in testing now since it's not merged yet.

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 3697049e1465..f4adbfee56d5 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -76,17 +76,16 @@ struct ceph_connection_operations {
 	 * sparse_read: read sparse data
 	 * @con: connection we're reading from
 	 * @cursor: data cursor for reading extents
-	 * @len: len of the data that msgr should read
 	 * @buf: optional buffer to read into
 	 *
 	 * This should be called more than once, each time setting up to
 	 * receive an extent into the current cursor position, and zeroing
 	 * the holes between them.
 	 *
-	 * Returns 1 if there is more data to be read, 0 if reading is
+	 * Returns amount of data to be read (in bytes), 0 if reading is
 	 * complete, or -errno if there was an error.
 	 *
-	 * If @buf is set on a 1 return, then the data should be read into
+	 * If @buf is set on a >0 return, then the data should be read into
 	 * the provided buffer. Otherwise, it should be read into the cursor.
 	 *
 	 * The sparse read operation is expected to initialize the cursor
@@ -94,7 +93,7 @@ struct ceph_connection_operations {
 	 */
 	int (*sparse_read)(struct ceph_connection *con,
 			   struct ceph_msg_data_cursor *cursor,
-			   u64 *len, char **buf);
+			   char **buf);
 
 };
 
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index 957ba4d4cae5..bf385e458a01 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -1059,9 +1059,9 @@ static int read_sparse_msg_data(struct ceph_connection *con)
 		}
 
 		memset(&con->v1.in_sr_kvec, 0, sizeof(con->v1.in_sr_kvec));
-		con->v1.in_sr_len = 0;
-		ret = con->ops->sparse_read(con, cursor, &con->v1.in_sr_len,
-					(char **)&con->v1.in_sr_kvec.iov_base);
+		ret = con->ops->sparse_read(con, cursor,
+				(char **)&con->v1.in_sr_kvec.iov_base);
+		con->v1.in_sr_len = ret;
 	} while (ret > 0);
 
 	if (do_datacrc)
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index c9f6b67fcdda..3dcaee6f8903 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -1088,20 +1088,19 @@ static int process_v2_sparse_read(struct ceph_connection *con, struct page **pag
 	int ret;
 
 	for (;;) {
-		u64 elen;
 		char *buf = NULL;
 
-		ret = con->ops->sparse_read(con, cursor, &elen, &buf);
+		ret = con->ops->sparse_read(con, cursor, &buf);
 		if (ret <= 0)
 			return ret;
 
-		dout("%s: sparse_read return elen %llx buf %p\n", __func__, elen, buf);
+		dout("%s: sparse_read return %x buf %p\n", __func__, ret, buf);
 
 		do {
 			int idx = spos >> PAGE_SHIFT;
 			int soff = offset_in_page(spos);
 			struct page *spage = con->v2.in_enc_pages[idx];
-			int len = min_t(int, elen, PAGE_SIZE - soff);
+			int len = min_t(int, ret, PAGE_SIZE - soff);
 
 			if (buf) {
 				memcpy_from_page(buf, spage, soff, len);
@@ -1116,8 +1115,8 @@ static int process_v2_sparse_read(struct ceph_connection *con, struct page **pag
 				ceph_msg_data_advance(cursor, len);
 			}
 			spos += len;
-			elen -= len;
-		} while (elen);
+			ret -= len;
+		} while (ret);
 	}
 }
 
@@ -1927,7 +1926,6 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 	struct bio_vec bv;
 	char *buf = NULL;
 	struct ceph_msg_data_cursor *cursor = &con->v2.in_cursor;
-	u64 len = 0;
 
 	WARN_ON(con->v2.in_state != IN_S_PREPARE_SPARSE_DATA_CONT);
 
@@ -1977,7 +1975,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 	}
 
 	/* get next extent */
-	ret = con->ops->sparse_read(con, cursor, &len, &buf);
+	ret = con->ops->sparse_read(con, cursor, &buf);
 	if (ret <= 0) {
 		if (ret < 0)
 			return ret;
@@ -1991,14 +1989,14 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 	if (buf) {
 		/* receive into buffer */
 		reset_in_kvecs(con);
-		add_in_kvec(con, buf, len);
-		con->v2.data_len_remain -= len;
+		add_in_kvec(con, buf, ret);
+		con->v2.data_len_remain -= ret;
 		return 0;
 	}
 
-	if (len > cursor->total_resid) {
-		pr_warn("%s: len 0x%llx total_resid 0x%zx resid 0x%zx last %d\n",
-			__func__, len, cursor->total_resid, cursor->resid,
+	if (ret > cursor->total_resid) {
+		pr_warn("%s: ret 0x%x total_resid 0x%zx resid 0x%zx last %d\n",
+			__func__, ret, cursor->total_resid, cursor->resid,
 			cursor->last_piece);
 		return -EIO;
 	}
@@ -2018,7 +2016,7 @@ static int prepare_sparse_read_cont(struct ceph_connection *con)
 		bv.bv_offset = 0;
 	}
 	set_in_bvec(con, &bv);
-	con->v2.data_len_remain -= len;
+	con->v2.data_len_remain -= ret;
 	return ret;
 }
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index cb199a3f3caf..5cb7635bb457 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -5881,7 +5881,7 @@ static inline void convert_extent_map(struct ceph_sparse_read *sr)
 
 static int osd_sparse_read(struct ceph_connection *con,
 			   struct ceph_msg_data_cursor *cursor,
-			   u64 *plen, char **pbuf)
+			   char **pbuf)
 {
 	struct ceph_osd *o = con->private;
 	struct ceph_sparse_read *sr = &o->o_sparse_read;
@@ -5897,7 +5897,7 @@ static int osd_sparse_read(struct ceph_connection *con,
 			return ret;
 
 		/* number of extents */
-		*plen = sizeof(sr->sr_count);
+		ret = sizeof(sr->sr_count);
 		*pbuf = (char *)&sr->sr_count;
 		sr->sr_state = CEPH_SPARSE_READ_EXTENTS;
 		break;
@@ -5913,8 +5913,11 @@ static int osd_sparse_read(struct ceph_connection *con,
 				 * Apply a hard cap to the number of extents.
 				 * If we have more, assume something is wrong.
 				 */
-				if (count > MAX_EXTENTS)
-					return -EIO;
+				if (count > MAX_EXTENTS) {
+					dout("%s: OSD returned 0x%x extents in a single reply!\n",
+						  __func__, count);
+					return -EREMOTEIO;
+				}
 
 				/* no extent array provided, or too short */
 				kfree(sr->sr_extent);
@@ -5925,7 +5928,7 @@ static int osd_sparse_read(struct ceph_connection *con,
 					return -ENOMEM;
 				sr->sr_ext_len = count;
 			}
-			*plen = count * sizeof(*sr->sr_extent);
+			ret = count * sizeof(*sr->sr_extent);
 			*pbuf = (char *)sr->sr_extent;
 			sr->sr_state = CEPH_SPARSE_READ_DATA_LEN;
 			break;
@@ -5934,7 +5937,7 @@ static int osd_sparse_read(struct ceph_connection *con,
 		fallthrough;
 	case CEPH_SPARSE_READ_DATA_LEN:
 		convert_extent_map(sr);
-		*plen = sizeof(sr->sr_datalen);
+		ret = sizeof(sr->sr_datalen);
 		*pbuf = (char *)&sr->sr_datalen;
 		sr->sr_state = CEPH_SPARSE_READ_DATA;
 		break;
@@ -5950,6 +5953,11 @@ static int osd_sparse_read(struct ceph_connection *con,
 		dout("[%d] ext %d off 0x%llx len 0x%llx\n",
 		     o->o_osd, sr->sr_index, eoff, elen);
 
+		if (elen > INT_MAX) {
+			dout("Sparse read extent length too long (0x%llx)\n", elen);
+			return -EREMOTEIO;
+		}
+
 		/* zero out anything from sr_pos to start of extent */
 		if (sr->sr_pos < eoff)
 			advance_cursor(cursor, eoff - sr->sr_pos, true);
@@ -5959,14 +5967,14 @@ static int osd_sparse_read(struct ceph_connection *con,
 
 		/* send back the new length and nullify the ptr */
 		cursor->sr_resid = elen;
-		*plen = elen;
+		ret = elen;
 		*pbuf = NULL;
 
 		/* Bump the array index */
 		++sr->sr_index;
 		break;
 	}
-	return 1;
+	return ret;
 }
 
 static const struct ceph_connection_operations osd_con_ops = {
-- 
2.35.1

