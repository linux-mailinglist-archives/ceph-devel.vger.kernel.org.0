Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410F51E925A
	for <lists+ceph-devel@lfdr.de>; Sat, 30 May 2020 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgE3Per (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 30 May 2020 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbgE3Peo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 30 May 2020 11:34:44 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E836C03E969
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:44 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id p5so1206409wrw.9
        for <ceph-devel@vger.kernel.org>; Sat, 30 May 2020 08:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CtfUoJdLkeIMazmkkq0hh8Q0ZCYV6HnsHLCP75iHdAA=;
        b=YqsQWd5VaEVO6d1mO+Y1Gv7dE1kgjL2U3G/jfdW6fFIDD/zm6F3c3aKgsif3qTEj/D
         XU9K7f1mbe3Z9xGALIrFMHf3Zn/TDKysGjwUWuNmeE5PLGvQuDX2IHJLxf0VfZWC86i4
         EOGeBvJDFcHHNOTStYwLgrlne3bGf8OlTxbVDenbOAQKqiRqpO2BaecNWB4qUhA/oPtS
         LIv9lDv/SDcjjdkre7Gk+RHLntZQ+CGmeXm5BruYALxliZsOLu81pjJGRg2j3kxXbrAB
         Jw2KxPMWJ3k1tZJrhF9gjTHPSqTjNeghsME0NVlxO/K7l+hFyY0UnT4eW/4kEJCzIN33
         CUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CtfUoJdLkeIMazmkkq0hh8Q0ZCYV6HnsHLCP75iHdAA=;
        b=t/iYRQRkGVWmOuDepTZJ+APzfZf8VLjrTXwEG5V5Vya2DtaL30EYOFvH2HupdBdAwb
         uFWVBn8zRnKKu/pC7VyRXgrcFowjX8vf18L3SG1/PftQaBzeueG43IQ+njUVjE+fXv0O
         FxbiZW+qoe4eWcZXqV7pJSXTbRHGIc4uxatfq9VeqOt8WDNay4rG4VjWISavbUXSTVUE
         r0UKa6XhSCaEmjrrZMpy0o5K07bmRD8s3vFIAkE4Cqc2hqgSz8AMh6+OdqupXXXnjSux
         KwWeOwM5LobkcVvMoiD7RQYDMC2Ps6Bf1/hCcz45LFQy1DT7AqwfYyVJt5MSZpvG1895
         blmg==
X-Gm-Message-State: AOAM5321HMwSmSMuirxx6QA34vjYq97i0Ygj3z8pndBgJLCAvKMP5+XL
        OrzgoF19POrV4M46IAGYZhj64zCKM4k=
X-Google-Smtp-Source: ABdhPJzDQ/Pd9SYPdyp5e3vtdRVhYl1O7hO5sTxw4OIwBHpr1SXugJAOqfuyOimToRvUicaZZx4H/w==
X-Received: by 2002:adf:fe8d:: with SMTP id l13mr13439145wrr.282.1590852882822;
        Sat, 30 May 2020 08:34:42 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id z132sm4835068wmc.29.2020.05.30.08.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 08:34:42 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 4/5] libceph: support for balanced and localized reads
Date:   Sat, 30 May 2020 17:34:38 +0200
Message-Id: <20200530153439.31312-5-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200530153439.31312-1-idryomov@gmail.com>
References: <20200530153439.31312-1-idryomov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

OSD-side issues with reads from replica have been resolved in
Octopus.  Reading from replica should be safe wrt. unstable or
uncommitted state now, so add support for balanced and localized
reads.

There are two cases when a read from replica can't be served:

- OSD may silently drop the request, expecting the client to
  notice that the acting set has changed and resend via the usual
  means (handled with t->used_replica)

