Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A90992091
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 11:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbfHSJmg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 05:42:36 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35848 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbfHSJmf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 05:42:35 -0400
Received: by mail-io1-f67.google.com with SMTP id o9so2831444iom.3
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 02:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0DSg2gGpcI9gMm7tzggYQs/xY/jLItnL+n0iKF8ExQ=;
        b=Hgec2wsQhM+MbOy9t7NBV1ADwWuvGNOf5AK/9Ize7M7OzFfIHlnfrMxOjsN3/nXKVP
         2jgA/zEyN0faQYZoxU3PlLBgi96EUeSTQ8F3CHFTyJKQLpMYOZVfQcFguTYxyk+w8j0W
         oTEqBpNysT2i8VoNP77YhcfnirhPhPaRtJX76Oj5WoXkSmlFqtVP3mDHPaMHLu1yOm/B
         8uNdKpf1GxLngaLDY8UFsO9kQ2QAIibN2bJ5Ftzti6RHAGcBp+wfsPJ1isYxU9THtayT
         RWjWcotKVn7UgIJVDhZ+GpXEHMCzq3vIueUV1TUZ/60vtqeCp7LU2LPyiWAEdIz/WTw3
         8CoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0DSg2gGpcI9gMm7tzggYQs/xY/jLItnL+n0iKF8ExQ=;
        b=q6mN7d/F1nS5H1tlwb1qjwe+SZTjO9LaZB1HcELG7ci8M6gRunsqUhdOlPBqAKDhsO
         gDbildEyPPO2Xixu1f8lc4Ei96VARHVZhDLeAjZRWxFMonteNP6UI6tijvnbUopNoD0U
         V3mww64y3jitIzXGD5g1eg1bs+hivR4JI3izGYpq9Wyxc86hWqWOK4hI8lMePhQ93SzU
         Cb1lXSr6Xj3C+PuE1bm3mK7tRkOqj5SymAW2EB7jl54m+h1sTeLGyEDbf8XxXV3l6uoP
         Ne3PGaXq2PyyzTsCXptU/CnTmXy3Fd4fm5g0GjPzTgvHmq5pSNBQ3rQLRe49i4oFLnG8
         Pf9Q==
X-Gm-Message-State: APjAAAWWMANtl0h5+3yVmXR80SjFVdLkFGZemlvrhVj3PHuyrlSfXESp
        B1xcGuLkK9/wKjoVtPcWlVcBbNjznhWnxDlrUkw=
X-Google-Smtp-Source: APXvYqwuIKl/TxKQFgJdIO/03iqZXjvcaBQLma0IFofMrp+x6iDnnu5mbvE5SPUfPvNtpcRsSy7ZNP7zjS4anZ6PK8M=
X-Received: by 2002:a6b:8d90:: with SMTP id p138mr10038136iod.282.1566207754001;
 Mon, 19 Aug 2019 02:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-9-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-9-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 11:45:33 +0200
Message-ID: <CAOi1vP9PS-AqB31aqRMRWSODtjuMFXZCkCu+6yAsFpJ+rCnO0A@mail.gmail.com>
Subject: Re: [PATCH v3 08/15] libceph: journaling: introduce api for journal appending
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Jason Dillaman <jdillama@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 11:43 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> This commit introduce 3 APIs for journal recording:
>
> (1) ceph_journaler_allocate_tag()
>     This api allocate a new tag for user to get a unified
> tag_tid. Then each event appended by this user will be tagged
> by this tag_tid.
>
> (2) ceph_journaler_append()
>     This api allow user to append event to journal objects.
>
> (3) ceph_journaler_client_committed()
>     This api will notify journaling that a event is already
> committed, you can remove it from journal if there is no other
> client refre to it.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  include/linux/ceph/journaler.h |   2 +-
>  net/ceph/journaler.c           | 834 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 835 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ceph/journaler.h b/include/linux/ceph/journaler.h
> index e3b82af..f04fb3f 100644
> --- a/include/linux/ceph/journaler.h
> +++ b/include/linux/ceph/journaler.h
> @@ -173,7 +173,7 @@ static inline uint64_t ceph_journaler_get_max_append_size(struct ceph_journaler
>  struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void);
>  void ceph_journaler_ctx_put(struct ceph_journaler_ctx *journaler_ctx);
>  int ceph_journaler_append(struct ceph_journaler *journaler,
> -                         uint64_t tag_tid, uint64_t *commit_tid,
> +                         uint64_t tag_tid,
>                           struct ceph_journaler_ctx *ctx);
>  void ceph_journaler_client_committed(struct ceph_journaler *journaler,
>                                      uint64_t commit_tid);

