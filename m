Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB871B277C
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgDUNTA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:50096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbgDUNTA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9A870ADED;
        Tue, 21 Apr 2020 13:18:57 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 05/16] libceph: remove unused last_piece out parameter from ceph_msg_data_next()
Date:   Tue, 21 Apr 2020 15:18:39 +0200
Message-Id: <20200421131850.443228-6-rpenyaev@suse.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200421131850.443228-1-rpenyaev@suse.de>
References: <20200421131850.443228-1-rpenyaev@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Remove it as it is not used anywhere.

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 net/ceph/messenger.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 8f35ed01a576..08786d75b990 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1137,11 +1137,9 @@ static void ceph_msg_data_cursor_init(struct ceph_msg *msg, size_t length)
 /*
  * Return the page containing the next piece to process for a given
  * data item, and supply the page offset and length of that piece.
- * Indicate whether this is the last piece in this data item.
  */
 static struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
-					size_t *page_offset, size_t *length,
-					bool *last_piece)
+					size_t *page_offset, size_t *length)
 {
 	struct page *page;
 
@@ -1170,8 +1168,6 @@ static struct page *ceph_msg_data_next(struct ceph_msg_data_cursor *cursor,
 	BUG_ON(*page_offset + *length > PAGE_SIZE);
 	BUG_ON(!*length);
 	BUG_ON(*length > cursor->resid);
-	if (last_piece)
-		*last_piece = cursor->last_piece;
 
 	return page;
 }
@@ -1589,7 +1585,7 @@ static int write_partial_message_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
+		page = ceph_msg_data_next(cursor, &page_offset, &length);
 		if (length == cursor->total_resid)
 			more = MSG_MORE;
 		ret = ceph_tcp_sendpage(con->sock, page, page_offset, length,
@@ -2336,7 +2332,7 @@ static int read_partial_msg_data(struct ceph_connection *con)
 			continue;
 		}
 
-		page = ceph_msg_data_next(cursor, &page_offset, &length, NULL);
+		page = ceph_msg_data_next(cursor, &page_offset, &length);
 		ret = ceph_tcp_recvpage(con->sock, page, page_offset, length);
 		if (ret <= 0) {
 			if (do_datacrc)
-- 
2.24.1

