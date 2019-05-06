Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01BFE14B07
	for <lists+ceph-devel@lfdr.de>; Mon,  6 May 2019 15:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbfEFNiw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 May 2019 09:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfEFNiw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 6 May 2019 09:38:52 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C0A120830;
        Mon,  6 May 2019 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557149930;
        bh=EwFqHbB0QOl1N/TtM6POa+FgcPbRyF9ssjERgK75Cac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pxjj1olMbYOXC60kS9wHxWqALm9/XLeOC5IcJYzUE8vsoxcv8pMeEvKo4vngDjzx/
         Eg/Hd274mkYUlEuvTA+FM3ZJ0I+t9SMrIHraB/EWldL4Fg43oFXGKvAiKNUqBmWBtj
         4MZq8TXHd5lXSi0hlt18WqPq0bZwsTpZbBbtCllI=
From:   Jeff Layton <jlayton@kernel.org>
To:     zyan@redhat.com, sage@redhat.com, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v3 2/2] libceph: make ceph_pr_addr take an struct ceph_entity_addr pointer
Date:   Mon,  6 May 2019 09:38:47 -0400
Message-Id: <20190506133847.7394-2-jlayton@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506133847.7394-1-jlayton@kernel.org>
References: <20190506133847.7394-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

GCC9 is throwing a lot of warnings about unaligned accesses by
callers of ceph_pr_addr. All of the current callers are passing a
pointer to the sockaddr inside struct ceph_entity_addr.

Fix it to take a pointer to a struct ceph_entity_addr instead,
and then have the function make a copy of the sockaddr before
printing it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/debugfs.c              |  2 +-
 fs/ceph/mdsmap.c               |  2 +-
 include/linux/ceph/messenger.h |  3 ++-
 net/ceph/cls_lock_client.c     |  2 +-
 net/ceph/debugfs.c             |  4 +--
 net/ceph/messenger.c           | 48 +++++++++++++++++-----------------
 net/ceph/mon_client.c          |  6 ++---
 net/ceph/osd_client.c          |  2 +-
 8 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index b014fc7d4e3c..b3fc5fe26a1a 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -37,7 +37,7 @@ static int mdsmap_show(struct seq_file *s, void *p)
 		struct ceph_entity_addr *addr = &mdsmap->m_info[i].addr;
 		int state = mdsmap->m_info[i].state;
 		seq_printf(s, "\tmds%d\t%s\t(%s)\n", i,
-			       ceph_pr_addr(&addr->in_addr),
+			       ceph_pr_addr(addr),
 			       ceph_mds_state_name(state));
 	}
 	return 0;
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 977cacd3825f..45a815c7975e 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -205,7 +205,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
 
 		dout("mdsmap_decode %d/%d %lld mds%d.%d %s %s\n",
 		     i+1, n, global_id, mds, inc,
-		     ceph_pr_addr(&addr.in_addr),
+		     ceph_pr_addr(&addr),
 		     ceph_mds_state_name(state));
 
 		if (mds < 0 || state <= 0)
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 800a2128d411..23895d178149 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -323,7 +323,8 @@ struct ceph_connection {
 };
 
 
-extern const char *ceph_pr_addr(const struct sockaddr_storage *ss);
+extern const char *ceph_pr_addr(const struct ceph_entity_addr *addr);
+
 extern int ceph_parse_ips(const char *c, const char *end,
 			  struct ceph_entity_addr *addr,
 			  int max_count, int *count);
diff --git a/net/ceph/cls_lock_client.c b/net/ceph/cls_lock_client.c
index 2105a6eaa66c..4cc28541281b 100644
--- a/net/ceph/cls_lock_client.c
+++ b/net/ceph/cls_lock_client.c
@@ -271,7 +271,7 @@ static int decode_locker(void **p, void *end, struct ceph_locker *locker)
 
 	dout("%s %s%llu cookie %s addr %s\n", __func__,
 	     ENTITY_NAME(locker->id.name), locker->id.cookie,
-	     ceph_pr_addr(&locker->info.addr.in_addr));
+	     ceph_pr_addr(&locker->info.addr));
 	return 0;
 }
 
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 46f65709a6ff..63aef9915f75 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -46,7 +46,7 @@ static int monmap_show(struct seq_file *s, void *p)
 
 		seq_printf(s, "\t%s%lld\t%s\n",
 			   ENTITY_NAME(inst->name),
-			   ceph_pr_addr(&inst->addr.in_addr));
+			   ceph_pr_addr(&inst->addr));
 	}
 	return 0;
 }