These declarations should be added in this patch, not earlier.

> diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
> index 3e92e96..26a5b97 100644
> --- a/net/ceph/journaler.c
> +++ b/net/ceph/journaler.c
> @@ -29,6 +29,42 @@ static char *object_oid_prefix(int pool_id, const char *journal_id)
>         return prefix;
>  }
>
> +static void journaler_flush(struct work_struct *work);
> +static void journaler_client_commit(struct work_struct *work);
> +static void journaler_notify_update(struct work_struct *work);
> +static void journaler_overflow(struct work_struct *work);
> +static void journaler_append_finish(struct work_struct *work);
> +
> +/*
> + * Append got through the following state machine:
> + *
> + *                    JOURNALER_APPEND_START
> + *                              |
> + *                              v
> + *            ..>. . . JOURNALER_APPEND_SEND  . . . .
> + *            .                 |                    .
> + * JOURNALER_APPEND_OVERFLOW    |                    .
> + *                              |                    .
> + *            ^                 v                    v
> + *            .. . . . JOURNALER_APPEND_FLUSH . . >. .
> + *                              |                    .
> + *                              v                 (error)
> + *                     JOURNALER_APPEND_SAFE         v
> + *                              |                    .
> + *                              v                    .
> + *                     JOURNALER_APPEND_FINISH . < . .
> + *
> + * Append starts in JOURNALER_APPEND_START and ends in JOURNALER_APPEND_FINISH
> + */
> +enum journaler_append_state {
> +       JOURNALER_APPEND_START = 1,
> +       JOURNALER_APPEND_SEND,
> +       JOURNALER_APPEND_FLUSH,
> +       JOURNALER_APPEND_OVERFLOW,
> +       JOURNALER_APPEND_SAFE,
> +       JOURNALER_APPEND_FINISH,
> +};
> +
>  /*
>   * journaler_append_ctx is an internal structure to represent an append op.
>   */
> @@ -44,6 +80,7 @@ struct journaler_append_ctx {
>         struct ceph_journaler_entry entry;
>         struct ceph_journaler_ctx journaler_ctx;
>
> +       enum journaler_append_state state;
>         struct kref     kref;
>  };
>
> @@ -151,6 +188,12 @@ struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
>         if (!journaler->notify_wq)
>                 goto err_destroy_task_wq;
>
> +       INIT_WORK(&journaler->flush_work, journaler_flush);
> +       INIT_WORK(&journaler->finish_work, journaler_append_finish);
> +       INIT_DELAYED_WORK(&journaler->commit_work, journaler_client_commit);
> +       INIT_WORK(&journaler->notify_update_work, journaler_notify_update);
> +       INIT_WORK(&journaler->overflow_work, journaler_overflow);

Why do these functions need a workqueue?  Except for commit_work which
runs on a schedule, why journaler_flush() can't be called directly from
the append state machine?  Same for journaler_overflow()?

journaler_notify_update() is queued from more places, but I don't see
a reason for a workqueue for it either.

