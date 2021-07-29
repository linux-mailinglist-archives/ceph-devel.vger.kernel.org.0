Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319F13D9E3C
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jul 2021 09:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhG2HTM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Jul 2021 03:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbhG2HTA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 29 Jul 2021 03:19:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F68FC0613C1
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jul 2021 00:18:57 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso7956445pjo.1
        for <ceph-devel@vger.kernel.org>; Thu, 29 Jul 2021 00:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7tfzYiGAu1hgUx+AtMXkEVG1ft/9hE5YChgnfU0kEG0=;
        b=hP38vzfRS7NKSS7eFUkAJHv3qgpH9gmC4awLnhT3z040NQCmSx+2OCG3zyATtcpsvu
         rmGBHeyGU2Nd2ZL8FuVcUtKLwYx1quvuaCYIKU8QYZXaScKRm5t+GGfcMdmPt8WXqoBk
         jN7DYTy5LmYV5f2yHJ93N6B/OF3ot8S95id61Z5JO3pFskdBO8cEZRkmbrJcILlFXKWl
         u4pzkx1FzuKJys468iHp7iszRh6atQdPuDzK7yqE8OABj5f9mqk4yW1rUkDN3LrOO8VH
         gs8Bl++gnYV0JsytBcOMrYicwb+b7V9O7JnBt63uTJKU9DEAes0WxtmNtPqlwZtAb/6k
         rVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7tfzYiGAu1hgUx+AtMXkEVG1ft/9hE5YChgnfU0kEG0=;
        b=t+nEnfq2KPYMS/lVr0lxkgiJhOxSaCDzd4sYHEmw2UPalJGU3BaYrvQ6FY8ub/2j3M
         LgTUMBXLqGr54t2diCQM2M4/qvrvlXua1yeK8Dux9jgOgigsUHCX/5/j8kiLohxipJQA
         qQdUKZ4VKXPuxDKeurnrDnEpqveymhiPCEZV6oCHyP17uVVCImNpbWZBW4LFwJOjWmDb
         blOrblxV0B5V/8eCZ7FjyWP+LY94Aws18ZrZtBdB26ZhV49Ck62yanBPg1UpvZkOLkh3
         aEyjALMix0RQ3zZTuxgaelhtcw2rK1KGVj5monYJemWurXqIdpEPAyG07ZktXzaQreH6
         QGGQ==
X-Gm-Message-State: AOAM530suXFF81tnr7ULq9S7WC73h+eZiNXq3H5oAFix5BiAAbF87vs2
        P+QreQiwG2K1MiiCcwzmiZKu8Vm8gF7U1swF
X-Google-Smtp-Source: ABdhPJx1fjJB1zJSIjafBhi0MnSqkqztgvOuEdPv9Em8HUyeSEqLpr5gC+mZcXVIEtwB/AeP9TObhA==
X-Received: by 2002:a05:6a00:a94:b029:384:1dc6:7012 with SMTP id b20-20020a056a000a94b02903841dc67012mr3702094pfl.53.1627543136127;
        Thu, 29 Jul 2021 00:18:56 -0700 (PDT)
Received: from localhost.localdomain (tvk033142.tvk.ne.jp. [202.222.33.142])
        by smtp.gmail.com with ESMTPSA id w2sm8062681pjd.35.2021.07.29.00.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 00:18:55 -0700 (PDT)
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
To:     ceph-devel@vger.kernel.org
Cc:     Satoru Takeuchi <satoru.takeuchi@gmail.com>
Subject: [PATCH] ceph: print fsid with mon id and osd id
Date:   Thu, 29 Jul 2021 07:18:51 +0000
Message-Id: <20210729071851.1244874-1-satoru.takeuchi@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Print fsid in libceph log messages to distinct from which each message come.

Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
---
 net/ceph/mon_client.c |  26 +++++----
 net/ceph/osd_client.c | 129 ++++++++++++++++++++++++------------------
 net/ceph/osdmap.c     |  16 +++---
 3 files changed, 98 insertions(+), 73 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 013cbdb6cfe2..c5db73da1c3d 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -141,7 +141,8 @@ static struct ceph_monmap *ceph_monmap_decode(void **p, void *end, bool msgr2)
 		if (ret)
 			goto fail;
 
-		dout("%s mon%d addr %s\n", __func__, i,
+		dout("%s mon%d(fsid=%pU) addr %s\n", __func__,
+		     i, &monmap->fsid,
 		     ceph_pr_addr(&inst->addr));
 	}
 
