Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD3D92150
	for <lists+ceph-devel@lfdr.de>; Mon, 19 Aug 2019 12:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfHSKe3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Aug 2019 06:34:29 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45318 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfHSKe3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 19 Aug 2019 06:34:29 -0400
Received: by mail-io1-f65.google.com with SMTP id t3so3078662ioj.12
        for <ceph-devel@vger.kernel.org>; Mon, 19 Aug 2019 03:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+DrN0E1g0V2wDTnXA6UnIH87xElZ39Z7Qlg+NNqBL0=;
        b=HdKPvwvSmeULoN7eIIr1awHf1jYCue6I4q+afMJGrkqo38ES5J5wwCkUXIetj+JDSw
         TupwSAdVMKqfdBRvLjBIVf0sWrCmo/3hWTzewqudvbHxVmKpG0V92D1IoMJG7rJmIKqO
         A56UnQH0hkkPXKgN2CQi3OveiCJE3vgxtWtgBrUz2LIbOPXaWOUHd74M6Hu+eraoRLIK
         /ekzqF8+pyEeMRAQaIZDinVa82L6HkjDTC1OcBzwzx7aIKCHHvbVerFmZOZJdFy7YFEm
         EfyLX1Bj+LFNCX6epCvC1FGzkgWcXqN1xg8cGXUrFRcLYFUM4PH4LwEzmzTqwLmBdmEI
         zzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+DrN0E1g0V2wDTnXA6UnIH87xElZ39Z7Qlg+NNqBL0=;
        b=SI77gdpaZeVklh0aYlCsKgCgkq2eEKgI8m6nGHmNqvefOrcHBt8lQcR0H3iLfvLDRI
         3nQ3+jKh8RHnQwpkKznkLudNS/+jFpcoepn+uAxEtaQeXYh4Hziku36AVz23N64sCofy
         MHBxwNWxKKAfWLcExr8qlBypKTjl2RMyFJVCepIsyctZ1I7Rsp788xUUqPK2EzqDAZRj
         AGyAOA2ivmtNAPtGLDObbPZPNLRdp3N0vb3MNtZ9xWbuboWX6gw1QZmBE2jzmS/XcqtW
         EljWHprQ3BxktMHIdybG6IVr4ZV0uRpBfYAfIEpMQFDdFTQSb+9NhkZ77Vk4D0IDDIaj
         ptDQ==
X-Gm-Message-State: APjAAAWYF9AE0k4CBpmmAP9K77ns+ACkuMVs9vD/YuKM2KEkLQTwUmtV
        sz/VFll8yW+IsToKd2Kfg3omUD3S+VRsq/DNwvB1AWZk
X-Google-Smtp-Source: APXvYqx7TqAY2XUdwUio8HybYFeCS765aWpRe+uMdTx30lx1fXPZyG/lFojFqSh0U2QCUUcbJxmAh1nooziarsYg9nA=
X-Received: by 2002:a5d:844c:: with SMTP id w12mr280817ior.51.1566210868227;
 Mon, 19 Aug 2019 03:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <1564393377-28949-1-git-send-email-dongsheng.yang@easystack.cn> <1564393377-28949-13-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1564393377-28949-13-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 19 Aug 2019 12:37:27 +0200
Message-ID: <CAOi1vP_vw7uDUERh8iOOy4N8Ph9Ddh2qiLpkBFd=1fwQK=yK9Q@mail.gmail.com>
Subject: Re: [PATCH v3 12/15] rbd: introduce rbd_journal_allocate_tag to
 allocate journal tag for rbd client
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
> rbd_journal_allocate_tag() get the client by client id and allocate an uniq tag
> for this client.
>
> All journal events from this client will be tagged by this tag.
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  drivers/block/rbd.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 337a20f..86008f2 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -28,16 +28,19 @@
>
>   */
>
> +#include <linux/crc32c.h>

What is this include for?

>  #include <linux/ceph/libceph.h>
>  #include <linux/ceph/osd_client.h>
>  #include <linux/ceph/mon_client.h>
>  #include <linux/ceph/cls_lock_client.h>
>  #include <linux/ceph/striper.h>
>  #include <linux/ceph/decode.h>
> +#include <linux/ceph/journaler.h>
>  #include <linux/parser.h>
>  #include <linux/bsearch.h>
>
>  #include <linux/kernel.h>
> +#include <linux/bio.h>

