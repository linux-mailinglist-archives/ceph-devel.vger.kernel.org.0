Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C815D1E9258
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgE3Peo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 May 2020 11:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729038AbgE3Peo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 30 May 2020 11:34:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69157C03E969
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:43 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k26so7088519wmi.4
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CuUblVlbb4/hdLfw8lJXOYph+PzOR6Wiwb4MsFsDZO8=;
        b=ODA4bV+Qp1OyzX/uM4MrzGwNC5lezH02oPgrZJ0y1BWSzMHAoQuUaF2LBw8kDWqTvw
         FRphzRxZxFg4qpJe7taBNZk0mGnz+A+ICadgTl7jJ5sJKK6rO5oCRR8Vtvo27v4lOy3E
         O5KtActEbKLykcpLILvYIVuLxRluf7ShiTKtilQP2A9gpKAyXz139AUYNKGr43nKDBQJ
         REMH8zbvWe4sZ7M6xetga7/CkBC8pcTDHNcEz1FIyvPCaGrBSlnBOEqQPJPz6hCRWT4X
         1NndY/JWxSnY2aejO3kDp3iYG6NkKV3OCp1mOrzs/9zgtWNtGPF5SLIZmCjwIxsqQzWy
         B21Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CuUblVlbb4/hdLfw8lJXOYph+PzOR6Wiwb4MsFsDZO8=;
        b=MHLAk1lZoYvXQJII7i/XnDBglmF4s4L6c1kJvscSlssFrHU16akObONlqPOxCCpTI1
         6nHi2GB6Boe90XCoNLQqnzgkKzxUUEDWuTkHEjCPPzjJ68UK3OOD8GPc/qvanxqrwaVI
         lJQxQi1/LyCqwjWhOItiueMitSNO+X5fpfmlOb9KG2k6Y6hnH+8svjiljhNyiqcGMbPH
         yKj7oYiaKxK94/errCYGG5M7OzIm3GFYk6efTOn7yGHxCHk2wthda6C/CMpSzDq9mEmE
         iL7v5lIkO0PreoXSSnEpzLzj12upMR6/HQKNkqPEqBHPO3OpFa2DnoWmmhrVUE3sExIV
         jXfQ==
X-Gm-Message-State: AOAM531SvLsklRfQ4OI+VlmyeTzbKcs6JVB1WFVT4FhokLAF8Ntq7ZAl
        I7dNNrO1gdVJT2c6RMuAbfl22O9eGqY=
X-Google-Smtp-Source: ABdhPJzoCSn6kel5sWQlCn+IbaIE/nkS8fzfXHSBh7CKGI6bYu/bNtUAB+Iq02IcAeAY9O3bdkQ87w==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr13459941wmc.121.1590852881725;
        Sat, 30 May 2020 08:34:41 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id z132sm4835068wmc.29.2020.05.30.08.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 08:34:41 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 3/5] libceph: crush_location infrastructure
Date:   Sat, 30 May 2020 17:34:37 +0200
Message-Id: <20200530153439.31312-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200530153439.31312-1-idryomov@gmail.com>
References: <20200530153439.31312-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow expressing client's location in terms of CRUSH hierarchy as
a set of (bucket type name, bucket name) pairs.  The userspace syntax
"crush_location = key1=value1 key2=value2" is incompatible with mount
options and needed adaptation.  Key-value pairs are separated by '|'
and we use ':' instead of '=' to separate keys from values.  So for:

  crush_location = host=foo rack=bar

one would write:

  crush_location=host:foo|rack:bar

As in userspace, "multipath" locations are supported, so indicating
locality for parallel hierarchies is possible:

  crush_location=rack:foo1|rack:foo2|datacenter:bar

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h |   1 +
 include/linux/ceph/osdmap.h  |  16 ++++-
 net/ceph/ceph_common.c       |  36 +++++++++++
 net/ceph/osdmap.c            | 116 +++++++++++++++++++++++++++++++++++
 4 files changed, 168 insertions(+), 1 deletion(-)

diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 4b5a47bcaba4..4733959f1ec7 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -64,6 +64,7 @@ struct ceph_options {
 	int num_mon;
 	char *name;
 	struct ceph_crypto_key *key;
+	struct rb_root crush_locs;
 };
 
 /*
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index 5e601975745f..8c9d18cc9f45 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -302,9 +302,23 @@ bool ceph_pg_to_primary_shard(struct ceph_osdmap *osdmap,
 int ceph_pg_to_acting_primary(struct ceph_osdmap *osdmap,
 			      const struct ceph_pg *raw_pgid);
 
+struct crush_loc {
+	char *cl_type_name;
+	char *cl_name;
+};
+
+struct crush_loc_node {
+	struct rb_node cl_node;
+	struct crush_loc cl_loc;  /* pointers into cl_data */
+	char cl_data[];
+};
+
+int ceph_parse_crush_location(char *crush_location, struct rb_root *locs);
+int ceph_compare_crush_locs(struct rb_root *locs1, struct rb_root *locs2);
+void ceph_clear_crush_locs(struct rb_root *locs);
+
 extern struct ceph_pg_pool_info *ceph_pg_pool_by_id(struct ceph_osdmap *map,
 						    u64 id);
-
 extern const char *ceph_pg_pool_name_by_id(struct ceph_osdmap *map, u64 id);
 extern int ceph_pg_poolid_by_name(struct ceph_osdmap *map, const char *name);
 u64 ceph_pg_pool_flags(struct ceph_osdmap *map, u64 id);
diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index a0e97f6c1072..44770b60bc38 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -176,6 +176,10 @@ int ceph_compare_options(struct ceph_options *new_opt,
 		}
 	}
 
