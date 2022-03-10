Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1444D4E34
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 17:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240690AbiCJQKJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 11:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240672AbiCJQKI (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 11:10:08 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A18918E3F6
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 08:09:06 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id j9so3262502vkj.1
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 08:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SVCLF/YQckznuYPq+BMLWNeSiwKEI+yEUlnDK/UAtPo=;
        b=XPgivFpfJT7WEHhK0gBOjXGO6O9fKWVddjNSmPtE4AwH+igFPfuaUEVknIBD/hSUiG
         XIM++k+/nZYQH6LshDfZBjv06bKliC59NNdNh9dnEooIVBMYep7ly0VTqlNOTHtb1kA0
         WcC671OLk2oV8RJ0NocUIkM9dKl6MbZX1c59dIIhzoCKVjvVU7Bn1OtWgEXpgy+17AMO
         8fBt9iLiSEyidpaxt8zg4dlRexqMSEiaJ8eV0aQFK7mJnzGOYYICEWkpaURPEPyNnp42
         M99svMa7XcXvkotfh+3H7GaDJBAl3UeAtA3+nmFyqGJkUB4qFVbhoZIJDTjxh+A4qciX
         t4Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVCLF/YQckznuYPq+BMLWNeSiwKEI+yEUlnDK/UAtPo=;
        b=DTdAP7kcMmTExEVnM/Q4NEi6kL4khtS5d9N79i2Rch6XTizvJFzdWVDd7hw+Epeed+
         NyovJdb87ho6LJKCnqiG1d+Ec0gxmFYXlCP6lSHYGqfBZOuD8vf/8eseXXe38D6A+yYa
         c6wAqUMpESugDb2lxyVysqZT/nzsiYEWGxL+9tmbtom2ZZo4ZvBURkdDThgQWhI3j5vu
         mxRbWZGjQQhaCKkLKCfkFAhOYGkHNs9l6ajYdP/idgEroqCeBK/qz5XI2Pyi6hCVyDJm
         ZsTEpyXLh2c48LcLUBOLrF5ClX+8HRPHtq99VZFRhbwKT2YJoAwHZTZyGfMVugPaKA0A
         JBfA==
X-Gm-Message-State: AOAM533ZvKW5rVQ8vLzdYRFLqASNc1SRWYMDy4ZNOdEsPpRSqIGoSRLv
        eqM+gLVWkxx7OYYlpq2fyn6fxWRy4t/M2fdm4aK350TgnKE=
X-Google-Smtp-Source: ABdhPJyOttLgYFl3Tp7G3VmwSBsa2zyJFWZ6cJmuSEJY5m6KvMIymMuU9ifuYbwqXyu7KkXpWXzehg28hmdSN56v9zs=
X-Received: by 2002:a05:6122:8c8:b0:32a:7010:c581 with SMTP id
 8-20020a05612208c800b0032a7010c581mr2591880vkg.32.1646928544482; Thu, 10 Mar
 2022 08:09:04 -0800 (PST)
MIME-Version: 1.0
References: <d0a7e3d1-f9ca-994e-fa6e-b730b443346d@cybozu.co.jp>
In-Reply-To: <d0a7e3d1-f9ca-994e-fa6e-b730b443346d@cybozu.co.jp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 10 Mar 2022 17:09:32 +0100
Message-ID: <CAOi1vP9SXGRzQF=Thy70QO0NyGjpPBtmCWyF4pfODJNPrWoX0A@mail.gmail.com>
Subject: Re: [PATCH v2] libceph: print fsid and client gid with mon id and osd id
To:     Daichi Mukai <daichi-mukai@cybozu.co.jp>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 9, 2022 at 4:12 AM Daichi Mukai <daichi-mukai@cybozu.co.jp> wrote:
>
> Print fsid and client gid in libceph log messages to distinct from which
> each message come.
>
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
>
> ---
> I took over Satoru's patch.
> https://www.spinics.net/lists/ceph-devel/msg51932.html
> ---
>   net/ceph/mon_client.c |  32 +++++---
>   net/ceph/osd_client.c | 166 +++++++++++++++++++++++++++---------------
>   net/ceph/osdmap.c     |  23 +++---
>   3 files changed, 143 insertions(+), 78 deletions(-)
>
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 6a6898ee4049..975a8d725e30 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -141,8 +141,8 @@ static struct ceph_monmap *ceph_monmap_decode(void **p, void *end, bool msgr2)
>                 if (ret)
>                         goto fail;
>
> -               dout("%s mon%d addr %s\n", __func__, i,
> -                    ceph_pr_addr(&inst->addr));
> +               dout("%s mon%d addr %s (fsid %pU)\n", __func__, i,
> +                    ceph_pr_addr(&inst->addr), &monmap->fsid);
>         }
>
>         return monmap;
> @@ -187,7 +187,8 @@ static void __send_prepared_auth_request(struct ceph_mon_client *monc, int len)
>    */
>   static void __close_session(struct ceph_mon_client *monc)
>   {
> -       dout("__close_session closing mon%d\n", monc->cur_mon);
> +       dout("__close_session closing mon%d (fsid %pU client%lld)\n",
> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>         ceph_msg_revoke(monc->m_auth);
>         ceph_msg_revoke_incoming(monc->m_auth_reply);
>         ceph_msg_revoke(monc->m_subscribe);
> @@ -229,8 +230,9 @@ static void pick_new_mon(struct ceph_mon_client *monc)
>                 monc->cur_mon = n;
>         }
>
> -       dout("%s mon%d -> mon%d out of %d mons\n", __func__, old_mon,
> -            monc->cur_mon, monc->monmap->num_mon);
> +       dout("%s mon%d -> mon%d out of %d mons (fsid %pU client%lld)\n", __func__,
> +            old_mon, monc->cur_mon, monc->monmap->num_mon,
> +            &monc->client->fsid, ceph_client_gid(monc->client));
>   }
>
>   /*
> @@ -252,7 +254,8 @@ static void __open_session(struct ceph_mon_client *monc)
>         monc->sub_renew_after = jiffies; /* i.e., expired */
>         monc->sub_renew_sent = 0;
>
> -       dout("%s opening mon%d\n", __func__, monc->cur_mon);
> +       dout("%s opening mon%d (fsid %pU client%lld)\n", __func__,
> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>         ceph_con_open(&monc->con, CEPH_ENTITY_TYPE_MON, monc->cur_mon,
>                       &monc->monmap->mon_inst[monc->cur_mon].addr);
>
> @@ -279,8 +282,9 @@ static void __open_session(struct ceph_mon_client *monc)
>   static void reopen_session(struct ceph_mon_client *monc)
>   {
>         if (!monc->hunting)
> -               pr_info("mon%d %s session lost, hunting for new mon\n",
> -                   monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr));
> +               pr_info("mon%d %s session lost, hunting for new mon (fsid %pU client%lld)\n",
> +                       monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
> +                       &monc->client->fsid, ceph_client_gid(monc->client));
>
>         __close_session(monc);
>         __open_session(monc);
> @@ -1263,7 +1267,9 @@ EXPORT_SYMBOL(ceph_monc_stop);
>   static void finish_hunting(struct ceph_mon_client *monc)
>   {
>         if (monc->hunting) {
> -               dout("%s found mon%d\n", __func__, monc->cur_mon);
> +               dout("%s found mon%d (fsid %pU client%lld)\n", __func__,
> +                    monc->cur_mon, &monc->client->fsid,
> +                    ceph_client_gid(monc->client));
>                 monc->hunting = false;
>                 monc->had_a_connection = true;
>                 un_backoff(monc);
> @@ -1295,8 +1301,9 @@ static void finish_auth(struct ceph_mon_client *monc, int auth_err,
>                 __send_subscribe(monc);
>                 __resend_generic_request(monc);
>
> -               pr_info("mon%d %s session established\n", monc->cur_mon,
> -                       ceph_pr_addr(&monc->con.peer_addr));
> +               pr_info("mon%d %s session established (client%lld)\n",
> +                       monc->cur_mon, ceph_pr_addr(&monc->con.peer_addr),
> +                       ceph_client_gid(monc->client));
>         }
>   }
>
> @@ -1546,7 +1553,8 @@ static void mon_fault(struct ceph_connection *con)
>         struct ceph_mon_client *monc = con->private;
>
>         mutex_lock(&monc->mutex);
> -       dout("%s mon%d\n", __func__, monc->cur_mon);
> +       dout("%s mon%d (fsid %pU client%lld)\n", __func__,
> +            monc->cur_mon, &monc->client->fsid, ceph_client_gid(monc->client));
>         if (monc->cur_mon >= 0) {
>                 if (!monc->hunting) {
>                         dout("%s hunting for new mon\n", __func__);
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 1c5815530e0d..04d859c04972 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -1271,7 +1271,8 @@ static void __move_osd_to_lru(struct ceph_osd *osd)
>   {
>         struct ceph_osd_client *osdc = osd->o_osdc;
>
> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>         BUG_ON(!list_empty(&osd->o_osd_lru));
>
>         spin_lock(&osdc->osd_lru_lock);
> @@ -1292,7 +1293,8 @@ static void __remove_osd_from_lru(struct ceph_osd *osd)
>   {
>         struct ceph_osd_client *osdc = osd->o_osdc;
>
> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>
>         spin_lock(&osdc->osd_lru_lock);
>         if (!list_empty(&osd->o_osd_lru))
> @@ -1310,7 +1312,8 @@ static void close_osd(struct ceph_osd *osd)
>         struct rb_node *n;
>
>         verify_osdc_wrlocked(osdc);
> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>
>         ceph_con_close(&osd->o_con);
>
> @@ -1347,9 +1350,11 @@ static void close_osd(struct ceph_osd *osd)
>    */
>   static int reopen_osd(struct ceph_osd *osd)
>   {
> +       struct ceph_osd_client *osdc = osd->o_osdc;
>         struct ceph_entity_addr *peer_addr;
>
> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>
>         if (RB_EMPTY_ROOT(&osd->o_requests) &&
>             RB_EMPTY_ROOT(&osd->o_linger_requests)) {
> @@ -1357,7 +1362,7 @@ static int reopen_osd(struct ceph_osd *osd)
>                 return -ENODEV;
>         }
>
> -       peer_addr = &osd->o_osdc->osdmap->osd_addr[osd->o_osd];
> +       peer_addr = &osdc->osdmap->osd_addr[osd->o_osd];
>         if (!memcmp(peer_addr, &osd->o_con.peer_addr, sizeof (*peer_addr)) &&
>                         !ceph_con_opened(&osd->o_con)) {
>                 struct rb_node *n;
> @@ -1405,7 +1410,8 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
>                               &osdc->osdmap->osd_addr[osd->o_osd]);
>         }
>
> -       dout("%s osdc %p osd%d -> osd %p\n", __func__, osdc, o, osd);
> +       dout("%s osdc %p osd%d -> osd %p (fsid %pU client%lld)\n", __func__,
> +            osdc, o, osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>         return osd;
>   }
>
> @@ -1416,15 +1422,18 @@ static struct ceph_osd *lookup_create_osd(struct ceph_osd_client *osdc, int o,
>    */
>   static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>   {
> +       struct ceph_osd_client *osdc = osd->o_osdc;
> +
>         verify_osd_locked(osd);
>         WARN_ON(!req->r_tid || req->r_osd);
> -       dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
> -            req, req->r_tid);
> +       dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
> +            __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
> +            ceph_client_gid(osdc->client));
>
>         if (!osd_homeless(osd))
>                 __remove_osd_from_lru(osd);
>         else
> -               atomic_inc(&osd->o_osdc->num_homeless);
> +               atomic_inc(&osdc->num_homeless);
>
>         get_osd(osd);
>         insert_request(&osd->o_requests, req);
> @@ -1433,10 +1442,13 @@ static void link_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>
>   static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>   {
> +       struct ceph_osd_client *osdc = osd->o_osdc;
> +
>         verify_osd_locked(osd);
>         WARN_ON(req->r_osd != osd);
> -       dout("%s osd %p osd%d req %p tid %llu\n", __func__, osd, osd->o_osd,
> -            req, req->r_tid);
> +       dout("%s osd %p osd%d req %p tid %llu (fsid %pU client%lld)\n",
> +            __func__, osd, osd->o_osd, req, req->r_tid, &osdc->client->fsid,
> +            ceph_client_gid(osdc->client));
>
>         req->r_osd = NULL;
>         erase_request(&osd->o_requests, req);
> @@ -1445,7 +1457,7 @@ static void unlink_request(struct ceph_osd *osd, struct ceph_osd_request *req)
>         if (!osd_homeless(osd))
>                 maybe_move_osd_to_lru(osd);
>         else
> -               atomic_dec(&osd->o_osdc->num_homeless);
> +               atomic_dec(&osdc->num_homeless);
>   }
>
>   static bool __pool_full(struct ceph_pg_pool_info *pi)
> @@ -1532,8 +1544,9 @@ static int pick_closest_replica(struct ceph_osd_client *osdc,
>                 }
>         } while (++i < acting->size);
>
> -       dout("%s picked osd%d with locality %d, primary osd%d\n", __func__,
> -            acting->osds[best_i], best_locality, acting->primary);
> +       dout("%s picked osd%d with locality %d, primary osd%d (fsid %pU client%lld)\n",
> +            __func__, acting->osds[best_i], best_locality, acting->primary,
> +            &osdc->client->fsid, ceph_client_gid(osdc->client));
>         return best_i;
>   }
>
> @@ -1666,8 +1679,10 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
>                 ct_res = CALC_TARGET_NO_ACTION;
>
>   out:
> -       dout("%s t %p -> %d%d%d%d ct_res %d osd%d\n", __func__, t, unpaused,
> -            legacy_change, force_resend, split, ct_res, t->osd);
> +       dout("%s t %p -> %d%d%d%d ct_res %d osd%d (fsid %pU client%lld)\n",
> +            __func__, t, unpaused, legacy_change, force_resend, split,
> +            ct_res, t->osd, &osdc->client->fsid,
> +            ceph_client_gid(osdc->client));
>         return ct_res;
>   }
>
> @@ -1987,9 +2002,10 @@ static bool should_plug_request(struct ceph_osd_request *req)
>         if (!backoff)
>                 return false;
>
> -       dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu\n",
> -            __func__, req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
> -            backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id);
> +       dout("%s req %p tid %llu backoff osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
> +            __func__,  req, req->r_tid, osd->o_osd, backoff->spgid.pgid.pool,
> +            backoff->spgid.pgid.seed, backoff->spgid.shard, backoff->id,
> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>         return true;
>   }
>
> @@ -2296,11 +2312,12 @@ static void send_request(struct ceph_osd_request *req)
>
>         encode_request_partial(req, req->r_request);
>
> -       dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d\n",
> +       dout("%s req %p tid %llu to pgid %llu.%x spgid %llu.%xs%d osd%d e%u flags 0x%x attempt %d (fsid %pU client%lld)\n",
>              __func__, req, req->r_tid, req->r_t.pgid.pool, req->r_t.pgid.seed,
>              req->r_t.spgid.pgid.pool, req->r_t.spgid.pgid.seed,
> -            req->r_t.spgid.shard, osd->o_osd, req->r_t.epoch, req->r_flags,
> -            req->r_attempts);
> +            req->r_t.spgid.shard, osd->o_osd,
> +            req->r_t.epoch, req->r_flags, req->r_attempts,
> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>
>         req->r_t.paused = false;
>         req->r_stamp = jiffies;
> @@ -2788,8 +2805,9 @@ static void link_linger(struct ceph_osd *osd,
>   {
>         verify_osd_locked(osd);
>         WARN_ON(!lreq->linger_id || lreq->osd);
> -       dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
> -            osd->o_osd, lreq, lreq->linger_id);
> +       dout("%s osd %p osd%d lreq %p linger_id %llu (fsid %pU client%lld)\n",
> +            __func__, osd, osd->o_osd, lreq, lreq->linger_id,
> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>
>         if (!osd_homeless(osd))
>                 __remove_osd_from_lru(osd);
> @@ -2806,8 +2824,9 @@ static void unlink_linger(struct ceph_osd *osd,
>   {
>         verify_osd_locked(osd);
>         WARN_ON(lreq->osd != osd);
> -       dout("%s osd %p osd%d lreq %p linger_id %llu\n", __func__, osd,
> -            osd->o_osd, lreq, lreq->linger_id);
> +       dout("%s osd %p osd%d lreq %p linger_id %llu  (fsid %pU client%lld)\n",
> +            __func__, osd, osd->o_osd, lreq, lreq->linger_id,
> +            &osd->o_osdc->client->fsid, ceph_client_gid(osd->o_osdc->client));
>
>         lreq->osd = NULL;
>         erase_linger(&osd->o_linger_requests, lreq);
> @@ -3357,14 +3376,18 @@ static void handle_timeout(struct work_struct *work)
>                         p = rb_next(p); /* abort_request() */
>
>                         if (time_before(req->r_stamp, cutoff)) {
> -                               dout(" req %p tid %llu on osd%d is laggy\n",
> -                                    req, req->r_tid, osd->o_osd);
> +                               dout(" req %p tid %llu on osd%d is laggy (fsid %pU client%lld)\n",
> +                                    req, req->r_tid, osd->o_osd,
> +                                    &osdc->client->fsid,
> +                                    ceph_client_gid(osdc->client));
>                                 found = true;
>                         }
>                         if (opts->osd_request_timeout &&
>                             time_before(req->r_start_stamp, expiry_cutoff)) {
> -                               pr_err_ratelimited("tid %llu on osd%d timeout\n",
> -                                      req->r_tid, osd->o_osd);
> +                               pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
> +                                      req->r_tid, osd->o_osd,
> +                                      &osdc->client->fsid,
> +                                      ceph_client_gid(osdc->client));
>                                 abort_request(req, -ETIMEDOUT);
>                         }
>                 }
> @@ -3372,8 +3395,10 @@ static void handle_timeout(struct work_struct *work)
>                         struct ceph_osd_linger_request *lreq =
>                             rb_entry(p, struct ceph_osd_linger_request, node);
>
> -                       dout(" lreq %p linger_id %llu is served by osd%d\n",
> -                            lreq, lreq->linger_id, osd->o_osd);
> +                       dout(" lreq %p linger_id %llu is served by osd%d (fsid %pU client%lld)\n",
> +                            lreq, lreq->linger_id, osd->o_osd,
> +                            &osdc->client->fsid,
> +                            ceph_client_gid(osdc->client));
>                         found = true;
>
>                         mutex_lock(&lreq->lock);
> @@ -3394,8 +3419,10 @@ static void handle_timeout(struct work_struct *work)
>                         p = rb_next(p); /* abort_request() */
>
>                         if (time_before(req->r_start_stamp, expiry_cutoff)) {
> -                               pr_err_ratelimited("tid %llu on osd%d timeout\n",
> -                                      req->r_tid, osdc->homeless_osd.o_osd);
> +                               pr_err_ratelimited("tid %llu on osd%d timeout (fsid %pU client%lld)\n",
> +                                      req->r_tid, osdc->homeless_osd.o_osd,
> +                                      &osdc->client->fsid,
> +                                      ceph_client_gid(osdc->client));
>                                 abort_request(req, -ETIMEDOUT);
>                         }
>                 }
> @@ -3662,7 +3689,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>
>         down_read(&osdc->lock);
>         if (!osd_registered(osd)) {
> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
> +                    osd->o_osd, &osd->o_osdc->client->fsid,
> +                    ceph_client_gid(osdc->client));
>                 goto out_unlock_osdc;
>         }
>         WARN_ON(osd->o_osd != le64_to_cpu(msg->hdr.src.num));
> @@ -3670,7 +3699,9 @@ static void handle_reply(struct ceph_osd *osd, struct ceph_msg *msg)
>         mutex_lock(&osd->lock);
>         req = lookup_request(&osd->o_requests, tid);
>         if (!req) {
> -               dout("%s osd%d tid %llu unknown\n", __func__, osd->o_osd, tid);
> +               dout("%s osd%d tid %llu unknown (fsid %pU client%lld)\n",
> +                    __func__, osd->o_osd, tid, &osd->o_osdc->client->fsid,
> +                    ceph_client_gid(osdc->client));
>                 goto out_unlock_session;
>         }
>
> @@ -4180,11 +4211,14 @@ static void osd_fault(struct ceph_connection *con)
>         struct ceph_osd *osd = con->private;
>         struct ceph_osd_client *osdc = osd->o_osdc;
>
> -       dout("%s osd %p osd%d\n", __func__, osd, osd->o_osd);
> +       dout("%s osd %p osd%d (fsid %pU client%lld)\n", __func__, osd,
> +            osd->o_osd, &osdc->client->fsid, ceph_client_gid(osdc->client));
>
>         down_write(&osdc->lock);
>         if (!osd_registered(osd)) {
> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
> +                    osd->o_osd, &osdc->client->fsid,
> +                    ceph_client_gid(osdc->client));
>                 goto out_unlock;
>         }
>
> @@ -4299,8 +4333,10 @@ static void handle_backoff_block(struct ceph_osd *osd, struct MOSDBackoff *m)
>         struct ceph_osd_backoff *backoff;
>         struct ceph_msg *msg;
>
> -       dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
> -            m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
> +       dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
> +            __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
> +            m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
> +            ceph_client_gid(osd->o_osdc->client));
>
>         spg = lookup_spg_mapping(&osd->o_backoff_mappings, &m->spgid);
>         if (!spg) {
> @@ -4359,22 +4395,28 @@ static void handle_backoff_unblock(struct ceph_osd *osd,
>         struct ceph_osd_backoff *backoff;
>         struct rb_node *n;
>
> -       dout("%s osd%d spgid %llu.%xs%d id %llu\n", __func__, osd->o_osd,
> -            m->spgid.pgid.pool, m->spgid.pgid.seed, m->spgid.shard, m->id);
> +       dout("%s osd%d spgid %llu.%xs%d id %llu (fsid %pU client%lld)\n",
> +            __func__, osd->o_osd, m->spgid.pgid.pool, m->spgid.pgid.seed,
> +            m->spgid.shard, m->id, &osd->o_osdc->client->fsid,
> +            ceph_client_gid(osd->o_osdc->client));
>
>         backoff = lookup_backoff_by_id(&osd->o_backoffs_by_id, m->id);
>         if (!backoff) {
> -               pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne\n",
> +               pr_err("%s osd%d spgid %llu.%xs%d id %llu backoff dne (fsid %pU client%lld)\n",
>                        __func__, osd->o_osd, m->spgid.pgid.pool,
> -                      m->spgid.pgid.seed, m->spgid.shard, m->id);
> +                      m->spgid.pgid.seed, m->spgid.shard, m->id,
> +                      &osd->o_osdc->client->fsid,
> +                      ceph_client_gid(osd->o_osdc->client));
>                 return;
>         }
>
>         if (hoid_compare(backoff->begin, m->begin) &&
>             hoid_compare(backoff->end, m->end)) {
> -               pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range?\n",
> +               pr_err("%s osd%d spgid %llu.%xs%d id %llu bad range? (fsid %pU client%lld)\n",
>                        __func__, osd->o_osd, m->spgid.pgid.pool,
> -                      m->spgid.pgid.seed, m->spgid.shard, m->id);
> +                      m->spgid.pgid.seed, m->spgid.shard, m->id,
> +                      &osd->o_osdc->client->fsid,
> +                      ceph_client_gid(osd->o_osdc->client));
>                 /* unblock it anyway... */
>         }
>
> @@ -4418,7 +4460,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
>
>         down_read(&osdc->lock);
>         if (!osd_registered(osd)) {
> -               dout("%s osd%d unknown\n", __func__, osd->o_osd);
> +               dout("%s osd%d unknown (fsid %pU client%lld)\n", __func__,
> +                    osd->o_osd, &osd->o_osdc->client->fsid,
> +                    ceph_client_gid(osdc->client));
>                 up_read(&osdc->lock);
>                 return;
>         }
> @@ -4440,7 +4484,9 @@ static void handle_backoff(struct ceph_osd *osd, struct ceph_msg *msg)
>                 handle_backoff_unblock(osd, &m);
>                 break;
>         default:
> -               pr_err("%s osd%d unknown op %d\n", __func__, osd->o_osd, m.op);
> +               pr_err("%s osd%d unknown op %d (fsid %pU client%lld)\n",
> +                      __func__, osd->o_osd, m.op, &osd->o_osdc->client->fsid,
> +                      ceph_client_gid(osdc->client));
>         }
>
>         free_hoid(m.begin);
> @@ -5417,7 +5463,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>
>         down_read(&osdc->lock);
>         if (!osd_registered(osd)) {
> -               dout("%s osd%d unknown, skipping\n", __func__, osd->o_osd);
> +               dout("%s osd%d unknown, skipping (fsid %pU client%lld)\n",
> +                    __func__, osd->o_osd, &osdc->client->fsid,
> +                    ceph_client_gid(osdc->client));
>                 *skip = 1;
>                 goto out_unlock_osdc;
>         }
> @@ -5426,8 +5474,9 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>         mutex_lock(&osd->lock);
>         req = lookup_request(&osd->o_requests, tid);
>         if (!req) {
> -               dout("%s osd%d tid %llu unknown, skipping\n", __func__,
> -                    osd->o_osd, tid);
> +               dout("%s osd%d tid %llu unknown, skipping (fsid %pU client%lld)\n",
> +                    __func__, osd->o_osd, tid, &osdc->client->fsid,
> +                    ceph_client_gid(osdc->client));
>                 *skip = 1;
>                 goto out_unlock_session;
>         }
> @@ -5435,9 +5484,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>         ceph_msg_revoke_incoming(req->r_reply);
>
>         if (front_len > req->r_reply->front_alloc_len) {
> -               pr_warn("%s osd%d tid %llu front %d > preallocated %d\n",
> +               pr_warn("%s osd%d tid %llu front %d > preallocated %d (fsid %pU client%lld)\n",
>                         __func__, osd->o_osd, req->r_tid, front_len,
> -                       req->r_reply->front_alloc_len);
> +                       req->r_reply->front_alloc_len, &osdc->client->fsid,
> +                       ceph_client_gid(osdc->client));
>                 m = ceph_msg_new(CEPH_MSG_OSD_OPREPLY, front_len, GFP_NOFS,
>                                  false);
>                 if (!m)
> @@ -5447,9 +5497,10 @@ static struct ceph_msg *get_reply(struct ceph_connection *con,
>         }
>
>         if (data_len > req->r_reply->data_length) {
> -               pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping\n",
> +               pr_warn("%s osd%d tid %llu data %d > preallocated %zu, skipping (fsid %pU client%lld)\n",
>                         __func__, osd->o_osd, req->r_tid, data_len,
> -                       req->r_reply->data_length);
> +                       req->r_reply->data_length, &osdc->client->fsid,
> +                       ceph_client_gid(osdc->client));
>                 m = NULL;
>                 *skip = 1;
>                 goto out_unlock_session;
> @@ -5508,8 +5559,9 @@ static struct ceph_msg *osd_alloc_msg(struct ceph_connection *con,
>         case CEPH_MSG_OSD_OPREPLY:
>                 return get_reply(con, hdr, skip);
>         default:
> -               pr_warn("%s osd%d unknown msg type %d, skipping\n", __func__,
> -                       osd->o_osd, type);
> +               pr_warn("%s osd%d unknown msg type %d, skipping (fsid %pU client%lld)\n",
> +                       __func__, osd->o_osd, type, &osd->o_osdc->client->fsid,
> +                       ceph_client_gid(osd->o_osdc->client));
>                 *skip = 1;
>                 return NULL;
>         }
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 2823bb3cff55..a9cbd8b88929 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1566,7 +1566,8 @@ static int decode_new_primary_affinity(void **p, void *end,
>                 if (ret)
>                         return ret;
>
> -               pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
> +               pr_info("osd%d primary-affinity 0x%x (fsid %pU)\n", osd, aff,
> +                       &map->fsid);
>         }
>
>         return 0;
> @@ -1728,7 +1729,8 @@ static int osdmap_decode(void **p, void *end, bool msgr2,
>                 if (err)
>                         goto bad;
>
> -               dout("%s osd%d addr %s\n", __func__, i, ceph_pr_addr(addr));
> +               dout("%s osd%d addr %s (fsid %pU)\n", __func__, i,
> +                    ceph_pr_addr(addr), &map->fsid);
>         }
>
>         /* pg_temp */
> @@ -1864,9 +1866,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>                 osd = ceph_decode_32(p);
>                 w = ceph_decode_32(p);
>                 BUG_ON(osd >= map->max_osd);
> -               pr_info("osd%d weight 0x%x %s\n", osd, w,
> -                    w == CEPH_OSD_IN ? "(in)" :
> -                    (w == CEPH_OSD_OUT ? "(out)" : ""));
> +               pr_info("osd%d weight 0x%x %s (fsid %pU)\n", osd, w,
> +                       w == CEPH_OSD_IN ? "(in)" :
> +                       (w == CEPH_OSD_OUT ? "(out)" : ""),
> +                       &map->fsid);
>                 map->osd_weight[osd] = w;
>
>                 /*
> @@ -1898,10 +1901,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>                 BUG_ON(osd >= map->max_osd);
>                 if ((map->osd_state[osd] & CEPH_OSD_UP) &&
>                     (xorstate & CEPH_OSD_UP))
> -                       pr_info("osd%d down\n", osd);
> +                       pr_info("osd%d down (fsid %pU)\n", osd, &map->fsid);
>                 if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
>                     (xorstate & CEPH_OSD_EXISTS)) {
> -                       pr_info("osd%d does not exist\n", osd);
> +                       pr_info("osd%d does not exist (fsid %pU)\n", osd,
> +                               &map->fsid);
>                         ret = set_primary_affinity(map, osd,
>                                                    CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
>                         if (ret)
> @@ -1929,9 +1933,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>                 if (ret)
>                         return ret;
>
> -               dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
> +               dout("%s osd%d addr %s (fsid %pU)\n", __func__, osd,
> +                    ceph_pr_addr(&addr), &map->fsid);
>
> -               pr_info("osd%d up\n", osd);
> +               pr_info("osd%d up (fsid %pU)\n", osd, &map->fsid);
>                 map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
>                 map->osd_addr[osd] = addr;
>         }
> --
> 2.25.1

Hi Daichi,

I would suggest two things:

1) Leave dout messages alone for now.  They aren't shown by default and
   are there for developers to do debugging.  In that setting, multiple
   clusters or client instances should be rare.

2) For pr_info/pr_warn/etc messages, make the format consistent and
   more grepable, e.g.

     libceph (<fsid> <gid>): <message>

     libceph (ef1ab157-688c-483b-a94d-0aeec9ca44e0 4181): osd10 down

   as I suggested earlier.  Sometimes printing just the fsid, sometimes
   the fsid and the gid and sometimes none is undesirable.

Thanks,

                Ilya
