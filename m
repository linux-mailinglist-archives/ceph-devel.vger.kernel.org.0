Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24DEA1E8198
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 17:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgE2PUR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbgE2PT6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 11:19:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8D8C08C5CB
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:57 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id d7so2435854eja.7
        for <ceph-devel@vger.kernel.org>; Fri, 29 May 2020 08:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Fc62wKrMPH6nZ431LinTdBd252cNnf4Q3NUpiZo8zs=;
        b=FO3TrijP2NIUxVwwOIMQClQXJDL38Ke716C/dxdQWlKSxg9BYyORlc7vb58Z+MLNfc
         +0xWhmxyO9SSm+OTLpGwWW0dpNCP9RweL4RXfW7wEYBJ60RrHkloq0QxSG5aaF3DfKB1
         iWrSZdcMiBv1Rx+3gKSYJYV8B4f0/soy1xIidgHDww3d7NxtnrVbOGUjroFoP/S15+sm
         WeDtrLCgUYIvlLJPd//z12mjV25d9foarNquJOt5OdFGEHrU+9Q+Atjjm/BgGTNPrBq5
         4qZkrrP/fZLllp9a0dEV0NMFCtnUbFAjNxrV9/aFS+A3j4QEYOIaIUOzoVlUtIXhxXIW
         JSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Fc62wKrMPH6nZ431LinTdBd252cNnf4Q3NUpiZo8zs=;
        b=fbgy4bfHoo36GKfksh0iXioQ0KgPNH6yVv+gfCqIO4VUfac6TRPORyuNB169IK+Ho8
         o4Tj4UsDP/q9AGcnMG0AyB72akrgrRviPOoOpnCtoCPTEMwG7PO1pJ2iSPwamYKaU8CB
         AEJnJk1sh24by2DZ0maH1Fj9XWN+he7YdbC0UCfOoNVnoV//27A48WEkas4BmxB9aylo
         RZk8nZX7zVC5czz198+IRXdUOK59HoehuWl6ZXdyKl4Fcg3po+kVwL62I7nMWwPsuNJk
         EVWVkKpGVW3gPjYelaBTi6HM9I7ySmlF79yTistUlJfj4VDbTdxbiSTxduD7gv3yOz0K
         Yn0g==
X-Gm-Message-State: AOAM531IyJTNBETwTn9bx9LIkvZobRv1TBL+SQoTO9Zg6eszSVK6dVc0
        tmYB945iYwZIxouNlD24gXIrbWZ22Jc=
X-Google-Smtp-Source: ABdhPJx/Eo6nN49iTYduHhs3zsqsTYHSKWlPF/Xw6Mban58ipR2ZEE++biUTkswRIVRJTRSXFh0a6w==
X-Received: by 2002:a17:906:c952:: with SMTP id fw18mr6129869ejb.505.1590765595887;
        Fri, 29 May 2020 08:19:55 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id cd17sm6616663ejb.115.2020.05.29.08.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:19:55 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 3/5] libceph: crush_location infrastructure
Date:   Fri, 29 May 2020 17:19:50 +0200
Message-Id: <20200529151952.15184-4-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200529151952.15184-1-idryomov@gmail.com>
References: <20200529151952.15184-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Allow expressing client's location in terms of CRUSH hierarchy as
a set of (bucket type name, bucket name) pairs.  The userspace syntax
"crush_location = key1=value1 key2=value2" is incompatible with mount
options and needed adaptation:

- ':' separator
- one key:value pair per crush_location option
- crush_location options are combined together

So for:

  crush_location = host=foo rack=bar

one would write:

  crush_location=host:foo,crush_location=rack:bar

As in userspace, "multipath" locations are supported, so indicating
locality for parallel hierarchies is possible:

  crush_location=rack:foo1,crush_location=rack:foo2,crush_location=datacenter:bar

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/libceph.h |   1 +
 include/linux/ceph/osdmap.h  |  16 ++++-
 net/ceph/ceph_common.c       |  25 ++++++++
 net/ceph/osdmap.c            | 114 +++++++++++++++++++++++++++++++++++
 4 files changed, 155 insertions(+), 1 deletion(-)

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
index 5e601975745f..ef8619ad1401 100644
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
+int ceph_parse_crush_loc(const char *str, struct rb_root *locs);
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
index a0e97f6c1072..6d495685ee03 100644
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
@@ -454,6 +462,14 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
 		if (!opt->key)
 			return -ENOMEM;
 		return get_secret(opt->key, param->string, &log);
+	case Opt_crush_location:
+		err = ceph_parse_crush_loc(param->string, &opt->crush_locs);
+		if (err) {
+			error_plog(&log, "Failed to parse crush location: %d",
+				   err);
+			return err;
+		}
+		break;
 
 	case Opt_osdtimeout:
 		warn_plog(&log, "Ignoring osdtimeout");
@@ -536,6 +552,7 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 {
 	struct ceph_options *opt = client->options;
 	size_t pos = m->count;
+	struct rb_node *n;
 
 	if (opt->name) {
 		seq_puts(m, "name=");
@@ -545,6 +562,14 @@ int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
 	if (opt->key)
 		seq_puts(m, "secret=<hidden>,");
 
+	for (n = rb_first(&opt->crush_locs); n; n = rb_next(n)) {
+		struct crush_loc_node *loc =
+		    rb_entry(n, struct crush_loc_node, cl_node);
+
+		seq_printf(m, "crush_location=%s:%s,",
+			   loc->cl_loc.cl_type_name, loc->cl_loc.cl_name);
+	}
+
 	if (opt->flags & CEPH_OPT_FSID)
 		seq_printf(m, "fsid=%pU,", &opt->fsid);
 	if (opt->flags & CEPH_OPT_NOSHARE)
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index e74130876d3a..995cdb8b559e 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -2715,3 +2715,117 @@ int ceph_pg_to_acting_primary(struct ceph_osdmap *osdmap,
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
+ * A <bucket type name>:<bucket name> pair, e.g. "zone:us-east".
+ */
+int ceph_parse_crush_loc(const char *str, struct rb_root *locs)
+{
+	struct crush_loc_node *loc;
+	const char *type_name, *name;
+	size_t type_name_len, name_len;
+
+	type_name = str;
+	str = strchrnul(str, ':');
+	if (*str == '\0')
+		return -EINVAL;  /* no ':' */
+
+	type_name_len = str - type_name;
+	if (type_name_len == 0)
+		return -EINVAL;
+
+	name = ++str;
+	str = strchrnul(str, ':');
+	if (*str != '\0')
+		return -EINVAL;  /* another ':' */
+
+	name_len = str - name;
+	if (name_len == 0)
+		return -EINVAL;
+
+	loc = alloc_crush_loc(type_name_len, name_len);
+	if (!loc)
+		return -ENOMEM;
+
+	loc->cl_loc.cl_type_name = loc->cl_data;
+	memcpy(loc->cl_loc.cl_type_name, type_name, type_name_len);
+	loc->cl_loc.cl_type_name[type_name_len] = '\0';
+
+	loc->cl_loc.cl_name = loc->cl_data + type_name_len + 1;
+	memcpy(loc->cl_loc.cl_name, name, name_len);
+	loc->cl_loc.cl_name[name_len] = '\0';
+
+	if (!__insert_crush_loc(locs, loc)) {
+		free_crush_loc(loc);
+		return -EEXIST;
+	}
+
+	dout("%s type_name '%s' name '%s'\n", __func__,
+	     loc->cl_loc.cl_type_name, loc->cl_loc.cl_name);
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

