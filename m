Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9295887C5
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Aug 2022 09:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbiHCHNP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Aug 2022 03:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbiHCHNO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Aug 2022 03:13:14 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B5713E36
        for <ceph-devel@vger.kernel.org>; Wed,  3 Aug 2022 00:13:13 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id 66so16965856vse.4
        for <ceph-devel@vger.kernel.org>; Wed, 03 Aug 2022 00:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q9b79jY/u17GYRFU9G4m0npY134fiHh7X1IiD0DxvRU=;
        b=glX3OPmzpAb9xAIS3vJ0fPg8xdHVf/DJouN1WE5ehgvpKsk68Hn4+Uir3vEwgT/uuh
         03G/ZytF4ucSugLOoE9RmYpimTXB2n4FQ8966od8Yp/PI0KNm2vXp8Kwqu9zxuQmuy2t
         WJs9zeNK5QWrzrnsW8wMOLXJTOx6wJH9yDrpDUBg0K+A63ehCA83Q0rr8vCYLTi/FXkF
         prTwgO2slN50AhBD2Qil/JgZQuDdDrG1lN42vOns37GToId4EQ7wlpHRPHdeH7FI+DH4
         sLXJlYFn/tNMT8fjFNEyRQB42PZYov1LUcJ+2lFY7gTQZggfN/0NpP/RdAiMLg/FxQtq
         w1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q9b79jY/u17GYRFU9G4m0npY134fiHh7X1IiD0DxvRU=;
        b=ZbMFY2tH1MElwAltVlFD4Fg9jggFISqhoftNduvpjp8neSZqtk5m7Qkwon4O4c39Wm
         6ALbXPiGqXGewOYbEcUmPeZFg4GUYUaamt41XfSg9xqIUg99eBSu+62ZNaaj7RKWrfg2
         WQsdJEQURzW1HFVRp+lKR2RqLpfREEzSeQFhPQMJy0hjIA2sk33nHH+sXqqNs+tH/rCH
         wilbvEgVaL6VvBO7ev55ZSnozUKAgoN/xTL8FDkdVTdSR2/ixrjcOywFYQ7KpJ86tU20
         MQbNeMWxCrtUyXN3glayjyjleqodJrJ2Yky18pa5otPrFx1zjpgMGa8JC1LkdfARAi2L
         kOYg==
X-Gm-Message-State: AJIora9dTbj3A1sqTd6yvRkQzb/v4lD7cykxzcm6Zb4g0NIosQvEunKt
        V4c1xHH2M5YYsZfsod1ckd4wbzpvVTcVippI1EQ=
X-Google-Smtp-Source: AGRyM1vkzZonf/Zj7tXptc3bBzaAD9r5AhbzTpxh9x2q6/53xcm77wkWsHSKXYeU6d+hTJJXtBe0a5pFG7aBtJTz5uw=
X-Received: by 2002:a67:af07:0:b0:358:3951:343e with SMTP id
 v7-20020a67af07000000b003583951343emr8542385vsl.6.1659510792812; Wed, 03 Aug
 2022 00:13:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220630202150.653547-1-jlayton@kernel.org>
In-Reply-To: <20220630202150.653547-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Aug 2022 09:13:01 +0200
Message-ID: <CAOi1vP_PETHhCm3nUm5B_t0tMJQdmdBxsAmMpbPoGTD1WimMpg@mail.gmail.com>
Subject: Re: [PATCH] libceph: clean up ceph_osdc_start_request prototype
To:     Jeff Layton <jlayton@kernel.org>
Cc:     xiubli@redhat.com, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 30, 2022 at 10:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> This function always returns 0, and ignores the nofail boolean. Drop the
> nofail argument, make the function void return and fix up the callers.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  drivers/block/rbd.c             |  6 +++---
>  fs/ceph/addr.c                  | 32 ++++++++++++--------------------
>  fs/ceph/file.c                  | 32 +++++++++++++-------------------
>  include/linux/ceph/osd_client.h |  5 ++---
>  net/ceph/osd_client.c           | 15 ++++++---------
>  5 files changed, 36 insertions(+), 54 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 91e541aa1f64..a8af0329ab77 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -1297,7 +1297,7 @@ static void rbd_osd_submit(struct ceph_osd_request *osd_req)
>         dout("%s osd_req %p for obj_req %p objno %llu %llu~%llu\n",
>              __func__, osd_req, obj_req, obj_req->ex.oe_objno,
>              obj_req->ex.oe_off, obj_req->ex.oe_len);
> -       ceph_osdc_start_request(osd_req->r_osdc, osd_req, false);
> +       ceph_osdc_start_request(osd_req->r_osdc, osd_req);
>  }
>
>  /*
> @@ -2081,7 +2081,7 @@ static int rbd_object_map_update(struct rbd_obj_request *obj_req, u64 snap_id,
>         if (ret)
>                 return ret;
>
> -       ceph_osdc_start_request(osdc, req, false);
> +       ceph_osdc_start_request(osdc, req);
>         return 0;
>  }
>
> @@ -4768,7 +4768,7 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
>         if (ret)
>                 goto out_req;
>
> -       ceph_osdc_start_request(osdc, req, false);
> +       ceph_osdc_start_request(osdc, req);
>         ret = ceph_osdc_wait_request(osdc, req);
>         if (ret >= 0)
>                 ceph_copy_from_page_vector(pages, buf, 0, ret);
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index fe6147f20dee..66dc7844fcc6 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -357,9 +357,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
>         req->r_inode = inode;
>         ihold(inode);
>
> -       err = ceph_osdc_start_request(req->r_osdc, req, false);
> -       if (err)
> -               iput(inode);
> +       ceph_osdc_start_request(req->r_osdc, req);
>  out:
>         ceph_osdc_put_request(req);
>         if (err)

Hi Jeff,

I'm confused by this err != 0 check.  Previously err was set to 0
by ceph_osdc_start_request() and netfs_subreq_terminated() was never
called after an OSD request submission.  Now it is called, but only if
len != 0?

I see that netfs_subreq_terminated() accepts either the amount of data
transferred or an error code but it also has some transferred_or_error
== 0 handling which this check effectively disables.  And do we really
want to account for transferred data before the transfer occurs?

Thanks,

                Ilya
