Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDCC736F66
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Jun 2023 16:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233098AbjFTO6A (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 20 Jun 2023 10:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjFTO57 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 20 Jun 2023 10:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E8C19B5
        for <ceph-devel@vger.kernel.org>; Tue, 20 Jun 2023 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687273011;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fSQZQ6YboxRaXsiohOL5R9kf0uRRv2lhrE9A+pyCn4U=;
        b=SHENJ0GSgIz2mdkumGas7Cs2l6K5ZNRKKmEXaM4lGYfAACsrJ0IYxXAkUhq4MZfGYCbnJN
        wl6GSYJj48n2SmJ2lJERwGzwKtdmwIzS5fDvAmYS9Jp+MPmwOgp5/wY7mjw8wXsYsV4qWL
        jKtqbEsMmis2r/dJwYas+uN5UVsVjDU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-Z9ENlngsPYSmfCtfvR07VA-1; Tue, 20 Jun 2023 10:56:46 -0400
X-MC-Unique: Z9ENlngsPYSmfCtfvR07VA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 157BC3823A0C;
        Tue, 20 Jun 2023 14:54:18 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30210200C0DA;
        Tue, 20 Jun 2023 14:53:58 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org
Subject: [PATCH net-next v3 07/18] ceph: Use sendmsg(MSG_SPLICE_PAGES) rather than sendpage()
Date:   Tue, 20 Jun 2023 15:53:26 +0100
Message-ID: <20230620145338.1300897-8-dhowells@redhat.com>
In-Reply-To: <20230620145338.1300897-1-dhowells@redhat.com>
References: <20230620145338.1300897-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Use sendmsg() and MSG_SPLICE_PAGES rather than sendpage in ceph when
transmitting data.  For the moment, this can only transmit one page at a
time because of the architecture of net/ceph/, but if
write_partial_message_data() can be given a bvec[] at a time by the
iteration code, this would allow pages to be sent in a batch.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Xiubo Li <xiubli@redhat.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
cc: ceph-devel@vger.kernel.org
cc: netdev@vger.kernel.org
---
 net/ceph/messenger_v2.c | 91 +++++++++--------------------------------
 1 file changed, 19 insertions(+), 72 deletions(-)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 301a991dc6a6..87ac97073e75 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -117,91 +117,38 @@ static int ceph_tcp_recv(struct ceph_connection *con)
 	return ret;
 }
 
-static int do_sendmsg(struct socket *sock, struct iov_iter *it)
-{
-	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
-	int ret;
-
-	msg.msg_iter = *it;
-	while (iov_iter_count(it)) {
-		ret = sock_sendmsg(sock, &msg);
-		if (ret <= 0) {
-			if (ret == -EAGAIN)
-				ret = 0;
-			return ret;
-		}
-
-		iov_iter_advance(it, ret);
-	}
-
-	WARN_ON(msg_data_left(&msg));
-	return 1;
-}
-
-static int do_try_sendpage(struct socket *sock, struct iov_iter *it)
-{
-	struct msghdr msg = { .msg_flags = CEPH_MSG_FLAGS };
-	struct bio_vec bv;
-	int ret;
-
-	if (WARN_ON(!iov_iter_is_bvec(it)))
-		return -EINVAL;
-
-	while (iov_iter_count(it)) {
-		/* iov_iter_iovec() for ITER_BVEC */
-		bvec_set_page(&bv, it->bvec->bv_page,
-			      min(iov_iter_count(it),
-				  it->bvec->bv_len - it->iov_offset),
-			      it->bvec->bv_offset + it->iov_offset);
-
-		/*
-		 * sendpage cannot properly handle pages with
-		 * page_count == 0, we need to fall back to sendmsg if
-		 * that's the case.
-		 *
-		 * Same goes for slab pages: skb_can_coalesce() allows
-		 * coalescing neighboring slab objects into a single frag
-		 * which triggers one of hardened usercopy checks.
-		 */
-		if (sendpage_ok(bv.bv_page)) {
-			ret = sock->ops->sendpage(sock, bv.bv_page,
-						  bv.bv_offset, bv.bv_len,
-						  CEPH_MSG_FLAGS);
-		} else {
-			iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bv, 1, bv.bv_len);
-			ret = sock_sendmsg(sock, &msg);
-		}
-		if (ret <= 0) {
-			if (ret == -EAGAIN)
-				ret = 0;
-			return ret;
-		}
-
-		iov_iter_advance(it, ret);
-	}
-
-	return 1;
-}
-
 /*
  * Write as much as possible.  The socket is expected to be corked,
- * so we don't bother with MSG_MORE/MSG_SENDPAGE_NOTLAST here.
+ * so we don't bother with MSG_MORE here.
  *
  * Return:
- *   1 - done, nothing (else) to write
+ *  >0 - done, nothing (else) to write
  *   0 - socket is full, need to wait
  *  <0 - error
  */
 static int ceph_tcp_send(struct ceph_connection *con)
 {
+	struct msghdr msg = {
+		.msg_iter	= con->v2.out_iter,
+		.msg_flags	= CEPH_MSG_FLAGS,
+	};
 	int ret;
 
+	if (WARN_ON(!iov_iter_is_bvec(&con->v2.out_iter)))
+		return -EINVAL;
+
+	if (con->v2.out_iter_sendpage)
+		msg.msg_flags |= MSG_SPLICE_PAGES;
+
 	dout("%s con %p have %zu try_sendpage %d\n", __func__, con,
 	     iov_iter_count(&con->v2.out_iter), con->v2.out_iter_sendpage);
-	if (con->v2.out_iter_sendpage)
-		ret = do_try_sendpage(con->sock, &con->v2.out_iter);
-	else
-		ret = do_sendmsg(con->sock, &con->v2.out_iter);
+
+	ret = sock_sendmsg(con->sock, &msg);
+	if (ret > 0)
+		iov_iter_advance(&con->v2.out_iter, ret);
+	else if (ret == -EAGAIN)
+		ret = 0;
+
 	dout("%s con %p ret %d left %zu\n", __func__, con, ret,
 	     iov_iter_count(&con->v2.out_iter));
 	return ret;