> +
>         journaler->fetch_buf = NULL;
>         journaler->handle_entry = NULL;
>         journaler->entry_handler = NULL;
> @@ -1287,3 +1330,794 @@ int ceph_journaler_start_replay(struct ceph_journaler *journaler)
>         return ret;
>  }
>  EXPORT_SYMBOL(ceph_journaler_start_replay);
> +
> +// recording
> +static int get_new_entry_tid(struct ceph_journaler *journaler,
> +                             uint64_t tag_tid, uint64_t *entry_tid)
> +{
> +       struct entry_tid *pos;
> +
> +       spin_lock(&journaler->entry_tid_lock);
> +       list_for_each_entry(pos, &journaler->entry_tids, node) {
> +               if (pos->tag_tid == tag_tid) {
> +                       *entry_tid = pos->entry_tid++;
> +                       spin_unlock(&journaler->entry_tid_lock);
> +                       return 0;
> +               }
> +       }
> +
> +       pos = entry_tid_alloc(journaler, tag_tid);
> +       if (!pos) {
> +               spin_unlock(&journaler->entry_tid_lock);
> +               pr_err("failed to allocate new entry.");
> +               return -ENOMEM;
> +       }

This looks like a blocking memory allocation under a spinlock.  If you
run with CONFIG_DEBUG_ATOMIC_SLEEP, you should see a warning.

> +
> +       *entry_tid = pos->entry_tid++;
> +       spin_unlock(&journaler->entry_tid_lock);
> +
> +       return 0;
> +}
> +
> +static uint64_t get_object(struct ceph_journaler *journaler, uint64_t splay_offset)
> +{
> +       return splay_offset + (journaler->splay_width * journaler->active_set);
> +}
> +
> +static void future_init(struct ceph_journaler_future *future,
> +                       uint64_t tag_tid,
> +                                                  uint64_t entry_tid,
> +                                                  uint64_t commit_tid,
> +                       struct ceph_journaler_ctx *journaler_ctx)
> +{
> +       future->tag_tid = tag_tid;
> +       future->entry_tid = entry_tid;
> +       future->commit_tid = commit_tid;
> +
> +       spin_lock_init(&future->lock);
> +       future->safe = false;
> +       future->consistent = false;
> +
> +       future->ctx = journaler_ctx;
> +       future->wait = NULL;
> +}
> +
> +static void set_prev_future(struct ceph_journaler *journaler,
> +                           struct journaler_append_ctx *append_ctx)
> +{
> +       struct ceph_journaler_future *future = &append_ctx->future;
> +       bool prev_future_finished = false;
> +
> +       if (journaler->prev_future == NULL) {
> +               prev_future_finished = true;
> +       } else {
> +               spin_lock(&journaler->prev_future->lock);
> +               prev_future_finished = (journaler->prev_future->consistent &&
> +                                       journaler->prev_future->safe);
> +               journaler->prev_future->wait = append_ctx;
> +               spin_unlock(&journaler->prev_future->lock);
> +       }
> +
> +       spin_lock(&future->lock);
> +       if (prev_future_finished) {
> +               future->consistent = true;
> +       }
> +       spin_unlock(&future->lock);
> +
> +       journaler->prev_future = future;
> +}
> +
> +static void entry_init(struct ceph_journaler_entry *entry,
> +                       uint64_t tag_tid,
> +                       uint64_t entry_tid,
> +                       struct ceph_journaler_ctx *journaler_ctx)
> +{
> +       entry->tag_tid = tag_tid;
> +       entry->entry_tid = entry_tid;
> +       entry->data_len = journaler_ctx->bio_len +
> +                         journaler_ctx->prefix_len + journaler_ctx->suffix_len;
> +}
> +
> +static void journaler_entry_encode_prefix(struct ceph_journaler_entry *entry,
> +                                         void **p, void *end)
> +{
> +       ceph_encode_64(p, PREAMBLE);
> +       ceph_encode_8(p, (uint8_t)1);

No need to cast here.

> +       ceph_encode_64(p, entry->entry_tid);
> +       ceph_encode_64(p, entry->tag_tid);
> +
> +       ceph_encode_32(p, entry->data_len);
> +}
> +
> +static uint32_t crc_bio(uint32_t crc, struct bio *bio, u64 length)
> +{
> +       struct bio_vec bv;
> +       struct bvec_iter iter;
> +       char *buf;
> +       u64 offset = 0;
> +       u64 len = length;
> +
> +next:
> +       bio_for_each_segment(bv, bio, iter) {
> +               buf = page_address(bv.bv_page) + bv.bv_offset;
> +               len = min_t(u64, length, bv.bv_len);
> +               crc = crc32c(crc, buf, len);
> +               offset += len;
> +               length -= len;
> +
> +               if (length == 0)
> +                       goto out;
> +       }
> +
> +       if (length && bio->bi_next) {
> +               bio = bio->bi_next;
> +               goto next;
> +       }
> +
> +       WARN_ON(length != 0);
> +out:
> +       return crc;
> +}

Use ceph_bio_iter_advance_step(), similar to zero_bios() in rbd.c.

