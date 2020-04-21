Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FC51B2775
	for <lists+ceph-devel@lfdr.de>; Tue, 21 Apr 2020 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgDUNTB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 Apr 2020 09:19:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:50118 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728951AbgDUNTA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 09:19:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08EE1AD88;
        Tue, 21 Apr 2020 13:18:57 +0000 (UTC)
From:   Roman Penyaev <rpenyaev@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        Roman Penyaev <rpenyaev@suse.de>
Subject: [PATCH 07/16] libceph: use new tcp_sendiov() instead of tcp_sendmsg() for messenger
Date:   Tue, 21 Apr 2020 15:18:41 +0200
Message-Id: <20200421131850.443228-8-rpenyaev@suse.de>
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
 net/ceph/messenger.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 709d9f26f755..b8ea6ce91a27 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -562,6 +562,7 @@ static int ceph_tcp_recvpage(struct socket *sock, struct page *page,
  * write something.  @more is true if caller will be sending more data
  * shortly.
  */
+__attribute__((unused))
 static int ceph_tcp_sendmsg(struct socket *sock, struct kvec *iov,
 			    size_t kvlen, size_t len, bool more)
 {
@@ -1552,13 +1553,14 @@ static int prepare_write_connect(struct ceph_connection *con)
  */
 static int write_partial_kvec(struct ceph_connection *con)
 {
+	struct iov_iter it;
 	int ret;
 
 	dout("write_partial_kvec %p %d left\n", con, con->out_kvec_bytes);
 	while (con->out_kvec_bytes > 0) {
-		ret = ceph_tcp_sendmsg(con->sock, con->out_kvec_cur,
-				       con->out_kvec_left, con->out_kvec_bytes,
-				       con->out_more);
+		iov_iter_kvec(&it, WRITE, con->out_kvec_cur,
+			      con->out_kvec_left, con->out_kvec_bytes);
+		ret = ceph_tcp_sendiov(con->sock, &it, con->out_more);
 		if (ret <= 0)
 			goto out;
 		con->out_kvec_bytes -= ret;
-- 
2.24.1