- OSD may return EAGAIN, expecting the client to resend to the
  primary, ignoring replica read flags (see handle_reply())

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 include/linux/ceph/osd_client.h |   1 +
 include/linux/ceph/osdmap.h     |   3 +
 net/ceph/debugfs.c              |   6 +-
 net/ceph/osd_client.c           |  87 +++++++++++++++++++++++++--
 net/ceph/osdmap.c               | 102 ++++++++++++++++++++++++++++++++
 5 files changed, 193 insertions(+), 6 deletions(-)

diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 734f7c6a9f56..671fb93e8c60 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -165,6 +165,7 @@ struct ceph_osd_request_target {
 	bool recovery_deletes;
 
 	unsigned int flags;                /* CEPH_OSD_FLAG_* */
+	bool used_replica;
 	bool paused;
 
 	u32 epoch;
diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
index 8c9d18cc9f45..3f4498fef6ad 100644
--- a/include/linux/ceph/osdmap.h
+++ b/include/linux/ceph/osdmap.h
@@ -317,6 +317,9 @@ int ceph_parse_crush_location(char *crush_location, struct rb_root *locs);
 int ceph_compare_crush_locs(struct rb_root *locs1, struct rb_root *locs2);
 void ceph_clear_crush_locs(struct rb_root *locs);
 
+int ceph_get_crush_locality(struct ceph_osdmap *osdmap, int id,
+			    struct rb_root *locs);
+
 extern struct ceph_pg_pool_info *ceph_pg_pool_by_id(struct ceph_osdmap *map,
 						    u64 id);
 extern const char *ceph_pg_pool_name_by_id(struct ceph_osdmap *map, u64 id);
diff --git a/net/ceph/debugfs.c b/net/ceph/debugfs.c
index 1344f232ecc5..409d505ff320 100644
--- a/net/ceph/debugfs.c
+++ b/net/ceph/debugfs.c
@@ -81,11 +81,13 @@ static int osdmap_show(struct seq_file *s, void *p)
 		u32 state = map->osd_state[i];
 		char sb[64];
 
-		seq_printf(s, "osd%d\t%s\t%3d%%\t(%s)\t%3d%%\n",
+		seq_printf(s, "osd%d\t%s\t%3d%%\t(%s)\t%3d%%\t%2d\n",
 			   i, ceph_pr_addr(addr),
 			   ((map->osd_weight[i]*100) >> 16),
 			   ceph_osdmap_state_str(sb, sizeof(sb), state),
-			   ((ceph_get_primary_affinity(map, i)*100) >> 16));
+			   ((ceph_get_primary_affinity(map, i)*100) >> 16),
+			   ceph_get_crush_locality(map, i,
+					   &client->options->crush_locs));
 	}
 	for (n = rb_first(&map->pg_temp); n; n = rb_next(n)) {
 		struct ceph_pg_mapping *pg =
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ece124a5138e..4ce6cdc744e4 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1497,6 +1497,45 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
 	       (osdc->osdmap->epoch < osdc->epoch_barrier);
 }
 