@@ -187,7 +188,8 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
  */
 static void __close_session(struct ceph_mon_client *monc)
 {
-	dout("__close_session closing mon%d\n", monc->cur_mon);
+	dout("__close_session closing mon%d(fsid=%pU)\n", monc->cur_mon,
+		&monc->client->fsid);
 	ceph_msg_revoke(monc->m_auth);
 	ceph_msg_revoke_incoming(monc->m_auth_reply);
 	ceph_msg_revoke(monc->m_subscribe);
@@ -229,8 +231,8 @@ static void pick_new_mon(struct ceph_mon_client *monc)
 		monc->cur_mon = n;
 	}
 
-	dout("%s mon%d -> mon%d out of %d mons\n", __func__, old_mon,
-	     monc->cur_mon, monc->monmap->num_mon);
+	dout("%s mon%d(fsid=%pU) -> mon%d out of %d mons\n", __func__, old_mon,
+	     &monc->client->fsid, monc->cur_mon, monc->monmap->num_mon);
 }
 
 /*
@@ -252,7 +254,8 @@ static void __open_session(struct ceph_mon_client *monc)
 	monc->sub_renew_after = jiffies; /* i.e., expired */
 	monc->sub_renew_sent = 0;
 
-	dout("%s opening mon%d\n", __func__, monc->cur_mon);
+	dout("%s opening mon%d(fsid=%pU)\n", __func__,
+		monc->cur_mon, &monc->client->fsid);
 	ceph_con_open(&monc->con, CEPH_ENTITY_TYPE_MON, monc->cur_mon,
 		      &monc->monmap->mon_inst[monc->cur_mon].addr);
 
@@ -279,8 +282,8 @@ static void __open_session(struct ceph_mon_client *monc)
 static void reopen_session(struct ceph_mon_client *monc)
 {
 	if (!monc->hunting)
-		pr_info("mon%d %s session lost, hunting for new mon\n",
-		    monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr));
+		pr_info("mon%d(fsid=%pU) %s session lost, hunting for new mon\n",
+		    monc->cur_mon, &monc->client->fsid, ceph_pr_addr(&monc->con.peer_addr));
 
 	__close_session(monc);
 	__open_session(monc);
