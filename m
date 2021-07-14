Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BFF3C8267
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 12:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239008AbhGNKJF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 06:09:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238984AbhGNKJE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 06:09:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8t/yKmVAO8L3RLiFdigoWmVn4UCTKMM2iaDiSJwS5c=;
        b=fb0TKMSdgdnbKgeELP0n/3Bex06uMZE4C9htQi+65sGeIZTDoae8Nf8RCk37av0oqCR6hK
        j7+JVdR8shS0sLp0IJa0GF0+3epaIRP0Ao3Jj58a4CSvE75ZbXdB38k7rHcdqNmsQm+KGO
        clnpzOsAwMTzTfahaKVKehRWvEnlANY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-ZKFihud8M8OxbaTLOy44OA-1; Wed, 14 Jul 2021 06:06:09 -0400
X-MC-Unique: ZKFihud8M8OxbaTLOy44OA-1
Received: by mail-pg1-f198.google.com with SMTP id 137-20020a63058f0000b02902285c45652dso1191205pgf.4
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 03:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m8t/yKmVAO8L3RLiFdigoWmVn4UCTKMM2iaDiSJwS5c=;
        b=r1ME8odH5SdwPytgFS++nARYzoj0nCpoNGkB9zzPHjRmWD3sgHRdB5B48I5jOWwS7I
         /gbGvUSNMFjCUFiiu2dBQVwjWHC5kzllbCKRz8yDYQyS8tfdKtS/7eS8qzlTXEH2bV/V
         UfOMLUjVg1SEgndk83yTOluYnMVpaaZa1H8wNg7EuYuYuJwUhNnlGbYlElgdmmQH3lzJ
         0oPLINjAXQ9x+WtuprsCsZXofDM3F00xnvBHXBgCXwBXOSSxX6Z3kfnqmxxOQ9jqsfzc
         QOtRnim5AO5Psr2zRuZ9xzi3xnkB9bDxOQJiLOrThkQs2QEt/mG3e35+O/wAVEl1G6nN
         EB3g==
X-Gm-Message-State: AOAM533an5SYJhG0QdBjy0dAstL+oxdAhhITo+j94X4/OhGRL3zYd0x2
        xtQrMHJmXCUxWYAEgrBSz9BJ7DdYcaMxyg+uWjIIzpFoDPPPIpafHCpzMi+TB63Z4WMqt4hhCFC
        zTLgIo2pnj/mN4sYxn8ySzQ==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr8979018pjq.58.1626257168679;
        Wed, 14 Jul 2021 03:06:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzvx8GpcKc/kjTB/pBp+XiwiR37BYc7hZXMat23JoKy0CYCj4veR9TRzsCHU7IAtrF7Gxr7mw==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr8979005pjq.58.1626257168448;
        Wed, 14 Jul 2021 03:06:08 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.217.185])
        by smtp.gmail.com with ESMTPSA id 125sm2227030pfg.52.2021.07.14.03.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 03:06:07 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v4 1/5] ceph: generalize addr/ip parsing based on delimiter
Date:   Wed, 14 Jul 2021 15:35:50 +0530
Message-Id: <20210714100554.85978-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714100554.85978-1-vshankar@redhat.com>
References: <20210714100554.85978-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