+static int pick_random_replica(const struct ceph_osds *acting)
+{
+	int i = prandom_u32() % acting->size;
+
+	dout("%s picked osd%d, primary osd%d\n", __func__,
+	     acting->osds[i], acting->primary);
+	return i;
+}
+
+/*
+ * Picks the closest replica based on client's location given by
+ * crush_location option.  Prefers the primary if the locality is
+ * the same.
+ */
+static int pick_closest_replica(struct ceph_osd_client *osdc,
+				const struct ceph_osds *acting)
+{
+	struct ceph_options *opt = osdc->client->options;
+	int best_i, best_locality;
+	int i = 0, locality;
+
+	do {
+		locality = ceph_get_crush_locality(osdc->osdmap,
+						   acting->osds[i],
+						   &opt->crush_locs);
+		if (i == 0 ||
+		    (locality >= 0 && best_locality < 0) ||
+		    (locality >= 0 && best_locality >= 0 &&
+		     locality < best_locality)) {
+			best_i = i;
+			best_locality = locality;
+		}
+	} while (++i < acting->size);
+
+	dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
+	     acting->osds[best_i], best_locality, acting->primary);
+	return best_i;
+}
+
 enum calc_target_result {
 	CALC_TARGET_NO_ACTION = 0,
 	CALC_TARGET_NEED_RESEND,
@@ -1510,6 +1549,8 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 	struct ceph_pg_pool_info *pi;
 	struct ceph_pg pgid, last_pgid;
 	struct ceph_osds up, acting;
+	bool is_read = t->flags & CEPH_OSD_FLAG_READ;
+	bool is_write = t->flags & CEPH_OSD_FLAG_WRITE;
 	bool force_resend = false;
 	bool unpaused = false;
 	bool legacy_change = false;
@@ -1540,9 +1581,9 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 	ceph_oid_copy(&t->target_oid, &t->base_oid);
 	ceph_oloc_copy(&t->target_oloc, &t->base_oloc);
 	if ((t->flags & CEPH_OSD_FLAG_IGNORE_OVERLAY) == 0) {
-		if (t->flags & CEPH_OSD_FLAG_READ && pi->read_tier >= 0)
+		if (is_read && pi->read_tier >= 0)
 			t->target_oloc.pool = pi->read_tier;
-		if (t->flags & CEPH_OSD_FLAG_WRITE && pi->write_tier >= 0)
+		if (is_write && pi->write_tier >= 0)
 			t->target_oloc.pool = pi->write_tier;
 
 		pi = ceph_pg_pool_by_id(osdc->osdmap, t->target_oloc.pool);
@@ -1581,7 +1622,8 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 		unpaused = true;
 	}
 	legacy_change = ceph_pg_compare(&t->pgid, &pgid) ||
-			ceph_osds_changed(&t->acting, &acting, any_change);
+			ceph_osds_changed(&t->acting, &acting,
+					  t->used_replica || any_change);
 	if (t->pg_num)
 		split = ceph_pg_is_split(&last_pgid, t->pg_num, pi->pg_num);
 
@@ -1597,7 +1639,24 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 		t->sort_bitwise = sort_bitwise;
 		t->recovery_deletes = recovery_deletes;
 
-		t->osd = acting.primary;
+		if ((t->flags & (CEPH_OSD_FLAG_BALANCE_READS |
+				 CEPH_OSD_FLAG_LOCALIZE_READS)) &&
+		    !is_write && pi->type == CEPH_POOL_TYPE_REP &&
+		    acting.size > 1) {
+			int pos;
+
+			WARN_ON(!is_read || acting.osds[0] != acting.primary);
+			if (t->flags & CEPH_OSD_FLAG_BALANCE_READS) {
+				pos = pick_random_replica(&acting);
+			} else {
+				pos = pick_closest_replica(osdc, &acting);
+			}
+			t->osd = acting.osds[pos];
+			t->used_replica = pos > 0;
+		} else {
+			t->osd = acting.primary;
+			t->used_replica = false;
+		}
 	}
 
 	if (unpaused || legacy_change || force_resend || split)
@@ -3660,6 +3719,26 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 		goto out_unlock_osdc;
 	}
 
+	if (m.result == -EAGAIN) {
+		dout("req %p tid %llu EAGAIN\n", req, req->r_tid);
+		unlink_request(osd, req);
+		mutex_unlock(&osd->lock);
+
+		/*
+		 * The object is missing on the replica or not (yet)
+		 * readable.  Clear pgid to force a resend to the primary
+		 * via legacy_change.
+		 */
+		req->r_t.pgid.pool = 0;
+		req->r_t.pgid.seed = 0;
+		WARN_ON(!req->r_t.used_replica);
+		req->r_flags &= ~(CEPH_OSD_FLAG_BALANCE_READS |
+				  CEPH_OSD_FLAG_LOCALIZE_READS);
+		req->r_tid = 0;
+		__submit_request(req, false);
+		goto out_unlock_osdc;
+	}
+
 	if (m.num_ops != req->r_num_ops) {
 		pr_err("num_ops %d != %d for tid %llu\n", m.num_ops,
 		       req->r_num_ops, req->r_tid);
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 4b81334e9e5b..96c25f5e064a 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -2831,3 +2831,105 @@ void ceph_clear_crush_locs(struct rb_root *locs)
 		free_crush_loc(loc);
 	}
 }