@@ -1264,7 +1267,8 @@ EXPORT_SYMBOL(ceph_monc_stop);
 static void finish_hunting(struct ceph_mon_client *monc)
 {
 	if (monc->hunting) {
-		dout("%s found mon%d\n", __func__, monc->cur_mon);
+		dout("%s found mon%d(fsid=%pU)\n", __func__,
+			monc->cur_mon, &monc->client->fsid);
 		monc->hunting = false;
 		monc->had_a_connection = true;
 		un_backoff(monc);
@@ -1296,7 +1300,8 @@ static void finish_auth(struct ceph_mon_client *monc, int auth_err,
 		__send_subscribe(monc);
 		__resend_generic_request(monc);
 
-		pr_info("mon%d %s session established\n", monc->cur_mon,
+		pr_info("mon%d(fsid=%pU) %s session established\n", monc->cur_mon,
+			monc->client->fsid,
 			ceph_pr_addr(&monc->con.peer_addr));
 	}
 }
@@ -1547,7 +1552,8 @@ static void mon_fault(struct ceph_connection *con)
 	struct ceph_mon_client *monc = con->private;
 
 	mutex_lock(&monc->mutex);
-	dout("%s mon%d\n", __func__, monc->cur_mon);
+	dout("%s mon%d(fsid=%pU)\n", __func__, monc->cur_mon,
+		&monc->client->fsid);
 	if (monc->cur_mon >= 0) {
 		if (!monc->hunting) {
 			dout("%s hunting for new mon\n", __func__);
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index ff8624a7c964..5bb47b20f288 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1271,7 +1271,8 @@ static void __move_osd_to_lru(struct ceph_osd *osd)
 {
 	struct ceph_osd_client *osdc = osd->o_osdc;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d(fsid=%pU)\n", __func__, osd, osd->o_osd,
+		&osd->o_osdc->client->fsid);
 	BUG_ON(!list_empty(&osd->o_osd_lru));
 
 	spin_lock(&osdc->osd_lru_lock);
@@ -1292,7 +1293,8 @@ static void __remove_osd_from_lru(struct ceph_osd *osd)
 {
 	struct ceph_osd_client *osdc = osd->o_osdc;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d(fsid=%pU)\n", __func__, osd, osd->o_osd,
+		&osd->o_osdc->client->fsid);
 
 	spin_lock(&osdc->osd_lru_lock);
 	if (!list_empty(&osd->o_osd_lru))
@@ -1310,7 +1312,8 @@ static void close_osd(struct ceph_osd *osd)
 	struct rb_node *n;
 
 	verify_osdc_wrlocked(osdc);
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d(fsid=%pU)\n", __func__, osd, osd->o_osd,
+		&osdc->client->fsid);
 
 	ceph_con_close(&osd->o_con);
 
@@ -1349,7 +1352,8 @@ static int reopen_osd(struct ceph_osd *osd)
 {
 	struct ceph_entity_addr *peer_addr;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d(fsid=%pU)\n", __func__, osd, osd->o_osd,
+		&osd->o_osdc->client->fsid);
 
 	if (RB_EMPTY_ROOT(&osd->o_requests) &&
 	    RB_EMPTY_ROOT(&osd->o_linger_requests)) {
@@ -1405,7 +1409,8 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
 			      &osdc->osdmap->osd_addr[osd->o_osd]);
 	}
 
-	dout("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
+	dout("%s osdc %p osd%d(fsid=%pU) -> osd %p\n", __func__, osdc, o,
+		&osdc->client->fsid, osd);
 	return osd;
 }
 
@@ -1418,8 +1423,8 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 {
 	verify_osd_locked(osd);
 	WARN_ON(!req->r_tid || req->r_osd);
-	dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
-	     req, req->r_tid);
+	dout("%s osd %p osd%d(fsid=%pU) req %p tid %llu\n", __func__, osd,
+		osd->o_osd, &osd->o_osdc->client->fsid, req, req->r_tid);
 
 	if (!osd_homeless(osd))
 		__remove_osd_from_lru(osd);
@@ -1435,8 +1440,8 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
 {
 	verify_osd_locked(osd);
 	WARN_ON(req->r_osd != osd);
-	dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
-	     req, req->r_tid);
+	dout("%s osd %p osd%d(fsid=%pU) req %p tid %llu\n", __func__, osd,
+		osd->o_osd, &osd->o_osdc->client->fsid, req, req->r_tid);
 
 	req->r_osd = NULL;
 	erase_request(&osd->o_requests, req);
@@ -1498,12 +1503,12 @@ static bool target_should_be_paused(struct ceph_osd_client *osdc,
 	       (osdc->osdmap->epoch < osdc->epoch_barrier);
 }
 
-static int pick_random_replica(const struct ceph_osds *acting)
+static int pick_random_replica(struct ceph_osd_client *osdc, const struct ceph_osds *acting)
 {
 	int i = prandom_u32() % acting->size;
 
-	dout("%s picked osd%d, primary osd%d\n", __func__,
-	     acting->osds[i], acting->primary);
+	dout("%s picked osd%d(fsid=%pU), primary osd%d\n", __func__,
+	     acting->osds[i], &osdc->client->fsid, acting->primary);
 	return i;
 }
 
@@ -1532,8 +1537,9 @@ static int pick_closest_replica(struct ceph_osd_client *osdc,
 		}
 	} while (++i < acting->size);
 
-	dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
-	     acting->osds[best_i], best_locality, acting->primary);
+	dout("%s picked osd%d(fsid=%pU) with locality %d, primary osd%d\n", __func__,
+	     acting->osds[best_i], &osdc->client->fsid,
+		 best_locality, acting->primary);
 	return best_i;
 }
 
@@ -1648,7 +1654,7 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 
 			WARN_ON(!is_read || acting.osds[0] != acting.primary);
 			if (t->flags & CEPH_OSD_FLAG_BALANCE_READS) {
-				pos = pick_random_replica(&acting);
+				pos = pick_random_replica(osdc, &acting);
 			} else {
 				pos = pick_closest_replica(osdc, &acting);
 			}
@@ -1666,8 +1672,8 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 		ct_res = CALC_TARGET_NO_ACTION;
 
 out:
-	dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
-	     legacy_change, force_resend, split, ct_res, t->osd);
+	dout("%s t %p -> %d%d%d%d ct_res %d osd%d(fsid=%pU)\n", __func__, t, unpaused,
+	     legacy_change, force_resend, split, ct_res, t->osd, &osdc->client->fsid);
 	return ct_res;
 }
 
@@ -1987,9 +1993,10 @@ static bool should_plug_request(struct ceph_osd_request *req)
 	if (!backoff)
 		return false;
 