> +
> +static void journaler_append_finish(struct work_struct *work)
> +{
> +       struct ceph_journaler *journaler = container_of(work, struct ceph_journaler,
> +                                                       finish_work);
> +       struct journaler_append_ctx *ctx_pos, *next;
> +       LIST_HEAD(tmp_list);
> +
> +       spin_lock(&journaler->finish_lock);
> +       list_splice_init(&journaler->finish_list, &tmp_list);
> +       spin_unlock(&journaler->finish_lock);
> +
> +       list_for_each_entry_safe(ctx_pos, next, &tmp_list, node) {
> +               list_del(&ctx_pos->node);
> +               ctx_pos->journaler_ctx.callback(&ctx_pos->journaler_ctx);
> +       }
> +}
> +
> +static void journaler_handle_append(struct journaler_append_ctx *ctx, int ret);
> +static void future_consistent(struct journaler_append_ctx *append_ctx,
> +                             int result) {
> +       struct ceph_journaler_future *future = &append_ctx->future;
> +       bool future_finished = false;
> +
> +       spin_lock(&future->lock);
> +       future->consistent = true;
> +       future_finished = (future->safe && future->consistent);
> +       spin_unlock(&future->lock);
> +
> +       if (future_finished) {
> +               append_ctx->state = JOURNALER_APPEND_FINISH;
> +               journaler_handle_append(append_ctx, result);
> +       }
> +}
> +
> +static void future_finish(struct journaler_append_ctx *append_ctx,
> +                         int result) {
> +       struct ceph_journaler *journaler = append_ctx->journaler;
> +       struct ceph_journaler_ctx *journaler_ctx = &append_ctx->journaler_ctx;
> +       struct ceph_journaler_future *future = &append_ctx->future;
> +       struct journaler_append_ctx *wait = future->wait;
> +
> +       mutex_lock(&journaler->meta_lock);
> +       if (journaler->prev_future == future)
> +               journaler->prev_future = NULL;
> +       mutex_unlock(&journaler->meta_lock);
> +
> +       spin_lock(&journaler->finish_lock);
> +       if (journaler_ctx->result == 0)
> +               journaler_ctx->result = result;
> +       list_add_tail(&append_ctx->node, &journaler->finish_list);
> +       spin_unlock(&journaler->finish_lock);
> +
> +       queue_work(journaler->task_wq, &journaler->finish_work);
> +       if (wait)
> +               future_consistent(wait, result);
> +}
> +
> +static void journaler_notify_update(struct work_struct *work)
> +{
> +       struct ceph_journaler *journaler = container_of(work,
> +                                                       struct ceph_journaler,
> +                                                       notify_update_work);
> +       int ret = 0;
> +
> +       ret = ceph_osdc_notify(journaler->osdc, &journaler->header_oid,
> +                               &journaler->header_oloc, NULL, 0,
> +                               5000, NULL, NULL);

This needs a define for 5000.

> +       if (ret)
> +               pr_err("notify_update failed: %d", ret);
> +}
> +
> +// advance the active_set to (active_set + 1). This function
> +// will call ceph_cls_journaler_set_active_set to update journal
> +// metadata and notify all clients about this event. We don't
> +// update journaler->active_set in memory currently.
> +//
> +// The journaler->active_set will be updated in refresh() when
> +// we get the notification.
> +static void advance_object_set(struct ceph_journaler *journaler)
> +{
> +       struct object_recorder *obj_recorder;
> +       uint64_t active_set;
> +       int i, ret;
> +
> +       mutex_lock(&journaler->meta_lock);
> +       if (journaler->advancing || journaler->flushing) {
> +               mutex_unlock(&journaler->meta_lock);
> +               return;
> +       }
> +
> +       // make sure all inflight appending finish
> +       for (i = 0; i < journaler->splay_width; i++) {
> +               obj_recorder = &journaler->obj_recorders[i];
> +               spin_lock(&obj_recorder->lock);
> +               if (obj_recorder->inflight_append) {
> +                       spin_unlock(&obj_recorder->lock);
> +                       mutex_unlock(&journaler->meta_lock);
> +                       return;
> +               }
> +               spin_unlock(&obj_recorder->lock);
> +       }
> +
> +       journaler->advancing = true;
> +
> +       active_set = journaler->active_set + 1;
> +       mutex_unlock(&journaler->meta_lock);
> +
> +       ret = ceph_cls_journaler_set_active_set(journaler->osdc,
> +                       &journaler->header_oid, &journaler->header_oloc,
> +                       active_set);
> +       if (ret) {
> +               pr_err("error in set active_set: %d", ret);
> +       }
> +
> +       queue_work(journaler->task_wq, &journaler->notify_update_work);
> +}
> +
> +static void journaler_overflow(struct work_struct *work)
> +{
> +       struct ceph_journaler *journaler = container_of(work,
> +                                                       struct ceph_journaler,
> +                                                       overflow_work);
> +       advance_object_set(journaler);
> +}
> +
> +static void journaler_append_callback(struct ceph_osd_request *osd_req)
> +{
> +       struct journaler_append_ctx *ctx = osd_req->r_priv;
> +       int ret = osd_req->r_result;
> +
> +       if (ret)
> +               pr_debug("ret of journaler_append_callback: %d", ret);
> +
> +       __free_page(ctx->req_page);
> +       ceph_osdc_put_request(osd_req);
> +
> +       journaler_handle_append(ctx, ret);
> +}
> +
> +static int append(struct ceph_journaler *journaler,
> +                 struct ceph_object_id *oid,
> +                 struct ceph_object_locator *oloc,
> +                 struct journaler_append_ctx *ctx)
> +
> +{
> +       struct ceph_osd_client *osdc = journaler->osdc;
> +       struct ceph_osd_request *req;
> +       void *p;
> +       int ret;
> +
> +       req = ceph_osdc_alloc_request(osdc, NULL, 2, false, GFP_NOIO);
> +       if (!req)
> +               return -ENOMEM;
> +
> +       ceph_oid_copy(&req->r_base_oid, oid);
> +       ceph_oloc_copy(&req->r_base_oloc, oloc);
> +       req->r_flags = CEPH_OSD_FLAG_WRITE;
> +       req->r_callback = journaler_append_callback;
> +       req->r_priv = ctx;
> +
> +       // guard_append
> +       ctx->req_page = alloc_page(GFP_NOIO);
> +       if (!ctx->req_page) {
> +               ret = -ENOMEM;
> +               goto out_req;
> +       }

I think this allocation is unnecessary.  You are allocating three pages
for each append: for prefix, for suffix and for guard_append.  Given
that the prefix is just a few dozen bytes, the suffix is eight bytes
and guard_append needs just four bytes, a single page should be more
than enough.

> +       p = page_address(ctx->req_page);
> +       ceph_encode_64(&p, 1 << journaler->order);
> +       ret = osd_req_op_cls_init(req, 0, "journal", "guard_append");
> +       if (ret)
> +               goto out_free_page;
> +       osd_req_op_cls_request_data_pages(req, 0, &ctx->req_page, 8, 0, false, false);
> +
> +       // append_data
> +       osd_req_op_extent_init(req, 1, CEPH_OSD_OP_APPEND, 0,
> +               ctx->journaler_ctx.prefix_len + ctx->journaler_ctx.bio_len + ctx->journaler_ctx.suffix_len, 0, 0);
> +
> +       if (ctx->journaler_ctx.prefix_len)
> +               osd_req_op_extent_prefix_pages(req, 1, &ctx->journaler_ctx.prefix_page,
> +                                              ctx->journaler_ctx.prefix_len,
> +                                              ctx->journaler_ctx.prefix_offset,
> +                                              false, false);
> +
> +       if (ctx->journaler_ctx.bio_len)
> +               osd_req_op_extent_osd_data_bio(req, 1, &ctx->journaler_ctx.bio_iter, ctx->journaler_ctx.bio_len);
> +
> +       if (ctx->journaler_ctx.suffix_len)
> +               osd_req_op_extent_suffix_pages(req, 1, &ctx->journaler_ctx.suffix_page,
> +                                              ctx->journaler_ctx.suffix_len,
> +                                              ctx->journaler_ctx.suffix_offset,
> +                                              false, false);
> +       ret = ceph_osdc_alloc_messages(req, GFP_NOIO);
> +       if (ret)
> +               goto out_free_page;
> +
> +       ceph_osdc_start_request(osdc, req, false);
> +       return 0;
> +
> +out_free_page:
> +       __free_page(ctx->req_page);
> +out_req:
> +       ceph_osdc_put_request(req);
> +       return ret;
> +}
> +
> +static int send_append_request(struct ceph_journaler *journaler,
> +                              uint64_t object_num,
> +                              struct journaler_append_ctx *ctx)
> +{
> +       struct ceph_object_id object_oid;
> +       int ret = 0;
> +
> +       ceph_oid_init(&object_oid);
> +       ret = ceph_oid_aprintf(&object_oid, GFP_NOIO, "%s%llu",
> +                               journaler->object_oid_prefix, object_num);
> +       if (ret) {
> +               pr_err("failed to initialize object id: %d", ret);
> +               goto out;
> +       }
> +
> +       ret = append(journaler, &object_oid, &journaler->data_oloc, ctx);
> +out:
> +       ceph_oid_destroy(&object_oid);
> +       return ret;
> +}
> +
> +static void journaler_flush(struct work_struct *work)
> +{
> +       struct ceph_journaler *journaler = container_of(work,
> +                                                       struct ceph_journaler,
> +                                                       flush_work);
> +       int i = 0;
> +       struct object_recorder *obj_recorder;
> +       struct journaler_append_ctx *ctx, *next_ctx;
> +       LIST_HEAD(tmp);
> +
> +       mutex_lock(&journaler->meta_lock);
> +       if (journaler->overflowed) {
> +               mutex_unlock(&journaler->meta_lock);
> +               return;
> +       }
> +
> +       journaler->flushing = true;
> +       mutex_unlock(&journaler->meta_lock);
> +
> +       for (i = 0; i < journaler->splay_width; i++) {
> +               INIT_LIST_HEAD(&tmp);
> +               obj_recorder = &journaler->obj_recorders[i];
> +
> +               spin_lock(&obj_recorder->lock);
> +               list_splice_tail_init(&obj_recorder->overflow_list, &tmp);
> +               list_splice_tail_init(&obj_recorder->append_list, &tmp);
> +               spin_unlock(&obj_recorder->lock);
> +
> +               list_for_each_entry_safe(ctx, next_ctx, &tmp, node) {
> +                       list_del(&ctx->node);
> +                       ctx->object_num = get_object(journaler, obj_recorder->splay_offset);
> +                       journaler_handle_append(ctx, 0);
> +               }
> +       }
> +
> +       mutex_lock(&journaler->meta_lock);
> +       journaler->flushing = false;
> +       // As we don't do advance in flushing, so queue another overflow_work
> +       // after flushing finished if we journaler is overflowed.
> +       if (journaler->overflowed)
> +               queue_work(journaler->task_wq, &journaler->overflow_work);
> +       mutex_unlock(&journaler->meta_lock);
> +}
> +
> +static void ceph_journaler_object_append(struct ceph_journaler *journaler,
> +                                        struct journaler_append_ctx *append_ctx)
> +{
> +       void *buf, *end;
> +       uint32_t crc = 0;
> +       struct ceph_journaler_ctx *journaler_ctx = &append_ctx->journaler_ctx;
> +       struct ceph_bio_iter *bio_iter = &journaler_ctx->bio_iter;
> +       struct object_recorder *obj_recorder;
> +
> +       // PEAMBLE(8) + version(1) + entry_tid(8) + tag_tid(8) + string_len(4) = 29
> +       journaler_ctx->prefix_offset -= 29;
> +       journaler_ctx->prefix_len += 29;
> +       buf = page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset;
> +       end = buf + 29;
> +       journaler_entry_encode_prefix(&append_ctx->entry, &buf, end);
> +
> +       // size of crc is 4
> +       journaler_ctx->suffix_offset += 0;
> +       journaler_ctx->suffix_len += 4;
> +       buf = page_address(journaler_ctx->suffix_page);
> +       end = buf + 4;
> +       crc = crc32c(crc, page_address(journaler_ctx->prefix_page) + journaler_ctx->prefix_offset,
> +                    journaler_ctx->prefix_len);
> +       if (journaler_ctx->bio_len)
> +               crc = crc_bio(crc, bio_iter->bio, journaler_ctx->bio_len);

Looks like ceph_journaler_object_append() is called for each append
chunk (max_append_size), but you are always checksumming the entire
bio?

> +       ceph_encode_32(&buf, crc);
> +       obj_recorder = &journaler->obj_recorders[append_ctx->splay_offset];
> +
> +       spin_lock(&obj_recorder->lock);
> +       list_add_tail(&append_ctx->node, &obj_recorder->append_list);
> +       queue_work(journaler->task_wq, &journaler->flush_work);
> +       spin_unlock(&obj_recorder->lock);
> +}
> +
> +static void journaler_handle_append(struct journaler_append_ctx *ctx, int ret)
> +{
> +       struct ceph_journaler *journaler = ctx->journaler;
> +       struct object_recorder *obj_recorder = &journaler->obj_recorders[ctx->splay_offset];
> +
> +again:
> +       switch (ctx->state) {
> +       case JOURNALER_APPEND_START:
> +               ctx->state = JOURNALER_APPEND_SEND;
> +               ceph_journaler_object_append(journaler, ctx);
> +               break;
> +       case JOURNALER_APPEND_SEND:
> +               ctx->state = JOURNALER_APPEND_FLUSH;
> +               spin_lock(&obj_recorder->lock);
> +               obj_recorder->inflight_append++;
> +               spin_unlock(&obj_recorder->lock);
> +               ret = send_append_request(journaler, ctx->object_num, ctx);
> +               if (ret) {
> +                       pr_err("failed to send append request: %d", ret);
> +                       ctx->state = JOURNALER_APPEND_FINISH;
> +                       goto again;
> +               }
> +               break;
> +       case JOURNALER_APPEND_FLUSH:
> +               if (ret == -EOVERFLOW) {
> +                       mutex_lock(&journaler->meta_lock);
> +                       journaler->overflowed = true;
> +                       mutex_unlock(&journaler->meta_lock);
> +
> +                       spin_lock(&obj_recorder->lock);
> +                       ctx->state = JOURNALER_APPEND_OVERFLOW;
> +                       list_add_tail(&ctx->node, &obj_recorder->overflow_list);
> +                       if (--obj_recorder->inflight_append == 0)
> +                               queue_work(journaler->task_wq, &journaler->overflow_work);
> +                       spin_unlock(&obj_recorder->lock);
> +                       break;
> +               }
> +
> +               spin_lock(&obj_recorder->lock);
> +               if (--obj_recorder->inflight_append == 0) {
> +                       mutex_lock(&journaler->meta_lock);

Acquiring a mutex is a blocking operation, can't do it while holding
a spinlock.

> +                       if (journaler->overflowed)
> +                               queue_work(journaler->task_wq, &journaler->overflow_work);
> +                       mutex_unlock(&journaler->meta_lock);
> +               }
> +               spin_unlock(&obj_recorder->lock);
> +
> +               ret = add_commit_entry(journaler, ctx->future.commit_tid, ctx->object_num,
> +                                      ctx->future.tag_tid, ctx->future.entry_tid);
> +               if (ret) {
> +                       pr_err("failed to add_commit_entry: %d", ret);
> +                       ctx->state = JOURNALER_APPEND_FINISH;
> +                       ret = -ENOMEM;
> +                       goto again;
> +               }
> +
> +               ctx->state = JOURNALER_APPEND_SAFE;
> +               goto again;
> +       case JOURNALER_APPEND_OVERFLOW:
> +               ctx->state = JOURNALER_APPEND_SEND;
> +               goto again;
> +       case JOURNALER_APPEND_SAFE:
> +               spin_lock(&ctx->future.lock);
> +               ctx->future.safe = true;
> +               if (ctx->future.consistent) {
> +                       spin_unlock(&ctx->future.lock);
> +                       ctx->state = JOURNALER_APPEND_FINISH;
> +                       goto again;
> +               }
> +               spin_unlock(&ctx->future.lock);
> +               break;
> +       case JOURNALER_APPEND_FINISH:
> +               future_finish(ctx, ret);
> +               break;
> +       default:
> +               BUG();
> +       }
> +}
> +
> +// journaler_append_ctx alloc and release
> +struct journaler_append_ctx *journaler_append_ctx_alloc(void)
> +{
> +       struct journaler_append_ctx *append_ctx;
> +       struct ceph_journaler_ctx *journaler_ctx;
> +
> +       append_ctx = kmem_cache_zalloc(journaler_append_ctx_cache, GFP_NOIO);
> +       if (!append_ctx)
> +               return NULL;
> +
> +       journaler_ctx = &append_ctx->journaler_ctx;
> +       journaler_ctx->prefix_page = alloc_page(GFP_NOIO);
> +       if (!journaler_ctx->prefix_page)
> +               goto free_journaler_ctx;
> +
> +       journaler_ctx->suffix_page = alloc_page(GFP_NOIO);
> +       if (!journaler_ctx->suffix_page)
> +               goto free_prefix_page;
> +
> +       memset(page_address(journaler_ctx->prefix_page), 0, PAGE_SIZE);
> +       memset(page_address(journaler_ctx->suffix_page), 0, PAGE_SIZE);

Why zero here?

> +       INIT_LIST_HEAD(&journaler_ctx->node);
> +
> +       kref_init(&append_ctx->kref);
> +       INIT_LIST_HEAD(&append_ctx->node);
> +       return append_ctx;
> +
> +free_prefix_page:
> +       __free_page(journaler_ctx->prefix_page);
> +free_journaler_ctx:
> +       kmem_cache_free(journaler_append_ctx_cache, append_ctx);
> +       return NULL;
> +}
> +
> +struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void)
> +{
> +       struct journaler_append_ctx *append_ctx;
> +
> +       append_ctx = journaler_append_ctx_alloc();
> +       if (!append_ctx)
> +               return NULL;
> +
> +       return &append_ctx->journaler_ctx;
> +}
> +EXPORT_SYMBOL(ceph_journaler_ctx_alloc);
> +
> +static void journaler_append_ctx_release(struct kref *kref)
> +{
> +       struct journaler_append_ctx *append_ctx;
> +       struct ceph_journaler_ctx *journaler_ctx;
> +
> +       append_ctx = container_of(kref, struct journaler_append_ctx, kref);
> +       journaler_ctx = &append_ctx->journaler_ctx;
> +
> +       __free_page(journaler_ctx->prefix_page);
> +       __free_page(journaler_ctx->suffix_page);
> +       kmem_cache_free(journaler_append_ctx_cache, append_ctx);
> +}
> +
> +static void journaler_append_ctx_put(struct journaler_append_ctx *append_ctx)
> +{
> +       if (append_ctx) {
> +               kref_put(&append_ctx->kref, journaler_append_ctx_release);

AFAICT this kref is initialized to 1 and never incremented.  Is it
actually needed?

> +       }
> +}
> +
> +void ceph_journaler_ctx_put(struct ceph_journaler_ctx *journaler_ctx)
> +{
> +       struct journaler_append_ctx *append_ctx;
> +
> +       if (journaler_ctx) {
> +               append_ctx = container_of(journaler_ctx,
> +                                         struct journaler_append_ctx,
> +                                         journaler_ctx);
> +               journaler_append_ctx_put(append_ctx);
> +       }
> +}
> +EXPORT_SYMBOL(ceph_journaler_ctx_put);
> +
> +int ceph_journaler_append(struct ceph_journaler *journaler,
> +                         uint64_t tag_tid,
> +                         struct ceph_journaler_ctx *journaler_ctx)
> +{
> +       uint64_t entry_tid;
> +       struct object_recorder *obj_recorder;
> +       struct journaler_append_ctx *append_ctx;
> +       int ret;
> +
> +       append_ctx = container_of(journaler_ctx,
> +                                 struct journaler_append_ctx,
> +                                 journaler_ctx);
> +
> +       append_ctx->journaler = journaler;
> +       mutex_lock(&journaler->meta_lock);
> +       // get entry_tid for this event. (tag_tid, entry_tid) is
> +       // the uniq id for every journal event.
> +       ret = get_new_entry_tid(journaler, tag_tid, &entry_tid);
> +       if (ret) {
> +               mutex_unlock(&journaler->meta_lock);
> +               return ret;
> +       }
> +
> +       // calculate the object_num for this entry.
> +       append_ctx->splay_offset = entry_tid % journaler->splay_width;
> +       obj_recorder = &journaler->obj_recorders[journaler->splay_width];
> +       append_ctx->object_num = get_object(journaler, append_ctx->splay_offset);
> +
> +       // allocate a commit_tid for this event, when the data is committed
> +       // to data objects, ceph_journaler_client_committed() will accept
> +       // the commit_tid to understand how to update journal commit position.
> +       journaler_ctx->commit_tid = __allocate_commit_tid(journaler);
> +       entry_init(&append_ctx->entry, tag_tid, entry_tid, journaler_ctx);
> +
> +       // To make sure the journal entry is consistent, we use future
> +       // to track it. And every journal entry depent on the previous
> +       // entry. Only if the previous entry is finished, current entry
> +       // could be consistent. and then we can finish current entry.
> +       future_init(&append_ctx->future, tag_tid, entry_tid,
> +                   journaler_ctx->commit_tid, journaler_ctx);
> +       set_prev_future(journaler, append_ctx);
> +       mutex_unlock(&journaler->meta_lock);
> +
> +       append_ctx->state = JOURNALER_APPEND_START;
> +       journaler_handle_append(append_ctx, 0);
> +       return 0;
> +}
> +EXPORT_SYMBOL(ceph_journaler_append);
> +
> +static void journaler_client_commit(struct work_struct *work)
> +{
> +       struct ceph_journaler *journaler = container_of(to_delayed_work(work),
> +                                                       struct ceph_journaler,
> +                                                       commit_work);
> +       int ret;
> +
> +       mutex_lock(&journaler->commit_lock);
> +       copy_pos_list(&journaler->obj_pos_pending,
> +                     &journaler->obj_pos_committing);
> +       mutex_unlock(&journaler->commit_lock);
> +
> +       ret = ceph_cls_journaler_client_committed(journaler->osdc,
> +               &journaler->header_oid, &journaler->header_oloc,
> +               journaler->client, &journaler->obj_pos_committing);
> +
> +       if (ret) {
> +               pr_err("error in client committed: %d", ret);
> +       }
> +
> +       queue_work(journaler->task_wq, &journaler->notify_update_work);
> +
> +       mutex_lock(&journaler->commit_lock);
> +       journaler->commit_scheduled = false;
> +       mutex_unlock(&journaler->commit_lock);
> +}
> +
> +// hold journaler->commit_lock

This can be enforced with lockdep_assert_held() macro.

> +static void add_object_position(struct commit_entry *entry,
> +                              struct list_head *object_positions,
> +                              uint64_t splay_width)
> +{
> +       struct ceph_journaler_object_pos *position;
> +       uint8_t splay_offset = entry->object_num % splay_width;
> +       bool found = false;
> +
> +       list_for_each_entry(position, object_positions, node) {
> +               if (position->in_using == false) {
> +                       found = true;
> +                       break;
> +               }
> +
> +               if (splay_offset == position->object_num % splay_width) {
> +                       found = true;
> +                       break;
> +               }

Combine these into a single if?

> +       }
> +
> +       BUG_ON(!found);
> +       if (position->in_using == false)
> +               position->in_using = true;

Set ->in_using unconditionally?

Thanks,

                Ilya
