Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4CD54B216
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jun 2022 15:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238880AbiFNNMg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jun 2022 09:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbiFNNMf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 14 Jun 2022 09:12:35 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0BF1A83B
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 06:12:33 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id a28so1523252uaj.10
        for <ceph-devel@vger.kernel.org>; Tue, 14 Jun 2022 06:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M52TgzVFxZYamGroET81gni50Yd/fFX+koTmyYLlmWw=;
        b=OPuAiDcBCvGfdoJPaFaz8bq10haLSVvVHg4UyTbsA6UK1nnCHghovxUuKAgT3bw8FH
         XW0eYI62CitLK9VH8VPkIFy+RnD4aUOed8J0Kh425zTKLiDtqj/SqmFkiQ+JXZ3n6wjo
         D5hUypSeVbeexdvtUnShPTnRdoarF4F/xQG06DvHOvA0Y7NTaH/JiAF/GhqcL32Zg7iR
         lu6JJMAReaW6yC9hvpD1HQT2KFDE5iNDIyNH07XwM4H4KxAeIA7NNNIxTmUmI07mGcCU
         rk2A7hyZQAcKAaLFNIm3+RiDvZ3RNTHuDY4XCRcc/Uh06Rb770qA8p1f3lTLpmiQzLqv
         1kiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M52TgzVFxZYamGroET81gni50Yd/fFX+koTmyYLlmWw=;
        b=exhJOOFU8KbDfWd6/HaN7JeyHTHFR4JPFLNTeLQaZVRnRzEhhfaaUM2x4Esm5BSriy
         YyZ43+7ZDOmurTl7udxuUDAhdomOK7OhK4SP9yQWfmXdhfMNF3CxqsIfV32OFlZU1KWf
         vuotCMJCF46vf4K+yDS3lVUM+y23Vozlj5rDmAw3Aen8dFSsFRFvfgIs/LytXIwpI9hL
         yzRAON3eXkxgeqlo56qrRWF/+AmTEL+VVKmo3dDEtzerYqw/skSsOdga0VtuVg8kO6Nh
         gp068j9LYta61zL2/N4z+6zafb75rphoEn6BaIWRQavWQQGDZRyIWBOTVq8MYYTh3f4w
         X62w==
X-Gm-Message-State: AJIora9Fq/zcxFM3SnFMjEcrfWoPOUgV/L0y70MdYaznZiluNXIUefJr
        pkfRSnjFJb85bmdRDEjpdbMBwO1RHfW6hibv3ZE=
X-Google-Smtp-Source: AGRyM1vYIgzx7bSLB6vikPvGAZzZCmXlE2MJFxwiEslSYmsILgqXJXQz8yxoRvuw5NCLeY1sBQUeQvtIop+ylaFmLyo=
X-Received: by 2002:ab0:6d9a:0:b0:36e:5a86:92fb with SMTP id
 m26-20020ab06d9a000000b0036e5a8692fbmr2095283uah.38.1655212352568; Tue, 14
 Jun 2022 06:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <bfc20d2c-9198-2cb3-506a-4bae09c6cd68@cybozu.co.jp>
In-Reply-To: <bfc20d2c-9198-2cb3-506a-4bae09c6cd68@cybozu.co.jp>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 14 Jun 2022 15:12:15 +0200
Message-ID: <CAOi1vP9rrmWr7oyy1U_M+x6NSFeQWBZacBEooFgdKXYETVLJ6Q@mail.gmail.com>
Subject: Re: [PATCH v4] libceph: print fsid and client gid with osd id
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

