Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6CE66A80AA
	for <lists+ceph-devel@lfdr.de>; Thu,  2 Mar 2023 12:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjCBLED (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 2 Mar 2023 06:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjCBLD7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 2 Mar 2023 06:03:59 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED0F448E
        for <ceph-devel@vger.kernel.org>; Thu,  2 Mar 2023 03:03:33 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id da10so66057575edb.3
        for <ceph-devel@vger.kernel.org>; Thu, 02 Mar 2023 03:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677755012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Ipgae3doacgRHpktCF96ZypWJb47br71xQAZBFrhhs=;
        b=ggK4aqSCtUey/xp5p/I/eqGyO3eBGT+Ml3d7yGo9D4pw0qXY7zLgSEAOBkQ+KZACiG
         pzFE0clU5GO6FYQCYVtscMD1ElntomzbiNluVGCu5O9PKseJHPY7WzzDNe5dR3okM64A
         YelAh0jhlI/fhKVOaEDArpkz7I0xfFpoAf256iEdA+AAjHPdYJ3xfmKAl3KgJyQXQvJL
         Utn6PHdjw7Wu2N4rgemADaiqOt5g+rlv/VixxI+K6gBDmrrShypRL9uTE26skq/YuM45
         jxGR+J7naO1a8kRQ3ZF+Qbqq0/IbYpnnT/2D3+xwpJd7256xwYXEjzcdamdmC7LvM1Ms
         8K+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677755012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Ipgae3doacgRHpktCF96ZypWJb47br71xQAZBFrhhs=;
        b=vfYxR2+x9fbZox17GyfNXbu3vIjeHwwslhJ9Mj1FfuzSGc+n8QUioBsXzNDDm1nqYl
         Ucb04nvNbuIN/5iWa1RLzP+x5n0kldrr35dtgHGWMJmETgUdp3jHjSMLh5wbRC0RixAv
         g+InBxcvhZ5bL+pSJHFfA5zFbWZTe3ksYe7xnXm9pKcm8NKleYYP2II//A3omgAUUq71
         1yrHrqmSq8lWlc5DHkM2QrOlzjXkDvzZqPR2iklql2HSVIoBlFMrRhowKa8zjRMcBsfu
         zFKlZvCTWgzGgyswuEpi0cQ/dbHSxTdsxdmX+QQg/08B5rKayXWg805+p5ohMi7jH1PJ
         Rbpw==
X-Gm-Message-State: AO0yUKVG76U938NLIHPOFur04vjpyopdOAq1/dK2MXhH4j5/uS9Y3Jtr
        CqJ7Homj1lgXcM7HTYH12KqW97XhqrME58AOv1Y=
X-Google-Smtp-Source: AK7set9gYw9+6Ac0ZWb+ZAidlQWfGFZ0XxZICTbh4xfS84Q/WiMMKQw0BEzJ83bCEEf1AQ8cA2NlcnoXKyDsHOdlPgg=
X-Received: by 2002:a50:c30c:0:b0:4be:f5a0:a810 with SMTP id
 a12-20020a50c30c000000b004bef5a0a810mr2044876edb.0.1677755012190; Thu, 02 Mar
 2023 03:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20230302032649.407500-1-xiubli@redhat.com>
In-Reply-To: <20230302032649.407500-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 2 Mar 2023 12:03:20 +0100
Message-ID: <CAOi1vP_Ghb9F1ccrj-d=GQu9xrUw4wSBRJur_LET+-Rm0QLHTg@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: do not print the whole xattr value if it's too long
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org, lhenriques@suse.de,
        vshankar@redhat.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 2, 2023 at 4:26=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> If the xattr's value size is long enough the kernel will warn and
> then will fail the xfstests test case.
>
> Just print part of the value string if it's too long.
>
> URL: https://tracker.ceph.com/issues/58404
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - s/MAX_XATTR_VAL/MAX_XATTR_VAL_PRINT_LEN/g
> - removed the CCing stable mail list
>
>
>  fs/ceph/xattr.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b10d459c2326..25a585e63a2d 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -561,6 +561,8 @@ static struct ceph_vxattr *ceph_match_vxattr(struct i=
node *inode,
>         return NULL;
>  }
>
> +#define MAX_XATTR_VAL_PRINT_LEN 256
> +
>  static int __set_xattr(struct ceph_inode_info *ci,
>                            const char *name, int name_len,
>                            const char *val, int val_len,
> @@ -654,8 +656,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
>                 dout("__set_xattr_val p=3D%p\n", p);
>         }
>
> -       dout("__set_xattr_val added %llx.%llx xattr %p %.*s=3D%.*s\n",
> -            ceph_vinop(&ci->netfs.inode), xattr, name_len, name, val_len=
, val);
> +       dout("__set_xattr_val added %llx.%llx xattr %p %.*s=3D%.*s%s\n",

Hi Xiubo,

The function name is incorrect here and above, it should be __set_xattr.

> +            ceph_vinop(&ci->netfs.inode), xattr, name_len, name,
> +            min(val_len, MAX_XATTR_VAL_PRINT_LEN), val,
> +            val_len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");
>
>         return 0;
>  }
> @@ -681,8 +685,11 @@ static struct ceph_inode_xattr *__get_xattr(struct c=
eph_inode_info *ci,
>                 else if (c > 0)
>                         p =3D &(*p)->rb_right;
>                 else {
> -                       dout("__get_xattr %s: found %.*s\n", name,
> -                            xattr->val_len, xattr->val);
> +                       int len =3D xattr->val_len;
> +
> +                       dout("__get_xattr %s: found %.*s%s\n", name,
> +                            min(len, MAX_XATTR_VAL_PRINT_LEN), xattr->va=
l,
> +                            len > MAX_XATTR_VAL_PRINT_LEN ? "..." : "");

It looks like len variable is introduced just to save a few characters?
If you make it meaningful, dout would actually be more compact:

    int len =3D min(xattr->val_len, MAX_XATTR_VAL_PRINT_LEN);

    dout("__get_xattr %s: found %.*s%s\n", name, len,
         xattr->val, xattr->val_len > len ? "..." : "");

Thanks,

                Ilya
