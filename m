Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54EF91ED2
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHSIYp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 04:24:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33556 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfHSIYp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 04:24:45 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so2409281iog.0
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 01:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PouNEjCpBoe7l7bY+O3skJ6qCy/ZC6Jn9PLzO6liOI4=;
        b=niE1sZrfO6pC8G4ykjStctpPD3hBh/oZmhChJV7za6gY6pBuKtidMW5H0H1sU/4Ya7
         gxjLpMwaNeFkaC/9eE6bwL2JN3bqKb3ONL/s3AK+c2oKze/wMbvNOFvH194Ezn8mhaQB
         UNcSa2FE8KXntpExwyfCGwYu64pJ26fqjcnXSemG7oLd3H3ggb8z1kBEBzx261kVvvfI
         0JVluc0L84bz54InGjvXdtyrGxBwKfOsfYUDf4JxTfQu9fVdAS3tbRs7vzdPIikWlpa2
         gG5X8zX2/v6IXP5o2wDSAjIHDUpPJSzwxXe9ZImMuuLRspTT8y++P3NHNv6KyI9X6OgH
         Qx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PouNEjCpBoe7l7bY+O3skJ6qCy/ZC6Jn9PLzO6liOI4=;
        b=hrg7IidY7ceAa4F/c/SISQ/6oGUnniKJeXOySAQBT5W2MT+9XceLklddqkpodnheen
         gTCdxR5gYNtOY+v93CpVsRHj4lkmio9hprgZYnGM65sVX4wArNQ6jwKL9mnLieflk1SZ
         FY7XsXCBgsbAXpiaLkDYWFe/e61VaUziE8zzheFRgzexqYRG7Re7+2OdNUE483ND2tTm
         gRItR2avZHMsXpJy7Pch1Su8WlqI9O3HF2STv9nU3rmzf5NBUuqg9vjXEA821YS7aakb
         HMjFn3LLu01rwcJjH00SBcej2MrKdpTdS/wVqs3uXTq0kGNJEi32catLPmbhs4GYV9ql
         07Iw==
X-Gm-Message-State: APjAAAVr/hcSXbsN33fofWW4xdvMD/cFbMSw09p0w7GkZn+R5r6UOlVw
        WFO/Uxto/ekefv8ewEmKX6cw/Cp5eJ9G7HmJIBlaqv8P
X-Google-Smtp-Source: APXvYqxh4Kc9QZ07r+D/wRhDwJwQEwhqi8RFvViroC++ocazlq2K0bVkq4fNmbGN7Mf7eW6aSJZAOs5uWT/s1f/Ut8k=
X-Received: by 2002:a6b:8d90:: with SMTP id p138mr9782946iod.282.1566203083603;
 Mon, 19 Aug 2019 01:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-6-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-6-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 10:27:42 +0200