-	dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
-	     __func__, req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
-	     backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id);
+	dout("%s req %p tid %llu backoff osd%d(fsid=%pU) spgid %llu.%xs%d id %llu\n",
+	     __func__, req, req->r_tid, osd->o_osd, &osd->o_osdc->client->fsid,
+		 backoff->spgid.pgid.pool, backoff->spgid.pgid.seed, backoff->spgid.shard,
+		 backoff->id);
 	return true;
 }
 
@@ -2296,11 +2303,11 @@ static void send_request(struct ceph_osd_request *req)
 
 	encode_request_partial(req, req->r_request);
 
-	dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
+	dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d(fsid=%pU) e%u flags 0x%x attempt %d\n",
 	     __func__, req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
 	     req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
-	     req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
-	     req->r_attempts);
+	     req->r_t.spgid.shard, osd->o_osd, &osd->o_osdc->client->fsid,
+		 req->r_t.epoch, req->r_flags, req->r_attempts);
 
 	req->r_t.paused = false;
 	req->r_stamp = jiffies;
@@ -2788,8 +2795,8 @@ static void link_linger(struct ceph_osd *osd,
 {
 	verify_osd_locked(osd);
 	WARN_ON(!lreq->linger_id || lreq->osd);
-	dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
-	     osd->o_osd, lreq, lreq->linger_id);
+	dout("%s osd %p osd%d(fsid=%pU) lreq %p linger_id %llu\n", __func__, osd,
+	     osd->o_osd, &osd->o_osdc->client->fsid, lreq, lreq->linger_id);
 
 	if (!osd_homeless(osd))
 		__remove_osd_from_lru(osd);
@@ -2806,8 +2813,8 @@ static void unlink_linger(struct ceph_osd *osd,
 {
 	verify_osd_locked(osd);
 	WARN_ON(lreq->osd != osd);
-	dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
-	     osd->o_osd, lreq, lreq->linger_id);
+	dout("%s osd %p osd%d(fsid=%pU) lreq %p linger_id %llu\n", __func__, osd,
+	     osd->o_osd, &osd->o_osdc->client->fsid, lreq, lreq->linger_id);
 
 	lreq->osd = NULL;
 	erase_linger(&osd->o_linger_requests, lreq);
@@ -3357,14 +3364,14 @@ static void handle_timeout(struct work_struct *work)
 			p = rb_next(p); /* abort_request() */
 
 			if (time_before(req->r_stamp, cutoff)) {
-				dout(" req %p tid %llu on osd%d is laggy\n",
-				     req, req->r_tid, osd->o_osd);
+				dout(" req %p tid %llu on osd%d(fsid=%pU) is laggy\n",
+				     req, req->r_tid, osd->o_osd, &osdc->client->fsid);
 				found = true;
 			}
 			if (opts->osd_request_timeout &&
 			    time_before(req->r_start_stamp, expiry_cutoff)) {
-				pr_err_ratelimited("tid %llu on osd%d timeout\n",
-				       req->r_tid, osd->o_osd);
+				pr_err_ratelimited("tid %llu on osd%d(fsid=%pU) timeout\n",
+				       req->r_tid, osd->o_osd, &osdc->client->fsid);
 				abort_request(req, -ETIMEDOUT);
 			}
 		}
@@ -3372,8 +3379,8 @@ static void handle_timeout(struct work_struct *work)
 			struct ceph_osd_linger_request *lreq =
 			    rb_entry(p, struct ceph_osd_linger_request, node);
 
-			dout(" lreq %p linger_id %llu is served by osd%d\n",
-			     lreq, lreq->linger_id, osd->o_osd);
+			dout(" lreq %p linger_id %llu is served by osd%d(fsid=%pU)\n",
+			     lreq, lreq->linger_id, osd->o_osd, osdc->client->fsid);
 			found = true;
 
 			mutex_lock(&lreq->lock);
@@ -3394,8 +3401,9 @@ static void handle_timeout(struct work_struct *work)
 			p = rb_next(p); /* abort_request() */
 
 			if (time_before(req->r_start_stamp, expiry_cutoff)) {
-				pr_err_ratelimited("tid %llu on osd%d timeout\n",
-				       req->r_tid, osdc->homeless_osd.o_osd);
+				pr_err_ratelimited("tid %llu on osd%d(fsid=%pU) timeout\n",
+				       req->r_tid, osdc->homeless_osd.o_osd,
+					   &osdc->client->fsid);
 				abort_request(req, -ETIMEDOUT);
 			}
 		}
