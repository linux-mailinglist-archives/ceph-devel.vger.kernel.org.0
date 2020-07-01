Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228FC211307
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 20:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgGASr5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 14:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgGASr4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 14:47:56 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702FBC08C5C1
        for <ceph-devel@vger.kernel.org>; Wed,  1 Jul 2020 11:47:56 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id i18so21988278ilk.10
        for <ceph-devel@vger.kernel.org>; Wed, 01 Jul 2020 11:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ek1hpi1drb/d5qKjPsfvYwnvCmpkcVAPgD3aBiVekOs=;
        b=pxp4BfeT0TYRB3nPs9R4km2GiwoKsNEcw5dxLabO9H2kIK6MyMUpSgshG9RlKW9ZMg
         /xNf9dAF/f4kzaBJFgdYF8VAfVBVg5TN6wLhjD0kIKHutrhDM33HpbWu5ZWjDDo8YGyq
         JHnoY8F6SS8g4GwhIx52IOYx5atpXhjE31BFgaXB9oKBD/5NnWbkObOCRDSbEFVBjaEH
         2VpCNJCmNx0iHVjVdQJHmW4WP3qheZTGcUP4MtzHV2HLrPG9j5+pMP0RvxNqMFh9QT6l
         oW9MDbizP0ycY3q6PYfr1qq0m1M5MOr7kjBAjZ/DBYNuK5DjcSShHWqVOYzWtC2Du1Kv
         vuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ek1hpi1drb/d5qKjPsfvYwnvCmpkcVAPgD3aBiVekOs=;
        b=liR6jaz8Qd/S1+CFQiNNtQSjaY5rHh7nwmNdkzewIF/zsW8RQSrqe1o/2cXmiwabx+
         328BsruDEFA12R39AXF2M4FvreHK643KxTdAygX4nXSVapeP6zzalREW7dUFRvfKcyz6
         H4fG8oBBz1435Z9N1eagSG79tqQ6smSaQj6vtoKDZ2A/tXYsIeFVfnQd8I1WSYK2BD/z
         hzZX555oJYu8YvwzUOIyYSW40LtjZL1ueZ0tso/hVcNodLlwyuXAXywc73anbklJ+Fjq
         8YccrXdvo4DLV+/jkwJ1ZZ+tml0PeGNtZnYqy+AAruldNRScgS0GhbI4exLQjFkAcKgz
         Lhiw==
X-Gm-Message-State: AOAM532bVcibv3XO0imzpLN8zR2Tjj5an3HsFXicb48Ul6A6P0Oa7/1W
        3vPmYn+hSNBBtGBjhu/KuRD1wSA8Nub/zOSOQQ4=
X-Google-Smtp-Source: ABdhPJzgW9x2TydpdXRD7E3OSdkCY1nd4JSMVkd0XwBhnkh4LERc0GPWrh1hod7OYK207S6PVgFWfXfHNe6p+hsc/9o=
X-Received: by 2002:a92:5e59:: with SMTP id s86mr9684459ilb.112.1593629275840;
 Wed, 01 Jul 2020 11:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155446.41141-1-jlayton@kernel.org> <20200701155446.41141-4-jlayton@kernel.org>
In-Reply-To: <20200701155446.41141-4-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 1 Jul 2020 20:48:01 +0200
Message-ID: <CAOi1vP_200rymwrks34JTn224Y6yGaBfu2oX01xj-qKS+c08sQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] libceph: rename __ceph_osdc_alloc_messages to ceph_osdc_alloc_num_messages
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 1, 2020 at 5:54 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> ...and make it public and export it.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/osd_client.h |  3 +++
>  net/ceph/osd_client.c           | 13 +++++++------
>  2 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 40a08c4e5d8d..71b7610c3a3c 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -481,6 +481,9 @@ extern struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *
>                                                unsigned int num_ops,
>                                                bool use_mempool,
>                                                gfp_t gfp_flags);
> +int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> +                                int num_request_data_items,
> +                                int num_reply_data_items);
>  int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp);
>
>  extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 4ddf23120b1a..7be78fa6e2c3 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -613,9 +613,9 @@ static int ceph_oloc_encoding_size(const struct ceph_object_locator *oloc)
>         return 8 + 4 + 4 + 4 + (oloc->pool_ns ? oloc->pool_ns->len : 0);
>  }
>
> -static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
> -                                     int num_request_data_items,
> -                                     int num_reply_data_items)
> +int ceph_osdc_alloc_num_messages(struct ceph_osd_request *req, gfp_t gfp,
> +                                int num_request_data_items,
> +                                int num_reply_data_items)
>  {
>         struct ceph_osd_client *osdc = req->r_osdc;
>         struct ceph_msg *msg;
> @@ -672,6 +672,7 @@ static int __ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp,
>
>         return 0;
>  }
> +EXPORT_SYMBOL(ceph_osdc_alloc_num_messages);
>
>  static bool osd_req_opcode_valid(u16 opcode)
>  {
> @@ -738,8 +739,8 @@ int ceph_osdc_alloc_messages(struct ceph_osd_request *req, gfp_t gfp)
>         int num_request_data_items, num_reply_data_items;
>
>         get_num_data_items(req, &num_request_data_items, &num_reply_data_items);
> -       return __ceph_osdc_alloc_messages(req, gfp, num_request_data_items,
> -                                         num_reply_data_items);
> +       return ceph_osdc_alloc_num_messages(req, gfp, num_request_data_items,
> +                                                 num_reply_data_items);
>  }
>  EXPORT_SYMBOL(ceph_osdc_alloc_messages);
>
> @@ -1129,7 +1130,7 @@ struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *osdc,
>                  * also covers ceph_uninline_data().  If more multi-op request
>                  * use cases emerge, we will need a separate helper.
>                  */
> -               r = __ceph_osdc_alloc_messages(req, GFP_NOFS, num_ops, 0);
> +               r = ceph_osdc_alloc_num_messages(req, GFP_NOFS, num_ops, 0);
>         else
>                 r = ceph_osdc_alloc_messages(req, GFP_NOFS);
>         if (r)

I think exporting __ceph_osdc_alloc_messages() is wrong, at least
conceptually.  Only the OSD client should be concerned with message
data items and their count, as they are an implementation detail of
the OSD client and the messenger.  Exporting something that takes
message data items counts without exporting something for counting
them suggests that users will somehow do that on their own and we
don't want that.

Thanks,

                Ilya