On Mon, Jun 6, 2022 at 8:00 AM Daichi Mukai <daichi-mukai@cybozu.co.jp> wrote:
>
> Print fsid and client gid in libceph log messages to distinct from which
> each message come.
>
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Signed-off-by: Daichi Mukai <daichi-mukai@cybozu.co.jp>
> ---
>   include/linux/ceph/osdmap.h |  2 +-
>   net/ceph/osd_client.c       |  3 ++-
>   net/ceph/osdmap.c           | 43 ++++++++++++++++++++++++++-----------
>   3 files changed, 34 insertions(+), 14 deletions(-)
>
> * Changes since v3
>
> - Rebased to latest mainline
>
> * Changes since v2
>
> - Set scope of this patch to log message for osd
> - Improved format of message
>
> * Changes since v1
>
> - Added client gid to log message
>
> diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> index 5553019c3f07..a9216c64350c 100644
> --- a/include/linux/ceph/osdmap.h
> +++ b/include/linux/ceph/osdmap.h
> @@ -253,7 +253,7 @@ static inline int ceph_decode_pgid(void **p, void *end, struct ceph_pg *pgid)
>   struct ceph_osdmap *ceph_osdmap_alloc(void);
>   struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2);
>   struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
> -                                            struct ceph_osdmap *map);
> +                                            struct ceph_osdmap *map, u64 gid);
>   extern void ceph_osdmap_destroy(struct ceph_osdmap *map);
>
>   struct ceph_osds {
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 9d82bb42e958..e9bd6c27c5ad 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -3945,7 +3945,8 @@ static int handle_one_map(struct ceph_osd_client *osdc,
>         if (incremental)
>                 newmap = osdmap_apply_incremental(&p, end,
>                                                   ceph_msgr2(osdc->client),
> -                                                 osdc->osdmap);
> +                                                 osdc->osdmap,
> +                                                 ceph_client_gid(osdc->client));
>         else
>                 newmap = ceph_osdmap_decode(&p, end, ceph_msgr2(osdc->client));
>         if (IS_ERR(newmap))
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 2823bb3cff55..cd65677baff3 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1549,8 +1549,23 @@ static int decode_primary_affinity(void **p, void *end,
>         return -EINVAL;
>   }
>
> +static __printf(3, 4)
> +void print_osd_info(struct ceph_fsid *fsid, u64 gid, const char *fmt, ...)
> +{
> +       struct va_format vaf;
> +       va_list args;
> +
> +       va_start(args, fmt);
> +       vaf.fmt = fmt;
> +       vaf.va = &args;
> +
> +       printk(KERN_INFO "%s (%pU %lld): %pV", KBUILD_MODNAME, fsid, gid, &vaf);
> +
> +       va_end(args);
> +}
> +
>   static int decode_new_primary_affinity(void **p, void *end,
> -                                      struct ceph_osdmap *map)
> +                                      struct ceph_osdmap *map, u64 gid)
>   {
>         u32 n;
>
> @@ -1566,7 +1581,8 @@ static int decode_new_primary_affinity(void **p, void *end,
>                 if (ret)
>                         return ret;
>
> -               pr_info("osd%d primary-affinity 0x%x\n", osd, aff);
> +               print_osd_info(&map->fsid, gid, "osd%d primary-affinity 0x%x\n",
> +                              osd, aff);
>         }
>
>         return 0;
> @@ -1825,7 +1841,8 @@ struct ceph_osdmap *ceph_osdmap_decode(void **p, void *end, bool msgr2)
>    *     new_state: { osd=6, xorstate=EXISTS } # clear osd_state
>    */
>   static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
> -                                     bool msgr2, struct ceph_osdmap *map)
> +                                     bool msgr2, struct ceph_osdmap *map,
> +                                     u64 gid)
>   {
>         void *new_up_client;
>         void *new_state;
> @@ -1864,9 +1881,10 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>                 osd = ceph_decode_32(p);
>                 w = ceph_decode_32(p);
>                 BUG_ON(osd >= map->max_osd);
> -               pr_info("osd%d weight 0x%x %s\n", osd, w,
> -                    w == CEPH_OSD_IN ? "(in)" :
> -                    (w == CEPH_OSD_OUT ? "(out)" : ""));
> +               print_osd_info(&map->fsid, gid, "osd%d weight 0x%x %s\n",
> +                              osd, w,
> +                              w == CEPH_OSD_IN ? "(in)" :
> +                              (w == CEPH_OSD_OUT ? "(out)" : ""));
>                 map->osd_weight[osd] = w;
>
>                 /*
> @@ -1898,10 +1916,11 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>                 BUG_ON(osd >= map->max_osd);
>                 if ((map->osd_state[osd] & CEPH_OSD_UP) &&
>                     (xorstate & CEPH_OSD_UP))
> -                       pr_info("osd%d down\n", osd);
> +                       print_osd_info(&map->fsid, gid, "osd%d down\n", osd);
>                 if ((map->osd_state[osd] & CEPH_OSD_EXISTS) &&
>                     (xorstate & CEPH_OSD_EXISTS)) {
> -                       pr_info("osd%d does not exist\n", osd);
> +                       print_osd_info(&map->fsid, gid, "osd%d does not exist\n",
> +                                      osd);
>                         ret = set_primary_affinity(map, osd,
>                                                    CEPH_OSD_DEFAULT_PRIMARY_AFFINITY);
>                         if (ret)
> @@ -1931,7 +1950,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>
>                 dout("%s osd%d addr %s\n", __func__, osd, ceph_pr_addr(&addr));
>
> -               pr_info("osd%d up\n", osd);
> +               print_osd_info(&map->fsid, gid, "osd%d up\n", osd);
>                 map->osd_state[osd] |= CEPH_OSD_EXISTS | CEPH_OSD_UP;
>                 map->osd_addr[osd] = addr;
>         }
> @@ -1947,7 +1966,7 @@ static int decode_new_up_state_weight(void **p, void *end, u8 struct_v,
>    * decode and apply an incremental map update.
>    */
>   struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
> -                                            struct ceph_osdmap *map)
> +                                            struct ceph_osdmap *map, u64 gid)
>   {
>         struct ceph_fsid fsid;
>         u32 epoch = 0;
> @@ -2033,7 +2052,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>         }
>
>         /* new_up_client, new_state, new_weight */
> -       err = decode_new_up_state_weight(p, end, struct_v, msgr2, map);
> +       err = decode_new_up_state_weight(p, end, struct_v, msgr2, map, gid);
>         if (err)
>                 goto bad;
>
> @@ -2051,7 +2070,7 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end, bool msgr2,
>
>         /* new_primary_affinity */
>         if (struct_v >= 2) {
> -               err = decode_new_primary_affinity(p, end, map);
> +               err = decode_new_primary_affinity(p, end, map, gid);
>                 if (err)
>                         goto bad;
>         }
> --
> 2.25.1

Hi Daichi,

I played with this a bit and decided that printing gid is not needed
after all, given that only osdmap messages are changed.  Instead,
I switched to printing epoch which can be very useful when debugging
stuck OSD requests.  Here is the patch I ended up with:

    https://github.com/ceph/ceph-client/commit/b5f9965fad5a4f3a8d17aa234167e8a85e1b9105

Could you please take a look and let me know if you are OK with it?

Thanks,

                Ilya