@@ -3662,7 +3670,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		dout("%s osd%d(fsid=%pU) unknown\n", __func__, osd->o_osd,
+			&osd->o_osdc->client->fsid);
 		goto out_unlock_osdc;
 	}
 	WARN_ON(osd->o_osd != le64_to_cpu(msg->hdr.src.num));
@@ -3670,7 +3679,8 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
 	mutex_lock(&osd->lock);
 	req = lookup_request(&osd->o_requests, tid);
 	if (!req) {
-		dout("%s osd%d tid %llu unknown\n", __func__, osd->o_osd, tid);
+		dout("%s osd%d(fsid=%pU) tid %llu unknown\n", __func__,
+			osd->o_osd, &osd->o_osdc->client->fsid, &tid);
 		goto out_unlock_session;
 	}
 
@@ -4180,11 +4190,13 @@ static void osd_fault(struct ceph_connection *con)
 	struct ceph_osd *osd = con->private;
 	struct ceph_osd_client *osdc = osd->o_osdc;
 
-	dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
+	dout("%s osd %p osd%d(fsid=%pU)\n", __func__, osd,
+		&osdc->client->fsid, osd->o_osd);
 
 	down_write(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		dout("%s osd%d(fsid=%pU) unknown\n", __func__,
+			osd->o_osd, &osdc->client->fsid);
 		goto out_unlock;
 	}
 
@@ -4299,7 +4311,8 @@ static void handle_backoff_block(struct ceph_osd *osd, struct MOSDBackoff *m)
 	struct ceph_osd_backoff *backoff;
 	struct ceph_msg *msg;
 
