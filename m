Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D186F2889
	for <lists+ceph-devel@lfdr.de>; Sun, 30 Apr 2023 13:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjD3LBB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 30 Apr 2023 07:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjD3LA7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 30 Apr 2023 07:00:59 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B6C269E
        for <ceph-devel@vger.kernel.org>; Sun, 30 Apr 2023 04:00:57 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-94eff00bcdaso306616966b.1
        for <ceph-devel@vger.kernel.org>; Sun, 30 Apr 2023 04:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682852455; x=1685444455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=38dUtOiHpRM77jIIzXGr7jnOgvZlKKDjYlwVOT82Ug8=;
        b=RJYtfE0sTucEDa+r7oxniapBUR7CuyiDUlh9m70kPcsiRQI+Z8Yl+j7WKutCGhRsIV
         TtNUjNoOMsJnqPXmE/71oT9yArVTp6383trTKeV5hYFK+iXsicvBKzRx8qGsO2naQ9Yh
         NEvyAPqYvHVkREfBOqq0XE/9nJHtHjVYDxtiUUn7yFiu4klqni5vah2EobeQcJKh+18x
         sKwmMx4dzz/FbWmZtfBuwEH8LzbjPr2jvW+IPu1J7ua7pgiLdcwvBcQtNZisD7R6wfM+
         agISNGM7zLu18lxJYG3OP44BA9wTolTUWDdp3EK+Gu8+7Kqh4fzmObmMdYxAJVyLBPgp
         sL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682852455; x=1685444455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=38dUtOiHpRM77jIIzXGr7jnOgvZlKKDjYlwVOT82Ug8=;
        b=AoyzbKKNiZy7vlokIDvVKGFAOqC6ZHmFuUEHHcanskNimdFtlAN/QJyU7hA7aF7RkI
         HCap4t433jUT/pksk2N8mbvPgWD2qpbv9hhG3W2KSZFlh9OXociSE+V8U6GR5uFPQTgQ
         w40idIta6szj4gUWJwhhRFS7o9jP+MhI4KHiU5tkCIUPQsoVAR4IllPpB+Ii//G7NBIa
         mdwtVzpGj+UHgp33ow9AXXGmrcWUQO4ImG73jPfX2/vlcozKMUT3mGjUFT70Ru3St34i
         VOOgBXmpz4R9apsuatPVKyr32LP3SdcVdVl6UKsLK005iEFhmY5bvjAyozf/aQqxQi67
         TD0g==
X-Gm-Message-State: AC+VfDz2Mo9yELABSJO853k46gbtJ509kg6RNwNjLGM8n2Adzs1MVHCD
        Q+adFXkOqWzNUv9lVlXKCZOAWi+enbmQ8sJ6j+c=
X-Google-Smtp-Source: ACHHUZ5FjxS9ANceuJr2X9/ywZLl5HWROzN1g15YoALnpjG8hsXwg8WQF/c73NRrGGCfRZrK3sZAyurAJGapOW9zMZo=
X-Received: by 2002:a17:907:2ce4:b0:94e:1764:b0b5 with SMTP id
 hz4-20020a1709072ce400b0094e1764b0b5mr11285484ejc.69.1682852455422; Sun, 30
 Apr 2023 04:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230323070105.201578-1-xiubli@redhat.com>
In-Reply-To: <20230323070105.201578-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 30 Apr 2023 13:00:43 +0200
Message-ID: <CAOi1vP_cX3U-Xs72-fXDrxT+e_hEkUi6xtZc_3Cm7ko1ZT_BLQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix blindly expanding the readahead windows
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, lhenriques@suse.de
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

On Thu, Mar 23, 2023 at 8:01=E2=80=AFAM <xiubli@redhat.com> wrote:
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
> URL: https://www.spinics.net/lists/ceph-users/msg76183.html
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/addr.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index ca4dc6450887..01d997f6c66c 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -188,16 +188,27 @@ static void ceph_netfs_expand_readahead(struct netf=
s_io_request *rreq)
>         struct inode *inode =3D rreq->inode;
>         struct ceph_inode_info *ci =3D ceph_inode(inode);
>         struct ceph_file_layout *lo =3D &ci->i_layout;
> +       unsigned long max_pages =3D inode->i_sb->s_bdi->ra_pages;
> +       unsigned long max_len =3D max_pages << PAGE_SHIFT;
> +       unsigned long len;
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
> +
> +       /* Expand the length forward by rounding up it to the next block =
*/
> +       len =3D roundup(rreq->len, lo->stripe_unit);
> +       if (len <=3D max_len)
> +               rreq->len =3D len;

Hi Xiubo,

This change makes it possible for the request to be expanded into the
next block (i.e. it's not rounded _up_ to the next block as the comment
says) because rreq->len is no longer guaranteed to be based off of the
start of the block here.  Previously that was ensured by the preceding
downward expansion.

Thanks,

                Ilya
