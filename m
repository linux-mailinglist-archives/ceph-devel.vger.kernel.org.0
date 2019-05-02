Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7E12225
	for <lists+ceph-devel@lfdr.de>; Thu,  2 May 2019 20:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfEBSqm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 May 2019 14:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbfEBSql (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 2 May 2019 14:46:41 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E1F204FD;
        Thu,  2 May 2019 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556822800;
        bh=gm1n4t0vX2Ott6TmCxxwz6j5k1Z48tGlDGI7atKLPLk=;
        h=From:To:Cc:Subject:Date:From;
        b=B7jTY5vxwqaSB983tEXSMC1tNPMpmH2lvspB4qQOLZrgnssu6fiD8IV9mWFBZg6Xg
         vNqWUf1y2TzsJopQBlcMwKcW++J6W+3XHAvLGoLaiAYArqYDkSUs4q9O3tGvVr01xo
         FReUBhbPbPHhcLnmzGp9fc2oanzImMuzzVG4am3g=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v2 1/3] libceph: fix unaligned accesses in ceph_entity_addr handling
Date:   Thu,  2 May 2019 14:46:36 -0400
Message-Id: <20190502184638.3614-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

GCC9 is throwing a lot of warnings about unaligned access. This patch
fixes some of them by changing most of the sockaddr handling functions
to take a pointer to struct ceph_entity_addr instead of struct
sockaddr_storage.  The lower functions can then take copies or do
unaligned accesses as needed.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 net/ceph/messenger.c | 77 ++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3083988ce729..54713836cac3 100644
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
 	dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
 
 	con_sock_state_connecting(con);