Same here.

>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/blk-mq.h>
> @@ -470,6 +473,14 @@ enum rbd_dev_flags {
>         RBD_DEV_FLAG_REMOVING,  /* this mapping is being removed */
>  };
>
> +#define        LOCAL_MIRROR_UUID       ""
> +#define        LOCAL_CLIENT_ID         ""
> +
> +struct rbd_journal {
> +       struct ceph_journaler *journaler;
> +       uint64_t                tag_tid;
> +};

I think these two fields can be embedded into struct rbd_device
directly.

> +
>  static DEFINE_MUTEX(client_mutex);     /* Serialize client creation */
>
>  static LIST_HEAD(rbd_dev_list);    /* devices */
> @@ -6916,6 +6927,107 @@ static int rbd_dev_header_name(struct rbd_device *rbd_dev)
>         return ret;
>  }
>
> +typedef struct rbd_journal_tag_predecessor {
> +       bool commit_valid;
> +       uint64_t tag_tid;
> +       uint64_t entry_tid;
> +       uint32_t uuid_len;
> +       char *mirror_uuid;
> +} rbd_journal_tag_predecessor;
> +
> +typedef struct rbd_journal_tag_data {
> +       struct rbd_journal_tag_predecessor predecessor;
> +       uint32_t uuid_len;
> +       char *mirror_uuid;
> +} rbd_journal_tag_data;

Why typedef these structs?

> +
> +static uint32_t tag_data_encoding_size(struct rbd_journal_tag_data *tag_data)
> +{
> +       // sizeof(uuid_len) 4 + uuid_len + 1 commit_valid + 8 tag_tid +
> +       // 8 entry_tid + 4 sizeof(uuid_len) + uuid_len
> +       return (4 + tag_data->uuid_len + 1 + 8 + 8 + 4 +
> +               tag_data->predecessor.uuid_len);
> +}
> +
> +static void predecessor_encode(void **p, void *end,
> +                              struct rbd_journal_tag_predecessor *predecessor)
> +{
> +       ceph_encode_string(p, end, predecessor->mirror_uuid,
> +                          predecessor->uuid_len);
> +       ceph_encode_8(p, predecessor->commit_valid);
> +       ceph_encode_64(p, predecessor->tag_tid);
> +       ceph_encode_64(p, predecessor->entry_tid);
> +}
> +
> +static int rbd_journal_encode_tag_data(void **p, void *end,
> +                                      struct rbd_journal_tag_data *tag_data)
> +{
> +       struct rbd_journal_tag_predecessor *predecessor = &tag_data->predecessor;
> +
> +       ceph_encode_string(p, end, tag_data->mirror_uuid, tag_data->uuid_len);
> +       predecessor_encode(p, end, predecessor);
> +
> +       return 0;
> +}
> +
> +static int rbd_journal_allocate_tag(struct rbd_journal *journal)
> +{
> +       struct ceph_journaler_tag tag = {};
> +       struct rbd_journal_tag_data tag_data = {};
> +       struct ceph_journaler *journaler = journal->journaler;
> +       struct ceph_journaler_client *client;
> +       struct rbd_journal_tag_predecessor *predecessor;
> +       struct ceph_journaler_object_pos *position;
> +       void *orig_buf, *buf, *p, *end;
> +       uint32_t buf_len;
> +       int ret;
> +
> +       ret = ceph_journaler_get_cached_client(journaler, LOCAL_CLIENT_ID, &client);
> +       if (ret)
> +               goto out;
> +
> +       position = list_first_entry(&client->object_positions,
> +                                   struct ceph_journaler_object_pos, node);
> +
> +       predecessor = &tag_data.predecessor;
> +       predecessor->commit_valid = true;
> +       predecessor->tag_tid = position->tag_tid;
> +       predecessor->entry_tid = position->entry_tid;
> +       predecessor->uuid_len = 0;
> +       predecessor->mirror_uuid = LOCAL_MIRROR_UUID;
> +
> +       tag_data.uuid_len = 0;
> +       tag_data.mirror_uuid = LOCAL_MIRROR_UUID;

If ->mirror_uuid is always "" (and ->uuid_len is always 0), drop them
and encode 0 directly instead of using ceph_encode_string().

Thanks,

                Ilya
