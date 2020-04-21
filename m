Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560C31B2781
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgDUNTO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:50120 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728952AbgDUNTA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 343C5AE44;
        Tue, 21 Apr 2020 13:18:58 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 08/16] libceph: remove unused tcp wrappers, now iov_iter is used for messenger
Date:   Tue, 21 Apr 2020 15:18:42 +0200
Message-Id: <20200421131850.443228-9-rpenyaev@suse.de>
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

Signed-off-by: Roman Penyaev <rpenyaev@suse.de>
---
 net/ceph/messenger.c | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b8ea6ce91a27..8f867c8dc481 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -538,48 +538,6 @@ static int ceph_tcp_recviov(struct socket *sock, struct iov_iter *iter)
 	return r;
 }
 
-__attribute__((unused))
-static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
-		     int page_offset, size_t length)
-{
-	struct bio_vec bvec = {
-		.bv_page = page,
-		.bv_offset = page_offset,
-		.bv_len = length
-	};
-	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL };
-	int r;
-
-	BUG_ON(page_offset + length > PAGE_SIZE);
-	iov_iter_bvec(&msg.msg_iter, READ, &bvec, 1, length);
-	r = sock_recvmsg(sock, &msg, msg.msg_flags);
-	if (r == -EAGAIN)
-		r = 0;
-	return r;
-}
-
-/*
- * write something.  @more is true if caller will be sending more data
- * shortly.
- */
-__attribute__((unused))
-static int ceph_tcp_sendmsg(struct socket *sock, struct kvec *iov,
-			    size_t kvlen, size_t len, bool more)
-{
-	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL };
-	int r;
-
-	if (more)
-		msg.msg_flags |= MSG_MORE;
-	else
-		msg.msg_flags |= MSG_EOR;  /* superfluous, but what the hell */
-
-	r = kernel_sendmsg(sock, &msg, iov, kvlen, len);
-	if (r == -EAGAIN)
-		r = 0;
-	return r;
-}
-
 /*
  * @more: either or both of MSG_MORE and MSG_SENDPAGE_NOTLAST
  */
-- 
2.24.1

