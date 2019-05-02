Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8911E8D
	for <lists+ceph-devel@lfdr.de>; Thu,  2 May 2019 17:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfEBPiD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 May 2019 11:38:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbfEBPiC (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 May 2019 11:38:02 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98C9E21670;
        Thu,  2 May 2019 15:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811481;
        bh=dSvu9a54pr6ei11knBmt/NP04KKTmyWJM8C3MTj6vIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KVauYNmV12MXJPCW4UVq/XKEdtYliU05M+QbL2D7aKllwVlpiPnNdprzgO/6b93l
         Q8NZfIa2bb6iMWo3Hw5F9YGLVLhL2RfCd4yomXmkj8KjjEHY4gwZ4bUHafL1BljnKY
         E7pkxhWLsUh+KCQtBTq3Ynzk+KbqqAcsedezEHWk=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH 3/3] libceph: fix unaligned accesses
Date:   Thu,  2 May 2019 11:37:57 -0400
Message-Id: <20190502153757.29038-3-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502153757.29038-1-jlayton@kernel.org>
References: <20190502153757.29038-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

GCC9 is throwing a lot of warnings about unaligned access. This patch
fixes them up by changing most of the helper functions to take a
struct ceph_entity_addr instead.

The exception is when setting the port in a sockaddr_storage. For that
I ended up making a completely separate function to handle setting the
port inside a struct ceph_entity_addr.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger.c | 55 ++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 38a4db87c756..2d4ae261011c 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -449,7 +449,7 @@ static void set_sock_callbacks(struct socket *sock,
  */
 static int ceph_tcp_connect(struct ceph_connection *con)
 {
-	struct sockaddr_storage *paddr = &con->peer_addr.in_addr;
+	struct sockaddr_storage addr = con->peer_addr.in_addr;
 	struct socket *sock;
 	unsigned int noio_flag;
 	int ret;
@@ -458,7 +458,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 
 	/* sock_create_kern() allocates with GFP_KERNEL */
 	noio_flag = memalloc_noio_save();
-	ret = sock_create_kern(read_pnet(&con->msgr->net), paddr->ss_family,
+	ret = sock_create_kern(read_pnet(&con->msgr->net), addr.ss_family,
 			       SOCK_STREAM, IPPROTO_TCP, &sock);
 	memalloc_noio_restore(noio_flag);
 	if (ret)
@@ -474,7 +474,7 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 	dout("connect %s\n", ceph_pr_addr(&con->peer_addr));
 
 	con_sock_state_connecting(con);
-	ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
+	ret = sock->ops->connect(sock, (struct sockaddr *)&addr, sizeof(addr),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
 		dout("connect %s EINPROGRESS sk_state = %u\n",
@@ -1794,12 +1794,13 @@ static int verify_hello(struct ceph_connection *con)
 	return 0;
 }
 
-static bool addr_is_blank(struct sockaddr_storage *ss)
+static bool addr_is_blank(struct ceph_entity_addr *ea)
 {
-	struct in_addr *addr = &((struct sockaddr_in *)ss)->sin_addr;
-	struct in6_addr *addr6 = &((struct sockaddr_in6 *)ss)->sin6_addr;
+	struct sockaddr_storage ss = ea->in_addr;
+	struct in_addr *addr = &((struct sockaddr_in *)&ss)->sin_addr;
+	struct in6_addr *addr6 = &((struct sockaddr_in6 *)&ss)->sin6_addr;
 
-	switch (ss->ss_family) {
+	switch (ss.ss_family) {
 	case AF_INET:
 		return addr->s_addr == htonl(INADDR_ANY);
 	case AF_INET6:
@@ -1809,18 +1810,20 @@ static bool addr_is_blank(struct sockaddr_storage *ss)
 	}
 }
 
-static int addr_port(struct sockaddr_storage *ss)
+static int addr_port(struct ceph_entity_addr *ea)
 {
-	switch (ss->ss_family) {
+	struct sockaddr_storage ss = ea->in_addr;
+
+	switch (ss.ss_family) {
 	case AF_INET:
-		return ntohs(((struct sockaddr_in *)ss)->sin_port);
+		return ntohs(((struct sockaddr_in *)&ss)->sin_port);
 	case AF_INET6:
-		return ntohs(((struct sockaddr_in6 *)ss)->sin6_port);
+		return ntohs(((struct sockaddr_in6 *)&ss)->sin6_port);
 	}
 	return 0;
 }
 
-static void addr_set_port(struct sockaddr_storage *ss, int p)
+static void sockaddr_set_port(struct sockaddr_storage *ss, int p)
 {
 	switch (ss->ss_family) {
 	case AF_INET:
@@ -1832,6 +1835,18 @@ static void addr_set_port(struct sockaddr_storage *ss, int p)
 	}
 }
 
+static void addr_set_port(struct ceph_entity_addr *addr, int p)
+{
+	switch (get_unaligned(&addr->in_addr.ss_family)) {
+	case AF_INET:
+		put_unaligned(htons(p), &((struct sockaddr_in *)&addr->in_addr)->sin_port);
+		break;
+	case AF_INET6:
+		put_unaligned(htons(p), &((struct sockaddr_in6 *)&addr->in_addr)->sin6_port);
+		break;
+	}
+}
+
 /*
  * Unlike other *_pton function semantics, zero indicates success.
  */
@@ -1941,7 +1956,7 @@ int ceph_parse_ips(const char *c, const char *end,
 	dout("parse_ips on '%.*s'\n", (int)(end-c), c);
 	for (i = 0; i < max_count; i++) {
 		const char *ipend;
-		struct sockaddr_storage *ss = &addr[i].in_addr;
+		struct sockaddr_storage ss = addr[i].in_addr;
 		int port;
 		char delim = ',';
 
@@ -1950,7 +1965,7 @@ int ceph_parse_ips(const char *c, const char *end,
 			p++;
 		}
 
-		ret = ceph_parse_server_name(p, end - p, ss, delim, &ipend);
+		ret = ceph_parse_server_name(p, end - p, &ss, delim, &ipend);
 		if (ret)
 			goto bad;
 		ret = -EINVAL;
@@ -1981,9 +1996,9 @@ int ceph_parse_ips(const char *c, const char *end,
 			port = CEPH_MON_PORT;
 		}
 
-		addr_set_port(ss, port);
+		sockaddr_set_port(&ss, port);
 
-		dout("parse_ips got %s\n", ceph_pr_sockaddr(ss));
+		dout("parse_ips got %s\n", ceph_pr_sockaddr(&ss));
 
 		if (p == end)
 			break;
@@ -2022,7 +2037,7 @@ static int process_banner(struct ceph_connection *con)
 	 */
 	if (memcmp(&con->peer_addr, &con->actual_peer_addr,
 		   sizeof(con->peer_addr)) != 0 &&
-	    !(addr_is_blank(&con->actual_peer_addr.in_addr) &&
+	    !(addr_is_blank(&con->peer_addr_for_me) &&
 	      con->actual_peer_addr.nonce == con->peer_addr.nonce)) {
 		pr_warn("wrong peer, want %s/%d, got %s/%d\n",
 			ceph_pr_addr(&con->peer_addr),
@@ -2036,13 +2051,13 @@ static int process_banner(struct ceph_connection *con)
 	/*
 	 * did we learn our address?
 	 */
-	if (addr_is_blank(&con->msgr->inst.addr.in_addr)) {
-		int port = addr_port(&con->msgr->inst.addr.in_addr);
+	if (addr_is_blank(&con->msgr->inst.addr)) {
+		int port = addr_port(&con->msgr->inst.addr);
 
 		memcpy(&con->msgr->inst.addr.in_addr,
 		       &con->peer_addr_for_me.in_addr,
 		       sizeof(con->peer_addr_for_me.in_addr));
-		addr_set_port(&con->msgr->inst.addr.in_addr, port);
+		addr_set_port(&con->msgr->inst.addr, port);
 		encode_my_addr(con->msgr);
 		dout("process_banner learned my addr is %s\n",
 		     ceph_pr_addr(&con->msgr->inst.addr));
-- 
2.21.0