Message-ID: <CAOi1vP_57G8knyeTwuT_BLOHL+wzC7Z3OT0+xGiWgDNUum4VJw@mail.gmail.com>
Subject: Re: [PATCH v3 05/15] libceph: introduce cls_journaler_client
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
> This is a cls client module for journaler.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  include/linux/ceph/cls_journaler_client.h |  94 +++++
>  net/ceph/cls_journaler_client.c           | 558 ++++++++++++++++++++++++++++++
>  2 files changed, 652 insertions(+)
>  create mode 100644 include/linux/ceph/cls_journaler_client.h
>  create mode 100644 net/ceph/cls_journaler_client.c
>
> diff --git a/include/linux/ceph/cls_journaler_client.h b/include/linux/ceph/cls_journaler_client.h
> new file mode 100644
> index 0000000..6245882
> --- /dev/null
> +++ b/include/linux/ceph/cls_journaler_client.h
> @@ -0,0 +1,94 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_CEPH_CLS_JOURNAL_CLIENT_H
> +#define _LINUX_CEPH_CLS_JOURNAL_CLIENT_H
> +
> +#include <linux/ceph/osd_client.h>
> +
> +struct ceph_journaler;
> +struct ceph_journaler_client;
> +
> +struct ceph_journaler_object_pos {
> +       struct list_head        node;
> +       u64                     object_num;
> +       u64                     tag_tid;
> +       u64                     entry_tid;
> +       // ->in_using means this object_pos is initialized.
> +       // There would be some stub for it created in init step
> +       // to allocate memory as early as possible.
> +       bool                    in_using;
> +};
> +
> +struct ceph_journaler_client {
> +       struct list_head                        node;
> +       size_t                                  id_len;
> +       char                                    *id;
> +       size_t                                  data_len;
> +       char                                    *data;

Is client->data ever used?  If not, drop it and skip over this string
when decoding.

> +       struct list_head                        object_positions;
> +       struct ceph_journaler_object_pos        *object_positions_array;
> +};
> +
> +struct ceph_journaler_tag {
> +       uint64_t tid;
> +       uint64_t tag_class;
> +       size_t data_len;
> +       char *data;

Same here, is tag->data ever used?

> +};
> +
> +void destroy_client(struct ceph_journaler_client *client);
> +
> +int ceph_cls_journaler_get_immutable_metas(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint8_t *order,
> +                                          uint8_t *splay_width,
> +                                          int64_t *pool_id);
> +
> +int ceph_cls_journaler_get_mutable_metas(struct ceph_osd_client *osdc,
> +                                        struct ceph_object_id *oid,
> +                                        struct ceph_object_locator *oloc,
> +                                        uint64_t *minimum_set, uint64_t *active_set);
> +
> +int ceph_cls_journaler_client_list(struct ceph_osd_client *osdc,
> +                                  struct ceph_object_id *oid,
> +                                  struct ceph_object_locator *oloc,
> +                                  struct list_head *clients,
> +                                  uint8_t splay_width);
> +
> +int ceph_cls_journaler_get_next_tag_tid(struct ceph_osd_client *osdc,
> +                                  struct ceph_object_id *oid,
> +                                  struct ceph_object_locator *oloc,
> +                                  uint64_t *tag_tid);
> +
> +int ceph_cls_journaler_get_tag(struct ceph_osd_client *osdc,
> +                              struct ceph_object_id *oid,
> +                              struct ceph_object_locator *oloc,
> +                              uint64_t tag_tid, struct ceph_journaler_tag *tag);
> +
> +int ceph_cls_journaler_tag_create(struct ceph_osd_client *osdc,
> +                                 struct ceph_object_id *oid,
> +                                 struct ceph_object_locator *oloc,
> +                                 uint64_t tag_tid, uint64_t tag_class,
> +                                 void *buf, uint32_t buf_len);
> +
> +int ceph_cls_journaler_client_committed(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          struct ceph_journaler_client *client,
> +                                       struct list_head *object_positions);
> +
> +int ceph_cls_journaler_set_active_set(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t active_set);
> +
> +int ceph_cls_journaler_set_minimum_set(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t minimum_set);
> +
> +int ceph_cls_journaler_guard_append(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t soft_limit);
> +#endif
> diff --git a/net/ceph/cls_journaler_client.c b/net/ceph/cls_journaler_client.c
> new file mode 100644
> index 0000000..ac27589
> --- /dev/null
> +++ b/net/ceph/cls_journaler_client.c
> @@ -0,0 +1,558 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/ceph/ceph_debug.h>
> +#include <linux/ceph/cls_journaler_client.h>
> +#include <linux/ceph/journaler.h>
> +
> +#include <linux/types.h>
> +
> +//TODO get all metas in one single request
> +int ceph_cls_journaler_get_immutable_metas(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint8_t *order,
> +                                          uint8_t *splay_width,
> +                                          int64_t *pool_id)
> +{
> +       struct page *reply_page;
> +       size_t reply_len = sizeof(*order);
> +       int ret;
> +
> +       reply_page = alloc_page(GFP_NOIO);
> +       if (!reply_page)
> +               return -ENOMEM;
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_order",
> +                            CEPH_OSD_FLAG_READ, NULL,
> +                            0, &reply_page, &reply_len);
> +       if (!ret) {
> +               memcpy(order, page_address(reply_page), reply_len);
> +       } else {
> +               goto out;
> +       }
> +       reply_len = sizeof(*splay_width);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_splay_width",
> +                            CEPH_OSD_FLAG_READ, NULL,
> +                            0, &reply_page, &reply_len);
> +       if (!ret) {
> +               memcpy(splay_width, page_address(reply_page), reply_len);
> +       } else {
> +               goto out;
> +       }
> +       reply_len = sizeof(*pool_id);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_pool_id",
> +                            CEPH_OSD_FLAG_READ, NULL,
> +                            0, &reply_page, &reply_len);
> +       if (!ret) {
> +               memcpy(pool_id, page_address(reply_page), reply_len);

This memcpy() is not going to work on big endian machines.  Use either
ceph_decode_*() or le*_to_cpu() helpers.

Also, check for errors instead of success:

        ret = ceph_osdc_call(...);
        if (ret)
                goto out;

        ... decode ...


> +       } else {
> +               goto out;
> +       }
> +out:
> +       __free_page(reply_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_get_immutable_metas);
> +
> +//TODO get all metas in one single request
> +int ceph_cls_journaler_get_mutable_metas(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t *minimum_set, uint64_t *active_set)
> +{
> +       struct page *reply_page;
> +       int ret;
> +       size_t reply_len = sizeof(*minimum_set);
> +
> +       reply_page = alloc_page(GFP_NOIO);
> +       if (!reply_page)
> +               return -ENOMEM;
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_minimum_set",
> +                            CEPH_OSD_FLAG_READ, NULL,
> +                            0, &reply_page, &reply_len);
> +       if (!ret) {
> +               memcpy(minimum_set, page_address(reply_page), reply_len);

Same here.

> +       } else {
> +               goto out;
> +       }
> +       reply_len = sizeof(active_set);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_active_set",
> +                            CEPH_OSD_FLAG_READ, NULL,
> +                            0, &reply_page, &reply_len);
> +       if (!ret) {
> +               memcpy(active_set, page_address(reply_page), reply_len);

Same here.

> +       } else {
> +               goto out;
> +       }
> +out:
> +       __free_page(reply_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_get_mutable_metas);
> +
> +static int decode_object_position(void **p, void *end, struct ceph_journaler_object_pos *pos)
> +{
> +       u8 struct_v;
> +       u32 struct_len;
> +       int ret;
> +       u64 object_num;
> +       u64 tag_tid;
> +       u64 entry_tid;
> +
> +       ret = ceph_start_decoding(p, end, 1, "cls_journal_object_position",
> +                                 &struct_v, &struct_len);
> +       if (ret)
> +               return ret;
> +
> +       object_num = ceph_decode_64(p);
> +       tag_tid = ceph_decode_64(p);
> +       entry_tid = ceph_decode_64(p);
> +
> +       pos->object_num = object_num;
> +       pos->tag_tid = tag_tid;
> +       pos->entry_tid = entry_tid;

Can decode directly into pos, without going through local variables.

> +
> +       return ret;
> +}
> +
> +void destroy_client(struct ceph_journaler_client *client)
> +{
> +       kfree(client->object_positions_array);
> +       kfree(client->id);
> +       kfree(client->data);
> +
> +       kfree(client);
> +}
> +
> +struct ceph_journaler_client *create_client(uint8_t splay_width)
> +{
> +       struct ceph_journaler_client *client;
> +       struct ceph_journaler_object_pos *pos;
> +       int i;
> +
> +       client = kzalloc(sizeof(*client), GFP_NOIO);
> +       if (!client)
> +               return NULL;
> +
> +       client->object_positions_array = kcalloc(splay_width, sizeof(*pos), GFP_NOIO);
> +       if (!client->object_positions_array)
> +               goto free_client;
> +
> +       INIT_LIST_HEAD(&client->object_positions);
> +       for (i = 0; i < splay_width; i++) {
> +               pos = &client->object_positions_array[i];
> +               INIT_LIST_HEAD(&pos->node);
> +               list_add_tail(&pos->node, &client->object_positions);
> +       }
> +
> +       INIT_LIST_HEAD(&client->node);
> +       client->data = NULL;
> +       client->id = NULL;
> +
> +       return client;
> +free_client:
> +       kfree(client);
> +       return NULL;
> +}
> +
> +static int decode_client(void **p, void *end, struct ceph_journaler_client *client)
> +{
> +       u8 struct_v;
> +       u8 state_raw;
> +       u32 struct_len;
> +       int ret, num, i;
> +       struct ceph_journaler_object_pos *pos;
> +
> +       ret = ceph_start_decoding(p, end, 1, "cls_journal_get_client_reply",
> +                                 &struct_v, &struct_len);
> +       if (ret)
> +               return ret;
> +
> +       client->id = ceph_extract_encoded_string(p, end, &client->id_len, GFP_NOIO);
> +       if (IS_ERR(client->id)) {
> +               ret = PTR_ERR(client->id);
> +               client->id = NULL;
> +               goto err;
> +       }
> +       client->data = ceph_extract_encoded_string(p, end, &client->data_len, GFP_NOIO);
> +       if (IS_ERR(client->data)) {
> +               ret = PTR_ERR(client->data);
> +               client->data = NULL;
> +               goto free_id;
> +       }
> +       ret = ceph_start_decoding(p, end, 1, "cls_joural_client_object_set_position",
> +                                 &struct_v, &struct_len);
> +       if (ret)
> +               goto free_data;
> +
> +       num = ceph_decode_32(p);
> +       i = 0;
> +       list_for_each_entry(pos, &client->object_positions, node) {
> +               if (i < num) {
> +                       // we will use this position stub
> +                       pos->in_using = true;
> +                       ret = decode_object_position(p, end, pos);
> +                       if (ret) {
> +                               goto free_data;
> +                       }
> +               } else {
> +                       // This stub is not used anymore
> +                       pos->in_using = false;
> +               }
> +               i++;
> +       }
> +
> +       state_raw = ceph_decode_8(p);

Just skip over it (i.e. increment p with a comment), don't add bogus local
variables.

> +       return 0;
> +
> +free_data:
> +       kfree(client->data);
> +free_id:
> +       kfree(client->id);
> +err:
> +       return ret;
> +}
> +
> +static int decode_clients(void **p, void *end, struct list_head *clients, uint8_t splay_width)
> +{
> +       int i = 0;
> +       int ret;
> +       uint32_t client_num;
> +       struct ceph_journaler_client *client, *next;
> +
> +       client_num = ceph_decode_32(p);
> +       // Reuse the clients already exist in list.
> +       list_for_each_entry_safe(client, next, clients, node) {
> +               // Some clients unregistered.
> +               if (i < client_num) {
> +                       kfree(client->id);
> +                       kfree(client->data);
> +                       ret = decode_client(p, end, client);
> +                       if (ret)
> +                               return ret;
> +               } else {
> +                       list_del(&client->node);
> +                       destroy_client(client);
> +               }
> +               i++;
> +       }
> +
> +       // Some more clients registered.
> +       for (; i < client_num; i++) {
> +               client = create_client(splay_width);
> +               if (!client)
> +                       return -ENOMEM;
> +               ret = decode_client(p, end, client);
> +               if (ret) {
> +                       destroy_client(client);
> +                       return ret;
> +               }
> +               list_add_tail(&client->node, clients);
> +       }
> +       return 0;
> +}
> +
> +int ceph_cls_journaler_client_list(struct ceph_osd_client *osdc,
> +                                  struct ceph_object_id *oid,
> +                                  struct ceph_object_locator *oloc,
> +                                  struct list_head *clients,
> +                                  uint8_t splay_width)
> +{
> +       struct page *reply_page;
> +       struct page *req_page;
> +       int ret;
> +       size_t reply_len = PAGE_SIZE;
> +       int buf_size;
> +       void *p, *end;
> +       char name[] = "";
> +
> +       buf_size = strlen(name) + sizeof(__le32) + sizeof(uint64_t);
> +
> +       if (buf_size > PAGE_SIZE)
> +               return -E2BIG;

If name is always an empty string, this can't ever be true.

> +
> +       reply_page = alloc_page(GFP_NOIO);
> +       if (!reply_page)
> +               return -ENOMEM;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page) {
> +               ret = -ENOMEM;
> +               goto free_reply_page;
> +       }
> +
> +       p = page_address(req_page);
> +       end = p + buf_size;
> +
> +       ceph_encode_string(&p, end, name, strlen(name));