@@ -82,7 +82,7 @@ static int osdmap_show(struct seq_file *s, void *p)
 		char sb[64];
 
 		seq_printf(s, "osd%d\t%s\t%3d%%\t(%s)\t%3d%%\n",
-			   i, ceph_pr_addr(&addr->in_addr),
+			   i, ceph_pr_addr(addr),
 			   ((map->osd_weight[i]*100) >> 16),
 			   ceph_osdmap_state_str(sb, sizeof(sb), state),
 			   ((ceph_get_primary_affinity(map, i)*100) >> 16));
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 3cb8ce385fce..9d34f240398f 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -186,17 +186,18 @@ static atomic_t addr_str_seq = ATOMIC_INIT(0);
 
 static struct page *zero_page;		/* used in certain error cases */
 
-const char *ceph_pr_addr(const struct sockaddr_storage *ss)
+const char *ceph_pr_addr(const struct ceph_entity_addr *addr)
 {
 	int i;
 	char *s;
-	struct sockaddr_in *in4 = (struct sockaddr_in *) ss;
-	struct sockaddr_in6 *in6 = (struct sockaddr_in6 *) ss;
+	const struct sockaddr_storage ss = addr->in_addr; /* align */
+	const struct sockaddr_in *in4 = (struct sockaddr_in *) &ss;
+	const struct sockaddr_in6 *in6 = (struct sockaddr_in6 *) &ss;
 
 	i = atomic_inc_return(&addr_str_seq) & ADDR_STR_COUNT_MASK;
 	s = addr_str[i];
 
-	switch (ss->ss_family) {
+	switch (ss.ss_family) {
 	case AF_INET:
 		snprintf(s, MAX_ADDR_STR_LEN, "%pI4:%hu", &in4->sin_addr,
 			 ntohs(in4->sin_port));
@@ -209,7 +210,7 @@ const char *ceph_pr_addr(const struct sockaddr_storage *ss)
 
 	default:
 		snprintf(s, MAX_ADDR_STR_LEN, "(unknown sockaddr family %hu)",
-			 ss->ss_family);
+			 ss.ss_family);
 	}
 
 	return s;
@@ -471,18 +472,18 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 
 	set_sock_callbacks(sock, con);
 
-	dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
+	dout("connect %s\n", ceph_pr_addr(&con->peer_addr));
 
 	con_sock_state_connecting(con);
 	ret = sock->ops->connect(sock, (struct sockaddr *)&addr, sizeof(addr),
 				 O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
 		dout("connect %s EINPROGRESS sk_state = %u\n",
-		     ceph_pr_addr(&con->peer_addr.in_addr),
+		     ceph_pr_addr(&con->peer_addr),
 		     sock->sk->sk_state);
 	} else if (ret < 0) {
 		pr_err("connect %s error %d\n",
-		       ceph_pr_addr(&con->peer_addr.in_addr), ret);
+		       ceph_pr_addr(&con->peer_addr), ret);
 		sock_release(sock);
 		return ret;
 	}