+	ret = ceph_compare_crush_locs(&opt1->crush_locs, &opt2->crush_locs);
+	if (ret)
+		return ret;
+
 	/* any matching mon ip implies a match */
 	for (i = 0; i < opt1->num_mon; i++) {
 		if (ceph_monmap_contains(client->monc.monmap,
@@ -260,6 +264,7 @@ enum {
 	Opt_secret,
 	Opt_key,
 	Opt_ip,
+	Opt_crush_location,
 	/* string args above */
 	Opt_share,
 	Opt_crc,
@@ -274,6 +279,7 @@ static const struct fs_parameter_spec ceph_parameters[] = {
 	fsparam_flag_no ("cephx_require_signatures",	Opt_cephx_require_signatures),
 	fsparam_flag_no ("cephx_sign_messages",		Opt_cephx_sign_messages),
 	fsparam_flag_no ("crc",				Opt_crc),
+	fsparam_string	("crush_location",		Opt_crush_location),
 	fsparam_string	("fsid",			Opt_fsid),
 	fsparam_string	("ip",				Opt_ip),
 	fsparam_string	("key",				Opt_key),
@@ -298,6 +304,7 @@ struct ceph_options *ceph_alloc_options(void)
 	if (!opt)
 		return NULL;
 
+	opt->crush_locs = RB_ROOT;
 	opt->mon_addr = kcalloc(CEPH_MAX_MON, sizeof(*opt->mon_addr),
 				GFP_KERNEL);
 	if (!opt->mon_addr) {
@@ -320,6 +327,7 @@ void ceph_destroy_options(struct ceph_options *opt)
 	if (!opt)
 		return;
 
+	ceph_clear_crush_locs(&opt->crush_locs);
 	kfree(opt->name);
 	if (opt->key) {
 		ceph_crypto_key_destroy(opt->key);
@@ -454,6 +462,16 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		if (!opt->key)
 			return -ENOMEM;
 		return get_secret(opt->key, param->string, &log);
+	case Opt_crush_location:
+		ceph_clear_crush_locs(&opt->crush_locs);
+		err = ceph_parse_crush_location(param->string,
+						&opt->crush_locs);
+		if (err) {
+			error_plog(&log, "Failed to parse CRUSH location: %d",
+				   err);
+			return err;
+		}
+		break;
 
 	case Opt_osdtimeout:
 		warn_plog(&log, "Ignoring osdtimeout");
@@ -536,6 +554,7 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 {
 	struct ceph_options *opt = client->options;
 	size_t pos = m->count;
+	struct rb_node *n;
 
 	if (opt->name) {
 		seq_puts(m, "name=");
@@ -545,6 +564,23 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 	if (opt->key)
 		seq_puts(m, "secret=<hidden>,");
 
+	if (!RB_EMPTY_ROOT(&opt->crush_locs)) {
+		seq_puts(m, "crush_location=");
+		for (n = rb_first(&opt->crush_locs); ; ) {
+			struct crush_loc_node *loc =
+			    rb_entry(n, struct crush_loc_node, cl_node);
+
+			seq_printf(m, "%s:%s", loc->cl_loc.cl_type_name,
+				   loc->cl_loc.cl_name);
+			n = rb_next(n);
+			if (!n)
+				break;
+
+			seq_putc(m, '|');
+		}
+		seq_putc(m, ',');
+	}
+
 	if (opt->flags & CEPH_OPT_FSID)
 		seq_printf(m, "fsid=%pU,", &opt->fsid);
 	if (opt->flags & CEPH_OPT_NOSHARE)
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index e74130876d3a..4b81334e9e5b 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -2715,3 +2715,119 @@ int ceph_pg_to_acting_primary(struct ceph_osdmap *osdmap,
 	return acting.primary;
 }
 EXPORT_SYMBOL(ceph_pg_to_acting_primary);
+
+static struct crush_loc_node *alloc_crush_loc(size_t type_name_len,
+					      size_t name_len)
+{
+	struct crush_loc_node *loc;
+
+	loc = kmalloc(sizeof(*loc) + type_name_len + name_len + 2, GFP_NOIO);
+	if (!loc)
+		return NULL;
+
+	RB_CLEAR_NODE(&loc->cl_node);
+	return loc;
+}
+
+static void free_crush_loc(struct crush_loc_node *loc)
+{
+	WARN_ON(!RB_EMPTY_NODE(&loc->cl_node));
+
+	kfree(loc);
+}
+
+static int crush_loc_compare(const struct crush_loc *loc1,
+			     const struct crush_loc *loc2)
+{
+	return strcmp(loc1->cl_type_name, loc2->cl_type_name) ?:
+	       strcmp(loc1->cl_name, loc2->cl_name);
+}
+
+DEFINE_RB_FUNCS2(crush_loc, struct crush_loc_node, cl_loc, crush_loc_compare,
+		 RB_BYPTR, const struct crush_loc *, cl_node)
+
+/*
+ * Parses a set of <bucket type name>':'<bucket name> pairs separated
+ * by '|', e.g. "rack:foo1|rack:foo2|datacenter:bar".
+ *
+ * Note that @crush_location is modified by strsep().
+ */
+int ceph_parse_crush_location(char *crush_location, struct rb_root *locs)
+{
+	struct crush_loc_node *loc;
+	const char *type_name, *name, *colon;
+	size_t type_name_len, name_len;
+
+	dout("%s '%s'\n", __func__, crush_location);
+	while ((type_name = strsep(&crush_location, "|"))) {
+		colon = strchr(type_name, ':');
+		if (!colon)
+			return -EINVAL;
+
+		type_name_len = colon - type_name;
+		if (type_name_len == 0)
+			return -EINVAL;
+
+		name = colon + 1;
+		name_len = strlen(name);
+		if (name_len == 0)
+			return -EINVAL;
+
+		loc = alloc_crush_loc(type_name_len, name_len);
+		if (!loc)
+			return -ENOMEM;
+
+		loc->cl_loc.cl_type_name = loc->cl_data;
+		memcpy(loc->cl_loc.cl_type_name, type_name, type_name_len);
+		loc->cl_loc.cl_type_name[type_name_len] = '\0';
+
+		loc->cl_loc.cl_name = loc->cl_data + type_name_len + 1;
+		memcpy(loc->cl_loc.cl_name, name, name_len);
+		loc->cl_loc.cl_name[name_len] = '\0';
+
+		if (!__insert_crush_loc(locs, loc)) {
+			free_crush_loc(loc);
+			return -EEXIST;
+		}
+
+		dout("%s type_name '%s' name '%s'\n", __func__,
+		     loc->cl_loc.cl_type_name, loc->cl_loc.cl_name);
+	}
+
+	return 0;
+}
+
+int ceph_compare_crush_locs(struct rb_root *locs1, struct rb_root *locs2)
+{
+	struct rb_node *n1 = rb_first(locs1);
+	struct rb_node *n2 = rb_first(locs2);
+	int ret;
+
+	for ( ; n1 && n2; n1 = rb_next(n1), n2 = rb_next(n2)) {
+		struct crush_loc_node *loc1 =
+		    rb_entry(n1, struct crush_loc_node, cl_node);
+		struct crush_loc_node *loc2 =
+		    rb_entry(n2, struct crush_loc_node, cl_node);
+
+		ret = crush_loc_compare(&loc1->cl_loc, &loc2->cl_loc);
+		if (ret)
+			return ret;
+	}
+
+	if (!n1 && n2)
+		return -1;
+	if (n1 && !n2)
+		return 1;
+	return 0;
+}
+
+void ceph_clear_crush_locs(struct rb_root *locs)
+{
+	while (!RB_EMPTY_ROOT(locs)) {
+		struct crush_loc_node *loc =
+		    rb_entry(rb_first(locs), struct crush_loc_node, cl_node);
+
+		erase_crush_loc(locs, loc);
+		free_crush_loc(loc);
+	}
+}
-- 
2.19.2

