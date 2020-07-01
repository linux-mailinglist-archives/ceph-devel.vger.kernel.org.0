Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7647721125E
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Jul 2020 20:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbgGASIk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Jul 2020 14:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729871AbgGASIj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Jul 2020 14:08:39 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966ACC08C5C1
        for <ceph-devel@vger.kernel.org>; Wed,  1 Jul 2020 11:08:39 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i18so21881319ilk.10
        for <ceph-devel@vger.kernel.org>; Wed, 01 Jul 2020 11:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=20e7KxVW/I7c5k2nhzP9hhFgzdDWtbrKrihjhvDK1EU=;
        b=DlQHlXY7OQbbQMpY6cCjGPI3Ih1hQQrMGdDLaCeKfoHZFqHkE9Mz3r9YiRRBQzCohR
         R4nWtltkdFzqQy3h/M0k+05BLvdBUzDD49gM3beRAVC6Gryuv/VN/s4e3INh5frs4z0M
         Ph60tMb2oiZKwMEMC9YbmN/ODiS8nmybDy83X/zKME8pmYTX8EQOxDizEVyQci2JUqhR
         kfUSeKRmdzf9tmPHAthicZidZ0FLqKiGWIHspNktP6HI+fzqCBdrSVlFwYhLWI5yCegE
         542//L7tW48lok2QVtMaf6Y1FSBGUmAYNQV7frHlBh0u/5OTrgh3OpqH83388rRbRtTj
         UzYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=20e7KxVW/I7c5k2nhzP9hhFgzdDWtbrKrihjhvDK1EU=;
        b=FKkd/ZQncsvhDrt7G4IhI+XPkXm9NZ56rvzUpBxGVOojwzbBbtb90IjWdib/1srCAU
         cIY5ymBWh4LuuYPYKCKs6E6j8cgI8AxKmnPbvqrBEYUC36bMdSdaI4pyguKVqW4HH8nL
         KDB6OFPc4/lGaWUN8fgcwTwDxypEUyhbmz2L8MeOLc7ePvT6/hAoO0xjTYy9XCJsYOba
         jtU5ho5YsaQZshOE5DyL2uF8ys49LHi2F1MrETLsSSzHvXaOZkvKMGj9A23laj6723FT
         imSusNNeGUmIqv0cost52TD4suTYjSDPGCWnPyBjWjeU00NlkDTqdiDBxcWFctwQoh1D
         S6Ug==
X-Gm-Message-State: AOAM532LSIeL/RqSENERMIQXdTK9w0K9woHGR6Cusnj8uBdG3uJOOQRZ
        kMubtYx1Zyn0gt3228TiFkirWOPQzGeH63h8ATEQLZPkzFs=
X-Google-Smtp-Source: ABdhPJz1+O8SmszXEkA9SockUTvuuFJClTVptrvymjYxKxUQxdC3buTiz+6F7n9NOOfSdqtU/xI9uHOe3X82bAu5c0c=
X-Received: by 2002:a92:794f:: with SMTP id u76mr8284534ilc.215.1593626918824;
 Wed, 01 Jul 2020 11:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200701155446.41141-1-jlayton@kernel.org> <20200701155446.41141-3-jlayton@kernel.org>
In-Reply-To: <20200701155446.41141-3-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 1 Jul 2020 20:08:44 +0200
Message-ID: <CAOi1vP-o16swX+oHd0Xj30jdTqYUUrm5Fk4O7rA2LwNBKne5QQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] libceph: refactor osdc request initialization
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 1, 2020 at 5:54 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Turn the request_init helper into a more full-featured initialization
> routine that we can use to initialize an already-allocated request.
> Make it a public and exported function so we can use it from ceph.ko.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/osd_client.h |  4 ++++
>  net/ceph/osd_client.c           | 28 +++++++++++++++-------------
>  2 files changed, 19 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 8d63dc22cb36..40a08c4e5d8d 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -495,6 +495,10 @@ extern struct ceph_osd_request *ceph_osdc_new_request(struct ceph_osd_client *,
>
>  extern void ceph_osdc_get_request(struct ceph_osd_request *req);
>  extern void ceph_osdc_put_request(struct ceph_osd_request *req);
> +void ceph_osdc_init_request(struct ceph_osd_request *req,
> +                           struct ceph_osd_client *osdc,
> +                           struct ceph_snap_context *snapc,
> +                           unsigned int num_ops);
>
>  extern int ceph_osdc_start_request(struct ceph_osd_client *osdc,
>                                    struct ceph_osd_request *req,
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 3cff29d38b9f..4ddf23120b1a 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -523,7 +523,10 @@ void ceph_osdc_put_request(struct ceph_osd_request *req)
>  }
>  EXPORT_SYMBOL(ceph_osdc_put_request);
>
> -static void request_init(struct ceph_osd_request *req)
> +void ceph_osdc_init_request(struct ceph_osd_request *req,
> +                           struct ceph_osd_client *osdc,
> +                           struct ceph_snap_context *snapc,
> +                           unsigned int num_ops)
>  {
>         /* req only, each op is zeroed in osd_req_op_init() */
>         memset(req, 0, sizeof(*req));
> @@ -535,7 +538,13 @@ static void request_init(struct ceph_osd_request *req)
>         INIT_LIST_HEAD(&req->r_private_item);
>
>         target_init(&req->r_t);
> +
> +       req->r_osdc = osdc;
> +       req->r_num_ops = num_ops;
> +       req->r_snapid = CEPH_NOSNAP;
> +       req->r_snapc = ceph_get_snap_context(snapc);
>  }
> +EXPORT_SYMBOL(ceph_osdc_init_request);
>
>  /*
>   * This is ugly, but it allows us to reuse linger registration and ping
> @@ -563,12 +572,9 @@ static void request_reinit(struct ceph_osd_request *req)
>         WARN_ON(kref_read(&reply_msg->kref) != 1);
>         target_destroy(&req->r_t);
>
> -       request_init(req);
> -       req->r_osdc = osdc;
> +       ceph_osdc_init_request(req, osdc, snapc, num_ops);
>         req->r_mempool = mempool;
> -       req->r_num_ops = num_ops;
>         req->r_snapid = snapid;
> -       req->r_snapc = snapc;
>         req->r_linger = linger;
>         req->r_request = request_msg;
>         req->r_reply = reply_msg;
> @@ -591,15 +597,11 @@ struct ceph_osd_request *ceph_osdc_alloc_request(struct ceph_osd_client *osdc,
>                 BUG_ON(num_ops > CEPH_OSD_MAX_OPS);
>                 req = kmalloc(struct_size(req, r_ops, num_ops), gfp_flags);
>         }
> -       if (unlikely(!req))
> -               return NULL;
>
> -       request_init(req);
> -       req->r_osdc = osdc;
> -       req->r_mempool = use_mempool;
> -       req->r_num_ops = num_ops;
> -       req->r_snapid = CEPH_NOSNAP;
> -       req->r_snapc = ceph_get_snap_context(snapc);
> +       if (likely(req)) {
> +               req->r_mempool = use_mempool;
> +               ceph_osdc_init_request(req, osdc, snapc, num_ops);
> +       }
>
>         dout("%s req %p\n", __func__, req);
>         return req;

What is going to use ceph_osdc_init_request()?

Given that OSD request allocation is non-trivial, exporting a
routine for initializing already allocated requests doesn't seem
like a good idea.  How do you ensure that the OSD request to be
initialized has enough room for passed num_ops?  What about calling
this routine on a request that has already been initialized?
None of these issues exist today...

Thanks,

                Ilya