-	dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
+	dout("%s osd%d(fsid=%pU) spgid %llu.%xs%d id %llu\n", __func__,
+	     osd->o_osd, &osd->o_osdc->client->fsid,
 	     m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
 
 	spg = lookup_spg_mapping(&osd->o_backoff_mappings, &m->spgid);
@@ -4359,21 +4372,22 @@ static void handle_backoff_unblock(struct ceph_osd *osd,
 	struct ceph_osd_backoff *backoff;
 	struct rb_node *n;
 
-	dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
+	dout("%s osd%d(fsid=%pU) spgid %llu.%xs%d id %llu\n", __func__,
+	     osd->o_osd, &osd->o_osdc->client->fsid,
 	     m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
 
 	backoff = lookup_backoff_by_id(&osd->o_backoffs_by_id, m->id);
 	if (!backoff) {
-		pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne\n",
-		       __func__, osd->o_osd, m->spgid.pgid.pool,
+		pr_err("%s osd%d(fsid=%pU) spgid %llu.%xs%d id %llu backoff dne\n",
+		       __func__, osd->o_osd, &osd->o_osdc->client->fsid, m->spgid.pgid.pool,
 		       m->spgid.pgid.seed, m->spgid.shard, m->id);
 		return;
 	}
 
 	if (hoid_compare(backoff->begin, m->begin) &&
 	    hoid_compare(backoff->end, m->end)) {
-		pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range?\n",
-		       __func__, osd->o_osd, m->spgid.pgid.pool,
+		pr_err("%s osd%d(fsid=%pU) spgid %llu.%xs%d id %llu bad range?\n",
+		       __func__, osd->o_osd, osd->o_osdc->client->fsid, m->spgid.pgid.pool,
 		       m->spgid.pgid.seed, m->spgid.shard, m->id);
 		/* unblock it anyway... */
 	}
@@ -4418,7 +4432,8 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown\n", __func__, osd->o_osd);
+		dout("%s osd%d(fsid=%pU) unknown\n", __func__,
+			osd->o_osd, &osd->o_osdc->client->fsid);
 		up_read(&osdc->lock);
 		return;
 	}
@@ -4440,7 +4455,8 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
 		handle_backoff_unblock(osd, &m);
 		break;
 	default:
-		pr_err("%s osd%d unknown op %d\n", __func__, osd->o_osd, m.op);
+		pr_err("%s osd%d(fsid=%pU) unknown op %d\n", __func__,
+			osd->o_osd, &osd->o_osdc->client->fsid, m.op);
 	}
 
 	free_hoid(m.begin);
@@ -5459,7 +5475,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 
 	down_read(&osdc->lock);
 	if (!osd_registered(osd)) {
-		dout("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
+		dout("%s osd%d(fsid=%pU) unknown, skipping\n", __func__,
+			osd->o_osd, &osdc->client->fsid);
 		*skip = 1;
 		goto out_unlock_osdc;
 	}
@@ -5468,8 +5485,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	mutex_lock(&osd->lock);
 	req = lookup_request(&osd->o_requests, tid);
 	if (!req) {
-		dout("%s osd%d tid %llu unknown, skipping\n", __func__,
-		     osd->o_osd, tid);
+		dout("%s osd%d(fsid=%pU) tid %llu unknown, skipping\n", __func__,
+		     osd->o_osd, &osdc->client->fsid, tid);
 		*skip = 1;
 		goto out_unlock_session;
 	}
@@ -5477,8 +5494,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	ceph_msg_revoke_incoming(req->r_reply);
 
 	if (front_len > req->r_reply->front_alloc_len) {
-		pr_warn("%s osd%d tid %llu front %d > preallocated %d\n",
-			__func__, osd->o_osd, req->r_tid, front_len,
+		pr_warn("%s osd%d(fsid=%pU) tid %llu front %d > preallocated %d\n",
+			__func__, osd->o_osd, &osdc->client->fsid, req->r_tid, front_len,
 			req->r_reply->front_alloc_len);
 		m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
 				 false);
@@ -5489,8 +5506,8 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
 	}
 
 	if (data_len > req->r_reply->data_length) {
-		pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
-			__func__, osd->o_osd, req->r_tid, data_len,
+		pr_warn("%s osd%d(fsid=%pU) tid %llu data %d > preallocated %zu, skipping\n",
+			__func__, osd->o_osd, &osdc->client->fsid, req->r_tid, data_len,
 			req->r_reply->data_length);
 		m = NULL;
 		*skip = 1;
@@ -5550,8 +5567,8 @@ static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
 	case CEPH_MSG_OSD_OPREPLY:
 		return get_reply(con, hdr, skip);
 	default:
-		pr_warn("%s osd%d unknown msg type %d, skipping\n", __func__,
-			osd->o_osd, type);
+		pr_warn("%s osd%d(fsid=%pU) unknown msg type %d, skipping\n", __func__,
+			osd->o_osd, &osd->o_osdc->client->fsid, type);
 		*skip = 1;
 		return NULL;
 	}
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 75b738083523..24b70bc7225c 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -1566,7 +1566,7 @@ static int decode_new_primary_affinity(void **p, void *end,
 		if (ret)
 			return ret;
 
-		pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
+		pr_info("osd%d(fsid=%pU) primary-affinity 0x%x\n", osd, &map->fsid, aff);
 	}
 
 	return 0;
@@ -1728,7 +1728,8 @@ static int osdmap_decode(void **p, void *end, bool msgr2,
 		if (err)
 			goto bad;
 
-		dout("%s osd%d addr %s\n", __func__, i, ceph_pr_addr(addr));
+		dout("%s osd%d(fsid=%pU) addr %s\n",
+			__func__, i, &map->fsid, ceph_pr_addr(addr));
 	}
 
 	/* pg_temp */
@@ -1864,7 +1865,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
 		osd = ceph_decode_32(p);
 		w = ceph_decode_32(p);
 		BUG_ON(osd >= map->max_osd);
-		pr_info("osd%d weight 0x%x %s\n", osd, w,
+		pr_info("osd%d(fsid=%pU) weight 0x%x %s\n", osd, &map->fsid, w,
 		     w == CEPH_OSD_IN ? "(in)" :
 		     (w == CEPH_OSD_OUT ? "(out)" : ""));
 		map->osd_weight[osd] = w;
@@ -1898,10 +1899,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
 		BUG_ON(osd >= map->max_osd);
 		if ((map->osd_state[osd] & CEPH_OSD_UP) &&
 		    (xorstate & CEPH_OSD_UP))
-			pr_info("osd%d down\n", osd);
+			pr_info("osd%d(fsid=%pU) down\n", osd, &map->fsid);
 		if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
 		    (xorstate & CEPH_OSD_EXISTS)) {
-			pr_info("osd%d does not exist\n", osd);
+			pr_info("osd%d(fsid=%pU) does not exist\n", osd, &map->fsid);
 			ret = set_primary_affinity(map, osd,
 						   CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
 			if (ret)
@@ -1929,9 +1930,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
 		if (ret)
 			return ret;
 
-		dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
+		dout("%s osd%d(fsid=%pU) addr %s\n",
+			__func__, osd, &map->fsid, ceph_pr_addr(&addr));
 
-		pr_info("osd%d up\n", osd);
+		pr_info("osd%d(fsid=%pU) up\n", osd, &map->fsid);
 		map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
 		map->osd_addr[osd] = addr;
 	}
-- 
2.25.1

