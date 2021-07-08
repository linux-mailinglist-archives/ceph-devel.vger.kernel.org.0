Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E637B3BF702
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Jul 2021 10:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhGHIpk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Jul 2021 04:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231272AbhGHIpk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Jul 2021 04:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625733778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TG/V7Skx2KSYU7juA/oYagr74/10LpNd4e/c1AyKDU4=;
        b=hfslls0n7ON0ee8bI7Nuv6+rwQHmqSMz74R/5o1mIeE6rioixqGCDh2dnKFNC9vWmXsG6Q
        RBOskcEqyXW8FKZj7ujl05RzeCJ8WUFjvpYEHZj1rAbhk1LduKXsn5Fg1iI8rF1R/u7sRb
        MNLLf7fG/m8PLi+Y/NNSDAfEJ9b5TPI=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-5-3wj62eN4OMGTRVRJYOCw-1; Thu, 08 Jul 2021 04:42:57 -0400
X-MC-Unique: 5-3wj62eN4OMGTRVRJYOCw-1
Received: by mail-pg1-f197.google.com with SMTP id d28-20020a634f1c0000b02902238495b6a7so3838550pgb.16
        for <ceph-devel@vger.kernel.org>; Thu, 08 Jul 2021 01:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TG/V7Skx2KSYU7juA/oYagr74/10LpNd4e/c1AyKDU4=;
        b=bhGkUOt8EV3bkgsFLzRrT8nFShLakCftfc9Rt6Vo/Bcsar197DTughcjBo+16DWj9n
         3jV+XKaSO1XiLq7n/uH4h+ga1WcsWSRM2SljvplxA4WR4gF/MV3Wgw1U1hMJuyDMV81w
         hkqJO44auMFlcUNY/+UCotWlFRHORiTxe/L1litU9Sijz6kqHZrZHXSoLLQwkokdTVpJ
         8NXsMOD+2upe8gTDcc93QXAOs8xelMNt8ECq8KjDCgtKFkMOXTtZYIU8u6mMLU3JSb7o
         L9fYf2jPMlNMaEsacppQ4oTvq54Y4vYWCssekOKm/htGXqV9w3jdNHq2ySdoRsEUIQ66
         pzqg==
X-Gm-Message-State: AOAM5313X5hGnlM0QPg8UmJu9IgZNIrhEYlx7UDiqbZ4cf+lQFSRnXd9
        da/UgeOqOLEyRIM2ko9pZdxVpFRfDyaFE5bWuPlW+YjlqVWl/jO8mN05YwOM7wC1eqwFWpp2LVC
        zp080spsD/rmILgxZD5JOKw==
X-Received: by 2002:a63:5d5c:: with SMTP id o28mr30913151pgm.22.1625733776127;
        Thu, 08 Jul 2021 01:42:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi8aIB9kZL/MJOLT+rZ0ygckNKxE3Vye7OOvfWnbysvN3+jFx2FuRiQGcjpRsETav3/aj/Nw==
X-Received: by 2002:a63:5d5c:: with SMTP id o28mr30913137pgm.22.1625733775957;
        Thu, 08 Jul 2021 01:42:55 -0700 (PDT)
Received: from h3ckers-pride.redhat.com ([49.207.223.150])
        by smtp.gmail.com with ESMTPSA id r14sm2154588pgm.28.2021.07.08.01.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 01:42:55 -0700 (PDT)
From:   Venky Shankar <vshankar@redhat.com>
To:     jlayton@redhat.com, idryomov@gmail.com, lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org,
        Venky Shankar <vshankar@redhat.com>
Subject: [PATCH v3 1/5] ceph: generalize addr/ip parsing based on delimiter
Date:   Thu,  8 Jul 2021 14:12:43 +0530
Message-Id: <20210708084247.182953-2-vshankar@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210708084247.182953-1-vshankar@redhat.com>
References: <20210708084247.182953-1-vshankar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Signed-off-by: Venky Shankar <vshankar@redhat.com>
---
 drivers/block/rbd.c            | 3 ++-
 fs/ceph/super.c                | 3 ++-
 include/linux/ceph/libceph.h   | 4 +++-
 include/linux/ceph/messenger.h | 2 +-
 net/ceph/ceph_common.c         | 8 ++++----
 net/ceph/messenger.c           | 4 ++--
 6 files changed, 14 insertions(+), 10 deletions(-)

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
index 57d043b382ed..142fc70ea45d 100644
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
-- 
2.27.0