-	ret = sock->ops->connect(sock, (struct sockaddr *)paddr, sizeof(*paddr),
+	ret = sock->ops->connect(sock, (struct sockaddr *)&addr, sizeof(addr),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
 		dout("connect %s EINPROGRESS sk_state = %u\n",
@@ -1795,12 +1795,13 @@ static int verify_hello(struct ceph_connection *con)
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
@@ -1810,25 +1811,27 @@ static bool addr_is_blank(struct sockaddr_storage *ss)
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
+static void addr_set_port(struct ceph_entity_addr *addr, int p)
 {
-	switch (ss->ss_family) {
+	switch (get_unaligned(&addr->in_addr.ss_family)) {
 	case AF_INET:
-		((struct sockaddr_in *)ss)->sin_port = htons(p);
+		put_unaligned(htons(p), &((struct sockaddr_in *)&addr->in_addr)->sin_port);
 		break;
 	case AF_INET6:
-		((struct sockaddr_in6 *)ss)->sin6_port = htons(p);
+		put_unaligned(htons(p), &((struct sockaddr_in6 *)&addr->in_addr)->sin6_port);
 		break;
 	}
 }
@@ -1836,21 +1839,18 @@ static void addr_set_port(struct sockaddr_storage *ss, int p)
 /*
  * Unlike other *_pton function semantics, zero indicates success.
  */
-static int ceph_pton(const char *str, size_t len, struct sockaddr_storage *ss,
+static int ceph_pton(const char *str, size_t len, struct ceph_entity_addr *addr,
 		char delim, const char **ipend)
 {
-	struct sockaddr_in *in4 = (struct sockaddr_in *) ss;
-	struct sockaddr_in6 *in6 = (struct sockaddr_in6 *) ss;
-
-	memset(ss, 0, sizeof(*ss));
+	memset(&addr->in_addr, 0, sizeof(addr->in_addr));
 
-	if (in4_pton(str, len, (u8 *)&in4->sin_addr.s_addr, delim, ipend)) {
-		ss->ss_family = AF_INET;
+	if (in4_pton(str, len, (u8 *)&((struct sockaddr_in *)&addr->in_addr)->sin_addr.s_addr, delim, ipend)) {
+		put_unaligned(AF_INET, &addr->in_addr.ss_family);
 		return 0;
 	}
 
-	if (in6_pton(str, len, (u8 *)&in6->sin6_addr.s6_addr, delim, ipend)) {
-		ss->ss_family = AF_INET6;
+	if (in6_pton(str, len, (u8 *)&((struct sockaddr_in6 *)&addr->in_addr)->sin6_addr.s6_addr, delim, ipend)) {
+		put_unaligned(AF_INET6, &addr->in_addr.ss_family);
 		return 0;
 	}
 
@@ -1862,7 +1862,7 @@ static int ceph_pton(const char *str, size_t len, struct sockaddr_storage *ss,
  */
 #ifdef CONFIG_CEPH_LIB_USE_DNS_RESOLVER
 static int ceph_dns_resolve_name(const char *name, size_t namelen,
-		struct sockaddr_storage *ss, char delim, const char **ipend)
+		struct ceph_entity_addr *addr, char delim, const char **ipend)
 {
 	const char *end, *delim_p;
 	char *colon_p, *ip_addr = NULL;
@@ -1891,7 +1891,7 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 	/* do dns_resolve upcall */
 	ip_len = dns_query(NULL, name, end - name, NULL, &ip_addr, NULL);
 	if (ip_len > 0)
-		ret = ceph_pton(ip_addr, ip_len, ss, -1, NULL);
+		ret = ceph_pton(ip_addr, ip_len, addr, -1, NULL);
 	else
 		ret = -ESRCH;
 
@@ -1900,13 +1900,13 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 	*ipend = end;
 
 	pr_info("resolve '%.*s' (ret=%d): %s\n", (int)(end - name), name,
-			ret, ret ? "failed" : ceph_pr_addr(ss));
+			ret, ret ? "failed" : ceph_pr_addr(&addr->in_addr));
 
 	return ret;
 }
 #else
 static inline int ceph_dns_resolve_name(const char *name, size_t namelen,
-		struct sockaddr_storage *ss, char delim, const char **ipend)
+		struct ceph_entity_addr *addr, char delim, const char **ipend)
 {
 	return -EINVAL;
 }
@@ -1917,13 +1917,13 @@ static inline int ceph_dns_resolve_name(const char *name, size_t namelen,
  * then try to extract a hostname to resolve using userspace DNS upcall.
  */
 static int ceph_parse_server_name(const char *name, size_t namelen,
-			struct sockaddr_storage *ss, char delim, const char **ipend)
+		struct ceph_entity_addr *addr, char delim, const char **ipend)
 {
 	int ret;
 
-	ret = ceph_pton(name, namelen, ss, delim, ipend);
+	ret = ceph_pton(name, namelen, addr, delim, ipend);
 	if (ret)
-		ret = ceph_dns_resolve_name(name, namelen, ss, delim, ipend);
+		ret = ceph_dns_resolve_name(name, namelen, addr, delim, ipend);
 
 	return ret;
 }
@@ -1942,7 +1942,6 @@ int ceph_parse_ips(const char *c, const char *end,
 	dout("parse_ips on '%.*s'\n", (int)(end-c), c);
 	for (i = 0; i < max_count; i++) {
 		const char *ipend;
-		struct sockaddr_storage *ss = &addr[i].in_addr;
 		int port;
 		char delim = ',';
 
@@ -1951,7 +1950,7 @@ int ceph_parse_ips(const char *c, const char *end,
 			p++;
 		}
 
-		ret = ceph_parse_server_name(p, end - p, ss, delim, &ipend);
+		ret = ceph_parse_server_name(p, end - p, &addr[i], delim, &ipend);
 		if (ret)
 			goto bad;
 		ret = -EINVAL;
@@ -1982,9 +1981,9 @@ int ceph_parse_ips(const char *c, const char *end,
 			port = CEPH_MON_PORT;
 		}
 
-		addr_set_port(ss, port);
+		addr_set_port(&addr[i], port);
 
-		dout("parse_ips got %s\n", ceph_pr_addr(ss));
+		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i].in_addr));
 
 		if (p == end)
 			break;
@@ -2023,7 +2022,7 @@ static int process_banner(struct ceph_connection *con)
 	 */
 	if (memcmp(&con->peer_addr, &con->actual_peer_addr,
 		   sizeof(con->peer_addr)) != 0 &&
-	    !(addr_is_blank(&con->actual_peer_addr.in_addr) &&
+	    !(addr_is_blank(&con->peer_addr_for_me) &&
 	      con->actual_peer_addr.nonce == con->peer_addr.nonce)) {
 		pr_warn("wrong peer, want %s/%d, got %s/%d\n",
 			ceph_pr_addr(&con->peer_addr.in_addr),
@@ -2037,13 +2036,13 @@ static int process_banner(struct ceph_connection *con)
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
 		     ceph_pr_addr(&con->msgr->inst.addr.in_addr));
-- 
2.21.0