... and remove hardcoded function name in ceph_parse_ips().

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 drivers/block/rbd.c            | 3 ++-
 fs/ceph/super.c                | 3 ++-
 include/linux/ceph/libceph.h   | 4 +++-
 include/linux/ceph/messenger.h | 2 +-
 net/ceph/ceph_common.c         | 8 ++++----
 net/ceph/messenger.c           | 8 ++++----
 6 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index bbb88eb009e0..209a7a128ea3 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -6530,7 +6530,8 @@ static int rbd_add_parse_args(const char *buf,
 	pctx.opts->exclusive = RBD_EXCLUSIVE_DEFAULT;
 	pctx.opts->trim = RBD_TRIM_DEFAULT;
 
-	ret = ceph_parse_mon_ips(mon_addrs, mon_addrs_size, pctx.copts, NULL);
+	ret = ceph_parse_mon_ips(mon_addrs, mon_addrs_size, pctx.copts, NULL,
+				 CEPH_ADDR_PARSE_DEFAULT_DELIM);
 	if (ret)
 		goto out_err;
 
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 9b1b7f4cfdd4..039775553a88 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -271,7 +271,8 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
 		dout("server path '%s'\n", fsopt->server_path);
 
 	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
-				 pctx->copts, fc->log.log);
+				 pctx->copts, fc->log.log,
+				 CEPH_ADDR_PARSE_DEFAULT_DELIM);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 409d8c29bc4f..e50dba429819 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -98,6 +98,8 @@ struct ceph_options {
 
 #define CEPH_AUTH_NAME_DEFAULT   "guest"
 
+#define CEPH_ADDR_PARSE_DEFAULT_DELIM  ','
+
 /* mount state */
 enum {
 	CEPH_MOUNT_MOUNTING,
@@ -301,7 +303,7 @@ struct fs_parameter;
 struct fc_log;
 struct ceph_options *ceph_alloc_options(void);
 int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
-		       struct fc_log *l);
+		       struct fc_log *l, char delimiter);
 int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		     struct fc_log *l);
 int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 0e6e9ad3c3bf..c9675ee33f51 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -532,7 +532,7 @@ extern const char *ceph_pr_addr(const struct ceph_entity_addr *addr);
 
 extern int ceph_parse_ips(const char *c, const char *end,
 			  struct ceph_entity_addr *addr,
-			  int max_count, int *count);
+			  int max_count, int *count, char delimiter);
 
 extern int ceph_msgr_init(void);
 extern void ceph_msgr_exit(void);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 97d6ea763e32..0f74ceeddf48 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -422,14 +422,14 @@ static int get_secret(struct ceph_crypto_key *dst, const char *name,
 }
 
 int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
-		       struct fc_log *l)
+		       struct fc_log *l, char delimiter)
 {
 	struct p_log log = {.prefix = "libceph", .log = l};
 	int ret;
 
-	/* ip1[:port1][,ip2[:port2]...] */
+	/* ip1[:port1][<delim>ip2[:port2]...] */
 	ret = ceph_parse_ips(buf, buf + len, opt->mon_addr, CEPH_MAX_MON,
-			     &opt->num_mon);
+			     &opt->num_mon, delimiter);
 	if (ret) {
 		error_plog(&log, "Failed to parse monitor IPs: %d", ret);
 		return ret;
@@ -456,7 +456,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		err = ceph_parse_ips(param->string,
 				     param->string + param->size,
 				     &opt->my_addr,
-				     1, NULL);
+				     1, NULL, CEPH_ADDR_PARSE_DEFAULT_DELIM);
 		if (err) {
 			error_plog(&log, "Failed to parse ip: %d", err);
 			return err;
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 57d043b382ed..c93d103fe343 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1267,7 +1267,7 @@ static int ceph_parse_server_name(const char *name, size_t namelen,
  */
 int ceph_parse_ips(const char *c, const char *end,
 		   struct ceph_entity_addr *addr,
-		   int max_count, int *count)
+		   int max_count, int *count, char delimiter)
 {
 	int i, ret = -EINVAL;
 	const char *p = c;
@@ -1276,7 +1276,7 @@ int ceph_parse_ips(const char *c, const char *end,
 	for (i = 0; i < max_count; i++) {
 		const char *ipend;
 		int port;
-		char delim = ',';
+		char delim = delimiter;
 
 		if (*p == '[') {
 			delim = ']';
@@ -1326,11 +1326,11 @@ int ceph_parse_ips(const char *c, const char *end,
 		addr[i].type = CEPH_ENTITY_ADDR_TYPE_LEGACY;
 		addr[i].nonce = 0;
 
-		dout("parse_ips got %s\n", ceph_pr_addr(&addr[i]));
+		dout("%s got %s\n", __func__, ceph_pr_addr(&addr[i]));
 
 		if (p == end)
 			break;
-		if (*p != ',')
+		if (*p != delimiter)
 			goto bad;
 		p++;
 	}
-- 
2.27.0