@@ -669,8 +670,7 @@ static void reset_connection(struct ceph_connection *con)
 void ceph_con_close(struct ceph_connection *con)
 {
 	mutex_lock(&con->mutex);
-	dout("con_close %p peer %s\n", con,
-	     ceph_pr_addr(&con->peer_addr.in_addr));
+	dout("con_close %p peer %s\n", con, ceph_pr_addr(&con->peer_addr));
 	con->state = CON_STATE_CLOSED;
 
 	con_flag_clear(con, CON_FLAG_LOSSYTX);	/* so we retry next connect */
@@ -694,7 +694,7 @@ void ceph_con_open(struct ceph_connection *con,
 		   struct ceph_entity_addr *addr)
 {
 	mutex_lock(&con->mutex);
-	dout("con_open %p %s\n", con, ceph_pr_addr(&addr->in_addr));
+	dout("con_open %p %s\n", con, ceph_pr_addr(addr));
 
 	WARN_ON(con->state != CON_STATE_CLOSED);
 	con->state = CON_STATE_PREOPEN;
@@ -1788,7 +1788,7 @@ static int verify_hello(struct ceph_connection *con)
 {
 	if (memcmp(con->in_banner, CEPH_BANNER, strlen(CEPH_BANNER))) {
 		pr_err("connect to %s got bad banner\n",
-		       ceph_pr_addr(&con->peer_addr.in_addr));
+		       ceph_pr_addr(&con->peer_addr));
 		con->error_msg = "protocol error, bad banner";
 		return -1;
 	}
@@ -1898,7 +1898,7 @@ static int ceph_dns_resolve_name(const char *name, size_t namelen,
 	*ipend = end;
 
 	pr_info("resolve '%.*s' (ret=%d): %s\n", (int)(end - name), name,
-			ret, ret ? "failed" : ceph_pr_addr(&addr->in_addr));
+			ret, ret ? "failed" : ceph_pr_addr(addr));
 
 	return ret;
 }
@@ -1981,7 +1981,7 @@ int ceph_parse_ips(const char *c, const char *end,
 
 		addr_set_port(&addr[i], port);
 
-		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i].in_addr));
+		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i]));
 
 		if (p == end)
 			break;
@@ -2023,9 +2023,9 @@ static int process_banner(struct ceph_connection *con)
 	    !(addr_is_blank(&con->peer_addr_for_me) &&
 	      con->actual_peer_addr.nonce == con->peer_addr.nonce)) {
 		pr_warn("wrong peer, want %s/%d, got %s/%d\n",
-			ceph_pr_addr(&con->peer_addr.in_addr),
+			ceph_pr_addr(&con->peer_addr),
 			(int)le32_to_cpu(con->peer_addr.nonce),
-			ceph_pr_addr(&con->actual_peer_addr.in_addr),
+			ceph_pr_addr(&con->actual_peer_addr),
 			(int)le32_to_cpu(con->actual_peer_addr.nonce));
 		con->error_msg = "wrong peer at address";
 		return -1;
@@ -2043,7 +2043,7 @@ static int process_banner(struct ceph_connection *con)
 		addr_set_port(&con->msgr->inst.addr, port);
 		encode_my_addr(con->msgr);
 		dout("process_banner learned my addr is %s\n",
-		     ceph_pr_addr(&con->msgr->inst.addr.in_addr));
+		     ceph_pr_addr(&con->msgr->inst.addr));
 	}
 
 	return 0;
@@ -2094,7 +2094,7 @@ static int process_connect(struct ceph_connection *con)
 		pr_err("%s%lld %s feature set mismatch,"
 		       " my %llx < server's %llx, missing %llx\n",
 		       ENTITY_NAME(con->peer_name),
-		       ceph_pr_addr(&con->peer_addr.in_addr),
+		       ceph_pr_addr(&con->peer_addr),
 		       sup_feat, server_feat, server_feat & ~sup_feat);
 		con->error_msg = "missing required protocol features";
 		reset_connection(con);
@@ -2104,7 +2104,7 @@ static int process_connect(struct ceph_connection *con)
 		pr_err("%s%lld %s protocol version mismatch,"
 		       " my %d != server's %d\n",
 		       ENTITY_NAME(con->peer_name),
-		       ceph_pr_addr(&con->peer_addr.in_addr),
+		       ceph_pr_addr(&con->peer_addr),
 		       le32_to_cpu(con->out_connect.protocol_version),
 		       le32_to_cpu(con->in_reply.protocol_version));
 		con->error_msg = "protocol version mismatch";