+
+/*
+ * [a-zA-Z0-9-_.]+
+ */
+static bool is_valid_crush_name(const char *name)
+{
+	do {
+		if (!('a' <= *name && *name <= 'z') &&
+		    !('A' <= *name && *name <= 'Z') &&
+		    !('0' <= *name && *name <= '9') &&
+		    *name != '-' && *name != '_' && *name != '.')
+			return false;
+	} while (*++name != '\0');
+
+	return true;
+}
+
+/*
+ * Gets the parent of an item.  Returns its id (<0 because the
+ * parent is always a bucket), type id (>0 for the same reason,
+ * via @parent_type_id) and location (via @parent_loc).  If no
+ * parent, returns 0.
+ *
+ * Does a linear search, as there are no parent pointers of any
+ * kind.  Note that the result is ambigous for items that occur
+ * multiple times in the map.
+ */
+static int get_immediate_parent(struct crush_map *c, int id,
+				u16 *parent_type_id,
+				struct crush_loc *parent_loc)
+{
+	struct crush_bucket *b;
+	struct crush_name_node *type_cn, *cn;
+	int i, j;
+
+	for (i = 0; i < c->max_buckets; i++) {
+		b = c->buckets[i];
+		if (!b)
+			continue;
+
+		/* ignore per-class shadow hierarchy */
+		cn = lookup_crush_name(&c->names, b->id);
+		if (!cn || !is_valid_crush_name(cn->cn_name))
+			continue;
+
+		for (j = 0; j < b->size; j++) {
+			if (b->items[j] != id)
+				continue;
+
+			*parent_type_id = b->type;
+			type_cn = lookup_crush_name(&c->type_names, b->type);
+			parent_loc->cl_type_name = type_cn->cn_name;
+			parent_loc->cl_name = cn->cn_name;
+			return b->id;
+		}
+	}
+
+	return 0;  /* no parent */
+}
+
+/*
+ * Calculates the locality/distance from an item to a client
+ * location expressed in terms of CRUSH hierarchy as a set of
+ * (bucket type name, bucket name) pairs.  Specifically, looks
+ * for the lowest-valued bucket type for which the location of
+ * @id matches one of the locations in @locs, so for standard
+ * bucket types (host = 1, rack = 3, datacenter = 8, zone = 9)
+ * a matching host is closer than a matching rack and a matching
+ * data center is closer than a matching zone.
+ *
+ * Specifying multiple locations (a "multipath" location) such
+ * as "rack=foo1 rack=foo2 datacenter=bar" is allowed -- @locs
+ * is a multimap.  The locality will be:
+ *
+ * - 3 for OSDs in racks foo1 and foo2
+ * - 8 for OSDs in data center bar
+ * - -1 for all other OSDs
+ *
+ * The lowest possible bucket type is 1, so the best locality
+ * for an OSD is 1 (i.e. a matching host).  Locality 0 would be
+ * the OSD itself.
+ */
+int ceph_get_crush_locality(struct ceph_osdmap *osdmap, int id,
+			    struct rb_root *locs)
+{
+	struct crush_loc loc;
+	u16 type_id;
+
+	/*
+	 * Instead of repeated get_immediate_parent() calls,
+	 * the location of @id could be obtained with a single
+	 * depth-first traversal.
+	 */
+	for (;;) {
+		id = get_immediate_parent(osdmap->crush, id, &type_id, &loc);
+		if (id >= 0)
+			return -1;  /* not local */
+
+		if (lookup_crush_loc(locs, &loc))
+			return type_id;
+	}
+}
-- 
2.19.2

