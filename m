Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E176FB087
	for <lists+ceph-devel@lfdr.de>; Mon,  8 May 2023 14:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbjEHMrB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 8 May 2023 08:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjEHMrA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 8 May 2023 08:47:00 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7810A19D4B;
        Mon,  8 May 2023 05:46:55 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-965c3f9af2aso635235566b.0;
        Mon, 08 May 2023 05:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683550014; x=1686142014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4CtZd5VLc+pYXhj65DUnH/CQxgllwSSL9bOHAzJMo/o=;
        b=SjX3A19GRrO9j5/6LE5Qtmrdtk4tg/wyhNIyB0kqHs332xn+GQHdto0goycqEJhq6C
         co9HNZi/yVAg+1p7sBESmWx6Iqv/mVc+zlngEDNmH+VRhKOLWr6JhGUJhL/pOcPIRjpS
         CA7STm5jH10upbpK+eFZabTsWLmqFxJVcAx2xmqVDIEpC7CIWFdpe3GJowyxDcAz9xPp
         SF0ieNHsvbMPQeuVDGE10NZG8zvzgLWGggoXCRKL3LDQe6eYALEbEsLMUOtKSvAZ6Ebn
         1VW1EEJ8u3FFM021LqV7AdzuFPqB0GMK1ciXrUdbD0ryGHgXbKEWVD6V6oDPUUENfNi+
         36sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683550014; x=1686142014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4CtZd5VLc+pYXhj65DUnH/CQxgllwSSL9bOHAzJMo/o=;
        b=N785bkIHnP/8vO8qRazh9bAcOfxqL3++3q1n/8NBW8o4OxgoFCSNB+IPCd/y2ECPbm
         qhMZixReA3M9IvjVpdxW8RSoWosSd87m3lPhviarmTCUlwgYR5R/ZVvjsgQGR/GCzNIB
         e1jBzKFaJdDNvPuBeyEIPRSBxXpLkVjoJDM6QqO05VnWqns9aGcayQYehTvoqUFe2tnY
         cM8gpFkQ9QSjjqLemFE8mkGKFTIRiPzLUjVKsri39gqRNeo0nRFjt42+ejuGjj6+iR3R
         hm29LotpExlY+b3WrelO0uoLrWABc3IbS2ebKpy8FBjrRDeda95wG9RY21yfXcAtUIdo
         XCEA==
X-Gm-Message-State: AC+VfDx+b/ptNEy49oMMKxSqYn7Im/7oIoM14sI4EIf1Khq7PXA/tmQ+
        tHbWjXCOGpz0gcO4b/YuODu7bZIf4HSKNk2NE48=
X-Google-Smtp-Source: ACHHUZ6FiUyYBrM6IAk9jO1VkdY3O3ss5wrY66voF/dmm+uVMk3NNXNZmlzcE2gmjP2aTMVw1r1YhCTx5BYegtHJ78U=
X-Received: by 2002:a17:907:980a:b0:968:8b67:4507 with SMTP id
 ji10-20020a170907980a00b009688b674507mr1376171ejc.69.1683550013837; Mon, 08
 May 2023 05:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230504111100.417305-1-xiubli@redhat.com>
In-Reply-To: <20230504111100.417305-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 8 May 2023 14:46:41 +0200
Message-ID: <CAOi1vP_8hUUZBHXLUJP3Xq74LONKq=weFQMV+Es45yV3wH-wTw@mail.gmail.com>
Subject: Re: [PATCH v3] ceph: fix blindly expanding the readahead windows
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, lhenriques@suse.de, mchangir@redhat.com,
        stable@vger.kernel.org, Hu Weiwen <sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 4, 2023 at 1:11=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Blindly expanding the readahead windows will cause unneccessary
> pagecache thrashing and also will introdue the network workload.
> We should disable expanding the windows if the readahead is disabled
> and also shouldn't expand the windows too much.
>
> Expanding forward firstly instead of expanding backward for possible
> sequential reads.
>
> Bound `rreq->len` to the actual file size to restore the previous page
> cache usage.
>
> Cc: stable@vger.kernel.org
> Fixes: 49870056005c ("ceph: convert ceph_readpages to ceph_readahead")
> URL: https://lore.kernel.org/ceph-devel/20230504082510.247-1-sehuww@mail.=
scut.edu.cn
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Cc: Hu Weiwen <sehuww@mail.scut.edu.cn>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - Folded Hu Weiwen's fix and bound `rreq->len` to the actual file size.

Hi Xiubo,

This looks much better!  Just a couple of nits:

>
>
>
>  fs/ceph/addr.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index ca4dc6450887..357d9d28f202 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,32 @@ static void ceph_netfs_expand_readahead(struct netf=
s_io_request *rreq)
>         struct inode *inode =3D rreq->inode;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_file_layout *lo =3D &ci->i_layout;
> +       unsigned long max_pages =3D inode->i_sb->s_bdi->ra_pages;
> +       unsigned long max_len =3D max_pages << PAGE_SHIFT;
> +       loff_t end =3D rreq->start + rreq->len, new_end;
>         u32 blockoff;
>         u64 blockno;
>
> -       /* Expand the start downward */
> -       blockno =3D div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> -       rreq->start =3D blockno * lo->stripe_unit;
> -       rreq->len +=3D blockoff;
> +       /* Readahead is disabled */
> +       if (!max_pages)
> +               return;
>
> -       /* Now, round up the length to the next block */
> -       rreq->len =3D roundup(rreq->len, lo->stripe_unit);
> +       /*
> +        * Try to expand the length forward by rounding  up it to the nex=
t
> +        * block, but do not exceed the file size, unless the original
> +        * request already exceeds it.
> +        */
> +       new_end =3D round_up(end, lo->stripe_unit);
> +       new_end =3D min(new_end, rreq->i_size);

This can be done on single line:

        new_end =3D min(round_up(end, lo->stripe_unit), rreq->i_size);

> +       if (new_end > end && new_end <=3D rreq->start + max_len)
> +               rreq->len =3D new_end - rreq->start;
> +
> +       /* Try to expand the start downward */
> +       blockno =3D div_u64_rem(rreq->start, lo->stripe_unit, &blockoff);
> +       if (rreq->len + blockoff <=3D max_len) {
> +               rreq->start =3D blockno * lo->stripe_unit;

Can this be written as:

                rreq->start -=3D blockoff;

It seems like it would be easier to read and probably cheaper to
compute too.

Thanks,

                Ilya