@@ -2138,7 +2138,7 @@ static int process_connect(struct ceph_connection *con)
 		     le32_to_cpu(con->in_reply.connect_seq));
 		pr_err("%s%lld %s connection reset\n",
 		       ENTITY_NAME(con->peer_name),
-		       ceph_pr_addr(&con->peer_addr.in_addr));
+		       ceph_pr_addr(&con->peer_addr));
 		reset_connection(con);
 		con_out_kvec_reset(con);
 		ret = prepare_write_connect(con);
@@ -2195,7 +2195,7 @@ static int process_connect(struct ceph_connection *con)
 			pr_err("%s%lld %s protocol feature mismatch,"
 			       " my required %llx > server's %llx, need %llx\n",
 			       ENTITY_NAME(con->peer_name),
-			       ceph_pr_addr(&con->peer_addr.in_addr),
+			       ceph_pr_addr(&con->peer_addr),
 			       req_feat, server_feat, req_feat & ~server_feat);
 			con->error_msg = "missing required protocol features";
 			reset_connection(con);
@@ -2402,7 +2402,7 @@ static int read_partial_message(struct ceph_connection *con)
 	if ((s64)seq - (s64)con->in_seq < 1) {
 		pr_info("skipping %s%lld %s seq %lld expected %lld\n",
 			ENTITY_NAME(con->peer_name),
-			ceph_pr_addr(&con->peer_addr.in_addr),
+			ceph_pr_addr(&con->peer_addr),
 			seq, con->in_seq + 1);
 		con->in_base_pos = -front_len - middle_len - data_len -
 			sizeof_footer(con);
@@ -2981,10 +2981,10 @@ static void ceph_con_workfn(struct work_struct *work)
 static void con_fault(struct ceph_connection *con)
 {
 	dout("fault %p state %lu to peer %s\n",
-	     con, con->state, ceph_pr_addr(&con->peer_addr.in_addr));
+	     con, con->state, ceph_pr_addr(&con->peer_addr));
 
 	pr_warn("%s%lld %s %s\n", ENTITY_NAME(con->peer_name),
-		ceph_pr_addr(&con->peer_addr.in_addr), con->error_msg);
+		ceph_pr_addr(&con->peer_addr), con->error_msg);
 	con->error_msg = NULL;
 
 	WARN_ON(con->state != CON_STATE_CONNECTING &&
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index a53e4fbb6319..895679d3529b 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -76,7 +76,7 @@ struct ceph_monmap *ceph_monmap_decode(void *p, void *end)
 	     m->num_mon);
 	for (i = 0; i < m->num_mon; i++)
 		dout("monmap_decode  mon%d is %s\n", i,
-		     ceph_pr_addr(&m->mon_inst[i].addr.in_addr));
+		     ceph_pr_addr(&m->mon_inst[i].addr));
 	return m;
 
 bad:
@@ -203,7 +203,7 @@ static void reopen_session(struct ceph_mon_client *monc)
 {
 	if (!monc->hunting)
 		pr_info("mon%d %s session lost, hunting for new mon\n",
-		    monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr.in_addr));
+		    monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr));
 
 	__close_session(monc);
 	__open_session(monc);
@@ -1178,7 +1178,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 		__resend_generic_request(monc);
 
 		pr_info("mon%d %s session established\n", monc->cur_mon,
-			ceph_pr_addr(&monc->con.peer_addr.in_addr));
+			ceph_pr_addr(&monc->con.peer_addr));
 	}
 
 out:
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index fa9530dd876e..e6d31e0f0289 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4926,7 +4926,7 @@ static int decode_watcher(void **p, void *end, struct ceph_watch_item *item)
 
 	dout("%s %s%llu cookie %llu addr %s\n", __func__,
 	     ENTITY_NAME(item->name), item->cookie,
-	     ceph_pr_addr(&item->addr.in_addr));
+	     ceph_pr_addr(&item->addr));
 	return 0;
 }
 
-- 
2.21.0

