Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A14391F79
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 10:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfHSI4U (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 04:56:20 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44330 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfHSI4U (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 04:56:20 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so2522397iop.11
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 01:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aBFmiQ9PJiGa9Lz5mRbPkQTY8axnA8QOd8ei3zhw7Ng=;
        b=BELsl0YPr/FgwI/W+apq1AAr8cfwl+5FbQclcWpLCQ8tsI/qgDxFuSBpCgrmq3/jfr
         IFt6CQxN5rLfvV+xci8GpIf6MUjTVB9E/D46QLR6E6Tn/sQwGRnqdkvKseB3pcbcFqTV
         hq1i117/NUe9nyQWdCrThJ74YSsvFWg2gzPucU4psSAngwljQGuFoZYc6iRgq6GUE0k3
         Jn3cdPeTvY8IHh5vzBwTiPa7xeyOqrUfQuBLIJO073UKgmI0JqvpumvelQGwryoR9TD0
         kf/19nRc3fdiBPOlVSUdXi/XuJlNxC4bV8azjTYYH6yePD7py5lZS2TSctecJybQrdgv
         f1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aBFmiQ9PJiGa9Lz5mRbPkQTY8axnA8QOd8ei3zhw7Ng=;
        b=QvyLkUsoEdnG3KAwVkd+uRps9nF+7a+IPMjc/laFLho3C5UaIHQa0UMID6avcyBni7
         dhj19xzSL1sQ1wusd+qCKddryYRGHuXzgurP/ilzM46RqQBi3uKHuOxvIibL9qzrcVhY
         N1l7PTt8Gjcz3XiCvmqhPDGHsUPapmKbz30zfykcCw0uolNFPStmdRyc+xS22cq8skMb
         Y2IUXHoxEBwxHLUjqPezziRprnfu10K6dznb4UCn7l24cViX3bhF+mUg5NlbewKhDO2f
         ErQxf3mh2xbkrkWaFst8kZex3ojiUNglqANRe/ENpIkqkg4WrffY3m2pY/so9klBKRpN
         hEcQ==
X-Gm-Message-State: APjAAAVppw0fmMjhfhIEs9RPEOgM2eRFAPpAFC9Im6FsPgjA78vv0kpA
        spLRKkpi1pVgBPzvO7Jx5q73CDUYVcn/MtA+6eY=
X-Google-Smtp-Source: APXvYqyKvzELJk346kArfS2375NDeJfFpXcSI9iTSeJvpgBRlKC5vzgxDD5aVmER1hRLbOMWk3Hspm0Cx6DWEpCL0B0=
X-Received: by 2002:a5d:9945:: with SMTP id v5mr10469345ios.143.1566204978238;
 Mon, 19 Aug 2019 01:56:18 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-7-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-7-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 10:59:17 +0200
Message-ID: <CAOi1vP-s8dEodE9uGWNZGF_TAOzm=OdzQmN=AOq3hB_owbDkiw@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] libceph: introduce generic journaling
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
> This commit introduce the generic journaling. This is a initial
> commit, which only includes some generic functions, such as
> journaler_create|destroy() and journaler_open|close().
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  include/linux/ceph/journaler.h | 184 +++++++++++++
>  net/ceph/Makefile              |   3 +-
>  net/ceph/journaler.c           | 596 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 782 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/ceph/journaler.h
>  create mode 100644 net/ceph/journaler.c
>
> diff --git a/include/linux/ceph/journaler.h b/include/linux/ceph/journaler.h
> new file mode 100644
> index 0000000..e3b82af
> --- /dev/null
> +++ b/include/linux/ceph/journaler.h
> @@ -0,0 +1,184 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _FS_CEPH_JOURNAL_H
> +#define _FS_CEPH_JOURNAL_H
> +
> +#include <linux/rbtree.h>
> +#include <linux/ceph/cls_journaler_client.h>
> +
> +struct ceph_osd_client;
> +
> +#define JOURNAL_HEADER_PREFIX  "journal."
> +#define JOURNAL_OBJECT_PREFIX  "journal_data."
> +
> +#define LOCAL_MIRROR_UUID      ""
> +
> +static const uint32_t JOURNALER_EVENT_FIXED_SIZE = 33;
> +
> +static const uint64_t PREAMBLE = 0x3141592653589793;
> +
> +struct ceph_journaler_ctx;
> +typedef void (*ceph_journaler_callback_t)(struct ceph_journaler_ctx *);
> +
> +// A ceph_journaler_ctx should be allocated for each journaler appending
> +// op, and caller need to set the ->callback, which will be called
> +// when this journaler event appending finish.
> +struct ceph_journaler_ctx {
> +       struct list_head        node;
> +       struct ceph_bio_iter    bio_iter;
> +       size_t bio_len;
> +
> +       struct page *prefix_page;
> +       unsigned int prefix_offset;
> +       unsigned int prefix_len;
> +
> +       struct page *suffix_page;
> +       unsigned int suffix_offset;
> +       unsigned int suffix_len;
> +
> +       int result;
> +       uint64_t commit_tid;
> +       void *priv;
> +       ceph_journaler_callback_t callback;
> +};
> +
> +// tag_tid is used to identify the client.
> +struct ceph_journaler_entry {
> +       struct list_head node;
> +       uint64_t tag_tid;
> +       uint64_t entry_tid;
> +       ssize_t data_len;
> +       char *data;
> +       struct ceph_bio_iter *bio_iter;
> +};
> +
> +// ->safe = true means this append op is already write to osd servers
> +// ->consistent = true means the prev append op is already finished
> +// (safe && consistent) means this append finished. we can call the
> +// callback to upper caller.
> +//
> +// ->wait is the next append which depends on this append, when this
> +// append finish, it will tell wait to be consistent.
> +struct ceph_journaler_future {
> +       uint64_t tag_tid;
> +       uint64_t entry_tid;
> +       uint64_t commit_tid;
> +
> +       spinlock_t lock;
> +       bool safe;
> +       bool consistent;
> +
> +       struct ceph_journaler_ctx *ctx;
> +       struct journaler_append_ctx *wait;
> +};
> +
> +// each journaler object have a recorder to append event to it.
> +struct object_recorder {
> +       spinlock_t lock;
> +       uint64_t splay_offset;
> +       uint64_t inflight_append;
> +
> +       struct list_head append_list;
> +       struct list_head overflow_list;
> +};
> +
> +// each journaler object have a replayer to do replay in journaler openning.
> +struct object_replayer {
> +       spinlock_t lock;
> +       uint64_t object_num;
> +       struct ceph_journaler_object_pos *pos;
> +       struct list_head entry_list;
> +};
> +
> +struct ceph_journaler {
> +       struct ceph_osd_client          *osdc;
> +       struct ceph_object_id           header_oid;
> +       struct ceph_object_locator      header_oloc;
> +       struct ceph_object_locator      data_oloc;
> +       char                            *object_oid_prefix;
> +       char                            *client_id;
> +
> +       // TODO put these bool into ->flags
> +       // don't need to do another advance if we are advancing
> +       bool                            advancing;
> +       // don't do advance when we are flushing
> +       bool                            flushing;
> +       bool                            overflowed;
> +       bool                            commit_scheduled;
> +       uint8_t                         order;
> +       uint8_t                         splay_width;
> +       int64_t                         pool_id;

Given ->data_oloc, ->pool_id is probably redundant.

> +       uint64_t                        splay_offset;
> +       uint64_t                        active_tag_tid;
> +       uint64_t                        prune_tag_tid;
> +       uint64_t                        commit_tid;
> +       uint64_t                        minimum_set;
> +       uint64_t                        active_set;
> +
> +       struct ceph_journaler_future    *prev_future;
> +       struct ceph_journaler_client    *client;
> +       struct object_recorder          *obj_recorders;
> +       struct object_replayer          *obj_replayers;
> +
> +       struct ceph_journaler_object_pos *obj_pos_pending_array;
> +       struct list_head                obj_pos_pending;
> +       struct ceph_journaler_object_pos *obj_pos_committing_array;
> +       struct list_head                obj_pos_committing;
> +
> +       struct mutex                    meta_lock;
> +       struct mutex                    commit_lock;
> +       spinlock_t              entry_tid_lock;
> +       spinlock_t              finish_lock;

I haven't followed the logic closely yet, but there are way too many
locks here: at least two mutexes and five spinlocks.  Does it really
need to be this granular?

> +       struct list_head                finish_list;
> +       struct list_head                clients;
> +       struct list_head                clients_cache;
> +       struct list_head                entry_tids;
> +       struct rb_root                  commit_entries;
> +
> +       struct workqueue_struct         *task_wq;
> +       struct workqueue_struct         *notify_wq;
> +       struct work_struct              flush_work;
> +       struct delayed_work             commit_work;
> +       struct work_struct              overflow_work;
> +       struct work_struct              finish_work;
> +       struct work_struct              notify_update_work;
> +
> +       void *fetch_buf;
> +       int (*handle_entry)(void *entry_handler,
> +                           struct ceph_journaler_entry *entry,
> +                           uint64_t commit_tid);
> +       void *entry_handler;
> +       struct ceph_osd_linger_request *watch_handle;
> +};
> +
> +// generic functions
> +struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
> +                                            struct ceph_object_locator*_oloc,
> +                                            const char *journal_id,
> +                                            const char *client_id);
> +void ceph_journaler_destroy(struct ceph_journaler *journal);
> +
> +int ceph_journaler_open(struct ceph_journaler *journal);
> +void ceph_journaler_close(struct ceph_journaler *journal);
> +
> +int ceph_journaler_get_cached_client(struct ceph_journaler *journaler, char *client_id,
> +                                    struct ceph_journaler_client **client_result);
> +// replaying
> +int ceph_journaler_start_replay(struct ceph_journaler *journaler);
> +
> +// recording
> +static inline uint64_t ceph_journaler_get_max_append_size(struct ceph_journaler *journaler)
> +{
> +       return (1 << journaler->order) - JOURNALER_EVENT_FIXED_SIZE;
> +}
> +struct ceph_journaler_ctx *ceph_journaler_ctx_alloc(void);
> +void ceph_journaler_ctx_put(struct ceph_journaler_ctx *journaler_ctx);
> +int ceph_journaler_append(struct ceph_journaler *journaler,
> +                         uint64_t tag_tid, uint64_t *commit_tid,
> +                         struct ceph_journaler_ctx *ctx);
> +void ceph_journaler_client_committed(struct ceph_journaler *journaler,
> +                                    uint64_t commit_tid);
> +int ceph_journaler_allocate_tag(struct ceph_journaler *journaler,
> +                               uint64_t tag_class, void *buf,
> +                               uint32_t buf_len,
> +                               struct ceph_journaler_tag *tag);
> +#endif
> diff --git a/net/ceph/Makefile b/net/ceph/Makefile
> index 59d0ba2..ea31a2d 100644
> --- a/net/ceph/Makefile
> +++ b/net/ceph/Makefile
> @@ -14,4 +14,5 @@ libceph-y := ceph_common.o messenger.o msgpool.o buffer.o pagelist.o \
>         crypto.o armor.o \
>         auth_x.o \
>         ceph_fs.o ceph_strings.o ceph_hash.o \
> -       pagevec.o snapshot.o string_table.o
> +       pagevec.o snapshot.o string_table.o \
> +       journaler.o cls_journaler_client.o
> diff --git a/net/ceph/journaler.c b/net/ceph/journaler.c
> new file mode 100644
> index 0000000..1b04d3f
> --- /dev/null
> +++ b/net/ceph/journaler.c
> @@ -0,0 +1,596 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/ceph/ceph_debug.h>
> +#include <linux/ceph/ceph_features.h>
> +#include <linux/ceph/cls_journaler_client.h>
> +#include <linux/ceph/journaler.h>
> +#include <linux/ceph/libceph.h>
> +#include <linux/ceph/osd_client.h>
> +
> +#include <linux/crc32c.h>
> +#include <linux/module.h>
> +
> +#define JOURNALER_COMMIT_INTERVAL              msecs_to_jiffies(5000)
> +
> +static char *object_oid_prefix(int pool_id, const char *journal_id)
> +{
> +       char *prefix;
> +       ssize_t len = snprintf(NULL, 0, "%s%d.%s.", JOURNAL_OBJECT_PREFIX,
> +                              pool_id, journal_id);
> +
> +       prefix = kzalloc(len + 1, GFP_KERNEL);
> +
> +       if (!prefix)
> +               return NULL;
> +
> +       WARN_ON(snprintf(prefix, len + 1, "%s%d.%s.", JOURNAL_OBJECT_PREFIX,
> +                        pool_id, journal_id) != len);
> +
> +       return prefix;
> +}