I would drop name and encode 0 directly.

> +       ceph_encode_64(&p, (uint64_t)256);

This constant needs a define or a comment.  Unnecessary cast.

> +
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "client_list",
> +                            CEPH_OSD_FLAG_READ, req_page,
> +                            buf_size, &reply_page, &reply_len);
> +
> +       if (!ret) {
> +               p = page_address(reply_page);
> +               end = p + reply_len;
> +
> +               ret = decode_clients(&p, end, clients, splay_width);
> +       }
> +
> +       __free_page(req_page);
> +free_reply_page:
> +       __free_page(reply_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_client_list);
> +
> +int ceph_cls_journaler_get_next_tag_tid(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                  uint64_t *tag_tid)
> +{
> +       struct page *reply_page;
> +       int ret;
> +       size_t reply_len = PAGE_SIZE;
> +
> +       reply_page = alloc_page(GFP_NOIO);
> +       if (!reply_page)
> +               return -ENOMEM;
> +
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_next_tag_tid",
> +                            CEPH_OSD_FLAG_READ, NULL,
> +                            0, &reply_page, &reply_len);
> +
> +       if (!ret) {
> +               memcpy(tag_tid, page_address(reply_page), reply_len);

Same here.

> +       }
> +
> +       __free_page(reply_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_get_next_tag_tid);
> +
> +int ceph_cls_journaler_tag_create(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                       uint64_t tag_tid, uint64_t tag_class,
> +                                  void *buf, uint32_t buf_len)
> +{
> +       struct page *req_page;
> +       int ret;
> +       int buf_size;
> +       void *p, *end;
> +
> +       buf_size = buf_len + sizeof(__le32) + sizeof(uint64_t) + sizeof(uint64_t);
> +
> +       if (buf_size > PAGE_SIZE)
> +               return -E2BIG;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page)
> +               return -ENOMEM;
> +
> +       p = page_address(req_page);
> +       end = p + buf_size;
> +
> +       ceph_encode_64(&p, tag_tid);
> +       ceph_encode_64(&p, tag_class);
> +       ceph_encode_string(&p, end, buf, buf_len);
> +
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "tag_create",
> +                            CEPH_OSD_FLAG_WRITE, req_page,
> +                            buf_size, NULL, NULL);
> +
> +       __free_page(req_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_tag_create);
> +
> +int decode_tag(void **p, void *end, struct ceph_journaler_tag *tag)
> +{
> +       int ret;
> +       u8 struct_v;
> +       u32 struct_len;
> +
> +       ret = ceph_start_decoding(p, end, 1, "cls_journaler_tag",
> +                                 &struct_v, &struct_len);
> +       if (ret)
> +               return ret;
> +
> +       tag->tid = ceph_decode_64(p);
> +       tag->tag_class = ceph_decode_64(p);
> +       tag->data = ceph_extract_encoded_string(p, end, &tag->data_len, GFP_NOIO);
> +       if (IS_ERR(tag->data)) {
> +               ret = PTR_ERR(tag->data);
> +               tag->data = NULL;
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +int ceph_cls_journaler_get_tag(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                  uint64_t tag_tid, struct ceph_journaler_tag *tag)
> +{
> +       struct page *reply_page;
> +       struct page *req_page;
> +       int ret;
> +       size_t reply_len = PAGE_SIZE;
> +       int buf_size;
> +       void *p, *end;
> +
> +       buf_size = sizeof(tag_tid);
> +
> +       reply_page = alloc_page(GFP_NOIO);
> +       if (!reply_page)
> +               return -ENOMEM;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page) {
> +               ret = -ENOMEM;
> +               goto free_reply_page;
> +       }
> +
> +       p = page_address(req_page);
> +       end = p + buf_size;
> +       ceph_encode_64(&p, tag_tid);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "get_tag",
> +                            CEPH_OSD_FLAG_READ, req_page,
> +                            buf_size, &reply_page, &reply_len);
> +
> +       if (!ret) {
> +               p = page_address(reply_page);
> +               end = p + reply_len;
> +
> +               ret = decode_tag(&p, end, tag);
> +       }
> +
> +       __free_page(req_page);
> +free_reply_page:
> +       __free_page(reply_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_get_tag);
> +
> +static int version_len = 6;

Use CEPH_ENCODING_START_BLK_LEN.

> +
> +int ceph_cls_journaler_client_committed(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          struct ceph_journaler_client *client,
> +                                       struct list_head *object_positions)
> +{
> +       struct page *req_page;
> +       int ret;
> +       int buf_size;
> +       void *p, *end;
> +       struct ceph_journaler_object_pos *position = NULL;
> +       int object_position_len = version_len + 8 + 8 + 8;
> +       int pos_num = 0;
> +
> +       buf_size = 4 + client->id_len + version_len + 4;
> +       list_for_each_entry(position, object_positions, node) {
> +               buf_size += object_position_len;
> +               pos_num++;
> +       }
> +
> +       if (buf_size > PAGE_SIZE)
> +               return -E2BIG;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page)
> +               return -ENOMEM;
> +
> +       p = page_address(req_page);
> +       end = p + buf_size;
> +       ceph_encode_string(&p, end, client->id, client->id_len);
> +       ceph_start_encoding(&p, 1, 1, buf_size - client->id_len - version_len - 4);
> +       ceph_encode_32(&p, pos_num);
> +
> +       list_for_each_entry(position, object_positions, node) {
> +               ceph_start_encoding(&p, 1, 1, 24);
> +               ceph_encode_64(&p, position->object_num);
> +               ceph_encode_64(&p, position->tag_tid);
> +               ceph_encode_64(&p, position->entry_tid);
> +       }
> +
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "client_commit",
> +                            CEPH_OSD_FLAG_WRITE, req_page,
> +                            buf_size, NULL, NULL);
> +
> +       __free_page(req_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_client_committed);
> +
> +
> +int ceph_cls_journaler_set_minimum_set(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t minimum_set)
> +{
> +       struct page *req_page;
> +       int ret;
> +       void *p;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page)
> +               return -ENOMEM;
> +
> +       p = page_address(req_page);
> +       ceph_encode_64(&p, minimum_set);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "set_minimum_set",
> +                            CEPH_OSD_FLAG_WRITE, req_page,
> +                            8, NULL, NULL);
> +
> +       __free_page(req_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_set_minimum_set);
> +
> +int ceph_cls_journaler_set_active_set(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t active_set)
> +{
> +       struct page *req_page;
> +       int ret;
> +       void *p;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page)
> +               return -ENOMEM;
> +
> +       p = page_address(req_page);
> +       ceph_encode_64(&p, active_set);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "set_active_set",
> +                            CEPH_OSD_FLAG_WRITE, req_page,
> +                            8, NULL, NULL);
> +
> +       __free_page(req_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_set_active_set);
> +
> +int ceph_cls_journaler_guard_append(struct ceph_osd_client *osdc,
> +                                          struct ceph_object_id *oid,
> +                                          struct ceph_object_locator *oloc,
> +                                          uint64_t soft_limit)
> +{
> +       struct page *req_page;
> +       int ret;
> +       void *p;
> +
> +       req_page = alloc_page(GFP_NOIO);
> +       if (!req_page)
> +               return -ENOMEM;
> +
> +       p = page_address(req_page);
> +       ceph_encode_64(&p, soft_limit);
> +       ret = ceph_osdc_call(osdc, oid, oloc, "journal", "guard_append",
> +                            CEPH_OSD_FLAG_READ, req_page,
> +                            8, NULL, NULL);
> +
> +       __free_page(req_page);
> +       return ret;
> +}
> +EXPORT_SYMBOL(ceph_cls_journaler_guard_append);

Looks like this function is unused.

Thanks,

                Ilya