I would drop this and format the whole object with ceph_oid_printf()
directly.

> +
> +/*
> + * journaler_append_ctx is an internal structure to represent an append op.
> + */
> +struct journaler_append_ctx {
> +       struct list_head node;
> +       struct ceph_journaler *journaler;
> +
> +       uint64_t splay_offset;
> +       uint64_t object_num;
> +       struct page *req_page;
> +
> +       struct ceph_journaler_future future;
> +       struct ceph_journaler_entry entry;
> +       struct ceph_journaler_ctx journaler_ctx;
> +
> +       struct kref     kref;
> +};
> +
> +struct commit_entry {
> +       struct rb_node  r_node;
> +       uint64_t commit_tid;
> +       uint64_t object_num;
> +       uint64_t tag_tid;
> +       uint64_t entry_tid;
> +       bool committed;
> +};
> +
> +struct entry_tid {
> +       struct list_head        node;
> +       uint64_t tag_tid;
> +       uint64_t entry_tid;
> +};
> +
> +static struct kmem_cache       *journaler_commit_entry_cache;
> +static struct kmem_cache       *journaler_append_ctx_cache;
> +
> +struct ceph_journaler *ceph_journaler_create(struct ceph_osd_client *osdc,
> +                                            struct ceph_object_locator *oloc,
> +                                            const char *journal_id,
> +                                            const char *client_id)
> +{
> +       struct ceph_journaler *journaler;
> +       int ret;
> +
> +       journaler = kzalloc(sizeof(struct ceph_journaler), GFP_KERNEL);
> +       if (!journaler)
> +               return NULL;
> +
> +       journaler->osdc = osdc;
> +       ceph_oid_init(&journaler->header_oid);
> +       ret = ceph_oid_aprintf(&journaler->header_oid, GFP_NOIO, "%s%s",
> +                               JOURNAL_HEADER_PREFIX, journal_id);
> +       if (ret) {
> +               pr_err("aprintf error : %d", ret);
> +               goto err_free_journaler;
> +       }
> +
> +       ceph_oloc_init(&journaler->header_oloc);
> +       ceph_oloc_copy(&journaler->header_oloc, oloc);
> +       ceph_oloc_init(&journaler->data_oloc);
> +
> +       journaler->object_oid_prefix = object_oid_prefix(journaler->header_oloc.pool,
> +                                                        journal_id);
> +
> +       if (!journaler->object_oid_prefix)
> +               goto err_destroy_data_oloc;
> +
> +       journaler->client_id = kstrdup(client_id, GFP_NOIO);
> +       if (!journaler->client_id) {
> +               ret = -ENOMEM;
> +               goto err_free_object_oid_prefix;
> +       }
> +
> +       journaler->advancing = false;
> +       journaler->flushing = false;
> +       journaler->overflowed = false;
> +       journaler->commit_scheduled = false;
> +       journaler->order = 0;
> +       journaler->splay_width = 0;
> +       journaler->pool_id = -1;
> +       journaler->splay_offset = 0;
> +       journaler->active_tag_tid = UINT_MAX;
> +       journaler->prune_tag_tid = UINT_MAX;
> +       journaler->commit_tid = 0;
> +       journaler->minimum_set = 0;
> +       journaler->active_set = 0;
> +
> +       journaler->prev_future = NULL;
> +       journaler->client = NULL;
> +       journaler->obj_recorders = NULL;
> +       journaler->obj_replayers = NULL;
> +
> +       mutex_init(&journaler->meta_lock);
> +       mutex_init(&journaler->commit_lock);
> +       spin_lock_init(&journaler->entry_tid_lock);
> +       spin_lock_init(&journaler->finish_lock);
> +
> +       INIT_LIST_HEAD(&journaler->finish_list);
> +       INIT_LIST_HEAD(&journaler->clients);
> +       INIT_LIST_HEAD(&journaler->clients_cache);
> +       INIT_LIST_HEAD(&journaler->entry_tids);
> +       INIT_LIST_HEAD(&journaler->obj_pos_pending);
> +       INIT_LIST_HEAD(&journaler->obj_pos_committing);
> +
> +       journaler->commit_entries = RB_ROOT;
> +       journaler_commit_entry_cache = KMEM_CACHE(commit_entry, 0);
> +       if (!journaler_commit_entry_cache)
> +               goto err_free_client_id;
> +
> +       journaler_append_ctx_cache = KMEM_CACHE(journaler_append_ctx, 0);
> +       if (!journaler_append_ctx_cache)
> +               goto err_destroy_commit_entry_cache;
> +
> +       journaler->task_wq = alloc_ordered_workqueue("journaler-tasks",
> +                                                    WQ_MEM_RECLAIM);
> +       if (!journaler->task_wq)
> +               goto err_destroy_append_ctx_cache;
> +
> +       journaler->notify_wq = create_singlethread_workqueue("journaler-notify");
> +       if (!journaler->notify_wq)
> +               goto err_destroy_task_wq;
> +
> +       journaler->fetch_buf = NULL;
> +       journaler->handle_entry = NULL;
> +       journaler->entry_handler = NULL;
> +       journaler->watch_handle = NULL;
> +
> +       return journaler;
> +
> +err_destroy_task_wq:
> +       destroy_workqueue(journaler->task_wq);
> +err_destroy_append_ctx_cache:
> +       kmem_cache_destroy(journaler_append_ctx_cache);
> +err_destroy_commit_entry_cache:
> +       kmem_cache_destroy(journaler_commit_entry_cache);
> +err_free_client_id:
> +       kfree(journaler->client_id);
> +err_free_object_oid_prefix:
> +       kfree(journaler->object_oid_prefix);
> +err_destroy_data_oloc:
> +       ceph_oloc_destroy(&journaler->data_oloc);
> +       ceph_oloc_destroy(&journaler->header_oloc);
> +       ceph_oid_destroy(&journaler->header_oid);
> +err_free_journaler:
> +       kfree(journaler);
> +       return NULL;
> +}
> +EXPORT_SYMBOL(ceph_journaler_create);
> +
> +void ceph_journaler_destroy(struct ceph_journaler *journaler)
> +{
> +       destroy_workqueue(journaler->notify_wq);
> +       destroy_workqueue(journaler->task_wq);
> +
> +       kmem_cache_destroy(journaler_append_ctx_cache);
> +       kmem_cache_destroy(journaler_commit_entry_cache);
> +       kfree(journaler->client_id);
> +       kfree(journaler->object_oid_prefix);
> +       ceph_oloc_destroy(&journaler->data_oloc);
> +       ceph_oloc_destroy(&journaler->header_oloc);
> +       ceph_oid_destroy(&journaler->header_oid);
> +       kfree(journaler);
> +}
> +EXPORT_SYMBOL(ceph_journaler_destroy);
> +
> +static int refresh(struct ceph_journaler *journaler, bool init)
> +{
> +       int ret;
> +       struct ceph_journaler_client *client;
> +       uint64_t minimum_commit_set;
> +       uint64_t minimum_set;
> +       uint64_t active_set;
> +       bool need_advance = false;
> +       LIST_HEAD(tmp_clients);
> +
> +       INIT_LIST_HEAD(&tmp_clients);
> +       ret = ceph_cls_journaler_get_mutable_metas(journaler->osdc,
> +                       &journaler->header_oid, &journaler->header_oloc,
> +                       &minimum_set, &active_set);

I would name all cls functions ceph_cls_journal_*() because the class
is named "journal".  It's also slightly shorter ;)

> +       if (ret)
> +               return ret;
> +
> +       ret = ceph_cls_journaler_client_list(journaler->osdc, &journaler->header_oid,
> +               &journaler->header_oloc, &journaler->clients_cache, journaler->splay_width);
> +       if (ret)
> +               return ret;
> +
> +       mutex_lock(&journaler->meta_lock);
> +       if (init) {
> +               journaler->active_set = active_set;
> +       } else {
> +               // check for advance active_set.
> +               need_advance = active_set > journaler->active_set;
> +       }
> +
> +       journaler->active_set = active_set;
> +       journaler->minimum_set = minimum_set;
> +       // swap clients with clients_cache. clients in client_cache list is not
> +       // released, then we can reuse them in next refresh() to avoid malloc() and
> +       // free() too frequently.
> +       list_splice_tail_init(&journaler->clients, &tmp_clients);
> +       list_splice_tail_init(&journaler->clients_cache, &journaler->clients);
> +       list_splice_tail_init(&tmp_clients, &journaler->clients_cache);
> +
> +       // calculate the minimum_commit_set.
> +       // TODO: unregister clients if the commit position is too long behind
> +       // active positions. similar with rbd_journal_max_concurrent_object_sets
> +       // in user space journal.
> +       minimum_commit_set = journaler->active_set;
> +       list_for_each_entry(client, &journaler->clients, node) {
> +               struct ceph_journaler_object_pos *pos;
> +
> +               list_for_each_entry(pos, &client->object_positions, node) {
> +                       uint64_t object_set = pos->object_num / journaler->splay_width;
> +                       if (object_set < minimum_commit_set) {
> +                               minimum_commit_set = object_set;
> +                       }
> +               }
> +
> +               if (!strcmp(client->id, journaler->client_id)) {
> +                       journaler->client = client;
> +               }
> +       }
> +       mutex_unlock(&journaler->meta_lock);
> +
> +       if (need_advance) {
> +               // the actual advancing
> +               mutex_lock(&journaler->meta_lock);

Why release ->meta_lock just to take it again here?

> +               journaler->overflowed = false;
> +               journaler->advancing = false;
> +               mutex_unlock(&journaler->meta_lock);
> +
> +               // At this time, the active_set is actually advanced,
> +               // we can flush now.
> +               queue_work(journaler->task_wq, &journaler->flush_work);
> +       }
> +
> +       return 0;
> +
> +}
> +
> +static void journaler_watch_cb(void *arg, u64 notify_id, u64 cookie,
> +                        u64 notifier_id, void *data, size_t data_len)
> +{
> +       struct ceph_journaler *journaler = arg;
> +       int ret;
> +
> +       ret = refresh(journaler, false);
> +        if (ret < 0)
> +                pr_err("%s: failed to refresh journaler: %d", __func__, ret);
> +
> +       ret = ceph_osdc_notify_ack(journaler->osdc, &journaler->header_oid,
> +                                  &journaler->header_oloc, notify_id,
> +                                  cookie, NULL, 0);
> +       if (ret)
> +               pr_err("acknowledge_notify failed: %d", ret);
> +}
> +
> +static void journaler_watch_errcb(void *arg, u64 cookie, int err)
> +{
> +       // TODO re-watch in watch error.
> +       pr_err("journaler watch error: %d", err);
> +}
> +
> +static int journaler_watch(struct ceph_journaler *journaler)
> +{
> +       struct ceph_osd_client *osdc = journaler->osdc;
> +       struct ceph_osd_linger_request *handle;
> +
> +       handle = ceph_osdc_watch(osdc, &journaler->header_oid,
> +                                &journaler->header_oloc, journaler->notify_wq,
> +                                journaler_watch_cb, journaler_watch_errcb,
> +                                journaler);
> +       if (IS_ERR(handle))
> +               return PTR_ERR(handle);
> +
> +       journaler->watch_handle = handle;
> +       return 0;
> +}
> +
> +static void journaler_unwatch(struct ceph_journaler *journaler)
> +{
> +       struct ceph_osd_client *osdc = journaler->osdc;
> +       int ret;
> +
> +       ret = ceph_osdc_unwatch(osdc, journaler->watch_handle);
> +       if (ret)
> +               pr_err("%s: failed to unwatch: %d", __func__, ret);
> +
> +       journaler->watch_handle = NULL;
> +}
> +
> +static void copy_object_pos(struct ceph_journaler_object_pos *src_pos,
> +                          struct ceph_journaler_object_pos *dst_pos)
> +{
> +       dst_pos->object_num = src_pos->object_num;
> +       dst_pos->tag_tid = src_pos->tag_tid;
> +       dst_pos->entry_tid = src_pos->entry_tid;
> +}
> +
> +static void copy_pos_list(struct list_head *src_list, struct list_head *dst_list)
> +{
> +       struct ceph_journaler_object_pos *src_pos, *dst_pos;
> +
> +       src_pos = list_first_entry(src_list, struct ceph_journaler_object_pos, node);
> +       dst_pos = list_first_entry(dst_list, struct ceph_journaler_object_pos, node);
> +       while (&src_pos->node != src_list && &dst_pos->node != dst_list) {
> +               copy_object_pos(src_pos, dst_pos);
> +               src_pos = list_next_entry(src_pos, node);
> +               dst_pos = list_next_entry(dst_pos, node);
> +       }
> +}
> +
> +int ceph_journaler_open(struct ceph_journaler *journaler)
> +{
> +       uint8_t order, splay_width;
> +       int64_t pool_id;
> +       int i, ret;
> +       struct ceph_journaler_client *client, *next_client;
> +
> +       ret = ceph_cls_journaler_get_immutable_metas(journaler->osdc,
> +                                       &journaler->header_oid,
> +                                       &journaler->header_oloc,
> +                                       &order,
> +                                       &splay_width,
> +                                       &pool_id);
> +       if (ret) {
> +               pr_err("failed to get immutable metas.");;
> +               goto out;
> +       }
> +
> +       mutex_lock(&journaler->meta_lock);
> +       // set the immutable metas.
> +       journaler->order = order;
> +       journaler->splay_width = splay_width;
> +       journaler->pool_id = pool_id;
> +
> +       if (journaler->pool_id == -1) {
> +               ceph_oloc_copy(&journaler->data_oloc, &journaler->header_oloc);
> +               journaler->pool_id = journaler->data_oloc.pool;
> +       } else {
> +               journaler->data_oloc.pool = journaler->pool_id;
> +       }
> +
> +       // initialize ->obj_recorders and ->obj_replayers.
> +       journaler->obj_recorders = kzalloc(sizeof(struct object_recorder) *
> +                                          journaler->splay_width, GFP_KERNEL);

Use kcalloc() here.

> +       if (!journaler->obj_recorders) {
> +               mutex_unlock(&journaler->meta_lock);
> +               goto out;
> +       }
> +
> +       journaler->obj_replayers = kzalloc(sizeof(struct object_replayer) *
> +                                          journaler->splay_width, GFP_KERNEL);

Same here.

> +       if (!journaler->obj_replayers) {
> +               mutex_unlock(&journaler->meta_lock);
> +               goto free_recorders;
> +       }
> +
> +       journaler->obj_pos_pending_array = kzalloc(sizeof(struct ceph_journaler_object_pos) *
> +                                                  journaler->splay_width, GFP_KERNEL);

Same here.

> +       if (!journaler->obj_pos_pending_array) {
> +               mutex_unlock(&journaler->meta_lock);
> +               goto free_replayers;
> +       }
> +
> +       journaler->obj_pos_committing_array = kzalloc(sizeof(struct ceph_journaler_object_pos) *
> +                                                  journaler->splay_width, GFP_KERNEL);

Same here.

Thanks,

                Ilya
